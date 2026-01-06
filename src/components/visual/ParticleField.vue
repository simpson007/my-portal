<template>
  <div ref="containerRef" class="fixed inset-0 -z-10" />
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'
import * as THREE from 'three'

const containerRef = ref<HTMLDivElement>()

let scene: THREE.Scene
let camera: THREE.PerspectiveCamera
let renderer: THREE.WebGLRenderer
let particles: THREE.Points
let animationId: number
let mouseX = 0
let mouseY = 0
let targetMouseX = 0
let targetMouseY = 0

// 粒子数量
const PARTICLE_COUNT = 3000
const FIELD_SIZE = 50

// 顶点着色器
const vertexShader = `
  uniform float uTime;
  uniform vec2 uMouse;
  uniform float uPixelRatio;

  attribute float aScale;
  attribute float aRandomness;

  varying vec3 vColor;

  // Simplex noise function
  vec3 mod289(vec3 x) { return x - floor(x * (1.0 / 289.0)) * 289.0; }
  vec4 mod289(vec4 x) { return x - floor(x * (1.0 / 289.0)) * 289.0; }
  vec4 permute(vec4 x) { return mod289(((x*34.0)+1.0)*x); }
  vec4 taylorInvSqrt(vec4 r) { return 1.79284291400159 - 0.85373472095314 * r; }

  float snoise(vec3 v) {
    const vec2 C = vec2(1.0/6.0, 1.0/3.0);
    const vec4 D = vec4(0.0, 0.5, 1.0, 2.0);

    vec3 i  = floor(v + dot(v, C.yyy));
    vec3 x0 = v - i + dot(i, C.xxx);

    vec3 g = step(x0.yzx, x0.xyz);
    vec3 l = 1.0 - g;
    vec3 i1 = min(g.xyz, l.zxy);
    vec3 i2 = max(g.xyz, l.zxy);

    vec3 x1 = x0 - i1 + C.xxx;
    vec3 x2 = x0 - i2 + C.yyy;
    vec3 x3 = x0 - D.yyy;

    i = mod289(i);
    vec4 p = permute(permute(permute(
      i.z + vec4(0.0, i1.z, i2.z, 1.0))
      + i.y + vec4(0.0, i1.y, i2.y, 1.0))
      + i.x + vec4(0.0, i1.x, i2.x, 1.0));

    float n_ = 0.142857142857;
    vec3 ns = n_ * D.wyz - D.xzx;

    vec4 j = p - 49.0 * floor(p * ns.z * ns.z);

    vec4 x_ = floor(j * ns.z);
    vec4 y_ = floor(j - 7.0 * x_);

    vec4 x = x_ *ns.x + ns.yyyy;
    vec4 y = y_ *ns.x + ns.yyyy;
    vec4 h = 1.0 - abs(x) - abs(y);

    vec4 b0 = vec4(x.xy, y.xy);
    vec4 b1 = vec4(x.zw, y.zw);

    vec4 s0 = floor(b0)*2.0 + 1.0;
    vec4 s1 = floor(b1)*2.0 + 1.0;
    vec4 sh = -step(h, vec4(0.0));

    vec4 a0 = b0.xzyw + s0.xzyw*sh.xxyy;
    vec4 a1 = b1.xzyw + s1.xzyw*sh.zzww;

    vec3 p0 = vec3(a0.xy, h.x);
    vec3 p1 = vec3(a0.zw, h.y);
    vec3 p2 = vec3(a1.xy, h.z);
    vec3 p3 = vec3(a1.zw, h.w);

    vec4 norm = taylorInvSqrt(vec4(dot(p0,p0), dot(p1,p1), dot(p2,p2), dot(p3,p3)));
    p0 *= norm.x;
    p1 *= norm.y;
    p2 *= norm.z;
    p3 *= norm.w;

    vec4 m = max(0.6 - vec4(dot(x0,x0), dot(x1,x1), dot(x2,x2), dot(x3,x3)), 0.0);
    m = m * m;
    return 42.0 * dot(m*m, vec4(dot(p0,x0), dot(p1,x1), dot(p2,x2), dot(p3,x3)));
  }

  void main() {
    vec3 pos = position;

    // Flow field displacement
    float noiseFreq = 0.08;
    float noiseAmp = 2.5;
    float time = uTime * 0.15;

    vec3 noisePos = pos * noiseFreq + time;
    float noiseX = snoise(noisePos);
    float noiseY = snoise(noisePos + 100.0);
    float noiseZ = snoise(noisePos + 200.0);

    pos.x += noiseX * noiseAmp * aRandomness;
    pos.y += noiseY * noiseAmp * aRandomness;
    pos.z += noiseZ * noiseAmp * 0.5;

    // Mouse interaction - repel particles
    vec2 mouseWorld = uMouse * 30.0;
    vec2 toMouse = pos.xy - mouseWorld;
    float distToMouse = length(toMouse);
    float repelRadius = 8.0;
    float repelStrength = 3.0;

    if (distToMouse < repelRadius) {
      float repelFactor = (1.0 - distToMouse / repelRadius) * repelStrength;
      pos.xy += normalize(toMouse) * repelFactor;
    }

    vec4 mvPosition = modelViewMatrix * vec4(pos, 1.0);
    gl_Position = projectionMatrix * mvPosition;

    // Size attenuation
    float sizeAtten = (1.0 / -mvPosition.z) * 300.0;
    gl_PointSize = aScale * sizeAtten * uPixelRatio;
    gl_PointSize = max(gl_PointSize, 1.0);

    // Color based on position and noise
    float colorMix = (noiseX + 1.0) * 0.5;
    vec3 color1 = vec3(0.059, 0.090, 0.165); // Deep teal #0f172a
    vec3 color2 = vec3(0.063, 0.725, 0.506); // Neon green #10b981
    vec3 color3 = vec3(0.0, 1.0, 0.533);     // Bright accent

    vColor = mix(color1, color2, colorMix);
    vColor = mix(vColor, color3, smoothstep(0.7, 1.0, colorMix) * 0.5);

    // Fade based on distance
    float depth = smoothstep(40.0, 10.0, -mvPosition.z);
    vColor *= depth;
  }
`

// 片段着色器
const fragmentShader = `
  varying vec3 vColor;

  void main() {
    // Circular particle with soft edge
    vec2 center = gl_PointCoord - 0.5;
    float dist = length(center);
    float alpha = 1.0 - smoothstep(0.3, 0.5, dist);

    // Add glow
    float glow = exp(-dist * 3.0) * 0.5;

    vec3 finalColor = vColor + vColor * glow;

    gl_FragColor = vec4(finalColor, alpha * 0.8);
  }
`

const init = () => {
  if (!containerRef.value) return

  const width = window.innerWidth
  const height = window.innerHeight

  // Scene
  scene = new THREE.Scene()
  scene.background = new THREE.Color(0x0a0a0f)

  // Camera
  camera = new THREE.PerspectiveCamera(60, width / height, 0.1, 100)
  camera.position.z = 30

  // Renderer
  renderer = new THREE.WebGLRenderer({
    antialias: true,
    alpha: true
  })
  renderer.setSize(width, height)
  renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2))
  containerRef.value.appendChild(renderer.domElement)

  // Create particles
  createParticles()

  // Add ambient fog
  scene.fog = new THREE.FogExp2(0x0a0a0f, 0.02)
}

const createParticles = () => {
  const geometry = new THREE.BufferGeometry()

  const positions = new Float32Array(PARTICLE_COUNT * 3)
  const scales = new Float32Array(PARTICLE_COUNT)
  const randomness = new Float32Array(PARTICLE_COUNT)

  for (let i = 0; i < PARTICLE_COUNT; i++) {
    const i3 = i * 3

    // Distribute particles in a field
    positions[i3] = (Math.random() - 0.5) * FIELD_SIZE
    positions[i3 + 1] = (Math.random() - 0.5) * FIELD_SIZE
    positions[i3 + 2] = (Math.random() - 0.5) * FIELD_SIZE * 0.5

    scales[i] = Math.random() * 2 + 0.5
    randomness[i] = Math.random() * 0.5 + 0.5
  }

  geometry.setAttribute('position', new THREE.BufferAttribute(positions, 3))
  geometry.setAttribute('aScale', new THREE.BufferAttribute(scales, 1))
  geometry.setAttribute('aRandomness', new THREE.BufferAttribute(randomness, 1))

  const material = new THREE.ShaderMaterial({
    vertexShader,
    fragmentShader,
    uniforms: {
      uTime: { value: 0 },
      uMouse: { value: new THREE.Vector2(0, 0) },
      uPixelRatio: { value: Math.min(window.devicePixelRatio, 2) }
    },
    transparent: true,
    depthWrite: false,
    blending: THREE.AdditiveBlending
  })

  particles = new THREE.Points(geometry, material)
  scene.add(particles)
}

const animate = () => {
  animationId = requestAnimationFrame(animate)

  // Smooth mouse movement
  mouseX += (targetMouseX - mouseX) * 0.05
  mouseY += (targetMouseY - mouseY) * 0.05

  // Update uniforms
  const material = particles.material as THREE.ShaderMaterial
  material.uniforms.uTime.value = performance.now() / 1000
  material.uniforms.uMouse.value.set(mouseX, mouseY)

  // Subtle camera movement
  camera.position.x = mouseX * 2
  camera.position.y = mouseY * 2
  camera.lookAt(0, 0, 0)

  renderer.render(scene, camera)
}

const handleMouseMove = (e: MouseEvent) => {
  targetMouseX = (e.clientX / window.innerWidth) * 2 - 1
  targetMouseY = -(e.clientY / window.innerHeight) * 2 + 1
}

const handleResize = () => {
  if (!containerRef.value) return

  const width = window.innerWidth
  const height = window.innerHeight

  camera.aspect = width / height
  camera.updateProjectionMatrix()

  renderer.setSize(width, height)
  renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2))

  const material = particles.material as THREE.ShaderMaterial
  material.uniforms.uPixelRatio.value = Math.min(window.devicePixelRatio, 2)
}

onMounted(() => {
  init()
  animate()

  window.addEventListener('mousemove', handleMouseMove)
  window.addEventListener('resize', handleResize)
})

onUnmounted(() => {
  cancelAnimationFrame(animationId)
  window.removeEventListener('mousemove', handleMouseMove)
  window.removeEventListener('resize', handleResize)

  if (renderer) {
    renderer.dispose()
  }
})
</script>