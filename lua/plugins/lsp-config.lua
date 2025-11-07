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
      "neovim/nvim-lspconfig", -- still needed; it ships server defaults
    },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "pyright", "ruff", "ltex" },
      })

      -- Define per-server configs with the new API
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = { checkThirdParty = false },
          },
        },
      })

      vim.lsp.config("pyright", {
        settings = {
          python = {
            analysis = { typeCheckingMode = "basic" },
          },
        },
      })

      vim.lsp.config("ruff", {
        filetypes = { "python" },
      })

      vim.lsp.config("ltex", {
        -- root dir similar to your previous util.root_pattern
        root_dir = function(_)
          local markers = { ".ltex.config.json", ".git" }
          return vim.fs.root(0, markers) or vim.loop.cwd()
        end,
        filetypes = { "markdown", "text", "tex" },
        settings = (function()
          local cfg = vim.loop.cwd() .. "/.ltex.config.json"
          if vim.fn.filereadable(cfg) == 1 then
            local ok, content = pcall(function()
              return vim.json.decode(table.concat(vim.fn.readfile(cfg), "\n"))
            end)
            if ok and content then
              return vim.tbl_deep_extend("force", {
                additionalLanguages = { "en-US", "en-GB" },
                dictionary = { ["en-GB"] = {}, ["en-US"] = {}, ["nl"] = {} },
                disabledRules = {},
                enabled = true,
                checkFrequency = "change",
              }, content)
            end
          end
          return {
            language = "nl",
            additionalLanguages = { "en-US", "en-GB" },
            dictionary = { ["en-GB"] = {}, ["en-US"] = {}, ["nl"] = {} },
            disabledRules = {},
            enabled = true,
            checkFrequency = "change",
          }
        end)(),
      })

      -- Enable the servers (start on relevant buffers automatically)
      for _, server in ipairs({ "lua_ls", "pyright", "ruff", "ltex" }) do
        vim.lsp.enable(server)
      end

      -- Keymaps: set them when an LSP actually attaches
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local opts = { buffer = ev.buf }
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
        end,
      })
    end,
  },
}

