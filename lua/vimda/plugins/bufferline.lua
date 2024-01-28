local icons = require("vimda.icons")

return {
    'akinsho/bufferline.nvim',
    -- version = "*",
    branch = "main",
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
        vim.opt.termguicolors = true
        vim.opt.mousemoveevent = true
        local bufferline = require('bufferline')
        bufferline.setup({
            options = {
                mode = "buffers",                               -- set to "tabs" to only show tabpages instead
                sources = { "filesystem", "git_status" },       --  filesystem, buffers, git_status, document_symbols
                style_preset = bufferline.style_preset.minimal, -- default | minimal
                numbers = "none",                               -- can be "none" | "ordinal" | "buffer_id" | "both" | function
                -- close_command = function(bufnr)                 -- can be a string | function, see "Mouse actions"
                --     buf_kill("bd", bufnr, false)
                -- end,
                right_mouse_command = "vert sbuffer %d", -- can be a string | function, see "Mouse actions"
                left_mouse_command = "buffer %d",        -- can be a string | function, see "Mouse actions"
                middle_mouse_command = nil,              -- can be a string | function, see "Mouse actions"
                indicator = {
                    icon = icons.ui.BoldLineLeft,        -- this should be omitted if indicator style is not 'icon'
                    style = "icon",                      -- can also be 'underline'|'none',
                },
                buffer_close_icon = icons.ui.Close,
                modified_icon = icons.ui.Circle,
                close_icon = icons.ui.BoldClose,
                left_trunc_marker = icons.ui.ArrowCircleLeft,
                right_trunc_marker = icons.ui.ArrowCircleRight,
                -- name_formatter can be used to change the buffer's label in the bufferline.
                -- Please note some names can/will break the
                -- bufferline so use this at your discretion knowing that it has
                -- some limitations that will *NOT* be fixed.
                name_formatter = function(buf) -- buf contains a "name", "path" and "bufnr"
                    -- remove extension from markdown files for example
                    if buf.name:match "%.md" then
                        return vim.fn.fnamemodify(buf.name, ":t:r")
                    end
                end,
                max_name_length = 12,
                max_prefix_length = 10, -- prefix used when a buffer is de-duplicated
                truncate_names = true,  -- whether or not tab names should be truncated
                tab_size = 12,
                diagnostics = "nvim_lsp",
                diagnostics_update_in_insert = false,
                diagnostics_indicator = function(_, _, diagnostics, _)
                    local result_table = {}
                    local symbols = {
                        error = icons.diagnostics.Error,
                        warning = icons.diagnostics.Warning,
                        info = icons.diagnostics.Information,
                    }
                    for name, count in pairs(diagnostics) do
                        if symbols[name] and count > 0 then
                            table.insert(result_table, symbols[name] .. " " .. count)
                        end
                    end
                    local result_str = table.concat(result_table, " ")
                    return #result_str > 0 and result_str or ""
                end,
                -- NOTE: this will be called a lot so don't do any heavy processing here
                custom_filter = function(buf, buf_nums)
                    local logs = vim.tbl_filter(function(b)
                        return vim.bo[b].filetype == "log"
                    end, buf_nums or {})
                    if vim.tbl_isempty(logs) then
                        return true
                    end
                    local tab_num = vim.fn.tabpagenr()
                    local last_tab = vim.fn.tabpagenr "$"
                    local is_log = vim.bo[buf].filetype == "log"
                    if last_tab == 1 then
                        return true
                    end
                    -- only show log buffers in secondary tabs
                    return (tab_num == last_tab and is_log) or (tab_num ~= last_tab and not is_log)
                end,
                offsets = {
                    {
                        filetype = "neo-tree",
                        text = "Neo-tree",
                        -- text = function()
                        --     return vim.fn.getcwd()
                        -- end,
                        highlight = "NeoTreeNormal",
                        padding = 0,
                        separator = false
                    },
                    {
                        filetype = "NvimTree",
                        text = "Nvim-tree",
                        -- text = function()
                        --     return vim.fn.getcwd()
                        -- end,
                        highlight = "NeoTreeNormal",
                        padding = 0,
                        separator = true
                    },
                    {
                        filetype = "undotree",
                        text = "Undotree",
                        highlight = "PanelHeading",
                        padding = 1,
                    },
                    {
                        filetype = "DiffviewFiles",
                        text = "Diff View",
                        highlight = "PanelHeading",
                        padding = 1,
                    },
                    {
                        filetype = "flutterToolsOutline",
                        text = "Flutter Outline",
                        highlight = "PanelHeading",
                    },
                    {
                        filetype = "lazy",
                        text = "Lazy",
                        highlight = "PanelHeading",
                        padding = 1,
                    },
                },
                color_icons = true,        -- whether or not to add the filetype icon highlights
                show_buffer_icons = false, -- disable filetype icons for buffers
                show_buffer_close_icons = true,
                show_close_icon = false,
                show_tab_indicators = true,
                persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
                -- can also be a table containing 2 custom separators
                -- [focused and unfocused]. eg: { '|', '|' }
                separator_style = "thin",
                enforce_regular_tabs = false,
                always_show_bufferline = false,
                hover = {
                    enabled = true, -- requires nvim 0.8+
                    delay = 200,
                    reveal = { "close" },
                },
                sort_by = "id",
            },
            -- highlights = {
            --     buffer_selected = {
            --         -- fg = '<colour-value-here>',
            --         -- bg = '<colour-value-here>',
            --         bold = true,
            --         italic = false,
            --         underline = false,
            --     },
            --     tab_separator_selected = {
            --         -- fg = '<colour-value-here>',
            --         -- bg = '<colour-value-here>',
            --         -- sp = '<colour-value-here>',
            --         underline = 'Pmenu',
            --     },
            --     fill = {
            --         fg = { attribute = "fg", highlight = "Visual" },
            --         bg = { attribute = "bg", highlight = "TabLine" },
            --     },
            --     background = {
            --         fg = { attribute = "fg", highlight = "TabLine" },
            --         bg = { attribute = "bg", highlight = "TabLine" },
            --     },

            --     buffer_visible = {
            --         fg = { attribute = "fg", highlight = "TabLine" },
            --         bg = { attribute = "bg", highlight = "TabLine" },
            --     },

            --     close_button = {
            --         fg = { attribute = "fg", highlight = "TabLine" },
            --         bg = { attribute = "bg", highlight = "TabLine" },
            --     },
            --     close_button_visible = {
            --         fg = { attribute = "fg", highlight = "TabLine" },
            --         bg = { attribute = "bg", highlight = "TabLine" },
            --     },
            --     -- close_button_selected = {
            --     --   fg = {attribute='fg',highlight='TabLineSel'},
            --     --   bg ={attribute='bg',highlight='TabLineSel'}
            --     --   },

            --     tab_selected = {
            --         fg = { attribute = "fg", highlight = "Normal" },
            --         bg = { attribute = "bg", highlight = "Normal" },
            --     },
            --     tab = {
            --         fg = { attribute = "fg", highlight = "TabLine" },
            --         bg = { attribute = "bg", highlight = "TabLine" },
            --     },
            --     tab_close = {
            --         -- fg = {attribute='fg',highlight='LspDiagnosticsDefaultError'},
            --         fg = { attribute = "fg", highlight = "TabLineSel" },
            --         bg = { attribute = "bg", highlight = "Normal" },
            --     },

            --     duplicate_selected = {
            --         fg = { attribute = "fg", highlight = "TabLineSel" },
            --         bg = { attribute = "bg", highlight = "TabLineSel" },
            --         underline = true,
            --     },
            --     duplicate_visible = {
            --         fg = { attribute = "fg", highlight = "TabLine" },
            --         bg = { attribute = "bg", highlight = "TabLine" },
            --         underline = true,
            --     },
            --     duplicate = {
            --         fg = { attribute = "fg", highlight = "TabLine" },
            --         bg = { attribute = "bg", highlight = "TabLine" },
            --         underline = true,
            --     },

            --     modified = {
            --         fg = { attribute = "fg", highlight = "TabLine" },
            --         bg = { attribute = "bg", highlight = "TabLine" },
            --     },
            --     modified_selected = {
            --         fg = { attribute = "fg", highlight = "Normal" },
            --         bg = { attribute = "bg", highlight = "Normal" },
            --     },
            --     modified_visible = {
            --         fg = { attribute = "fg", highlight = "TabLine" },
            --         bg = { attribute = "bg", highlight = "TabLine" },
            --     },

            --     separator = {
            --         fg = { attribute = "bg", highlight = "TabLine" },
            --         bg = { attribute = "bg", highlight = "TabLine" },
            --     },
            --     separator_selected = {
            --         fg = { attribute = "bg", highlight = "Normal" },
            --         bg = { attribute = "bg", highlight = "Normal" },
            --     },
            --     -- separator_visible = {
            --     --   fg = {attribute='bg',highlight='TabLine'},
            --     --   bg = {attribute='bg',highlight='TabLine'}
            --     --   },
            --     indicator_selected = {
            --         fg = { attribute = "fg", highlight = "LspDiagnosticsDefaultHint" },
            --         bg = { attribute = "bg", highlight = "Normal" },
            --     },
            -- },
        })
    end
}


-- local function buf_kill(kill_command, bufnr, force)
--     kill_command = kill_command or "bd"

--     local bo = vim.bo
--     local api = vim.api
--     local fmt = string.format
--     local fn = vim.fn

--     if bufnr == 0 or bufnr == nil then
--         bufnr = api.nvim_get_current_buf()
--     end

--     local bufname = api.nvim_buf_get_name(bufnr)

--     if not force then
--         local choice
--         if bo[bufnr].modified then
--             choice = fn.confirm(fmt([[Save changes to "%s"?]], bufname), "&Yes\n&No\n&Cancel")
--             if choice == 1 then
--                 vim.api.nvim_buf_call(bufnr, function()
--                     vim.cmd("w")
--                 end)
--             elseif choice == 2 then
--                 force = true
--             else
--                 return
--             end
--         elseif api.nvim_buf_get_option(bufnr, "buftype") == "terminal" then
--             choice = fn.confirm(fmt([[Close "%s"?]], bufname), "&Yes\n&No\n&Cancel")
--             if choice == 1 then
--                 force = true
--             else
--                 return
--             end
--         end
--     end

--     -- Get list of windows IDs with the buffer to close
--     local windows = vim.tbl_filter(function(win)
--         return api.nvim_win_get_buf(win) == bufnr
--     end, api.nvim_list_wins())

--     if force then
--         kill_command = kill_command .. "!"
--     end

--     -- Get list of active buffers
--     local buffers = vim.tbl_filter(function(buf)
--         return api.nvim_buf_is_valid(buf) and bo[buf].buflisted
--     end, api.nvim_list_bufs())

--     -- If there is only one buffer (which has to be the current one), vim will
--     -- create a new buffer on :bd.
--     -- For more than one buffer, pick the previous buffer (wrapping around if necessary)
--     if #buffers > 1 and #windows > 0 then
--         for i, v in ipairs(buffers) do
--             if v == bufnr then
--                 local prev_buf_idx = i == 1 and #buffers or (i - 1)
--                 local prev_buffer = buffers[prev_buf_idx]
--                 for _, win in ipairs(windows) do
--                     api.nvim_win_set_buf(win, prev_buffer)
--                 end
--             end
--         end
--     end

--     -- Check if buffer still exists, to ensure the target buffer wasn't killed
--     -- due to options like bufhidden=wipe.
--     if api.nvim_buf_is_valid(bufnr) and bo[bufnr].buflisted then
--         vim.cmd(string.format("%s %d", kill_command, bufnr))
--     end
-- end
