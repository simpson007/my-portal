<template>
  <div class="cursor-wrapper" :class="{ 'is-hovering': isHovering, 'is-clicking': isClicking }">
    <!-- Outer ring -->
    <div
      ref="cursorRingRef"
      class="cursor-ring"
      :style="{ transform: `translate(${ringX}px, ${ringY}px)` }"
    />
    <!-- Inner dot -->
    <div
      ref="cursorDotRef"
      class="cursor-dot"
      :style="{ transform: `translate(${dotX}px, ${dotY}px)` }"
    />
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'

const dotX = ref(0)
const dotY = ref(0)
const ringX = ref(0)
const ringY = ref(0)
const isHovering = ref(false)
const isClicking = ref(false)

let targetX = 0
let targetY = 0
let animationId: number

const lerp = (start: number, end: number, factor: number) => {
  return start + (end - start) * factor
}

const animate = () => {
  // Dot follows cursor directly
  dotX.value = lerp(dotX.value, targetX, 0.35)
  dotY.value = lerp(dotY.value, targetY, 0.35)

  // Ring follows with more delay
  ringX.value = lerp(ringX.value, targetX, 0.15)
  ringY.value = lerp(ringY.value, targetY, 0.15)

  animationId = requestAnimationFrame(animate)
}

const handleMouseMove = (e: MouseEvent) => {
  targetX = e.clientX
  targetY = e.clientY
}

const handleMouseEnter = (e: Event) => {
  const target = e.target as HTMLElement
  if (
    target.tagName === 'A' ||
    target.tagName === 'BUTTON' ||
    target.closest('a') ||
    target.closest('button') ||
    target.classList.contains('hoverable') ||
    target.closest('.hoverable')
  ) {
    isHovering.value = true
  }
}

const handleMouseLeave = () => {
  isHovering.value = false
}

const handleMouseDown = () => {
  isClicking.value = true
}

const handleMouseUp = () => {
  isClicking.value = false
}

onMounted(() => {
  animate()

  document.addEventListener('mousemove', handleMouseMove)
  document.addEventListener('mouseover', handleMouseEnter)
  document.addEventListener('mouseout', handleMouseLeave)
  document.addEventListener('mousedown', handleMouseDown)
  document.addEventListener('mouseup', handleMouseUp)

  // Hide default cursor
  document.body.style.cursor = 'none'
})

onUnmounted(() => {
  cancelAnimationFrame(animationId)

  document.removeEventListener('mousemove', handleMouseMove)
  document.removeEventListener('mouseover', handleMouseEnter)
  document.removeEventListener('mouseout', handleMouseLeave)
  document.removeEventListener('mousedown', handleMouseDown)
  document.removeEventListener('mouseup', handleMouseUp)

  document.body.style.cursor = 'auto'
})
</script>

<style scoped>
.cursor-wrapper {
  pointer-events: none;
  position: fixed;
  top: 0;
  left: 0;
  z-index: 9999;
  mix-blend-mode: difference;
}

.cursor-ring {
  position: fixed;
  top: -24px;
  left: -24px;
  width: 48px;
  height: 48px;
  border: 1.5px solid rgba(16, 185, 129, 0.8);
  border-radius: 50%;
  transition: width 0.3s ease, height 0.3s ease, top 0.3s ease, left 0.3s ease,
    border-color 0.3s ease, background-color 0.3s ease;
  will-change: transform;
}

.cursor-dot {
  position: fixed;
  top: -4px;
  left: -4px;
  width: 8px;
  height: 8px;
  background: #10b981;
  border-radius: 50%;
  transition: width 0.2s ease, height 0.2s ease, top 0.2s ease, left 0.2s ease,
    background-color 0.2s ease;
  will-change: transform;
}

/* Hover state */
.cursor-wrapper.is-hovering .cursor-ring {
  width: 64px;
  height: 64px;
  top: -32px;
  left: -32px;
  border-color: rgba(16, 185, 129, 1);
  background-color: rgba(16, 185, 129, 0.1);
}

.cursor-wrapper.is-hovering .cursor-dot {
  width: 4px;
  height: 4px;
  top: -2px;
  left: -2px;
  background: #fff;
}

/* Click state */
.cursor-wrapper.is-clicking .cursor-ring {
  width: 40px;
  height: 40px;
  top: -20px;
  left: -20px;
  border-width: 2px;
}

.cursor-wrapper.is-clicking .cursor-dot {
  width: 12px;
  height: 12px;
  top: -6px;
  left: -6px;
}

/* Hide on touch devices */
@media (hover: none) and (pointer: coarse) {
  .cursor-wrapper {
    display: none;
  }
}
</style>