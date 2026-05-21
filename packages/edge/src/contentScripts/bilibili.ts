function setDark(enable: boolean) {
  console.log('theme changed to dark:', enable)
  if (location.href.startsWith('https://show.bilibili.com/platform/')) {
    document.body.classList[enable ? 'add' : 'remove']('theme-dark')
    document.body.classList[enable ? 'remove' : 'add']('theme-light')
    return
  }
  document.documentElement.classList[enable ? 'add' : 'remove']('bili_dark')
}

const media = matchMedia('(prefers-color-scheme: dark)')
setDark(media.matches)
media.addEventListener('change', (e) => setDark(e.matches))
