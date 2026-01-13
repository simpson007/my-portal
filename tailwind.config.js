/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{vue,js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        'glass': {
          'dark': 'rgba(0, 0, 0, 0.3)',
          'border': 'rgba(255, 255, 255, 0.1)',
        },
      },
      fontFamily: {
        'sans': ['Inter', 'ui-sans-serif', 'system-ui', 'sans-serif'],
        'display': ['Playfair Display', 'Georgia', 'serif'],
      },
      animation: {
        'float-gentle': 'floatGentle 8s ease-in-out infinite',
      },
      keyframes: {
        floatGentle: {
          '0%, 100%': { transform: 'translateY(0)' },
          '50%': { transform: 'translateY(-6px)' }
        },
      },
      backdropBlur: {
        '3xl': '64px',
      },
      boxShadow: {
        'glass': '0 8px 32px rgba(0, 0, 0, 0.3)',
        'glass-hover': '0 16px 48px rgba(0, 0, 0, 0.4)',
      },
    },
  },
  plugins: [],
}
