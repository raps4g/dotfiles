-- leader
vim.g.mapleader = " "
--vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Move visual lines 
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("v", "<S-Down>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<S-Up>", ":m '<-2<CR>gv=gv")
-- Keep curson position while joining lines
vim.keymap.set("n", "J", "mzJ`z")

-- Center search results
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Pasts without yanking
vim.keymap.set("x", "<leader>p", "\"_dP")

-- Deleting to void
vim.keymap.set("v", "<leader>d", "\"_d")
vim.keymap.set("n", "<leader>d", "\"_d")

-- Insert lines below and above cursor
vim.keymap.set("n", "<leader>k", "O<Esc>j")
vim.keymap.set("n", "<leader>j", "o<Esc>k")

-- Copy to clipboard
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")
vim.keymap.set("v", "<leader>y", "\"+y")

-- Paste from clipboard
--vim.keymap.set("n", "<leader>p", "\"+p") 
--vim.keymap.set("n", "<leader>P", "\"+p") 
--vim.keymap.set("v", "<leader>p", "\"+p")

vim.keymap.set("n", "<leader>w", ":set wrap!<cr>")
vim.keymap.set("i", "<C-o>", "<Esc>A;<cr>")
