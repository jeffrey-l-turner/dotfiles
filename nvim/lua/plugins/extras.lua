return {
  {
    "joshuavial/aider.nvim",
    cmd = { "AiderOpen", "AiderBackground", "AiderAddModifiedFiles" },
  },
  {
    "ellisonleao/glow.nvim",
    cmd = "Glow",
    config = true,
  },
  {
    "F1R3FLY-io/rholang-nvim",
    ft = "rholang",
    build = function()
      local cmd = "cd " .. vim.fn.expand("<sfile>:p:h") .. " && make && make install"
      local result = vim.fn.system(cmd)
      if vim.v.shell_error ~= 0 then
        vim.notify("rholang-nvim build failed: " .. result, vim.log.levels.ERROR)
      else
        vim.notify("rholang-nvim build successful", vim.log.levels.INFO)
      end
    end,
    config = function()
      require("rholang").setup()
    end,
  },
}
