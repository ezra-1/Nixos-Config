{ pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    themeFile = "Catppuccin-Mocha";

    settings = {
      # ==============================
      # 🖋 Font & Cursor
      # ==============================
      font_family = "JetBrainsMono NF";
      font_size = "11.0";
      cursor_shape = "block";
      cursor_stop_blinking_after = 0;
      cursor = "#f0f0f0";
      cursor_text_color = "#0d0f18";

      # ==============================
      # 🖱 Selection & Scrolling
      # ==============================
      scrollback_lines = 5000;
      copy_on_select = "yes";
      select_by_word_characters = "@-./_~?&=%+#a";

      # ==============================
      # 🪟 Window & Borders
      # ==============================
      mouse_hide_wait = 0;
      window_border_width = "1pt";
      draw_minimal_borders = "yes";
      window_padding_width = 12;
      inactive_text_alpha = "0.65";
      hide_window_decorations = "yes";
      confirm_os_window_close = 0;
      tab_bar_style = "powerline";
      background_opacity = "0.85";
    };
  };
}
