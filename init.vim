syntax on
filetype indent on
filetype plugin on
set omnifunc=syntaxcomplete#Complete
set backspace=2
set autoindent
set expandtab
set shiftwidth=4
set tabstop=4
set softtabstop=4
set number
set encoding=utf-8

" Disable arrow keys so hjkl are used instead
map <Up> ""
map <Down> ""
map <Left> ""
map <Right> ""

au BufRead,BufNewFile *.rs setfiletype rust

set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe  " Windows
set wildignore+=*/target/*,*.bk  " Rust

let g:rustfmt_autosave = 1
if filereadable(expand('~/.config/nvim/init.vim'))
    let g:rustfmt_command = 'rustup run nightly-2017-09-17 rustfmt'
else
    let g:rustfmt_command = 'rustup run nightly rustfmt'
endif

syntax on
if has("win32")
    set guifont=consolas
else
    set guifont=Droid\ Sans\ Mono
endif

set directory+=,~/tmp,$TMP

autocmd FileType make setlocal noexpandtab

set nocompatible               " be iMproved
filetype off                   " required!


if has("win32")
  call plug#begin('~/AppData/Local/nvim/plugged')
else
  call plug#begin('~/.config/nvim/plugged')
endif


" My Plugins here:
"
" original repos on github
Plug 'tpope/vim-fugitive'
Plug 'Lokaltog/vim-easymotion'
Plug 'rstacruz/sparkup', {'rtp': 'vim/'}
" non github repos
Plug 'git://git.wincent.com/command-t.git'
" git repos on your local machine (ie. when working on your own plugin)
" ...
Plug 'scrooloose/nerdtree'
Plug 'bling/vim-airline'
Plug 'kien/ctrlp.vim'

Plug 'cespare/vim-toml'
Plug 'rust-lang/rust.vim'
Plug 'dag/vim2hs'
Plug 'prabirshrestha/async.vim'
" Plug 'prabirshrestha/vim-lsp'
Plug 'gluon-lang/vim-gluon'
Plug 'rust-lang/rust.vim'
"Plugin 'phildawes/racer'
"
Plug 'autozimu/LanguageClient-neovim', { 'do': ':UpdateRemotePlugins' }
" Plug 'vim-syntastic/syntastic'
Plug 'w0rp/ale'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

Plug 'tomasr/molokai'

Plug 'christoomey/vim-tmux-navigator'
Plug 'edkolev/tmuxline.vim'

"Plug 'octref/RootIgnore'

Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'

call plug#end()

let g:deoplete#enable_at_startup = 1

" let g:NERDTreeRespectWildIgnore = 1

let g:vim_markdown_folding_disabled = 1

if has('unix')
    autocmd BufEnter * call system("tmux rename-window " . expand("%:t"))
    autocmd VimLeave * call system("tmux rename-window bash")
    autocmd BufEnter * let &titlestring = ' ' . expand("%:t")                                                                 
    set title
endif

colorscheme molokai
let g:molokai_original = 1

set hidden

filetype plugin indent on     " required!


if has('win32')
    function! ClipboardYank()
      call system('clip', @@)
    endfunction

    vnoremap <silent> y y:call ClipboardYank()<cr>
    vnoremap <silent> d d:call ClipboardYank()<cr>
endif

let g:LanguageClient_serverCommands = {
    \ 'rust': ['rustup', 'run', 'nightly', 'rls'],
    \ 'javascript': ['/opt/javascript-typescript-langserver/lib/language-server-stdio.js'],
    \ 'gluon': ['gluon_language-server.exe'],
    \ }

" Automatically start language servers.
let g:LanguageClient_autoStart = 1

nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>

" Use ctrl-[hjkl] to select the active split!
nmap <silent> <c-k> :wincmd k<CR>
nmap <silent> <c-j> :wincmd j<CR>
nmap <silent> <c-h> :wincmd h<CR>
nmap <silent> <c-l> :wincmd l<CR>

imap jj <Esc>

let g:ale_linters = {'rust': ['rls']}

" Use rg instead of grep
if executable('rg')
  " Use ag over grep
  set grepprg=rg\ --vimgrep

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  " let g:ctrlp_user_command = 'rg %s -l --color never -g ""'
  let g:ctrlp_user_command = ['.git', 'cd %s ; git ls-files . -co --exclude-standard', 'find %s -type f']

  " rg is fast enough that CtrlP doesn't need to cache
  " let g:ctrlp_use_caching = 0

  " bind \ (backward slash) to grep shortcut
  command -nargs=+ -complete=file -bar Rg silent! grep! <args>|cwindow|redraw!
  nnoremap \ :Rg<SPACE>
endif

