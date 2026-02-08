-- Comprehensive linting configuration for multiple languages
return {
  "mfussenegger/nvim-lint",
  opts = function(_, opts)
    opts.linters_by_ft = opts.linters_by_ft or {}

    -- Python: ruff is fast and comprehensive (replaces flake8, isort, pyupgrade, etc.)
    opts.linters_by_ft.python = { "ruff" }

    -- JavaScript/TypeScript: eslint handles most JS/TS linting
    opts.linters_by_ft.javascript = { "eslint_d" }
    opts.linters_by_ft.javascriptreact = { "eslint_d" }
    opts.linters_by_ft.typescript = { "eslint_d" }
    opts.linters_by_ft.typescriptreact = { "eslint_d" }

    -- Shell/Bash: shellcheck is the gold standard
    opts.linters_by_ft.sh = { "shellcheck" }
    opts.linters_by_ft.bash = { "shellcheck" }
    opts.linters_by_ft.zsh = { "shellcheck" }

    -- YAML: yamllint for config files
    opts.linters_by_ft.yaml = { "yamllint" }

    -- JSON: jsonlint for JSON validation
    opts.linters_by_ft.json = { "jsonlint" }

    -- Dockerfile: hadolint for Docker best practices
    opts.linters_by_ft.dockerfile = { "hadolint" }

    -- Go: golangci-lint is comprehensive
    opts.linters_by_ft.go = { "golangcilint" }

    -- Markdown: markdownlint for docs (re-enabled with sensible config)
    opts.linters_by_ft.markdown = { "markdownlint" }

    -- GitHub Actions: actionlint for workflow files
    opts.linters_by_ft["yaml.github"] = { "actionlint" }

    -- SQL: sqlfluff (already configured in conform, but add linting too)
    opts.linters_by_ft.sql = { "sqlfluff" }

    -- HTML: htmlhint
    opts.linters_by_ft.html = { "htmlhint" }

    -- CSS: stylelint
    opts.linters_by_ft.css = { "stylelint" }
    opts.linters_by_ft.scss = { "stylelint" }

    return opts
  end,
}
