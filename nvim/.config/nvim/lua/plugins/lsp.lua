-- LSP configuration
return {
  -- Disable inline diagnostics, show on hover instead
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Pyright: Configure to use project venv automatically
        pyright = {
          settings = {
            python = {
              analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace",
                typeCheckingMode = "basic",
              },
            },
          },
        },
        -- Ruff LSP: Fast Python linting with code actions
        ruff_lsp = {
          keys = {
            {
              "<leader>co",
              function()
                vim.lsp.buf.code_action({
                  apply = true,
                  context = {
                    only = { "source.organizeImports" },
                    diagnostics = {},
                  },
                })
              end,
              desc = "Organize Imports (Ruff)",
            },
          },
        },
      },
      diagnostics = {
        virtual_text = false, -- Disable inline diagnostics
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        -- Enable signs with fun emoji! 🎉
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "❌",
            [vim.diagnostic.severity.WARN] = "⚠️",
            [vim.diagnostic.severity.HINT] = "💡",
            [vim.diagnostic.severity.INFO] = "ℹ️",
          },
        },
        float = {
          focusable = true,
          style = "minimal",
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
      },
    },
    init = function()
      -- Ensure sign column is always visible for diagnostics
      vim.opt.signcolumn = "yes"

      -- Define diagnostic sign HIGHLIGHTS with explicit colors (purple theme)
      vim.api.nvim_set_hl(0, "DiagnosticSignError", { fg = "#f38ba8", bg = "NONE" })
      vim.api.nvim_set_hl(0, "DiagnosticSignWarn", { fg = "#f9e2af", bg = "NONE" })
      vim.api.nvim_set_hl(0, "DiagnosticSignHint", { fg = "#a6e3a1", bg = "NONE" })
      vim.api.nvim_set_hl(0, "DiagnosticSignInfo", { fg = "#89b4fa", bg = "NONE" })

      -- Define signs using vim.fn.sign_define (works across all Neovim versions)
      -- Using emoji for colorful, whimsical diagnostics! 🎨
      local signs = {
        { name = "DiagnosticSignError", text = "❌" },  -- Red X
        { name = "DiagnosticSignWarn", text = "⚠️" },   -- Warning sign
        { name = "DiagnosticSignHint", text = "💡" },   -- Lightbulb
        { name = "DiagnosticSignInfo", text = "ℹ️" },   -- Info
      }
      for _, sign in ipairs(signs) do
        vim.fn.sign_define(sign.name, {
          text = sign.text,
          texthl = sign.name,
          numhl = "",
        })
      end

      -- Configure diagnostics after everything loads
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          vim.diagnostic.config({
            virtual_text = false,
            signs = {
              text = {
                [vim.diagnostic.severity.ERROR] = "❌",
                [vim.diagnostic.severity.WARN] = "⚠️",
                [vim.diagnostic.severity.HINT] = "💡",
                [vim.diagnostic.severity.INFO] = "ℹ️",
              },
            },
            underline = true,
            update_in_insert = false,
            severity_sort = true,
          })
        end,
      })

      -- Show diagnostics on hover (CursorHold)
      vim.api.nvim_create_autocmd("CursorHold", {
        callback = function()
          local opts = {
            focusable = false,
            close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
            border = "rounded",
            source = "always",
            prefix = " ",
            scope = "cursor",
          }
          vim.diagnostic.open_float(nil, opts)
        end,
      })
    end,
  },

  -- Configure hover delay for diagnostics
  {
    "LazyVim/LazyVim",
    opts = function()
      vim.opt.updatetime = 300 -- Faster CursorHold trigger (default 4000ms)
    end,
  },
}
