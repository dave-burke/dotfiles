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

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" set tab width
set ts=8
set shiftwidth=8 "same as tabwidth
" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
	set nobackup		" do not keep a backup file, use versions instead
else
	set backupdir=$VIMFILES/backup/
	set backup		" keep a backup file
endif
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.	Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
	set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
	syntax on
	set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

	" Enable file type detection.
	" Use the default filetype settings, so that mail gets 'tw' set to 72,
	" 'cindent' is on in C files, etc.
	" Also load indent files, to automatically do language-dependent indenting.
	filetype plugin indent on

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
	autocmd FileType java setlocal omnifunc=javacomplete#Complete
	autocmd FileType jsp setlocal foldlevel=1
	autocmd FileType js setlocal foldlevel=1
	autocmd FileType xml cnoremap tidy %!tidy -q -i -xml
	autocmd FileType html cnoremap tidy %!tidy -q -i -html

	set autoindent		" always set autoindenting on

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

" My config stuff
if has("unix")
	"set clipboard=unnamedplus
else
	set clipboard=unnamed "use windows clipboard
endif
set isk+=_,$,@,%,#,- "none of these should be word separators
set nowrap "don't wrap lines by default
set lbr "wrap on words
set foldenable "turn on folding
set foldmethod=indent "make folding indent sensitive
set foldlevel=100 "don't autofold anything
set guioptions=egmrLtTb
set formatoptions=l
set directory=$VIMFILES/swap/
set gfn=Source_Code_Pro:h9:cANSI
set encoding=utf8
set so=14
set ssop-=options " do not store global and local values in a session
colorscheme slate
if has("undofile")
	set undofile
	set undodir=$VIMFILES/undo/
endif

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

" GPG encryption/decryption via custom commands.
" This doesn't bother with things like preventing anything
" from getting written to .viminfo. It just does the encryption
" upon request.
function! s:MyGpg(recipient)
	let recipient = a:recipient
	execute "%!gpg -aes -r ".recipient
endfunction
if !exists(":Encrypt")
	command! -nargs=1 Encrypt call s:MyGpg(<f-args>)
endif
if !exists(":Decrypt")
	command Decrypt execute "%!gpg -d"
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

silent! execute pathogen#infect()

" Syntastic
let g:syntastic_javascript_checkers=['jsl']
let g:syntastic_java_checkers=['checkstyle']
