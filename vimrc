" -*- vim: set sts=2 sw=2 et fdm=marker: -------------  vim modeline -*-

" Basic Settings -------------------------------------- {{{1
syntax on
set termguicolors
let mapleader = ' '
let maplocalleader = ','

set sw=2 sts=2 et nu sr
set diffopt=filler,context:3
set display=lastline
set hidden
set hlsearch
if has('nvim')
  set inccommand=nosplit
endif
set incsearch
set nrformats+=alpha
set ruler
set showcmd
set isfname-==
set shortmess+=s
set nostartofline
set synmaxcol=1000
"set tags=./tags,tags,./../tags,./../../tags,./../../../tags
set title
set whichwrap=b,s,[,]
set wildcharm=<tab>
set wildmenu
set wildmode=list:longest,list:full
set wildignore=*.o,*.bak,*.byte,*.native,*~,*.sw?,*.aux,*.toc,*.hg,*.git,*.svn,*.hi,*.so,*.a,*.pyc,*.aux,*.toc,*.exe
"set autochdir
set winaltkeys=no
set scrolloff=3 scrolljump=5
set showbreak=↪
set breakindent
set sidescroll=10 sidescrolloff=10
set switchbuf=useopen
"set ignorecase smartcase
set timeoutlen=600
set ttimeoutlen=0
set matchpairs+=<:>
set laststatus=2
set cursorline

set backup
set backupdir=~/.vimtmp/backup//
set directory=~/.vimtmp/swap//
set noswapfile
if has('persistent_undo')
  set undofile
  set undodir=~/.vimtmp/undo
end

set fileencodings=ucs-bom,utf8,cp936,gbk,big5,euc-jp,euc-kr,gb18130,latin1
set formatoptions+=nj " support formatting of numbered lists

" tabs and spaces
set listchars+=tab:▸\ ,trail:⋅,nbsp:␣
" eols and others
set listchars+=eol:¬,extends:»,precedes:«

" highlight columns after 'textwidth'
set colorcolumn=+1,+2,+4,+5,+6,+7,+8

if has('mouse')
  set mouse=a
endif

if has("gui_running")
  set guiheadroom=20
  " Ctrl-F12 Toggle Menubar and Toolbar
  nnoremap <silent> <C-F12> :
    \ if &guioptions =~# 'T' <Bar>
      \ set guioptions-=T <Bar>
      \ set guioptions-=m <Bar>
    \ else <Bar>
      \ set guioptions+=T <Bar>
      \ set guioptions+=m <Bar>
    \ endif<CR>

  set guioptions-=T
  set guioptions-=m
  " no scroll bars
  set guioptions-=r
  set guioptions-=L
endif

" Status Line ----------------------------------------- {{{1
set laststatus=2

set statusline=%#ColorColumn#%2f              " buffer number
set statusline+=%*»                           " separator
set statusline+=%<                            " truncate here
set statusline+=%*»                           " separator
set statusline+=%*»                           " separator
set statusline+=%#DiffText#%m                 " modified flag
set statusline+=%r                            " readonly flag
set statusline+=%*»                           " separator
set statusline+=%#CursorLine#(%l/%L,%c)%*»    " line no./no. of lines,col no.
set statusline+=%=«                           " right align the rest
set statusline+=%#Cursor#%02B                 " value of current char in hex
set statusline+=%*«                           " separator
set statusline+=%#ErrorMsg#%o                 " byte offset
set statusline+=%*«                           " separator
set statusline+=%#Title#%y                    " filetype
set statusline+=%*«                           " separator
set statusline+=%#ModeMsg#%3p%%               " % through file in lines
set statusline+=%*                            " restore normal highlight
" Fonts ----------------------------------------------- {{{1
if has("gui_running")
  " Envy Code R
  " http://damieng.com/blog/2008/05/26/envy-code-r-preview-7-coding-font-released
  " set guifont=Monaco\ 15
  " set guifont=Inconsolata\ 15
  " set guifont=Monofur\ 16
  set guifont=Fantasque\ Sans\ Mono\ 18
  set guifontwide=Source\ Han\ Sans\ 15
endif
if has('nvim')
  " Neovim-qt Guifont command
  "command -nargs=? Guifont call rpcnotify(0, 'Gui', 'SetFont', "<args>") | let g:Guifont="<args>"
  "Guifont Fantasque Sans Mono:h18
endif


" Functions --------------------- {{{1
" DiffOrig {{{2
" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vnew | setlocal bt=nofile bh=wipe nobl noswf | r ++edit # | 0d_ | diffthis
  \ | wincmd p | diffthis
endif

" ErrorsToggle & QFixToggle {{{2
function! ErrorsToggle()
  if exists("g:is_error_window")
    lclose
    unlet g:is_error_window
  else
    botright lwindow 5
    let g:is_error_window = 1
  endif
endfunction

"command! -bang -nargs=? QFixToggle call QFixToggle(<bang>0)
function! QFixToggle()
  if exists("g:qfix_win")
    cclose
    unlet g:qfix_win
  else
    botright copen 5
    let g:qfix_win = 1
  endif
endfunction

" StripTrailingWhitespace {{{2
function! StripTrailingWhitespace()
  " To disable this function, either set ft as keewhitespace prior saving
  " or define a buffer local variable named keepWhitespace
  if &ft =~ 'whitespace\|keep_whitespace' || exists('b:keep_whitespace')
    return
  endif
  let l:savedview = winsaveview()
  silent! %s/\s*$//e
  call winrestview(l:savedview)
endfunction

" MatchUnwantedWhitespaces {{{2
fu! MatchUnwantedWhitespaces()
  " Show all trailing whitespaces: /\s\+$/
  " and spaces followed by tabs:   / \+\t\+\s*/
  " and tabs followed by spaces:   /\t\+ \+\s*/
  " combine them together: /\s\+$\| \+\t\+\s*\|\t\+ \+\s*/
  if bufname('%') != '' && bufname('%') != 'vimfiler:explorer'
    if exists('b:showextrawhitespace') && b:showextrawhitespace == 0
      hi clear ExtraWhitespace
      match none ExtraWhitespace
    else
      hi ExtraWhitespace ctermbg=red guibg=red
      match ExtraWhitespace /\s\+$\| \+\t\+\s*\|\t\+ \+\s*/
    endif
  en
endf
fu! ToggleUnwantedWhitespaces()
  if exists('b:showextrawhitespace') && b:showextrawhitespace == 0
    let b:showextrawhitespace = 1
  else
    let b:showextrawhitespace = 0
  endif
  call MatchUnwantedWhitespaces()
endf
fu! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endf
" Autocommands ---------------------------------------- {{{1
if has("autocmd")
  aug Fortran_support
    au!
    au FileType fortran :call Fortran_init()
  aug MarkDown_support
    au!
    au FileType markdown :call MarkDown_init()
  aug OCaml_support
    au!
    au FileType ocaml :call OCaml_init()
  aug Rust_support
    au!
    au FileType rust :call Rust_init()
  aug Vim_support
    au!
    au FileType vim :call Vim_init()
  " Show trailing whitespaces when necessary {{{2
  " That is, most of the cases other than editing source code in Whitespace,
  " the programming language.
  augroup show_whitespaces
    au!
    " Make sure this will not be cleared by colorscheme
    "autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
    " Highlight unwanted whitespaces
    autocmd BufWinEnter,WinEnter,InsertLeave * call MatchUnwantedWhitespaces()
    " In insert mode, show trailing whitespaces except when typing at the end
    " of a line
    "autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
    " Show whitespaces in insert mode
    autocmd InsertEnter * set list
    " and turn it off when leave insert mode
    autocmd InsertLeave * set nolist
    " Clear highlight when lose focus
    autocmd WinLeave * call clearmatches()
  aug Textify
    au!
    au BufNewFile,BufRead *.txt,*.doc,*.pdf setl ft=txt
    au BufReadPre *.doc,*.class,*.pdf setl ro
    au BufReadPost *.doc silent %!antiword "%"
    au BufRead *.class exe 'silent %!javap -c "%"' | setl ft=java
    au BufReadPost *.pdf silent %!pdftotext -nopgbrk "%" -
  aug misc
    au!
    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid or when inside an event handler
    " (happens when dropping a file on gvim).
    " Also don't do it when the mark is in the first line, that is the default
    " position when opening a file.
    autocmd BufReadPost *
      \ if line("'\"") > 1 && line("'\"") <= line("$") |
      \   exe "normal! g`\"" |
      \ endif
    " turn on spell checker for commit messages
    au FileType gitcommit,hgcommit setlocal spell
    " and emails and plain text files
    au FileType mail,text setlocal spell
    " except 'help' files
    au BufEnter *.txt if &filetype == 'help' | setlocal nospell | endif
    " au FileType * exe('setl dictionary+='.$VIMRUNTIME.'/syntax/'.&filetype.'.vim')

    au Filetype dot let &makeprg="dot -Tpng -O -v % && feh %.png"
    au Filetype r let &makeprg="R <% --vanilla"
    au Filetype ocaml let &makeprg='ocaml %'
    "au FileType tex let &makeprg = 'xelatex -shell-escape -interaction=nonstopmode % && xdotool key Super+4'
  aug misc
    au BufWritePost .Xresources sil !xrdb %
  aug end
endif


" Languages ---------------- {{{1
" C++ {{{2
aug C
  au!
  au FileType c,cpp :call C_init()
aug D
  au!
  au FileType d :call D_init()
" GP {{{2
aug GP
  au!
  au FileType gp :call GP_init()
fu! GP_init()
  " Override
  nn <buffer> <leader>aa :silent !pkill -f <C-r>=expand('%:p')<cr><cr>:T gp <C-r>=expand('%:p')<cr><cr>
endf
" Automatically make cscope connections
fu! LoadHscope()
  let db = findfile("hscope.out", ".;")
  if (!empty(db))
    let path = strpart(db, 0, match(db, "/hscope.out$"))
    set nocscopeverbose " suppress 'duplicate connection' error
    exe "cs add " . db . " " . path
    set cscopeverbose
  endif
endf
fu! Pointfree()
  call setline('.', split(system('pointfree '.shellescape(join(getline(a:firstline, a:lastline), "\n"))), "\n"))
endf
fu! Pointful()
  call setline('.', split(system('pointful '.shellescape(join(getline(a:firstline, a:lastline), "\n"))), "\n"))
endf
" Make {{{2
au FileType make setl ts=8 sts=0 sw=8 noet
au FileType snippets setl ts=8 sts=0 sw=8 noet
" Python {{{2
aug Python
  au!
  au FileType python :call Python_init()
fu! Python_init()
  let b:deoplete_disable_auto_complete = 1
  ia <buffer> #! #!/usr/bin/env python3
  ia <buffer> #e # -*- coding: utf-8 -*-
  nn <buffer> <leader>mb Ofrom ipdb import set_trace as bp; bp()<esc>^j
  nn <buffer> <leader>mr Ofrom remote_pdb import RemotePdb; RemotePdb('0', 4444).set_trace()<esc>^j
  syn keyword pythonDecorator self
  " Setting 'python_space_error_highlight' = 1 will only highlight mixed
  " tabs and spaces, I go as far as mark all tabs as error.
  autocmd Syntax python syn match ExtraWhitespace /\t/
  nn <buffer> <leader>aa :T ./<C-r>=expand('%')<cr> -f /tmp/a.cap<cr>
  nn <buffer> <leader>= :0,$!yapf<CR>
  nn <buffer> <localleader>i :!isort %<cr><cr>
endf
let g:pymode_folding = 0
" failed to disable [Pymode] Init Rope project: $HOME, too slow, prefer YouCompleteMe
let g:pymode_rope = 0
let g:pymode_lint = 0
"let g:pymode_breakpoint_bind = '<leader>mb'
"let g:pymode_rope_goto_definition_bind = '<m-.>'
"let g:pymode_rope_goto_definition_cmd = 'e'
" Plugins --------------------------------------------- {{{1
if 1
  so ~/.vim/bundle/vim-plug/plug.vim
  call plug#begin('~/.vim/bundle')

  Plug 'liuchengxu/vim-clap'
  Plug 'sakhnik/nvim-gdb'
  Plug 'kana/vim-arpeggio'
  Plug 'kopischke/vim-fetch'
  Plug 'AndrewRadev/splitjoin.vim'
  "Plug 'SirVer/ultisnips'
  Plug 'junegunn/fzf'
  Plug 'junegunn/fzf.vim'
  Plug 'junegunn/rainbow_parentheses.vim'
  Plug 'junegunn/vim-easy-align'
  Plug 'tpope/vim-endwise'
  Plug 'tpope/vim-eunuch'
  Plug 'tpope/vim-unimpaired'
  Plug 'vim-scripts/VisIncr'
  Plug 'romainl/vim-qf'
  Plug 'hecal3/vim-leader-guide'

  " Window
  Plug 'majutsushi/tagbar'
  Plug 'simnalamburt/vim-mundo'

  " Tools
  Plug 'benmills/vimux'
  Plug 'neoclide/coc.nvim', {'tag': '*', 'do': { -> coc#util#install()}}
  "Plug 'prabirshrestha/async.vim'
  "Plug 'prabirshrestha/vim-lsp'
  "Plug 'jackguo380/vim-lsp-cxx-highlight'
  if has('nvim')
    "Plug 'autozimu/LanguageClient-neovim', {
    "  \ 'branch': 'next',
    "  \ }
    "Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  endif
  Plug 'justinmk/vim-sneak'
  Plug 'justinmk/vim-dirvish'
  Plug 'easymotion/vim-easymotion'
  Plug 'Shougo/echodoc.vim'
  Plug 'Shougo/neomru.vim'
  Plug 'Shougo/neosnippet.vim'
  Plug 'Shougo/neosnippet-snippets'
  Plug 'Shougo/neoyank.vim'
  Plug 'Shougo/denite.nvim'
  Plug 'Shougo/unite.vim' " dependency of vimfiler
  Plug 'Shougo/vimfiler.vim', { 'on': 'VimFilerExplorer' }
  Plug 'Shougo/vimproc.vim', { 'do': 'make' }
  Plug 'Shougo/vimshell.vim'
  Plug 'mhinz/vim-randomtag' " :Random
  Plug 'mhinz/vim-signify'
  Plug 'dhruvasagar/vim-table-mode'
  Plug 'glts/vim-textobj-comment'
  Plug 'glts/vim-textobj-indblock'
  Plug 'haya14busa/incsearch-easymotion.vim'
  Plug 'haya14busa/incsearch.vim'
  Plug 'janko-m/vim-test'
  Plug 'kana/vim-textobj-user'
  Plug 'KabbAmine/zeavim.vim'
  Plug 'lucapette/vim-textobj-underscore'
  Plug 'nathanaelkane/vim-indent-guides'
  Plug 'mhinz/vim-grepper'
  Plug 'w0rp/ale'
  Plug 'terryma/vim-expand-region'
  Plug 'tommcdo/vim-exchange'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-surround'
  Plug 'AndrewRadev/linediff.vim'
  Plug 'neomake/neomake'

  " Languages
  "" Go
  Plug 'fatih/vim-go', { 'for': 'go' }
  Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
  Plug 'mattn/emmet-vim'
  Plug 'rust-lang/rust.vim', { 'for': 'rust' }
  Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
  Plug 'python-mode/python-mode', { 'for': 'python' }
  Plug 'chrisbra/csv.vim', { 'for': 'csv' }
  Plug 'ledger/vim-ledger', { 'for': 'ledger' }

  "Colors
  Plug 'junegunn/seoul256.vim'
  Plug 'liuchengxu/space-vim-dark'

  call plug#end()
endif

" ale {{{2
let g:ale_enabled = 0
let g:ale_linters = {
      \   'c': ['ccls'],
      \   'cpp': ['ccls'],
      \}
let g:ale_linters_explicit = 1
" arpeggio {{{2
call arpeggio#map('i', '', 0, 'jk', '<Esc>')
" deoplete {{{2
let g:deoplete#enable_at_startup = 1
let g:deoplete#omni_patterns = {}
let g:deoplete#omni_patterns.cpp = '[^. *\t]\.\w*|[^. *\t]\::\w*|[^. *\t]\->\w*|#include\s*[<"][^>"]*'
let g:deoplete#omni#functions={}
let g:deoplete#omni#functions.cpp = ['LanguageClient#complete']
" EasyMotion {{{2
let g:EasyMotion_do_mapping = 1
let g:EasyMotion_startofline = 0
let g:EasyMotion_leader_key = 'gs'
" denite {{{2
call denite#custom#var('file_rec', 'command',
      \ ['rg', '--files', '--glob', '!.git', ''])
call denite#custom#map('insert', '<C-n>', '<denite:move_to_next_line>', 'noremap')
call denite#custom#map('insert', '<C-p>', '<denite:move_to_previous_line>', 'noremap')
" emmet {{{2
let g:user_emmet_leader_key = '<C-z>'
" GitGutter {{{2
let g:gitgutter_map_keys = 0
let g:gitgutter_enabled = 0
" grepper {{{2
let g:grepper = {}
let g:grepper.tools = ['rg', 'git']
"let g:ack_use_dispatch = 1
" LanguageClient-neovim {{{2
let g:LanguageClient_settingsPath = expand('~/.config/nvim/settings.json')
let g:LanguageClient_serverCommands = {
      \ 'c': ['ccls.debug'],
      \ 'cpp': ['ccls.debug'],
      \ 'cuda': ['ccls.debug'],
      \ 'objc': ['ccls.debug'],
      \ 'go': ['go-langserver', '-gocodecompletion', '-func-snippet-enabled', '-logfile=/tmp/gols.log'],
      \ 'python': ['pyls', '--log-file=/tmp/pyls.log'],
      \ 'rust': ['rustup', 'run', 'nightly', 'rls'],
      \ }
let g:LanguageClient_autoStart = 0
"let g:LanguageClient_hasSnippetSupport = 0
let g:LanguageClient_completionPreferTextEdit = 1
"let g:LanguageClient_devel = 1
"nn ga :call LanguageClient#workspace_symbol(input('workspace/symbol '))<cr>
"vn <leader>= :<C-u>call LanguageClient#textDocument_rangeFormatting()<cr>
"nn <leader>l= :call LanguageClient#textDocument_formatting()<cr>
"nn <leader>la :call LanguageClient#textDocument_codeAction()<cr>
"nn <leader>lf :call LanguageClient#textDocument_formatting()<cr>
"nn <leader>lr :call LanguageClient#textDocument_rename()<cr>
"nn <leader>l= :call LanguageClient#textDocument_formatting()<cr>
"nn <silent> K :call LanguageClient#textDocument_hover()<cr>
"nn <silent> <C-,> :sil call LanguageClient#textDocument_references({'includeDeclaration': v:false})<cr>
"nn <silent> <leader>si :call LanguageClient#textDocument_documentSymbol()<cr>
"nn <silent> <leader>sI :call LanguageClient#workspace_symbol()<cr>

" coc.nvim {{{2
set updatetime=300
augroup coc_config
  au!
  "au User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
  "au CursorHold * sil call CocActionAsync('highlight')
  "au CursorHoldI * sil call CocActionAsync('showSignatureHelp')
augroup END
nmap <silent> <M-j> <Plug>(coc-definition)
nmap <silent> <M-k> <Plug>(coc-references)
nn <silent> K :call <SID>show_documentation()<cr>
nn <silent> <leader>si :<C-u>CocList outline<cr>
nmap <silent> <leader>en <Plug>(coc-diagnostic-next)
nmap <silent> <leader>ep <Plug>(coc-diagnostic-prev)
nn <silent> ga :<C-u>CocList -I symbols<cr>
nn <leader>l= :call CocAction('format')<cr>
nmap <leader>la <Plug>(coc-codeaction)
nn <silent> <leader>lc :call CocAction('codeLens')<cr>
nn <leader>le :<C-u>CocList diagnostics<cr>
nmap <leader>lf <Plug>(coc-fix-current)
nmap <leader>lr <Plug>(coc-rename)
ino <expr><tab> pumvisible() ? "\<C-y>" : "\<tab>"
let g:coc_snippet_next = '<tab>'
let g:coc_snippet_prev = '<S-tab>'
let g:coc_start_at_startup = 0
au VimEnter * if getcwd() !~ 'Dev\|llvm\|projects' | let g:coc_start_at_startup=1 | endif
"let g:coc_node_args = ['--nolazy', '--inspect-brk=6045']
" one-level base
" bases
nn <silent> xb :call CocLocations('ccls','$ccls/inheritance')<cr>
" bases of up to 3 levels
nn <silent> xb :call CocLocations('ccls','$ccls/inheritance',{'levels':3})<cr>
" derived of up to 3 levels
nn <silent> xd :call CocLocations('ccls','$ccls/inheritance',{'derived':v:true})<cr>
" derived of up to 3 levels
nn <silent> xD :call CocLocations('ccls','$ccls/inheritance',{'derived':v:true,'levels':3})<cr>

" caller
nn <silent> xc :call CocLocations('ccls','$ccls/call')<cr>
" callee
nn <silent> xC :call CocLocations('ccls','$ccls/call',{'callee':v:true})<cr>

" $ccls/member
" member variables / variables in a namespace
nn <silent> xm :call CocLocations('ccls','$ccls/member')<cr>
" member functions / functions in a namespace
nn <silent> xf :call CocLocations('ccls','$ccls/member',{'kind':3})<cr>
" nested classes / types in a namespace
nn <silent> xs :call CocLocations('ccls','$ccls/member',{'kind':2})<cr>

nmap <silent> xt <Plug>(coc-type-definition)<cr>
nn <silent> xv :call CocLocations('ccls','$ccls/vars')<cr>
nn <silent> xV :call CocLocations('ccls','$ccls/vars',{'kind':1})<cr>
" leader-guide {{{2
let g:lmap = {}
call leaderGuide#register_prefix_descriptions("<Space>", "g:lmap")
" markdown {{{2
let g:vim_markdown_folding_disabled = 1
" neoterm {{{2
" sneak {{{2
let g:sneak#label = 1
let g:sneak#target_labels = "asdfghjkl;qwertyuiopzxcvbnm/ASDFGHJKL:QWERTYUIOPZXCVBNM?"
" Tagbar {{{2
let g:tagbar_autofocus = 1
let g:tagbar_autoshowtag = 1
" UltiSnips {{{2
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<S-tab>"
" local snippets only:
let g:UltiSnipsSnippetDirectories = ["UltiSnips"]
" vsplit the snippets edit window
let g:UltiSnipsEditSplit = 'vertical'
" VimFiler {{{2
let g:vimfiler_as_default_explorer=1
let g:vimfiler_ignore_pattern = '\.\%(byte\|cm.\|doc\|native\|o\|ppt\|pdf\)$'
" Colorschemes ---------------------------------------- {{{1
set background=dark
if has("gui_running")
  "colorscheme badwolf
  "colorscheme harlequin
  "colorscheme molokai
  "colorscheme hemisu
  colorscheme hybrid
else
  set t_Co=256
  "colorscheme bocau
  "colorscheme hybrid
  "colorscheme seoul256
  colorscheme space-vim-dark
endif
" Misc --------------------- {{{1
" vim hacks #181
" Open junk file."{{{
command! -nargs=0 JunkFile call s:open_junk_file()
function! s:open_junk_file()
let l:junk_dir = '/tmp/.junk'. strftime('/%Y/%m')
if !isdirectory(l:junk_dir)
  call mkdir(l:junk_dir, 'p')
endif

let l:filename = input('Junk Code: ', l:junk_dir.strftime('/%Y-%m-%d-%H%M%S.'))
if l:filename != ''
  execute 'edit ' . l:filename
endif
endfunction "}}}

" Beginning & End
"noremap H ^
"noremap L g_

" Open a Quickfix window for the last search.
nnoremap <silent> <leader>/ :execute 'vimgrep /'.@/.'/g %'<CR>:botright copen<CR>

" Paste toggle
set pastetoggle=<F7>

map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)
map z/ <Plug>(incsearch-easymotion-/)
map z? <Plug>(incsearch-easymotion-?)
map zg/ <Plug>(incsearch-easymotion-stay)

map n <Plug>(incsearch-nohl-n)zzzv
map N <Plug>(incsearch-nohl-N)zzzv
map * <Plug>(incsearch-nohl-*)zzzv
map # <Plug>(incsearch-nohl-#)zzzv
map g* <Plug>(incsearch-nohl-g*)zzzv
map g# <Plug>(incsearch-nohl-g#)zzzv

au BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal g`\"" |
      \ endif

if isdirectory(expand('~/.vim/bundle/vim-sneak'))
" ; :
  nn <silent> ; :if sneak#is_sneaking()<Bar>call sneak#rpt('',0)<Bar>else<Bar>call feedkeys(':', 'n')<Bar>endif<cr>
  nn : ;
  "nn <silent><expr> ; sneak#is_sneaking() ? ":call sneak#rpt('',0)<cr>" : ':'
  xn <silent> ; :<C-u>if sneak#is_sneaking()<Bar>call sneak#rpt('',0)<Bar>else<Bar>call feedkeys(":'<,'>", 'n')<Bar>endif<cr>
  xn : ;
endif

" clang-format
let g:clang_format#style_options = {
      \ "AccessModifierOffset" : -2,
      \ "AllowShortIfStatementsOnASingleLine" : "true",
      \ "AlwaysBreakTemplateDeclarations" : "true",
      \ "Standard" : "C++11",
      \ "BreakBeforeBraces" : "Stroustrup"}

" Command-line editing
cnoremap <C-R><C-L> <C-R>=getline('.')<CR>

let g:Tex_Flavor='latex'
let g:Tex_CompileRule_pdf = 'xelatex -interaction=nonstopmode $*'

fu! C_init()
  let b:deoplete_disable_auto_complete = 1
  setl cino+=g0,:0,j1,l1,N-s,t0,(0
  "setl mps+==:;  neovim
  setl tags+=~/.vim/static/cpp                        " core in cpp
  setl dictionary=~/.vim/dict/cpp
  abbr #i #include
  setl syntax=cpp.doxygen
  "let &makeprg="clang++ % -g -Wall -Wextra -O0 -std=c++11 -o %<"
  setl formatexpr=LanguageClient#textDocument_rangeFormatting()
  syn keyword cppType ulong i8 i16 i32 i64 u8 u16 u32 u64 real_t Vec Vec2D Vector Matrix Plane Sphere Geometry Ray Color Img imgptr
  syn keyword cppSTL priority_queue hypot isnormal isfinite isnan shared_ptr make_shared numeric_limits move
  syn keyword cppSTLType T

  nn <silent><buffer> <C-k> :call LanguageClient#findLocations({'method':'$ccls/navigate','direction':'L'})<cr>
  nn <silent><buffer> <C-l> :call LanguageClient#findLocations({'method':'$ccls/navigate','direction':'D'})<cr>
  nn <silent><buffer> <C-h> :call LanguageClient#findLocations({'method':'$ccls/navigate','direction':'U'})<cr>
  nn <silent><buffer> <C-j> :call LanguageClient#findLocations({'method':'$ccls/navigate','direction':'R'})<cr>

  ia <buffer> re return
  ia <buffer> return a<bs>

  command! A FSHere
  command! AV FSSplitRight

  if expand('%:p:h') == '/home/ray/CC'
    nn <buffer> <leader>aa :T make <C-r>=expand('%:r')<cr>.<cr>
  else
    nn <buffer> <leader>aa :T make && ./<C-r>=expand('%:r')<cr><cr>
  endif
endf

fu! CSS_init()
  setl dictionary=~/.vim/dict/css
endf

fu! D_init()
  nn <buffer> <leader>aa :VimuxRunCommand 'make && ./<C-r>=expand("%:r")<cr>'<cr>
endf

fu! Fortran_init()
  let g:fortran_free_source = 1
endf

fu! MarkDown_init()
  "ia <buffer> ``` ```<cr>```<up><end><esc>
  ia <buffer> more <!-- more -->
endf

fu! OCaml_init()
  setl isk-=.
endf

fu! Rust_init()
  nn <buffer> <leader>aa :T rustc <C-r>=expand('%')<cr> && <C-r>=expand('%:r')<cr><cr>
endf

fu! Vim_init()
  setl keywordprg=:help
endf

" map --------- {{{1
" cmap          {{{2
cmap w!! w !sudo tee % >/dev/null
cnoreab cdh cd %:p:h
cnoreab lcdh lcd %:p:h
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'
" nmap -------- {{{2
" nmap <leader> {{{3
if filereadable(expand('~/.vim/bundle/vim-indent-guides/README.markdown'))
  nn <leader> :<C-u>LeaderGuide '<Space>'<cr>
  vn <leader> :<C-u>LeaderGuideVisual '<Space>'<cr>
endif
" nmap <leader>a {{{4
let g:lmap.a = {'name': '+applications'}
nn <leader>aa :silent !pkill -f <C-r>=expand('%:p')<cr><cr>:T <C-r>=expand('%:p')<cr><cr>
nn <leader>at :TagbarToggle<cr>
nn <leader>as :Ttoggle<cr>
nn <leader>au :MundoToggle<cr>
nn <leader>ag :%!genhdr<cr>
nn <leader>aG :%!genhdr windows<cr>
" nmap <leader>b (buffer) {{{4
let g:lmap.b = {'name': '+buffers'}
nn <leader><leader> :Denite -winheight=10 buffer<cr>
nn <leader>bb <C-^>
nn <leader>bk :bp\|bd #<cr>
nn <Leader>bK :!cp % ~/tmp/%.bak --backup=numbered<cr>
nn <leader>bl :Buffers<cr>
nn <leader>bn :bn<cr>
nn <leader>bNh :topleft vertical new<cr>
nn <leader>bNj :rightbelow new<cr>
nn <leader>bNk :new<cr>
nn <leader>bNl :enew<cr>
nn <leader>bp :bp<cr>
nn <leader>bP :norm! ggdG"+P<cr>
nn <leader>bR :e<cr>
nn <leader>bw :set readonly!<cr>
nn <leader>bY :%y+<cr>
" nmap <leader>c (compile) {{{4
nn <leader>cC :let b:neomake_target=input('make ')<Bar>exe 'NeomakeSh make ' . b:neomake_target<cr>
nn <leader>cr :exe 'NeomakeSh make ' . b:neomake_target<cr>
" nmap <leader>d (diff) {{{4
nn <leader>dt :diffthis<CR>
nn <leader>do :bufdo diffoff<CR>
" nmap <leader>e (edit) {{{4
nn <leader>ec :SyntasticClear<cr>
nn <leader>ev :SyntasticInfo<cr>
nn <leader>ee :e <C-R>=expand("%:p:h") . "/" <CR>
nn <leader>es :sp <C-R>=expand("%:p:h") . "/" <CR>
nn <leader>ev :vsp <C-R>=expand("%:p:h") . "/" <CR>
nn <leader>et :tabe <C-R>=expand("%:p:h") . "/" <CR>
" nmap <leader>f (file) {{{4
let g:lmap.f = {'name': '+files'}
nn <leader>. :Denite file_rec<cr>
nn <leader>fc :cd %:p:h<cr>
nn <leader>fe :e ~/.vim/vimrc<cr>
nn <leader>ff :Denite file_rec<cr>
nn <silent> <leader>fr :Denite file_mru<cr>
nn <leader>fj :Dirvish<cr>
nn <leader>fJ :JunkFile<cr>
nn <leader>fs :update<cr>
nn <leader>fS :bufdo update<cr>
nn <leader>ft :VimFilerExplorer -winwidth=20<cr>
nn <leader>fT :VimFilerExplorer -winwidth=30<cr>
nn <leader>fy :let @*=expand('%:p')<Bar>echo @*<cr>
" nmap <leader>g (fugitive) {{{4
nmap <leader>g[ <Plug>GitGutterPrevHunk
nmap <leader>g] <Plug>GitGutterNextHunk
nn <leader>gb :Gblame<cr>
nn <leader>gc :Gcd<cr>
nn <leader>gd :Gdiff<cr>
nn <leader>gl :Glog<cr>
nn <leader>gp :Gpush<cr>
nn <leader>gP :Gpull<cr>
nn <leader>gg :Gstatus<cr>
" nmap <leader>q (quit) {{{4
let g:lmap.q = {'name': '+quit'}
nn <leader>qq :quit<cr>
" nmap <leader>r (register) {{{4
nn <leader>rl :Denite -resume<cr>
nn <leader>rr :Denite register<cr>
" nmap <leader>s (search) {{{4
let g:lmap.s = {'name': '+search'}
nn <leader>sd :Grepper -dir file<cr>
nn <leader>ss :Grepper<cr>
nn <leader>sj :SplitjoinJoin<cr>
nn <leader>sJ :SplitjoinSplit<cr>
nn <leader>sP :Grepper -noprompt -cword<cr>
nn <leader>pt :Grepper -query TODO\<bar>FIXME<cr>
" nmap <leader>t (toggle) {{{4
let g:lmap.t = {'name': '+toggles'}
"nn <leader>ta :!gtags && ctags -R<cr>
"nn <silent> <leader>ta :call deoplete#toggle()<Bar>echo 'deoplete '.(deoplete#is_enabled()?"enabled":"disabled")<cr>
nn <leader>tCd :RainbowParentheses!!<cr>
nn <leader>thc :set cursorcolumn!<cr>
nn <leader>tb :set breakindent!<cr>
nn <leader>tf :ALEToggle<cr>
nn <leader>ti :IndentGuidesToggle<cr>
nn <leader>tw :set wrap!<cr>
nn <leader>tha :MatchmakerToggle<cr>
nn <leader>tl :set nu!<cr>
nn <leader>ts :set spell!<cr>
"nn <leader>td :let b:deoplete_disable_auto_complete = exists('b:deoplete_disable_auto_complete') ? ! b:deoplete_disable_auto_complete : 1<cr>:echo ! b:deoplete_disable_auto_complete<cr>
" nmap <leader>v (vimux) {{{4
let g:lmap.v = {'name': '+vimux'}
nn <leader>vc :VimuxInterruptRunner<cr>
nn <leader>vi :VimuxInspectRunner<cr>
nn <leader>vp :VimuxPromptCommand<cr>
nn <leader>vl :VimuxRunLastCommand<cr>
nn <leader>vq :VimuxCloseRunner<cr>
function! VimuxSlime()
 call VimuxSendText(@v)
 call VimuxSendKeys("Enter")
endfunction
vn <leader>vs "vy :call VimuxSlime()<cr>
" nmap <leader>w (window) {{{4
let g:lmap.w = {'name': '+windows'}
nn <leader>w- :sp<cr>
nn <leader>w/ :vsp<cr>
" nmap <leader>x TODO {{{4
nn <leader>x :xit<cr>
" nmap <leader> misc {{{4
nn <leader>/ :Grepper -query<space>
nn <leader>? :Maps<cr>
nn <leader>1 :set cmdheight=1<cr>
nn <leader>2 :set cmdheight=2<cr>
nn <leader>3 :set cmdheight=3<cr>
nn <leader>4 :set cmdheight=4<cr>
nn <leader>5 :set cmdheight=5<cr>
nn <leader>L :call ErrorsToggle()<cr>
nn <leader>q :call QFixToggle()<cr>
nn <Leader>cp :!xsel -ib < %<cr><cr>
" nmap g {{{3
let g:lmap.g = {'name': '+git'}
nn <expr> gp '`['.strpart(getregtype(), 0, 1).'`]'
nmap gss <Plug>(easymotion-s2)
" nmap mark stack {{{3
let g:mark_ring = [{},{},{},{},{},{},{},{},{},{}]
let g:mark_ring_i = 0

function! MarkPush()
  let g:mark_ring[g:mark_ring_i] = {'path': expand('%:p'), 'line': line('.'), 'col': col('.')}
  let g:mark_ring_i = (g:mark_ring_i + 1) % len(g:mark_ring)
endfunction

function! MarkPop(d)
  let g:mark_ring[g:mark_ring_i] = {'path': expand('%:p'), 'line': line('.'), 'col': col('.')}
  let g:mark_ring_i = (g:mark_ring_i + a:d + len(g:mark_ring)) %  len(g:mark_ring)
  let mark = g:mark_ring[g:mark_ring_i]
  if !has_key(mark, 'path')
    echo 'empty g:mark_ping'
    return
  endif
  if mark.path !=# expand('%:p')
    silent exec 'e ' . fnameescape(mark.path)
  endif
  call cursor(mark.line, mark.col)
endfunction

" nmap easymotion sneak {{{3
map t <Plug>Sneak_t
map T <Plug>Sneak_T
map f <Plug>Sneak_f
map F <Plug>Sneak_F
" nmap n {{{3
nn xx x
" nmap Alt {{{3
nn <silent> <M-.> :YcmCompleter GoTo<cr>
nn <M-down> :lnext<cr>zvzz
nn <M-up> :lprevious<cr>zvzz
"nn <silent> <M-j> :call MarkPush()<cr>:call LanguageClient#textDocument_definition()<cr>
nn <M-1> :tabnext 1<cr>
nn <M-2> :tabnext 2<cr>
nn <M-3> :tabnext 3<cr>
nn <M-4> :tabnext 4<cr>
nn <M-5> :tabnext 5<cr>
nn <M-n> :new<cr>
nn <M-p> :cprevious<cr>zvzz
nn <M-r> :QuickRun<cr>
nn <M-q> :qa<cr>
nn <M-s> :w<cr>
nn <M-w> :q<cr>
" nmap , {{{3
nn ,al :LanguageClientStart<cr>
nn ,db :call append(line('.')-1, 'volatile static int z=0;while(!z)asm("pause");')<cr>
nn ,gs :Denite tag<cr>
nn ,gR :Denite tag -resume<cr>
" nmap misc {{{3
nn / ms/
nn <silent><Tab> :wincmd w<cr>
nn <silent><S-Tab> :wincmd p<cr>
nn <silent><C-l> :nohls<cr><C-r>=has('diff')?'<Bar>diffupdate':''<cr><Bar>redraw!<cr>
nmap <C-c><C-c> <Plug>SlimeParagraphSend
"nn <silent> <F9> :echo "hi<".synIDattr(synID(line("."),col("."),1),"name"). '> trans<'.synIDattr(synID(line("."),col("."),0),"name"). "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<cr>
nn <silent> <F9> :echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')<cr>
nn mm :call MarkPush(0)<cr>
nn 'm <C-t>
nn L :call MarkPop(1)<cr>
nn H :call MarkPop(-1)<cr>
nn <C-s> :Lines<cr>
nn zx :bdelete<cr>
" imap {{{2
" insert word of the line above
ino <C-Y> <C-C>:let @z = @"<CR>mz
      \:exec 'normal!' (col('.')==1 && col('$')==1 ? 'k' : 'kl')<CR>
      \:exec (col('.')==col('$') - 1 ? 'let @" = @_' : 'normal! yw')<CR>
      \`zp:let @" = @z<CR>a
inoremap <expr><C-h> deoplete#mappings#smart_close_popup()."\<C-h>"
" visual shifting (does not exit Visual mode)
vn < <gv
vn > >gv
" search for visual-mode selected text
"vmap // y/<C-R>"<CR>
vn <leader>S y:execute @@<cr>

" omap {{{2
" Motion for "next/last object". For example, "din(" would go to the next "()" pair
" and delete its contents.

onoremap an :<c-u>call <SID>NextTextObject('a', 'f')<cr>
xnoremap an :<c-u>call <SID>NextTextObject('a', 'f')<cr>
onoremap in :<c-u>call <SID>NextTextObject('i', 'f')<cr>
xnoremap in :<c-u>call <SID>NextTextObject('i', 'f')<cr>

onoremap al :<c-u>call <SID>NextTextObject('a', 'F')<cr>
xnoremap al :<c-u>call <SID>NextTextObject('a', 'F')<cr>
onoremap il :<c-u>call <SID>NextTextObject('i', 'F')<cr>
xnoremap il :<c-u>call <SID>NextTextObject('i', 'F')<cr>

function! s:NextTextObject(motion, dir)
  let c = nr2char(getchar())

  if c ==# "b"
      let c = "("
  elseif c ==# "B"
      let c = "{"
  elseif c ==# "d"
      let c = "["
  endif

  exe "normal! ".a:dir.c."v".a:motion.c
endfunction
" tmap {{{2
if exists(':tnoremap')
  tno <M-h> <C-\><C-n><C-w>h
  tno <M-j> <C-\><C-n><C-w>j
  tno <M-k> <C-\><C-n><C-w>k
  tno <M-l> <C-\><C-n><C-w>l
endif

" local vimrc if exists -------------------------- {{{1
sil! source ~/.vimrc.local
