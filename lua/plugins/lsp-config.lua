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
          return require("lspconfig.util").find_git_ancestor(fname) or vim.fn.getcwd()
        end,
        filetypes = { "markdown", "text", "tex" },
        settings = {
          ltex = {
            language = "nl",
            additionalLanguages = { "en-US", "en-GB" },
            dictionary = {
              ["en-GB"] = {},
              ["en-US"] = {},
              ["nl"] = {},
            },
            disabledRules = {},
            enabled = true,
            -- checkFrequency = "save",
            checkFrequency = "change",
          },
        },
      })

      -- Keymaps
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
      vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, {})
    end,
  },
}

