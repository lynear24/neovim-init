call plug#begin('$VIM/plugins')

Plug 'vim-airline/vim-airline'
Plug 'rust-lang/rust.vim'
Plug 'ryanoasis/vim-devicons'
Plug 'morhetz/gruvbox'
Plug 'unblevable/quick-scope'
Plug 'stanangeloff/php.vim'
Plug 'zhou13/vim-easyescape'
Plug 'posva/vim-vue'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'michaeljsmith/vim-indent-object'
Plug 'andymass/vim-matchup'

call plug#end()

" Line numbers
set number relativenumber
" augroup numbertoggle
"   autocmd!
"   autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
"   autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
" augroup END

" Indention
filetype plugin indent on
syntax enable
set autoindent
set smartindent

" Miscellaneous
set history=1000
set showcmd
set autoread
set ignorecase
set smartcase
set cursorline
set notimeout
set ttimeout
set clipboard+=unnamedplus
set laststatus=2
set hlsearch
set mouse=a
set tabstop=5
set shiftwidth=5
set softtabstop=0
set noexpandtab
set shiftround
set nowrap
set linebreak
set scrolloff=8
set sidescrolloff=10
set confirm

" Disable startup splash message
set shortmess+=I

" Maintain undo history between sessions
" set undofile
" set undodir=~/.cache/nvim/undodir

" Remaps
noremap <Tab> ;
noremap : ;
noremap ; :
nnoremap <Space> :noh<cr>
" let mapleader = ','

" General buffer settings
set hidden

" vim-airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline_powerline_fonts = 1
let g:airline_theme='gruvbox'

" quick-scope
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
let g:qs_lazy_highlight = 1
augroup qs_colors
	autocmd!
	autocmd ColorScheme * highlight QuickScopePrimary guifg='#afff5f' gui=underline cterm=underline
	autocmd ColorScheme * highlight QuickScopeSeconday guifg='#5fffff' gui=underline cterm=underline
augroup END

" easy-motion
" map <Leader> <Plug>(easymotion-prefix)

" Color scheme
let g:rehash256 = 1
set background=dark
colorscheme gruvbox

" Move across wrapped lines like regular lines
" noremap 0 ^ " Go to the first non-blank character of a line
" noremap ^ 0 " Just in case you need to go to the very beginning of a line


" Only shift inner contents in a tag
" affects text object 'it' and 'at'
" 0: Strict, consider non-blank characters before and after the tags.
" 1: Flexible, ignore non-blank characters before and after the tags.
let g:innerMultilineHTMLTagMode = 1

function! InnerMultilineHTMLTag()
	" Get the position of the first line of the last selected Visual area.
	let openingMark =  getpos("'<")

	" Get the position of the last line of the last selected Visual area.
	let closingMark = getpos("'>")

	" Check whether both marks are on the same line.
	if openingMark[1] != closingMark[1]

		" Get the lines where the marks are on.
		let openingLine = getline(openingMark[1])
		let closingLine = getline(closingMark[1])

		" Check whether there's nothing appended to the opening tag.
		if g:innerMultilineHTMLTagMode == 1  ||
					\ match( openingLine, '\S',  openingMark[2] - 1) == -1

			" Check whether the closing tag is at the beginning of the line.
			if match( closingLine, "$" ) + 1  ==  closingMark[2]
				" Restore and adjust the last Visual area.
				normal! gvVojo
				return

				" Check whether there's nothing prepended to the closing tag.
			elseif g:innerMultilineHTMLTagMode == 1  ||
						\   match( closingLine, '\S\%<' . closingMark[2] . "c" ) == -1
				" Restore and adjust the last Visual area.
				normal! gvVkojo
				return
			endif
		endif
	endif

	" Do nothing. Restore the last Visual area.
	normal! gv
endfunction

function! ToggleInnerMultilineHTMLTagMode()
	if g:innerMultilineHTMLTagMode == 0
		let g:innerMultilineHTMLTagMode = 1
		echo "it text object is now flexible"
	else
		let g:innerMultilineHTMLTagMode = 0
		echo "it text object is now strict"
	endif
endfunction

" Map to set the multi-line HTML tag mode.
nnoremap - :call ToggleInnerMultilineHTMLTagMode()<CR>

" Map to extend the behavior of the 'it' text object to create linewise
" visual areas within multi-line HTML tags.
" See https://vi.stackexchange.com/q/13050/6698
vnoremap it it:<C-U>call InnerMultilineHTMLTag()<CR>
" omap it :normal vit<CR>

"Remove all trailing whitespace by pressing F5
nnoremap <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>

if (exists("g:vscode"))
	nnoremap <silent> za <Cmd>call VSCodeNotify('editor.toggleFold')<CR>
	nnoremap <silent> zR <Cmd>call VSCodeNotify('editor.unfoldAll')<CR>
	nnoremap <silent> zM <Cmd>call VSCodeNotify('editor.foldAll')<CR>
	nnoremap <silent> zo <Cmd>call VSCodeNotify('editor.unfold')<CR>
	nnoremap <silent> zO <Cmd>call VSCodeNotify('editor.unfoldRecursively')<CR>
	nnoremap <silent> zc <Cmd>call VSCodeNotify('editor.fold')<CR>
	nnoremap <silent> zC <Cmd>call VSCodeNotify('editor.foldRecursively')<CR>

	nnoremap <silent> z1 <Cmd>call VSCodeNotify('editor.foldLevel1')<CR>
	nnoremap <silent> z2 <Cmd>call VSCodeNotify('editor.foldLevel2')<CR>
	nnoremap <silent> z3 <Cmd>call VSCodeNotify('editor.foldLevel3')<CR>
	nnoremap <silent> z4 <Cmd>call VSCodeNotify('editor.foldLevel4')<CR>
	nnoremap <silent> z5 <Cmd>call VSCodeNotify('editor.foldLevel5')<CR>
	nnoremap <silent> z6 <Cmd>call VSCodeNotify('editor.foldLevel6')<CR>
	nnoremap <silent> z7 <Cmd>call VSCodeNotify('editor.foldLevel7')<CR>

	xnoremap <silent> zV <Cmd>call VSCodeNotify('editor.foldAllExcept')<" Workaround for gk/gj
endif