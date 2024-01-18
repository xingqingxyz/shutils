local api, fn, ts, lsp = vim.api, vim.fn, vim.treesitter, vim.lsp

-- api.nvim_create_autocmd('MouseHover',{callback=function()end})
local bufnr = api.nvim_create_buf(false, true)
api.nvim_open_win(bufnr, false, {
  relative = 'mouse',
  anchor = 'NW',
  row = 0,
  col = 0,
  width = 80,
  height = 3,
  style = 'minimal',
  border = { '0', { '-', 'hello' }, '1', '|', '2', '_', '3', '[' },
})
