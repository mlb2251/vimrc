colorscheme molokai_modded
syntax enable " enable syntax processing
filetype plugin indent on "indent based on file type using .vim/indent files

"adds the @peek decorator to a function by name (or just start of name)
function! Peek(name)
    normal mp
    execute "/def " . a:name
    normal O@peek
    normal `p
endfunction

"adds the @timeit decorator to a function by name (or just start of name)
function! Timeit(name)
    normal mp
    execute "/def " . a:name
    normal O@timeit
    normal `p
endfunction

"VERY clever. using :read! cat mypipe instead of :read mypipe
"bc read! reads the output of a command like cat, whereas :read
"is supposed to read from the pipe but it fails and you have to
"send everything twice and its messed up. so this is much better.
"i guess this is a lesson in using bash stuff to interact with 
"external things like pipes and then just taking the raw output from
"those using things like read! instead of read

function! Send()
    let old_yank=@0
    let old_unnamed=@"
    execute ".yank a"
    "remove newline
    let @a=substitute(@a,"\n","","")
    let line="'".getpid() . " " . @a . "'"
    execute ":silent !echo ".line." > ~/shorthand/runtime/toserver"
    "execute ":silent read! cat ~/shorthand/runtime/pipes/" . getpid()
    "reset yank and unnamed registers to original values
    let @0=old_yank
    let @"=old_unnamed
    execute ":silent read! cat ~/shorthand/runtime/pipes/" . getpid()
endfunction

function! Connect()
    echo "sending connect request"
    execute ":silent !mkfifo ~/shorthand/runtime/pipes/" . getpid()
    echo "made pipe: " . getpid()
    execute ":silent !echo '".getpid()." connect ". expand('%:p') ."' > ~/shorthand/runtime/toserver"
    echo "sent connection request"
    execute ":silent read! cat ~/shorthand/runtime/pipes/" . getpid()
    echo "read response"
endfunction    

function! Disconnect()
    echo "sending disconnect request"
    execute ":silent !echo '".getpid()." disconnect' > ~/shorthand/runtime/toserver"
    execute ":silent read! cat ~/shorthand/runtime/pipes/" . getpid()
    echo "read response"
    execute ":silent ! /bin/rm ~/shorthand/runtime/pipes/" . getpid()
    echo "removed pipe: " .getpid()
endfunction


function! FindDelete()
    let c = nr2char(getchar())
    execute "normal! mpf" . c . "x`p"
endfunction

function! FindReplace()
    let f = nr2char(getchar())
    let r = nr2char(getchar())
    execute "normal! mpf" . f . "r" . r . "`p"
endfunction


let &t_SI .= "\<Esc>[?2004h"
let &t_EI .= "\<Esc>[?2004l"

function! DoPaste() "the ! means overwrite funct if it exists already
    set pastetoggle=<Esc>[201~
    set paste
    return ""
endfunction

inoremap <special> <expr> <Esc>[200~ DoPaste()
"        ^         ^  not sure what these are for

"<l>s<any><any> for sub char
"<l>x<any> for del char
"maybe wrap these in <l>fx? idk.

"noremap <expr> <leader>x "mpf" . (nr2char(getchar())) . "x`p"

"find and delete, and find and replace functions (charwise)
noremap <leader>fd :call FindDelete()<cr>
noremap <leader>fr :call FindReplace()<cr>

noremap <leader>c :call Connect()<cr>
noremap <leader><space> :call Send()<cr>

""""""Matt's shortcuts

"
map <leader>src :source ~/.vimrc<CR>

"""leader shortcuts
"space is the leader key (by way of '\' that way showcmd shows it better)
let mapleader="\\"
map <space> \

noremap <leader>y "+y
noremap <leader>v "myiwoprintf("\n");jkF\"mPa:%djkf"a,jk"mp$
noremap <leader>p oprintf("\n");jkF\i
"<l>= autoindent full file
noremap <leader>= gg=G``zz
noremap <leader>w :w<CR>
noremap <leader>q :wq<CR>
"create testfile in c
noremap <leader>t i#include <stdio.h><cr>#include <stdlib.h><cr>int main(int argc, char **argv){<cr>return 0;<cr>}<esc>kO

"replace word with contents of "0 register
noremap <leader>r diw"0Pb
"same but replacing the WORD (not word)
noremap <leader>R diW"0Pb

"toggle line nums
noremap <leader>n :set number!<CR>

"turn a function into a function prototype
noremap <leader>d da}A;<esc>





"@TODO
"like fx but removes the character (returns to initial pos)
"like fx but replaces the character
"capitalize first letter of line
"do spellcheck on each letter of line
"(remap spellcheck)




"""insert mode remaps
inoremap {<CR> {<CR>}<esc>O
inoremap ;; {<CR>}<esc>O

"convert visual selection to an insertable text line for a macro
"vnoremap <leader>q yPgv:normal A<CR___><CR><ESC>gvgJ:s/___//g<CR>

"make backspace work in insert mode
set backspace=indent,eol,start

"""abbrevs
iabbrev teh the
"create testfile in c
iabbrev waht what

let python_highlight_all=1

set number " line #s
set showcmd	"show cmd in bottom bar
set cursorline " highlight curr line

" filetype indent on " loads indent files based on the filetype, eg
" loading ~/.vim/indent/python.vim when you open a *.py file

set wildmenu " gives a cool visual list of options as you cycle thru
" autocomplete options
set lazyredraw "speeds up macros by not redrawing screen unnecessarily
" in the middle of them

"actually this is a shitty setting cause it makes it jump weirdly so i
"disabled it:
"set showmatch "highlight matching () {} []
set noshowmatch
" search stuff
set incsearch "search as chars are entered
set hlsearch "highlight matches

" unhighlight the matches when you're done by pressing: ,space
" nnoremap <leader><space> :nohlsearch<CR>


" w wrapping text navigate it visually so if you have a very long line pressing j will bring your cursor down one character, not down to the next line
nnoremap j gj
nnoremap k gk

" this guy recommends rebinding  $ and ^ to E and B to jump to start and end of lines

" now you can press gV to select the test you last inserted in insert mode
nnoremap gV `[v`]


inoremap jk <esc>

"NOPs
noremap <Up>    <Nop>
noremap <Down>  <Nop>
noremap <Left>  <Nop>
noremap <Right> <Nop>
inoremap <Esc> <Nop>

nnoremap <silent> <C-l> :nohl<CR><C-l>


"""Jae's Vim settings

" Buffer switching using Cmd-arrows in Mac and Alt-arrows in Linux
:nnoremap <D-Right> :bnext<CR>
:nnoremap <M-Right> :bnext<CR>
:nnoremap <D-Left> :bprevious<CR>
:nnoremap <M-Left> :bprevious<CR>

" When coding, auto-indent by 4 spaces, just like in K&R
" Note that this does NOT change tab into 4 spaces
" You can do that with "set tabstop=4", which is a BAD idea
set shiftwidth=4

" Always replace tab with 8 spaces, except for makefiles
set expandtab
autocmd FileType make setlocal noexpandtab

" Don't do spell-checking on Vim help files
autocmd FileType help setlocal nospell

" Prepend ~/.backup to backupdir so that Vim will look for that directory
" before littering the current dir with backups.
" You need to do "mkdir ~/.backup" for this to work.
set backupdir^=~/.backup

" Also use ~/.backup for swap files. The trailing // tells Vim to incorporate
" full path into swap file names.
set dir^=~/.backup//

" Ignore case when searching
" - override this setting by tacking on \c or \C to your search term to make
"   your search always case-insensitive or case-sensitive, respectively.
set ignorecase

"
" End of Jae's Vim settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"The tab settings I like
set expandtab "replace tabs w spaces
set shiftwidth=4 "when you do >> or autoindentation happens it uses 4 spaces
set tabstop=4 " purely appearance I think - tabs look like 4 spaces
set softtabstop=4 "when you press TAB it inserts 4 spaces
autocmd FileType make setlocal noexpandtab "makefiles break if you use spaces instead of tabs




" Times the number of times a particular command takes to execute the specified number of times (in seconds).
function! HowLong( command, numberOfTimes )
  " We don't want to be prompted by a message if the command being tried is
  " an echo as that would slow things down while waiting for user input.
  let more = &more
  set nomore
  let startTime = localtime()
  for i in range( a:numberOfTimes )
    execute a:command
  endfor
  let result = localtime() - startTime
  let &more = more
  return result
endfunction

