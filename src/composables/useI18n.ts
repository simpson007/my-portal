import { ref, computed } from 'vue'

type Locale = 'zh' | 'en'

const messages = {
  zh: {
    profile: {
      name: '于沈健',
      title: '高级前端工程师',
      slogan: '代码即艺术。',
      description: '以热情和精准打造沉浸式数字体验。',
      specializing: '专注于',
      and: '和',
      openToWork: '✦ 开放工作机会',
      buildingCoolStuff: '⚡ 创造酷炫作品'
    },
    cards: {
      games: 'Games',
      gamesDesc: '互动实验项目',
      playNow: '立即体验',
      blog: 'Blog',
      blogDesc: '技术与开发思考',
      readMore: '阅读更多',
      tools: 'Tools',
      toolsDesc: '开发者实用工具',
      explore: '探索',
      connect: '联系方式'
    },
    social: {
      github: 'GitHub',
      twitter: 'Twitter',
      linkedin: 'LinkedIn',
      email: '邮箱'
    },
    command: {
      hint: '按下',
      forCommands: '打开命令面板'
    }
  },
  en: {
    profile: {
      name: 'Yu ShenJian',
      title: 'Senior Frontend Engineer',
      slogan: 'Code as Art.',
      description: 'Building immersive digital experiences with passion and precision.',
      specializing: 'Specializing in',
      and: 'and',
      openToWork: '✦ Open to Work',
      buildingCoolStuff: '⚡ Building Cool Stuff'
    },
    cards: {
      games: 'Games',
      gamesDesc: 'Interactive experiments',
      playNow: 'Play now',
      blog: 'Blog',
      blogDesc: 'Thoughts on tech and development',
      readMore: 'Read more',
      tools: 'Tools',
      toolsDesc: 'Developer utilities and boosters',
      explore: 'Explore',
      connect: 'Connect'
    },
    social: {
      github: 'GitHub',
      twitter: 'Twitter',
      linkedin: 'LinkedIn',
      email: 'Email'
    },
    command: {
      hint: 'Press',
      forCommands: 'for commands'
    }
  }
}

// 检测浏览器语言
function detectLocale(): Locale {
  const browserLang = navigator.language || (navigator as any).userLanguage
  return browserLang.startsWith('zh') ? 'zh' : 'en'
}

const currentLocale = ref<Locale>(detectLocale())

export function useI18n() {
  const t = computed(() => messages[currentLocale.value])
  
  const setLocale = (locale: Locale) => {
    currentLocale.value = locale
  }
  
  const toggleLocale = () => {
    currentLocale.value = currentLocale.value === 'zh' ? 'en' : 'zh'
  }
  
  return {
    locale: currentLocale,
    t,
    setLocale,
    toggleLocale
  }
}
