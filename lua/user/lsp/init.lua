require("user.lsp.mason")
require("user.lsp.gopls")
require("user.lsp.lua_ls")
require("user.lsp.rust_analyzer")
require("user.lsp.roslyn")
require("user.lsp.cmp")
require("user.plugins.setup")

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set({ "n", "v" }, "<leader>f", function()
      vim.lsp.buf.format({ async = true })
    end, opts)
  end,
})

vim.diagnostic.config({
  virtual_text = false,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "✘",
      [vim.diagnostic.severity.WARN] = "▲",
      [vim.diagnostic.severity.HINT] = "⚑",
      [vim.diagnostic.severity.INFO] = "»",
    },
  },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})
