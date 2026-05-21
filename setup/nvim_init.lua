vim.cmd("filetype plugin indent on")
vim.api.nvim_create_autocmd("FileType", {
  pattern = {"elixir", "heex", "eex"},
  callback = function() pcall(vim.treesitter.start) end
})
vim.pack.add({"https://github.com/echasnovski/mini.completion"})
require('mini.completion').setup({
  delay = { completion = 100, info = 100 },
  window = { info = { border = 'single' } }
})
vim.pack.add({"https://github.com/junegunn/fzf", "https://github.com/junegunn/fzf.vim"})
local osc52 = require('vim.ui.clipboard.osc52')
vim.g.clipboard = {
  name = 'OSC 52',
  copy = { ['+'] = osc52.copy('+'), ['*'] = osc52.copy('*'), },
  paste = { ['+'] = osc52.paste('+'), ['*'] = osc52.paste('*'), },
}
vim.api.nvim_create_autocmd('BufReadPost', {pattern='*', command='normal `"'})
vim.keymap.set({'n', 'i'}, '<s-cr>', '<esc>:w<cr>:term time `readlink -f %`<cr>')
vim.keymap.set('n', '<c-c>', ':bd<cr>')
vim.keymap.set('n', '<c-p>', ':FZF<cr>')
vim.keymap.set('n', '<tab>', ':Buffers<cr>')
vim.o.autoindent = true
vim.o.autowrite = true
vim.o.clipboard = "unnamed,unnamedplus"
vim.o.expandtab = true
vim.o.ignorecase = true
vim.o.mouse = ""
vim.o.shiftwidth = 2
vim.o.smartcase = true
vim.o.smartindent = true
vim.o.softtabstop = 2
vim.o.tabstop = 2
vim.o.wrap = false
