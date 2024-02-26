return {
        "catppuccin/nvim",
        name = "catppuccin",
        config = function()
            require("catppuccin").setup({
                color_overrides = {
                    all = {
                        base = "#0F0F0F",
                        crust = "#0F0F0F",
                        mantle = "#0F0F0F"
                    }
                },
            })
            vim.cmd.colorscheme "catppuccin"
        end,
}


