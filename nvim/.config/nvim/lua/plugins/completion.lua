-- Blink.cmp completion styling (Purple themed)
return {
  "saghen/blink.cmp",
  opts = {
    completion = {
      menu = {
        border = "rounded",
        winhighlight = "Normal:BlinkCmpMenu,NormalFloat:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
        winblend = 0,
        scrollbar = false,
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
        window = {
          border = "rounded",
          winhighlight = "Normal:BlinkCmpDoc,NormalFloat:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder",
          winblend = 0,
        },
      },
    },
  },
  init = function()
    -- Purple themed completion highlights (matching NONE background)
    -- Menu highlights - ensure bg is set on ALL to prevent gaps
    vim.api.nvim_set_hl(0, "BlinkCmpMenu", { bg = "NONE", fg = "#cdd6f4" })
    vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", { bg = "NONE", fg = "#89b4fa" })
    vim.api.nvim_set_hl(0, "BlinkCmpMenuSelection", { bg = "NONE", fg = "#cdd6f4" })

    -- Documentation window highlights
    vim.api.nvim_set_hl(0, "BlinkCmpDoc", { bg = "NONE", fg = "#cdd6f4" })
    vim.api.nvim_set_hl(0, "BlinkCmpDocBorder", { bg = "NONE", fg = "#89b4fa" })
    vim.api.nvim_set_hl(0, "BlinkCmpDocSeparator", { bg = "NONE", fg = "#6c7086" })
    vim.api.nvim_set_hl(0, "BlinkCmpLabel", { fg = "#cdd6f4" })
    vim.api.nvim_set_hl(0, "BlinkCmpLabelMatch", { fg = "#cba6f7", bold = true })

    -- Kind colors (colorful variety)
    vim.api.nvim_set_hl(0, "BlinkCmpKindFunction", { fg = "#89b4fa" })      -- Blue
    vim.api.nvim_set_hl(0, "BlinkCmpKindMethod", { fg = "#89b4fa" })        -- Blue
    vim.api.nvim_set_hl(0, "BlinkCmpKindVariable", { fg = "#cba6f7" })      -- Mauve
    vim.api.nvim_set_hl(0, "BlinkCmpKindField", { fg = "#cba6f7" })         -- Mauve
    vim.api.nvim_set_hl(0, "BlinkCmpKindProperty", { fg = "#cba6f7" })      -- Mauve
    vim.api.nvim_set_hl(0, "BlinkCmpKindClass", { fg = "#fab387" })         -- Peach
    vim.api.nvim_set_hl(0, "BlinkCmpKindStruct", { fg = "#fab387" })        -- Peach
    vim.api.nvim_set_hl(0, "BlinkCmpKindInterface", { fg = "#fab387" })     -- Peach
    vim.api.nvim_set_hl(0, "BlinkCmpKindModule", { fg = "#f9e2af" })        -- Yellow
    vim.api.nvim_set_hl(0, "BlinkCmpKindKeyword", { fg = "#f38ba8" })       -- Red
    vim.api.nvim_set_hl(0, "BlinkCmpKindText", { fg = "#cdd6f4" })          -- White (not green!)
    vim.api.nvim_set_hl(0, "BlinkCmpKindSnippet", { fg = "#89dceb" })       -- Sky
    vim.api.nvim_set_hl(0, "BlinkCmpKindConstant", { fg = "#fab387" })      -- Peach
    vim.api.nvim_set_hl(0, "BlinkCmpKindEnum", { fg = "#fab387" })          -- Peach
    vim.api.nvim_set_hl(0, "BlinkCmpKindEnumMember", { fg = "#89dceb" })    -- Sky
    vim.api.nvim_set_hl(0, "BlinkCmpKindConstructor", { fg = "#89b4fa" })   -- Blue
    vim.api.nvim_set_hl(0, "BlinkCmpKindReference", { fg = "#f38ba8" })     -- Red
    vim.api.nvim_set_hl(0, "BlinkCmpKindFile", { fg = "#cdd6f4" })          -- Text
    vim.api.nvim_set_hl(0, "BlinkCmpKindFolder", { fg = "#f9e2af" })        -- Yellow
    vim.api.nvim_set_hl(0, "BlinkCmpKindEvent", { fg = "#fab387" })         -- Peach
    vim.api.nvim_set_hl(0, "BlinkCmpKindOperator", { fg = "#94e2d5" })      -- Teal
    vim.api.nvim_set_hl(0, "BlinkCmpKindTypeParameter", { fg = "#cba6f7" }) -- Mauve
    vim.api.nvim_set_hl(0, "BlinkCmpKindCopilot", { fg = "#a6e3a1" })       -- Green
    vim.api.nvim_set_hl(0, "BlinkCmpKindMinuet", { fg = "#d4a574" })       -- Claude orange/tan
    vim.api.nvim_set_hl(0, "BlinkCmpKindValue", { fg = "#fab387" })         -- Peach
    vim.api.nvim_set_hl(0, "BlinkCmpKindUnit", { fg = "#fab387" })          -- Peach
    vim.api.nvim_set_hl(0, "BlinkCmpKindColor", { fg = "#cba6f7" })         -- Mauve
  end,
}
