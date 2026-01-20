<template>
  <div
    ref="cardRef"
    class="bento-card group relative overflow-hidden rounded-3xl bg-white/5 border border-white/10 backdrop-blur-md transition-all duration-300 hover:border-white/20"
    :class="[props.class, sizeClasses[props.size]]"
    @mousemove="handleMouseMove"
    @mouseleave="handleMouseLeave"
    :style="cardStyle"
  >
    <!-- 噪点纹理层 -->
    <div class="absolute inset-0 opacity-20 bg-noise pointer-events-none"></div>

    <!-- 内容层 -->
    <div class="relative z-10 h-full p-6 flex flex-col justify-between">
      <slot />
    </div>

    <!-- 光效层 -->
    <div
      class="pointer-events-none absolute -inset-px transition duration-300 opacity-0 group-hover:opacity-100"
      :style="{
        background: `radial-gradient(600px circle at ${mouseX}px ${mouseY}px, rgba(255,255,255,0.1), transparent 40%)`
      }"
    />

    <!-- 光晕层 -->
    <div
      v-if="props.glow"
      class="absolute -inset-0.5 bg-gradient-to-r opacity-75 blur-sm transition duration-500 group-hover:opacity-100"
      :class="props.glowColor"
    />
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { useMouseInElement } from '@vueuse/core'

interface Props {
  size?: 'small' | 'medium' | 'large'
  class?: string
  glow?: boolean
  glowColor?: string
  tilt?: boolean
  tiltMaxX?: number
  tiltMaxY?: number
}

const props = withDefaults(defineProps<Props>(), {
  size: 'medium',
  glow: false,
  glowColor: 'from-accent/20 to-accent-dim/20',
  tilt: true,
  tiltMaxX: 10,
  tiltMaxY: 10
})

const cardRef = ref<HTMLElement>()
const { elementX: mouseX, elementY: mouseY, isOutside } = useMouseInElement(cardRef)

const tiltX = ref(0)
const tiltY = ref(0)

const sizeClasses = {
  small: 'min-h-[150px]',
  medium: 'min-h-[200px]',
  large: 'min-h-[300px]'
}

const cardStyle = computed(() => {
  if (!props.tilt) return {}

  return {
    transform: `perspective(1000px) rotateX(${tiltX.value}deg) rotateY(${tiltY.value}deg)`,
    transformStyle: 'preserve-3d' as const,
    transition: isOutside.value ? 'transform 0.3s ease-out' : 'none'
  }
})

const handleMouseMove = (e: MouseEvent) => {
  if (!props.tilt || !cardRef.value) return

  const rect = cardRef.value.getBoundingClientRect()
  const centerX = rect.width / 2
  const centerY = rect.height / 2

  const x = e.clientX - rect.left
  const y = e.clientY - rect.top

  // 计算倾斜角度
  tiltY.value = ((x - centerX) / centerX) * props.tiltMaxX
  tiltX.value = -((y - centerY) / centerY) * props.tiltMaxY
}

const handleMouseLeave = () => {
  tiltX.value = 0
  tiltY.value = 0
}
</script>

<style scoped>
.bento-card {
  transform-origin: center center;
  will-change: transform;
}

.bento-card::before {
  content: '';
  position: absolute;
  inset: 0;
  border-radius: inherit;
  padding: 1px;
  background: linear-gradient(
    135deg,
    rgba(255, 255, 255, 0.1),
    rgba(255, 255, 255, 0.05),
    rgba(255, 255, 255, 0.1)
  );
  -webkit-mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
  -webkit-mask-composite: exclude;
  mask-composite: exclude;
  pointer-events: none;
}
</style>