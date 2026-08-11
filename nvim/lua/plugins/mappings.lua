return {
    {
        "AstroNvim/astrocore",
        ---@type AstroCoreOpts
        opts = {
            mappings = {
                -- first key is the mode
                n = {
                    -- second key is the lefthand side of the map
                    -- mappings seen under group name "Buffer"
                    ["<Leader>bn"] = { "<cmd>tabnew<cr>", desc = "New tab" },
                    ["<Leader>bD"] = {
                        function()
                            require("astroui.status").heirline.buffer_picker(function(bufnr)
                                require("astrocore.buffer").close(bufnr)
                            end)
                        end,
                        desc = "Pick to close",
                    },
                    -- tables with just a `desc` key will be registered with which-key if it's installed
                    -- this is useful for naming menus
                    -- ["<Leader>b"] = { desc = "Buffers" },
                    -- quick save
                    -- ["<C-s>"] = { ":w!<cr>", desc = "Save File" },  -- change description but the same command

                    -- Disable Default Mappings
                    ["<C-q>"] = false,
                    ["<Leader>/"] = false,

                    -- Garbage
                    ["Q"] = { "<nop>" },

                    -- Custom Mappings
                    ["H"] = { "^" },
                    ["L"] = { "$" },

                    ["<C-/>"] = { "gcc", remap = true, desc = "Toggle comment line" },
                    ["<C-d>"] = { "<C-d>zz" },
                    ["<C-u>"] = { "<C-u>zz" },
                    ["n"] = { "nzzzv", desc = "Go to next occurence of the word" },
                    ["N"] = { "Nzzzv", desc = "Go to previous occurence of the word" },

                    ["<A-j>"] = { ":m .+1<cr>==", noremap = true, silent = true, desc = "Move line down" },
                    ["<A-k>"] = { ":m .-2<cr>==", noremap = true, silent = true, desc = "Move line up" },

                    ["<Leader>s"] = {
                        ":%s/<C-r><C-w>/<C-r><C-w>/gI<Left><Left><Left>",
                        desc = "Search and Replace current word",
                    },

                    ["<A-z>"] = { ":set wrap!<CR>", noremap = true, silent = true, desc = "Toggle softwrap" },
                },

                x = {
                    -- Disable Default Mappings
                    ["<Leader>/"] = false,

                    -- Custom Mappings
                    ["<C-/>"] = { "gc", remap = true, desc = "Toggle comment" },
                    ["<A-j>"] = {
                        ":m '>+1<cr>gv=gv",
                        noremap = true,
                        silent = true,
                        desc = "Move block down",
                    },
                    ["<A-k>"] = {
                        ":m '<-2<cr>gv=gv",
                        noremap = true,
                        silent = true,
                        desc = "Move block up",
                    },
                },

                t = {
                    -- setting a mapping to false will disable it
                    -- ["<esc>"] = false,
                },

                i = {
                    ["<A-j>"] = {
                        "<Esc>:m .+1<cr>==gi",
                        noremap = true,
                        silent = true,
                        desc = "Move line down (insert mode)",
                    },
                    ["<A-k>"] = {
                        "<Esc>:m .-2<cr>==gi",
                        noremap = true,
                        silent = true,
                        desc = "Move line up (insert mode)",
                    },
                },

                v = {
                    ["H"] = { "^" },
                    ["L"] = { "$" },
                },
            },
        },
    },
    {
        "AstroNvim/astrolsp",
        ---@type AstroLSPOpts
        opts = {
            mappings = {
                n = {
                    -- this mapping will only be set in buffers with an LSP attached
                    K = {
                        function()
                            vim.lsp.buf.hover()
                        end,
                        desc = "Hover symbol details",
                    },
                    -- condition for only server with declaration capabilities
                    gD = {
                        function()
                            vim.lsp.buf.declaration()
                        end,
                        desc = "Declaration of current symbol",
                        cond = "textDocument/declaration",
                    },
                },
            },
        },
    },
}
