return {
    "nvim-treesitter/nvim-treesitter",
    -- Automatically install missing parsers when entering buffer
    build = ":TSUpdate",
    opts = {
        auto_install = true,
        autopairs = {
            enable = true,
        },
    }
}
