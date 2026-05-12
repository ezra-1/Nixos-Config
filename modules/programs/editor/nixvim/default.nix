{ pkgs, inputs, ... }:

{
  # ==================================================
  # 📦 Install Nixvim package globally
  # ==================================================
  home.packages = with pkgs; [
    inputs.nixvim.packages.${pkgs.system}.default
  ];

  # ==================================================
  # 🖥️ Desktop entry for Neovim
  # ==================================================
  xdg.desktopEntries.nvim = {
    name = "Neovim";
    genericName = "Text Editor";
    comment = "Edit text files with Neovim";
    icon = "nvim";

    # Open file in Neovim directly
    exec = "nvim %F";

    # File associations
    mimeType = [
      "text/plain"
      "text/x-makefile"
    ];

    # Category shown in app launcher
    categories = [
      "Development"
      "TextEditor"
    ];

    # Runs inside terminal (important for CLI apps like nvim)
    terminal = true;
  };
}
