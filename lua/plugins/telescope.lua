return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.5',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope-ui-select.nvim',
        'nvim-telescope/telescope-bibtex.nvim',  -- Load bibtex here
    },
    config = function()
        local telescope = require("telescope")
        local builtin = require("telescope.builtin")

        -- Keymaps for core telescope
        vim.keymap.set('n', '<leader><leader>', builtin.buffers, {})
        vim.keymap.set('n', '<C-p>', builtin.find_files, {})
        vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})

        -- Setup telescope
        telescope.setup({
            extensions = {
                ["ui-select"] = {
                    require("telescope.themes").get_dropdown {}
                }
            }
        })

        -- Load all extensions
        telescope.load_extension("ui-select")
        telescope.load_extension("bibtex")

        -- Keymap for BibTeX picker
        vim.keymap.set('n', '<leader>fb', function()
            telescope.extensions.bibtex.bibtex()
        end, {})
    end
}

