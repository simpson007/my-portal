export interface Portal {
  id: string
  title: string
  description: string
  icon?: string
  href: string
  color: string
  gridClass: string
  size: 'small' | 'medium' | 'large'
}

export const portals: Portal[] = [
  {
    id: 'profile',
    title: 'Yu ShenJian',
    description: 'Senior Frontend Engineer | Code as Art',
    href: '#',
    color: 'from-green-500 to-emerald-600',
    gridClass: 'col-span-2 row-span-2',
    size: 'large'
  },
  {
    id: 'blog',
    title: 'Blog',
    description: 'Thoughts on tech & development',
    href: 'https://blog.yushenjian.com',
    color: 'from-blue-500 to-cyan-600',
    gridClass: 'col-span-1 row-span-1',
    size: 'medium'
  },
  {
    id: 'games',
    title: 'Games',
    description: 'Interactive experiments',
    href: '#games',
    color: 'from-purple-500 to-pink-600',
    gridClass: 'col-span-1 row-span-1',
    size: 'medium'
  },
  {
    id: 'tools',
    title: 'Tools',
    description: 'Developer utilities',
    href: '#tools',
    color: 'from-orange-500 to-red-600',
    gridClass: 'col-span-1 row-span-1',
    size: 'medium'
  },
  {
    id: 'contact',
    title: 'Connect',
    description: 'Get in touch',
    href: '#contact',
    color: 'from-gray-600 to-gray-800',
    gridClass: 'col-span-1 row-span-1',
    size: 'small'
  }
]

export const socialLinks = [
  {
    name: 'GitHub',
    href: 'https://github.com/yushenjian',
    icon: 'github'
  },
  {
    name: 'Twitter',
    href: 'https://twitter.com/yushenjian',
    icon: 'twitter'
  },
  {
    name: 'LinkedIn',
    href: 'https://linkedin.com/in/yushenjian',
    icon: 'linkedin'
  },
  {
    name: 'Email',
    href: 'mailto:contact@yushenjian.com',
    icon: 'email'
  }
]

export const commands = [
  {
    id: 'blog',
    title: 'Go to Blog',
    icon: '📝',
    handler: () => window.location.href = 'https://blog.yushenjian.com'
  },
  {
    id: 'games',
    title: 'View Games',
    icon: '🎮',
    handler: () => window.location.href = '#games'
  },
  {
    id: 'tools',
    title: 'Open Tools',
    icon: '🔧',
    handler: () => window.location.href = '#tools'
  },
  {
    id: 'github',
    title: 'Visit GitHub',
    icon: '🐙',
    handler: () => window.open('https://github.com/yushenjian', '_blank')
  },
  {
    id: 'theme',
    title: 'Toggle Theme',
    icon: '🌓',
    handler: () => {
      document.documentElement.classList.toggle('dark')
    }
  }
]