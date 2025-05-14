" check if plug is installed
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

if !empty($WAYLAND_DISPLAY)
    if !isdirectory(expand('~/.vim/pack/vim-wayland-clipboard'))
      silent! call mkdir(expand('~/vim/pack/vim-wayland-clipboard/start/'), 'p') 
      echo 'Installing vim-wayland-clipboard...'
      silent! execute '!git clone https://github.com/jasonccox/vim-wayland-clipboard.git ~/.vim/pack/vim-wayland-clipboard/start/vim-wayland-clipboard'
    endif
endif

" load plugins
call plug#begin(expand('~/.vim/plugged'))
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
call plug#end()

runtime ftplugin/man.vim

nnoremap <C-p> <Nop>
let mapleader = " "

colorscheme habamax

map <C-1> 1gt
map <C-2> 2gt
map <C-3> 3gt
map <C-4> 4gt

map <leader>c "+y
map <leader>v "+p

" Use ctrl-[hjkl] to select the active split!
nmap <silent> <c-k> :wincmd k<CR>
nmap <silent> <c-j> :wincmd j<CR>
nmap <silent> <c-h> :wincmd h<CR>
nmap <silent> <c-l> :wincmd l<CR>

nmap - :Explore<CR>

" Quickfix
nnoremap <leader>q :copen<CR>
tnoremap <leader><Esc> <C-\><C-n>

" turn hybrid line numbers on
:set number relativenumber
:set nu rnu
:set mouse=a
:set colorcolumn=88

:set expandtab
:set tabstop=4
:set shiftwidth=4
:set incsearch

:set backup
:set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp 
:set backupskip=/tmp/*,/private/tmp/*
:set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
:set writebackup

syntax on

map <leader>pr :GFiles<CR>
map <leader>pf :Files<CR>
map <leader>pt :Tags<CR>
map <leader>pg :RG<CR>
map <leader>pb :Buffers<CR>
map <leader>pc :Commits<CR>

