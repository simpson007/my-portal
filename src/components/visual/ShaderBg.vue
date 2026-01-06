<template>
  <canvas
    ref="canvasRef"
    class="fixed inset-0 w-full h-full -z-10 pointer-events-none"
  />
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'

const canvasRef = ref<HTMLCanvasElement>()
let animationId: number
let gl: WebGLRenderingContext | null = null

// 顶点着色器
const vertexShaderSource = `
  attribute vec2 a_position;
  void main() {
    gl_Position = vec4(a_position, 0.0, 1.0);
  }
`

// 片段着色器 - 深海极光效果
const fragmentShaderSource = `
  precision highp float;

  uniform vec2 u_resolution;
  uniform float u_time;
  uniform vec2 u_mouse;

  // 简化的噪声函数
  float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
  }

  float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    f = f * f * (3.0 - 2.0 * f);

    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));

    return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
  }

  // 分形布朗运动
  float fbm(vec2 p) {
    float value = 0.0;
    float amplitude = 0.5;
    float frequency = 1.0;

    for (int i = 0; i < 6; i++) {
      value += amplitude * noise(p * frequency);
      amplitude *= 0.5;
      frequency *= 2.0;
    }

    return value;
  }

  void main() {
    vec2 uv = gl_FragCoord.xy / u_resolution.xy;
    vec2 p = uv * 3.0;

    // 时间流动
    float t = u_time * 0.15;

    // 多层噪声叠加
    float n1 = fbm(p + vec2(t * 0.3, t * 0.2));
    float n2 = fbm(p * 2.0 - vec2(t * 0.2, t * 0.3) + n1);
    float n3 = fbm(p * 0.5 + vec2(n2 * 0.5, t * 0.1));

    // 鼠标交互影响
    vec2 mouseNorm = u_mouse / u_resolution;
    float mouseDist = length(uv - mouseNorm);
    float mouseInfluence = smoothstep(0.5, 0.0, mouseDist) * 0.3;

    // 颜色混合 - 深海极光色调
    vec3 color1 = vec3(0.0, 0.05, 0.1);   // 深蓝黑
    vec3 color2 = vec3(0.0, 0.4, 0.35);   // 青绿
    vec3 color3 = vec3(0.0, 1.0, 0.53);   // 亮绿 (accent)
    vec3 color4 = vec3(0.1, 0.2, 0.3);    // 深青

    float blend = n1 * 0.5 + n2 * 0.3 + n3 * 0.2 + mouseInfluence;

    vec3 finalColor = mix(color1, color2, smoothstep(0.2, 0.5, blend));
    finalColor = mix(finalColor, color3, smoothstep(0.6, 0.9, blend) * 0.3);
    finalColor = mix(finalColor, color4, smoothstep(0.3, 0.6, n3));

    // 添加微弱的扫描线效果
    float scanline = sin(uv.y * u_resolution.y * 0.5) * 0.02;
    finalColor += scanline;

    // 暗角效果
    float vignette = 1.0 - smoothstep(0.3, 1.2, length(uv - 0.5) * 1.5);
    finalColor *= vignette;

    // 整体亮度调整
    finalColor *= 0.8;

    gl_FragColor = vec4(finalColor, 1.0);
  }
`

const createShader = (gl: WebGLRenderingContext, type: number, source: string): WebGLShader | null => {
  const shader = gl.createShader(type)
  if (!shader) return null

  gl.shaderSource(shader, source)
  gl.compileShader(shader)

  if (!gl.getShaderParameter(shader, gl.COMPILE_STATUS)) {
    console.error('Shader compile error:', gl.getShaderInfoLog(shader))
    gl.deleteShader(shader)
    return null
  }

  return shader
}

const createProgram = (gl: WebGLRenderingContext, vertexShader: WebGLShader, fragmentShader: WebGLShader): WebGLProgram | null => {
  const program = gl.createProgram()
  if (!program) return null

  gl.attachShader(program, vertexShader)
  gl.attachShader(program, fragmentShader)
  gl.linkProgram(program)

  if (!gl.getProgramParameter(program, gl.LINK_STATUS)) {
    console.error('Program link error:', gl.getProgramInfoLog(program))
    gl.deleteProgram(program)
    return null
  }

  return program
}

let mouseX = 0
let mouseY = 0

const handleMouseMove = (e: MouseEvent) => {
  mouseX = e.clientX
  mouseY = window.innerHeight - e.clientY // WebGL Y轴翻转
}

onMounted(() => {
  const canvas = canvasRef.value
  if (!canvas) return

  gl = canvas.getContext('webgl', { alpha: false, antialias: false })
  if (!gl) {
    console.error('WebGL not supported')
    return
  }

  // 创建着色器
  const vertexShader = createShader(gl, gl.VERTEX_SHADER, vertexShaderSource)
  const fragmentShader = createShader(gl, gl.FRAGMENT_SHADER, fragmentShaderSource)
  if (!vertexShader || !fragmentShader) return

  const program = createProgram(gl, vertexShader, fragmentShader)
  if (!program) return

  gl.useProgram(program)

  // 创建全屏四边形
  const positionBuffer = gl.createBuffer()
  gl.bindBuffer(gl.ARRAY_BUFFER, positionBuffer)
  gl.bufferData(gl.ARRAY_BUFFER, new Float32Array([
    -1, -1,
    1, -1,
    -1, 1,
    -1, 1,
    1, -1,
    1, 1
  ]), gl.STATIC_DRAW)

  const positionLocation = gl.getAttribLocation(program, 'a_position')
  gl.enableVertexAttribArray(positionLocation)
  gl.vertexAttribPointer(positionLocation, 2, gl.FLOAT, false, 0, 0)

  // 获取 uniform 位置
  const resolutionLocation = gl.getUniformLocation(program, 'u_resolution')
  const timeLocation = gl.getUniformLocation(program, 'u_time')
  const mouseLocation = gl.getUniformLocation(program, 'u_mouse')

  // 设置画布大小
  const resize = () => {
    if (!canvas || !gl) return
    const dpr = Math.min(window.devicePixelRatio, 2)
    canvas.width = window.innerWidth * dpr
    canvas.height = window.innerHeight * dpr
    gl.viewport(0, 0, canvas.width, canvas.height)
  }

  resize()
  window.addEventListener('resize', resize)
  window.addEventListener('mousemove', handleMouseMove)

  // 渲染循环
  const startTime = performance.now()

  const render = () => {
    if (!gl) return

    const time = (performance.now() - startTime) / 1000

    gl.uniform2f(resolutionLocation, canvas.width, canvas.height)
    gl.uniform1f(timeLocation, time)
    gl.uniform2f(mouseLocation, mouseX * window.devicePixelRatio, mouseY * window.devicePixelRatio)

    gl.drawArrays(gl.TRIANGLES, 0, 6)

    animationId = requestAnimationFrame(render)
  }

  render()
})

onUnmounted(() => {
  if (animationId) {
    cancelAnimationFrame(animationId)
  }
  window.removeEventListener('mousemove', handleMouseMove)
})
</script>