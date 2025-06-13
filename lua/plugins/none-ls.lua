return {
	"nvimtools/none-ls.nvim",
	config = function()
		local null_ls = require("null-ls")
		null_ls.setup({
			sources = {
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.black,
				--null_ls.builtins.diagnostics.mypy,
                --https://stackoverflow.com/questions/76487150/how-to-avoid-cannot-find-implementation-or-library-stub-when-mypy-is-installed
                null_ls.builtins.diagnostics.mypy.with({
                    extra_args = function()
                    local virtual = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX") or "/usr"
                    return { "--python-executable", virtual .. "/bin/python3" }
                    end,
                }),
				--null_ls.builtins.diagnostics.ruff,
			},
		})
		vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
	end,
}
