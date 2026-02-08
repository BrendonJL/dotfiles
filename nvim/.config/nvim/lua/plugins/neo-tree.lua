return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  cmd = "Neotree",
  keys = {
    { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "File Explorer" },
    { "<leader>ge", "<cmd>Neotree git_status<cr>", desc = "Git Explorer" },
    { "<leader>be", "<cmd>Neotree buffers<cr>", desc = "Buffer Explorer" },
  },
  opts = {
    sources = { "filesystem", "buffers", "git_status" },
    popup_border_style = "rounded",
    window = {
      width = 40,
      mappings = {
        -- Standard mappings
        ["<space>"] = "none",
        ["<cr>"] = "open",
        ["o"] = "open",
        ["s"] = "open_split",
        ["v"] = "open_vsplit",
        ["t"] = "open_tabnew",
        ["w"] = "open_with_window_picker",
        ["C"] = "close_node",
        ["z"] = "close_all_nodes",
        ["Z"] = "expand_all_nodes",
        ["a"] = {
          "add",
          config = {
            show_path = "relative",
          },
        },
        ["A"] = "add_directory",
        ["d"] = "delete",
        ["r"] = "rename",
        ["y"] = "copy_to_clipboard",
        ["x"] = "cut_to_clipboard",
        ["p"] = "paste_from_clipboard",
        ["c"] = "copy",
        ["m"] = "move",
        ["q"] = "close_window",
        ["R"] = "refresh",
        ["?"] = "show_help",
        ["<"] = "prev_source",
        [">"] = "next_source",
        -- Right-click context menu
        ["<RightMouse>"] = function(state)
          -- Show context menu on right click
          local node = state.tree:get_node()
          if node then
            local Menu = require("nui.menu")
            local event = require("nui.utils.autocmd").event

            local menu_items = {}
            if node.type == "file" then
              table.insert(menu_items, Menu.item("󰏌  Open", { action = "open" }))
              table.insert(menu_items, Menu.item("󰤼  Open in Split", { action = "open_split" }))
              table.insert(menu_items, Menu.item("󰤻  Open in VSplit", { action = "open_vsplit" }))
              table.insert(menu_items, Menu.separator("─"))
            end
            table.insert(menu_items, Menu.item("󰝒  New File", { action = "add" }))
            table.insert(menu_items, Menu.item("󰉗  New Directory", { action = "add_directory" }))
            table.insert(menu_items, Menu.separator("─"))
            table.insert(menu_items, Menu.item("󰑕  Rename", { action = "rename" }))
            table.insert(menu_items, Menu.item("󰪹  Move", { action = "move" }))
            table.insert(menu_items, Menu.item("󰆏  Copy", { action = "copy_to_clipboard" }))
            table.insert(menu_items, Menu.item("󰆐  Cut", { action = "cut_to_clipboard" }))
            table.insert(menu_items, Menu.item("󰆒  Paste", { action = "paste_from_clipboard" }))
            table.insert(menu_items, Menu.separator("─"))
            table.insert(menu_items, Menu.item("󰩹  Delete", { action = "delete" }))

            local menu = Menu({
              position = {
                row = 1,
                col = 0,
              },
              relative = "cursor",
              size = {
                width = 25,
                height = #menu_items,
              },
              border = {
                style = "rounded",
                text = {
                  top = " Actions ",
                  top_align = "center",
                },
              },
              win_options = {
                winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
              },
            }, {
              lines = menu_items,
              max_width = 25,
              keymap = {
                focus_next = { "j", "<Down>", "<Tab>" },
                focus_prev = { "k", "<Up>", "<S-Tab>" },
                close = { "<Esc>", "q" },
                submit = { "<CR>", "<Space>" },
              },
              on_submit = function(item)
                if item.action then
                  local commands = require("neo-tree.sources.filesystem.commands")
                  if commands[item.action] then
                    commands[item.action](state)
                  else
                    local common = require("neo-tree.sources.common.commands")
                    if common[item.action] then
                      common[item.action](state)
                    end
                  end
                end
              end,
            })

            menu:mount()
            menu:on(event.BufLeave, function()
              menu:unmount()
            end)
          end
        end,
        ["<2-RightMouse>"] = "none",
      },
    },
    source_selector = {
      winbar = true,
      statusline = false,
      show_separator_on_edge = true,
      content_layout = "center", -- Center the tab content
      separator_style = { "", "" }, -- Minimal separators
      -- Explicitly set highlight groups for purple theme
      highlight_tab = "NeoTreeTabInactive",
      highlight_tab_active = "NeoTreeTabActive",
      highlight_background = "NeoTreeTabInactive",
      highlight_separator = "NeoTreeTabSeparatorInactive",
      highlight_separator_active = "NeoTreeTabSeparatorActive",
      tabs = {
        { source = "filesystem", display_name = " 󰉓 Files " },
        { source = "buffers", display_name = " 󰈚 Buffers " },
        { source = "git_status", display_name = " 󰊢 Git " },
      },
    },
    filesystem = {
      filtered_items = {
        hide_dotfiles = false,
        hide_gitignored = false,
      },
      follow_current_file = {
        enabled = false,
      },
      use_libuv_file_watcher = true,
      commands = {
        -- Custom command to show context menu
        show_context_menu = function(state)
          local node = state.tree:get_node()
          local Menu = require("nui.menu")
          local event = require("nui.utils.autocmd").event

          local menu_items = {}
          if node.type == "file" then
            table.insert(menu_items, Menu.item("󰏌  Open", { action = "open" }))
            table.insert(menu_items, Menu.item("󰤼  Open in Split", { action = "open_split" }))
            table.insert(menu_items, Menu.item("󰤻  Open in VSplit", { action = "open_vsplit" }))
            table.insert(menu_items, Menu.separator("─"))
          end
          table.insert(menu_items, Menu.item("󰝒  New File", { action = "add" }))
          table.insert(menu_items, Menu.item("󰉗  New Directory", { action = "add_directory" }))
          table.insert(menu_items, Menu.separator("─"))
          table.insert(menu_items, Menu.item("󰑕  Rename", { action = "rename" }))
          table.insert(menu_items, Menu.item("󰪹  Move", { action = "move" }))
          table.insert(menu_items, Menu.item("󰆏  Copy", { action = "copy_to_clipboard" }))
          table.insert(menu_items, Menu.item("󰆐  Cut", { action = "cut_to_clipboard" }))
          table.insert(menu_items, Menu.item("󰆒  Paste", { action = "paste_from_clipboard" }))
          table.insert(menu_items, Menu.separator("─"))
          table.insert(menu_items, Menu.item("󰩹  Delete", { action = "delete" }))

          local menu = Menu({
            position = "50%",
            size = {
              width = 25,
              height = #menu_items,
            },
            border = {
              style = "rounded",
              text = {
                top = " Actions ",
                top_align = "center",
              },
            },
            win_options = {
              winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
            },
          }, {
            lines = menu_items,
            max_width = 25,
            keymap = {
              focus_next = { "j", "<Down>", "<Tab>" },
              focus_prev = { "k", "<Up>", "<S-Tab>" },
              close = { "<Esc>", "q" },
              submit = { "<CR>", "<Space>" },
            },
            on_submit = function(item)
              if item.action then
                local commands = require("neo-tree.sources.filesystem.commands")
                if commands[item.action] then
                  commands[item.action](state)
                else
                  -- Try common commands
                  local common = require("neo-tree.sources.common.commands")
                  if common[item.action] then
                    common[item.action](state)
                  end
                end
              end
            end,
          })

          menu:mount()
          menu:on(event.BufLeave, function()
            menu:unmount()
          end)
        end,
      },
    },
    default_component_configs = {
      container = {
        enable_character_fade = false,
      },
      icon = {
        folder_closed = "",
        folder_open = "",
        folder_empty = "",
      },
      git_status = {
        symbols = {
          added = "✚",
          modified = "",
          deleted = "✖",
          renamed = "󰁕",
          untracked = "",
          ignored = "",
          unstaged = "󰄱",
          staged = "",
          conflict = "",
        },
      },
    },
    event_handlers = {
      {
        event = "neo_tree_popup_input_ready",
        handler = function(args)
          vim.cmd("stopinsert")
          vim.keymap.set("i", "<esc>", vim.cmd.stopinsert, { noremap = true, buffer = args.bufnr })
        end,
      },
    },
  },
  config = function(_, opts)
    require("neo-tree").setup(opts)

    -- Add keybinding for context menu (press 'M' for menu)
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "neo-tree",
      callback = function()
        vim.keymap.set("n", "M", function()
          local state = require("neo-tree.sources.manager").get_state("filesystem")
          if state and state.tree then
            -- Call our custom command directly from opts
            opts.filesystem.commands.show_context_menu(state)
          end
        end, { buffer = true, desc = "Show context menu" })
      end,
    })
  end,
}
