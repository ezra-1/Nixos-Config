{ inputs, host, pkgs, lib, ... }:

{
  # ------------------------------------------------------
  # 🛠️ Development Tools & Neovim Dependencies
  # ------------------------------------------------------
  # Packages required for:
  # - LSPs
  # - Formatters
  # - Treesitter parsers
  # - Compilers/build tools
  # - Telescope/file searching
  home.packages = with pkgs; [
    gcc                     # C compiler (Treesitter/native builds)
    nodejs                  # JS runtime for many LSP servers
    cargo                   # Rust package manager/build tool

    # Nix tooling
    nil                     # Nix language server
    nixfmt-tree             # Nix formatter

    # Search utilities
    ripgrep                 # Fast grep for Telescope/live grep
    fd                      # Faster alternative to find

    # Lua / Neovim tooling
    stylua                  # Lua formatter
    lua-language-server     # Lua LSP

    # Python tooling
    python3                 # Python interpreter
    pyright                 # Python language server
    black                   # Python formatter
    ruff                    # Fast Python linter/formatter
  ];

  # ------------------------------------------------------
  # 🧠 Neovim
  # ------------------------------------------------------
  programs.neovim = {
    enable = true;

    # Enable Python provider support
    withPython3 = true;

    # Disable unused providers
    withRuby = false;
  };

  # ------------------------------------------------------
  # 📂 Neovim Configuration
  # ------------------------------------------------------
  # Symlink Neovim config from flake input
  xdg.configFile."nvim".source = inputs.neovim;

  # ------------------------------------------------------
  # 🖥️ Desktop Launcher
  # ------------------------------------------------------
  xdg.desktopEntries.nvim = {
    name = "Neovim";
    genericName = "Text Editor";
    comment = "Launch Neovim inside Kitty";

    exec = "${lib.getExe pkgs.kitty} --class nvim-wrapper -e nvim %F";

    icon = "nvim";

    mimeType = [
      "text/plain"
      "text/x-makefile"
    ];

    categories = [
      "Utility"
      "Development"
      "TextEditor"
    ];

    terminal = false;
  };
}
