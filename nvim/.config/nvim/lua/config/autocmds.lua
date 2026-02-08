-- Snacks highlight theming (purple vibe)
local function set_snacks_hl()
  -- Footer text
  vim.api.nvim_set_hl(0, "SnacksFooter", { fg = "#A667BA" })
  -- Footer key hints (make them pop)
  vim.api.nvim_set_hl(0, "SnacksFooterKey", { fg = "#FFFFFF", bg = "#401D61", bold = true })

  -- Dashboard embedded terminal section (if present)
  vim.api.nvim_set_hl(0, "SnacksDashboardTerminal", { bg = "#251A47" })

  -- Optional: make borders match your purple
  vim.api.nvim_set_hl(0, "SnacksInputBorder", { fg = "#643A93" })
  vim.api.nvim_set_hl(0, "SnacksPickerInputBorder", { fg = "#643A93" })
  vim.api.nvim_set_hl(0, "SnacksPickerBoxBorder", { fg = "#643A93" })
  vim.api.nvim_set_hl(0, "SnacksPickerListBorder", { fg = "#643A93" })
  vim.api.nvim_set_hl(0, "SnacksPickerPreviewBorder", { fg = "#643A93" })
end

set_snacks_hl()

-- Reapply after colorscheme changes
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("snacks_theme", { clear = true }),
  callback = set_snacks_hl,
})

-- Force the background color to stick
local function set_purple_bg()
  vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE" })
  -- Floating windows need a real background (for terminals, popups)
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#1a1a1a" })
  vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#6c7086", bg = "#1a1a1a" })
  -- Statusline - transparent to blend with background
  vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE" })

  -- Neo-tree - ALL highlights must have purple bg
  vim.api.nvim_set_hl(0, "NeoTreeNormal", { bg = "NONE", fg = "#cdd6f4" })
  vim.api.nvim_set_hl(0, "NeoTreeNormalNC", { bg = "NONE", fg = "#cdd6f4" })
  vim.api.nvim_set_hl(0, "NeoTreeEndOfBuffer", { bg = "NONE", fg = "NONE" })
  -- Neo-tree source selector tabs (the "File Explorer" area)
  vim.api.nvim_set_hl(0, "NeoTreeTabActive", { fg = "#cdd6f4", bg = "NONE", bold = true })
  vim.api.nvim_set_hl(0, "NeoTreeTabInactive", { fg = "#6c7086", bg = "NONE" })
  vim.api.nvim_set_hl(0, "NeoTreeTabSeparatorActive", { fg = "#c678dd", bg = "NONE" })
  vim.api.nvim_set_hl(0, "NeoTreeTabSeparatorInactive", { fg = "#313244", bg = "NONE" })
  -- WinBar (neo-tree uses this for the top bar)
  vim.api.nvim_set_hl(0, "WinBar", { fg = "#cdd6f4", bg = "NONE", bold = true })
  vim.api.nvim_set_hl(0, "WinBarNC", { fg = "#6c7086", bg = "NONE" })
  vim.api.nvim_set_hl(0, "NeoTreeWinBar", { fg = "#cdd6f4", bg = "NONE", bold = true })

  -- TabLine (the area behind bufferline - this was the grey culprit!)
  vim.api.nvim_set_hl(0, "TabLine", { fg = "#6c7086", bg = "NONE" })
  vim.api.nvim_set_hl(0, "TabLineFill", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "TabLineSel", { fg = "#cdd6f4", bg = "NONE", bold = true })

  -- Blink.cmp completion menu
  vim.api.nvim_set_hl(0, "BlinkCmpMenu", { bg = "NONE", fg = "#cdd6f4" })
  vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", { bg = "NONE", fg = "#89b4fa" })
  vim.api.nvim_set_hl(0, "BlinkCmpMenuSelection", { bg = "NONE", fg = "#cdd6f4" })
  vim.api.nvim_set_hl(0, "BlinkCmpDoc", { bg = "NONE", fg = "#cdd6f4" })
  vim.api.nvim_set_hl(0, "BlinkCmpDocBorder", { bg = "NONE", fg = "#89b4fa" })

  -- Diagnostics
  vim.api.nvim_set_hl(0, "DiagnosticNormal", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "DiagnosticNormalNC", { bg = "NONE" })

  -- Bufferline - force transparent backgrounds
  vim.api.nvim_set_hl(0, "BufferLineFill", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "BufferLineBackground", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "BufferLineBufferSelected", { bg = "NONE", bold = true })
  vim.api.nvim_set_hl(0, "BufferLineBufferVisible", { bg = "NONE" })
end
-- Run on multiple events
vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter", "UIEnter" }, {
  group = vim.api.nvim_create_augroup("custom_bg", { clear = true }),
  callback = set_purple_bg,
})

-- Also run it immediately
set_purple_bg()

-- Fix WinBar specifically when Neo-tree opens (it gets overridden otherwise)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "neo-tree",
  callback = function()
    vim.api.nvim_set_hl(0, "WinBar", { fg = "#cdd6f4", bg = "NONE", bold = true })
    vim.api.nvim_set_hl(0, "WinBarNC", { fg = "#6c7086", bg = "NONE" })
  end,
})
local group = vim.api.nvim_create_augroup("sudo_visual_markers", { clear = true })

-- Customize Claude Code terminal colors (match purple background)
vim.api.nvim_create_autocmd({ "TermOpen", "BufEnter", "WinEnter" }, {
  callback = function()
    local bufname = vim.api.nvim_buf_get_name(0)
    if bufname:match("claude") and vim.bo.buftype == "terminal" then
      local win = vim.api.nvim_get_current_win()
      -- Match the purple background
      vim.api.nvim_set_hl(0, "ClaudeTerminal", { bg = "NONE" })
      vim.wo[win].winhighlight = "Normal:ClaudeTerminal,NormalNC:ClaudeTerminal"
    end
  end,
})
-- Define the sign BEFORE using it
vim.fn.sign_define("SudoFile", {
  text = "🔒",
  texthl = "DiagnosticWarn",
  linehl = "",
  numhl = "",
}) -- Custom highlight groups (don't overwrite global CursorLine/ColorColumn)
vim.api.nvim_set_hl(0, "SudoCursorLine", { bg = "#2a1f3a" })
vim.api.nvim_set_hl(0, "SudoColorColumn", { bg = "#3a1f2a" })

-- MISSING FUNCTION DEFINITION - ADD THIS:
local function is_system_or_sudo_buf(bufnr)
  local real = vim.api.nvim_buf_get_name(bufnr)
  if real:match("^/var/tmp/") then
    return true
  end
  -- readonly buffers
  if vim.bo[bufnr].readonly then
    return true
  end
  return false
end

local function apply_marks(bufnr)
  local win = vim.fn.bufwinid(bufnr)
  if win == -1 then
    return
  end

  local protected = is_system_or_sudo_buf(bufnr)
  vim.b[bufnr].sudo_file = protected

  -- Always clear our sign first
  vim.fn.sign_unplace("sudo_visual_markers", { buffer = bufnr })

  -- Remove our window-local highlight mappings (so it doesn't “stick”)
  local wh = vim.api.nvim_get_option_value("winhighlight", { win = win }) or ""
  wh = wh:gsub(",?CursorLine:SudoCursorLine", ""):gsub(",?ColorColumn:SudoColorColumn", ""):gsub("^,", "")
  vim.api.nvim_set_option_value("winhighlight", wh, { win = win })

  if protected then
    -- Window-local options
    vim.api.nvim_set_option_value("cursorline", true, { win = win })
    vim.api.nvim_set_option_value("colorcolumn", "80", { win = win })

    -- Add our mappings back
    local cur = vim.api.nvim_get_option_value("winhighlight", { win = win }) or ""
    local add = "CursorLine:SudoCursorLine,ColorColumn:SudoColorColumn"
    vim.api.nvim_set_option_value("winhighlight", (cur ~= "" and (cur .. ",") or "") .. add, { win = win })

    -- Place sign on line 1
    vim.fn.sign_place(0, "sudo_visual_markers", "SudoFile", bufnr, { lnum = 1, priority = 10 })

    -- Ensure it renders in the left gutter
    vim.api.nvim_set_option_value("signcolumn", "yes", { win = win })
  else
    -- Optional: turn these off when not protected
    -- vim.api.nvim_set_option_value("cursorline", false, { win = win })
    -- vim.api.nvim_set_option_value("colorcolumn", "", { win = win })
  end
end

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "BufReadPost" }, {
  group = group,
  callback = function(args)
    apply_marks(args.buf)
  end,
})

-- Remove terminal background on dashboard
vim.api.nvim_create_autocmd("FileType", {
  pattern = "snacks_dashboard",
  callback = function()
    vim.cmd([[
      highlight SnacksDashboardTerminal guibg=NONE ctermbg=NONE
      setlocal winhl=Normal:Normal,NormalFloat:Normal
    ]])
  end,
})

-- Completely disable diagnostics for markdown
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function(args)
    vim.diagnostic.enable(false, { bufnr = args.buf })
  end,
})
