vim.opt.clipboard = "unnamedplus" -- use system keyboard for yank

vim.opt.nu = true -- set line numbers
vim.opt.relativenumber = true -- use relative line numbers

-- set tab size to 2 spaces
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.incsearch = true -- incremental search

vim.opt.termguicolors = true

vim.diagnostic.config({
	virtual_text = true, -- show inline errors
	signs = true, -- show signs in the gutter
	underline = true, -- underline errors
	update_in_insert = false, -- don't update while typing
	severity_sort = true, -- show most severe first
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		-- Choose soft wrap settings:
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true

		-- Navigate visual rows instead of logical file rows
		vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
		vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
	end,
})
