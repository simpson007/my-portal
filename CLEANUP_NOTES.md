# 🧹 Cleanup Notes

## Optional Files to Remove

The following files are legacy components that are no longer used in the optimized version. You can safely delete them if you don't plan to use them:

### Unused Components

1. **`src/components/HelloWorld.vue`**
   - Status: ❌ Not imported anywhere
   - Reason: Default Vite template component
   - Action: Safe to delete

2. **`src/components/layout/MasonryLayout.vue`**
   - Status: ❌ Not imported anywhere
   - Reason: Replaced by asymmetric grid in App.vue
   - Action: Safe to delete

3. **`src/components/core/BentoCard.vue`**
   - Status: ⚠️ Legacy (replaced by FloatingCard)
   - Reason: Old grid-based card component
   - Action: Keep for reference or delete if not needed

4. **`src/components/visual/ShaderBg.vue`**
   - Status: ⚠️ Legacy (replaced by ParticleField)
   - Reason: Old static shader background
   - Action: Keep for reference or delete if not needed

## Cleanup Commands

### Remove Unused Components
```bash
# Remove HelloWorld (safe)
rm src/components/HelloWorld.vue

# Remove MasonryLayout (safe)
rm src/components/layout/MasonryLayout.vue

# Optional: Remove legacy components
rm src/components/core/BentoCard.vue
rm src/components/visual/ShaderBg.vue
```

### Clean Empty Directories
```bash
# Check if layout directory is empty
ls src/components/layout/

# If empty, remove it
rmdir src/components/layout/
```

## Files to Keep

### Active Components (DO NOT DELETE)
- ✅ `src/components/core/CustomCursor.vue` - Custom cursor
- ✅ `src/components/core/FloatingCard.vue` - Main card component
- ✅ `src/components/core/GlitchText.vue` - Text effect
- ✅ `src/components/core/MagneticBtn.vue` - Interactive buttons
- ✅ `src/components/visual/ParticleField.vue` - WebGL background
- ✅ `src/components/CommandPalette.vue` - Command interface

### Configuration Files (DO NOT DELETE)
- ✅ `src/config/portals.ts` - Content configuration
- ✅ `src/assets/shaders/flowField.glsl` - Shader code
- ✅ `src/App.vue` - Main application
- ✅ `src/main.ts` - Entry point
- ✅ `src/style.css` - Global styles

### Documentation (KEEP)
- ✅ `README.md` - Project overview
- ✅ `OPTIMIZATION_GUIDE.md` - Optimization details
- ✅ `CHANGES.md` - Change log
- ✅ `QUICKSTART.md` - Quick start guide
- ✅ `PROJECT_SUMMARY.md` - Project summary
- ✅ `CLEANUP_NOTES.md` - This file

## Recommended Cleanup Steps

### Step 1: Backup
```bash
# Create a backup branch
git checkout -b backup-before-cleanup
git add .
git commit -m "Backup before cleanup"
git checkout main
```

### Step 2: Remove Unused Files
```bash
# Remove definitely unused files
rm src/components/HelloWorld.vue
rm src/components/layout/MasonryLayout.vue

# Optional: Remove legacy components
# (Only if you're sure you won't need them)
# rm src/components/core/BentoCard.vue
# rm src/components/visual/ShaderBg.vue
```

### Step 3: Clean Build
```bash
# Clean and rebuild
rm -rf node_modules dist
npm install
npm run build
```

### Step 4: Test
```bash
# Start dev server and test
npm run dev

# Check all features:
# - Particle background working
# - Cards floating properly
# - Cursor tracking
# - Glitch text on hover
# - Command palette (⌘K)
```

### Step 5: Commit
```bash
git add .
git commit -m "chore: remove unused components"
```

## File Size Comparison

### Before Cleanup
```
Total Components: 11
Active: 7
Legacy: 4
```

### After Cleanup
```
Total Components: 7
Active: 7
Legacy: 0
```

## Benefits of Cleanup

1. **Smaller Bundle**: Reduced unused code
2. **Clearer Structure**: Only active components
3. **Easier Maintenance**: Less confusion
4. **Better Performance**: Faster builds

## Notes

- Keep legacy components if you want to reference the old implementation
- The cleanup is optional and won't affect functionality
- All active features use the new components
- You can always restore from git history if needed

---

**Last Updated**: January 5, 2026
