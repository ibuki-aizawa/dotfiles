
require('config.plug').init()

require('config.options')
require('config.keymaps')
require('config.autocmds')
require('config.commands')

require('config.lsp')
require('config.cmp')
require('config.oil')
require('config.neo-tree')

require('config.telescope')
require('config.conform')

-- エラーが出るので、treesitter を止める
vim.treesitter.stop()
