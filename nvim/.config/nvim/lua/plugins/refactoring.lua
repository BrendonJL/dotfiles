-- Refactoring support for multiple languages
return {
  "ThePrimeagen/refactoring.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  keys = {
    -- Extract operations (visual mode)
    { "<leader>re", function() require("refactoring").refactor("Extract Function") end, desc = "Extract Function", mode = "x" },
    { "<leader>rf", function() require("refactoring").refactor("Extract Function To File") end, desc = "Extract Function To File", mode = "x" },
    { "<leader>rv", function() require("refactoring").refactor("Extract Variable") end, desc = "Extract Variable", mode = "x" },

    -- Inline operations
    { "<leader>ri", function() require("refactoring").refactor("Inline Variable") end, desc = "Inline Variable", mode = { "n", "x" } },
    { "<leader>rI", function() require("refactoring").refactor("Inline Function") end, desc = "Inline Function", mode = "n" },

    -- Extract block (normal mode)
    { "<leader>rb", function() require("refactoring").refactor("Extract Block") end, desc = "Extract Block", mode = "n" },
    { "<leader>rB", function() require("refactoring").refactor("Extract Block To File") end, desc = "Extract Block To File", mode = "n" },

    -- Debug print statements
    { "<leader>rp", function() require("refactoring").debug.printf({ below = false }) end, desc = "Debug Print" },
    { "<leader>rP", function() require("refactoring").debug.print_var() end, desc = "Debug Print Variable", mode = { "n", "x" } },
    { "<leader>rc", function() require("refactoring").debug.cleanup({}) end, desc = "Debug Cleanup" },

    -- Refactor menu (shows all available refactors)
    { "<leader>rr", function() require("refactoring").select_refactor() end, desc = "Select Refactor", mode = { "n", "x" } },
  },
  opts = {
    prompt_func_return_type = {
      go = true,
      cpp = true,
      c = true,
    },
    prompt_func_param_type = {
      go = true,
      cpp = true,
      c = true,
    },
  },
}
