local lspconfig = require("lspconfig")

lspconfig.nil_ls.setup({
  settings = {
    ['nil'] = {
      formatting = {
        command = { "alejandra" },
      },
    },
  },
})

