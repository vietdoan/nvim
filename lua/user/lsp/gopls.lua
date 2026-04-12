local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.config("gopls", {
  capabilities = capabilities,
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
        shadow = true,
      },
      staticcheck = true,
      hints = {
        rangeVariableTypes = true,
        parameterNames = true,
        constantValues = true,
        functionTypeParameters = true,
      },
    },
  },
})

vim.lsp.enable("gopls")
