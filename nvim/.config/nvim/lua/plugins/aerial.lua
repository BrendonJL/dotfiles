-- Aerial symbol outline
return {
  "stevearc/aerial.nvim",
  event = "LazyFile",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    { "<leader>cs", "<cmd>AerialToggle<cr>", desc = "Symbols Outline (Aerial)" },
    { "<leader>cS", "<cmd>AerialNavToggle<cr>", desc = "Symbols Nav (Aerial)" },
    { "[s", "<cmd>AerialPrev<cr>", desc = "Previous Symbol" },
    { "]s", "<cmd>AerialNext<cr>", desc = "Next Symbol" },
  },
  opts = {
    -- Backend priority
    backends = { "lsp", "treesitter", "markdown", "man" },

    -- Layout options
    layout = {
      max_width = { 40, 0.2 },
      min_width = 30,
      default_direction = "prefer_left",
      placement = "edge",
      preserve_equality = false,
    },

    -- Attach behavior
    attach_mode = "global",

    -- Keymaps in aerial window
    keymaps = {
      ["?"] = "actions.show_help",
      ["g?"] = "actions.show_help",
      ["<CR>"] = "actions.jump",
      ["<2-LeftMouse>"] = "actions.jump",
      ["<C-v>"] = "actions.jump_vsplit",
      ["<C-s>"] = "actions.jump_split",
      ["p"] = "actions.scroll",
      ["<C-j>"] = "actions.down_and_scroll",
      ["<C-k>"] = "actions.up_and_scroll",
      ["{"] = "actions.prev",
      ["}"] = "actions.next",
      ["[["] = "actions.prev_up",
      ["]]"] = "actions.next_up",
      ["q"] = "actions.close",
      ["o"] = "actions.tree_toggle",
      ["za"] = "actions.tree_toggle",
      ["O"] = "actions.tree_toggle_recursive",
      ["zA"] = "actions.tree_toggle_recursive",
      ["l"] = "actions.tree_open",
      ["zo"] = "actions.tree_open",
      ["L"] = "actions.tree_open_recursive",
      ["zO"] = "actions.tree_open_recursive",
      ["h"] = "actions.tree_close",
      ["zc"] = "actions.tree_close",
      ["H"] = "actions.tree_close_recursive",
      ["zC"] = "actions.tree_close_recursive",
      ["zr"] = "actions.tree_increase_fold_level",
      ["zR"] = "actions.tree_open_all",
      ["zm"] = "actions.tree_decrease_fold_level",
      ["zM"] = "actions.tree_close_all",
      ["zx"] = "actions.tree_sync_folds",
      ["zX"] = "actions.tree_sync_folds",
    },

    -- Filter symbols
    filter_kind = {
      "Class",
      "Constructor",
      "Enum",
      "Function",
      "Interface",
      "Module",
      "Method",
      "Struct",
    },

    -- Highlight
    highlight_mode = "split_width",
    highlight_closest = true,
    highlight_on_hover = true,
    highlight_on_jump = 300,

    -- Icons
    icons = {
      Class = "󰠱 ",
      Constant = "󰏿 ",
      Constructor = " ",
      Enum = " ",
      EnumMember = " ",
      Event = " ",
      Field = "󰜢 ",
      File = "󰈙 ",
      Function = "󰊕 ",
      Interface = " ",
      Key = "󰌋 ",
      Method = "󰆧 ",
      Module = " ",
      Namespace = "󰌗 ",
      Null = "󰟢 ",
      Number = "󰎠 ",
      Object = "󰅩 ",
      Operator = "󰆕 ",
      Package = " ",
      Property = "󰜢 ",
      String = "󰀬 ",
      Struct = "󰙅 ",
      TypeParameter = "󰊄 ",
      Variable = "󰀫 ",
    },

    -- Show guides
    show_guides = true,
    guides = {
      mid_item = "├─",
      last_item = "└─",
      nested_top = "│ ",
      whitespace = "  ",
    },

    -- Float preview
    float = {
      border = "rounded",
      relative = "cursor",
      max_height = 0.9,
      min_height = { 8, 0.1 },
    },

    -- Nav window
    nav = {
      border = "rounded",
      max_height = 0.9,
      min_height = { 10, 0.1 },
      max_width = 0.5,
      min_width = { 0.2, 20 },
      win_opts = {
        cursorline = true,
        winblend = 10,
      },
      autojump = false,
      preview = true,
      keymaps = {
        ["<CR>"] = "actions.jump",
        ["<2-LeftMouse>"] = "actions.jump",
        ["<C-v>"] = "actions.jump_vsplit",
        ["<C-s>"] = "actions.jump_split",
        ["h"] = "actions.left",
        ["l"] = "actions.right",
        ["<C-c>"] = "actions.close",
        ["q"] = "actions.close",
      },
    },
  },
}
