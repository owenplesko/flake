-- load blink and get capabilitiesrequire("blink"
--local blink = require("blink.cmp")
--blink.setup()

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
vim.lsp.enable("nil_ls")
vim.lsp.enable("lua_ls")
vim.lsp.enable("gopls")
vim.lsp.enable("tsgo")
vim.lsp.enable("tailwindcss")
vim.lsp.enable("pyright")
vim.lsp.enable("zls")
vim.lsp.enable("rust_analyzer")
