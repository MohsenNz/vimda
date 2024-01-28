local M = {}
M.lazy = {}

local function install_lazy(path)
    if not vim.loop.fs_stat(path) then
        print('Installing lazy.nvim....')
        vim.fn.system({
            'git',
            'clone',
            '--filter=blob:none',
            'https://github.com/folke/lazy.nvim.git',
            '--branch=stable', -- latest stable release
            path,
        })
    end
    vim.opt.rtp:prepend(path)
end

function M.lazy.init(lazy)
    install_lazy(lazy.path)
    require('lazy').setup(lazy.plugins, lazy.opts)
end

function M.concat_tables(tbl1, tbl2)
    for _, value in ipairs(tbl2) do
        table.insert(tbl1, value)
    end
    return tbl1
end

function M.map_ipairs(list, f)
    local new_list = {}
    for i, v in ipairs(list) do
        table.insert(new_list, f(i, v))
    end
    return new_list
end

function M.map_pairs(list, f)
    local new_list = {}
    for k, v in pairs(list) do
        table.insert(new_list, f(k, v))
    end
    return new_list
end

function M.set_keymaps(keymaps)
    for _, keymap in ipairs(keymaps) do
        local mode, lhs, rhs, opts = unpack(keymap)
        vim.keymap.set(mode, lhs, rhs, opts)
    end
end

function M.get_lua_file_names_no_extension(path)
    local files = {}
    -- iterate over all files in the directory
    for file in io.popen("ls " .. path .. "/*.lua"):lines() do
        -- remove the ".lua" extension from the file name
        local x = file:gsub("%.lua$", "")
        local y = x:sub(#path + 2)
        table.insert(files, y)
    end
    return files
end

function M.setup_document_highlight(client, bufnr)
    local status_ok, highlight_supported = pcall(function()
        return client.supports_method "textDocument/documentHighlight"
    end)
    if not status_ok or not highlight_supported then
        return
    end
    local group = "lsp_document_highlight"
    local hl_events = { "CursorHold", "CursorHoldI" }

    local ok, hl_autocmds = pcall(vim.api.nvim_get_autocmds, {
        group = group,
        buffer = bufnr,
        event = hl_events,
    })

    if ok and #hl_autocmds > 0 then
        return
    end

    vim.api.nvim_create_augroup(group, { clear = false })
    vim.api.nvim_create_autocmd(hl_events, {
        group = group,
        buffer = bufnr,
        callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd("CursorMoved", {
        group = group,
        buffer = bufnr,
        callback = vim.lsp.buf.clear_references,
    })
end

function M.setup_codelens_refresh(client, bufnr)
    local status_ok, codelens_supported = pcall(function()
        return client.supports_method "textDocument/codeLens"
    end)
    if not status_ok or not codelens_supported then
        return
    end
    local group = "lsp_code_lens_refresh"
    local cl_events = { "BufEnter", "InsertLeave" }
    local ok, cl_autocmds = pcall(vim.api.nvim_get_autocmds, {
        group = group,
        buffer = bufnr,
        event = cl_events,
    })

    if ok and #cl_autocmds > 0 then
        return
    end
    vim.api.nvim_create_augroup(group, { clear = false })
    vim.api.nvim_create_autocmd(cl_events, {
        group = group,
        buffer = bufnr,
        callback = vim.lsp.codelens.refresh,
    })
end

--- Clean autocommand in a group if it exists
--- This is safer than trying to delete the augroup itself
---@param name string the augroup name
function M.clear_augroup(name)
    -- defer the function in case the autocommand is still in-use
    -- TODO: log
    -- Log:debug("request to clear autocmds  " .. name)
    vim.schedule(function()
        pcall(function()
            vim.api.nvim_clear_autocmds { group = name }
        end)
    end)
end

return M
