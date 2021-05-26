import skills from './skills.json'

export function skillFinder (query) {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      const results = skills.filter((element, index, array) => {
        return element.name.toLowerCase().includes(query.toLowerCase())
      })
      resolve(results)
    }, 1000)
  })
}