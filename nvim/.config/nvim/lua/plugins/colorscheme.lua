-- Disable LazyVim's default colorscheme (catppuccin)
-- DMS handles colors via dankcolors.lua
return {
  -- Disable catppuccin
  { "catppuccin/nvim", enabled = false },

  -- Tell LazyVim to not set a colorscheme (dankcolors.lua handles it)
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = function() end, -- no-op, let dankcolors.lua handle it
    },
  },
}
