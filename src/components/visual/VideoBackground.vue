<template>
  <div class="fixed inset-0 -z-10 overflow-hidden bg-black">
    <!-- Video 1 -->
    <video
      ref="video1"
      class="absolute inset-0 h-full w-full object-cover transition-opacity duration-1000"
      :class="{ 'opacity-100': activeVideo === 1, 'opacity-0': activeVideo !== 1 }"
      muted
      playsinline
    >
      <source :src="videoSrc" type="video/mp4" />
    </video>

    <!-- Video 2 -->
    <video
      ref="video2"
      class="absolute inset-0 h-full w-full object-cover transition-opacity duration-1000"
      :class="{ 'opacity-100': activeVideo === 2, 'opacity-0': activeVideo !== 2 }"
      muted
      playsinline
    >
      <source :src="videoSrc" type="video/mp4" />
    </video>

    <!-- Gradient overlay -->
    <div class="absolute inset-0 bg-gradient-to-t from-black/70 via-[#051005]/20 to-transparent" />
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import videoSrc from '@/assets/video/3163534-uhd_3840_2160_30fps.mp4'

const video1 = ref<HTMLVideoElement | null>(null)
const video2 = ref<HTMLVideoElement | null>(null)
const activeVideo = ref(1)

onMounted(() => {
  const v1 = video1.value
  const v2 = video2.value

  if (!v1 || !v2) return

  // Initialize
  v1.play()
  
  // Crossfade logic
  // We monitor the active video. When it's near end (e.g. 1s left), we start the other one.
  const checkTime = () => {
    const current = activeVideo.value === 1 ? v1 : v2
    const next = activeVideo.value === 1 ? v2 : v1
    
    // Duration might be NaN at first
    if (!current.duration) {
      requestAnimationFrame(checkTime)
      return
    }

    const timeRemaining = current.duration - current.currentTime

    // Start crossfade 1.5s before end
    if (timeRemaining < 1.5 && next.paused) {
      next.currentTime = 0
      next.play()
      // Toggle active video to trigger CSS opacity transition
      activeVideo.value = activeVideo.value === 1 ? 2 : 1
    }

    requestAnimationFrame(checkTime)
  }

  requestAnimationFrame(checkTime)
})
</script>
