<script setup lang="ts">
import { ref, onMounted } from 'vue'
import gsap from 'gsap'
import ParticleField from './components/visual/ParticleField.vue'
import FloatingCard from './components/core/FloatingCard.vue'
import GlitchText from './components/core/GlitchText.vue'
import CustomCursor from './components/core/CustomCursor.vue'
import CommandPalette from './components/CommandPalette.vue'
import { useI18n } from './composables/useI18n'

const { t, locale, toggleLocale } = useI18n()
const isLoaded = ref(false)

// 入场动画
onMounted(() => {
  isLoaded.value = true

  const tl = gsap.timeline({ defaults: { ease: 'power3.out' } })

  tl.from('.digital-garden', {
    opacity: 0,
    duration: 0.8
  })
    .from('.floating-card', {
      y: 80,
      opacity: 0,
      duration: 1,
      stagger: 0.15,
      ease: 'power4.out'
    })
    .from('.cmd-hint', {
      opacity: 0,
      y: 20,
      duration: 0.6
    }, '-=0.3')
})
</script>

<template>
  <div class="min-h-screen w-full overflow-hidden bg-[#0a0a0f]">
    <CustomCursor />
    <ParticleField />

    <!-- 语言切换按钮 -->
    <button
      @click="toggleLocale"
      class="fixed top-4 right-4 z-50 px-3 py-1.5 text-xs font-mono bg-white/5 text-white/60 rounded-full border border-white/10 hover:border-accent/50 hover:text-accent transition-all duration-300"
    >
      {{ locale === 'zh' ? 'EN' : '中文' }}
    </button>

    <main class="relative z-10 min-h-screen flex items-center justify-center p-4 md:p-6 lg:p-8">
      <div class="w-full max-w-6xl">
        <div class="digital-garden relative">
          <!-- Profile Card -->
          <FloatingCard
            size="lg"
            class="floating-card profile-card mb-5"
            :float-delay="0"
            :float-duration="8"
            :float-distance="20"
          >
            <div class="flex flex-col h-full">
              <div class="flex items-start gap-4 mb-4">
                <div class="relative group">
                  <div class="w-16 h-16 md:w-20 md:h-20 rounded-2xl bg-gradient-to-br from-accent via-emerald-500 to-teal-600 p-0.5 transition-transform duration-500 group-hover:scale-105 group-hover:rotate-3">
                    <div class="w-full h-full rounded-2xl bg-[#0a0a0f] flex items-center justify-center text-2xl md:text-3xl font-bold text-accent font-mono">
                      Y
                    </div>
                  </div>
                  <div class="absolute -bottom-1 -right-1 w-4 h-4 bg-green-500 rounded-full border-2 border-[#0a0a0f] animate-pulse shadow-lg shadow-green-500/50" />
                  <div class="absolute inset-0 rounded-2xl bg-gradient-to-br from-accent/20 to-emerald-600/20 blur-xl opacity-0 group-hover:opacity-100 transition-opacity duration-500" />
                </div>
                <div class="flex-1">
                  <GlitchText
                    :text="t.profile.name"
                    class="text-xl md:text-2xl lg:text-3xl font-bold text-white mb-1 block"
                    :glitch-on-hover="true"
                  />
                  <p class="text-white/60 font-mono text-xs tracking-wide">
                    <span class="text-accent">&gt;_</span> {{ t.profile.title }}
                  </p>
                </div>
              </div>

              <div class="mb-4 flex-1">
                <p class="text-white/80 leading-relaxed text-sm md:text-base">
                  <span class="text-accent font-mono text-lg mr-2">&gt;</span>
                  <span class="font-light">{{ t.profile.slogan }}</span> {{ t.profile.description }}
                </p>
                <p class="text-white/60 leading-relaxed mt-1.5 text-xs md:text-sm pl-6">
                  {{ t.profile.specializing }} <span class="text-accent font-mono">Vue</span>, 
                  <span class="text-accent font-mono">TypeScript</span> {{ t.profile.and }} 
                  <span class="text-accent font-mono">WebGL</span>。
                </p>
              </div>

              <div class="flex flex-wrap gap-2">
                <span class="px-3 py-1.5 text-xs font-mono bg-accent/20 text-accent rounded-full border border-accent/30 hover:bg-accent/30 transition-colors cursor-default backdrop-blur-sm">
                  {{ t.profile.openToWork }}
                </span>
                <span class="px-3 py-1.5 text-xs font-mono bg-white/5 text-white/60 rounded-full border border-white/10 hover:border-white/20 transition-colors cursor-default backdrop-blur-sm">
                  {{ t.profile.buildingCoolStuff }}
                </span>
              </div>
            </div>
          </FloatingCard>

          <!-- Grid Layout -->
          <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4 md:gap-5 auto-rows-auto">
            <!-- Games Card -->
            <FloatingCard size="md" class="floating-card hoverable" :float-delay="0.2" :float-duration="6.5" :float-distance="16">
              <a href="#games" class="block h-full group/link">
                <div class="flex flex-col h-full">
                  <div class="w-10 h-10 rounded-xl bg-gradient-to-br from-purple-500/30 to-pink-500/30 flex items-center justify-center mb-3 group-hover/link:scale-110 group-hover/link:rotate-6 transition-all duration-300 border border-purple-500/20">
                    <span class="text-xl">🎮</span>
                  </div>
                  <h3 class="text-lg font-bold text-white mb-2 group-hover/link:text-accent transition-colors font-mono">
                    {{ t.cards.games }}
                  </h3>
                  <p class="text-white/60 text-xs leading-relaxed flex-1">{{ t.cards.gamesDesc }}</p>
                  <div class="flex items-center text-accent text-xs font-mono mt-3 opacity-0 group-hover/link:opacity-100 transition-all duration-300">
                    <span>{{ t.cards.playNow }}</span>
                    <svg class="w-3 h-3 ml-1 transform group-hover/link:translate-x-1 transition-transform" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
                    </svg>
                  </div>
                </div>
              </a>
            </FloatingCard>

            <!-- Blog Card -->
            <FloatingCard size="md" class="floating-card hoverable" :float-delay="0.4" :float-duration="7" :float-distance="12">
              <a href="https://blog.yushenjian.com" class="block h-full group/link">
                <div class="flex flex-col h-full">
                  <div class="w-10 h-10 rounded-xl bg-gradient-to-br from-blue-500/30 to-cyan-500/30 flex items-center justify-center mb-3 group-hover/link:scale-110 transition-transform duration-300 border border-blue-500/20">
                    <span class="text-xl">📝</span>
                  </div>
                  <h3 class="text-lg font-bold text-white mb-2 group-hover/link:text-accent transition-colors font-mono">
                    {{ t.cards.blog }}
                  </h3>
                  <p class="text-white/60 text-xs leading-relaxed flex-1">{{ t.cards.blogDesc }}</p>
                  <div class="flex items-center text-accent text-xs font-mono mt-3 opacity-0 group-hover/link:opacity-100 transition-all duration-300">
                    <span>{{ t.cards.readMore }}</span>
                    <svg class="w-3 h-3 ml-1 transform group-hover/link:translate-x-1 transition-transform" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
                    </svg>
                  </div>
                </div>
              </a>
            </FloatingCard>

            <!-- Tools Card -->
            <FloatingCard size="md" class="floating-card hoverable" :float-delay="0.6" :float-duration="6.8" :float-distance="14">
              <a href="#tools" class="block h-full group/link">
                <div class="flex flex-col h-full">
                  <div class="w-10 h-10 rounded-xl bg-gradient-to-br from-orange-500/30 to-red-500/30 flex items-center justify-center mb-3 group-hover/link:scale-110 group-hover/link:-rotate-6 transition-all duration-300 border border-orange-500/20">
                    <span class="text-xl">🔧</span>
                  </div>
                  <h3 class="text-lg font-bold text-white mb-2 group-hover/link:text-accent transition-colors font-mono">
                    {{ t.cards.tools }}
                  </h3>
                  <p class="text-white/60 text-xs leading-relaxed flex-1">{{ t.cards.toolsDesc }}</p>
                  <div class="flex items-center text-accent text-xs font-mono mt-3 opacity-0 group-hover/link:opacity-100 transition-all duration-300">
                    <span>{{ t.cards.explore }}</span>
                    <svg class="w-3 h-3 ml-1 transform group-hover/link:translate-x-1 transition-transform" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
                    </svg>
                  </div>
                </div>
              </a>
            </FloatingCard>

            <!-- Connect Card -->
            <FloatingCard size="md" class="floating-card lg:col-span-3" :float-delay="0.8" :float-duration="7.5" :float-distance="10">
              <div>
                <h3 class="text-lg font-bold text-white mb-4 font-mono">{{ t.cards.connect }}</h3>
                <div style="display: flex; gap: 16px;">
                  <a href="https://github.com/yushenjian" target="_blank" rel="noopener noreferrer"
                    style="display: flex; flex-direction: column; align-items: center; justify-content: center; width: 80px; height: 80px; border-radius: 12px; background: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.1);"
                    class="social-link group/social hover:border-accent/50 transition-all duration-300">
                    <svg style="width: 24px; height: 24px; margin-bottom: 8px;" class="text-white/70 group-hover/social:text-accent" viewBox="0 0 24 24" fill="currentColor">
                      <path d="M12 0c-6.626 0-12 5.373-12 12 0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23.957-.266 1.983-.399 3.003-.404 1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576 4.765-1.589 8.199-6.086 8.199-11.386 0-6.627-5.373-12-12-12z"/>
                    </svg>
                    <span class="text-xs font-mono text-white/50 group-hover/social:text-accent">{{ t.social.github }}</span>
                  </a>
                  <a href="https://twitter.com/yushenjian" target="_blank" rel="noopener noreferrer"
                    style="display: flex; flex-direction: column; align-items: center; justify-content: center; width: 80px; height: 80px; border-radius: 12px; background: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.1);"
                    class="social-link group/social hover:border-accent/50 transition-all duration-300">
                    <svg style="width: 24px; height: 24px; margin-bottom: 8px;" class="text-white/70 group-hover/social:text-accent" viewBox="0 0 24 24" fill="currentColor">
                      <path d="M18.244 2.25h3.308l-7.227 8.26 8.502 11.24H16.17l-5.214-6.817L4.99 21.75H1.68l7.73-8.835L1.254 2.25H8.08l4.713 6.231zm-1.161 17.52h1.833L7.084 4.126H5.117z"/>
                    </svg>
                    <span class="text-xs font-mono text-white/50 group-hover/social:text-accent">{{ t.social.twitter }}</span>
                  </a>
                  <a href="https://linkedin.com/in/yushenjian" target="_blank" rel="noopener noreferrer"
                    style="display: flex; flex-direction: column; align-items: center; justify-content: center; width: 80px; height: 80px; border-radius: 12px; background: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.1);"
                    class="social-link group/social hover:border-accent/50 transition-all duration-300">
                    <svg style="width: 24px; height: 24px; margin-bottom: 8px;" class="text-white/70 group-hover/social:text-accent" viewBox="0 0 24 24" fill="currentColor">
                      <path d="M20.447 20.452h-3.554v-5.569c0-1.328-.027-3.037-1.852-3.037-1.853 0-2.136 1.445-2.136 2.939v5.667H9.351V9h3.414v1.561h.046c.477-.9 1.637-1.85 3.37-1.85 3.601 0 4.267 2.37 4.267 5.455v6.286zM5.337 7.433c-1.144 0-2.063-.926-2.063-2.065 0-1.138.92-2.063 2.063-2.063 1.14 0 2.064.925 2.064 2.063 0 1.139-.925 2.065-2.064 2.065zm1.782 13.019H3.555V9h3.564v11.452zM22.225 0H1.771C.792 0 0 .774 0 1.729v20.542C0 23.227.792 24 1.771 24h20.451C23.2 24 24 23.227 24 22.271V1.729C24 .774 23.2 0 22.222 0h.003z"/>
                    </svg>
                    <span class="text-xs font-mono text-white/50 group-hover/social:text-accent">{{ t.social.linkedin }}</span>
                  </a>
                  <a href="mailto:contact@yushenjian.com"
                    style="display: flex; flex-direction: column; align-items: center; justify-content: center; width: 80px; height: 80px; border-radius: 12px; background: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.1);"
                    class="social-link group/social hover:border-accent/50 transition-all duration-300">
                    <svg style="width: 24px; height: 24px; margin-bottom: 8px;" class="text-white/70 group-hover/social:text-accent" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                      <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/>
                      <polyline points="22,6 12,13 2,6"/>
                    </svg>
                    <span class="text-xs font-mono text-white/50 group-hover/social:text-accent">{{ t.social.email }}</span>
                  </a>
                </div>
              </div>
            </FloatingCard>
          </div>
        </div>

        <!-- Cmd+K 提示 -->
        <div class="cmd-hint flex justify-center mt-8">
          <div class="flex items-center gap-2 text-white/40 text-xs font-mono group cursor-default">
            <span class="group-hover:text-white/60 transition-colors">{{ t.command.hint }}</span>
            <kbd class="px-2 py-1 bg-white/5 border border-white/10 rounded text-[10px] font-mono backdrop-blur-sm group-hover:border-accent/30 group-hover:bg-accent/5 transition-all duration-300">
              ⌘K
            </kbd>
            <span class="group-hover:text-white/60 transition-colors">{{ t.command.forCommands }}</span>
          </div>
        </div>
      </div>
    </main>

    <CommandPalette />
  </div>
</template>

<style scoped>
.digital-garden {
  perspective: 1000px;
}

.profile-card {
  grid-column: 1 / -1;
}

.hoverable {
  cursor: pointer;
}

.social-link {
  position: relative;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.social-link:hover {
  transform: translateY(-4px);
  box-shadow: 
    0 10px 25px -5px rgba(16, 185, 129, 0.2),
    0 0 20px rgba(16, 185, 129, 0.15);
}

@keyframes icon-glow {
  0%, 100% {
    filter: drop-shadow(0 0 4px rgba(16, 185, 129, 0.3));
  }
  50% {
    filter: drop-shadow(0 0 12px rgba(16, 185, 129, 0.6));
  }
}

.social-link:hover svg {
  animation: icon-glow 2s ease-in-out infinite;
}

* {
  transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1);
}

@media (hover: hover) and (pointer: fine) {
  * {
    cursor: none !important;
  }
}

@media (max-width: 768px) {
  .digital-garden {
    perspective: none;
  }
}
</style>
