local cmp = require("cmp")

cmp.setup({
    mapping = cmp.mapping.preset.insert({
        ['<C-o'] = cmp.mapping.scroll_docs(-4),
        ['<C-o>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-k>'] = cmp.mapping.select_prev_item(),
        ['<C-j>'] = cmp.mapping.select_next_item(),
        ['<Tab>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true}),
    }),
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    } , {
        { name = 'buffer' },
    }),
})


