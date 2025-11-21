-- load blink and get capabilities
local blink = require("blink.cmp")
blink.setup()

local capabilities =
	vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), blink.get_lsp_capabilities())

-- setup conform code formatting
require("conform").setup({
	format_on_save = {
		timeout_ms = 2000,
		lsp_fallback = true,
	},

	formatters_by_ft = {
		javascript = { "prettierd" },
		javascriptreact = { "prettierd" },
		typescript = { "prettierd" },
		typescriptreact = { "prettierd" },
		json = { "prettierd" },
		yaml = { "prettierd" },
		yml = { "prettierd" },
		html = { "prettierd" },
		css = { "prettierd" },
		markdown = { "prettierd" },

		nix = { "alejandra" },

		lua = { "stylua" },

		go = { "gofumpt", "goimports" },
	},
})

-- setup lsp servers

-- nix
vim.api.nvim_create_autocmd("FileType", {
	pattern = "nix",
	callback = function()
		vim.lsp.start({
			cmd = { "nil" },
			root_dir = vim.fs.root(0, { "flake.nix", ".git" }),
			capabilities = capabilities,
		})
	end,
})

-- lua
vim.api.nvim_create_autocmd("FileType", {
	pattern = "lua",
	callback = function()
		vim.lsp.start({
			name = "lua_ls",
			cmd = { "lua-language-server" },
			root_dir = vim.fs.root(0, { ".git", "init.lua" }),
			capabilities = capabilities,
			settings = {
				Lua = {
					runtime = { version = "LuaJIT" },
					diagnostics = { globals = { "vim" } },
					workspace = { checkThirdParty = false },
					telemetry = { enable = false },
				},
			},
		})
	end,
})

-- go
vim.api.nvim_create_autocmd("FileType", {
	pattern = "go",
	callback = function()
		vim.lsp.start({
			cmd = { "gopls" },
			root_dir = vim.fs.root(0, { "go.work", "go.mod", ".git" }),
			capabilities = capabilities,
		})
	end,
})

-- TS/JS
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
	callback = function()
		vim.lsp.start({
			cmd = { "typescript-language-server", "--stdio" },
			root_dir = vim.fs.root(0, { "tsconfig.json", "jsconfig.json", "package.json", ".git" }),
			capabilities = capabilities,
		})
	end,
})

-- TailwindCSS
require("tailwind-tools").setup({
	documentColor = {
		enabled = true,
		kind = "inline",
	},
})
vim.api.nvim_create_autocmd("FileType", {
	pattern = {
		"html",
		"css",
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"vue",
		"svelte",
		"astro",
	},
	callback = function()
		local root = vim.fs.root(0, {
			"tailwind.config.js",
			"tailwind.config.cjs",
			"tailwind.config.mjs",
			"tailwind.config.ts",
			"tailwind.config.json",
			"postcss.config.js",
			"package.json",
		})

		if not root then
			return
		end

		vim.lsp.start({
			name = "tailwindcss",
			cmd = { "tailwindcss-language-server", "--stdio" },
			root_dir = root,
			capabilities = vim.tbl_deep_extend("force", capabilities, { textDocument = { colorProvider = true } }),
		})
	end,
})
