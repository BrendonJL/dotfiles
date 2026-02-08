-- Register which-key groups
local ok, wk = pcall(require, "which-key")
if ok then
  wk.add({
    { "<leader>N", group = "Notes", icon = "📝" },
    { "<leader>a", group = "AI", icon = "🤖" },
    { "<leader>k", group = "Noice", icon = "🔔" },
    { "<leader>h", icon = "🏠" }, -- Add dashboard icon
    { "<leader>K", group = "Keywordprg", icon = "📖" }, -- Help/docs lookup
  })
end -- Dashboard
vim.keymap.set("n", "<leader>h", function()
  local ok, snacks = pcall(require, "snacks")
  if ok and snacks.dashboard and snacks.dashboard.open then
    return snacks.dashboard.open()
  end
  if _G.Snacks and Snacks.dashboard and Snacks.dashboard.open then
    return Snacks.dashboard.open()
  end
  vim.notify("Snacks dashboard not available", vim.log.levels.WARN)
end, { desc = "Dashboard" })

-- ===== MARKDOWN TEMPLATES (space + o) =====
-- Obsidian daily note
vim.keymap.set("n", "<leader>Nt", function()
  vim.cmd("ObsidianToday")
end, { desc = "Open today's note" })

-- Create new general note with template
vim.keymap.set("n", "<leader>Nn", function()
  vim.ui.input({ prompt = "Note name: " }, function(name)
    if name then
      local filepath = vim.fn.expand("~/mlp/docs/" .. name .. ".md")
      local template = vim.fn.readfile(vim.fn.expand("~/mlp/docs/templates/note.md"))

      local date = os.date("%Y-%m-%d")
      for i, line in ipairs(template) do
        template[i] = line:gsub("{{date}}", date):gsub("{{title}}", name)
      end

      vim.fn.writefile(template, filepath)
      vim.cmd("e " .. filepath)
    end
  end)
end, { desc = "New doc note" })

-- Create new notebook/analysis note with template
vim.keymap.set("n", "<leader>Nj", function()
  vim.ui.input({ prompt = "Notebook name: " }, function(name)
    if name then
      local filepath = vim.fn.expand("~/mlp/notebooks/" .. name .. ".md")
      local template = vim.fn.readfile(vim.fn.expand("~/mlp/docs/templates/notebook.md"))

      local date = os.date("%Y-%m-%d")
      for i, line in ipairs(template) do
        template[i] = line:gsub("{{date}}", date):gsub("{{title}}", name)
      end
      vim.fn.writefile(template, filepath)
      vim.cmd("e " .. filepath)
    end
  end)
end, { desc = "New notebook analysis" })

-- ===== AI / CLAUDE CODE (space + a) =====
-- Launch Claude Code in a right split
vim.keymap.set("n", "<leader>ac", function()
  vim.cmd("vsplit")
  vim.cmd("wincmd l")
  vim.cmd("terminal $HOME/.local/bin/claude")
  vim.cmd("startinsert")
end, { desc = "Launch Claude Code" })

vim.keymap.set("n", "<leader>aq", function()
  vim.cmd("vsplit")
  vim.cmd("wincmd l")
  vim.cmd("terminal $HOME/.local/bin/claude-qwen")
  vim.cmd("startinsert")
end, { desc = "Launch Claude Code (Qwen local)" })

-- Send context instructions to Claude terminal
vim.keymap.set("n", "<leader>ai", function()
  local text =
    [[Hello Claude! Its time to start working on the Mario RL Agent project. Please look through the following files:
- /home/blasley/mlp/CLAUDE.md
- /home/blasley/mlp/docs

These documents should tell you all of the progress I've made so far on the project, all the details of the overall project, and instructions for how to interact in the session. After you have finished reading the files please tell me summary of what you think was done most recently and what the next steps to start on are now. Thanks!]]

  -- Find the terminal buffer with Claude running
  local term_buf = nil
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].buftype == "terminal" then
      local buf_name = vim.api.nvim_buf_get_name(buf)
      if buf_name:match("claude") then
        term_buf = buf
        break
      end
    end
  end

  if term_buf and vim.b[term_buf].terminal_job_id then
    vim.api.nvim_chan_send(vim.b[term_buf].terminal_job_id, text .. "\n")
  else
    vim.notify("No Claude terminal found. Launch Claude Code first with <leader>ac", vim.log.levels.WARN)
  end
end, { desc = "Send instructions to Claude" })

-- Use neo-tree for <leader>e instead of snacks
vim.keymap.set("n", "<leader>e", function()
  require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() }) -- Changed here
end, { desc = "Explorer NeoTree (root dir)" })

vim.keymap.set("n", "<leader>E", function()
  require("neo-tree.command").execute({ toggle = true, dir = vim.fn.expand("%:p:h") })
end, { desc = "Explorer NeoTree (cwd)" })

-- ===== CODE ACTIONS & FIXES (space + c) =====
-- Quick fix at cursor (most common action)
vim.keymap.set("n", "<leader>cf", function()
  vim.lsp.buf.code_action({
    filter = function(action)
      return action.kind and action.kind:match("quickfix")
    end,
    apply = true,
  })
end, { desc = "Quick Fix" })

-- Fix all auto-fixable issues in file
vim.keymap.set("n", "<leader>cF", function()
  vim.lsp.buf.code_action({
    context = {
      only = { "source.fixAll" },
      diagnostics = {},
    },
    apply = true,
  })
end, { desc = "Fix All" })

-- Organize imports
vim.keymap.set("n", "<leader>co", function()
  vim.lsp.buf.code_action({
    context = {
      only = { "source.organizeImports" },
      diagnostics = {},
    },
    apply = true,
  })
end, { desc = "Organize Imports" })

-- Remove unused imports
vim.keymap.set("n", "<leader>cu", function()
  vim.lsp.buf.code_action({
    context = {
      only = { "source.removeUnused" },
      diagnostics = {},
    },
    apply = true,
  })
end, { desc = "Remove Unused" })

-- Format buffer (explicit)
vim.keymap.set("n", "<leader>cff", function()
  require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format Buffer" })
