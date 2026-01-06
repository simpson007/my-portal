<template>
  <Teleport to="body">
    <Transition name="fade">
      <div
        v-if="isOpen"
        class="fixed inset-0 z-50 flex items-start justify-center pt-[20vh]"
        @click.self="close"
      >
        <!-- 背景遮罩 -->
        <div class="absolute inset-0 bg-black/60 backdrop-blur-sm" @click="close" />

        <!-- 命令面板 -->
        <div
          class="relative w-full max-w-lg mx-4 bg-dark-secondary/95 backdrop-blur-2xl border border-white/10 rounded-3xl shadow-2xl overflow-hidden"
          @click.stop
        >
          <!-- Glassmorphism overlay -->
          <div class="absolute inset-0 bg-gradient-to-br from-white/5 to-transparent pointer-events-none" />
          <div class="absolute inset-0 bg-noise opacity-[0.03] pointer-events-none" />
          <!-- 搜索输入框 -->
          <div class="relative flex items-center px-5 border-b border-white/10 bg-white/5">
            <svg
              class="w-5 h-5 text-accent/60"
              fill="none"
              stroke="currentColor"
              viewBox="0 0 24 24"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"
              />
            </svg>
            <input
              ref="inputRef"
              v-model="searchQuery"
              type="text"
              placeholder="Type a command or search..."
              class="flex-1 px-4 py-5 bg-transparent text-white placeholder-white/40 outline-none font-mono text-sm"
              @keydown.down.prevent="selectNext"
              @keydown.up.prevent="selectPrev"
              @keydown.enter.prevent="executeSelected"
              @keydown.escape="close"
            />
            <kbd class="px-3 py-1.5 text-xs text-white/50 bg-white/5 rounded-lg border border-white/10 font-mono">
              ESC
            </kbd>
          </div>

          <!-- 命令列表 -->
          <div class="relative max-h-80 overflow-y-auto py-2">
            <div v-if="filteredCommands.length === 0" class="px-4 py-12 text-center text-white/40 font-mono">
              <div class="text-4xl mb-3">🔍</div>
              <div>No commands found</div>
            </div>

            <button
              v-for="(command, index) in filteredCommands"
              :key="command.id"
              class="relative w-full flex items-center gap-4 px-5 py-4 text-left transition-all duration-200 group"
              :class="[
                selectedIndex === index
                  ? 'bg-accent/15 text-accent border-l-2 border-accent'
                  : 'text-white/70 hover:bg-white/5 border-l-2 border-transparent'
              ]"
              @click="executeCommand(command)"
              @mouseenter="selectedIndex = index"
            >
              <span class="text-2xl transition-transform duration-200 group-hover:scale-110">{{ command.icon }}</span>
              <div class="flex-1 min-w-0">
                <div class="font-medium font-mono text-sm">{{ command.title }}</div>
                <div v-if="command.description" class="text-xs text-white/40 mt-0.5 truncate">
                  {{ command.description }}
                </div>
              </div>
              <kbd
                v-if="command.shortcut"
                class="px-2.5 py-1 text-xs text-white/40 bg-white/5 rounded-lg border border-white/10 font-mono"
              >
                {{ command.shortcut }}
              </kbd>
            </button>
          </div>

          <!-- 底部提示 -->
          <div class="relative flex items-center justify-between px-5 py-3 border-t border-white/10 text-xs text-white/40 bg-white/5">
            <div class="flex items-center gap-5">
              <span class="flex items-center gap-1.5 font-mono">
                <kbd class="px-2 py-1 bg-white/10 rounded-md border border-white/10">↑↓</kbd>
                Navigate
              </span>
              <span class="flex items-center gap-1.5 font-mono">
                <kbd class="px-2 py-1 bg-white/10 rounded-md border border-white/10">↵</kbd>
                Select
              </span>
            </div>
            <span class="font-mono text-accent/70 text-[10px] tracking-wider">YU_SHENJIAN</span>
          </div>
        </div>
      </div>
    </Transition>
  </Teleport>
</template>

<script setup lang="ts">
import { ref, computed, watch, nextTick, onMounted, onUnmounted } from 'vue'
import { commands } from '@/config/portals'

interface Command {
  id: string
  title: string
  icon: string
  description?: string
  shortcut?: string
  handler: () => void
}

const isOpen = ref(false)
const searchQuery = ref('')
const selectedIndex = ref(0)
const inputRef = ref<HTMLInputElement>()

const allCommands: Command[] = [
  ...commands,
  {
    id: 'home',
    title: 'Go Home',
    icon: '🏠',
    description: 'Return to homepage',
    handler: () => window.location.href = '/'
  },
  {
    id: 'source',
    title: 'View Source',
    icon: '💻',
    description: 'View source code on GitHub',
    handler: () => window.open('https://github.com/yushenjian/portal', '_blank')
  }
]

const filteredCommands = computed(() => {
  if (!searchQuery.value) return allCommands

  const query = searchQuery.value.toLowerCase()
  return allCommands.filter(
    cmd =>
      cmd.title.toLowerCase().includes(query) ||
      cmd.id.toLowerCase().includes(query) ||
      cmd.description?.toLowerCase().includes(query)
  )
})

watch(searchQuery, () => {
  selectedIndex.value = 0
})

watch(isOpen, async (open) => {
  if (open) {
    searchQuery.value = ''
    selectedIndex.value = 0
    await nextTick()
    inputRef.value?.focus()
  }
})

const open = () => {
  isOpen.value = true
}

const close = () => {
  isOpen.value = false
}

const toggle = () => {
  isOpen.value = !isOpen.value
}

const selectNext = () => {
  if (selectedIndex.value < filteredCommands.value.length - 1) {
    selectedIndex.value++
  }
}

const selectPrev = () => {
  if (selectedIndex.value > 0) {
    selectedIndex.value--
  }
}

const executeSelected = () => {
  const command = filteredCommands.value[selectedIndex.value]
  if (command) {
    executeCommand(command)
  }
}

const executeCommand = (command: Command) => {
  close()
  command.handler()
}

// 全局快捷键监听
const handleKeydown = (e: KeyboardEvent) => {
  // Cmd+K (Mac) 或 Ctrl+K (Windows/Linux)
  if ((e.metaKey || e.ctrlKey) && e.key === 'k') {
    e.preventDefault()
    toggle()
  }
}

onMounted(() => {
  window.addEventListener('keydown', handleKeydown)
})

onUnmounted(() => {
  window.removeEventListener('keydown', handleKeydown)
})

defineExpose({ open, close, toggle })
</script>

<style scoped>
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.2s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}

.fade-enter-active .relative,
.fade-leave-active .relative {
  transition: transform 0.2s ease, opacity 0.2s ease;
}

.fade-enter-from .relative,
.fade-leave-to .relative {
  transform: scale(0.95) translateY(-10px);
  opacity: 0;
}
</style>