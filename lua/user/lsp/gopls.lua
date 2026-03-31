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

vim.lsp.config("lua_ls", {
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      diagnostics = { globals = { "vim" } },
      workspace = {
        library = {
          vim.env.VIMRUNTIME,
          "${3rd}/luv/library",
          "${3rd}/busted/library",
        },
      },
    },
  },
})

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

vim.lsp.enable("gopls")
vim.lsp.enable("lua_ls")
vim.lsp.enable("rust_analyzer")
