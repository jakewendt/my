" Vim color file

set background=light
hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "wendt"

"
"       term and cterm attributes don't seem to work
"               bold, underline, reverse, standout, italic
"
"       ctermfg
"       ctermbg
"                   *cterm-colors*
"            NR-16   NR-8    COLOR NAME ~
"            0       0       Black
"            1       4       DarkBlue
"            2       2       DarkGreen
"            3       6       DarkCyan
"            4       1       DarkRed
"            5       5       DarkMagenta
"            6       3       Brown, DarkYellow
"            7       7       LightGray, LightGrey, Gray, Grey
"            8       0*      DarkGray, DarkGrey
"            9       4*      Blue, LightBlue
"            10      2*      Green, LightGreen
"            11      6*      Cyan, LightCyan
"            12      1*      Red, LightRed
"            13      5*      Magenta, LightMagenta
"            14      3*      Yellow, LightYellow
"            15      7*      White
"

hi Comment      ctermfg=Black
hi! link MoreMsg  Comment
hi! link Question Comment

hi Constant     ctermfg=DarkGrey
hi link String    Constant
hi link Character Constant
hi link Boolean   Constant
hi link Number    Constant
hi link Float     Number

hi Special      ctermfg=Magenta
hi link SpecialChar    Special
hi link Delimiter      Special
hi link SpecialComment Special
hi link Debug          Special

hi Identifier   ctermfg=DarkBlue
hi link Function Identifier

hi Statement    ctermfg=DarkRed
hi link Conditional Statement
hi link Repeat      Statement
hi link Label       Statement
hi link Operator    Statement
hi link Keyword     Statement
hi link Exception   Statement

hi PreProc      ctermfg=Magenta
hi link Include   PreProc
hi link Define    PreProc
hi link Macro     PreProc
hi link PreCondit PreProc

hi Type         ctermfg=Blue
hi link StorageClass Type
hi link Structure    Type
hi link Typedef      Type

hi Visual       ctermfg=Yellow
hi Visual       ctermbg=Red
hi! link ErrorMsg   Visual
hi! link WarningMsg ErrorMsg

hi Search       ctermfg=Black
hi Search       ctermbg=Cyan

hi Tag          ctermfg=DarkGreen

hi Error        ctermfg=White
hi Error        ctermbg=Blue

hi Todo         ctermbg=Yellow
hi Todo         ctermfg=Black

hi StatusLine   ctermfg=Yellow
hi StatusLine   ctermbg=DarkGray

