vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.expandtab = true   -- Redirect tab keys to insert spaces instead
vim.opt.tabstop = 4       -- Number of spaces that a <Tab> in the file counts for
vim.opt.shiftwidth = 4     -- Number of spaces to use for each step of (auto)indent
vim.opt.softtabstop = 4   -- Number of spaces that a <Tab> counts for while performing editing operations

vim.opt.smartindent = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"

vim.opt.list = true
vim.opt.listchars = {
    tab = "» ", -- Render tabs as '» '
    trail = "·", -- Show trailing spaces as '·'
    lead = ".", -- Show leading spaces as '.'
    nbsp = "␣", -- Show non-breaking spaces
}

vim.opt.updatetime = 50

vim.opt.colorcolumn = "81"
vim.opt.guicursor = {
    "n-v-c:block",                -- Normal, Visual, Command-line: Block
    "i-ci-ve:ver25",              -- Insert, Command-line Insert, Visual-exclusive: Vertical bar (25% width)
    "r-cr:hor20",                 -- Replace, Command-line Replace: Underline (20% height)
    "o:hor50",                    -- Operator-pending: Thick underline
    "a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor", -- Blinking settings
    "sm:block-blinkwait175-blinkoff150-blinkon175"
}
