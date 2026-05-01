{
  config,
  pkgs,
  nixgl,
  ...
}:
let
  hmPath = "${config.home.homeDirectory}/.config/home-manager";
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "khemi";
  home.homeDirectory = "/home/khemi";
  nixpkgs.config.allowUnfree = true;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  fonts.fontconfig.enable = true;
  home.packages = [
    pkgs.git
    pkgs.tree
    pkgs.gcc13
    pkgs.tmux
    pkgs.fzf
    pkgs.bat
    pkgs.ripgrep
    pkgs.starship
    pkgs.neovim
    pkgs.lazygit
    pkgs.btop
    pkgs.zellij
    pkgs.gnumake
    pkgs.libgcc

    pkgs.wl-clipboard
    # pkgs.firefox
    pkgs.gnomeExtensions.tactile
    pkgs.gnomeExtensions.space-bar
    pkgs.gnomeExtensions.switcher
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.noto-fonts
    pkgs.noto-fonts-color-emoji
    pkgs.auto-cpufreq
    # pkgs.obsidian

    # language-server and formatter
    pkgs.lua-language-server
    pkgs.pyright
    pkgs.black
    pkgs.nil
    pkgs.nixpkgs-fmt
    pkgs.ccls
    pkgs.postgres-lsp
    pkgs.pgformatter
    pkgs.asm-lsp
    pkgs.asmfmt

  ];

  imports = [
    ./modules/bash.nix
    ./modules/starship.nix
    ./modules/fzf.nix
    ./modules/zoxide.nix
    ./modules/lazygit.nix
    ./modules/git.nix
    ./modules/dconf.nix
    ./modules/zellij.nix
    ./modules/obsidian.nix
    ./modules/switcher.nix
    # ./modules/nixgl.nix
    # ./modules/manoonchai.nix

  ];
  nixGL = {
    # 1. Tell home-manager to use the nixGL packages
    packages = nixgl.packages;

    # 2. Tell nixGL to use the 'mesa' wrapper (correct for your Intel GPU)
    defaultWrapper = "mesa";
  };
  # ----------------------------------

  # --- ADD THIS SECTION FOR FIREFOX ---
  programs.firefox = {
    enable = true;

    # 3. This is the fix:
    # We wrap the Firefox package with the nixGL library
    package = config.lib.nixGL.wrap pkgs.firefox;
  };

  home.file = {
    ".config/nvim" = {
      enable = true;
      source = config.lib.file.mkOutOfStoreSymlink "${hmPath}/nvim";
    };
  };

  # systemd.user.services.gnome-settings-delay = {
  #   Unit = {
  #     Description = "Apply GNOME settings after delay";
  #     After = [ "graphical-session.target" ];
  #   };
  #   Service = {
  #     Type = "oneshot";
  #     ExecStartPre = "/run/current-system/sw/bin/sleep 5";
  #     ExecStart = "/run/current-system/sw/bin/home-manager switch";
  #   };
  #   Install.WantedBy = [ "default.target" ];
  # };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # programs.manoonchai = {
  #   enable = true;
  #   switchKey = "grp:win_space_toggle"; # Win+Space to switch layouts
  #   # autoInstall = true;  # Optional: auto-install on first run
  # };

}
