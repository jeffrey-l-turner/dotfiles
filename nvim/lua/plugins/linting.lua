return {
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        python = { "flake8", "codespell" },
        sh = { "shellcheck" },
        bash = { "shellcheck" },
        zsh = { "shellcheck" },
        javascript = { "codespell" },
      },
      linters = {
        shellcheck = {
          args = { "--severity=warning", "--format=json", "-" },
        },
      },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "flake8",
        "shellcheck",
        "codespell",
      })
    end,
  },
}
