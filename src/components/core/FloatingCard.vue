<template>
  <div
    ref="cardRef"
    class="floating-card hoverable"
    :class="[sizeClass, { 'is-hovered': isHovered }]"
    :style="cardStyle"
    @mouseenter="handleMouseEnter"
    @mouseleave="handleMouseLeave"
    @mousemove="handleMouseMove"
  >
    <!-- Noise texture overlay -->
    <div class="card-noise" />

    <!-- Spotlight border effect -->
    <div
      class="card-spotlight"
      :style="spotlightStyle"
    />

    <!-- Glass background -->
    <div class="card-glass" />

    <!-- Content -->
    <div class="card-content">
      <slot />
    </div>

    <!-- Glow effect on hover -->
    <div class="card-glow" :style="glowStyle" />
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'

interface Props {
  size?: 'sm' | 'md' | 'lg' | 'xl'
  floatDelay?: number
  floatDuration?: number
  floatDistance?: number
}

const props = withDefaults(defineProps<Props>(), {
  size: 'md',
  floatDelay: 0,
  floatDuration: 6,
  floatDistance: 15
})

const cardRef = ref<HTMLDivElement>()
const isHovered = ref(false)
const mouseX = ref(0)
const mouseY = ref(0)
const cardRect = ref({ width: 0, height: 0 })

const sizeClass = computed(() => `card-${props.size}`)

const cardStyle = computed(() => ({
  '--float-delay': `${props.floatDelay}s`,
  '--float-duration': `${props.floatDuration}s`,
  '--float-distance': `${props.floatDistance}px`
}))

const spotlightStyle = computed(() => {
  if (!isHovered.value) return { opacity: 0 }

  return {
    opacity: 1,
    background: `radial-gradient(
      600px circle at ${mouseX.value}px ${mouseY.value}px,
      rgba(16, 185, 129, 0.15),
      transparent 40%
    )`
  }
})

const glowStyle = computed(() => {
  if (!isHovered.value) return { opacity: 0 }

  return {
    opacity: 1,
    background: `radial-gradient(
      400px circle at ${mouseX.value}px ${mouseY.value}px,
      rgba(16, 185, 129, 0.1),
      transparent 50%
    )`
  }
})

const handleMouseEnter = () => {
  isHovered.value = true
  if (cardRef.value) {
    const rect = cardRef.value.getBoundingClientRect()
    cardRect.value = { width: rect.width, height: rect.height }
  }
}

const handleMouseLeave = () => {
  isHovered.value = false
}

const handleMouseMove = (e: MouseEvent) => {
  if (!cardRef.value) return

  const rect = cardRef.value.getBoundingClientRect()
  mouseX.value = e.clientX - rect.left
  mouseY.value = e.clientY - rect.top
}

onMounted(() => {
  if (cardRef.value) {
    const rect = cardRef.value.getBoundingClientRect()
    cardRect.value = { width: rect.width, height: rect.height }
  }
})
</script>

<style scoped>
.floating-card {
  position: relative;
  border-radius: 24px;
  overflow: hidden;
  animation: float var(--float-duration) ease-in-out infinite;
  animation-delay: var(--float-delay);
  transition: transform 0.4s cubic-bezier(0.23, 1, 0.32, 1),
    box-shadow 0.4s cubic-bezier(0.23, 1, 0.32, 1);
  will-change: transform;
}

.floating-card:hover {
  transform: translateY(-8px) scale(1.02);
  box-shadow: 0 25px 50px -12px rgba(16, 185, 129, 0.15),
    0 0 0 1px rgba(16, 185, 129, 0.2);
}

/* Floating animation */
@keyframes float {
  0%,
  100% {
    transform: translateY(0);
  }
  50% {
    transform: translateY(calc(var(--float-distance) * -1));
  }
}

/* Noise texture */
.card-noise {
  position: absolute;
  inset: 0;
  opacity: 0.03;
  pointer-events: none;
  z-index: 1;
  background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 256 256' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='noise'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23noise)'/%3E%3C/svg%3E");
}

/* Spotlight border */
.card-spotlight {
  position: absolute;
  inset: 0;
  z-index: 2;
  pointer-events: none;
  opacity: 0;
  transition: opacity 0.3s ease;
  border-radius: inherit;
}

/* Glass effect */
.card-glass {
  position: absolute;
  inset: 0;
  background: rgba(15, 23, 42, 0.6);
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
  border: 1px solid rgba(255, 255, 255, 0.08);
  border-radius: inherit;
  z-index: 0;
}

/* Content */
.card-content {
  position: relative;
  z-index: 3;
  padding: 20px;
  height: 100%;
}

/* Glow effect */
.card-glow {
  position: absolute;
  inset: 0;
  z-index: 1;
  pointer-events: none;
  opacity: 0;
  transition: opacity 0.3s ease;
  border-radius: inherit;
}

/* Size variants */
.card-sm {
  min-height: 100px;
}

.card-md {
  min-height: 160px;
}

.card-lg {
  min-height: 200px;
}

.card-xl {
  min-height: 280px;
}

/* Hover state enhancements */
.floating-card.is-hovered {
  animation-play-state: paused;
}

.floating-card.is-hovered .card-glass {
  border-color: rgba(16, 185, 129, 0.2);
  background: rgba(15, 23, 42, 0.7);
}

/* Inner glow on border */
.floating-card::before {
  content: '';
  position: absolute;
  inset: 0;
  border-radius: inherit;
  padding: 1px;
  background: linear-gradient(
    135deg,
    rgba(16, 185, 129, 0.2),
    transparent 50%,
    rgba(16, 185, 129, 0.1)
  );
  -webkit-mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
  -webkit-mask-composite: xor;
  mask-composite: exclude;
  pointer-events: none;
  z-index: 4;
  opacity: 0;
  transition: opacity 0.3s ease;
}

.floating-card:hover::before {
  opacity: 1;
}
</style>