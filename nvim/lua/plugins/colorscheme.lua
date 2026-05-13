return {
  {
    "jeffrey-l-turner/neon",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.neon_style = "default"
      vim.g.neon_transparent = true
      vim.g.neon_italic_keyword = true
      vim.g.neon_italic_function = true
      pcall(vim.cmd.colorscheme, "neon")
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "neon",
    },
  },
}
