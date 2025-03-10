{ config, pkgs, ... }:
let
  hmPath = "${config.home.homeDirectory}/.config/home-manager";
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "khemi";
  home.homeDirectory = "/home/khemi";

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
  home.packages = [
    pkgs.git
    pkgs.tree
    pkgs.gcc
    pkgs.tmux
    pkgs.fzf
    pkgs.bat
    pkgs.ripgrep
    pkgs.starship
    pkgs.neovim
    pkgs.lazygit

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
    ./modules/tmux.nix
  ];

  home.file = {
    ".config/nvim" = {
      enable = true;
      source = config.lib.file.mkOutOfStoreSymlink "${hmPath}/nvim";
    };
  };


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
}
