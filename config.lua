-- to be placed in: ~/.config/lvim/config.lua

-- 88     88   88 88b 88    db    88""Yb     Yb    dP 88 8b    d8
-- 88     88   88 88Yb88   dPYb   88__dP      Yb  dP  88 88b  d88
-- 88  .o Y8   8P 88 Y88  dP__Yb  88"Yb        YbdP   88 88YbdP88
-- 88ood8 `YbodP' 88  Y8 dP""""Yb 88  Yb        YP    88 88 YY 88

-- general
lvim.format_on_save = true
lvim.lint_on_save = true
lvim.colorscheme = "neon-custom"
lvim.hlsearch = true
lvim.transparent_window = true
lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enabled = true

-- Gui Font for Lunar Vide setup:
vim.opt.guifont = "JetBrainsMono Nerd Font:h15"
-- see: https://github.com/LunarVim/LunarVim/issues/1607
-- lvim.lang.typescript.formatters = { { exe = "prettier"  } }
-- lvim.lang.typescriptreact.formatters = { { exe = "prettier"  } }

-- must run :set manually when in gui; command below originally worked -- cannot now find default font option in config
-- can change ~/.local/share/lunarvim/lvim/lua/settings.lua to proper font
-- o.default_options.guifont = "jetbrainsmono nerd font:h14"
-- :set guifont=jetbrainsmono\ nerd\ font:h14

-- keymappings [view all the defaults by pressing <leader>lk]
lvim.leader = "space"
-- add your own keymapping
lvim.keys.normal_mode["<c-s>"] = ":wa<cr>"
-- unmap a default keymapping
-- lvim.keys.normal_mode["<c-up>"] = ""
-- edit a default keymapping
-- lvim.keys.normal_mode["<c-q>"] = ":q<cr>"

-- change telescope navigation to use j and k for navigation and n and p for history in both input and normal mode.
-- lvim.builtin.telescope.on_config_done = function()
--   local actions = require "telescope.actions"
--   -- for input mode
--   lvim.builtin.telescope.defaults.mappings.i["<c-j>"] = actions.move_selection_next
--   lvim.builtin.telescope.defaults.mappings.i["<c-k>"] = actions.move_selection_previous
--   lvim.builtin.telescope.defaults.mappings.i["<c-n>"] = actions.cycle_history_next
--   lvim.builtin.telescope.defaults.mappings.i["<c-p>"] = actions.cycle_history_prev
--   -- for normal mode
--   lvim.builtin.telescope.defaults.mappings.n["<c-j>"] = actions.move_selection_next
--   lvim.builtin.telescope.defaults.mappings.n["<c-k>"] = actions.move_selection_previous
-- end

-- use which-key to add extra bindings with the leader-key prefix
-- lvim.builtin.which_key.mappings["p"] = { "<cmd>telescope projects<cr>", "projects" }
-- lvim.builtin.which_key.mappings["t"] = {
--   name = "+trouble",
--   r = { "<cmd>trouble lsp_references<cr>", "references" },
--   f = { "<cmd>trouble lsp_definitions<cr>", "definitions" },
--   d = { "<cmd>trouble lsp_document_diagnostics<cr>", "diagnosticss" },
--   q = { "<cmd>trouble quickfix<cr>", "quickfix" },
--   l = { "<cmd>trouble loclist<cr>", "locationlist" },
--   w = { "<cmd>trouble lsp_workspace_diagnostics<cr>", "diagnosticss" },
-- }

-- todo: user config for predefined plugins
-- after changing plugin config exit and reopen lunarvim, run :packerinstall :packercompile
lvim.builtin.dashboard.active = true
lvim.builtin.terminal.active = true

-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = {}
lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enabled = true

-- generic lsp settings
-- you can set a custom on_attach function that will be used for all the language servers
-- see <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>
-- lvim.lsp.on_attach_callback = function(client, bufnr)
--   local function buf_set_option(...)
--     vim.api.nvim_buf_set_option(bufnr, ...)
--   end
--   --enable completion triggered by <c-x><c-o>
--   buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
-- end
-- you can overwrite the null_ls setup table (useful for setting the root_dir function)
-- lvim.lsp.null_ls.setup = {
--   root_dir = require("lspconfig").util.root_pattern("makefile", ".git", "node_modules"),
-- }
-- or if you need something more advanced
-- lvim.lsp.null_ls.setup.root_dir = function(fname)
--   if vim.bo.filetype == "javascript" then
--     return require("lspconfig/util").root_pattern("makefile", ".git", "node_modules")(fname)
--       or require("lspconfig/util").path.dirname(fname)
--   elseif vim.bo.filetype == "php" then
--     return require("lspconfig/util").root_pattern("makefile", ".git", "composer.json")(fname) or vim.fn.getcwd()
--   else
--     return require("lspconfig/util").root_pattern("makefile", ".git")(fname) or require("lspconfig/util").path.dirname(fname)
--   end
-- end

-- lvim.lang.javascript.formatters = {
--   {
--     exe = "prettier",
--     args = {}
--   }
-- }

-- lvim.lang.javascript.linters = {
--   {
--     exe = "eslint_d",
--     args = {}
--   }
-- }
-- lvim.lang.sh.formatters = {
--   -- on mac brew install shellharden
--   {
--     exe = "shellharden",
--     args = {}
--   }
-- }
-- lvim.lang.python.formatters = {
--   {
--     exe = "black",
--     args = {}
--   }
-- }
-- -- set an additional linter
-- lvim.lang.python.linters = {
--   {
--     exe = "flake8",
--     args = {}
--   }
-- }

-- Additional Plugins
lvim.plugins = {
  {"ChristianChiarulli/vim-solidity"},
  {"LnL7/vim-nix"},  -- for editing nix files
  {"mbbill/undotree"}, -- sets up tree of redo/undo
  {"mfussenegger/nvim-jdtls" },
  {"posva/vim-vue" },
  {"sgur/vim-editorconfig" },
  {
    "tzachar/cmp-tabnine",
    config = function()
      local tabnine = require "cmp_tabnine.config"
      tabnine:setup {
        max_lines = 1000,
        max_num_results = 20,
        sort = true,
    }
    end,
  }
}
-- Additional config options:
--         "ray-x/lsp_signature.nvim",
--         config = function() require"lsp_signature".on_attach() end,
--         event = "InsertEnter"


-- Autocommands (https://neovim.io/doc/user/autocmd.html)
-- lvim.autocommands.custom_groups = {
--   { "BufWinEnter", "*.lua", "setlocal ts=8 sw=8" },
-- }

-- sets yank/paste in clipboard - may now be builtin to lunarvim

-- set clipboard^=unnamed,unnamedplus
