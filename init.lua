-- Editor settings
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.guicursor = ""
vim.opt.backspace = "2"
vim.opt.showcmd = true
vim.opt.laststatus = 2
vim.opt.autoread = true
vim.opt.number = true
vim.opt.laststatus = 3
vim.opt.scrolloff = 20
vim.opt.updatetime = 50
-- tabs and indents
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.autoindent = true
vim.opt.mouse = "a"
vim.opt.fillchars = { eob = " " }

-- Lazy plugin manager
require("config.lazy")

-- Basic Keymaps
vim.keymap.set("n", "x", '"_x') -- no yank with X
vim.keymap.set("n", "<C-a>", "gg<S-v>G") -- select all
vim.keymap.set("n", "sv", ":vsplit<Return><C-w>w", { silent = true }) -- V Split
vim.keymap.set("n", "ss", ":split<Return><C-w>w", { silent = true }) -- Split
vim.keymap.set("x", "<leader>p", '"_dP') -- best remap

-- color scheme
vim.cmd([[colorscheme catppuccin-mocha]])

-- Nvim Tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true
require("nvim-tree").setup()

-- Commander
local commander = require("commander")
commander.add({
	{
		desc = "Show Commander",
		cmd = "<CMD>Telescope commander<CR>",
		keys = { "n", "<leader>fc", { silent = true } },
	},
	{
		desc = "Find in files",
		cmd = "<CMD>Telescope live_grep<CR>",
		keys = { "n", "<leader>fg", { silent = true } },
	},
	{
		desc = "Find files",
		cmd = "<CMD>Telescope find_files<CR>",
		keys = { "n", "<leader>ff", { silent = true } },
	},
	{
		desc = "Find Buffer",
		cmd = "<CMD>Telescope buffers<CR>",
		keys = { "n", "<leader>fb", { silent = true } },
	},
	{
		desc = "Find Help",
		cmd = "<CMD>Telescope help_tags<CR>",
		keys = { "n", "<leader>fh", { silent = true } },
	},
	{
		desc = "Format File",
		cmd = "<CMD>:lua require('conform').format()<CR>",
		keys = { "n", "<leader>fo", { silent = true } },
	},
	{
		desc = "File Tree",
		cmd = "<CMD>NvimTreeToggle<CR>",
		keys = { "n", "<C-n>", { silent = true } },
	},
})

-- Mason
local mason = require("mason")
mason.setup()

-- Mason-lspconfig
local masonlspconfig = require("mason-lspconfig")
masonlspconfig.setup({
	ensure_installed = { "lua_ls", "ts_ls", "tailwindcss", "clangd", "html", "pyright" },
})

-- lspconfig
local on_attach = function(_, _)
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {})
	vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
	vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {})
end
local capabilities = require("cmp_nvim_lsp").default_capabilities()
require("lspconfig").lua_ls.setup({
	on_init = function(client)
		if client.workspace_folders then
			local path = client.workspace_folders[1].name
			if vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc") then
				return
			end
		end

		client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
			runtime = {
				-- Tell the language server which version of Lua you're using
				-- (most likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
			},
			-- Make the server aware of Neovim runtime files
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME,
					-- Depending on the usage, you might want to add additional paths here.
					-- "${3rd}/luv/library"
					-- "${3rd}/busted/library",
				},
				-- or pull in all of 'runtimepath'. NOTE: this is a lot slower
				-- library = vim.api.nvim_get_runtime_file("", true)
			},
		})
	end,
	settings = {
		Lua = {},
	},
	on_attach = on_attach,
	capabilities = capabilities,
})

-- formatter
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		javascript = { "prettierd", "prettier", stop_after_first = true },
		typescript = { "prettierd", "prettier", stop_after_first = true },
		javascriptreact = { "prettierd", "prettier", stop_after_first = true },
		typescriptreact = { "prettierd", "prettier", stop_after_first = true },
		html = { "prettierd", "prettier", stop_after_first = true },
		css = { "prettierd", "prettier", stop_after_first = true },
		json = { "prettierd", "prettier", stop_after_first = true },
		python = { "black" },
	},
	format_on_save = {
		timeout_ms = 500,
		lsp_format = "fallback",
	},
})

require("lspconfig").ts_ls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})
require("lspconfig").html.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})
require("lspconfig").tailwindcss.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})
require("lspconfig").clangd.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})
require("lspconfig").pyright.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

-- auto html tags
require("nvim-ts-autotag").setup({
	opts = {
		-- Defaults
		enable_close = true, -- Auto close tags
		enable_rename = false, -- Auto rename pairs of tags
		enable_close_on_slash = true, -- Auto close on trailing </
	},
	-- Also override individual filetype configs, these take priority.
	-- Empty by default, useful if one of the "opts" global settings
	-- doesn't work well in a specific filetype
	--
	-- per_filetype = {
	--   ["html"] = {
	--     enable_close = false
	--   }
	-- }
})

-- lua line
require("lualine").setup({
	options = { theme = "ayu_dark" },
})

-- startup commands
vim.cmd("TransparentEnable")
