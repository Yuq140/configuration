-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
    "AstroNvim/astrocommunity",

    -- Recipes
    { import = "astrocommunity.recipes.picker-lsp-mappings" },
    { import = "astrocommunity.recipes.ai" },

    -- Language packs
    { import = "astrocommunity.pack.lua" },
    { import = "astrocommunity.pack.prettier" },
    { import = "astrocommunity.pack.typescript" },
    { import = "astrocommunity.pack.cs" },

    { import = "astrocommunity.bars-and-lines.smartcolumn-nvim" },
}
