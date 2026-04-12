local capabilities = require("cmp_nvim_lsp").default_capabilities()
local substrate = require("user.lsp.substrate")

local roslyn_cmd_args = {
  vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "bin", "roslyn"),
  "--logLevel=Information",
  "--extensionLogDirectory=" .. vim.fs.joinpath(vim.fn.stdpath("state"), "roslyn"),
  "--stdio",
}

vim.lsp.config("roslyn_ls", {
  -- cmd as a function: receives (dispatchers, config) where config.root_dir is
  -- already resolved to a string. This lets us compute cmd_env dynamically
  -- from the project root BEFORE the LSP process spawns.
  cmd = function(dispatchers, config)
    local env = nil
    if config.root_dir then
      env = substrate.build_env(config.root_dir)
    end
    return vim.lsp.rpc.start(roslyn_cmd_args, dispatchers, {
      cwd = config.cmd_cwd,
      env = env,
      detached = config.detached,
    })
  end,
  filetypes = { "cs" },
  capabilities = capabilities,
  root_dir = function(bufnr, on_dir)
    local buf_path = vim.api.nvim_buf_get_name(bufnr)
    local root = substrate.find_csproj_root(buf_path)
    if root then
      on_dir(root)
    end
  end,
})

vim.lsp.enable("roslyn_ls")
