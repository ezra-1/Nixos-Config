{ inputs, ... }:
{
  # --------------------------------------------------------
  # 🧩 additions — bring in custom packages from ../pkgs
  # --------------------------------------------------------
  additions = final: _prev:
    import ../pkgs { pkgs = final; };

  # --------------------------------------------------------
  # 🔧 modifications — customize or patch existing packages
  # --------------------------------------------------------
  modifications = final: prev: {
    # 🖥️ Vesktop: disable system Vencord and enable middle-click scroll
    vesktop = prev.vesktop.override {
      withSystemVencord = false;
      withMiddleClickScroll = true;
    };

    # 💬 Discord: enable Vencord, OpenASAR, and autoscroll
    discord = prev.discord.override {
      withVencord = true;
      withOpenASAR = true;
      enableAutoscroll = true;
    };
  };

  # --------------------------------------------------------
  # 🧱 stable-packages — import stable nixpkgs channel
  # --------------------------------------------------------
  stable-packages = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
