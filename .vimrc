" check if plug is installed
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

if !isdirectory(expand('~/.vim/pack/vim-wayland-clipboard'))
  silent! call mkdir(expand('~/vim/pack/vim-wayland-clipboard/start/'), 'p') 
  echo 'Installing vim-wayland-clipboard...'
  silent! execute '!git clone https://github.com/jasonccox/vim-wayland-clipboard.git ~/.vim/pack/vim-wayland-clipboard/start/vim-wayland-clipboard'
endif

" load plugins
call plug#begin(expand('~/.vim/plugged'))
Plug 'arcticicestudio/nord-vim'
Plug 'preservim/nerdtree'
Plug 'ledger/vim-ledger'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'maxboisvert/vim-simple-complete'
Plug 'LunarWatcher/auto-pairs'
Plug 'tpope/vim-fugitive'
Plug 'jpalardy/vim-slime'
Plug 'christoomey/vim-tmux-navigator'
call plug#end()

let g:slime_target = "tmux"

nnoremap <C-p> <Nop>
let mapleader = " "

colorscheme nord

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

" Nerd tree keymaps
nnoremap <leader>e :NERDTreeFocus<CR>
nnoremap <leader>b :NERDTreeToggle<CR>
nnoremap <leader>f :NERDTreeFind<CR>

nnoremap <leader>p :Files<CR>
nnoremap <leader>g :GFiles<CR>

" Quickfix
nnoremap <leader>q :copen<CR>

" turn hybrid line numbers on
:set number relativenumber
:set nu rnu

:set expandtab
:set tabstop=4
:set shiftwidth=4

syntax on

