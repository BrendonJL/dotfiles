-- Trouble diagnostics list configuration (Catppuccin Mocha themed)
return {
  "folke/trouble.nvim",
  opts = {
    -- Enable text wrapping in the Trouble window
    win = {
      wo = {
        wrap = true,
        linebreak = true,
        winhighlight = "Normal:TroubleNormal,NormalNC:TroubleNormalNC",
      },
    },
  },
  config = function(_, opts)
    require("trouble").setup(opts)
    -- Set Trouble background to match purple theme
    vim.api.nvim_set_hl(0, "TroubleNormal", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "TroubleNormalNC", { bg = "NONE" })
  end,
}
