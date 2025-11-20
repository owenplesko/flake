local blink = require('blink.cmp')
blink.setup()

local capabilities = vim.tbl_deep_extend(
  'force',
  vim.lsp.protocol.make_client_capabilities(),
  blink.get_lsp_capabilities()
)

vim.api.nvim_create_autocmd("FileType", {
  pattern = "nix",
  callback = function()
    vim.lsp.start({
      cmd = { "nil" },
      root_dir = vim.fs.root(0, { "flake.nix", ".git" }),
      capabilities = capabilities,
      settings = {
        ["nil"] = {
          formatting = {
            command = { "alejandra" },
          },
        },
      },
    })
  end,
})

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

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
  callback = function()
    vim.lsp.start({
      cmd = { "typescript-language-server", "--stdio" },
      root_dir = vim.fs.root(0, { "package.json", "tsconfig.json", "jsconfig.json", ".git" }),
      capabilities = capabilities,
    })
  end,
})
