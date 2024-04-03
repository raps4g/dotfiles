return {
        "catppuccin/nvim",
        name = "catppuccin",
        config = function()
            require("catppuccin").setup({
                color_overrides = {
                    all = {
                    }
                },
            })
            vim.cmd.colorscheme "catppuccin"
        end,
}


