vim.g.mapleader = " "
vim.keymap.set("n", "<leader>cd", vim.cmd.Ex)


-- Window splits (add to your init.lua or a keymaps file)
vim.keymap.set('n', '<leader>sv', '<C-w>v', { desc = 'Split vertically' })
vim.keymap.set('n', '<leader>sh', '<C-w>s', { desc = 'Split horizontally' })
vim.keymap.set('n', '<leader>se', '<C-w>=', { desc = 'Make splits equal size' })
vim.keymap.set('n', '<leader>sx', '<cmd>close<CR>', { desc = 'Close current split' })

-- Better window navigation
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Move to left window' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Move to right window' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Move to bottom window' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Move to top window' })




-- Compare current buffer with clipboard
vim.keymap.set('n', '<leader>dc', function()
    vim.cmd('vnew')
    vim.cmd('normal! "+P')
    vim.cmd('diffthis')
    vim.cmd('wincmd p')
    vim.cmd('diffthis')
end, { desc = 'Diff with clipboard' })

-- Exit diff mode
vim.keymap.set('n', '<leader>do', ':diffoff!<CR>', { desc = 'Diff off' })

-- Close quickfix / location list
vim.keymap.set('n', '<leader>q', ':cclose<CR>', { desc = 'Close quickfix' })
