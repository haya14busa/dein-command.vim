"=============================================================================
" FILE: autoload/dein/command/check_lazy_plugins.vim
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

  let subcommand = 'check-lazy-plugins'

  let s:parser = s:ArgumentParser.new({
  \   'name': 'Dein ' . subcommand,
  \   'description': g:dein#command#subcommands[subcommand].description,
  \ })

  return s:parser
endfunction

function! dein#command#check_lazy_plugins#command(bang, range, args) abort
  let parser = s:parser()
  let options = parser.parse(a:bang, a:range, a:args)
  if empty(options)
    return
  endif
  let plugins = dein#check_lazy_plugins()
  if len(plugins) > 0
    echom 'There are nonsense lazy plugins: ' . string(plugins)
  endif
endfunction

function! dein#command#check_lazy_plugins#complete(arglead, cmdline, cursorpos) abort
  return s:parser().complete(a:arglead, a:cmdline, a:cursorpos)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
" vim: expandtab softtabstop=2 shiftwidth=2 foldmethod=marker

