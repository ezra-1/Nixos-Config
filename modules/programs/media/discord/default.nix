{ pkgs, ... }:

{
  # --------------------------------------------------------
  # 🧩 Packages
  # --------------------------------------------------------
  home.packages = [
    (pkgs.discord.override {
      withVencord = true;
      withOpenASAR = true; # Faster startup
    })
  ];

  # --------------------------------------------------------
  # 🎨 Vencord Theme: Catppuccin Mocha
  # --------------------------------------------------------
  xdg.configFile."Vencord/themes/catppuccin-mocha.css".text = ''
    /**
     * @name Catppuccin Mocha
     * @author winston
     * @description 🎮 Soothing pastel theme for Discord
     * @link https://github.com/catppuccin/discord
     */
    @import url("https://catppuccin.github.io/discord/dist/catppuccin-mocha-mauve.theme.css");
  '';

  # --------------------------------------------------------
  # ⚙️ Vencord Settings
  # --------------------------------------------------------
  xdg.configFile."Vencord/settings/settings.json".text = builtins.toJSON {
    notifyAboutUpdates = true;
    autoUpdate = false;
    autoUpdateNotification = false;
    useQuickCss = true;

    themeLinks = [ ];
    enabledThemes = [ "catppuccin-mocha.css" ];

    frameless = false;
    transparent = false;
    winNativeTitleBar = false;

    notifications = {
      timeout = 5000;
      position = "bottom-right";
      useNative = "not-focused";
      logLimit = 50;
    };

    cloud = {
      authenticated = false;
      url = "https://api.vencord.dev/";
      settingsSync = false;
      settingsSyncVersion = 1737589382741;
    };

    # --------------------------------------------------------
    # 🧩 Vencord Plugins Configuration
    # --------------------------------------------------------
    plugins = {
      # Core APIs
      CommandsAPI.enabled = true;
      MessageAccessoriesAPI.enabled = true;
      UserSettingsAPI.enabled = true;

      # Useful UX Improvements
      ClearURLs.enabled = true;
      CopyFileContents.enabled = true;
      EmoteCloner.enabled = true;
      Experiments.enabled = true;
      FakeNitro.enabled = true;
      NSFWGateBypass.enabled = true;
      ReplaceGoogleSearch = {
        enabled = true;
        customEngineName = "Startpage";
        customEngineURL = "https://www.startpage.com/sp/search?query=";
      };
      ReverseImageSearch.enabled = true;
      ShowHiddenThings.enabled = true;
      SilentTyping = {
        enabled = true;
        showIcon = true;
        contextMenu = true;
        isEnabled = false;
      };
      SpotifyCrack.enabled = true;
      YoutubeAdblock.enabled = true;
      NoTrack = {
        enabled = true;
        disableAnalytics = true;
      };

      # Logger example
      MessageLogger = {
        enabled = true;
        logDeletes = true;
        collapseDeleted = false;
        logEdits = false;
        inlineEdits = false;
        ignoreBots = true;
        ignoreSelf = true;
      };

      # UI tweaks
      Settings = {
        enabled = true;
        settingsLocation = "aboveNitro";
      };
      SupportHelper.enabled = true;
    };
  };
}
