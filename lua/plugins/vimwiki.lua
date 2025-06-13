local wiki_path = os.getenv("VIMWIKI_PATH")
if not wiki_path then
  error("VIMWIKI_PATH not set! Please set it in your shell environment.")
end

return {
  { -- Vimwiki
    "vimwiki/vimwiki",
    init = function()
      -- vim.g.vimwiki_global_ext = 0
      -- vim.g.vimwiki_map_prefix = "<Leader>v"
      vim.g.vimwiki_list = {
        {
          path = wiki_path,
          syntax = "markdown",
          ext = ".md",
        },
      }
    end,
  },
}
