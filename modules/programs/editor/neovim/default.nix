{ inputs, host, pkgs, lib, ... }:

{
  # ------------------------------------------------------
  # 🧩 System Packages — Dependencies for Neovim
  # ------------------------------------------------------
  home.packages = with pkgs; [
    gcc
    nodejs
    nil
    nixfmt-tree
    ripgrep

    # Optional but very useful
    fd                # Faster file searching
    stylua            # Lua formatter
    lua-language-server
  ];

  # ------------------------------------------------------
  # 🧠 Neovim Setup
  # ------------------------------------------------------
  programs.neovim = {
    enable = true;

    # ✅ Silence warnings + use modern defaults
    withPython3 = false;
    withRuby = false;
  };

  # Link Neovim configuration from your flake input
  xdg.configFile."nvim".source = inputs.neovim;

  # ------------------------------------------------------
  # 🖥️ Desktop Entry
  # ------------------------------------------------------
  xdg.desktopEntries.nvim = {
    name = "Neovim wrapper";
    genericName = "Text Editor";
    comment = "Edit text files";

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
