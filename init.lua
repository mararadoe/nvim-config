-- =============================================================
--  NeoVim IDE Config – optimised for Claude Code workflow
-- =============================================================

-- ── Leader key (must be set before lazy) ─────────────────────
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ── Core options ─────────────────────────────────────────────
local opt = vim.opt
opt.number         = true
opt.relativenumber = true
opt.signcolumn     = "yes"
opt.cursorline     = true
opt.termguicolors  = true

opt.tabstop     = 2
opt.shiftwidth  = 2
opt.expandtab   = true
opt.smartindent = true

opt.ignorecase = true
opt.smartcase  = true
opt.hlsearch   = true
opt.incsearch  = true

opt.splitright = true
opt.splitbelow = true

opt.clipboard  = "unnamedplus"   -- system clipboard

-- OSC 52: clipboard over SSH (copy from remote to local)
if os.getenv("SSH_TTY") then
  vim.g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
      ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
      ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
      ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
    },
  }
end
opt.undofile   = true            -- persistent undo
opt.scrolloff  = 8
opt.updatetime = 250
opt.timeoutlen = 300
opt.mouse      = "a"
opt.showtabline = 2            -- always show tabline (for snacks.bufferline)

-- ── Bootstrap lazy.nvim ──────────────────────────────────────
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ── Load plugins ─────────────────────────────────────────────
require("lazy").setup("plugins", {
  change_detection = { notify = false },
})

-- ── Keymaps ──────────────────────────────────────────────────
local map = vim.keymap.set

-- better window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- buffers
map("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
map("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
map("n", "<leader>bd", function() Snacks.bufdelete() end, { desc = "Close buffer" })
map("n", "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", { desc = "Close other buffers" })
map("n", "<leader>bl", "<cmd>BufferLineCloseRight<cr>",  { desc = "Close buffers to right" })
map("n", "<leader>bh", "<cmd>BufferLineCloseLeft<cr>",   { desc = "Close buffers to left" })

-- clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear hlsearch" })

-- move selected lines up/down in visual mode
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- focus: explorer(Space n) / editor(Space e) / terminal(Space t)
map("n", "<leader>e", function()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local bt = vim.bo[buf].buftype
    local ft = vim.bo[buf].filetype
    if bt == "" and ft ~= "snacks_explorer" then
      vim.api.nvim_set_current_win(win)
      return
    end
  end
end, { desc = "Focus Editor" })

-- diagnostic navigation
map("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, { desc = "Prev diagnostic" })
map("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end, { desc = "Next diagnostic" })
map("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show diagnostic" })

-- terminal
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
-- Space t/n/e from terminal mode (no Esc Esc needed)
map("t", "<leader>e", function()
  vim.cmd("stopinsert")
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].buftype == "" and vim.bo[buf].filetype ~= "snacks_explorer" then
      vim.api.nvim_set_current_win(win)
      return
    end
  end
end, { desc = "Focus Editor from terminal" })
