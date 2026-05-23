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
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "elixir", "eelixir", "heex", "surface" },
  callback = function(ev)
    local current_file = vim.api.nvim_buf_get_name(ev.buf)
    local mix_match = vim.fs.find({ "mix.exs" }, { upward = true, path = current_file })[1]
    local root_dir
    if mix_match then
      root_dir = vim.fs.dirname(mix_match)
    elseif current_file ~= "" then
      root_dir = vim.fs.dirname(current_file)
    else
      root_dir = vim.fn.getcwd()
    end
    vim.lsp.start({
      name = "expert",
      cmd = { "expert", "--stdio" },
      root_dir = root_dir,
      settings = {},
    }, {
      bufnr = ev.buf,
    })
  end,
})
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
  end,
})
