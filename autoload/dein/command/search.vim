"=============================================================================
" FILE: autoload/dein/command/search.vim
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

  let subcommand = 'search'

  let s:parser = s:ArgumentParser.new({
  \   'name': 'Dein ' . subcommand,
  \   'description': g:dein#command#subcommands[subcommand].description,
  \ })

  call s:parser.add_argument(
  \   'repository', 'a repository to be searched (e.g. Shougo/dein.vim)',
  \   {
  \     'required': 1,
  \     'complete': function('dein#command#_complete#remote_repositories'),
  \   }
  \ )

  return s:parser
endfunction

function! dein#command#search#command(bang, range, args) abort
  let parser = s:parser()
  let options = parser.parse(a:bang, a:range, a:args)
  if empty(options)
    return
  endif
  let [username; qs] = split(options.repository, '/')
  let query = join(qs, '/')
  let repos = dein#command#_complete#repos(query, username)
  for repo in repos
    let full_name = repo.full_name
    let url = repo.html_url
    let stars = repo.stargazers_count
    let description = repo.description
    echo printf('full_name:%s	description:%s	stars:%d	url:%s', full_name, description, stars, url)
  endfor
endfunction

function! dein#command#search#complete(arglead, cmdline, cursorpos) abort
  return s:parser().complete(a:arglead, a:cmdline, a:cursorpos)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
" vim: expandtab softtabstop=2 shiftwidth=2 foldmethod=marker

