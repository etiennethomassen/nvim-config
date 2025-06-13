return {
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        config = function()
            require("mason").setup()
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "williamboman/mason.nvim",
            "neovim/nvim-lspconfig",
        },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "pyright",
                    "ruff",
                    "ltex",
                },
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require("lspconfig")

            -- Basic setups
            lspconfig.lua_ls.setup({})
            lspconfig.pyright.setup({})
            lspconfig.ruff.setup({
                filetypes = { "python" },
            })

            -- ltex setup
            lspconfig.ltex.setup({
                root_dir = function(fname)
                    return require("lspconfig.util").root_pattern(".ltex.config.json", ".git")(fname)
                        or vim.fn.getcwd()
                end,
                filetypes = { "markdown", "text", "tex" },
                settings = {
                    ltex = (function()
                        local config_path = vim.fn.getcwd() .. "/.ltex.config.json"
                        if vim.fn.filereadable(config_path) == 1 then
                            local ok, content = pcall(function()
                                return vim.fn.json_decode(vim.fn.readfile(config_path))
                            end)
                            if ok and content then
                                return vim.tbl_deep_extend("force", {
                                    additionalLanguages = { "en-US", "en-GB" },
                                    dictionary = {
                                        ["en-GB"] = {},
                                        ["en-US"] = {},
                                        ["nl"] = {},
                                    },
                                    disabledRules = {},
                                    enabled = true,
                                    checkFrequency = "change",
                                }, content)
                            end
                        end

                        -- fallback if no config found
                        return {
                            language = "nl",
                            additionalLanguages = { "en-US", "en-GB" },
                            dictionary = {
                                ["en-GB"] = {},
                                ["en-US"] = {},
                                ["nl"] = {},
                            },
                            disabledRules = {},
                            enabled = true,
                            checkFrequency = "change",
                        }
                    end)()
                }
            })

            -- Keymaps
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
            vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, {})
        end,
    },
}

