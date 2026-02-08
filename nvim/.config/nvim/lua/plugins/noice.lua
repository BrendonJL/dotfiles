return {
  "folke/noice.nvim",
  opts = {
    -- Command line in center with sleek popup
    cmdline = {
      enabled = true,
      view = "cmdline_popup",
      opts = {
        position = {
          row = "40%",
          col = "50%",
        },
        size = {
          width = 70,
          height = "auto",
        },
        border = {
          style = "rounded",
          padding = { 0, 1 },
        },
        win_options = {
          winhighlight = {
            Normal = "Normal",
            FloatBorder = "NoiceCmdlinePopupBorder",
            IncSearch = "",
            CurSearch = "",
          },
        },
      },
      format = {
        cmdline = {
          pattern = "^:",
          icon = "❯",
          icon_hl_group = "NoiceCmdlineIconCmdline",
          lang = "vim",
          title = "",
        },
        search_down = {
          kind = "search",
          pattern = "^/",
          icon = "🔍",
          icon_hl_group = "NoiceCmdlineIconSearch",
          lang = "regex",
          title = "",
        },
        search_up = {
          kind = "search",
          pattern = "^%?",
          icon = "🔍",
          icon_hl_group = "NoiceCmdlineIconSearch",
          lang = "regex",
          title = "",
        },
        filter = {
          pattern = "^:%s*!",
          icon = "$",
          icon_hl_group = "NoiceCmdlineIconFilter",
          lang = "bash",
          title = "",
        },
        lua = {
          pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" },
          icon = "☾",
          icon_hl_group = "NoiceCmdlineIconLua",
          lang = "lua",
          title = "",
        },
        help = {
          pattern = "^:%s*he?l?p?%s+",
          icon = "?",
          icon_hl_group = "NoiceCmdlineIconHelp",
          title = "",
        },
      },
    },

    -- Message handling
    messages = {
      enabled = true,
      view = "notify",
      view_error = "notify",
      view_warn = "notify",
      view_history = "messages",
      view_search = "virtualtext",
    },

    -- Better popups
    popupmenu = {
      enabled = true,
      backend = "nui",
      kind_icons = true,
    },

    -- Simple routes - just skip annoying messages
    routes = {
      {
        filter = {
          event = "msg_show",
          any = {
            { find = "written" },
            { find = "%d+L, %d+B" },
            { find = "; after #%d+" },
            { find = "; before #%d+" },
            { find = "No information available" },
          },
        },
        opts = { skip = true },
      },
      -- Hide stuck LSP progress messages (pyright "analyzing")
      {
        filter = {
          event = "lsp",
          kind = "progress",
          find = "Analyz",
        },
        opts = { skip = true },
      },
    },

    -- LSP configuration
    lsp = {
      progress = {
        enabled = false, -- Disable stuck progress messages
      },
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
      hover = {
        enabled = true,
        silent = false,
      },
      signature = {
        enabled = true,
        auto_open = {
          enabled = true,
          trigger = true,
          luasnip = true,
          throttle = 50,
        },
      },
      message = {
        enabled = true,
        view = "notify",
      },
      documentation = {
        view = "hover",
        opts = {
          lang = "markdown",
          replace = true,
          render = "plain",
          format = { "{message}" },
          win_options = { concealcursor = "n", conceallevel = 3 },
        },
      },
    },

    -- Notifications
    notify = {
      enabled = true,
      view = "notify",
    },

    -- Presets
    presets = {
      bottom_search = false,
      command_palette = true,
      long_message_to_split = true,
      inc_rename = true,
      lsp_doc_border = true,
    },

    -- Custom views
    views = {
      cmdline_popup = {
        position = {
          row = "40%",
          col = "50%",
        },
        size = {
          width = 70,
          height = "auto",
        },
        border = {
          style = "rounded",
          padding = { 0, 1 },
        },
        win_options = {
          winhighlight = {
            Normal = "NormalFloat",
            FloatBorder = "NoiceCmdlinePopupBorder",
          },
        },
      },
      popupmenu = {
        relative = "editor",
        position = {
          row = "45%",
          col = "50%",
        },
        size = {
          width = 70,
          height = 10,
        },
        border = {
          style = "rounded",
          padding = { 0, 1 },
        },
        win_options = {
          winhighlight = {
            Normal = "NoicePopupmenu",
            FloatBorder = "NoicePopupmenuBorder",
            CursorLine = "NoicePopupmenuSelected",
          },
        },
      },
      mini = {
        backend = "mini",
        relative = "editor",
        align = "message-right",
        timeout = 2000,
        reverse = true,
        position = {
          row = -2,
          col = "100%",
        },
        size = "auto",
        border = {
          style = "rounded",
        },
        zindex = 60,
        win_options = {
          winblend = 0,
          winhighlight = {
            Normal = "NoiceMini",
            IncSearch = "",
            CurSearch = "",
            Search = "",
          },
        },
      },
    },
  },

  -- Full purple theme with icon highlights
  config = function(_, opts)
    require("noice").setup(opts)

    -- Border and popup colors
    vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder", { fg = "#A667BA", bg = "NONE" })
    vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorderSearch", { fg = "#B794F6", bg = "NONE" })
    vim.api.nvim_set_hl(0, "NoiceConfirm", { fg = "#FFFFFF", bg = "#401D61" })
    vim.api.nvim_set_hl(0, "NoiceConfirmBorder", { fg = "#A667BA", bg = "NONE" })

    -- Icon colors (IMPORTANT - makes icons visible!)
    vim.api.nvim_set_hl(0, "NoiceCmdlineIcon", { fg = "#A667BA", bold = true })
    vim.api.nvim_set_hl(0, "NoiceCmdlineIconCmdline", { fg = "#A667BA", bold = true })
    vim.api.nvim_set_hl(0, "NoiceCmdlineIconSearch", { fg = "#B794F6", bold = true })
    vim.api.nvim_set_hl(0, "NoiceCmdlineIconLua", { fg = "#B794F6", bold = true })
    vim.api.nvim_set_hl(0, "NoiceCmdlineIconFilter", { fg = "#7B68EE", bold = true })
    vim.api.nvim_set_hl(0, "NoiceCmdlineIconHelp", { fg = "#9370DB", bold = true })

    -- Mini notifications
    vim.api.nvim_set_hl(0, "NoiceMini", { bg = "#1a1a2e", fg = "#e0e0e0" })

    -- LSP progress
    vim.api.nvim_set_hl(0, "NoiceLspProgressTitle", { fg = "#A667BA", bold = true })
    vim.api.nvim_set_hl(0, "NoiceLspProgressClient", { fg = "#B794F6" })
    vim.api.nvim_set_hl(0, "NoiceLspProgressSpinner", { fg = "#A667BA" })

    -- Popupmenu (autocomplete dropdown)
    vim.api.nvim_set_hl(0, "NoicePopupmenu", { bg = "#251A47", fg = "#e0e0e0" })
    vim.api.nvim_set_hl(0, "NoicePopupmenuBorder", { fg = "#A667BA", bg = "NONE" })
    vim.api.nvim_set_hl(0, "NoicePopupmenuSelected", { bg = "#401D61", fg = "#FFFFFF", bold = true })

    -- Progress bars
    vim.api.nvim_set_hl(0, "NoiceFormatProgressDone", { fg = "#FFFFFF", bg = "#401D61", bold = true })
    vim.api.nvim_set_hl(0, "NoiceFormatProgressTodo", { fg = "#666666", bg = "#1a1a2e" })

    -- Inc-rename
    vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorderIncRename", { fg = "#A667BA", bg = "NONE" })
    vim.api.nvim_set_hl(0, "NoiceCmdlinePopupTitleIncRename", { fg = "#FFFFFF", bg = "#401D61" })
  end,

  -- Useful keybinds
  keys = {
    { "<leader>k", "<cmd>Noice<cr>", desc = "Noice Messages" },
    { "<leader>kd", "<cmd>Noice dismiss<cr>", desc = "Dismiss All Notifications" },
    { "<leader>ke", "<cmd>Noice errors<cr>", desc = "Show Errors" },
    {
      "<c-f>",
      function()
        if not require("noice.lsp").scroll(4) then
          return "<c-f>"
        end
      end,
      silent = true,
      expr = true,
      desc = "Scroll Forward",
      mode = { "i", "n", "s" },
    },
    {
      "<c-b>",
      function()
        if not require("noice.lsp").scroll(-4) then
          return "<c-b>"
        end
      end,
      silent = true,
      expr = true,
      desc = "Scroll Backward",
      mode = { "i", "n", "s" },
    },
  },
}

