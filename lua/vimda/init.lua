local utile = require("vimda.utile")

local lazy = {
    path = vim.fn.stdpath('data') .. '/lazy/lazy.nvim',
    opts = {
        defaults = {
            lazy = false
        },
        install = {
            -- try to load one of these colorschemes when starting an installation during startup
            colorscheme = { "folke/tokyonight.nvim" },
        },
    },
    plugins = utile.concat_tables(
        {
            require("vimda.plugins.lualine"),
            require("vimda.plugins.bufferline"),
            require("vimda.plugins.nvim-tree"),        -- File explorer
            require("vimda.plugins.nvim-treesitter"),  -- Syntax highlighting
            require("vimda.plugins.indent-blankline"), -- Indentation line indicator
            require("vimda.plugins.nvim-autopairs"),
            require("vimda.plugins.nvim-lspconfig"),
            -- require("vimda.plugins.nvim-cmp"),
            -- require("vimda.plugins.nvim-navic"), -- Symbol navigation
            -- require("vimda.plugins.none-ls"),    -- Bridge between Neovim and None-lsp external apps
            require("vimda.plugins.plenary"),  -- Debugging
            require("vimda.plugins.nvim-dap"), -- Debugging

            require("vimda.plugins.language-specific.rust-tools")
        },
        require("vimda.colorschemes")
    )
}

utile.lazy.init(lazy)

require("vimda.options")
require("vimda.keymaps")
require("vimda.autocmds")
require("vimda.commands")
