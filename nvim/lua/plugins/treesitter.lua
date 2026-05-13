return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "bash",
        "c",
        "css",
        "java",
        "javascript",
        "json",
        "lua",
        "python",
        "rust",
        "tsx",
        "typescript",
        "yaml",
      })
      opts.ignore_install = vim.list_extend(opts.ignore_install or {}, { "haskell" })
      opts.highlight = opts.highlight or {}
      opts.highlight.enable = true
    end,
  },
}
