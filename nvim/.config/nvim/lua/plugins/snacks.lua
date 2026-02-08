return {
  "folke/snacks.nvim",
  opts = function(_, opts)
    -- Disable dimming completely
    opts.dim = { enabled = false }

    -- Picker settings
    opts.picker = {
      sources = {
        files = {
          hidden = true,
          ignored = false,
        },
      },
    }

    -- Dashboard configuration
    opts.dashboard = opts.dashboard or {}
    opts.dashboard.wo = { winhl = "" }
    opts.dashboard.sections = {
      {
        section = "terminal",
        cmd = "echo '\n\n\n' && colorscript -e crunchbang-mini | sed 's/^/         /'",
        height = 12,
        padding = 1,
        wo = { winhl = "" },
      },
      { section = "keys", gap = 1, padding = 2 },
      {
        icon = " ",
        title = "Recent Files",
        section = "recent_files",
        indent = 2,
        padding = 4,
        limit = 15,
      },
      { icon = " ", key = "p", desc = "Projects", action = ":Telescope projects" },
      {
        pane = 2,
        section = "terminal",
        cmd = "/home/blasley/ricedup_skulls.sh",
        height = 13,
        width = 67,
        padding = 1,
        wo = { winhl = "" },
      },
      {
        pane = 2,
        icon = " ",
        desc = "Browse Repo",
        padding = 1,
        key = "b",
        action = function()
          Snacks.gitbrowse()
        end,
      },
      function()
        local in_git = Snacks.git.get_root() ~= nil
        local cmds = {
          {
            title = "Notifications",
            cmd = "gh api notifications 2>/dev/null | jq -r '.[] | \"\\(.repository.full_name): \\(.subject.title)\"' | head -5 || echo 'No notifications'",
            action = function()
              vim.ui.open("https://github.com/notifications")
            end,
            key = "N",
            icon = " ",
            height = 7,
          },
          {
            title = "Open Issues",
            cmd = "gh issue list -L 5 2>/dev/null || echo 'No issues'",
            key = "i",
            action = function()
              vim.fn.jobstart("gh issue list --web", { detach = true })
            end,
            icon = " ",
            height = 8,
          },
          {
            icon = " ",
            title = "Open PRs",
            cmd = "gh pr list -L 5 2>/dev/null || echo 'No pull requests'",
            key = "P",
            action = function()
              vim.fn.jobstart("gh pr list --web", { detach = true })
            end,
            height = 8,
          },
          {
            icon = " ",
            title = "Git Status",
            cmd = "git status --short --branch --renames",
            height = 10,
          },
          {
            icon = " ",
            title = "Git Diff",
            cmd = "git --no-pager diff --stat -B -M -C",
            height = 12,
          },
        }
        return vim.tbl_map(function(cmd)
          return vim.tbl_extend("force", {
            pane = 2,
            section = "terminal",
            enabled = in_git,
            padding = 1,
            ttl = 5 * 60,
            indent = 3,
            wo = { winhl = "" },
          }, cmd)
        end, cmds)
      end,
      { section = "startup" },
    }

    opts.dashboard.preset = opts.dashboard.preset or {}
    opts.dashboard.preset.header = ""
    opts.dashboard.preset.keys = {
      { icon = "📄", key = "n", desc = "New File", action = ":ene | startinsert" },
      { icon = "🔍", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
      { icon = "🔎", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
      { icon = "🕒", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
      {
        icon = "⚙️",
        key = "c",
        desc = "Config",
        action = ":lua Snacks.dashboard.pick('files', { cwd = vim.fn.stdpath('config') })",
      },
      { icon = "💾", key = "s", desc = "Restore Session", action = ":lua require('persistence').load()" },
      { icon = "🎨", key = "x", desc = "Lazy Extras", action = ":LazyExtras" },
      { icon = "📦", key = "l", desc = "Lazy", action = ":Lazy" },
      { icon = "👋", key = "q", desc = "Quit", action = ":qa" },
    }

    return opts
  end,
}
