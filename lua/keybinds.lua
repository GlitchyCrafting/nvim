return {
      mode = { "n", "v" },
      { "<Leader>M", "<cmd>lua require('peek').open()<cr>", desc = "Markdown" },
      { "<Leader>a", "<cmd>lua require('fzf-lua').lsp_code_actions()<cr>", desc = "Actions" },
      { "<Leader>b", "<cmd>lua require('fzf-lua').buffers()<cr>", desc = "Buffers" },
      { "<Leader>c", "<cmd>CccPick<cr>", desc = "Color" },
      { "<Leader>d", "<cmd>Trouble diagnostics<cr>", desc = "Diagnostics" },
      { "<Leader>f", group = "Files" },
      { "<Leader>fb", "<cmd>lua require('oil').toggle_float()<cr>", desc = "Browser" },
      { "<Leader>ff", "<cmd>lua require('fzf-lua').files()<cr>", desc = "Find" },
      { "<Leader>h", "<cmd>lua require('fzf-lua').help_tags()<cr>", desc = "Help" },
      { "<Leader>m", "<cmd>lua require('fzf-lua').manpages()<cr>", desc = "Man Pages" },
      { "<Leader>s", "<cmd>lua require('fzf-lua').live_grep_native()<cr>", desc = "Search" },
  }
