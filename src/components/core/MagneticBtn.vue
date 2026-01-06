<template>
  <button
    ref="buttonRef"
    class="magnetic-btn relative inline-flex items-center justify-center px-6 py-3 rounded-full font-medium transition-all duration-300"
    :class="[
      props.variant === 'primary' ? 'bg-accent text-dark hover:bg-accent-dim' : '',
      props.variant === 'secondary' ? 'bg-white/10 text-white hover:bg-white/20' : '',
      props.variant === 'ghost' ? 'bg-transparent text-white hover:bg-white/10' : '',
      props.class
    ]"
    @mousemove="handleMouseMove"
    @mouseleave="handleMouseLeave"
    :style="buttonStyle"
  >
    <span class="relative z-10">
      <slot />
    </span>

    <!-- 磁性效果层 -->
    <span
      v-if="props.magnetic"
      class="absolute inset-0 rounded-full pointer-events-none"
      :style="magneticStyle"
    />

    <!-- 涟漪效果 -->
    <span
      v-if="ripple.show"
      class="absolute rounded-full bg-white/30 pointer-events-none animate-ping"
      :style="rippleStyle"
    />
  </button>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { useMouseInElement } from '@vueuse/core'

interface Props {
  variant?: 'primary' | 'secondary' | 'ghost'
  class?: string
  magnetic?: boolean
  magneticStrength?: number
}

const props = withDefaults(defineProps<Props>(), {
  variant: 'primary',
  magnetic: true,
  magneticStrength: 0.3
})

const buttonRef = ref<HTMLElement>()
const { elementX: mouseX, elementY: mouseY, isOutside } = useMouseInElement(buttonRef)

const translateX = ref(0)
const translateY = ref(0)
const ripple = ref({ show: false, x: 0, y: 0 })

const buttonStyle = computed(() => {
  if (!props.magnetic) return {}

  return {
    transform: `translate3d(${translateX.value}px, ${translateY.value}px, 0)`,
    transition: isOutside.value ? 'transform 0.3s ease-out' : 'transform 0.1s ease-out'
  }
})

const magneticStyle = computed(() => ({
  transform: `translate3d(${-translateX.value * 0.5}px, ${-translateY.value * 0.5}px, 0)`,
  background: `radial-gradient(circle at ${mouseX.value}px ${mouseY.value}px, rgba(255,255,255,0.1), transparent 50%)`
}))

const rippleStyle = computed(() => ({
  left: `${ripple.value.x}px`,
  top: `${ripple.value.y}px`,
  width: '20px',
  height: '20px',
  marginLeft: '-10px',
  marginTop: '-10px'
}))

const handleMouseMove = (e: MouseEvent) => {
  if (!props.magnetic || !buttonRef.value) return

  const rect = buttonRef.value.getBoundingClientRect()
  const centerX = rect.left + rect.width / 2
  const centerY = rect.top + rect.height / 2

  const distanceX = e.clientX - centerX
  const distanceY = e.clientY - centerY

  // 计算磁性吸附的距离
  const distance = Math.sqrt(distanceX * distanceX + distanceY * distanceY)
  const maxDistance = Math.max(rect.width, rect.height)

  if (distance < maxDistance) {
    const strength = (1 - distance / maxDistance) * props.magneticStrength
    translateX.value = distanceX * strength
    translateY.value = distanceY * strength
  }
}

const handleMouseLeave = () => {
  translateX.value = 0
  translateY.value = 0
}

const showRipple = (e: MouseEvent) => {
  if (!buttonRef.value) return

  const rect = buttonRef.value.getBoundingClientRect()
  ripple.value = {
    show: true,
    x: e.clientX - rect.left,
    y: e.clientY - rect.top
  }

  setTimeout(() => {
    ripple.value.show = false
  }, 600)
}

defineExpose({ showRipple })
</script>

<style scoped>
.magnetic-btn {
  will-change: transform;
  backface-visibility: hidden;
  -webkit-font-smoothing: antialiased;
}

.magnetic-btn::before {
  content: '';
  position: absolute;
  inset: -1px;
  border-radius: inherit;
  background: linear-gradient(135deg, rgba(255, 255, 255, 0.1), transparent);
  opacity: 0;
  transition: opacity 0.3s;
  pointer-events: none;
}

.magnetic-btn:hover::before {
  opacity: 1;
}
</style>