return {
  "epwalsh/obsidian.nvim",
  version = "*",
  lazy = true,
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    workspaces = {
      {
        name = "mlp-notes",
        path = "~/mlp/docs",
      },
    },

    daily_notes = {
      folder = "daily",
      date_format = "%Y-%m-%d",
      template = "daily.md",
    },

    -- Disable nvim-cmp completion since LazyVim uses blink.cmp
    completion = {
      nvim_cmp = false, -- Change this to false
      min_chars = 2,
    },

    templates = {
      subdir = "templates",
      date_format = "%Y-%m-%d",
      time_format = "%H:%M",
    },

    follow_url_func = function(url)
      vim.fn.jobstart({ "xdg-open", url })
    end,
  },
}
