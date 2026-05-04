{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
in
{
  # ------------------------------------------------------
  # Allow unfree Spotify
  # ------------------------------------------------------
  nixpkgs.config.allowUnfreePredicate = pkg: lib.hasPrefix "spotify" (lib.getName pkg);

  # ------------------------------------------------------
  # Spicetify configuration
  # ------------------------------------------------------
  programs.spicetify = {
    enable = true;

    # Theme
    theme = spicePkgs.themes.catppuccin;
    colorScheme = "mocha";

    # Extensions
    enabledExtensions = with spicePkgs.extensions; [
      shuffle
      keyboardShortcut
      copyLyrics
    ];

    # Custom apps
    enabledCustomApps = with spicePkgs.apps; [
      marketplace
      lyricsPlus
    ];
  };
}
