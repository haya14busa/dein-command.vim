"=============================================================================
" FILE: autoload/dein/command/list.vim
" AUTHOR: haya14busa, Aoi Tachibana
" License: MIT license
"=============================================================================
scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

let s:ArgumentParser = vital#dein_command#import('ArgumentParser')

function! s:parser() abort
  if exists('s:parser') && !g:dein#command#debug
    return s:parser
  endif

  let subcommand = 'list'

  let s:parser = s:ArgumentParser.new({
  \   'name': 'Dein ' . subcommand,
  \   'description': g:dein#command#subcommands[subcommand].description,
  \ })

  return s:parser
endfunction

function! dein#command#list#command(bang, range, args) abort
  let parser = s:parser()
  let options = parser.parse(a:bang, a:range, a:args)
  if empty(options)
    return
  endif

  echomsg '[dein] #: not sourced, X: not installed'
  for [name, plugin] in items(dein#get())
    let prefix = '#'
    if !isdirectory(plugin.path)
      let prefix = 'X'
    elseif plugin.sourced
      let prefix = ' '
    endif
    echomsg prefix name
  endfor
endfunction

function! dein#command#list#complete(arglead, cmdline, cursorpos) abort
  return s:parser().complete(a:arglead, a:cmdline, a:cursorpos)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
" vim: expandtab softtabstop=2 shiftwidth=2 foldmethod=marker
