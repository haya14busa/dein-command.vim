dein-command.vim
================

utility comamnds of https://github.com/Shougo/dein.vim with rich completion.

```
:Dein [--help] subcommand

utility commands of dein.vim

Positional arguments:
  subcommand  A name of subcommand

              direct-install      [dein#direct_install] install a plugin directly
              source              [dein#source] :source plugins
              rollback            [dein#rollback] rollback plugins
              update              [dein#update] update a plugin
              check-clean         [dein#check_clean] check unused plugins directories
              clear-state         [dein#clear_state] clear the dein state file
              updates-log         [dein#get_updates_log] show the dein update log
              search              [original] seach vim plugins from GitHub
              recache-runtimepath [dein#recache_runtimepath] re-make runtimepath cache and execute :helptags
              each                [dein#each] execute shell command for each plugins
              check-lazy-plugins  [dein#check_lazy_plugins] check nonsense lazy plugins
              reinstall           [dein#reinstall] reinstall a plugin
              log                 [dein#get_log] show the dein log
              check-install       [dein#check_install] check plugins installation
              install             [dein#install] install a plugin
              check-update        [dein#check_update] check plugins update
              clean               [original] clean plugins directories
              list                [original] print a list of configured bundles

              Note that each sub-commands also have -h/--help option (*)

Optional arguments:
  -h, --help  show this help
```
