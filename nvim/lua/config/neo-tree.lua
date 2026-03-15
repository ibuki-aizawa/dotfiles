-- require('neo-tree').setup()
require('neo-tree').setup({
  window = {
    mappings = {
      ['<C-b>'] = 'close_window',
      ['h'] = 'close_node',
      ['l'] = 'open',
      ['p'] = {
        'toggle_preview',
        config = {
          use_float = true,
          use_snacks_image = true,
          use_image_nvim = true,
        },
      },
    }
  }
})

-- vim.keymap.set('n', '<leader>e', ':Neotree toggle<CR>', { silent = true })
-- vim.keymap.set('n', '<leader>t', ':Neotree toggle<CR>', { silent = true }  -- t = tree
-- VSCode 風
vim.keymap.set('n', '<C-b>', ':Neotree toggle<CR>', { silent = true })

