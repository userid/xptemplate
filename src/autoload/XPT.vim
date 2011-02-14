if exists("g:__XPT_VIM__")
    finish
endif
let g:__XPT_VIM__ = 1



let s:oldcpo = &cpo
set cpo-=< cpo+=B

let XPT#ver = 3

let XPT#let_sid = 'map <Plug>xsid <SID>|let s:sid=matchstr(maparg("<Plug>xsid"), "\\d\\+_")|unmap <Plug>xsid'

let XPT#nullDict = {}
let XPT#nullList = []

let XPT#escapeHead   = '\v(\\*)\V'
let XPT#unescapeHead = '\v(\\*)\1\\?\V'
let XPT#nonEscaped =
      \   '\%('
      \ .     '\%(\[^\\]\|\^\)'
      \ .     '\%(\\\\\)\*'
      \ . '\)'
      \ . '\@<='
let XPT#regEval     = '\V\w(\|$\w'
let XPT#nonsafe     = '{$( '
let XPT#nonsafeHint = '$('

let XPT#item_var   = '\V' . '$\w\+'
let XPT#item_qvar  = '\V' . '{$\w\+}'
let XPT#item_func  = '\V' . '\w\+(\.\*)'
let XPT#item_qfunc = '\V' . '{\w\+(\.\*)}'


let XPT#ptnIncFull = '\V' . '\^Include:' . '\zs' . '\(\.\{-}\)\$'
let XPT#ptnIncSimp = '\V' . '\^:' . '\zs' . '\(\.\{-}\)' . '\ze' . ':\$'
let XPT#ptnRepetition = '\V'. '\^\w\*...\w\*\$'

let XPT#ptnPreEvalFunc = '\v^%(Inc|Inline|ResetIndent|Pre)\('

let XPT#BUILT = 0x001
let XPT#NOTBUILT = 0x002

let XPT#DONE   = 0x100
let XPT#UNDONE = 0x200
let XPT#GOON   = 0x300
let XPT#AGAIN  = 0x400
let XPT#BROKEN = -1




" VIM bug, variables in form *#* can not be used inside function. Thus I have to
" convert all them to script-local variables.
let XPT#importConst = ''
      \ . 'let s:escapeHead     = XPT#escapeHead | '
      \ . 'let s:unescapeHead   = XPT#unescapeHead | '
      \ . 'let s:nonEscaped     = XPT#nonEscaped | '
      \ . 'let s:regEval        = XPT#regEval | '
      \ . 'let s:nonsafe        = XPT#nonsafe | '
      \ . 'let s:nonsafeHint    = XPT#nonsafeHint | '
      \ . 'let s:nullDict       = XPT#nullDict | '
      \ . 'let s:nullList       = XPT#nullList | '
      \ . 'let s:item_var       = XPT#item_var   | '
      \ . 'let s:item_qvar      = XPT#item_qvar  | '
      \ . 'let s:item_func      = XPT#item_func  | '
      \ . 'let s:item_qfunc     = XPT#item_qfunc | '
      \ . 'let s:ptnIncFull     = XPT#ptnIncFull | '
      \ . 'let s:ptnIncSimp     = XPT#ptnIncSimp | '
      \ . 'let s:ptnRepetition  = XPT#ptnRepetition | '
      \ . 'let s:ptnPreEvalFunc = XPT#ptnPreEvalFunc | '
      \ . 'let s:DONE           = XPT#DONE | '
      \ . 'let s:UNDONE         = XPT#UNDONE | '
      \ . 'let s:GOON           = XPT#GOON | '
      \ . 'let s:AGAIN          = XPT#AGAIN | '
      \ . 'let s:BROKEN         = XPT#BROKEN | '
      \ . 'let s:BUILT          = XPT#BUILT | '
      \ . 'let s:NOTBUILT       = XPT#NOTBUILT | '
      \
      \ . 'let s:R_NEXT = 0x008 | '
      \ . 'let s:R_OUT  = 0x009 | '
      \ . 'let s:R_     = 0x00A | '
      \ . 'let s:R_FOO  = 0x00B | '
      \
      \ . 'let s:G_CRESTED   = 0x010 | '
      \ . 'let s:G_INITED    = 0x020 | '
      \ . 'let s:G_PROCESSED = 0x030 | '
      \ . 'let s:G_REFOCUSED = 0x040 | '

let XPT#priorities = {'all' : 192, 'spec' : 160, 'like' : 128, 'lang' : 96, 'sub' : 64, 'personal' : 32}
let XPT#skipPattern = 'synIDattr(synID(line("."), col("."), 0), "name") =~? "\\vstring|comment"'

fun! XPT#default(k, v) "{{{
    if !exists( a:k )
        exe "let" a:k "=" string( a:v )
    endif
endfunction "}}}

fun! XPT#warn( msg ) "{{{
    echohl WarningMsg
    echom a:msg
    echohl
endfunction "}}}
fun! XPT#info( msg ) "{{{
    echom a:msg
endfunction "}}}
fun! XPT#error( msg ) "{{{
    echohl ErrorMsg
    echom a:msg
    echohl
endfunction "}}}


call XPT#default( 'g:xpt_test_on_error', 'stop' )

fun! XPT#Assert( toBeTrue, msg ) "{{{
    if !a:toBeTrue
        call XPT#warn( a:msg )
        if g:xpt_test_on_error == 'stop'
            throw "XPT_TEST: fail: " . a:msg
        endif
    endi
endfunction "}}}
fun! XPT#AssertEq( a, b, msg ) "{{{
    call XPT#Assert( a:a == a:b, 'expect:' . string( a:a ) . ' but:' . string( a:b ) . ' message:' . a:msg )
endfunction "}}}

fun! XPT#Strlen( s ) "{{{
    return strlen(substitute(a:s, ".", "x", "g"))
endfunction "}}}



let &cpo = s:oldcpo
