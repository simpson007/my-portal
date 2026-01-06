<template>
  <div class="masonry-layout">
    <slot />
  </div>
</template>

<script setup lang="ts">
</script>

<style scoped>
.masonry-layout {
  display: grid;
  grid-template-columns: repeat(12, 1fr);
  grid-auto-rows: minmax(80px, auto);
  gap: 24px;
  max-width: 1400px;
  margin: 0 auto;
  padding: 0 24px;
}

/* Responsive */
@media (max-width: 1024px) {
  .masonry-layout {
    grid-template-columns: repeat(6, 1fr);
    gap: 16px;
  }
}

@media (max-width: 640px) {
  .masonry-layout {
    grid-template-columns: 1fr;
    gap: 16px;
    padding: 0 16px;
  }
}
</style>