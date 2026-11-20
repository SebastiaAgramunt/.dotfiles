" awesome-vim base config, cloned by setup/clones.sh into ~/.local/share/awesome-vim
let s:awesome_vim = (empty($XDG_DATA_HOME) ? expand('~/.local/share') : $XDG_DATA_HOME) . '/awesome-vim'

if isdirectory(s:awesome_vim)
  execute 'set runtimepath+=' . s:awesome_vim
  execute 'source ' . s:awesome_vim . '/vimrcs/basic.vim'
  execute 'source ' . s:awesome_vim . '/vimrcs/filetypes.vim'
  execute 'source ' . s:awesome_vim . '/vimrcs/plugins_config.vim'
  execute 'source ' . s:awesome_vim . '/vimrcs/extended.vim'
endif

" My customizations
set number
set cursorline
set showmode
