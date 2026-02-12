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

		go = { "gofumpt" },

		rust = { "rustfmt" },
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
	callback = function(args)
		local root = vim.fs.root(args.buf, { "go.work", "go.mod", ".git" })
		if not root then
			return
		end

		vim.lsp.start({
			name = "gopls",
			cmd = { "gopls" },
			root_dir = root,
			capabilities = capabilities,
		})
	end,
})

-- TS/JS
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
	callback = function()
		vim.lsp.start({
			cmd = { "bunx", "--bun", "typescript-language-server", "--stdio" },
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

-- python
vim.api.nvim_create_autocmd("FileType", {
	pattern = "python",
	callback = function()
		vim.lsp.start({
			name = "pyright",
			cmd = { "pyright-langserver", "--stdio" },
			root_dir = vim.fs.root(0, {
				"pyproject.toml",
				"setup.py",
				"setup.cfg",
				"requirements.txt",
				".git",
			}),
			capabilities = capabilities,
			settings = {
				python = {
					analysis = {
						typeCheckingMode = "basic", -- or "strict"
						autoSearchPaths = true,
						useLibraryCodeForTypes = true,
					},
				},
			},
		})
	end,
})

-- zig
vim.api.nvim_create_autocmd("FileType", {
	pattern = "zig",
	callback = function(args)
		local root = vim.fs.root(args.buf, { "build.zig", "build.zig.zon", ".git" })
		if not root then
			return
		end

		vim.lsp.start({
			name = "zls",
			cmd = { "zls" },
			root_dir = root,
			capabilities = capabilities,
			settings = {
				zls = {
					enable_snippets = true,
					enable_inlay_hints = true,
					enable_autofix = true,
					warn_style = true,
				},
			},
		})
	end,
})

-- rust
vim.api.nvim_create_autocmd("FileType", {
	pattern = "rust",
	callback = function(args)
		local root = vim.fs.root(args.buf, { "Cargo.toml", "rust-project.json", ".git" })
		if not root then
			return
		end

		vim.lsp.start({
			name = "rust_analyzer",
			cmd = { "rust-analyzer" },
			root_dir = root,
			capabilities = capabilities,
			settings = {
				["rust-analyzer"] = {
					cargo = {
						allFeatures = true,
					},
					checkOnSave = {
						command = "clippy",
					},
					procMacro = {
						enable = true,
					},
				},
			},
		})
	end,
})
