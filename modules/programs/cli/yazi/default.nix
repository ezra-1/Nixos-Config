{ config, pkgs, lib, ... }:

{
  programs.yazi = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;

    settings = {
      opener = {
        edit = [
          {
            run = "nvim \"$@\"";
            desc = "Edit with Neovim";
            block = true;
          }
        ];
      };

      mgr = {
        show_hidden = true;
        show_symlink = true;
        sort_dir_first = true;
        linemode = "size";
        ratio = [ 1 3 4 ];
      };

      preview = {
        tab_size = 4;
        image_filter = "triangle";
        max_width = 1920;
        max_height = 1080;
        image_quality = 90;
      };
    };

    keymap = {
      mgr.prepend_keymap = [
        { on = [ "e" ]; run = "open"; }
        { on = [ "d" ]; run = "remove --force"; }
      ];
    };

    theme = {
      mgr.border_symbol = " ";
      status = {
        separator_open = "";
        separator_close = "";
      };
    };
  };
}

