return {
  "akinsho/toggleterm.nvim",
  config = function()
    require("toggleterm").setup({
      size = 20,
      open_mapping = [[<leader>fk]],
      direction = "float",
      float_opts = {
        border = "curved",
        winblend = 15,
        width = math.floor(vim.o.columns * 0.8),
        height = math.floor(vim.o.lines * 0.8),
      },
      on_open = function(term)
        vim.cmd("startinsert!")
        -- Make Esc exit terminal mode
        vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<Esc>", [[<C-\><C-n>]], { noremap = true, silent = true })
        -- Then q to close
        vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
      end,
      insert_mappings = true,
      terminal_mappings = true,
    })
  end,
}
