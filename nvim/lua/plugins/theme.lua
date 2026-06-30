return {
  "sainnhe/sonokai",
  lazy = false,
  priority = 1000,
  init = function() -- init function runs before the plugin is loaded
    vim.g.sonokai_enable_italic = 1
    vim.g.sonokai_style = "default"
    vim.g.sonokai_dim_inactive_windows = 1
    vim.g.sonokai_cursor = "auto"
  end,
}
