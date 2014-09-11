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

" Plugin management
" Vundle setup
filetype off
set rtp+=$VIMFILES/bundle/Vundle.vim
call vundle#begin(expand("$VIMFILES//bundle"))
Plugin 'gmarik/Vundle.vim'

" My Bundles
Plugin 'altercation/vim-colors-solarized'
Plugin 'AutoTag'
Plugin 'bling/vim-airline'
Plugin 'ervandew/supertab'
Plugin 'freitass/todo.txt-vim'
if !has('gui') | Plugin 'jamessan/vim-gnupg' | endif
Plugin 'jszakmeister/vim-togglecursor'
Plugin 'kien/ctrlp.vim'
Plugin 'majutsushi/tagbar'
Plugin 'mbbill/undotree'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
if has('lua') | Plugin 'Shougo/neocomplete.vim' | endif
Plugin 'tpope/vim-fugitive'

" Finish Vundle setup
call vundle#end()
filetype plugin indent on

" Solarized config
set t_Co=256
syntax enable
set hlsearch
set background=dark
colorscheme solarized

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
let g:ctrlp_root_markers = ['.acignore']
let g:ctrlp_custom_ignore = '\v\.(class|exe|dll|zip)$'

" Tagbar config
nmap <C-m> :TagbarToggle<CR>

" Undotree config
" CTRL-U is 'scroll up' by default and I never use that.
nnoremap <C-u> :UndotreeToggle<cr>

" NERDTree config
" Open NERDTree when vim starts with no file specified
"autocmd StdinReadPre * let s:std_in=1
"autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" Open NERDTree with Ctrl-n
map <C-n> :NERDTreeToggle<CR>

" Syntastic config
let g:syntastic_javascript_checkers=['jshint']
let g:syntastic_java_checkers=['checkstyle']

" Neocomplete config
if has('lua')
	let g:neocomplete#enable_at_startup = 1
	autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
	autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
	autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
	autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
	autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
	autocmd FileType java setlocal omnifunc=javacomplete#Complete
	set tags=./tags;
else
	" This prevents the annoying pop-up when neocomplete can't load
	let g:loaded_neocomplete = 1
endif

" set tab width
set ts=8
set shiftwidth=8 "same as tabwidth
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

" Don't use Ex mode, use Q for formatting
map Q gq

" Key mappings
nnoremap <C-J> <C-W><C-J> " ctrl-j moves down a split
nnoremap <C-K> <C-W><C-K> " ctrl-k moves up a split
nnoremap <C-H> <C-W><C-H> " ctrl-h moves left a split
nnoremap <C-L> <C-W><C-L> " ctrl-l moves right a split
inoremap <C-U> <C-G>u<C-U> " CTRL-U in insert mode deletes a lot. Use CTRL-G u to first break undo, so that you can undo CTRL-U after inserting a line break.

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
	" Set foldlevel 1 for source files
	autocmd FileType java setlocal foldlevel=1
	autocmd FileType jsp setlocal foldlevel=1
	autocmd FileType js setlocal foldlevel=1
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
set foldenable "turn on folding
set foldmethod=indent "make folding indent sensitive
set foldlevel=100 "don't autofold anything
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
