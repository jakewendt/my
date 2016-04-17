"
"The global defaults had Blue on Black! Unreadable?
"/opt/local/share/vim/vimfiles/syntax/sas.vim
"
"Imported all settings and changed many 'bg=Black' to 'bg=White'
"
" Default sas enhanced editor color syntax
hi sComment	term=bold cterm=NONE ctermfg=Green ctermbg=White gui=NONE guifg=DarkGreen guibg=White
hi sCard	term=bold cterm=NONE ctermfg=Black ctermbg=Yellow gui=NONE guifg=Black guibg=LightYellow
hi sDate_Time	term=NONE cterm=bold ctermfg=Green ctermbg=White gui=bold guifg=SeaGreen guibg=White
hi sKeyword	term=NONE cterm=NONE ctermfg=Blue  ctermbg=White gui=NONE guifg=Blue guibg=White
hi sFmtInfmt	term=NONE cterm=NONE ctermfg=LightGreen ctermbg=White gui=NONE guifg=SeaGreen guibg=White
hi sString	term=NONE cterm=NONE ctermfg=Magenta ctermbg=White gui=NONE guifg=Purple guibg=White
hi sText	term=NONE cterm=NONE ctermfg=White ctermbg=Black gui=bold guifg=Black guibg=White
hi sNumber	term=NONE cterm=bold ctermfg=Green ctermbg=White gui=bold guifg=SeaGreen guibg=White
hi sProc	term=NONE cterm=bold ctermfg=Blue ctermbg=White gui=bold guifg=Navy guibg=White
hi sSection	term=NONE cterm=bold ctermfg=Blue ctermbg=White gui=bold guifg=Navy guibg=White
hi mDefine	term=NONE cterm=bold ctermfg=White ctermbg=Black gui=bold guifg=Black guibg=White
hi mKeyword	term=NONE cterm=NONE ctermfg=Blue ctermbg=White gui=NONE guifg=Blue guibg=White
hi mReference	term=NONE cterm=bold ctermfg=White ctermbg=Black gui=bold guifg=Blue guibg=White
hi mSection	term=NONE cterm=NONE ctermfg=Blue ctermbg=White gui=bold guifg=Navy guibg=White
hi mText	term=NONE cterm=NONE ctermfg=White ctermbg=Black gui=bold guifg=Black guibg=White

" Colors that closely match SAS log colors for default color scheme
hi lError	term=NONE cterm=NONE ctermfg=Red ctermbg=White gui=none guifg=Red guibg=White
hi lWarning	term=NONE cterm=NONE ctermfg=Green ctermbg=White gui=none guifg=Green guibg=White
hi lNote	term=NONE cterm=NONE ctermfg=Cyan ctermbg=White gui=none guifg=Blue guibg=White
