return {
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        build = ":TSUpdate",
        init = function()
            local parsers = {
                "lua",
                "vim",
                "vimdoc",
                "query",
                "javascript",
                "typescript",
                "tsx",
                "html",
                "css",
                "json",
                "gitignore",
            }

            local group =
                vim.api.nvim_create_augroup("TreeSitterGroup", { clear = true })
            vim.api.nvim_create_autocmd({ "BufEnter", "FileType" }, {
                group = group,
                callback = function()
                    if vim.bo.buftype ~= "" then
                        return
                    end

                    pcall(vim.treesitter.start, 0)
                end,
            })

            vim.api.nvim_create_autocmd("User", {
                group = group,
                pattern = "VeryLazy",
                once = true,
                callback = function()
                    require("nvim-treesitter").install(parsers)
                end,
            })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        lazy = false,
        config = function()
            require("nvim-treesitter-textobjects").setup({
                select = {
                    enable = true,
                    lookahead = true,
                    keymaps = {
                        ["af"] = "@function.outer",
                        ["if"] = "@function.inner",
                    },
                },
            })
        end,
    },

    -- Automatically add closing tags for HTML and JSX
    {
        "windwp/nvim-ts-autotag",
        event = { "BufReadPre", "BufNewFile" },
        opts = {},
    },
}
