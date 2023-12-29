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

set nocompatible


""""""""""""""""""""""
" Configure vim-plug "
""""""""""""""""""""""

" Install if missing
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin() " The default plugin directory will be ~/.vim/plugged

" Make sure you use single quotes around plugin names

Plug 'gioele/vim-autoswap' " Automatically deals with swap files when you open a buffer
Plug 'scrooloose/nerdcommenter' " <leader>cc to comment line/selection
Plug 'tpope/vim-sleuth' " Auto-detects whitespace (e.g. tabs vs spaces) of a file/project
Plug 'tpope/vim-sensible' " A bunch of sensible defaults
if !has('gui') | Plug 'jamessan/vim-gnupg' | endif

" Code
Plug 'editorconfig/editorconfig-vim' " Recognize editorconfig
Plug 'jiangmiao/auto-pairs' " Autocomplete pairs of parens, brackets, quotes, etc.
Plug 'tpope/vim-fugitive' " Git integration
Plug 'tpope/vim-surround' " Keymappings for surrounding with e.g. quotes or brackets

" Filetype support
Plug 'freitass/todo.txt-vim'
Plug 'pangloss/vim-javascript'
Plug 'posva/vim-vue'
Plug 'rodjek/vim-puppet'
Plug 'tpope/vim-fireplace' " For Clojure
Plug 'udalov/kotlin-vim'
Plug 'vim-scripts/groovy.vim'


"""""""""""""""""""""""""
" Solarized Colorscheme "
"""""""""""""""""""""""""
Plug 'altercation/vim-colors-solarized'
" Solarized config
set t_Co=256
set hlsearch
set background=dark
" colorscheme must be set after `call plug#end()` below


""""""""""""""
" Git Gutter "
""""""""""""""
Plug 'airblade/vim-gitgutter'
" gitgutter config
set updatetime=250


"""""""""""
" Airline "
"""""""""""
Plug 'vim-airline/vim-airline'
let g:airline#extensions#tabline#enabled = 1


"""""""""""
" Rainbow "
"""""""""""
Plug 'luochen1990/rainbow'
" rainbow config
let g:rainbow_active = 1 "set to 0 if you want to enable it later via :RainbowToggle


""""""""""
" Ledger "
""""""""""
Plug 'ledger/vim-ledger'
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
let g:ledger_align_at = 50
let g:ledger_default_commodity = '$'


"""""""""""""""""
" Toggle Cursor "
"""""""""""""""""
Plug 'jszakmeister/vim-togglecursor'
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


""""""""""
" CTRL-P "
""""""""""
Plug 'kien/ctrlp.vim'
" ctrlp config
let g:ctrlp_root_markers = ['.gitignore']
let g:ctrlp_custom_ignore = {
	\ 'dir': '\v[\/](\.git|bin|dist|build|node_modules)$',
	\ 'file': '\v\.(class|exe|dll|zip)$',
	\}


"""""""""""""
" Undo Tree "
"""""""""""""
Plug 'mbbill/undotree'
" Undotree config
" CTRL-U is 'scroll up' by default and I never use that.
nnoremap <C-u> :UndotreeToggle<cr>


""""""""""""
" NERDTree "
""""""""""""
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
" NERDTree config
" Open NERDTree when vim starts with no file specified
"autocmd StdinReadPre * let s:std_in=1
"autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" Open NERDTree with Ctrl-n
map <C-n> :NERDTreeToggle<CR>


"""""""""""""""""""""""""""""""
" Conquer of Completion (COC) "
"""""""""""""""""""""""""""""""
if has('gui')
	Plug 'neoclide/coc.nvim', {'branch': 'release'}
	" CoC config

	" Always show the signcolumn, otherwise it would shift the text each time
	" diagnostics appear/become resolved
	set signcolumn=yes

	let g:coc_global_extensions = [
		\'coc-clojure',
		\'coc-css',
		\'coc-docker',
		\'coc-eslint',
		\'coc-html',
		\'coc-java',
		\'coc-json',
		\'coc-sh',
		\'coc-snippets',
		\'coc-tailwindcss',
		\'coc-tsserver',
		\'coc-vetur',
		\'coc-yaml',
	\]

	" Use tab for trigger completion with characters ahead and navigate
	" NOTE: There's always complete item selected by default, you may want to enable
	" no select by `"suggest.noselect": true` in your configuration file
	" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
	" other plugin before putting this into your config
	inoremap <silent><expr> <TAB>
	      \ coc#pum#visible() ? coc#pum#next(1) :
	      \ CheckBackspace() ? "\<Tab>" :
	      \ coc#refresh()
	inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

	" Make <CR> to accept selected completion item or notify coc.nvim to format
	" <C-g>u breaks current undo, please make your own choice
	inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
				      \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

	function! CheckBackspace() abort
	  let col = col('.') - 1
	  return !col || getline('.')[col - 1]  =~# '\s'
	endfunction

	" Use <c-space> to trigger completion.
	if has('nvim')
	  inoremap <silent><expr> <c-space> coc#refresh()
	else
	  inoremap <silent><expr> <c-@> coc#refresh()
	endif

	" Use `[g` and `]g` to navigate diagnostics
	" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
	nmap <silent> [g <Plug>(coc-diagnostic-prev)
	nmap <silent> ]g <Plug>(coc-diagnostic-next)

	" GoTo code navigation
	nmap <silent> gd <Plug>(coc-definition)
	nmap <silent> gy <Plug>(coc-type-definition)
	nmap <silent> gi <Plug>(coc-implementation)
	nmap <silent> gr <Plug>(coc-references)

	" Use K to show documentation in preview window
	nnoremap <silent> K :call ShowDocumentation()<CR>

	function! ShowDocumentation()
	  if CocAction('hasProvider', 'hover')
	    call CocActionAsync('doHover')
	  else
	    call feedkeys('K', 'in')
	  endif
	endfunction

	" Symbol renaming
	nmap <leader>rn <Plug>(coc-rename)

	" Formatting selected code
	xmap <leader>f  <Plug>(coc-format-selected)
	nmap <leader>f  <Plug>(coc-format-selected)

	" Highlight the symbol and its references when holding the cursor.
	if has("autocmd")
		autocmd CursorHold * silent call CocActionAsync('highlight')
	endif

endif

call plug#end()

try
	colorscheme solarized
catch
endtry


"""""""""""""""""""""""""
" Miscelaneous settings "
"""""""""""""""""""""""""
set showcmd		" display incomplete commands
set ignorecase		" make searches case insensitive...
set smartcase		" unless the search pattern contains a capital letter
set isk+=$,@,%          " none of these should be word separators
set nowrap              " don't wrap lines by default
set lbr                 " wrap on words
set ssop-=options       " do not store global and local values in a session
set cursorline          "highlight current line
set guioptions=egmrLtTb
set formatoptions=l
set gfn=Source_Code_Pro:h9:cANSI
set so=14

if has('mouse')
	set mouse=a
endif

if has("multi_byte")
  if &termencoding == ""
    let &termencoding = &encoding
  endif
endif


"""""""""""""
" Clipboard "
"""""""""""""
if has("unix")
	"set clipboard=unnamedplus
else
	set clipboard=unnamed "use windows clipboard
endif


""""""""""""""""""""
" backup/undo/swap "
""""""""""""""""""""
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


"""""""""""
" Folding "
"""""""""""
set foldenable "turn on folding
au BufReadPre set foldmethod=syntax
au BufWinEnter if &fdm == 'syntax' | setlocal foldmethod=manual | endif


""""""""""""""
" Statusline "
""""""""""""""
set statusline+=%#warningmsg#
set statusline+=%{coc#status()}
set statusline+=%*


""""""""""""""""
" Key mappings "
""""""""""""""""
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

" Don't use Ex mode, use Q for formatting
map Q gq


"""""""""""""""
" Misc Tweaks "
"""""""""""""""
" Make guake transparent
hi Normal ctermbg=none
highlight NonText ctermbg=none

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
	command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
			\ | wincmd p | diffthis
endif

if !exists(":Txml")
	command Txml set ft=xml | execute "%!tidy -q -i -xml -wrap 150"
endif
if !exists(":Thtml")
	command Thtml set ft=html | execute "%!tidy -q -i -html -wrap 150"
endif

" Tidy up all xml files
"autocmd FileType xml exe ":silent 1,$!tidy -q -i -xml"

" Only do this part when compiled with support for autocommands.
if has("autocmd")

	" Put these in an autocmd group, so that we can delete them easily.
	augroup vimrcEx
	au!

	" For all text files set 'textwidth' to 78 characters.
	autocmd FileType text setlocal textwidth=78

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

	" Use regular numbers in insert-mode and relative numbers in normal mode.
	set number
	autocmd InsertEnter * :set relativenumber!
	autocmd InsertLeave * :set relativenumber
	set relativenumber

	" Protect large files from sourcing and other overhead.
	" Files become read only
	if !exists("large_file_auto_commands_loaded")
		let large_file_auto_commands_loaded = 1
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

endif " has("autocmd")

