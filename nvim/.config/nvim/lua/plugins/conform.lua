-- Comprehensive formatting configuration for multiple languages
return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      -- Python: ruff for linting fixes + black for formatting
      -- ruff_fix applies safe autofixes, ruff_format handles formatting
      python = { "ruff_fix", "ruff_format" },

      -- JavaScript/TypeScript: prettier is the standard
      javascript = { "prettier" },
      javascriptreact = { "prettier" },
      typescript = { "prettier" },
      typescriptreact = { "prettier" },
      vue = { "prettier" },
      svelte = { "prettier" },

      -- Web languages: prettier handles most
      html = { "prettier" },
      css = { "prettier" },
      scss = { "prettier" },
      less = { "prettier" },

      -- Data formats: prettier for JSON/YAML/GraphQL
      json = { "prettier" },
      jsonc = { "prettier" },
      yaml = { "prettier" },
      graphql = { "prettier" },

      -- Markdown: prettier for consistent docs
      markdown = { "prettier" },
      ["markdown.mdx"] = { "prettier" },

      -- Lua: stylua (Neovim config files)
      lua = { "stylua" },

      -- Shell: shfmt for bash/sh scripts
      sh = { "shfmt" },
      bash = { "shfmt" },
      zsh = { "shfmt" },

      -- Go: gofmt + goimports
      go = { "goimports", "gofmt" },

      -- Rust: rustfmt
      rust = { "rustfmt" },

      -- C/C++: clang-format
      c = { "clang-format" },
      cpp = { "clang-format" },
      objc = { "clang-format" },

      -- SQL: sqlfluff (already had this)
      sql = { "sqlfluff" },

      -- TOML: taplo
      toml = { "taplo" },

      -- XML: xmlformat
      xml = { "xmlformat" },

      -- Terraform/HCL: terraform fmt
      terraform = { "terraform_fmt" },
      tf = { "terraform_fmt" },
      hcl = { "terraform_fmt" },

      -- Docker: (no standard formatter, but hadolint catches issues)

      -- Nix: nixpkgs-fmt
      nix = { "nixpkgs_fmt" },

      -- Zig: zig fmt
      zig = { "zigfmt" },

      -- Fallback: use LSP formatting if available
      ["_"] = { "trim_whitespace" },
    },
  },
}
