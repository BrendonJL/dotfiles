return {
  {
    "ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup({
        detection_methods = { "pattern", "lsp" },
        patterns = { ".git", "Makefile", "package.json", "Cargo.toml" },
      })

      -- Load the telescope extension
      require("telescope").load_extension("projects")
    end,
  },
}
