" Dave's vimrc file
" Based on a vimrc file that came with vim or something.
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc

"Set location for backup/swap/undo dirs
let $VIMFILES=expand("$HOME/.vim")
if has('win32') || has('win64')
	let $VIMFILES=expand("$SystemDrive//Users/$USERNAME/vimfiles")
endif

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
	finish
endif

set nocompatible

" Configure vim-plug

" Install if missing
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin()
" The default plugin directory will be ~/.vim/plugged
let g:plug_timeout=300

" Make sure you use single quotes

" Gutter
Plug 'airblade/vim-gitgutter'
Plug 'vim-airline/vim-airline'

" Misc
Plug 'altercation/vim-colors-solarized'
Plug 'gioele/vim-autoswap'
Plug 'jszakmeister/vim-togglecursor'
Plug 'kien/ctrlp.vim'
Plug 'mbbill/undotree'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
if !has('gui') | Plug 'jamessan/vim-gnupg' | endif

" Code
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Filetype support
Plug 'freitass/todo.txt-vim'
Plug 'ledger/vim-ledger'
Plug 'pangloss/vim-javascript'
Plug 'posva/vim-vue'
Plug 'rodjek/vim-puppet'
Plug 'tpope/vim-fireplace'
Plug 'udalov/kotlin-vim'
Plug 'vim-scripts/groovy.vim'

call plug#end()

" Solarized config
set t_Co=256
syntax enable
set hlsearch
set background=dark
try
	colorscheme solarized
catch
endtry

" Make guake transparent
hi Normal ctermbg=none
highlight NonText ctermbg=none

" gitgutter config
set updatetime=250

" ledger-vim config
let g:ledger_bin='hledger'
"autocmd FileType ledger setlocal omnifunc=ledger#complete#omnifunc
if exists('g:ycm_filetype_blacklist')
	call extend(g:ycm_filetype_blacklist, { 'ledger': 1 })
endif
au FileType ledger noremap { ?^\d<CR>
au FileType ledger noremap } /^\d<CR>
"Align selection with tab
au FileType ledger vnoremap <silent> <Tab> :LedgerAlign<CR>
" Align buffer with <leader>a
au FileType ledger noremap <leader>a :LedgerAlignBuffer<CR>
let g:ledger_align_at = 40
let g:ledger_default_commodity = '$'

" Airline config
set laststatus=2
let g:airline#extensions#tabline#enabled = 1

" Toggle cursor config
" Extend to fix mintty cursor in cygwin
if !has('gui') && has('unix') && $OS == "Windows_NT"
	" \e = escape
	" ESC+[ 1 SP sets cursor to block
	" ESC+[ 5 SP sets cursor to line
	let &t_ti.="\e[1 q" " t_ti = put terminal in 'termcap' mode (start vim)
	let &t_SI.="\e[5 q" " t_SI = start insert mode
	let &t_EI.="\e[1 q" " t_EI = end insert mode
	let &t_te.="\e[5 q" " t_te = out of 'termcap' mode (close vim)
endif

" ctrlp config
let g:ctrlp_root_markers = ['.gitignore']
let g:ctrlp_custom_ignore = {
	\ 'dir': '\v[\/](\.git|bin|dist|build|node_modules)$',
	\ 'file': '\v\.(class|exe|dll|zip)$',
	\}

" Undotree config
" CTRL-U is 'scroll up' by default and I never use that.
nnoremap <C-u> :UndotreeToggle<cr>

" NERDTree config
" Open NERDTree when vim starts with no file specified
"autocmd StdinReadPre * let s:std_in=1
"autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" Open NERDTree with Ctrl-n
map <C-n> :NERDTreeToggle<CR>

set statusline+=%#warningmsg#
set statusline+=%{coc#status()}
set statusline+=%*

" CoC config
let g:coc_global_extensions = [
	\'coc-tsserver',
	\'coc-json',
	\'coc-html',
	\'coc-css',
	\'coc-eslint',
	\'coc-tailwindcss',
	\'coc-java',
	\'coc-clojure',
	\'coc-docker',
	\'coc-sh',
	\'coc-yaml',
	\'coc-snippets',
\]
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

""" END Coc Config """

" Configure tabs
set noexpandtab
set copyindent
set preserveindent
set softtabstop=4
set shiftwidth=4
set tabstop=4

" Capitulate to the collective insanity of the js community
if has("autocmd")
	autocmd Filetype javascript,json,vue,html,yaml setlocal expandtab softtabstop=2 shiftwidth=2 tabstop=2
endif

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" backup/undo/swap
if has("vms")
	set nobackup		" do not keep a backup file, use versions instead
else
	set backupdir=$VIMFILES/backup/
	set backup		" keep a backup file
endif
if has("undofile")
	set undofile
	set undodir=$VIMFILES/undo/
endif
set directory=$VIMFILES/swap/

set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
set ignorecase		" make searches case insensitive...
set smartcase		" unless the search pattern contains a capital letter

" Set up folding
" Set foldlevel 1 for source files
set foldenable "turn on folding
au BufReadPre set foldmethod=syntax
au BufWinEnter if &fdm == 'syntax' | setlocal foldmethod=manual | endif

" Don't use Ex mode, use Q for formatting
map Q gq

" Key mappings
" Use ctrl-t to move between tabs
map <C-T> :tabn<cr>

" Use ctrl-[jkhl] to move around splits
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-H> <C-W><C-H>
nnoremap <C-L> <C-W><C-L>

" Create sensible split shortcuts
" Note that 'frame' is the OS 'window' and 'window' is the vim file pane.
nmap <leader>swh :topleft vnew<CR> "Split frame left
cabbrev swh topleft vsplit

nmap <leader>swj :botright new<CR> "Split frame down
cabbrev swj botright split

nmap <leader>swk :topleft new<CR> "Split frame up
cabbrev swk topleft split

nmap <leader>swl :botright vnew<CR> "Split frame right
cabbrev swl botright vsplit

nmap <leader>sbh :leftabove vnew<CR> "Split window left
cabbrev sbh leftabove vsplit

nmap <leader>sbj :rightbelow new<CR> "Split window down
cabbrev sbj rightbelow split

nmap <leader>sbk :leftabove new<CR> "Split window up
cabbrev sbk leftabove split

nmap <leader>sbl :rightbelow vnew<CR> "Split window right
cabbrev sbl rightbelow vsplit

" CTRL-U in insert mode deletes a lot. Use CTRL-G u to first break undo, so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
	set mouse=a
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

	" Put these in an autocmd group, so that we can delete them easily.
	augroup vimrcEx
	au!

	" For all text files set 'textwidth' to 78 characters.
	autocmd FileType text setlocal textwidth=78

	" Tidy up all xml files
	"autocmd FileType xml exe ":silent 1,$!tidy -q -i -xml"

	" When editing a file, always jump to the last known cursor position.
	" Don't do it when the position is invalid or when inside an event handler
	" (happens when dropping a file on gvim).
	" Also don't do it when the mark is in the first line, that is the default
	" position when opening a file.
	autocmd BufReadPost *
		\ if line("'\"") > 1 && line("'\"") <= line("$") |
		\	 exe "normal! g`\"" |
		\ endif

	augroup END

	" Set filetype for these file extensions that aren't auto-detected
	au BufNewFile,BufRead *.gradle set filetype=groovy
	au BufNewFile,BufRead *.md set filetype=markdown

	" My autocmd config
	autocmd FileType xml cnoremap tidy %!tidy -q -i -xml
	autocmd FileType html cnoremap tidy %!tidy -q -i -html

	"Keep windows equal width when resizing window in diff mode
	if &diff
		autocmd VimResized * exec "normal \<C-w>="
	endif

endif " has("autocmd")

set autoindent		" always set autoindenting on

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
	command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
			\ | wincmd p | diffthis
endif

if has("unix")
	"set clipboard=unnamedplus
else
	set clipboard=unnamed "use windows clipboard
endif
if has("multi_byte")
  if &termencoding == ""
    let &termencoding = &encoding
  endif
  set encoding=utf-8
  setglobal fileencoding=utf-8
  "setglobal bomb
  set fileencodings=ucs-bom,utf-8,latin1
endif
set isk+=_,$,@,%,#,- "none of these should be word separators
set nowrap "don't wrap lines by default
set lbr "wrap on words
set guioptions=egmrLtTb
set formatoptions=l
set gfn=Source_Code_Pro:h9:cANSI
set so=14
set ssop-=options " do not store global and local values in a session

" Use regular numbers in insert-mode and relative numbers in normal mode.
set number
autocmd InsertEnter * :set relativenumber!
autocmd InsertLeave * :set relativenumber
set relativenumber

set cursorline "highlight current line
set wildmenu "visual autocomplete for command menu

if !exists(":Txml")
	command Txml set ft=xml | execute "%!tidy -q -i -xml -wrap 150"
endif
if !exists(":Thtml")
	command Thtml set ft=html | execute "%!tidy -q -i -html -wrap 150"
endif

" Protect large files from sourcing and other overhead.
" Files become read only
if !exists("my_auto_commands_loaded")
	let my_auto_commands_loaded = 1
	" Large files are > 10M
	" Set options:
	" 	eventignore+=FileType (no syntax highlighting etc
	"				assumes FileType always on)
	"	noswapfile (save copy of file)
	"	bufhidden=unload (save memory when other file is viewed)
	"	buftype=nowritefile (is read-only)
	"	undolevels=-1 (no undo possible)
	let g:LargeFile = 1024 * 1024 * 10
	augroup LargeFile
		autocmd BufReadPre * let f=expand("<afile>") | if getfsize(f) > g:LargeFile | set eventignore+=FileType | setlocal noswapfile bufhidden=unload buftype=nowrite undolevels=-1 | else | set eventignore-=FileType | endif
	augroup END
endif
