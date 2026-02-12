vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>")
vim.keymap.set("n", "<leader>e", ":Neotree<CR>")

-- Disable arrow keys
vim.keymap.set("", "<Up>", "<Nop>")
vim.keymap.set("", "<Down>", "<Nop>")
vim.keymap.set("", "<Left>", "<Nop>")
vim.keymap.set("", "<Right>", "<Nop>")

-- Write all
vim.keymap.set("n", "<leader>wa", vim.cmd.wall)

-- Code actions
vim.keymap.set("n", "<leader>ca", function()
	vim.lsp.buf.code_action()
end, { desc = "View Code Actions" })
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "LSP Definition" })
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>fr", builtin.lsp_references, { desc = "LSP References (Telescope)" })
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })

-- Remap blink complete from C-y -> Tab
local blink = require("blink.cmp")
blink.setup({
	keymap = {
		["<Tab>"] = { "snippet_forward", "accept", "fallback"},
		["<C-y>"] = false,
	},
})
