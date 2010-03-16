" NOTE: Shortcuts for navigation harbor projects
" VERSION: 0.1

" Utility {{{1

function! s:sub(str,pat,rep) abort
  return substitute(a:str,'\v\C'.a:pat,a:rep,'')
endfunction

function! s:find_project_name() abort
  if !exists('s:project_name')
    let s:project_name = s:sub(system("basename $(pwd)"),'\n$','')
  endif
  return s:project_name
endfunction

function! s:find_lib_directory(...) abort
  if !exists('s:lib_directory')
    let s:lib_directory = 'lib/' . s:find_project_name()
  endif
  if a:0 == 0
    return s:lib_directory.'/'
  else
    return join([s:lib_directory, a:1], '/').'/'
  endif
endfunction

" }}}1
" Basic Commands {{{1

function! H(args)
  exec "edit " . a:args
  exec "redraw!"
endfunction

function! HT(args)
  exec "tabedit " . a:args
  exec "redraw!"
endfunction

function! HS(args)
  exec "split " . a:args
  exec "redraw!"
endfunction

function! HV(args)
  exec "vsplit " . a:args
  exec "redraw!"
endfunction

command! -nargs=1 -complete=file H call H(<q-args>)
command! -nargs=1 -complete=file HT call HT(<q-args>)
command! -nargs=1 -complete=file HS call HS(<q-args>)
command! -nargs=1 -complete=file HV call HV(<q-args>)

function! s:basiccomplete(A,base) abort
  let files = map(split(glob(a:base.a:A.'**'), "\n"),'v:val[strlen(a:base) : -1]')
  if a:A == ''
    return files
  else
    return filter(files, 'v:val[0 : strlen(a:A)-1] ==# a:A')
  endif
endfunction

" }}}1
" Navigation Commands {{{1

function! s:addfilecmds(type)
  let t = a:type
  let cmds = 'SVT '
  let cmd = ''
  while cmds != ''
    let complete = ' -complete=customlist,s:'.t.'Complete'
    exe "command! -nargs=*".complete." H".cmd.t." :call s:".t.'Edit("'.cmd.'",<f-args>)'
    let cmd = strpart(cmds,0,1)
    let cmds = strpart(cmds,1)
  endwhile
endfunction

function! s:libEdit(cmd,...)
  let command = 'H'.a:cmd.' '
  if a:0 == 0
    exe command.'lib/'.s:find_project_name().'.rb'
  else
    exe command.s:find_lib_directory().a:1
  endif
endfunction
function s:libComplete(A,L,P)
  return s:basiccomplete(a:A, s:find_lib_directory())
endfunction
call s:addfilecmds("lib")

function! s:controllerEdit(cmd,...)
  let command = 'H'.a:cmd.' '
  exe command.s:find_lib_directory('controllers').a:1
endfunction
function s:controllerComplete(A,L,P)
  return s:basiccomplete(a:A, s:find_lib_directory('controllers'))
endfunction
call s:addfilecmds("controller")

function! s:modelEdit(cmd,...)
  let command = 'H'.a:cmd.' '
  exe command.s:find_lib_directory('models').a:1
endfunction
function s:modelComplete(A,L,P)
  return s:basiccomplete(a:A, s:find_lib_directory('models'))
endfunction
call s:addfilecmds("model")

function! s:viewEdit(cmd,...)
  let command = 'H'.a:cmd.' '
  exe command.s:find_lib_directory('views').a:1
endfunction
function s:viewComplete(A,L,P)
  return s:basiccomplete(a:A, s:find_lib_directory('views'))
endfunction
call s:addfilecmds("view")

function! s:testEdit(cmd,...)
  let command = 'H'.a:cmd.' '
  exe command.'test/'.a:1
endfunction
function s:testComplete(A,L,P)
  return s:basiccomplete(a:A, 'test/')
endfunction
call s:addfilecmds("test")

function! s:integrationtestEdit(cmd,...)
  let command = 'H'.a:cmd.' '
  exe command.'test/integration/'.a:1
endfunction
function s:integrationtestComplete(A,L,P)
  return s:basiccomplete(a:A, 'test/integration/')
endfunction
call s:addfilecmds("integrationtest")

function! s:unittestEdit(cmd,...)
  let command = 'H'.a:cmd.' '
  exe command.'test/unit/'.a:1
endfunction
function s:unittestComplete(A,L,P)
  return s:basiccomplete(a:A, 'test/unit/')
endfunction
call s:addfilecmds("unittest")

function! s:publicEdit(cmd,...)
  let command = 'H'.a:cmd.' '
  exe command.'public/'.a:1
endfunction
function s:publicComplete(A,L,P)
  return s:basiccomplete(a:A, 'public/')
endfunction
call s:addfilecmds("public")

function! s:stylesheetEdit(cmd,...)
  let command = 'H'.a:cmd.' '
  exe command.'public/stylesheets/'.a:1
endfunction
function s:stylesheetComplete(A,L,P)
  return s:basiccomplete(a:A, 'public/stylesheets/')
endfunction
call s:addfilecmds("stylesheet")

function! s:javascriptEdit(cmd,...)
  let command = 'H'.a:cmd.' '
  exe command.'public/javascripts/'.a:1
endfunction
function s:javascriptComplete(A,L,P)
  return s:basiccomplete(a:A, 'public/javascripts/')
endfunction
call s:addfilecmds("javascript")

" }}}1
