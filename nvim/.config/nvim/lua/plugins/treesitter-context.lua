-- Treesitter context - shows sticky function/class headers when scrolling
return {
  "nvim-treesitter/nvim-treesitter-context",
  event = "VeryLazy",
  opts = {
    enable = true,
    max_lines = 3, -- Max lines to show at top
    min_window_height = 20, -- Disable in small windows
    line_numbers = true,
    multiline_threshold = 20, -- Max lines for multiline context
    trim_scope = "outer", -- Which context to trim if max_lines exceeded
    mode = "cursor", -- Show context for cursor position (vs 'topline')
    separator = "─", -- Separator between context and code
    zindex = 20, -- Z-index of the context window
  },
  config = function(_, opts)
    require("treesitter-context").setup(opts)

    -- Style the context window to match purple theme
    vim.api.nvim_set_hl(0, "TreesitterContext", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", { fg = "#6c7086", bg = "NONE" })
    vim.api.nvim_set_hl(0, "TreesitterContextSeparator", { fg = "#c678dd", bg = "NONE" })
    vim.api.nvim_set_hl(0, "TreesitterContextBottom", { underline = true, sp = "#c678dd" })
  end,
}
