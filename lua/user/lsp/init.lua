require("user.lsp.mason")
require("user.lsp.gopls")
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

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
