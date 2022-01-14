call plug#begin('~/.vim/plugged') 
    " Theme 
    Plug 'joshdick/onedark.vim'  
    Plug 'dracula/vim'   

    Plug 'ryanoasis/vim-devicons'
    Plug 'scrooloose/nerdtree'
    Plug 'preservim/nerdcommenter' 
    Plug 'mhinz/vim-startify' 

    " Better status line theme 
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes' 

    " LSP 
    Plug 'neovim/nvim-lspconfig'

    " Telescope
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim'   

    " Markdown
    Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
call plug#end()

" Require plugins 
lua require('myplugin')

" UI Cofig{{
set showmatch 			    " Show matching
set ignorecase 			    " Case insensitive
set mouse=v			        " Middle-click paste with
set hlsearch			    " Highlight search
set tabstop=4			    " Number of columns occupied by a tab
set softtabstop=4		    " See multiple spaces as a tabstop so <BS> does the right thing
set shiftwidth=4
set expandtab 			    " Converts tab to white space
set autoindent			    " Indent a new line the same amoutn as the line just typed
set wildmode=longest,list	" Get bash-like tab completions
set cc=80			        " Set an 80 column border for good coding style
set mouse=a			        " Enable mouse clicking
set clipboard=unnamedplus	" Using system clipboard
set cursorline
set noswapfile			    " Disable swapfile 
set number                  " Show line number 
" }} UI config; 

" Color schemes {{ 
colorscheme onedark 
syntax enable 
"}} Color schemes; 


"Keybinds {{ 
nnoremap <A-f> :Telescope find_files<CR>
nnoremap <C-n> :NERDTreeToggle<CR>
" }} Keybinds; 

" vim-airline {{
let g:airline#extensions#tabline#enabled = 1					" Smarter tab line.
let g:airline#extensions#tabline#formatter = 'unique_tail'  
" Themes : https://github.com/vim-airline/vim-airline/wiki/Screenshots 
" }} 

" nnoremap => normal mode
" vnoremap => visual mode 
" inorepmap => insert mode  
