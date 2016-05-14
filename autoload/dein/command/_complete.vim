"=============================================================================
" FILE: autoload/dein/command/_complete.vim
" AUTHOR: haya14busa
" License: MIT license
"=============================================================================
scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

let s:HTTP = vital#dein_command#import('Web.HTTP')
let s:JSON = vital#dein_command#import('Web.JSON')
let s:List = vital#dein_command#import('Data.List')

let s:github_search_repo_url = 'https://api.github.com/search/repositories'
let s:cache = {}

function! s:remote_repositories(arglead) abort
  if has_key(s:cache, a:arglead)
    return s:cache[a:arglead]
  endif
  let list = split(a:arglead, '/')
  let head = get(list, 0, '')
  let tail = join(list[1:], '/')
  let has_user = len(list) > 1 || a:arglead[len(a:arglead) - 1] is# '/'
  if has_user
    let [username, query] = [head, tail]
    let users = []
    if query is# ''
      let query = 'vim'
    endif
  else
    let [username, query] = ['', head]
    let users = map(filter(s:users(), 'v:val =~# ''^'' . head'), "v:val . '/'")
  endif
  let repos = map(dein#command#_complete#repos(query, username), 'v:val.full_name')
  let s:cache[a:arglead] = repos + users
  return s:cache[a:arglead]
endfunction

function! dein#command#_complete#repos(query, username) abort
  let user = a:username is# '' ? '' : 'user:' . a:username
  let res = s:HTTP.get(s:github_search_repo_url, {
  \   'q': a:query .' language:VimL in:name ' . user,
  \   'sort': 'stars',
  \   'order': 'desc',
  \ })
  if res.status isnot# 200
    return []
  endif
  return s:JSON.decode(res.content).items
endfunction

" ['haya14busa/incsearch.vim', ...]
function! s:managed_repos() abort
  return map(values(g:dein#_plugins), 'v:val.repo')
endfunction

" ['incsearch.vim', ...]
function! s:managed_plugins() abort
  return keys(g:dein#_plugins)
endfunction

" ['haya14busa', ...]
function! s:users() abort
  let repos = s:managed_repos()
  return s:List.uniq(map(repos, "get(split(v:val, '/'), -2, '')"))
endfunction

function! dein#command#_complete#remote_repositories(arglead, cmdline, cursorpos, ...) abort
  return s:remote_repositories(a:arglead)
endfunction

function! dein#command#_complete#managed_plugins(arglead, cmdline, cursorpos, ...) abort
  return filter(s:managed_plugins(), 'v:val =~# ''^\%(vim[-_]\)\='' . a:arglead')
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
" vim: expandtab softtabstop=2 shiftwidth=2 foldmethod=marker
