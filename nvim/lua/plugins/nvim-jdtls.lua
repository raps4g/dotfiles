return {
    {
        "neovim/nvim-lspconfig",
        opts = {
            setup = {
                jdtls = function()
                    return true
                end,
            }
        }
    },
    {
        "mfussenegger/nvim-jdtls",
        ft = "java",
        config = function()
            local on_attach = function(client, bufnr)
                require("lazyvim.plugins.lsp.keymaps").on_attach(client, bufnr)
            end

            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
            local workspace_dir = vim.fn.stdpath("data") .. "/site/java/workspace-root/" .. project_name
            local install_path = require("mason-registry").get_package("jdtls"):get_install_path()
            local config = {
                cmd = {
                    install_path .. "/bin/jdtls",
                    "--jvm-arg=-javaagent:" .. install_path .. "/lombok.jar",
                    "-data",
                    workspace_dir,
                },
                on_attach = on_attach,
                capabilities = capabilities,
                root_dir = vim.fs.dirname(
                    vim.fs.find({ ".gradlew", ".git", "mvnw", "pom.xml", "build.gradle" }, { upward = true })[1]
                ),
            }
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "java",
                callback = function()
                    require("jdtls").start_or_attach(config)
                end,
            })
        end,
    }
}


--[[
return {
    {
        "neovim/nvim-lspconfig",
        dependencies = { "mfussenegger/nvim-jdtls" },
        opts = {
            setup = {
                jdtls = function(_, opts)
                    vim.api.nvim_create_autocmd("FileType", {
                        pattern = "java",
                        callback = function()
                            require("lazyvim.util").on_attach(function(_, buffer)
                                vim.keymap.set(
                                    "n",
                                    "<leader>di",
                                    "<Cmd>lua require'jdtls'.organize_imports()<CR>",
                                    { buffer = buffer, desc = "Organize Imports" }
                                )
                                vim.keymap.set(
                                    "n",
                                    "<leader>dt",
                                    "<Cmd>lua require'jdtls'.test_class()<CR>",
                                    { buffer = buffer, desc = "Test Class" }
                                )
                                vim.keymap.set(
                                    "n",
                                    "<leader>dn",
                                    "<Cmd>lua require'jdtls'.test_nearest_method()<CR>",
                                    { buffer = buffer, desc = "Test Nearest Method" }
                                )
                                vim.keymap.set(
                                    "v",
                                    "<leader>de",
                                    "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>",
                                    { buffer = buffer, desc = "Extract Variable" }
                                )
                                vim.keymap.set(
                                    "n",
                                    "<leader>de",
                                    "<Cmd>lua require('jdtls').extract_variable()<CR>",
                                    { buffer = buffer, desc = "Extract Variable" }
                                )
                                vim.keymap.set(
                                    "v",
                                    "<leader>dm",
                                    "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>",
                                    { buffer = buffer, desc = "Extract Method" }
                                )
                                vim.keymap.set(
                                    "n",
                                    "<leader>cf",
                                    "<cmd>lua vim.lsp.buf.formatting()<CR>",
                                    { buffer = buffer, desc = "Format" }
                                )
                            end)
                            local home = os.getenv 'HOME'
                            local workspace_path = home .. '/.local/share/nvim/jdtls-workspace/'
                            local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
                            local workspace_dir = workspace_path .. project_name

                            local config = {
                                cmd = {
                                    'java',
                                    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
                                    '-Dosgi.bundles.defaultStartLevel=4',
                                    '-Declipse.product=org.eclipse.jdt.ls.core.product',
                                    '-Dlog.protocol=true',
                                    '-Dlog.level=ALL',
                                    '-Xmx4g',
                                    '--add-modules=ALL-SYSTEM',
                                    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
                                    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
                                    '-javaagent:' .. os.getenv("HOME") .. '.local/share/nvim/mason/packages/jdtls/lombok.jar',
                                    '-jar', os.getenv("HOME") .. '/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar',
                                    '-configuration', os.getenv("HOME") .. '/.local/share/nvim/mason/packages/jdtls/config_linux',
                                    '-data', workspace_dir,
                                },                                -- The command that starts the language server
                                -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line

                                -- This is the default if not provided, you can remove it. Or adjust as needed.
                                -- One dedicated LSP server & client will be started per unique root_dir
                                root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew" }),

                                -- Here you can configure eclipse.jdt.ls specific settings
                                -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
                                -- for a list of options
                                settings = {
                                    java = {},
                                },
                                handlers = {
                                    ["language/status"] = function(_, result)
                                        -- print(result)
                                    end,
                                    ["$/progress"] = function(_, result, ctx)
                                        -- disable progress updates.
                                    end,
                                },
                            }
                            require("jdtls").start_or_attach(config)
                        end,
                    })
                    return true
                end,
            },
        },
    },
}
--]]
