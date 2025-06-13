return {
    {
    -- Telescope
    'nvim-telescope/telescope.nvim', tag = '0.1.5',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        local builtin = require("telescope.builtin")
        vim.keymap.set('n', '<leader><leader>', builtin.buffers, {})
        vim.keymap.set('n', '<C-p>', builtin.find_files, {})
        -- live_grep requires ripgrep (sudo apt install ripgrep)
        vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
    end
    },
    {
        -- Telescope-ui-select
        "nvim-telescope/telescope-ui-select.nvim",
        config = function()
            require("telescope").setup({
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown {
                        }
                    }
                }
        })
        require("telescope").load_extension("ui-select")
        end
    },

}

