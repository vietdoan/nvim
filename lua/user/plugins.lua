local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  install = { colorscheme = { "molokai" } },
  checker = { enabled = true },
  spec = {
  { "folke/lazy.nvim" },
  { "folke/neodev.nvim" },

  {
    "fatih/molokai",
    config = function()
      vim.cmd("colorscheme molokai")
    end,
  },

  { "tpope/vim-fugitive" },
  { "lewis6991/gitsigns.nvim" },

  { "nvim-tree/nvim-tree.lua" },
  { "nvim-tree/nvim-web-devicons" },

  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  { "echasnovski/mini.nvim", version = false },

  {
    "smoka7/hop.nvim",
    version = "*",
    config = function()
      require("hop").setup()
    end,
  },

  {
    "brenton-leighton/multiple-cursors.nvim",
    opts = {},
  },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup()
    end,
  },

  { "github/copilot.vim" },

  {
    "nickjvandyke/opencode.nvim",
    version = "*",
    dependencies = {
      {
        "folke/snacks.nvim",
        optional = true,
        opts = {
          input = {},
          picker = {
            actions = {
              opencode_send = function(...) return require("opencode").snacks_picker_send(...) end,
            },
            win = {
              input = {
                keys = {
                  ["<a-a>"] = { "opencode_send", mode = { "n", "i" } },
                },
              },
            },
          },
        },
      },
    },
    config = function()
      vim.o.autoread = true
    end,
  },

  { "rust-lang/rust.vim" },

  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npm install --legacy-peer-deps",
  },

  { "folke/trouble.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },

  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("diffview").setup()
    end,
  },

  {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
  },
  { "WhoIsSethDaniel/mason-tool-installer.nvim" },

  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "L3MON4D3/LuaSnip" },
  { "saadparwaiz1/cmp_luasnip" },

  {
    "stevearc/aerial.nvim",
    config = function()
      require("aerial").setup()
    end,
  },
  },
})
