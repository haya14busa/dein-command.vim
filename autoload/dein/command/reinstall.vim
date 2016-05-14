"=============================================================================
" FILE: autoload/dein/command/reinstall.vim
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

  let subcommand = 'reinstall'

  let s:parser = s:ArgumentParser.new({
  \   'name': 'Dein ' . subcommand,
  \   'description': g:dein#command#subcommands[subcommand].description,
  \ })

  call s:parser.add_argument(
  \   'plugin', 'a plugin to be reinstalled (e.g. dein.vim)',
  \   {
  \     'required': 1,
  \     'complete': function('dein#command#_complete#managed_plugins'),
  \   }
  \ )

  return s:parser
endfunction

function! dein#command#reinstall#command(bang, range, args) abort
  let parser = s:parser()
  let options = parser.parse(a:bang, a:range, a:args)
  if empty(options)
    return
  endif
  let plugin = has_key(options, 'plugin') ? [options.plugin] : []
  return dein#reinstall(plugin)
endfunction

function! dein#command#reinstall#complete(arglead, cmdline, cursorpos) abort
  return s:parser().complete(a:arglead, a:cmdline, a:cursorpos)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
" vim: expandtab softtabstop=2 shiftwidth=2 foldmethod=marker

