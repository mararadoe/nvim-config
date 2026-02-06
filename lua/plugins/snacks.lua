return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      -- File explorer (replaces neo-tree)
      explorer = { enabled = true },

      -- Fuzzy picker (replaces telescope)
      picker = {
        enabled = true,
        sources = {
          files = { hidden = true, ignored = false },
          grep = { hidden = true },
        },
      },

      -- Terminal (replaces toggleterm)
      terminal = { enabled = true },

      -- Notifications
      notifier = { enabled = true },

      -- Big file handling (disable LSP/treesitter on huge files)
      bigfile = { enabled = true },
    },
    keys = {
      -- Explorer
      { "<leader>n", function() Snacks.explorer() end, desc = "Toggle Explorer" },

      -- Picker: find files
      { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files (cwd)" },
      { "<leader>fF", function() Snacks.picker.files({ cwd = vim.env.HOME }) end, desc = "Find Files (Home ~)" },
      -- Picker: find files + directories
      { "<leader>fD", function()
        Snacks.picker.files({
          cmd = "fd",
          args = { "--type", "f", "--type", "d" },
          transform = function(item)
            if item.text:sub(-1) == "/" then
              item.icon = " "
              item.icon_hl = "Directory"
            end
            return item
          end,
        })
      end, desc = "Find Files+Dirs (cwd)" },

      -- Picker: grep
      { "<leader>fg", function() Snacks.picker.grep() end, desc = "Live Grep (cwd)" },
      { "<leader>fG", function() Snacks.picker.grep({ cwd = vim.env.HOME }) end, desc = "Live Grep (Home ~)" },

      -- Picker: buffers, help, recent, diagnostics
      { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<leader>fh", function() Snacks.picker.help() end, desc = "Help Tags" },
      { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent Files" },
      { "<leader>fd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
      { "<leader>/",  function() Snacks.picker.lines() end, desc = "Fuzzy search buffer" },

      -- Picker: LSP
      { "<leader>fs", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },

      -- Terminal (float: quick commands)
      { "<C-\\>", function() Snacks.terminal.toggle() end, desc = "Toggle Terminal (float)", mode = { "n", "t" } },
      -- Terminal (bottom split: for Claude / TUI apps)
      { "<leader>t", function()
        Snacks.terminal.toggle(nil, {
          win = { position = "bottom", height = 0.35 },
        })
      end, desc = "Toggle Terminal (bottom)", mode = { "n", "t" } },
    },
  },
}
