-- require('neo-tree').setup()
require('neo-tree').setup({
  window = {
    mappings = {
      ['<C-b>'] = 'close_window',
      ['h'] = 'close_node',
      ['l'] = 'open',
      ['z'] = 'none',
      ['p'] = {
        'toggle_preview',
        config = {
          use_float = true,
          use_snacks_image = true,
          use_image_nvim = true,
        },
      },
    },
  },
  filesystem = {
    follow_current_file = {
      -- 自動で追従
      enabled = true,
      -- 別のファイルに移った時、前のディレクトリを閉じるか
      leave_dirs_open = false,
    }
  }
})

vim.keymap.set('n', '<leader>e', ':Neotree toggle<CR>', { silent = true })
-- vim.keymap.set('n', '<leader>t', ':Neotree toggle<CR>', { silent = true }  -- t = tree
-- VSCode 風
vim.keymap.set('n', '<C-b>', ':Neotree toggle<CR>', { silent = true })

