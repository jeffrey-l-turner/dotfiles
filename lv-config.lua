--[[
O is the global options object

Linters should be
filled in as strings with either
a global executable or a path to
an executable
]]
-- THESE ARE EXAMPLE CONFIGS FEEL FREE TO CHANGE TO WHATEVER YOU WANT

-- general

O.format_on_save = true
O.completion.autocomplete = true
O.colorscheme = "neon-custom"
O.auto_close_tree = 0
O.default_options.wrap = true
O.default_options.timeoutlen = 100
O.leader_key = " "
O.default_options.guifont = "JetBrainsMono Nerd Font:h15"
-- O.default_options.guifont = "BlexMono Nerd Font:h16"
-- O.default_options.guifont = "Hack Nerd Font:h16"
O.default_options.hlsearch = true

-- TODO: User Config for predefined plugins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
O.plugin.dashboard.active = true
O.plugin.terminal.active = true
O.plugin.zen.active = true
O.plugin.zen.window.height = 0.75
O.plugin.telescope.active = true
O.transparent_window = true

-- if you don't want all the parsers change this to a table of the ones you want
O.treesitter.ensure_installed = "maintained"
O.treesitter.ignore_install = { "haskell" }
O.treesitter.highlight.enabled = true

-- python
-- O.lang.python.linter = 'flake8'
O.lang.python.isort = true
O.lang.python.diagnostics.virtual_text = true
O.lang.python.analysis.use_library_code_types = true
-- to change default formatter from yapf to black
-- O.lang.python.formatter.exe = "black"
-- O.lang.python.formatter.args = {"-"}

-- go
-- to change default formatter from gofmt to goimports
-- O.lang.formatter.go.exe = "goimports"

-- javascript
O.lang.tsserver.linter = nil

-- rust
-- O.lang.rust.formatter = {
--   exe = "rustfmt",
--   args = {"--emit=stdout", "--edition=2018"},
-- }

--LaTeX
-- Options: https://github.com/latex-lsp/texlab/blob/master/docs/options.md
O.lang.latex.active = true
O.lang.latex.aux_directory = "."
O.lang.latex.bibtex_formatter = "texlab"
O.lang.latex.build.args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" }
O.lang.latex.build.executable = "latexmk"
O.lang.latex.build.forward_search_after = false
O.lang.latex.build.on_save = false
O.lang.latex.chktex.on_edit = false
O.lang.latex.chktex.on_open_and_save = false
O.lang.latex.diagnostics_delay = 300
O.lang.latex.formatter_line_length = 80
O.lang.latex.forward_search.executable = "zathura"
O.lang.latex.latex_formatter = "latexindent"
O.lang.latex.latexindent.modify_line_breaks = false
O.lang.latex.auto_save = true
-- O.lang.latex.ignore_errors = { }

-- Additional Plugins
-- O.user_plugins = {
--     {"folke/tokyonight.nvim"}, {
--         "ray-x/lsp_signature.nvim",
--         config = function() require"lsp_signature".on_attach() end,
--         event = "InsertEnter"
--     }
-- }

-- Autocommands (https://neovim.io/doc/user/autocmd.html)
-- O.user_autocommands = {{ "BufWinEnter", "*", "echo \"hi again\""}}

-- Additional Leader bindings for WhichKey
-- O.user_which_key = {
--   A = {
--     name = "+Custom Leader Keys",
--     a = { "<cmd>echo 'first custom command'<cr>", "Description for a" },
--     b = { "<cmd>echo 'second custom command'<cr>", "Description for b" },
--   },
-- }
