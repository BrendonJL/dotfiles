-- Enable relative line numbers (helpful for vim motions)
vim.opt.relativenumber = true

-- Better mouse support
vim.opt.mouse = "a"

-- System clipboard integration
vim.opt.clipboard = "unnamedplus"

-- Nicer cursor line
vim.opt.cursorline = true

-- Double-click enters insert mode
vim.keymap.set("n", "<2-LeftMouse>", "<LeftMouse>a")

vim.g.lazyvim_lint_exclude = { "markdown" }

-- Better text wrapping
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakindent = true

-- Disable popup menu transparency (fixes blink.cmp background gaps)
vim.opt.pumblend = 0
vim.opt.winblend = 0

-- Always show sign column for diagnostics
vim.opt.signcolumn = "yes"

