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
-- Mason
require("mason").setup()

-- lsps
vim.lsp.enable("lua_ls")
vim.lsp.enable("ts_ls")
vim.lsp.enable("css")

vim.diagnostic.config({
	virtual_lines = true,
})

vim.lsp.config("lua_ls", {
	on_init = function(client)
		if client.workspace_folders then
			local path = client.workspace_folders[1].name
			if
				path ~= vim.fn.stdpath("config")
				and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
			then
				return
			end
		end

		client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
			runtime = {
				-- Tell the language server which version of Lua you're using (most
				-- likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
				-- Tell the language server how to find Lua modules same way as Neovim
				-- (see `:h lua-module-load`)
				path = {
					"lua/?.lua",
					"lua/?/init.lua",
				},
			},
			-- Make the server aware of Neovim runtime files
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME,
					-- Depending on the usage, you might want to add additional paths
					-- here.
					-- '${3rd}/luv/library'
					-- '${3rd}/busted/library'
				},
				-- Or pull in all of 'runtimepath'.
				-- NOTE: this is a lot slower and will cause issues when working on
				-- your own configuration.
				-- See https://github.com/neovim/nvim-lspconfig/issues/3189
				-- library = {
				--   vim.api.nvim_get_runtime_file('', true),
				-- }
			},
		})
	end,
	settings = {
		Lua = {},
	},
})

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
