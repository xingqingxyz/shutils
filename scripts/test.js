function test(ul) {
  let lstat = []
  for (const {
    children: [
      {
        children: [{ textContent }],
      },
    ],
  } of ul.children) {
    lstat.push(textContent)
  }
  return lstat
}
test(ul)
ul = document.querySelector('#_table_of_contents > ul > ul:nth-child(5)')
process.pl
