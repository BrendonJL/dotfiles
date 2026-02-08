-- Claude AI completion via minuet-ai.nvim
return {
  {
    "milanglacier/minuet-ai.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "InsertEnter",
    config = function()
      require("minuet").setup({
        provider = "claude",
        context_window = 8000,
        request_timeout = 3,
        throttle = 500,
        notify = "warn",
        provider_options = {
          claude = {
            model = "claude-sonnet-4-5",
            max_tokens = 512,
            -- Use function to read and trim env var (removes newlines/whitespace)
            api_key = function()
              local key = vim.env.ANTHROPIC_API_KEY or ""
              return key:gsub("%s+", "") -- Strip all whitespace including newlines
            end,
          },
        },
      })
    end,
  },

  -- Add minuet to blink.cmp
  {
    "saghen/blink.cmp",
    optional = true,
    dependencies = { "milanglacier/minuet-ai.nvim" },
    opts = {
      sources = {
        default = { "minuet", "lsp", "path", "snippets", "buffer" },
        providers = {
          minuet = {
            name = "Claude",
            module = "minuet.blink",
            score_offset = 200,
            async = true,
            timeout_ms = 3000,
          },
        },
      },
      completion = {
        menu = {
          draw = {
            components = {
              kind_icon = {
                text = function(ctx)
                  -- Custom icon for Claude/minuet
                  if ctx.source_name == "Claude" then
                    return "󰛄 " -- Brain icon for AI
                  end
                  -- Fall back to default
                  local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
                  return kind_icon
                end,
              },
            },
          },
        },
      },
    },
  },
}
