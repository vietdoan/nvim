local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
}, {
  install = { colorscheme = { "molokai" } },
  checker = { enabled = true },
})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
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
      vim.defer_fn(function()
        local ok, terminal = pcall(require, "opencode.terminal")
        if ok then
          local original_setup = terminal.setup
          terminal.setup = function(win)
            original_setup(win)
            local buf = vim.api.nvim_win_get_buf(win)
            vim.api.nvim_create_autocmd("TermRequest", {
              buffer = buf,
              once = true,
              callback = function()
                vim.defer_fn(function()
                  if vim.api.nvim_buf_is_valid(buf) then
                    local line = vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1]
                    if line and line:sub(1, 1) == "p" then
                      vim.api.nvim_buf_set_lines(buf, 0, 1, false, { "" })
                    end
                  end
                end, 50)
              end,
            })
          end
        end
      end, 100)
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
})
