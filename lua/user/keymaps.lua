local map = vim.keymap.set

-- General
map("n", "<leader><space>", "<cmd>nohlsearch<CR>", { silent = true })
map("i", "jk", "<Esc>", { silent = true })
map("n", "p", "a<BS><ESC>", { silent = true })

-- Copy/Paste
map("v", "<leader>y", '"*y')
map("v", "<leader>Y", '"+y')
map("v", "<leader>p", '"*p')
map("v", "<leader>P", '"+p')



-- NvimTree
map("n", "<C-b>", "<cmd>NvimTreeToggle<CR>")
map("n", "<C-\\>", "<cmd>NvimTreeFindFile<CR>")

-- Cmp
map("i", "<C-h>", "<cmd>lua require('cmp').mapping.scroll_docs(-4)<CR>")
map("i", "<C-l>", "<cmd>lua require('cmp').mapping.scroll_docs(4)<CR>")
map("i", "<C-Space>", "<cmd>lua require('cmp').mapping.complete()<CR>")
map("i", "<C-e>", "<cmd>lua require('cmp').mapping.abort()<CR>")
map("i", "<CR>", "<cmd>lua require('cmp').mapping.confirm({ select = true })()<CR>")
map({"i", "s"}, "<Tab>", function()
  local cmp = require("cmp")
  local luasnip = require("luasnip")
  if cmp.visible() then
    cmp.select_next_item()
  elseif luasnip.expand_or_jumpable() then
    luasnip.expand_or_jump()
  else
    return false
  end
end)
map({"i", "s"}, "<S-Tab>", function()
  local cmp = require("cmp")
  local luasnip = require("luasnip")
  if cmp.visible() then
    cmp.select_prev_item()
  elseif luasnip.jump_backward() then
    luasnip.jump_backward()
  else
    return false
  end
end)

-- FzfLua
map("n", "<C-p>", "<cmd>FzfLua files<CR>")
map("n", "<leader>ff", "<cmd>FzfLua files<CR>")
map("n", "<leader>fg", "<cmd>FzfLua live_grep<CR>")
map("n", "<leader>fb", "<cmd>FzfLua buffers<CR>")
map("n", "<leader>fh", "<cmd>FzfLua help_tags<CR>")
map("n", "<leader>a", "<cmd>FzfLua grep<CR>")

-- Git (Fugitive)
map("n", "<leader>gb", "<cmd>Git<CR>")
map("n", "<leader>gc", "<cmd>Git commit<CR>")
map("n", "<leader>gp", "<cmd>Git push<CR>")

-- Diffview
map("n", "<leader>do", "<cmd>DiffviewOpen<CR>", { desc = "Open diff view" })
map("n", "<leader>dc", "<cmd>DiffviewClose<CR>", { desc = "Close diff view" })
map("n", "<leader>dh", "<cmd>DiffviewFileHistory<CR>", { desc = "File history" })
map("n", "<leader>df", function()
  local filetype = vim.bo.filetype
  if filetype == "NvimTree" then
    vim.notify("Cannot diff from NvimTree buffer", vim.log.levels.WARN)
    return
  end
  local filepath = vim.fn.expand("%")
  if filepath == "" then
    vim.notify("No file to diff", vim.log.levels.WARN)
    return
  end
  vim.cmd("DiffviewOpen -- " .. filepath)
end, { desc = "Diff against current file" })

-- LSP
map("n", "[g", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
map("n", "]g", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Quickfix diagnostics" })
map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
map("n", "gy", vim.lsp.buf.type_definition, { desc = "Go to type definition" })
map("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
map("n", "gr", vim.lsp.buf.references, { desc = "Find references" })
map("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })
map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
map("n", "<leader>f", function() vim.lsp.buf.format({ async = true }) end, { desc = "Format buffer" })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions" })
map("n", "<leader>vc", "<cmd>LspInfo<CR>")

-- Aerial
map("n", "<F8>", "<cmd>AerialToggle!<CR>")

-- Markdown Preview
map("n", "<leader>mb", "<cmd>MarkdownPreviewToggle<CR>")

-- Rust
map("n", "<leader>rr", "<cmd>RustRun<CR>")

-- Terminal
map("n", "<leader>tt", "<cmd>vsplit | terminal<CR>")
map("t", "<C-g>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Smart Splits (navigation)
map("n", "<C-h>", function() require("smart-splits").move_cursor_left() end, { desc = "Move to left split" })
map("n", "<C-j>", function() require("smart-splits").move_cursor_down() end, { desc = "Move to below split" })
map("n", "<C-k>", function() require("smart-splits").move_cursor_up() end, { desc = "Move to above split" })
map("n", "<C-l>", function() require("smart-splits").move_cursor_right() end, { desc = "Move to right split" })

-- Smart Splits (resizing)
map("n", "<A-h>", function() require("smart-splits").resize_left() end, { desc = "Resize split left" })
map("n", "<A-j>", function() require("smart-splits").resize_down() end, { desc = "Resize split down" })
map("n", "<A-k>", function() require("smart-splits").resize_up() end, { desc = "Resize split up" })
map("n", "<A-l>", function() require("smart-splits").resize_right() end, { desc = "Resize split right" })

-- Multiple Cursors
map({"n", "x"}, "<Leader>j", "<cmd>MultipleCursorsAddDown<CR>", { desc = "Add cursor and move down" })
map({"n", "x"}, "<Leader>k", "<cmd>MultipleCursorsAddUp<CR>", { desc = "Add cursor and move up" })
map({"n", "x"}, "<Leader>A", "<cmd>MultipleCursorsAddMatches<CR>", { desc = "Add cursors to cword" })
map({"x"}, "<Leader>m", "<cmd>MultipleCursorsAddVisualArea<CR>", { desc = "Add cursors to visual area" })

-- Hop
map({"n", "x", "o"}, "s", "<cmd>HopWord<CR>", { desc = "Hop word" })
map({"n", "x", "o"}, "S", "<cmd>HopChar1<CR>", { desc = "Hop char" })
map({"n", "x", "o"}, "f", "<cmd>HopChar1<CR>", { desc = "Hop char forward" })
map({"n", "x", "o"}, "F", "<cmd>HopChar2<CR>", { desc = "Hop char backward" })

-- Opencode
map({ "n", "x" }, "<leader>oa", function() require("opencode").ask("") end, { desc = "Ask opencode…" })
map({ "n", "x" }, "<leader>ox", function() require("opencode").select() end, { desc = "Execute opencode action…" })
map({ "n", "t" }, "<leader>ot", function() require("opencode").toggle() end, { desc = "Toggle opencode" })
map({ "n", "x" }, "go", function() return require("opencode").operator("@this ") end, { desc = "Add range to opencode", expr = true })
map("n", "goo", function() return require("opencode").operator("@this ") .. "_" end, { desc = "Add line to opencode", expr = true })

