return {
    "olimorris/onedarkpro.nvim",
    ppriority = 1000, -- Ensure it loads first

    config = function()
        vim.cmd.colorscheme("onedark")
    end,
}
