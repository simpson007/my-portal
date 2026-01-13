<template>
  <div ref="containerRef" class="fixed inset-0 -z-10 pointer-events-none" />
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'
import * as THREE from 'three'

const containerRef = ref<HTMLDivElement | null>(null)

let renderer: THREE.WebGLRenderer | null = null
let scene: THREE.Scene | null = null
let camera: THREE.Camera | null = null
let material: THREE.ShaderMaterial | null = null
let mesh: THREE.Mesh | null = null
let animationId = 0

const mouse = new THREE.Vector2(0, 0)
const targetMouse = new THREE.Vector2(0, 0)

const vertexShader = `
  varying vec2 vUv;

  void main() {
    vUv = uv;
    gl_Position = vec4(position, 1.0);
  }
`

const fragmentShader = `
  precision highp float;

  uniform vec2 uResolution;
  uniform float uTime;
  uniform vec2 uMouse;

  varying vec2 vUv;

  // Improved hash function for smoother noise
  vec3 hash3(vec2 p) {
    vec3 q = vec3(
      dot(p, vec2(127.1, 311.7)),
      dot(p, vec2(269.5, 183.3)),
      dot(p, vec2(419.2, 371.9))
    );
    return fract(sin(q) * 43758.5453);
  }

  float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
  }

  // Smooth value noise
  float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    f = f * f * f * (f * (f * 6.0 - 15.0) + 10.0); // quintic interpolation

    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));

    return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
  }

  // Fractal Brownian Motion with domain warping
  float fbm(vec2 p) {
    float value = 0.0;
    float amplitude = 0.5;
    float frequency = 1.0;
    mat2 rot = mat2(cos(0.5), sin(0.5), -sin(0.5), cos(0.5));

    for (int i = 0; i < 6; i++) {
      value += amplitude * noise(p * frequency);
      p = rot * p;
      amplitude *= 0.5;
      frequency *= 2.0;
    }

    return value;
  }

  // Domain warped FBM for cloud-like patterns
  float warpedFbm(vec2 p, float time) {
    vec2 q = vec2(
      fbm(p + vec2(0.0, 0.0)),
      fbm(p + vec2(5.2, 1.3))
    );

    vec2 r = vec2(
      fbm(p + 4.0 * q + vec2(1.7, 9.2) + 0.15 * time),
      fbm(p + 4.0 * q + vec2(8.3, 2.8) + 0.126 * time)
    );

    return fbm(p + 4.0 * r);
  }

  // Aurora-like wave pattern
  float aurora(vec2 uv, float time) {
    float wave = 0.0;
    for (float i = 1.0; i < 4.0; i++) {
      wave += sin(uv.x * i * 2.0 + time * 0.3 + sin(uv.y * 3.0 + time * 0.2) * 2.0) / i;
    }
    return wave * 0.5 + 0.5;
  }

  void main() {
    vec2 uv = vUv;
    vec2 aspect = vec2(uResolution.x / uResolution.y, 1.0);
    vec2 centered = (uv - 0.5) * aspect;

    vec2 mouseNorm = (uMouse / uResolution) * 2.0 - 1.0;
    mouseNorm.x *= aspect.x;

    float time = uTime * 0.025;

    // Parallax distortion from mouse
    vec2 parallax = mouseNorm * 0.06 * (1.0 - length(centered) * 0.5);
    vec2 flow = centered + parallax;

    // Slow flowing motion
    flow += vec2(
      sin(time * 1.2 + centered.y * 1.2) * 0.06,
      cos(time * 0.8 + centered.x * 1.4) * 0.04
    );

    // Multiple noise layers for depth
    float cloud1 = warpedFbm(flow * 0.8, time);
    float cloud2 = warpedFbm(flow * 1.2 + vec2(10.0), time * 0.7);
    float cloud3 = fbm(flow * 2.0 - time * 0.3);

    // Aurora effect in upper portion
    float auroraEffect = aurora(flow, time) * smoothstep(0.0, 0.4, centered.y + 0.2);

    // Color palette - soft pastels
    vec3 pastelBlue = vec3(0.878, 0.949, 0.996);   // #e0f2fe - sky blue
    vec3 softPurple = vec3(0.914, 0.835, 1.0);     // #e9d5ff - lavender
    vec3 mintHint = vec3(0.820, 0.980, 0.898);     // #d1fae5 - mint
    vec3 warmWhite = vec3(0.996, 0.988, 0.976);    // warm highlight
    vec3 softPink = vec3(0.992, 0.906, 0.937);     // subtle pink accent

    // Blend colors based on noise
    float mixA = smoothstep(0.2, 0.8, cloud1);
    float mixB = smoothstep(0.25, 0.75, cloud2);
    float mixC = smoothstep(0.3, 0.7, cloud3);

    vec3 color = mix(pastelBlue, softPurple, mixA);
    color = mix(color, mintHint, mixB * 0.6);
    color = mix(color, softPink, auroraEffect * 0.3);

    // Add subtle highlights
    color = mix(color, warmWhite, mixC * 0.15);

    // Soft gradient from bottom to top
    float verticalGrad = smoothstep(-0.5, 0.5, centered.y);
    color = mix(color * 0.98, color, verticalGrad);

    // Very subtle vignette
    float vignette = smoothstep(1.5, 0.3, length(centered));
    color *= vignette * 0.15 + 0.85;

    // Slight brightness boost for ethereal feel
    color = pow(color, vec3(0.95));

    gl_FragColor = vec4(color, 1.0);
  }
`

const init = () => {
  if (!containerRef.value) return

  scene = new THREE.Scene()
  camera = new THREE.Camera()
  camera.position.z = 1

  renderer = new THREE.WebGLRenderer({ antialias: true, alpha: false })
  renderer.setClearColor(0xffffff, 1)
  renderer.outputColorSpace = THREE.SRGBColorSpace
  renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2))
  renderer.setSize(window.innerWidth, window.innerHeight)
  renderer.domElement.style.width = '100%'
  renderer.domElement.style.height = '100%'
  renderer.domElement.style.display = 'block'

  containerRef.value.appendChild(renderer.domElement)

  const dpr = Math.min(window.devicePixelRatio, 2)
  const centerX = window.innerWidth * dpr * 0.5
  const centerY = window.innerHeight * dpr * 0.5
  mouse.set(centerX, centerY)
  targetMouse.set(centerX, centerY)

  const geometry = new THREE.PlaneGeometry(2, 2)
  material = new THREE.ShaderMaterial({
    vertexShader,
    fragmentShader,
    uniforms: {
      uTime: { value: 0 },
      uResolution: { value: new THREE.Vector2(window.innerWidth, window.innerHeight) },
      uMouse: { value: new THREE.Vector2(0, 0) }
    }
  })

  mesh = new THREE.Mesh(geometry, material)
  mesh.frustumCulled = false
  scene.add(mesh)
}

const handleResize = () => {
  if (!renderer || !material) return
  const width = window.innerWidth
  const height = window.innerHeight
  const dpr = Math.min(window.devicePixelRatio, 2)

  renderer.setPixelRatio(dpr)
  renderer.setSize(width, height)
  material.uniforms.uResolution.value.set(width * dpr, height * dpr)
  targetMouse.set(width * dpr * 0.5, height * dpr * 0.5)
}

const handleMouseMove = (event: MouseEvent) => {
  const dpr = Math.min(window.devicePixelRatio, 2)
  targetMouse.set(event.clientX * dpr, (window.innerHeight - event.clientY) * dpr)
}

const animate = () => {
  if (!renderer || !scene || !camera || !material) return

  mouse.lerp(targetMouse, 0.06)
  material.uniforms.uMouse.value.copy(mouse)
  material.uniforms.uTime.value = performance.now() / 1000

  renderer.render(scene, camera)
  animationId = requestAnimationFrame(animate)
}

onMounted(() => {
  init()
  handleResize()
  animate()

  window.addEventListener('resize', handleResize)
  window.addEventListener('mousemove', handleMouseMove)
})

onUnmounted(() => {
  cancelAnimationFrame(animationId)
  window.removeEventListener('resize', handleResize)
  window.removeEventListener('mousemove', handleMouseMove)

  if (renderer) {
    renderer.dispose()
  }
  if (mesh) {
    mesh.geometry.dispose()
  }
  if (material) {
    material.dispose()
  }
})
</script>
