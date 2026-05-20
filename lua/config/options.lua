vim.opt.number = true
vim.opt.cursorline = true
vim.opt.relativenumber = true
vim.opt.shiftwidth = 2
vim.opt.clipboard = "unnamedplus"

-- project-local .nvim.lua auto-sourcing (secure trust prompt on first use)
vim.opt.exrc = true

-- Ghostty window title: uses vim.g.project_name if set by .nvim.lua, else folder name
vim.opt.title = true
vim.opt.titlestring = '%{get(g:, "project_name", fnamemodify(getcwd(), ":t"))} — nvim'
