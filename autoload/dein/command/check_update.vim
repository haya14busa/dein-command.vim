"=============================================================================
" FILE: autoload/dein/command/check_update.vim
" AUTHOR: haya14busa
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

  let subcommand = 'check-update'

  let s:parser = s:ArgumentParser.new({
  \   'name': 'Dein ' . subcommand,
  \   'description': g:dein#command#subcommands[subcommand].description,
  \ })

  call s:parser.add_argument(
  \   'plugin', 'plugins to be checked (e.g. dein.vim)',
  \   {
  \     'complete': function('dein#command#_complete#managed_plugins'),
  \     'type': s:ArgumentParser.types.multiple,
  \   }
  \ )

  return s:parser
endfunction

function! dein#command#check_update#command(bang, range, args) abort
  let parser = s:parser()
  let options = parser.parse(a:bang, a:range, a:args)
  if empty(options)
    return
  endif
  return call('dein#check_update', has_key(options, 'plugin') ? [options.plugin] : [])
endfunction

function! dein#command#check_update#complete(arglead, cmdline, cursorpos) abort
  return s:parser().complete(a:arglead, a:cmdline, a:cursorpos)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
" vim: expandtab softtabstop=2 shiftwidth=2 foldmethod=marker

