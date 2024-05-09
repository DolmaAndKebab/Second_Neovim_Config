local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Plugins
local plugins = {
	{
		"ellisonleao/gruvbox.nvim",
		priority = 1000,
		lazy = false,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		priority = 1000,
		lazy = false,
	},
	{
		"windwp/nvim-ts-autotag",
		priority = 1000,
		lazy = false,
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		priority = 1000,
		lazy = false,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
	},
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
			"3rd/image.nvim",
		},
	},
	{
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"neovim/nvim-lspconfig",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/nvim-cmp",
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
		"nvimtools/none-ls.nvim",
		"nvimtools/none-ls-extras.nvim",
		"MunifTanjim/eslint.nvim",
		priority = 1000,
		lazy = false,
	},
	{
		"barrett-ruth/live-server.nvim",
		build = "npm install -g live-server",
		cmd = { "LiveServerStart", "LiveServerStop" },
	},
}

-- Plugin manager
require("lazy").setup(plugins, {})

-- Colorscheme
vim.cmd("colorscheme gruvbox")

-- Nvim-treesitter

require("nvim-treesitter.configs").setup({
	ensure_installed = { "lua", "javascript", "typescript", "html", "css", "vim", "vimdoc" },

	auto_install = true,

	highlight = {
		enable = true,
	},

	autotag = {
		enable = true,
	},
})

-- Setting up CMP Nvim

local cmp = require("cmp")

cmp.setup({
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
	}, {
		{ name = "buffer" },
	}),
})

require("luasnip.loaders.from_vscode").lazy_load()

-- Setting up LSP

require("mason").setup({})

require("mason-lspconfig").setup({
	ensure_installed = { "lua_ls", "tsserver", "html", "cssls", "jsonls", "yamlls" },
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()
local lspconfig = require("lspconfig")

lspconfig.lua_ls.setup({
	capabilities = capabilities,
})

lspconfig.tsserver.setup({
	capabilities = capabilities,
})
lspconfig.html.setup({
	capabilities = capabilities,
})
lspconfig.cssls.setup({
	capabilities = capabilities,
})
lspconfig.jsonls.setup({
	capabilities = capabilities,
})
lspconfig.yamlls.setup({
	capabilities = capabilities,
})



vim.keymap.set("n", "<C-x>", vim.lsp.buf.hover, {})
vim.keymap.set("n", "<C-c>", vim.lsp.buf.code_action, {})

-- Settinng up none-ls

local null_ls = require("null-ls")
local eslint = require("eslint")

null_ls.setup({
	sources = {
		null_ls.builtins.formatting.stylua,
		require("none-ls.formatting.jq"),
		null_ls.builtins.formatting.prettier,
	},
})

eslint.setup({
  bin = 'eslint_d',
  code_actions = {
    enable = true,
    apply_on_save = {
      enable = true,
      types = { "directive", "problem", "suggestion", "layout" },
    },
    disable_rule_comment = {
      enable = true,
      location = "separate_line",
    },
  },
  diagnostics = {
    enable = true,
    report_unused_disable_directives = false,
    run_on = "type", -- or `save`
  },
})

vim.keymap.set("n", "<space>c", vim.lsp.buf.format, {})

-- Setting up autotag nvim

require("nvim-ts-autotag").setup({})

-- Setting up autopair nvim

require("nvim-autopairs").setup({})

-- Setting up lualine nvim

require("lualine").setup({})

-- Setting up bufferline nvim

vim.opt.termguicolors = true
require("bufferline").setup({})

-- Setting up Neo-tree nvim

vim.keymap.set("n", "<C-e>", ":Neotree filesystem reveal left<CR>", {})

-- Setting up Live server nvim 

require('live-server').setup({})

-- Vim commands & Options

vim.cmd("set number")
vim.cmd("set cursorline")
