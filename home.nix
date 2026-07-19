{ config
, pkgs
, lib
, nixgl
, isDesktop
, ...
}:
let
  hmPath = "${config.home.homeDirectory}/.config/home-manager";
in
{
  home.username = "khemi";
  home.homeDirectory = "/home/khemi";
  nixpkgs.config.allowUnfree = true;
  home.stateVersion = "26.05";

  fonts.fontconfig.enable = true;

  home.packages = [
    # ── cli tools (always) ───────────────────────────────────────────
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
    pkgs.fastfetch
    pkgs.gh
    pkgs.jless

    # ── LSPs & formatters (always) ───────────────────────────────────
    pkgs.lua-language-server
    pkgs.nil
    pkgs.nixpkgs-fmt

  ]
  ++ lib.optionals isDesktop [
    # ── desktop only ─────────────────────────────────────────────────
    pkgs.wl-clipboard
    pkgs.gnomeExtensions.tactile
    pkgs.gnomeExtensions.space-bar
    pkgs.gnomeExtensions.switcher
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.noto-fonts
    pkgs.noto-fonts-color-emoji
    pkgs.auto-cpufreq
  ];

  imports = [
    # ── always ───────────────────────────────────────────────────────
    ./modules/bash.nix
    ./modules/starship.nix
    ./modules/fzf.nix
    ./modules/zoxide.nix
    ./modules/lazygit.nix
    ./modules/git.nix
    ./modules/zellij.nix
    ./modules/zsh.nix
  ]
  ++ lib.optionals isDesktop [
    # ── desktop only ─────────────────────────────────────────────────
    ./modules/dconf.nix
    ./modules/switcher.nix
    ./modules/obsidian.nix
  ];

  targets.genericLinux.nixGL = lib.mkIf isDesktop {
    packages = nixgl.packages;
    defaultWrapper = "mesa";
  };

  programs.firefox = lib.mkIf isDesktop {
    enable = true;
    package = config.lib.nixGL.wrap pkgs.firefox;
  };

  home.file = {
    ".config/nvim" = {
      enable = true;
      source = config.lib.file.mkOutOfStoreSymlink "${hmPath}/nvim";
    };
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.home-manager.enable = true;
}
