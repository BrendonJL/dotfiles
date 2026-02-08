-- Mason: Ensure all LSP servers, linters, and formatters are installed
return {
  "mason-org/mason.nvim",
  opts = {
    ensure_installed = {
      -- LSP Servers (most handled by LazyVim extras, but explicit is good)
      "pyright",           -- Python
      "ruff-lsp",          -- Python linting LSP
      "lua-language-server", -- Lua
      "bash-language-server", -- Bash

      -- Python tools
      "ruff",              -- Fast Python linter + formatter
      "black",             -- Python formatter (backup)
      "mypy",              -- Python type checker
      "debugpy",           -- Python debugger

      -- JavaScript/TypeScript tools
      "prettier",          -- JS/TS/Web formatter
      "eslint_d",          -- Fast ESLint daemon
      "typescript-language-server",

      -- Shell tools
      "shellcheck",        -- Shell linter
      "shfmt",             -- Shell formatter

      -- Lua tools
      "stylua",            -- Lua formatter

      -- YAML/JSON tools
      "yamllint",          -- YAML linter
      "jsonlint",          -- JSON linter
      "yaml-language-server",
      "json-lsp",

      -- Docker tools
      "hadolint",          -- Dockerfile linter
      "dockerfile-language-server",
      "docker-compose-language-service",

      -- Go tools
      "gopls",             -- Go LSP
      "goimports",         -- Go imports organizer
      "golangci-lint",     -- Go linter

      -- Rust tools
      "rust-analyzer",     -- Rust LSP

      -- C/C++ tools
      "clangd",            -- C/C++ LSP
      "clang-format",      -- C/C++ formatter

      -- Web tools
      "html-lsp",
      "css-lsp",
      "tailwindcss-language-server",
      "htmlhint",
      "stylelint",

      -- SQL tools
      "sqlfluff",          -- SQL linter/formatter
      "sqls",              -- SQL LSP

      -- TOML tools
      "taplo",             -- TOML LSP + formatter

      -- Markdown tools
      "marksman",          -- Markdown LSP
      "markdownlint",      -- Markdown linter

      -- Terraform tools
      "terraform-ls",      -- Terraform LSP
      "tflint",            -- Terraform linter

      -- GitHub Actions
      "actionlint",        -- GitHub Actions linter

      -- General utilities
      "codespell",         -- Spell checker for code
    },
  },
}
