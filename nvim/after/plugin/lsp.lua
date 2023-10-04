require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = {"lua_ls", "pylsp", "hls"}
})
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local on_attach = function(_,_)
    vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition, {})
end

require("lspconfig").lua_ls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        Lua = {
            diagnostics = { globals = {'vim'} }
        }
    }
}

require("lspconfig").hls.setup {
    on_attach = on_attach,
    capabilities = capabilities
}
require("lspconfig").clangd.setup {
    on_attach = on_attach,
    capabilities = capabilities
}
require("lspconfig").pylsp.setup {
    on_attach = on_attach,
    capabilities = capabilities
}

require("lspconfig").bashls.setup {
    on_attach = on_attach,
    capabilities = capabilities
}
