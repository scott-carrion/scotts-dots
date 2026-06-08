# home.nix
# https://nix-community.github.io/home-manager/options.xhtml

{ config, pkgs, lib, ... }:

let
  # Import of local packages
  qman = pkgs.callPackage ./qman.nix { };
  powerline-gitstatus = pkgs.callPackage ./powerline-gitstatus.nix {
    python3Packages = pkgs.python3Packages;
  };
in
{
  # Nix overlays for choosing specific revisions of packages not in default nixpkgs
  nixpkgs.overlays = [
    (final: prev: {
      tmuxPlugins = prev.tmuxPlugins // {
        tmux-powerline = prev.tmuxPlugins.tmux-powerline.overrideAttrs (oldAttrs: {
          version = "3.2.0";
          src = prev.fetchFromGitHub {
            owner = "erikw";
            repo = "tmux-powerline";
            rev = "6079ace8d534a01d4d964b8b854b223f72edaf4b";
            hash = "sha256-GZVMxp+2y+BuxUKM8hP8OxVZlzYInlKC8D8Pwch1Ojg=";
          };
        });
      };

      powerline = prev.powerline.overrideAttrs (oldAttrs: {
        propagatedBuildInputs = (oldAttrs.propagatedBuildInputs or [ ]) ++ [powerline-gitstatus];
      });
    })
  ];

  imports = [
    # This pulls in requisite packages, e.g. git, emacs, and emacs package vterm
    ./spacemacs.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "skeet";
  home.homeDirectory = "/home/skeet";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "26.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # Local packages
    qman
    powerline-gitstatus

    # Upstream packages (nixpkgs)
    pkgs.vim
    pkgs.tmux
    pkgs.powerline
    pkgs.btop
    pkgs.ranger
    pkgs.polybar
    pkgs.i3
    pkgs.i3lock-fancy
    pkgs.glibcLocales
    pkgs.python314Packages.cogapp
    pkgs.ncurses
    pkgs.rofi
    pkgs.feh
    pkgs.flameshot
    pkgs.powerline-fonts
    pkgs.powerline-symbols
    pkgs.pywal16
    pkgs.delta
    pkgs.xbindkeys
    pkgs.xsel
    #pkgs.silver-searcher
    pkgs.ripgrep-all

    # Override st config to use config.h from home
    (pkgs.st.overrideAttrs (oldAttrs: {
       postPatch = "${oldAttrs.postPatch}\n cp ${config.home.file.".config".source}/st/config.h config.def.h";
     }))

    # pipx with UT disabled, it's broken in nixpkgs 26.05
    (pkgs.pipx.overridePythonAttrs (old: { doCheck = false; }))

    pkgs.tmuxPlugins.tmux-powerline
    pkgs.tmuxPlugins.sensible
    pkgs.tmuxPlugins.resurrect

    # Software build packages.
    # Some are disabled by default to avoid collisions with host OS packages
    pkgs.gnumake
    pkgs.meson
    pkgs.ninja
    pkgs.cmake
    #pkgs.gcc

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    ".bashrc".source = ~/scotts-dots/debian_dotfiles/.bashrc;
    ".vimrc".source = ~/scotts-dots/debian_dotfiles/.vimrc;
    ".tmux.conf".source = ~/scotts-dots/debian_dotfiles/.tmux.conf;
    ".config" = {
        source = ~/scotts-dots/debian_dotfiles/.config;
        recursive = true;
        force = true;
    };

    ".fonts" = {
        source = ~/scotts-dots/fonts;
        recursive = true;
        force = true;
    };

    ".gitconfig".source = ~/scotts-dots/debian_dotfiles/.gitconfig;

    "githooks" = {
        source = ~/scotts-dots/githooks/hooks;
        recursive = true;
        force = true;
        executable = true;
    };

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/skeet/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # Installed bashrc uses this as path to source powerline bash binding
    POWERLINE_BASH_BINDING_PATH = "/home/$USER/.nix-profile/share/bash/powerline.sh";
    LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
    LANG = "en_US.UTF-8";
  };

  programs.spacemacs = {
    enable = true;
    revision = "529c7fc3a33682770ac1ef2941eb33df012733eb";
    dotfile = ~/scotts-dots/debian_dotfiles/.spacemacs;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
