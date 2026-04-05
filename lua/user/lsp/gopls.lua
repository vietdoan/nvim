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

-- Scan downward from cwd for .sln/.csproj files
-- Avoids slow upward traversal on mounted filesystems
local function find_dotnet_root()
  local ignored = { bin = true, obj = true, [".git"] = true, node_modules = true }
  local dirs = { vim.fn.getcwd() }
  local csproj_dir = nil

  while #dirs > 0 do
    local dir = table.remove(dirs, 1)
    for entry, type in vim.fs.dir(dir) do
      if type == "file" and entry:match("%.slnx?$") then
        return dir
      elseif type == "file" and not csproj_dir and entry:match("%.csproj$") then
        csproj_dir = dir
      elseif type == "directory" and not ignored[entry] then
        dirs[#dirs + 1] = vim.fs.joinpath(dir, entry)
      end
    end
  end

  return csproj_dir
end

vim.lsp.config("roslyn_ls", {
  cmd = {
    vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "bin", "roslyn"),
    "--logLevel=Information",
    "--extensionLogDirectory=" .. vim.fs.joinpath(vim.fn.stdpath("state"), "roslyn"),
    "--stdio",
  },
  cmd_env = {
    DOTNET_FILE_WATCHER_DISABLED = "1",
  },
  capabilities = capabilities,
  root_dir = function(bufnr, on_dir)
    local root = find_dotnet_root()
    if root then
      on_dir(root)
    end
  end,
})

vim.lsp.enable("gopls")
vim.lsp.enable("lua_ls")
vim.lsp.enable("rust_analyzer")
vim.lsp.enable("roslyn_ls")
