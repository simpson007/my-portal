<template>
  <span
    class="glitch-text"
    :class="{ 'is-glitching': isGlitching }"
    @mouseenter="startGlitch"
    @mouseleave="stopGlitch"
  >
    <span class="glitch-text__main" :data-text="displayText">{{ displayText }}</span>
    <span class="glitch-text__clone glitch-text__clone--1" aria-hidden="true">{{ glitchText1 }}</span>
    <span class="glitch-text__clone glitch-text__clone--2" aria-hidden="true">{{ glitchText2 }}</span>
  </span>
</template>

<script setup lang="ts">
import { ref, computed, onUnmounted } from 'vue'

interface Props {
  text: string
  glitchOnHover?: boolean
  autoGlitch?: boolean
  glitchInterval?: number
}

const props = withDefaults(defineProps<Props>(), {
  glitchOnHover: true,
  autoGlitch: false,
  glitchInterval: 3000
})

const isGlitching = ref(false)
const glitchText1 = ref(props.text)
const glitchText2 = ref(props.text)
const displayText = ref(props.text)

let glitchIntervalId: number | null = null
let decodeIntervalId: number | null = null

const glitchChars = '!<>-_\\/[]{}—=+*^?#________'

const getRandomChar = () => {
  return glitchChars[Math.floor(Math.random() * glitchChars.length)]
}

const scrambleText = (original: string): string => {
  return original
    .split('')
    .map(char => (Math.random() > 0.7 ? getRandomChar() : char))
    .join('')
}

const startGlitch = () => {
  if (!props.glitchOnHover) return

  isGlitching.value = true

  // Scramble clone texts rapidly
  glitchIntervalId = window.setInterval(() => {
    glitchText1.value = scrambleText(props.text)
    glitchText2.value = scrambleText(props.text)
  }, 50)

  // Decode effect on main text
  let iteration = 0
  const originalText = props.text

  decodeIntervalId = window.setInterval(() => {
    displayText.value = originalText
      .split('')
      .map((char, index) => {
        if (index < iteration) {
          return originalText[index]
        }
        return glitchChars[Math.floor(Math.random() * glitchChars.length)]
      })
      .join('')

    if (iteration >= originalText.length) {
      if (decodeIntervalId) {
        clearInterval(decodeIntervalId)
      }
    }

    iteration += 1 / 3
  }, 30)
}

const stopGlitch = () => {
  isGlitching.value = false
  displayText.value = props.text
  glitchText1.value = props.text
  glitchText2.value = props.text

  if (glitchIntervalId) {
    clearInterval(glitchIntervalId)
    glitchIntervalId = null
  }
  if (decodeIntervalId) {
    clearInterval(decodeIntervalId)
    decodeIntervalId = null
  }
}

onUnmounted(() => {
  stopGlitch()
})
</script>

<style scoped>
.glitch-text {
  position: relative;
  display: inline-block;
  font-family: 'JetBrains Mono', monospace;
  font-weight: 700;
}

.glitch-text__main {
  position: relative;
  z-index: 1;
}

.glitch-text__clone {
  position: absolute;
  top: 0;
  left: 0;
  opacity: 0;
  pointer-events: none;
}

/* Glitching state */
.glitch-text.is-glitching .glitch-text__clone {
  opacity: 0.8;
}

.glitch-text.is-glitching .glitch-text__clone--1 {
  color: #ff00ff;
  animation: glitch-1 0.3s infinite linear alternate-reverse;
  clip-path: polygon(0 0, 100% 0, 100% 45%, 0 45%);
}

.glitch-text.is-glitching .glitch-text__clone--2 {
  color: #00ffff;
  animation: glitch-2 0.3s infinite linear alternate-reverse;
  clip-path: polygon(0 55%, 100% 55%, 100% 100%, 0 100%);
}

.glitch-text.is-glitching .glitch-text__main {
  animation: glitch-main 0.3s infinite linear;
}

@keyframes glitch-1 {
  0% {
    transform: translate(-2px, -1px);
  }
  25% {
    transform: translate(2px, 1px);
  }
  50% {
    transform: translate(-1px, 2px);
  }
  75% {
    transform: translate(1px, -2px);
  }
  100% {
    transform: translate(2px, 1px);
  }
}

@keyframes glitch-2 {
  0% {
    transform: translate(2px, 1px);
  }
  25% {
    transform: translate(-2px, -1px);
  }
  50% {
    transform: translate(1px, -2px);
  }
  75% {
    transform: translate(-1px, 2px);
  }
  100% {
    transform: translate(-2px, -1px);
  }
}

@keyframes glitch-main {
  0%, 100% {
    transform: translate(0);
  }
  20% {
    transform: translate(-1px, 1px);
  }
  40% {
    transform: translate(1px, -1px);
  }
  60% {
    transform: translate(-1px, -1px);
  }
  80% {
    transform: translate(1px, 1px);
  }
}

/* Scanline effect */
.glitch-text.is-glitching::after {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: repeating-linear-gradient(
    0deg,
    transparent,
    transparent 2px,
    rgba(0, 0, 0, 0.1) 2px,
    rgba(0, 0, 0, 0.1) 4px
  );
  pointer-events: none;
  animation: scanline 0.1s infinite linear;
}

@keyframes scanline {
  0% {
    transform: translateY(0);
  }
  100% {
    transform: translateY(4px);
  }
}
</style>