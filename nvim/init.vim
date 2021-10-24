" Nice reference https://gist.github.com/synasius/5cdc75c1c8171732c817  
"
call plug#begin('~/AppData/local/nvim/autoload')  

Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' } 
Plug 'joshdick/onedark.vim' 
Plug 'neovim/nvim-lspconfig' 

" autocompletion  
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/nvim-cmp'  
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'  

" better statusline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes' 



call plug#end()    


" Commands {{{ 

" Using powershell in neovim like :!commands => from :help shell-powershell" 
let &shell = has('win32') ? 'powershell' : 'pwsh'
let &shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;'
let &shellredir = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
let &shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
set shellquote= shellxquote=  

nnoremap <C-n> :NERDTreeToggle<CR>  
nnoremap <F8> :!java %    
nnoremap <F9> :!gcc % -o out; .\out  
nnoremap <C-l> :bnext<CR>  
nnoremap <C-h> :bprevious<CR>
" }}} Commands 


" Spaces & Tabs {{{
set tabstop=4
set shiftwidth=4  
set softtabstop=4
" }}} Spaces && Tabs


" UI config {{{ 
syntax enable
colorscheme onedark			 
set number						" Show line number.  
set cursorline					" Highlight current line. 
set showmatch					" Highlight matching brace.
set noswapfile					" 
filetype plugin indent on        
" }}} UI config 

" vim-airline {{{ 
let g:airline#extensions#tabline#enabled = 1					" Smarter tab line.
let g:airline#extensions#tabline#formatter = 'unique_tail'  
" Themes : https://github.com/vim-airline/vim-airline/wiki/Screenshots 
" }}} vim-airline 


"LSP   ------------------------------------------------------------
"https://github.com/neovim/nvim-lspconfig
lua << EOF
require'lspconfig'.clangd.setup{}  
require'lspconfig'.pylsp.setup{} 
require'lspconfig'.gopls.setup{}
require'lspconfig'.eslint.setup{} 
EOF

nnoremap <C-a> :autocmd BufWritePre <buffer> <cmd>EslintFixAll<CR>


" AUTOCOMPLETION --------------------------------------------------  
" https://github.com/hrsh7th/nvim-cmp/

set completeopt=menu,menuone,noselect

lua << EOF
  -- Setup nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
      end,
    },
	mapping = {
	  ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
	  ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
	  ['<Down>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
	  ['<Up>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
	  ['<C-d>'] = cmp.mapping.scroll_docs(-4),
	  ['<C-f>'] = cmp.mapping.scroll_docs(4),
	  ['<C-Space>'] = cmp.mapping.complete(),
	  ['<C-e>'] = cmp.mapping.close(),
	  ['<CR>'] = cmp.mapping.confirm({
		behavior = cmp.ConfirmBehavior.Replace,
		select = true
	  })
	},
    sources = {
      { name = 'nvim_lsp' },
      { name = 'vsnip' },
	  { name = 'buffer' }
    }
  })
	require('lspconfig').clangd.setup {
		capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
	}  

EOF
" gopls config {{{ 
lua <<EOF
  lspconfig = require "lspconfig"
  lspconfig.gopls.setup {
    cmd = {"gopls", "serve"},
    settings = {
      gopls = {
        analyses = {
          unusedparams = true,
        },
        staticcheck = true,
      },
    },
  }
EOF
" }}} gopls config  

" html config {{{
lua << EOF
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

require'lspconfig'.html.setup {
  capabilities = capabilities,
} 
EOF

" }}} html config 

