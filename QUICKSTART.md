# 🚀 Quick Start Guide

## Prerequisites

- Node.js 14+ (recommended: 18+)
- npm or yarn
- Modern browser (Chrome 90+, Firefox 88+, Safari 14+)

## Installation

```bash
# Clone the repository
git clone https://github.com/yushenjian/portal.git
cd my-portal

# Install dependencies
npm install

# Start development server
npm run dev
```

The app will be available at `http://localhost:5173`

## Development

### Project Structure
```
src/
├── components/
│   ├── core/           # Reusable UI components
│   ├── visual/         # WebGL and visual effects
│   └── CommandPalette.vue
├── config/
│   └── portals.ts      # Content configuration
├── assets/
│   └── shaders/        # GLSL shader code
├── App.vue             # Main application
├── main.ts             # Entry point
└── style.css           # Global styles
```

### Key Components

#### 1. ParticleField (WebGL Background)
```vue
<ParticleField />
```
- 3000 particles with flow field
- Mouse interaction
- Customizable in component

#### 2. FloatingCard (Glassmorphism Cards)
```vue
<FloatingCard
  size="md"
  :float-delay="0.2"
  :float-duration="7"
  :float-distance="18"
>
  <!-- Your content -->
</FloatingCard>
```

**Props:**
- `size`: 'sm' | 'md' | 'lg' | 'xl'
- `float-delay`: Animation delay in seconds
- `float-duration`: Animation duration in seconds
- `float-distance`: Float distance in pixels

#### 3. GlitchText (Cyberpunk Text Effect)
```vue
<GlitchText
  text="Your Text"
  :glitch-on-hover="true"
/>
```

#### 4. CustomCursor (Magnetic Cursor)
```vue
<CustomCursor />
```
Automatically tracks mouse and interacts with hoverable elements.

#### 5. MagneticBtn (Interactive Button)
```vue
<MagneticBtn
  variant="primary"
  :magnetic-strength="0.5"
>
  Click Me
</MagneticBtn>
```

**Variants:**
- `primary`: Accent color background
- `secondary`: White/10 background
- `ghost`: Transparent background

## Customization

### 1. Update Content

Edit `src/config/portals.ts`:

```typescript
export const socialLinks = [
  {
    name: 'GitHub',
    href: 'https://github.com/yourusername',
    icon: 'github'
  },
  // Add more links...
]
```

### 2. Adjust Colors

Edit `tailwind.config.js`:

```javascript
colors: {
  'accent': '#10b981',      // Your primary color
  'neon-teal': '#14b8a6',   // Secondary color
  'cyber-blue': '#06b6d4',  // Accent color
}
```

### 3. Modify Particle Count

Edit `src/components/visual/ParticleField.vue`:

```typescript
const PARTICLE_COUNT = 3000 // Adjust for performance
const FIELD_SIZE = 50       // Adjust distribution
```

### 4. Change Floating Animation

```vue
<FloatingCard
  :float-delay="0"        // Start immediately
  :float-duration="6"     // 6 seconds per cycle
  :float-distance="20"    // 20px movement
/>
```

## Performance Tips

### For Low-End Devices

1. **Reduce Particle Count**
```typescript
// ParticleField.vue
const PARTICLE_COUNT = 1500 // Half the particles
```

2. **Disable Custom Cursor on Mobile**
```vue
<!-- App.vue -->
<CustomCursor v-if="!isMobile" />
```

3. **Simplify Blur Effects**
```css
/* style.css */
.frosted-glass {
  backdrop-filter: blur(10px); /* Reduce from 20px */
}
```

### For High-End Devices

1. **Increase Particle Count**
```typescript
const PARTICLE_COUNT = 5000
```

2. **Add More Effects**
- Enable additional glow layers
- Increase blur radius
- Add more floating cards

## Keyboard Shortcuts

- `⌘K` / `Ctrl+K`: Open command palette
- `ESC`: Close command palette
- `↑` / `↓`: Navigate commands
- `Enter`: Execute selected command

## Building for Production

```bash
# Build the project
npm run build

# Preview production build
npm run preview
```

The built files will be in the `dist/` directory.

## Deployment

### Vercel
```bash
npm install -g vercel
vercel
```

### Netlify
```bash
npm install -g netlify-cli
netlify deploy
```

### GitHub Pages
```bash
npm run build
# Push dist/ folder to gh-pages branch
```

## Troubleshooting

### Issue: WebGL not working
**Solution**: Check browser compatibility and GPU acceleration

### Issue: Poor performance
**Solution**: Reduce particle count or disable effects on low-end devices

### Issue: Cursor not showing
**Solution**: Check if `cursor: none` is applied to body

### Issue: Build fails
**Solution**: Ensure Node.js version is 14+ and dependencies are installed

## Browser Support

| Browser | Version | Support |
|---------|---------|---------|
| Chrome  | 90+     | ✅ Full |
| Firefox | 88+     | ✅ Full |
| Safari  | 14+     | ✅ Full |
| Edge    | 90+     | ✅ Full |
| Opera   | 76+     | ✅ Full |

## Resources

- [Vue 3 Documentation](https://vuejs.org/)
- [Three.js Documentation](https://threejs.org/docs/)
- [GSAP Documentation](https://greensock.com/docs/)
- [Tailwind CSS](https://tailwindcss.com/docs)

## Support

For issues and questions:
- GitHub Issues: [Create an issue](https://github.com/yushenjian/portal/issues)
- Email: contact@yushenjian.com
- Twitter: [@yushenjian](https://twitter.com/yushenjian)

---

**Happy Coding! 🎉**
