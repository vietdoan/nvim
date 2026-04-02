require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {
    "gopls",
    "lua_ls",
    "rust_analyzer",
    "pyright",
    "ts_ls",
    "jsonls",
    "yamlls",
    "stylua",
  },
  automatic_installation = true,
})

require("mason-tool-installer").setup({
  ensure_installed = {
    "goimports",
  },
})
