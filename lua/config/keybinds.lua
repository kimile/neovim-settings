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
    -- Create a new vertical split
    vim.cmd('vnew')
    -- Mark this buffer as the clipboard diff buffer
    vim.b.is_clipboard_diff = true
    -- Ensure it's a scratch buffer so it doesn't prompt on close
    vim.bo.buftype = 'nofile'
    vim.bo.bufhidden = 'wipe'
    vim.bo.swapfile = false
    -- Paste clipboard contents
    vim.cmd('normal! "+P')
    -- Start diff mode here
    vim.cmd('diffthis')
    -- Go back to the original window
    vim.cmd('wincmd p')
    -- Start diff mode on the original window
    vim.cmd('diffthis')
end, { desc = 'Diff with clipboard' })

-- Exit diff mode and close the clipboard split
vim.keymap.set('n', '<leader>dx', function()
    -- Turn off diff mode for all windows
    vim.cmd('diffoff!')
    -- Find and close the clipboard diff window if it exists
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        local success, is_diff = pcall(vim.api.nvim_buf_get_var, buf, 'is_clipboard_diff')
        if success and is_diff then
            vim.api.nvim_win_close(win, true)
            break
        end
    end
end, { desc = 'Exit diff mode & close split' })

-- Close quickfix / location list
vim.keymap.set('n', '<leader>q', ':cclose<CR>', { desc = 'Close quickfix' })
