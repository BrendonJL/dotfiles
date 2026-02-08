return {
  "folke/edgy.nvim",
  opts = {
    left = {
      {
        ft = "neo-tree",
        size = { width = 40 },
        -- Preserve neo-tree's winbar for tabs
        wo = {
          winbar = true,
        },
      },
      {
        ft = "aerial",
        title = "Symbols",
        size = { width = 35 },
      },
    },
    bottom = {
      {
        ft = "trouble",
        title = "Diagnostics",
        size = { height = 0.3 },
      },
    },
    -- Don't override window options globally
    options = {
      left = { size = 40 },
      bottom = { size = 10 },
    },
  },
}