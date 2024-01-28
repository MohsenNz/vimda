local icons = require("vimda.icons")

return {
    "nvim-neo-tree/neo-tree.nvim",
    lazy = false,
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
    },
    config = function()
        -- If you want icons for diagnostic errors, you'll need to define them somewhere:
        vim.fn.sign_define(
            "DiagnosticSignError",
            { text = icons.diagnostics.BoldError, texthl = "DiagnosticSignError" }
        )
        vim.fn.sign_define(
            "DiagnosticSignWarn",
            { text = icons.diagnostics.BoldWarning, texthl = "DiagnosticSignWarn" }
        )
        vim.fn.sign_define(
            "DiagnosticSignInfo",
            { text = icons.diagnostics.BoldInformation, texthl = "DiagnosticSignInfo" }
        )
        vim.fn.sign_define(
            "DiagnosticSignHint",
            { text = icons.diagnostics.BoldHint, texthl = "DiagnosticSignHint" }
        )
        require("neo-tree").setup(
            {
                default_component_configs = {
                    container = {
                        enable_character_fade = true
                    },
                    indent = {
                        indent_size = 2,
                        padding = 1, -- extra padding on left hand side
                        -- indent guides
                        with_markers = true,
                        indent_marker = "│",
                        last_indent_marker = "└",
                        highlight = "NeoTreeIndentMarker",
                        -- expander config, needed for nesting files
                        with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
                        expander_collapsed = "",
                        expander_expanded = "",
                        expander_highlight = "NeoTreeExpander",
                    },
                    icon = {
                        folder_closed = icons.ui.Folder,
                        folder_open = icons.ui.FolderOpen,
                        folder_empty = icons.ui.EmptyFolder,
                        -- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
                        -- then these will never be used.
                        default = "*",
                        highlight = "NeoTreeFileIcon"
                    },
                    modified = {
                        symbol = "[+]",
                        highlight = "NeoTreeModified",
                    },
                    name = {
                        trailing_slash = false,
                        use_git_status_colors = true,
                        highlight = "NeoTreeFileName",
                    },
                    git_status = {
                        symbols = {
                            -- Change type
                            added     = "",                    -- or icons.git.LineAdded, but this is redundant info if you use git_status_colors on the name
                            modified  = "",                    -- or icons.git.LineModified, but this is redundant info if you use git_status_colors on the name
                            deleted   = icons.git.FileDeleted, -- this can only be used in the git_status source
                            renamed   = icons.git.FileRenamed, -- this can only be used in the git_status source
                            -- Status type
                            untracked = icons.git.FileUntracked,
                            ignored   = icons.git.FileIgnored,
                            unstaged  = icons.git.FileUnstaged,
                            staged    = icons.git.FileStaged,
                            conflict  = icons.git.FileUnmerged,
                        }
                    },
                    -- If you don't want to use these columns, you can set `enabled = false` for each of them individually
                    file_size = {
                        enabled = true,
                        required_width = 64, -- min width of window required to show this column
                    },
                    type = {
                        enabled = true,
                        required_width = 122, -- min width of window required to show this column
                    },
                    last_modified = {
                        enabled = true,
                        required_width = 88, -- min width of window required to show this column
                    },
                    created = {
                        enabled = true,
                        required_width = 110, -- min width of window required to show this column
                    },
                    symlink_target = {
                        enabled = false,
                    },
                },
                window = {
                    position = "right",
                    width = 35,
                    mappings = {
                        ["t"] = "", -- disable "open_tabnew",
                        ["l"] = "open",
                        ["h"] = "close_node",
                        ["a"] = {
                            "add",
                            config = {
                                show_path = "absolute" -- "none", "relative", "absolute"
                            }
                        },
                        ["c"] = {
                            "copy",
                            config = {
                                show_path = "absolute" -- "none", "relative", "absolute"
                            }
                        },
                        ["<"] = "", -- disable for "prev_source"
                        [">"] = "", -- disable for "next_source"
                        ["<A-j>"] = "prev_source",
                        ["<A-k>"] = "next_source",
                    },
                },
                filesystem = {
                    always_show = { -- remains visible even if other settings would normally hide it
                        --".gitignored",
                    },
                    follow_current_file = {
                        enabled = true,          -- This will find and focus the file in the active buffer every time
                        --                       -- the current file is changed while the tree is open.
                        leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
                    },
                },
                git_status = {
                    window = {
                        mappings = {
                            ["A"]  = "", -- disable "git_add_all",
                            ["gu"] = "", -- disable "git_unstage_file",
                            ["ga"] = "", -- disable "git_add_file",
                            ["gr"] = "", -- disable "git_revert_file",
                            ["gc"] = "", -- disable "git_commit",
                            ["gp"] = "", -- disable "git_push",
                            ["gg"] = "", -- disable "git_commit_and_push",
                        }
                    }
                },
                source_selector = {
                    winbar = true, -- toggle to show selector on winbar
                    statusline = false, -- toggle to show selector on statusline
                    show_scrolled_off_parent_node = false, -- boolean
                    sources = { -- table
                        {
                            source = "filesystem", -- string
                            display_name = " Files" -- string | nil
                        },
                        -- {
                        --     source = "buffers", -- string
                        --     display_name = " 󰈚 Buffers " -- string | nil
                        -- },
                        {
                            source = "git_status", -- string
                            display_name = "󰊢 Git" -- string | nil
                        },
                    },
                    content_layout = "center", -- string
                    tabs_layout = "equal", -- string
                    truncation_character = "…", -- string
                    tabs_min_width = nil, -- int | nil
                    tabs_max_width = nil, -- int | nil
                    padding = 1, -- int | { left: int, right: int }
                    -- separator = { left = "▏", right = "▕" }, -- string | { left: string, right: string, override: string | nil }
                    separator_active = nil, -- string | { left: string, right: string, override: string | nil } | nil
                    show_separator_on_edge = false, -- boolean
                    highlight_tab = "NeoTreeNormalNC", --"NeoTreeNormalNC", -- string
                    highlight_tab_active = "NeoTreeNormal", --"NeoTreeNormal", -- string
                    highlight_background = "NeoTreeNormalNC", -- string
                    highlight_separator = "NeoTreeNormalNC", -- string
                    highlight_separator_active = "NeoTreeNormalNC", -- string
                },
            }
        )
    end
}
