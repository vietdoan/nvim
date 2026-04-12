local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.config("rust_analyzer", {
  capabilities = capabilities,
  settings = {
    ["rust-analyzer"] = {
      cargo = {
        loadOutDirsFromCheck = true,
        runBuildScripts = true,
      },
      checkOnSave = {
        command = "clippy",
      },
    },
  },
})

vim.lsp.enable("rust_analyzer")
