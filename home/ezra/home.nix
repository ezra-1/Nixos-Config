{ config, lib, pkgs, ... }:

{
  # --------------------------------------------------------
  # Imports — bring in custom modules and host-level logic
  # --------------------------------------------------------
  imports = [
    ../../modules/core/zsh
    ../../modules/programs/terminal/kitty
    ../../modules/programs/media/discord
  ];


  # --------------------------------------------------------
  # 🏠 Home basics
  # --------------------------------------------------------
  home = {
    username = lib.mkDefault "ezra";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    stateVersion = "25.11";
  };

  # --------------------------------------------------------
  # 📦 User packages
  # --------------------------------------------------------
  home.packages = with pkgs; [
    git
    eza
    bat
    neovim
    wget
    fastfetch
    spicetify-cli
    dwt1-shell-color-scripts
    nerd-fonts.jetbrains-mono
  ];

  # --------------------------------------------------------
  # ⚙️ Environment variables
  # --------------------------------------------------------
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    LANG = "en_US.UTF-8";
  };

  # --------------------------------------------------------
  # 🧩 Dotfiles
  # --------------------------------------------------------
  home.file.".config/fastfetch/config.conf".text = ''
    print_info() {
      info "User" "$USER"
      info "Host" "$HOSTNAME"
      info "OS" "$distro"
      info "Kernel" "$kernel"
      info "Uptime" "$uptime"
    }
  '';

  # --------------------------------------------------------
  # 🧰 Programs
  # --------------------------------------------------------
  programs = {
    home-manager.enable = true;

    git = {
      enable = true;

      settings = {
        user = {
          name = "Ezra Lawrence";
          email = "ezralawrence02@gmail.com";
        };

        init.defaultBranch = "main";

        alias = {
          co = "checkout";
          br = "branch";
          ci = "commit";
          st = "status";
          last = "log -1 HEAD";
        };

        pull.rebase = true;
        push.autoSetupRemote = true;
        color.ui = "auto";
      };
    };
  };

  # --------------------------------------------------------
  # 🧹 Notes
  # --------------------------------------------------------
  # Home Manager manages user environment declaratively.
}
