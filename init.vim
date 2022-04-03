syntax on
filetype indent on
filetype plugin on
" set omnifunc=syntaxcomplete#Complete
set backspace=2
set smartindent
set expandtab
set shiftwidth=4
set tabstop=4
set softtabstop=4
set number
set encoding=utf-8
set directory=~/.config/nvim/undodir//

" Stops gitcommit from auto wrapping
au Filetype gitcommit call SetGitCommit()
func SetGitCommit()
    setlocal formatoptions-=tl
endfunc

autocmd FileType go setlocal expandtab&

if has('unix')
  set shell=/bin/bash
endif

" Disable arrow keys so hjkl are used instead
map <Up> ""
map <Down> ""
map <Left> ""
map <Right> ""

au BufRead,BufNewFile *.rs setfiletype rust

set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe  " Windows
set wildignore+=*/target/*,*.bk,*.orig  " Rust set wildignore+=*/node_modules/*  " Node
set wildignore+=*/elm-stuff/*  " Elm

let g:rustfmt_autosave = 1

syntax on
if has("win32")
    " set guifont=consolas
else
    set guifont=Droid\ Sans\ Mono
endif

set directory+=,~/tmp,$TMP

autocmd FileType make setlocal noexpandtab
autocmd BufRead COMMIT_EDITMSG setlocal spell
autocmd BufNewFile,BufRead *.md,*.mkd,*.markdown,*rs set spell

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
" Plug 'cespare/vim-toml'
Plug 'rust-lang/rust.vim'
Plug 'hashivim/vim-terraform'
Plug 'neovimhaskell/haskell-vim'
Plug 'prabirshrestha/async.vim'
" Plug 'prabirshrestha/vim-lsp'
Plug 'gluon-lang/vim-gluon'
Plug 'mattn/emmet-vim'
Plug 'ekalinin/Dockerfile.vim'
"Plugin 'phildawes/racer'
"
" Plug 'vim-syntastic/syntastic'
" Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/echodoc.vim'

set cmdheight=2
let g:echodoc#enable_at_startup = 1
let g:echodoc#type = 'signature'

Plug 'tomasr/molokai'

"Plug 'octref/RootIgnore'

Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'


Plug 'Shougo/echodoc.vim'
set cmdheight=2
let g:echodoc#enable_at_startup = 1
let g:echodoc#type = 'signature'
set signcolumn=yes

Plug 'neovim/nvim-lspconfig'

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

autocmd BufWritePre *.go lua vim.lsp.buf.formatting_sync()

" Use ctrl-[hjkl] to select the active split!
nmap <silent> <c-k> :wincmd k<CR>
nmap <silent> <c-j> :wincmd j<CR>
nmap <silent> <c-h> :wincmd h<CR>
nmap <silent> <c-l> :wincmd l<CR>

imap jj <Esc>

function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s; true'
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
  " command -nargs=+ -complete=file -bar Rg silent! grep! <args>|cwindow|redraw!
  " nnoremap \ :Rg<SPACE>
endif

lua << EOF
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

local use = require('packer').use
require('packer').startup(function()
  use 'neovim/nvim-lspconfig' -- Collection of configurations for built-in LSP client
  use 'hrsh7th/nvim-cmp' -- Autocompletion plugin
  use 'hrsh7th/cmp-nvim-lsp' -- LSP source for nvim-cmp
  use 'saadparwaiz1/cmp_luasnip' -- Snippets source for nvim-cmp
  use 'L3MON4D3/LuaSnip' -- Snippets plugin

  if packer_bootstrap then
    require('packer').sync()
  end
end)

-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

local lspconfig = require('lspconfig')

-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
local servers = { 'clangd', 'rust_analyzer', 'pyright', 'tsserver' }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    -- on_attach = my_custom_on_attach,
    capabilities = capabilities,
  }
end

-- luasnip setup
local luasnip = require 'luasnip'

-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end,
    ['<S-Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end,
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}


local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  -- buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = {
    gopls = {},
    rust_analyzer = {
        cmd = {'rustup', 'run', 'nightly', 'rust-analyzer'}
    },
    ['flux-lsp'] = {
        single_file_support = true
    }
}
for lsp, config in pairs(servers) do
    config.on_attach = on_attach
    config.flags = {
        debounce_text_changes = 150
    }
    nvim_lsp[lsp].setup(config)
end
-- vim.lsp.set_log_level('debug')
EOF
