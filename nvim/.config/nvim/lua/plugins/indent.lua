-- Indent scope and guides
return {
  -- Mini.indentscope - animated indent scope indicator
  {
    "nvim-mini/mini.indentscope",
    version = false,
    event = "LazyFile",
    opts = function()
      return {
        symbol = "│",
        options = { try_as_border = true },
        draw = {
          delay = 50,
          animation = require("mini.indentscope").gen_animation.none(),
        },
      }
    end,
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
          "snacks_dashboard",
        },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
  },

  -- Indent-blankline for static indent guides (optional enhancement)
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
      },
      scope = { enabled = false }, -- We use mini.indentscope for this
      exclude = {
        filetypes = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
          "snacks_dashboard",
        },
      },
    },
  },
}
