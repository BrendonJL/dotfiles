-- LazyVim language extras for comprehensive LSP, treesitter, and tooling support
-- These extras are now managed through lazyvim.json (see :LazyExtras)
-- Importing them here causes import order warnings
-- stylua: ignore
if true then return {} end

return {
  -- Python: pyright LSP, ruff linting, debugpy debugging
  { import = "lazyvim.plugins.extras.lang.python" },

  -- TypeScript/JavaScript: tsserver LSP, prettier, eslint
  { import = "lazyvim.plugins.extras.lang.typescript" },

  -- JSON: jsonls with schema support
  { import = "lazyvim.plugins.extras.lang.json" },

  -- YAML: yamlls with schema support (kubernetes, docker-compose, etc.)
  { import = "lazyvim.plugins.extras.lang.yaml" },

  -- Markdown: marksman LSP, preview support
  { import = "lazyvim.plugins.extras.lang.markdown" },

  -- Docker: dockerfile LSP, docker-compose support
  { import = "lazyvim.plugins.extras.lang.docker" },

  -- Go: gopls LSP, gofmt, delve debugging
  { import = "lazyvim.plugins.extras.lang.go" },

  -- Rust: rust-analyzer LSP, cargo integration
  { import = "lazyvim.plugins.extras.lang.rust" },

  -- C/C++: clangd LSP, cmake support
  { import = "lazyvim.plugins.extras.lang.clangd" },

  -- Terraform: terraform-ls LSP
  { import = "lazyvim.plugins.extras.lang.terraform" },

  -- Tailwind CSS: tailwindcss LSP for class completion
  { import = "lazyvim.plugins.extras.lang.tailwind" },

  -- Git integration extras
  { import = "lazyvim.plugins.extras.lang.git" },

  -- SQL: database tools
  { import = "lazyvim.plugins.extras.lang.sql" },

  -- TOML: taplo LSP
  { import = "lazyvim.plugins.extras.lang.toml" },

  -- Additional useful extras

  -- Copilot: AI completion (if you use it)
  -- { import = "lazyvim.plugins.extras.coding.copilot" },

  -- Mini.surround: surround text objects
  { import = "lazyvim.plugins.extras.coding.mini-surround" },

  -- Yanky: better yank/paste
  { import = "lazyvim.plugins.extras.coding.yanky" },
}
