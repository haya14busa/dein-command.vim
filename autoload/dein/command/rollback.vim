"=============================================================================
" FILE: autoload/dein/command/rollback.vim
" AUTHOR: haya14busa
" License: MIT license
"=============================================================================
scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

let s:ArgumentParser = vital#dein_command#import('ArgumentParser')
let s:Set = vital#dein_command#import('Data.Set')

function! s:parser() abort
  if exists('s:parser') && !g:dein#command#debug
    return s:parser
  endif

  let subcommand = 'rollback'

  let s:parser = s:ArgumentParser.new({
  \   'name': 'Dein ' . subcommand,
  \   'description': g:dein#command#subcommands[subcommand].description,
  \ })

  call s:parser.add_argument(
  \   '--date', 'date to rollback (e.g. 20160424031431)',
  \   {
  \     'complete': function('dein#command#rollback#complete_date'),
  \   }
  \ )

  call s:parser.add_argument(
  \   '--plugin', 'plugins to rollback (e.g. dein.vim)',
  \   {
  \     'complete': function('dein#command#_complete#managed_plugins'),
  \     'type': s:ArgumentParser.types.multiple,
  \   }
  \ )

  return s:parser
endfunction

function! dein#command#rollback#command(bang, range, args) abort
  let parser = s:parser()
  let options = parser.parse(a:bang, a:range, a:args)
  if empty(options)
    return
  endif
  let date = get(options, 'date', '')
  let plugin = get(options, 'plugin', [])
  return dein#rollback(date, plugin)
endfunction

function! dein#command#rollback#complete(arglead, cmdline, cursorpos) abort
  return s:parser().complete(a:arglead, a:cmdline, a:cursorpos)
endfunction

function! dein#command#rollback#complete_date(arglead, cmdline, cursorpos, ...) abort
  let options = get(a:, 1, {})
  let plugins = get(options, 'plugin', [])
  return s:rollback_dates(a:arglead, plugins)
endfunction

function! s:rollback_dates(date_query, plugins) abort
  let files = reverse(sort(split(globpath(s:rollback_dir(), a:date_query . '*', 1), "\n")))
  if empty(a:plugins)
    let date_files = files
  else
    let seen_revs = s:Set.set()
    let date_files = []
    for file in files
      let revs = dein#_json2vim(readfile(file)[0])
      let plugin_revs = map(copy(a:plugins), "get(revs, v:val, '')")
      if seen_revs.in(plugin_revs)
        continue
      endif
      call seen_revs.add(plugin_revs)
      call add(date_files, file)
    endfor
  endif
  return map(date_files,  "fnamemodify(v:val, ':t:r')")
endfunction

function! s:rollback_dir() abort
  return printf('%s/rollbacks/%s', dein#util#_get_cache_path(), fnamemodify(v:progname, ':r'))
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
" vim: expandtab softtabstop=2 shiftwidth=2 foldmethod=marker

