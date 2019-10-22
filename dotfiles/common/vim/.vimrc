"
" Originally pillaged from janus and spf13, and evolved from there.
"

" ------------------------------------------------------------------------------
" General
" ------------------------------------------------------------------------------
set nocompatible                " Use vim, no vi defaults
let mapleader="\<Space>"
set number                      " Show line numbers
set ruler                       " Show line and column number in stats line
set history=10000               " Store a ton of history
syntax enable                   " Enable syntax highlighting
set encoding=utf-8
set t_ti= t_te=                 " Don't switch to the terminal when running cli commands
set ttimeoutlen=0               " Shorten key sequence timeouts (eliminates delays after hitting ESC)
set mouse=a                     " Enable mouse support in all modes for pane resizing
set hidden                      " Allow hidden buffers


" ------------------------------------------------------------------------------
" Formatting
" ------------------------------------------------------------------------------
set nowrap                      " Don't wrap lines
set tabstop=4                   " A tab is X spaces
set shiftwidth=4                " An autoindent (with <<) is X spaces
set expandtab                   " Use spaces, not tabs
set list                        " Show invisible characters
set backspace=indent,eol,start  " Backspace through everything in insert mode

" List chars
set listchars=""                " Reset the listchars
set listchars=tab:\ \           " A tab should display as "  "
set listchars+=trail:.          " Show trailing spaces as periods
set listchars+=extends:>        " The character to show in the last column when wrap is off and the line continues beyond the right of the screen
set listchars+=precedes:<       " The character to show in the last column when wrap is off and the line continues beyond the left of the screen


" ------------------------------------------------------------------------------
" Searching
" ------------------------------------------------------------------------------
set hlsearch    " Highlight matches
set incsearch   " Incremental searching
set ignorecase  " Searches are case insensitive...
set smartcase   " ...unless they contain at least one capital letter


" ------------------------------------------------------------------------------
" UI
" ------------------------------------------------------------------------------
set termguicolors
set background=dark

if has("statusline")
    set laststatus=2  " Always show the status bar
endif

" ------------------------------------------------------------------------------
" Backup and swap files
" ------------------------------------------------------------------------------
set backupdir=~/.vim/_backup//
set directory=~/.vim/_temp//


" ------------------------------------------------------------------------------
" General Mappings
" ------------------------------------------------------------------------------
" Create the directory containing the file in the buffer
nmap <silent> <leader>md :!mkdir -p %:p:h<CR>

" Set text wrapping toggles
nmap <silent> <leader>tw :set invwrap<CR>:set wrap?<CR>


" ------------------------------------------------------------------------------
" Functions
" ------------------------------------------------------------------------------
function! ShortenPath(path)
    if empty(a:path) | return | endif

    let num_ignore_segments = 2
    let separator = "/"
    let segments = split(a:path, separator)

    let shortened_path = a:path
    if len(segments) > 1
        let shortened_segments = map(segments[0:-(num_ignore_segments + 1)], "v:val[0]")
        let ignored_segments = segments[-num_ignore_segments:-1]

        let prefix = a:path[0] == separator ? a:path[0] : ""
        let shortened_path = prefix . join(shortened_segments + ignored_segments, separator)
    endif

    return shortened_path
endfunction


" ------------------------------------------------------------------------------
" Plugins
" ------------------------------------------------------------------------------
call plug#begin("~/.vim/plugged")

Plug 'scrooloose/nerdtree'
Plug 'ddollar/nerdcommenter'
Plug 'tpope/vim-fugitive'
Plug 'mileszs/ack.vim'
Plug 'itchyny/lightline.vim'
Plug 'icymind/NeoSolarized'
Plug 'robertmeta/nofrils'
Plug 'vimwiki/vimwiki'
Plug 'airblade/vim-gitgutter'
Plug 'editorconfig/editorconfig-vim'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'

if has("nvim")
    Plug 'neoclide/coc.nvim', { 'do': { -> coc#util#install() }}
    Plug 'neoclide/coc-tsserver', { 'do': 'yarn install --frozen-lockfile' }
    Plug 'neoclide/coc-tslint-plugin', { 'do': 'yarn install --frozen-lockfile' }
endif

Plug 'HerringtonDarkholme/yats.vim'
Plug 'jcf/vim-latex'
Plug 'chooh/brightscript.vim'
Plug 'LnL7/vim-nix'
Plug 'neovimhaskell/haskell-vim'

call plug#end()


" ------------------------------------------------------------------------------
" Plugins Configuration
" ------------------------------------------------------------------------------

"
" NerdTree
"
autocmd vimenter * if !argc() | NERDTree | endif
map <leader>n :NERDTreeToggle<CR>

let NERDTreeShowBookmarks=1
let NERDTreeIgnore=["\.pyc", "\~$", "\.o$", "\.swo$", "\.swp$", "\.git","\.hg", "\.svn", "\.bzr"]
let NERDTreeChDirMode=0
let NERDTreeQuitOnOpen=0
let NERDTreeMouseMode=2
let NERDTreeShowHidden=0

"
" NerdCommenter
"
map <leader><leader> <plug>NERDCommenterToggle<CR>

"
" ack
"
let g:ackprg = "rg --vimgrep --hidden"

"
" lightline
"
set noshowmode
let g:lightline = {}
let g:lightline.colorscheme = "solarized"
let g:lightline.active = {
    \   "left": [["mode", "paste"],
    \            ["readonly", "filename"],
    \            ["gitbranch"]],
    \   "right": [["lineinfo", "cocstatus"],
    \             ["percent"],
    \             ["filetype"]]
    \ }
let g:lightline.tabline = {
    \ "left": [["tabs"]],
    \ "right": [[]],
    \ }
let g:lightline.component_function = {
    \   "cocstatus": "coc#status",
    \   "filename": "LightlineFilename",
    \   "gitbranch": "LightlineGitbranch"
    \ }

function! LightlineFilename()
    let filename = expand("%:f") !=# "" ? ShortenPath(expand("%:P")) : "[No Name]"
    let modified = &modified ? " [+]" : ""
    return filename . modified
endfunction

function! LightlineGitbranch()
    return winwidth(0) >= 80 ? fugitive#head() : ""
endfunction

"
" NeoSolarized
"
let g:neosolarized_vertSplitBgTrans = 0
let g:neosolarized_contrast = "high"

"
" fzf
"
nmap <C-p> :Files<CR>

"
" vimwiki
"
let g:vimwiki_list = [{ "path": "~/wiki/", "syntax": "markdown", "ext": ".md" }]

"
" vim-latex
"
let g:tex_flavor="latex"

"
" coc.nvim
"

" Use tab to navigate completion lists.
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Use enter to confirm completion.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

nmap <leader>rr <Plug>(coc-rename)

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

vmap <leader>f <Plug>(coc-format-selected)
nmap <leader>f <Plug>(coc-format-selected)

nmap <leader>ac <Plug>(coc-codeaction)
nmap <leader>qf <Plug>(coc-fix-current)

" Perform code action for a selected region.
vmap <leader>a <Plug>(coc-codeaction-selected)
nmap <leader>a <Plug>(coc-codeaction-selected)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>CocShowDocumentation()<CR>

" Use `[c` and `]c` to navigate diagnostics.
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

augroup CocGroup
  autocmd!
  " Setup formatexpr specified filetypes.
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')

  " Update signature help on jump to placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" CocList

" Show all diagnostics.
nnoremap <silent> <space>a :<C-u>CocList diagnostics<cr>

" Show commands.
nnoremap <silent> <space>c :<C-u>CocList commands<cr>

" Show document outline.
nnoremap <silent> <space>o :<C-u>CocList outline<cr>

" Do default action for next item.
nnoremap <silent> <space>j :<C-u>CocNext<CR>

" Do default action for previous item.
nnoremap <silent> <space>k :<C-u>CocPrev<CR>

" Resume latest CocList.
nnoremap <silent> <space>p :<C-u>CocListResume<CR>

function! s:CocShowDocumentation()
  if &filetype == "vim"
    execute "h ".expand("<cword>")
  else
    call CocAction("doHover")
  endif
endfunction


" ------------------------------------------------------------------------------
" Post-bundle Loading Configuration
" ------------------------------------------------------------------------------
filetype plugin indent on  " automatically detect file types
colorscheme NeoSolarized
