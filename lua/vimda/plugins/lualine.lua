local icons = require("vimda.icons")

local function fileinfo()
    local icon = " 󰈚 "
    local path = vim.api.nvim_buf_get_name(0)
    local name = (path == "" and "Empty ") or path:match "^.+[/\\](.+)$"

    if name ~= "Empty " then
        local devicons_present, devicons = pcall(require, "nvim-web-devicons")

        if devicons_present then
            local ft_icon = devicons.get_icon(name)
            icon = (ft_icon ~= nil and " " .. ft_icon) or ""
        end

        name = " " .. name .. " "
    end

    return icon .. name
end

local branch = {
    'branch',
    icon = icons.git.Branch,
    color = { gui = "bold" },
}

local shiftwidth = {
    function()
        local shiftwidth = vim.api.nvim_buf_get_option(0, "shiftwidth")
        return icons.ui.Tab .. " " .. shiftwidth
    end,
    padding = 1,
}

local diff = {
    "diff",
    symbols = {
        added = icons.git.LineAdded .. " ",
        modified = icons.git.LineModified .. " ",
        removed = icons.git.LineRemoved .. " ",
    },
    padding = { left = 2, right = 1 },
    cond = nil,
}

local diagnostics = {
    "diagnostics",
    sources = { "nvim_diagnostic" },
    symbols = {
        error = icons.diagnostics.Error .. " ",
        warn = icons.diagnostics.Warning .. " ",
        info = icons.diagnostics.Information .. " ",
        hint = icons.diagnostics.Hint .. " ",
    },
    -- cond = conditions.hide_in_width,
}

local sections = {
    lualine_a = {
        function()
            return icons.ui.Target
        end,
    },
    lualine_b = {
        branch
    },
    lualine_c = { fileinfo },
    lualine_x = {
        diff,
        diagnostics,
        shiftwidth,
        -- TODO
        -- "require'lsp-status'.status()",
    },
    lualine_y = { 'location' },
    lualine_z = { "%P/%L" }
}

-- TODO
-- local python_env = {
--     function()
--         local utils = require "lvim.core.lualine.utils"
--         if vim.bo.filetype == "python" then
--             local venv = os.getenv "CONDA_DEFAULT_ENV" or os.getenv "VIRTUAL_ENV"
--             if venv then
--                 local icons = require "nvim-web-devicons"
--                 local py_icon, _ = icons.get_icon ".py"
--                 return string.format(" " .. py_icon .. " (%s)", utils.env_cleanup(venv))
--             end
--         end
--         return ""
--     end,
--     color = { fg = colors.green },
--     cond = conditions.hide_in_width,
-- }

return {
    'nvim-lualine/lualine.nvim',
    opts = {
        options = {
            icons_enabled = true,
            theme = 'auto',
            component_separators = { left = '', right = '' },
            section_separators = { left = '', right = '' },
            disabled_filetypes = {
                statusline = {},
                winbar = {},
            },
            ignore_focus = {},
            always_divide_middle = true,
            globalstatus = true,
            refresh = {
                statusline = 1000,
                tabline = 1000,
                winbar = 1000,
            }
        },
        sections = sections,
        inactive_sections = sections,
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {}
    },
}
