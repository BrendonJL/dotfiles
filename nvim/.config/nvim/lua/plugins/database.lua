-- Database client for PostgreSQL (and other databases)
return {
  -- Core database plugin
  {
    "tpope/vim-dadbod",
    cmd = "DB",
  },

  -- UI for database management
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
    },
    cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
    keys = {
      { "<leader>Du", "<cmd>DBUIToggle<cr>", desc = "Toggle Database UI" },
      { "<leader>Da", "<cmd>DBUIAddConnection<cr>", desc = "Add Database Connection" },
      { "<leader>Df", "<cmd>DBUIFindBuffer<cr>", desc = "Find Database Buffer" },
    },
    init = function()
      -- DBUI configuration
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_show_database_icon = 1
      vim.g.db_ui_force_echo_notifications = 1

      -- Save queries in a dedicated location
      vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/db_ui"

      -- Table helpers (useful keybinds in DBUI)
      vim.g.db_ui_table_helpers = {
        postgresql = {
          Count = "SELECT COUNT(*) FROM {table}",
          List = "SELECT * FROM {table} LIMIT 100",
          Schema = "\\d+ {table}",
          Indexes = "SELECT * FROM pg_indexes WHERE tablename = '{table}'",
        },
      }

      -- Mario RL database connection
      vim.g.dbs = {
        { name = "mario_rl", url = "postgresql://mario_rl_user:Bingbongbing123!@localhost:5432/mario_rl_db" },
      }
    end,
  },

  -- Autocompletion for SQL (works with blink via nvim-cmp compat)
  {
    "saghen/blink.cmp",
    optional = true,
    dependencies = { "kristijanhusak/vim-dadbod-completion", "saghen/blink.compat" },
    opts = {
      sources = {
        default = { "dadbod", "lsp", "path", "snippets", "buffer" },
        providers = {
          dadbod = {
            name = "Dadbod",
            module = "blink.compat.source",
            score_offset = 85,
          },
        },
        -- Only enable dadbod completion in SQL files
        per_filetype = {
          sql = { "dadbod", "snippets", "buffer" },
          mysql = { "dadbod", "snippets", "buffer" },
          plsql = { "dadbod", "snippets", "buffer" },
        },
      },
    },
  },
}
