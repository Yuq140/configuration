-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

local os_options = vim.fn.has "win32" == 1
        and {
            shell = vim.fn.executable "pwsh" == 1 and "pwsh" or "powershell",
            shellcmdflag = "-NoLogo -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;",
            shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait",
            shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode",
            shellquote = "",
            shellxquote = "",

            undodir = os.getenv "USERPROFILE" .. "/.vim/undodir",
        }
    or {
        undodir = os.getenv "HOME" .. "/.vim/undodir",
    }

---@type LazySpec
return {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
        -- Configure core features of AstroNvim
        -- features = {
        --   large_buf = { size = 1024 * 256, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
        --   autopairs = true, -- enable autopairs at start
        --   cmp = true, -- enable completion at start
        --   diagnostics = { virtual_text = true, virtual_lines = false }, -- diagnostic settings on startup
        --   highlighturl = true, -- highlight URLs at start
        --   notifications = true, -- enable notifications at start
        -- },
        -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
        -- diagnostics = {
        --   virtual_text = true,
        --   underline = true,
        -- },
        -- passed to `vim.filetype.add`
        -- filetypes = {
        --   -- see `:h vim.filetype.add` for usage
        --   extension = {
        --     foo = "fooscript",
        --   },
        --   filename = {
        --     [".foorc"] = "fooscript",
        --   },
        --   pattern = {
        --     [".*/etc/foo/.*"] = "fooscript",
        --   },
        -- },
        -- vim options can be configured here
        options = {
            opt = vim.tbl_extend("force", { -- vim.opt.<key>
                termguicolors = true,
                number = true, -- sets vim.opt.number
                relativenumber = true, -- sets vim.opt.relativenumber
                spell = false, -- sets vim.opt.spell
                signcolumn = "yes", -- sets vim.opt.signcolumn to yes
                scrolloff = 8,

                expandtab = true, -- Redirect tab keys to insert spaces instead
                tabstop = 4, -- Number of spaces that a <Tab> in the file counts for
                shiftwidth = 4, -- Number of spaces to use for each step of (auto)indent
                softtabstop = 4, -- Number of spaces that a <Tab> counts for while performing editing operations

                smartindent = true,
                ignorecase = true,
                smartcase = true,

                swapfile = false,
                backup = false,
                undofile = true,

                hlsearch = false,
                incsearch = true,
                list = true,
                listchars = {
                    tab = "» ", -- Render tabs as '» '
                    trail = "·", -- Show trailing spaces as '·'
                    lead = ".", -- Show leading spaces as '.'
                    nbsp = "␣", -- Show non-breaking spaces
                },

                updatetime = 50,

                colorcolumn = "81",
                guicursor = {
                    "n-v-c:block", -- Normal, Visual, Command-line: Block
                    "i-ci-ve:ver25", -- Insert, Command-line Insert, Visual-exclusive: Vertical bar (25% width)
                    "r-cr:hor20", -- Replace, Command-line Replace: Underline (20% height)
                    "o:hor50", -- Operator-pending: Thick underline
                    "a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor", -- Blinking settings
                    "sm:block-blinkwait175-blinkoff150-blinkon175",
                },
            }, os_options),
            g = { -- vim.g.<key>
                -- configure global vim variables (vim.g)
                -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
                -- This can be found in the `lua/lazy_setup.lua` file
            },
        },
        -- Mappings can be configured through AstroCore as well.
        -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
        -- mappings = {
        --   -- first key is the mode
        --   n = {
        --     -- second key is the lefthand side of the map
        --
        --     -- navigate buffer tabs
        --     ["]b"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        --     ["[b"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },
        --
        --     -- mappings seen under group name "Buffer"
        --     ["<Leader>bd"] = {
        --       function()
        --         require("astroui.status.heirline").buffer_picker(
        --           function(bufnr) require("astrocore.buffer").close(bufnr) end
        --         )
        --       end,
        --       desc = "Close buffer from tabline",
        --     },
        --
        --     -- tables with just a `desc` key will be registered with which-key if it's installed
        --     -- this is useful for naming menus
        --     -- ["<Leader>b"] = { desc = "Buffers" },
        --
        --     -- setting a mapping to false will disable it
        --     -- ["<C-S>"] = false,
        --   },
        -- },
    },
}
