"=============================================================================
" FILE: autoload/dein/command/clean.vim
" AUTHOR: haya14busa
" License: MIT license
"=============================================================================
scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

let s:ArgumentParser = vital#dein_command#import('ArgumentParser')
let s:List = vital#dein_command#import('Data.List')
let s:Set = vital#dein_command#import('Data.Set')

function! s:parser() abort
  if exists('s:parser') && !g:dein#command#debug
    return s:parser
  endif

  let subcommand = 'clean'

  let s:parser = s:ArgumentParser.new({
  \   'name': 'Dein ' . subcommand,
  \   'description': g:dein#command#subcommands[subcommand].description,
  \ })

  call s:parser.add_argument(
  \   '--directories', 'directories to be cleaned',
  \   {
  \     'complete': function('dein#command#clean#choice'),
  \     'type': s:ArgumentParser.types.multiple,
  \   }
  \ )

  return s:parser
endfunction

function! dein#command#clean#command(bang, range, args) abort
  let parser = s:parser()
  let options = parser.parse(a:bang, a:range, a:args)
  if empty(options)
    return
  endif
  let candidates = dein#check_clean()
  let paths = s:List.uniq(filter(get(options, 'directories', candidates), 'index(candidates, v:val) >= 0'))
  call map(copy(paths), 'dein#install#_rm(v:val)')
  echom 'Cleaned ' . string(paths)
endfunction

function! dein#command#clean#choice(arglead, cmdline, cursorpos, ...) abort
  let candidates = s:Set.set(dein#check_clean())
  let selected = get(get(a:, 1, {}), 'directories', [])
  let choices = candidates.sub(selected).to_list()
  return filter(choices, 'v:val =~# ''^'' . a:arglead')
endfunction

function! dein#command#clean#complete(arglead, cmdline, cursorpos) abort
  return s:parser().complete(a:arglead, a:cmdline, a:cursorpos)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
" vim: expandtab softtabstop=2 shiftwidth=2 foldmethod=marker

