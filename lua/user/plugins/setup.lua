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

require("telescope").setup({
  defaults = {
    prompt_prefix = " ",
    selection_caret = " ",
    path_display = { "smart" },
    file_ignore_patterns = { ".git/", "node_modules/", "dist/", "__pycache__/" },
  },
  pickers = {
    find_files = { theme = "dropdown" },
    live_grep = { theme = "ivy" },
  },
})

require("telescope").load_extension("fzf")

require("trouble").setup({
  position = "bottom",
  height = 10,
  width = 50,
  icons = true,
  group = true,
  padding = true,
  use_diagnostic_signs = true,
})
