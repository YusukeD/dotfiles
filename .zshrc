autoload -Uz vcs_info
autoload -Uz colors
colors

PATH="$HOME/.composer/vendor/bin:$PATH"
PATH="$HOME/.bin:$HOME/.nodebrew/current/bin:/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
PATH="/usr/local/opt/findutils/libexec/gnubin:$PATH"
MANPATH="/usr/local/opt/findutils/libexec/gnuman:$MANPATH"
HISTFILE="$HOME/.zsh_history"

export LSCOLORS=fxgxcxdxbxegedabagacad
export LS_COLORS='di=35:ln=37:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
export DOCKER_HOST_IP=10.200.10.1

alias ls="ls --color=auto"
alias ll="ls --color=auto -l"
alias dc="docker compose"
alias dcexec="docker compose exec"

PROMPT="%{$fg[magenta]%}[%{$fg[green]%}%n%{$fg[yellow]%}@%{$fg[magenta]%}%m%{$reset_color%}:%{$fg[cyan]%}%1~%{$fg[magenta]%}]$%{$reset_color%} "

# # Override auto-title when static titles are desired ($ title My new title)
# title() { export TITLE_OVERRIDDEN=1; echo -en "\e]0;$*\a"}
# # Turn off static titles ($ autotitle)
# autotitle() { export TITLE_OVERRIDDEN=0 }; autotitle
# # Condition checking if title is overridden
# overridden() { [[ $TITLE_OVERRIDDEN == 1 ]]; }
# # Echo asterisk if git state is dirty
# gitDirty() { [[ $(git status 2> /dev/null | grep -o '\w\+' | tail -n1) != ("clean"|"") ]] && echo "*" }

# # Show cwd when shell prompts for input.
# tabtitle_precmd() {
#    if overridden; then return; fi
#    pwd=$(pwd) # Store full path as variable
#    cwd=${pwd##*/} # Extract current working dir only
#    print -Pn "\e]0;$cwd$(gitDirty)\a" # Replace with $pwd to show full path
# }
# [[ -z $precmd_functions ]] && precmd_functions=()
# precmd_functions=($precmd_functions tabtitle_precmd)

# # Prepend command (w/o arguments) to cwd while waiting for command to complete.
# tabtitle_preexec() {
#    if overridden; then return; fi
#    printf "\033]0;%s\a" "${1%% *} | $cwd$(gitDirty)" # Omit construct from $1 to show args
# }
# [[ -z $preexec_functions ]] && preexec_functions=()
# preexec_functions=($preexec_functions tabtitle_preexec)

fpath=(~/.zsh/completion $fpath)

autoload -U compinit
compinit

zstyle ':completion:*' list-colors "${LS_COLORS}"

# 単語の入力途中でもTab補完を有効化
setopt complete_in_word
# 補完候補をハイライト
zstyle ':completion:*:default' menu select=1
# キャッシュの利用による補完の高速化
zstyle ':completion::complete:*' use-cache true
# 大文字、小文字を区別せず補完する
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# 補完リストの表示間隔を狭くする
setopt list_packed

# 履歴ファイルの保存先
export HISTFILE=${HOME}/.zsh_history

# メモリに保存される履歴の件数
export HISTSIZE=1000

# 履歴ファイルに保存される履歴の件数
export SAVEHIST=100000

# 重複を記録しない
setopt hist_ignore_dups

# 開始と終了を記録
setopt EXTENDED_HISTORY

# コマンドの打ち間違いを指摘してくれる
setopt correct
SPROMPT="correct: $RED%R$DEFAULT -> $GREEN%r$DEFAULT ? [Yes/No/Abort/Edit] => "

# setopt nonomatch

# jEnv
export JENV_ROOT="$HOME/.jenv"
if [ -d "${JENV_ROOT}" ]; then
  export PATH="$JENV_ROOT/bin:$PATH"
  eval "$(jenv init -)"
fi

# nodeenv
[[ -d ~/.nodenv  ]] && \
  export PATH="$HOME/.nodenv/bin:$PATH" && \
  eval "$(nodenv init -)"

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

source ~/.zplug/init.zsh

# 入力途中に候補をうっすら表示
zplug "zsh-users/zsh-autosuggestions"

# コマンドを種類ごとに色付け
zplug "zsh-users/zsh-syntax-highlighting", defer:2

# ヒストリの補完を強化する
zplug "zsh-users/zsh-history-substring-search"

zplug "zplug/zplug", hook-build:'zplug --self-manage'
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# コマンドをリンクして、PATH に追加し、プラグインは読み込む
zplug load

if zplug check zsh-users/zsh-history-substring-search; then
    bindkey '^[OA' history-substring-search-up
    bindkey '^[OB' history-substring-search-down
fi

# checks to see if we are in a windows or linux dir
function isWinDir {
  case $PWD/ in
    /mnt/*) return $(true);;
    *) return $(false);;
  esac
}
# wrap the git command to either run windows git or linux
function git {
  if isWinDir
  then
    /mnt/c/Program\ Files/Git/bin/git.exe "$@"
  else
    /usr/bin/git "$@"
  fi
}
