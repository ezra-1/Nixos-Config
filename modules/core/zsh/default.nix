{
  config,
  pkgs,
  lib,
  ...
}:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;

    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 100000;
      path = "${config.xdg.dataHome}/zsh/history";
      share = true;
    };

    dotDir = "${config.xdg.configHome}/zsh";

    shellAliases = {
      grub-update = "sudo grub-mkconfig -o /boot/grub/grub.cfg";
      music = "ncmpcpp";
      cat = "bat --theme=base16";
      ls = "eza --icons=always --color=always -a";
      ll = "eza --icons=always --color=always -la";
    };

    sessionVariables = {
      EDITOR = "geany";
      VISUAL = "geany";
      BROWSER = "firefox";
      BAT_THEME = "base16";
      SUDO_PROMPT = "Deploying root access for %u. Password pls: ";
      HISTORY_IGNORE = "(ls|cd|pwd|exit|sudo reboot|history|cd -|cd ..)";
      PATH = "$HOME/.local/bin:$PATH";
    };

    initContent = ''
      # ───────────────────────────────────────────────
      # Exit if not interactive
      [[ $- != *i* ]] && return

      # ───────────────────────────────────────────────
      # Completion system
      autoload -Uz compinit
      local zcompdump="$HOME/.config/zsh/zcompdump"

      if [[ -n "$zcompdump"(#qN.mh+24) ]]; then
        compinit -i -d "$zcompdump"
      else
        compinit -C -d "$zcompdump"
      fi

      if [[ ! -f "$zcompdump.zwc" || "$zcompdump" -nt "$zcompdump.zwc" ]]; then
        zcompile -U -R "$zcompdump" 2>/dev/null
      fi

      autoload -Uz add-zsh-hook vcs_info
      precmd() { vcs_info }
      _comp_options+=(globdots)

      # ───────────────────────────────────────────────
      # Completion styles
      zstyle ':completion:*' menu select
      zstyle ':completion:*:descriptions' format '[%d]'
      zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
      zstyle ':completion:*' matcher-list \
        'm:{a-zA-Z}={A-Za-z}' \
        '+r:|[._-]=* r:|=*' \
        '+l:|=*'

      zstyle ':vcs_info:*' formats ' %B%s-[%F{magenta}%f %F{yellow}%b%f]-'

      # ───────────────────────────────────────────────
      # fzf-tab configuration
      zstyle ':fzf-tab:*' fzf-flags \
        --style=full --height=90% --pointer '>' \
        --color 'pointer:green:bold,bg+:-1:,fg+:green:bold,info:blue:bold,marker:yellow:bold,hl:gray:bold,hl+:yellow:bold' \
        --input-label ' Search ' --color 'input-border:blue,input-label:blue:bold' \
        --list-label ' Results ' --color 'list-border:green,list-label:green:bold' \
        --preview-label ' Preview ' --color 'preview-border:magenta,preview-label:magenta:bold'

      zstyle ':fzf-tab:*' fzf-bindings 'space:accept'
      zstyle ':fzf-tab:*' accept-line enter
      zstyle ':fzf-tab:*' use-cache yes

      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --icons=always --color=always -a "$realpath"'
      zstyle ':fzf-tab:complete:eza:*' fzf-preview 'eza -1 --icons=always --color=always -a "$realpath"'
      zstyle ':fzf-tab:complete:bat:*' fzf-preview 'bat --color=always --theme=base16 "$realpath"'

      # ───────────────────────────────────────────────
      # Tab completion visual cue
      expand-or-complete-with-dots() {
        echo -n "\e[31m…\e[0m"
        zle expand-or-complete
        zle redisplay
      }
      zle -N expand-or-complete-with-dots
      bindkey "^I" expand-or-complete-with-dots

      # ───────────────────────────────────────────────
      # History configuration
      setopt appendhistory sharehistory \
              hist_ignore_space hist_ignore_all_dups \
              hist_save_no_dups hist_ignore_dups hist_find_no_dups

      # ───────────────────────────────────────────────
      # Shell behavior
      setopt AUTOCD PROMPT_SUBST MENU_COMPLETE LIST_PACKED AUTO_LIST COMPLETE_IN_WORD
      setopt PROMPT_CR PROMPT_SP

      # ───────────────────────────────────────────────
      # Prompt
      dir_icon() {
        [[ "$PWD" == "$HOME" ]] && echo "%B%F{cyan}%f%b" || echo "%B%F{cyan}%f%b"
      }

      PS1='%B%F{blue}%f%b  %B%F{magenta}%n%f%b $(dir_icon)  %B%F{red}%~%f%b''${vcs_info_msg_0_} %(?.%B%F{green}.%F{red})%f%b '

      # ───────────────────────────────────────────────
      # Plugins
      if [[ -f "$HOME/zsh/plugins/fzf-tab-git/fzf-tab.zsh" ]]; then
        source "$HOME/zsh/plugins/fzf-tab-git/fzf-tab.zsh"
      fi

      # ───────────────────────────────────────────────
      # Key bindings
      if (( $+functions[history-substring-search-up] )); then
        bindkey '^[[A' history-substring-search-up
        bindkey '^[[B' history-substring-search-down
      fi
      bindkey '^[[3~' delete-char
      bindkey "^[[H" beginning-of-line
      bindkey "^[[F" end-of-line

      # ───────────────────────────────────────────────
      # Dynamic terminal titles
      xterm_title_precmd() {
        print -Pn -- '\e]2;%n@%m %~\a'
        [[ "$TERM" == 'screen'* ]] && print -Pn -- '\e_\005{g}%n\005{-}@\005{m}%m\005{-} \005{B}%~\005{-}\e\\'
      }
      xterm_title_preexec() {
        print -Pn -- '\e]2;%n@%m %~ %# ' && print -n -- "''${(q)1}\a"
        [[ "$TERM" == 'screen'* ]] && {
          print -Pn -- '\e_\005{g}%n\005{-}@\005{m}%m\005{-} \005{B}%~\005{-} %# ' && print -n -- "''${(q)1}\e\\"
        }
      }

      if [[ "$TERM" == (kitty*|alacritty*|tmux*|screen*|xterm*) ]]; then
        add-zsh-hook -Uz precmd xterm_title_precmd
        add-zsh-hook -Uz preexec xterm_title_preexec
      fi

      # ───────────────────────────────────────────────
      # Direnv Hook
      if command -v direnv &>/dev/null; then
        eval "$(direnv hook zsh)"
      fi

      # ───────────────────────────────────────────────
      # Visual startup
      if command -v colorscript &>/dev/null; then
        colorscript -r
      fi
    '';
  };
}
