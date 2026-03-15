local vim = vim;

-- LSP サーバーを起動設定
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'python',
  callback = function()
    -- local name = 'pyright'
    -- local cmd = { 'pyright-langserver', '--stdio' }
    local name = 'pylsp'
    local cmd = { 'pylsp' }

    vim.lsp.start({
      name = name,
      cmd = cmd,
      root_dir = vim.fs.dirname(
        vim.fs.find({
          'pyproject.toml',
          'setup.py',
          '.git'
        },
        { upward = true })[1]
      ),
    })
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
  callback = function()
    vim.lsp.start({
      name = 'ts_ls',
      cmd = { 'typescript-language-server', '--stdio' },
      root_dir = vim.fs.dirname(
        vim.fs.find({ 'tsconfig.json', 'package.json', '.git' }, { upward = true })[1]
      ),
    })
  end,
})

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function (args)
    local opts = { buffer = args.buf }

    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K',  vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>.', vim.lsp.buf.code_action, opts)

    -- フォーマット
    -- vim.keymap.set('n', '<leader>f', function ()
    --   vim.lsp.buf.format({ async = true })
    -- end, opts)
    -- vim.keymap.set('n', '=', function()
    --   vim.lsp.buf.format({ async = true })
    -- end, opts)

    vim.keymap.set('n', '=', function()
      vim.opt.operatorfunc = 'v:lua.lsp_format_operator'
      return 'g@'
    end, { buffer = args.buf, expr = true })

    _G.lsp_format_operator = function()
      vim.lsp.buf.format({
        async = true,
        range = {
          start = vim.api.nvim_buf_get_mark(0, '['),
          ['end'] = vim.api.nvim_buf_get_mark(0, ']'),
        }
      })
    end

    vim.keymap.set('v', '=', function()
      vim.lsp.buf.format({
        async = true,
        range = {
          start = vim.api.nvim_buf_get_mark(0, '<'),
          ['end'] = vim.api.nvim_buf_get_mark(0, '>'),
        }
      })
    end, opts)

    vim.notify('LspAttach fired! client: ' .. vim.lsp.get_client_by_id(args.data.client_id).name)
  end,
})

vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
})

vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
