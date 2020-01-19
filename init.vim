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

set shell=/bin/bash

" Disable arrow keys so hjkl are used instead
map <Up> ""
map <Down> ""
map <Left> ""
map <Right> ""

au BufRead,BufNewFile *.rs setfiletype rust

set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe  " Windows
set wildignore+=*/target/*,*.bk,*.orig  " Rust
set wildignore+=*/node_modules/*  " Node
set wildignore+=*/elm-stuff/*  " Elm

let g:rustfmt_autosave = 1
let g:rustfmt_options = '--edition 2018'

syntax on
if has("win32")
    " set guifont=consolas
else
    set guifont=Droid\ Sans\ Mono
endif

set directory+=,~/tmp,$TMP

autocmd FileType make setlocal noexpandtab
autocmd BufRead COMMIT_EDITMSG setlocal spell
autocmd BufNewFile,BufRead *.md,*.mkd,*.markdown set spell

fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun

autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

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
"Plug 'kien/ctrlp.vim'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-unimpaired'

Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
Plug 'cespare/vim-toml'
Plug 'rust-lang/rust.vim'
Plug 'neovimhaskell/haskell-vim'
Plug 'prabirshrestha/async.vim'
" Plug 'prabirshrestha/vim-lsp'
Plug 'gluon-lang/vim-gluon'
Plug 'mattn/emmet-vim'
Plug 'ekalinin/Dockerfile.vim'
"Plugin 'phildawes/racer'
"
if has("win32")
    Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'powershell -executionpolicy bypass -File install.ps1' }
else
    Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'bash install.sh' }
endif
" Plug 'vim-syntastic/syntastic'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/echodoc.vim'

set cmdheight=2
let g:echodoc#enable_at_startup = 1
let g:echodoc#type = 'signature'

Plug 'tomasr/molokai'

"Plug 'octref/RootIgnore'

Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'

if has('unix')
    Plug 'christoomey/vim-tmux-navigator'
    Plug 'edkolev/tmuxline.vim'
    Plug 'benmills/vimux'
    map <Leader>vl :VimuxRunLastCommand<CR>
    map <Leader>vr :VimuxRunCommand
    map <Leader>vs :VimuxInterruptRunner<CR>

    Plug 'dag/vim-fish'
endif

call plug#end()

let g:deoplete#enable_at_startup = 1

let g:NERDTreeRespectWildIgnore = 1

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
    \ 'rust': ['ra_lsp_server'],
    \ 'javascript': ['javascript-typescript-stdio'],
    \ 'typescript': ['javascript-typescript-stdio'],
    \ 'gluon': ['gluon_language-server'],
    \ }

" Automatically start language servers.
let g:LanguageClient_autoStart = 1
let g:LanguageClient_loggingFile = expand('~/.config/nvim/LanguageClient.log')

let g:LanguageClient_loggingFile = expand('~/.vim/LanguageClient.log')

nnoremap <F5> :call LanguageClient_contextMenu()<CR>

nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>

" Use ctrl-[hjkl] to select the active split!
nmap <silent> <c-k> :wincmd k<CR>
nmap <silent> <c-j> :wincmd j<CR>
nmap <silent> <c-h> :wincmd h<CR>
nmap <silent> <c-l> :wincmd l<CR>

imap jj <Esc>

function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

nmap <c-p> :GitFiles<CR>

" Use rg instead of grep
if executable('rg') && !has("win32")
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

