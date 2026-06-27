return {
    "ckipp01/stylua-nvim",
    config = function()
        local stylua = require("stylua-nvim")
        vim.keymap.set("n", "<M-S-f>", stylua.format_file, {})
    end,
}
