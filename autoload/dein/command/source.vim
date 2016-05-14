"=============================================================================
" FILE: autoload/dein/command/source.vim
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

  let subcommand = 'source'

  let s:parser = s:ArgumentParser.new({
  \   'name': 'Dein ' . subcommand,
  \   'description': g:dein#command#subcommands[subcommand].description,
  \ })

  call s:parser.add_argument(
  \   'plugin', 'a plugin to be a:sourced (e.g. dein.vim)',
  \   {
  \     'complete': function('dein#command#source#complete_source'),
  \   }
  \ )

  return s:parser
endfunction

function! dein#command#source#command(bang, range, args) abort
  let parser = s:parser()
  let options = parser.parse(a:bang, a:range, a:args)
  if empty(options)
    return
  endif
  let plugin = has_key(options, 'plugin') ? [options.plugin] : []
  return dein#source(plugin)
endfunction

function! dein#command#source#complete(arglead, cmdline, cursorpos) abort
  return s:parser().complete(a:arglead, a:cmdline, a:cursorpos)
endfunction

function! dein#command#source#complete_source(arglead, cmdline, cursorpos, ...) abort
  return keys(filter(dein#get(), '!v:val.sourced'))
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
" vim: expandtab softtabstop=2 shiftwidth=2 foldmethod=marker

