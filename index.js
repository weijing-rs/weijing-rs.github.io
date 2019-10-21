/* globals Docute */

new Docute({
  // 渲染md文档的div
  target: '#docute',
  darkThemeToggler:true,
  // md文档目录
  sourcePath: './docs/',
  // 导航栏
  nav: [
    {
      title: 'Home',
      link: '/'
    },
    {
      title: 'Contact',
      link: '/contact'
    }
  ],
  // 目录
  sidebar: [
    {
      title: 'Catalog',
      links: [
        {
          title: 'Education',
          link: '/education'
        },
        {
          title: 'Experience',
          link: '/experience'
        },
		{
          title: 'Papper',
          link: '/papper'
        },
				        {
          title: 'Reward',
          link: '/reward'
        },
		{
          title: 'Project',
          link: '/project'
        },
		{
          title: 'Production',
          link: '/production'
        }
      ]
    }
  ]
})
