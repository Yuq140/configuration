vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("x", "<leader>p", [["_dP]])
vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])

-- Copy to system clipboard
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- Movement
vim.keymap.set({"n", "v"}, "H", "^")
vim.keymap.set({"n", "v"}, "J", "G")
vim.keymap.set({"n", "v"}, "K", "gg")
vim.keymap.set({"n", "v"}, "L", "$")

-- Line Management
-- Alt + jk to move line up/down
vim.keymap.set("n", "<A-j>", ":m .+1<cr>==", { noremap = true, silent = true, desc = "Move line down" })
vim.keymap.set("n", "<A-k>", ":m .-2<cr>==", { noremap = true, silent = true, desc = "Move line up" })
vim.keymap.set(
    "i",
    "<A-j>",
    "<Esc>:m .+1<cr>==gi",
    { noremap = true, silent = true, desc = "Move line down (insert mode)" }
)
vim.keymap.set(
    "i",
    "<A-k>",
    "<Esc>:m .-2<cr>==gi",
    { noremap = true, silent = true, desc = "Move line up (insert mode)" }
)
vim.keymap.set("x", "<A-j>", ":m '>+1<cr>gv=gv", { noremap = true, silent = true, desc = "Move block down" })
vim.keymap.set("x", "<A-k>", ":m '<-2<cr>gv=gv", { noremap = true, silent = true, desc = "Move block up" })

vim.keymap.set("n", "Q", "<nop>")

-- Search and replace current world
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- VSCode mapping
vim.keymap.set("n", "<A-z>", ':set wrap!<CR>', { noremap = true, silent = true })
