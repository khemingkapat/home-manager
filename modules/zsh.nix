{
  config,
  pkgs,
  lib,
  ...
}:
{
  # ── Extra packages pulled in by this module ──────────────────────────────────
  home.packages = [
    pkgs.eza
    pkgs.fd
    pkgs.zsh
  ];

  # ── ZSH via Home Manager ─────────────────────────────────────────────────────
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh"; # keeps ~ clean; zsh reads from $ZDOTDIR

    # ── History ────────────────────────────────────────────────────────────────
    history = {
      path = "${config.home.homeDirectory}/.local/state/zsh/history";
      size = 100000;
      save = 100000;
      ignoreAllDups = true;
      ignoreSpace = true;
      expireDuplicatesFirst = true;
      share = true;
    };

    # ── Shell options ──────────────────────────────────────────────────────────
    autocd = true;

    # ── Completion ────────────────────────────────────────────────────────────
    enableCompletion = true;

    # ── Plugins (sourced directly from Nix store — no runtime git cloning) ────
    plugins = [
      {
        name = "zsh-autosuggestions";
        src = pkgs.zsh-autosuggestions;
        file = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
      }
      {
        # must come before zsh-vi-mode (which resets bindings) so that
        # the widget exists when we re-bind arrows inside zvm_after_init
        name = "zsh-history-substring-search";
        src = pkgs.zsh-history-substring-search;
        file = "share/zsh-history-substring-search/zsh-history-substring-search.zsh";
      }
      {
        # zsh-vi-mode resets all ZLE bindings on init; custom bindings
        # must be set inside the zvm_after_init hook (see initExtra below)
        name = "zsh-vi-mode";
        src = pkgs.zsh-vi-mode;
        file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
      }
      {
        # load last — FSH wraps ZLE widgets and must see all other widgets first
        name = "fast-syntax-highlighting";
        src = pkgs.zsh-fast-syntax-highlighting;
        file = "share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh";
      }
    ];

    # ── Aliases ───────────────────────────────────────────────────────────────
    shellAliases = {
      # navigation
      "-" = "cd -";
      ".." = "cd ..";

      # eza-based ls
      ls = "eza --icons";
      ll = "eza -lh --icons --git";
      la = "eza -lah --icons --git";
      tree = "eza --tree --icons";

      # better defaults
      cat = "bat";
      grep = "rg --color=auto";
      diff = "diff --color=auto";
      df = "df -h";
      vim = "nvim";

      # git
      glog = ''PAGER="less -F -X" git log'';
      gadog = ''PAGER="less -F -X" git log --all --decorate --oneline --graph'';

      # home-manager shorthand (kept from your bash config)
      hm = "home-manager";
      zdev = "zellij --layout ./dev.kdl";
    };

    # ── initExtra: runs at the end of the generated .zshrc ───────────────────
    initExtra = ''
      # ── Completion behaviour ─────────────────────────────────────────────────
      zstyle ':completion:*' menu select
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

      # ── fzf ─────────────────────────────────────────────────────────────────
      export FZF_DEFAULT_COMMAND='fd --type f --hidden --strip-cwd-prefix'
      export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
      export FZF_DEFAULT_OPTS='
        --height=60%
        --layout=reverse
        --border=rounded
        --prompt="  "
        --pointer="  "
        --preview-window=right:65%:wrap:border-left
      '
      export _FZF_PREVIEW_CMD='bat --color=always --style=plain,numbers --line-range=:500 {}'
      export FZF_CTRL_T_OPTS="--preview '$_FZF_PREVIEW_CMD'"

      # Ctrl+F widget: fuzzy file picker, hidden files excluded
      _fzf_file_no_hidden() {
        local cmd result
        cmd="''${FZF_DEFAULT_COMMAND/--hidden /}"
        result=$(eval "''${cmd:-find . -type f}" | fzf --preview "$_FZF_PREVIEW_CMD") \
          && LBUFFER+="$result"
        zle reset-prompt
      }
      zle -N _fzf_file_no_hidden

      # ── vi-mode config ───────────────────────────────────────────────────────
      # zvm_config() is called by zsh-vi-mode before its own setup, so cursor
      # shape vars set here are respected from the first keystroke.
      zvm_config() {
        ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BEAM
        ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_BLOCK
        ZVM_VISUAL_MODE_CURSOR=$ZVM_CURSOR_BLOCK
        ZVM_VI_HIGHLIGHT_BACKGROUND=none
        ZVM_VI_HIGHLIGHT_FOREGROUND=none
        ZVM_VI_HIGHLIGHT_EXTRASTYLE=none
      }

      # zsh-vi-mode resets all ZLE bindings after loading; zvm_after_init is the
      # correct hook to re-apply custom bindings so they survive.
      zvm_after_init() {
        bindkey '^[[1;5C' forward-word               # Ctrl+Right — forward word
        bindkey '^[[1;5D' backward-word              # Ctrl+Left  — backward word
        bindkey '^F'      _fzf_file_no_hidden        # Ctrl+F     — fzf (no hidden)
        bindkey '^\' autosuggest-toggle              # Ctrl+\     — toggle suggestions
        bindkey '^[[A' history-substring-search-up   # Up arrow   — history search
        bindkey '^[[B' history-substring-search-down # Down arrow — history search
      }

      # ── Default-shell reminder ───────────────────────────────────────────────
      # Printed once per session when the login shell is not zsh.
      if [[ "$SHELL" != */zsh ]]; then
        print -P "%F{yellow}⚠  Your default shell is not zsh.%f"
        print -P "%F{cyan}   To fix it, run: %F{white}chsh -s \$(which zsh)%f"
        print -P "%F{cyan}   Then log out and back in for the change to take effect.%f"
      fi
    '';

    # ── Session variables ─────────────────────────────────────────────────────
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      GPG_TTY = "$(tty)";

      # Prevent virtualenv from adding its own prompt segment (starship handles it)
      VIRTUAL_ENV_DISABLE_PROMPT = "1";
    };
  };

  # ── Cross-program integrations ────────────────────────────────────────────────
  # starship — your config stays in modules/starship.nix; this just wires it to zsh
  programs.starship.enableZshIntegration = true;

  # zoxide — your modules/zoxide.nix has bash; this adds zsh on top
  programs.zoxide.enableZshIntegration = true;

  # fzf — your modules/fzf.nix enables it; this adds the zsh key-binding glue
  programs.fzf.enableZshIntegration = true;

  # ── Ensure required directories exist before zsh first launches ───────────────
  home.activation.zshDirs = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p "${config.home.homeDirectory}/.local/state/zsh"
    mkdir -p "${config.home.homeDirectory}/.cache/zsh"
  '';
}
