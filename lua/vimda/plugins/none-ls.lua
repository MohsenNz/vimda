local utile = require("vimda.utile")

-- Has been gotten from LunarVim
local function add_lsp_buffer_keybindings(bufnr)
    local function show_line_diagnostics()
        local float = vim.diagnostic.config().float

        if float then
            local config = type(float) == "table" and float or {}
            config.scope = "line"

            vim.diagnostic.open_float(config)
        end
    end
    local function f(desc)
        return { buffer = bufnr, desc = desc, noremap = true, silent = true }
    end
    utile.set_keymaps({
        { 'n', 'K',  '<cmd>lua vim.lsp.buf.hover()<cr>',          f("Show hover") },
        { 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>',     f("Goto definition") },
        { 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>',    f("Goto Declaration") },
        { 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>',     f("Goto references") },
        { 'n', 'gI', '<cmd>lua vim.lsp.buf.implementation()<cr>', f("Goto Implementation") },
        { 'n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', f("Show signature help") },
        { 'n', 'gl', show_line_diagnostics,                       f("Show line diagnostics") },
    })
end

-- Has been gotten from LunarVim
local function add_lsp_buffer_options(bufnr)
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
    vim.api.nvim_buf_set_option(bufnr, "formatexpr", "v:lua.vim.lsp.formatexpr(#{timeout_ms:500})")
end

-- Has been gotten from LunarVim
local function setup_document_symbols(client, bufnr)
    vim.g.navic_silence = false -- can be set to true to suppress error
    local symbols_supported = client.supports_method "textDocument/documentSymbol"
    if not symbols_supported then
        -- TODO: log
        -- Log:debug("skipping setup for document_symbols, method not supported by " .. client.name)
        return
    end
    local status_ok, navic = pcall(require, "nvim-navic")
    if status_ok then
        navic.attach(client, bufnr)
    end
end

-- Has been gotten from LunarVim
local function common_capabilities()
    local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    if status_ok then
        return cmp_nvim_lsp.default_capabilities()
    end

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = {
            "documentation",
            "detail",
            "additionalTextEdits",
        },
    }

    return capabilities
end

return {
    "nvimtools/none-ls.nvim",
    opts = {
        on_attach = function(client, bufnr)
            if lvim.lsp.document_highlight then
                utile.setup_document_highlight(client, bufnr)
            end
            if lvim.lsp.code_lens_refresh then
                utile.setup_codelens_refresh(client, bufnr)
            end
            add_lsp_buffer_keybindings(bufnr)
            add_lsp_buffer_options(bufnr)
            setup_document_symbols(client, bufnr)
        end,
        on_init = nil,
        on_exit = function(_, _)
            utile.clear_augroup("lsp_code_lens_refresh")
        end,
        capabilities = common_capabilities,
    },
}
