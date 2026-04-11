local function nvim_tree_on_attach(bufnr)
  local api = require("nvim-tree.api")
  api.config.mappings.default_on_attach(bufnr)
  -- Remap file info from C-k to C-i so smart-splits C-k works
  vim.keymap.del("n", "<C-k>", { buffer = bufnr })
  vim.keymap.set("n", "<C-i>", api.node.show_info_popup, { buffer = bufnr, desc = "Info" })
end

require("nvim-tree").setup({
  on_attach = nvim_tree_on_attach,
  git = { enable = true },
  filesystem_watchers = {
    ignore_dirs = {
      "TestResults",
      "node_modules",
      ".git",
      ".vs",
    },
  },
  actions = {
    open_file = { quit_on_open = true },
  },
  view = {
    width = 35,
    side = "left",
    signcolumn = "no",
  },
  renderer = {
    group_empty = true,
    icons = {
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = true,
      },
    },
  },
})

require("fzf-lua").setup({
  winopts = {
    height = 0.85,
    width = 0.80,
    preview = {
      layout = "vertical",
      vertical = "down:45%",
    },
  },
  files = {
    fd_opts = "--color=never --type f --hidden --follow --exclude .git",
  },
  grep = {
    rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096",
  },
})

require("trouble").setup({
  position = "bottom",
  height = 10,
  width = 50,
  icons = true,
  group = true,
  padding = true,
  use_diagnostic_signs = true,
})
