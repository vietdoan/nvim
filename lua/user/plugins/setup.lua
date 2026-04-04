require("nvim-tree").setup({
  git = { enable = true },
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
