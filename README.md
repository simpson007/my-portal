# Yu ShenJian - Digital Garden Portal 🌿✨

An immersive, high-performance personal landing page showcasing WebGL mastery and modern UI design. Built with Vue 3, Three.js, and cutting-edge web technologies.

## 🎨 Design Philosophy

**"Show, Don't Tell"** - This isn't just a portfolio; it's a living demonstration of technical artistry.

### Key Features

- **🌊 Flow Field Background**: Real-time WebGL particle system with mouse interaction
- **🎭 Glassmorphism 2.0**: Enhanced frosted glass effects with noise textures
- **✨ Asymmetric Floating Layout**: Zero-gravity cards with independent floating animations
- **🎯 Spotlight Border Effect**: Dynamic radial gradient tracking mouse position
- **⚡ Glitch Text Effect**: Cyberpunk-style decoding animation on hover
- **🖱️ Custom Magnetic Cursor**: Interactive ring cursor with magnetic attraction
- **🎪 Micro-interactions**: Polished hover states and smooth transitions

## 🛠️ Tech Stack

- **Vue 3** (Composition API) - Reactive framework
- **Three.js** - WebGL rendering and particle systems
- **GSAP** - Smooth entrance animations
- **Tailwind CSS** - Utility-first styling
- **TypeScript** - Type safety
- **Vite** - Lightning-fast build tool

## 🎨 Color Palette

```css
Deep Cyberpunk Teal: #0f172a
Neon Green: #10b981
Accent Teal: #14b8a6
Cyber Blue: #06b6d4
Dark Base: #0a0a0f
```

## 🚀 Getting Started

```bash
# Install dependencies
npm install

# Start development server
npm run dev

# Build for production
npm run build

# Preview production build
npm run preview
```

## 📁 Project Structure

```
src/
├── components/
│   ├── core/
│   │   ├── CustomCursor.vue      # Magnetic ring cursor
│   │   ├── FloatingCard.vue      # Glassmorphism cards with spotlight
│   │   ├── GlitchText.vue        # Cyberpunk text effect
│   │   └── MagneticBtn.vue       # Interactive buttons
│   ├── visual/
│   │   ├── ParticleField.vue     # WebGL flow field
│   │   └── ShaderBg.vue          # Shader background
│   └── CommandPalette.vue        # Cmd+K command interface
├── config/
│   └── portals.ts                # Content configuration
├── assets/
│   └── shaders/
│       └── flowField.glsl        # GLSL shader code
└── App.vue                       # Main application
```

## 🎯 Performance Optimizations

- **Lazy Loading**: Components load on demand
- **GPU Acceleration**: Hardware-accelerated transforms
- **Debounced Events**: Optimized mouse tracking
- **Efficient Rendering**: RequestAnimationFrame for smooth 60fps
- **Minimal Bundle**: Tree-shaking and code splitting

## 🎨 Design Highlights

### 1. WebGL Flow Field
- 3000+ particles with simplex noise
- Mouse repulsion interaction
- Depth-based color gradients
- Optimized shader performance

### 2. Glassmorphism 2.0
- 20px backdrop blur
- Noise texture overlay
- Dynamic spotlight borders
- Subtle floating animations

### 3. Micro-interactions
- Magnetic button effects
- Glitch text on hover
- Smooth card transitions
- Custom cursor feedback

## 🎮 Interactive Elements

- **⌘K**: Open command palette
- **Hover**: Activate spotlight effects
- **Mouse Movement**: Particle repulsion and cursor tracking
- **Click**: Magnetic button feedback

## 📱 Responsive Design

Fully responsive across all devices:
- Desktop: Full WebGL effects
- Tablet: Optimized particle count
- Mobile: Touch-friendly, reduced effects

## 🌟 Browser Support

- Chrome/Edge 90+
- Firefox 88+
- Safari 14+
- Opera 76+

## 📄 License

MIT License - Feel free to use this as inspiration for your own projects!

## 🤝 Credits

Designed and developed by **Yu ShenJian**
- Portfolio: [yushenjian.com](https://yushenjian.com)
- GitHub: [@yushenjian](https://github.com/yushenjian)
- Twitter: [@yushenjian](https://twitter.com/yushenjian)

---

**Built with ❤️ and lots of ☕**
