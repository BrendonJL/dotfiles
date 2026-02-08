-- Bufferline styling (Catppuccin Mocha themed)
return {
  "akinsho/bufferline.nvim",
  event = "VeryLazy",
  keys = {
    { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
    { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
    { "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>", desc = "Delete Other Buffers" },
    { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete Buffers to the Right" },
    { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete Buffers to the Left" },
    { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
    { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
    { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
    { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
    { "[B", "<cmd>BufferLineMovePrev<cr>", desc = "Move Buffer Prev" },
    { "]B", "<cmd>BufferLineMoveNext<cr>", desc = "Move Buffer Next" },
  },
  opts = {
    options = {
      mode = "buffers",
      themable = true,
      numbers = "none",
      close_command = "bdelete! %d",
      right_mouse_command = "bdelete! %d",
      left_mouse_command = "buffer %d",
      middle_mouse_command = nil,
      indicator = {
        icon = "▎",
        style = "icon",
      },
      buffer_close_icon = "󰅖",
      modified_icon = "●",
      close_icon = "",
      left_trunc_marker = "",
      right_trunc_marker = "",
      max_name_length = 30,
      max_prefix_length = 15,
      truncate_names = true,
      tab_size = 18,
      diagnostics = "nvim_lsp",
      diagnostics_update_in_insert = false,
      diagnostics_indicator = function(count, level, diagnostics_dict, context)
        local icons = {
          error = " ",
          warning = " ",
          info = " ",
          hint = " ",
        }
        local icon = icons[level] or ""
        return " " .. icon .. count
      end,
      offsets = {
        {
          filetype = "neo-tree",
          text = "File Explorer",
          text_align = "center",
          separator = false,
          highlight = "Directory",
        },
        {
          filetype = "aerial",
          text = "Symbols",
          text_align = "center",
          separator = false,
        },
      },
      color_icons = true,
      show_buffer_icons = true,
      show_buffer_close_icons = true,
      show_close_icon = false,
      show_tab_indicators = true,
      show_duplicate_prefix = true,
      persist_buffer_sort = true,
      separator_style = "thin",
      enforce_regular_tabs = false,
      always_show_bufferline = true,
      hover = {
        enabled = true,
        delay = 100,
        reveal = { "close" },
      },
      sort_by = "insert_after_current",
    },
    highlights = {
      -- Catppuccin Mocha colors
      fill = {
        bg = "NONE",
      },
      background = {
        fg = "#6c7086",
        bg = "NONE",
        italic = true,
      },
      tab = {
        fg = "#6c7086",
        bg = "NONE",
      },
      tab_selected = {
        fg = "#cdd6f4",
        bg = "NONE",
        bold = true,
      },
      tab_separator = {
        fg = "#313244",
        bg = "NONE",
      },
      tab_separator_selected = {
        fg = "#313244",
        bg = "NONE",
      },
      buffer_visible = {
        fg = "#89b4fa",
        bg = "NONE",
      },
      buffer_selected = {
        fg = "#cdd6f4",
        bg = "NONE",
        bold = true,
        italic = false,
      },
      close_button = {
        fg = "#6c7086",
        bg = "NONE",
      },
      close_button_visible = {
        fg = "#89b4fa",
        bg = "NONE",
      },
      close_button_selected = {
        fg = "#f38ba8",
        bg = "NONE",
      },
      numbers = {
        fg = "#6c7086",
        bg = "NONE",
      },
      numbers_visible = {
        fg = "#89b4fa",
        bg = "NONE",
      },
      numbers_selected = {
        fg = "#cdd6f4",
        bg = "NONE",
        bold = true,
      },
      diagnostic = {
        fg = "#6c7086",
        bg = "NONE",
      },
      diagnostic_visible = {
        fg = "#89b4fa",
        bg = "NONE",
      },
      diagnostic_selected = {
        fg = "#cdd6f4",
        bg = "NONE",
        bold = true,
      },
      hint = {
        fg = "#94e2d5",
        bg = "NONE",
      },
      hint_visible = {
        fg = "#94e2d5",
        bg = "NONE",
      },
      hint_selected = {
        fg = "#94e2d5",
        bg = "NONE",
        bold = true,
      },
      hint_diagnostic = {
        fg = "#94e2d5",
        bg = "NONE",
      },
      hint_diagnostic_visible = {
        fg = "#94e2d5",
        bg = "NONE",
      },
      hint_diagnostic_selected = {
        fg = "#94e2d5",
        bg = "NONE",
        bold = true,
      },
      info = {
        fg = "#89dceb",
        bg = "NONE",
      },
      info_visible = {
        fg = "#89dceb",
        bg = "NONE",
      },
      info_selected = {
        fg = "#89dceb",
        bg = "NONE",
        bold = true,
      },
      info_diagnostic = {
        fg = "#89dceb",
        bg = "NONE",
      },
      info_diagnostic_visible = {
        fg = "#89dceb",
        bg = "NONE",
      },
      info_diagnostic_selected = {
        fg = "#89dceb",
        bg = "NONE",
        bold = true,
      },
      warning = {
        fg = "#f9e2af",
        bg = "NONE",
      },
      warning_visible = {
        fg = "#f9e2af",
        bg = "NONE",
      },
      warning_selected = {
        fg = "#f9e2af",
        bg = "NONE",
        bold = true,
      },
      warning_diagnostic = {
        fg = "#f9e2af",
        bg = "NONE",
      },
      warning_diagnostic_visible = {
        fg = "#f9e2af",
        bg = "NONE",
      },
      warning_diagnostic_selected = {
        fg = "#f9e2af",
        bg = "NONE",
        bold = true,
      },
      error = {
        fg = "#f38ba8",
        bg = "NONE",
      },
      error_visible = {
        fg = "#f38ba8",
        bg = "NONE",
      },
      error_selected = {
        fg = "#f38ba8",
        bg = "NONE",
        bold = true,
      },
      error_diagnostic = {
        fg = "#f38ba8",
        bg = "NONE",
      },
      error_diagnostic_visible = {
        fg = "#f38ba8",
        bg = "NONE",
      },
      error_diagnostic_selected = {
        fg = "#f38ba8",
        bg = "NONE",
        bold = true,
      },
      modified = {
        fg = "#f9e2af",
        bg = "NONE",
      },
      modified_visible = {
        fg = "#f9e2af",
        bg = "NONE",
      },
      modified_selected = {
        fg = "#a6e3a1",
        bg = "NONE",
      },
      duplicate = {
        fg = "#6c7086",
        bg = "NONE",
        italic = true,
      },
      duplicate_visible = {
        fg = "#89b4fa",
        bg = "NONE",
        italic = true,
      },
      duplicate_selected = {
        fg = "#cba6f7",
        bg = "NONE",
        italic = true,
      },
      separator = {
        fg = "#313244",
        bg = "NONE",
      },
      separator_visible = {
        fg = "#313244",
        bg = "NONE",
      },
      separator_selected = {
        fg = "#313244",
        bg = "NONE",
      },
      indicator_visible = {
        fg = "#6c7086",
        bg = "NONE",
      },
      indicator_selected = {
        fg = "#89b4fa",
        bg = "NONE",
      },
      pick = {
        fg = "#f38ba8",
        bg = "NONE",
        bold = true,
      },
      pick_visible = {
        fg = "#f38ba8",
        bg = "NONE",
        bold = true,
      },
      pick_selected = {
        fg = "#f38ba8",
        bg = "NONE",
        bold = true,
      },
      offset_separator = {
        fg = "#313244",
        bg = "NONE",
      },
      trunc_marker = {
        fg = "#6c7086",
        bg = "NONE",
      },
    },
  },
}
