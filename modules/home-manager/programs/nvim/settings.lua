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

-- auto save
vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost" }, {
	callback = function()
		if vim.bo.modified and not vim.bo.readonly and vim.fn.expand("%") ~= "" and vim.bo.buftype == "" then
			vim.api.nvim_command("silent update")
		end
	end,
})
