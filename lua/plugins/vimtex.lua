return {
  "lervag/vimtex",
  init = function()
    -- Set Zathura as the PDF viewer
    vim.g.vimtex_view_method = "zathura"

    -- Optional: Enable forward search on Vim command `\lv` (Vimtex view)
    vim.g.vimtex_view_general_viewer = "zathura"
    vim.g.vimtex_view_general_options = [[--synctex-forward @line:@col:@tex --synctex-editor-command 'nvim --server /tmp/nvim-server --remote-send "<C-\\><C-n>:e @file | call cursor(@line,@col)<CR>"' @pdf]]

    -- Ensure that your Neovim server is started with a known name
    vim.cmd("let $NVIM_LISTEN_ADDRESS='/tmp/nvim-server'")

    -- 👇 Tell VimTeX to use XeLaTeX via latexmk
    vim.g.vimtex_compiler_latexmk = {
      aux_dir = 'build/aux',
      build_dir = 'build/pdf',
      callback = 1,
      continuous = 1,
      executable = 'latexmk',
      options = {
        '-xelatex',
        '-file-line-error',
        '-synctex=1',
        '-interaction=nonstopmode',
      },
    }
  end,
}

