local utile = require("vimda.utile")

local keymaps = {
    { 'n', '<leader>w', '<cmd>write<cr>',               { desc = 'Save' } },
    { 'n', '<leader>q', '<cmd>quit<cr>',                { desc = 'Quit' } },
    -- { 'n', '<leader>e', '<cmd>Neotree source=last toggle=true<cr>', { desc = 'Open vim-tree' } },
    { 'n', '<leader>e', '<cmd>NvimTreeToggle<cr>',      { desc = 'Open Nvim-tree' } },
    { 'n', '<A-k>',     '<cmd>BufferLineCycleNext<cr>', { desc = 'Next buffer' } },
    { 'n', '<A-j>',     '<cmd>BufferLineCyclePrev<cr>', { desc = 'Previous buffer' } },
    { 'n', '<A-S-k>',   '<cmd>BufferLineMoveNext<cr>',  { desc = 'Move buffer to next' } },
    { 'n', '<A-S-j>',   '<cmd>BufferLineMovePrev<cr>',  { desc = 'Move  buffer to previous' } },
}

utile.set_keymaps(keymaps)
