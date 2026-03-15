
require('config.plug').init()

require('config.options')
require('config.keymaps')
require('config.autocmds')
require('config.commands')

require('config.lsp')
require('config.cmp')
require('config.oil')

-- エラーが出るので、treesitter を止める
vim.treesitter.stop()
