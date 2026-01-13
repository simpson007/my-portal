<script setup lang="ts">
import { ref, computed, onMounted, onUnmounted } from 'vue'
import VideoBackground from './components/visual/VideoBackground.vue'
import CustomCursor from './components/core/CustomCursor.vue'

const now = ref(new Date())
const typedQuote = ref('')
const quoteText = '竹影扫阶尘不动，月轮穿沼水无痕。'

const mouseX = ref(0.5)
const mouseY = ref(0.5)

let timeTimer: number | undefined
let typeTimer: number | undefined

const timeParts = computed(() => {
  const formatted = new Intl.DateTimeFormat('en-GB', {
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit',
    hour12: false
  }).format(now.value)

  const [hours, minutes, seconds] = formatted.split(':')
  return { hours, minutes, seconds }
})

const parallaxStyle = computed(() => {
  const x = (mouseX.value - 0.5) * -15
  const y = (mouseY.value - 0.5) * -15
  return {
    transform: `translate(${x}px, ${y}px)`
  }
})

const skills = ['Vue 3', 'WebGL', 'TypeScript', 'Three.js']

const dockItems = [
  {
    label: '博客',
    href: '#blog',
    paths: [
      'M7.5 4.5h9a2 2 0 0 1 2 2v11a2 2 0 0 1-2 2h-9a2 2 0 0 1-2-2v-11a2 2 0 0 1 2-2Z',
      'M9 9h6',
      'M9 13h6'
    ],
    circles: []
  },
  {
    label: '游戏',
    href: '#games',
    paths: [
      'M7.5 11h9a3 3 0 0 1 2.9 2.2l.5 2.4a2.5 2.5 0 0 1-2.4 3.1h-1.2a2.5 2.5 0 0 1-2.2-1.2l-.4-.7a2 2 0 0 0-1.7-1h-2a2 2 0 0 0-1.7 1l-.4.7a2.5 2.5 0 0 1-2.2 1.2H6.8A2.5 2.5 0 0 1 4.4 15l.5-2.4A3 3 0 0 1 7.5 11Z',
      'M8.7 14h2.1',
      'M9.75 12.9v2.2'
    ],
    circles: [{ cx: 16.3, cy: 14, r: 0.8 }]
  },
  {
    label: '工具',
    href: '#tools',
    paths: [
      'M12 2.5v2.5',
      'M12 19v2.5',
      'M2.5 12h2.5',
      'M19 12h2.5',
      'M4.6 4.6l1.8 1.8',
      'M17.6 17.6l1.8 1.8',
      'M4.6 19.4l1.8-1.8',
      'M17.6 6.4l1.8-1.8'
    ],
    circles: [{ cx: 12, cy: 12, r: 3.2 }]
  },
  {
    label: '开源',
    href: 'https://github.com/yushenjian',
    paths: [
      'M8.5 9.5L5 12l3.5 2.5',
      'M15.5 9.5L19 12l-3.5 2.5',
      'M10 19l4-14'
    ],
    circles: []
  },
  {
    label: '联系',
    href: 'mailto:hello@yushenjian.com',
    paths: [
      'M4.5 7.5h15a2 2 0 0 1 2 2v7a2 2 0 0 1-2 2h-15a2 2 0 0 1-2-2v-7a2 2 0 0 1 2-2Z',
      'M4.5 9l7.5 5 7.5-5'
    ],
    circles: []
  }
]

const handleMouseMove = (e: MouseEvent) => {
  mouseX.value = e.clientX / window.innerWidth
  mouseY.value = e.clientY / window.innerHeight

  const cards = document.querySelectorAll('.glass-panel') as NodeListOf<HTMLElement>
  cards.forEach(card => {
    const rect = card.getBoundingClientRect()
    const x = e.clientX - rect.left
    const y = e.clientY - rect.top
    card.style.setProperty('--mouse-x', `${x}px`)
    card.style.setProperty('--mouse-y', `${y}px`)
  })
}

onMounted(() => {
  window.addEventListener('mousemove', handleMouseMove)

  timeTimer = window.setInterval(() => {
    now.value = new Date()
  }, 1000)

  let index = 0
  const typeNext = () => {
    typedQuote.value = quoteText.slice(0, index)
    if (index < quoteText.length) {
      index += 1
      typeTimer = window.setTimeout(typeNext, 80)
    }
  }

  typeTimer = window.setTimeout(typeNext, 1000)
})

onUnmounted(() => {
  window.removeEventListener('mousemove', handleMouseMove)
  if (timeTimer) {
    window.clearInterval(timeTimer)
  }
  if (typeTimer) {
    window.clearTimeout(typeTimer)
  }
})
</script>

<template>
  <div class="relative min-h-screen overflow-hidden">
    <CustomCursor />
    <VideoBackground />

    <div
      class="relative z-10 min-h-screen p-6 sm:p-8 lg:p-10 transition-transform duration-500 ease-out"
      :style="parallaxStyle"
    >
      <!-- Profile Card - Top Left -->
      <Transition appear name="float-in">
        <section
          class="glass-panel mb-5 w-full max-w-[280px] p-5 md:mb-0 md:absolute md:left-10 md:top-10"
          style="--delay: 0ms;"
        >
          <div class="flex items-center gap-4">
            <div class="h-12 w-12 rounded-xl bg-gradient-to-br from-emerald-600/20 via-teal-500/20 to-cyan-500/20 p-[1px]">
              <div class="flex h-full w-full items-center justify-center rounded-[11px] bg-[#0a150a]/60 font-serif-display text-sm text-jade">
                禅
              </div>
            </div>
            <div>
              <h1 class="font-serif-display text-lg text-jade tracking-wide">于慎简</h1>
              <div class="mt-1 flex items-center gap-2">
                <span class="status-dot"></span>
                <span class="text-xs text-jade-dim italic">前端艺术家 / 创意开发</span>
              </div>
            </div>
          </div>
          <!-- Skill Tags -->
          <div class="mt-4 flex flex-wrap gap-x-4 gap-y-2 text-xs">
            <span
              v-for="skill in skills"
              :key="skill"
              class="skill-tag"
            >
              {{ skill }}
            </span>
          </div>
        </section>
      </Transition>

      <!-- Clock - Top Right -->
      <Transition appear name="float-in">
        <section
          class="glass-panel mb-5 w-full max-w-[260px] p-5 md:mb-0 md:absolute md:right-10 md:top-10"
          style="--delay: 150ms;"
        >
          <p class="text-[10px] uppercase tracking-[0.3em] text-jade-muted">当前时间</p>
          <div class="mt-3 flex items-baseline gap-1">
            <span class="font-serif-display text-4xl sm:text-5xl text-jade tabular-nums tracking-tight">
              {{ timeParts.hours }}<span class="text-jade-muted">:</span>{{ timeParts.minutes }}
            </span>
            <span class="font-serif-display text-xl text-jade-dim tabular-nums">{{ timeParts.seconds }}</span>
          </div>
        </section>
      </Transition>

      <!-- Daily Quote - Bottom Right -->
      <Transition appear name="float-in">
        <section
          class="glass-panel w-full max-w-[280px] p-5 md:absolute md:bottom-10 md:right-10"
          style="--delay: 450ms;"
        >
          <p class="text-[10px] uppercase tracking-[0.3em] text-jade-muted">禅语</p>
          <p class="mt-3 text-base leading-relaxed text-jade-dim font-light tracking-wider">
            <span>{{ typedQuote }}</span>
            <span class="type-caret" aria-hidden="true"></span>
          </p>
        </section>
      </Transition>
    </div>

    <!-- Dock Navigation - Fixed Bottom Center (Outside Parallax) -->
    <Transition appear name="float-in">
      <section
        class="glass-panel fixed z-20 mb-5 w-full max-w-md px-5 py-3 md:mb-0 md:bottom-10 left-1/2 -translate-x-1/2"
        style="--delay: 300ms;"
      >
        <nav class="flex items-center justify-around">
          <a
            v-for="item in dockItems"
            :key="item.label"
            :href="item.href"
            class="dock-item"
            :rel="item.href.startsWith('http') ? 'noreferrer' : undefined"
            :target="item.href.startsWith('http') ? '_blank' : undefined"
          >
            <span class="dock-tooltip">{{ item.label }}</span>
            <span class="dock-icon">
              <svg
                class="h-5 w-5 text-jade-dim"
                viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                stroke-width="1.4"
                stroke-linecap="round"
                stroke-linejoin="round"
              >
                <path
                  v-for="(path, pathIndex) in item.paths"
                  :key="`${item.label}-path-${pathIndex}`"
                  :d="path"
                />
                <circle
                  v-for="(circle, circleIndex) in item.circles"
                  :key="`${item.label}-circle-${circleIndex}`"
                  :cx="circle.cx"
                  :cy="circle.cy"
                  :r="circle.r"
                  fill="currentColor"
                  stroke="none"
                />
              </svg>
            </span>
          </a>
        </nav>
      </section>
    </Transition>
  </div>
</template>
