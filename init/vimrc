
"	shebang line for /bin/sh has this trailing . which makes it ignored when
" using some of vims word based movement keys
"	    *.sh      call SetFileTypeSH(getline(1))
":set iskeyword=@,48-57,_,192-255,.
":set iskeyword=@,48-57,_,192-255
" can't figure out how to override this behaviour
"au BufNewFile,BufRead *.sh
"  \ set iskeyword=@,48-57,_,192-255
"	/opt/local/share/vim/vim74/filetype.vim
"	/opt/local/share/vim/vim74/scripts.vim
" /opt/local/share/vim/vim74/syntax/sh.vim
"
"	show current file type with ...
"	:set ft?
":set g:sh_noisk
"	whooo.  found some code in syntax/sh.vim to checks the existance
" of g:sh_noisk before adding the "." to iskeyword
:let g:sh_noisk = 'something'


:set nobomb

"	link this file as ~/.vimrc

" kind of annoying
":set foldmethod=syntax

"	show special characters
":set invlist (what's the difference between list and invlist?)
":set list

:syntax enable
:set number

":set softtabstop=0
:set ts=2
":set expandtab

" ~/.vim/colors/wendt.vim
:colorscheme wendt

" map movement keys to "Escape" before moving
":map! [A k
":map! [B j
":map! [C l
":map! [D h
"	Rather than typing Ctrl-V then Up-Arrow, <up> (and other macros) works
:map! <up>    <esc>k
:map! <down>  <esc>j
:map! <right> <esc>l
:map! <left>  <esc>h

" Jump to last position (set cursor position to the line last at on close)
autocmd BufReadPost *
\ if line("'\"") > 0 && line ("'\"") <= line("$") |
\   exe "normal g'\"" |
\ endif





"	As of my recent upgrade to Mountain Lion, vim clears the screen on exit
"	This stops that clearing.  Don't know exactly how though.
:set t_ti= t_te=


"	Just in case some file type specific format options
"	Disable the autocomment marker insertion....
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o




"
"	Nothing below this is used
"


"
""this is for java, c++,c# can reshape as necessary
"":ab ff <ESC>^d$ifor(int i=0;i<<ESC>pi.length;i++){<CR><CR>}//end for loop over array <ESC>pi[i]<ESC>==k==k==ji<TAB>
"
""
""	Some abbreviations I found online (as examples)
""  ibl   for inserting a block
"ab ibl   {<ESC>o}<ESC>O
""  def   for inserting "#define" at the start of line
"ab def   #define
""  inc   for inserting "#include" at start of line
"ab inc   #include
""  else if (  for inserting else if block
"ab else if () {  else if () {<ESC>o}<ESC>k$2hi
""  mfor   for inserting "for" statement
"ab mfor   for (;;) {<ESC>o}<ESC>kwa
""  mif    for inserting "if" statement
"ab mif    if () {<ESC>o}<ESC>k$2hi
""  mwhile for inserting "while" statement
"ab mwhile while () {<ESC>o}<ESC>k$2hi
""  mmain  for inserting "main" routine
"ab mmain  main (argc,argv) <ESC>oint argc;<ESC>ochar *argv;<ESC>o{<ESC>o}<ESC>O
"
"	some html abbreviations
"	What's the diff between iab and ab?
"iab <t <target name="%"></target><esc>F%s<c-o>:call getchar()<cr>
"iab <a   <a title="" href="%"></a><esc>F%s<c-o>:call getchar()<cr>
"iab <img <img alt="" src="%" /><esc>F%s<c-o>:call getchar()<cr>
"iab <s   <script language="JavaScript" type="text/javascript" src="%"></script><esc>F%s<c-o>:call getchar()<cr>
"iab <h 
"	\<html>
"	\<cr><head>
"	\<cr><title>My Title</title>
"	\<cr></head>
"	\<cr><body>
"	\<cr>%
"	\<cr></body>
"	\<cr></html><esc>2k0C<tab><c-o>:call getchar()<cr>
"
"<lin doesn't work (is reserved or something?)
"iab link <link rel="stylesheet" type="text/css" href="%" /><esc>F%s<c-o>:call getchar()<cr>
"
""	map some ruby shortcuts
"iab <%   <%= X -%><esc>FXs<c-o>:call getchar()<cr>
"iab def 
"	\def
"	\<cr>%
"	\<cr>end<esc>1k0C<tab><c-o>:call getchar()<cr>

