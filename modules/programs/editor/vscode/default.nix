{ lib, pkgs, ... }:

{
  # ========================================================
  # 🧩 Allow Unfree Packages
  # ========================================================
  #
  # VSCode is distributed under a proprietary license,
  # so Nix must explicitly allow it.
  #
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [ "vscode" ];

  # ========================================================
  # 📦 Extra User Packages
  # ========================================================
  #
  # Install VSCode globally for the current Home Manager user.
  #
  home.packages = with pkgs; [
    vscode
  ];

  # ========================================================
  # 💻 VSCode Configuration
  # ========================================================
  programs.vscode = {
    enable = true;

    # Main VSCode package
    package = pkgs.vscode;

    # Allow manual extension installs from the UI.
    # Set to false for fully reproducible Nix-only extensions.
    mutableExtensionsDir = true;

    profiles.default = {

      # ====================================================
      # 🧩 Extensions
      # ====================================================
      #
      # Declarative extension management through Home Manager.
      #
      extensions = with pkgs.vscode-extensions; [

        # ---------------- Nix ----------------
        bbenoist.nix
        arrterian.nix-env-selector
        jnoortheen.nix-ide

        # ---------------- Git ----------------
        eamodio.gitlens
        github.vscode-github-actions

        # -------------- Markdown -------------
        yzhang.markdown-all-in-one

        # ---------------- Theme --------------
        catppuccin.catppuccin-vsc
        catppuccin.catppuccin-vsc-icons
        pkief.material-icon-theme

        # ---------------- Vim ----------------
        vscodevim.vim

        # ---------------- Optional -----------
        # rust-lang.rust-analyzer
        # tamasfe.even-better-toml
        # redhat.vscode-yaml
        # ms-python.python
      ];

      # ====================================================
      # ⌨️ Keybindings
      # ====================================================
      #
      # Custom editor shortcuts.
      #
      keybindings = [

        # Toggle comment on current line
        {
          key = "ctrl+q";
          command = "editor.action.commentLine";
          when = "editorTextFocus && !editorReadonly";
        }

        # Save all open files
        {
          key = "ctrl+s";
          command = "workbench.action.files.saveFiles";
        }
      ];

      # ====================================================
      # ⚙️ User Settings
      # ====================================================
      userSettings = {

        # ==================================================
        # 🛠️ General
        # ==================================================

        # Disable automatic VSCode updates
        "update.mode" = "none";

        # Use custom client-side title bar
        "window.titleBarStyle" = "custom";

        # Toggle menu bar with Alt key
        "window.menuBarVisibility" = "toggle";

        # Skip welcome/start page
        "workbench.startupEditor" = "none";

        # Disable Microsoft telemetry
        "telemetry.enableCrashReporter" = false;
        "telemetry.enableTelemetry" = false;

        # Open untrusted files without prompts
        "security.workspace.trust.untrustedFiles" = "open";

        # ==================================================
        # 🔤 Fonts
        # ==================================================

        # Main editor font size
        "editor.fontSize" = 11;

        # Enable ligatures for supported fonts
        "editor.fontLigatures" = true;

        # Preferred coding font stack
        "editor.fontFamily" =
          "'JetBrainsMono Nerd Font', monospace";

        # ==================================================
        # 🎨 Appearance
        # ==================================================

        # Main color theme
        "workbench.colorTheme" = "Catppuccin Mocha";

        # File/folder icon theme
        "workbench.iconTheme" = "material-icon-theme";

        # Catppuccin accent color
        "catppuccin.accentColor" = "mauve";

        # Disable accidental drag/drop in explorer
        "explorer.confirmDragAndDrop" = false;

        # Hide Open Editors section
        "explorer.openEditors.visible" = 0;

        # Disable minimap
        "editor.minimap.enabled" = false;

        # Hide editor scrollbars
        "editor.scrollbar.vertical" = "hidden";
        "editor.scrollbar.horizontal" = "hidden";

        # Sidebar on the left side
        "workbench.sideBar.location" = "left";

        # Hide layout controls
        "workbench.layoutControl.enabled" = false;

        # ==================================================
        # ✍️ Editor Behavior
        # ==================================================

        # Enable semantic token highlighting
        "editor.semanticHighlighting.enabled" = true;

        # Enable inline suggestions
        "editor.inlineSuggest.enabled" = true;

        # Format file automatically on save
        "editor.formatOnSave" = true;

        # Format pasted content automatically
        "editor.formatOnPaste" = true;

        # Ctrl + mouse wheel changes font size
        "editor.mouseWheelZoom" = true;

        # Enable breadcrumbs navigation
        "breadcrumbs.enabled" = true;

        # Disable sticky scroll header
        "editor.stickyScroll.enabled" = false;

        # Hide control character rendering
        "editor.renderControlCharacters" = false;

        # ==================================================
        # 🪟 Workbench
        # ==================================================

        # Limit open tabs
        "workbench.editor.limit.enabled" = true;
        "workbench.editor.limit.value" = 10;

        # Apply limit per split/editor group
        "workbench.editor.limit.perEditorGroup" = true;

        # ==================================================
        # 🌱 Git
        # ==================================================

        # Auto-stage on commit when possible
        "git.enableSmartCommit" = true;

        # Automatically fetch remote updates
        "git.autofetch" = true;

        # Skip sync confirmation dialog
        "git.confirmSync" = false;

        # Reduce GitLens hover noise
        "gitlens.hovers.annotations.changes" = false;
        "gitlens.hovers.avatars" = false;

        # ==================================================
        # 🧠 Vim Extension
        # ==================================================

        # Use Space as leader key
        "vim.leader" = "<Space>";

        # Allow Vim extension to manage Ctrl bindings
        "vim.useCtrlKeys" = true;

        # Highlight search matches
        "vim.hlsearch" = true;

        # Use system clipboard
        "vim.useSystemClipboard" = true;

        # Override specific Ctrl mappings
        "vim.handleKeys" = {
          "<C-f>" = true;
          "<C-a>" = false;
        };

        # --------------------------------------------------
        # ✍️ Insert Mode
        # --------------------------------------------------

        # Exit insert mode using "kj"
        "vim.insertModeKeyBindings" = [
          {
            "before" = [ "k" "j" ];
            "after" = [ "<Esc>" "l" ];
          }
        ];

        # --------------------------------------------------
        # 🧭 Normal Mode
        # --------------------------------------------------

        "vim.normalModeKeyBindingsNonRecursive" = [

          # ---------------- Buffers ----------------

          # Previous buffer
          {
            "before" = [ "<S-h>" ];
            "commands" = [ ":bprevious" ];
          }

          # Next buffer
          {
            "before" = [ "<S-l>" ];
            "commands" = [ ":bnext" ];
          }

          # ---------------- Splits -----------------

          # Vertical split
          {
            "before" = [ "<leader>" "v" ];
            "commands" = [ ":vsplit" ];
          }

          # Horizontal split
          {
            "before" = [ "<leader>" "s" ];
            "commands" = [ ":split" ];
          }

          # ------------ Window Navigation ----------

          {
            "before" = [ "<C-h>" ];
            "commands" = [ "workbench.action.focusLeftGroup" ];
          }

          {
            "before" = [ "<C-j>" ];
            "commands" = [ "workbench.action.focusBelowGroup" ];
          }

          {
            "before" = [ "<C-k>" ];
            "commands" = [ "workbench.action.focusAboveGroup" ];
          }

          {
            "before" = [ "<C-l>" ];
            "commands" = [ "workbench.action.focusRightGroup" ];
          }

          # ---------------- Essentials -------------

          # Save file
          {
            "before" = [ "<leader>" "w" ];
            "commands" = [ ":w!" ];
          }

          # Quit editor
          {
            "before" = [ "<leader>" "q" ];
            "commands" = [ ":q!" ];
          }

          # Save and quit
          {
            "before" = [ "<leader>" "x" ];
            "commands" = [ ":x!" ];
          }

          # ---------------- Diagnostics ------------

          # Previous diagnostic
          {
            "before" = [ "[" "d" ];
            "commands" = [ "editor.action.marker.prev" ];
          }

          # Next diagnostic
          {
            "before" = [ "]" "d" ];
            "commands" = [ "editor.action.marker.next" ];
          }

          # ---------------- Utilities --------------

          # File picker
          {
            "before" = [ "<leader>" "f" ];
            "commands" = [ "workbench.action.quickOpen" ];
          }

          # Format document
          {
            "before" = [ "<leader>" "p" ];
            "commands" = [ "editor.action.formatDocument" ];
          }

          # Hover preview
          {
            "before" = [ "g" "h" ];
            "commands" = [ "editor.action.showDefinitionPreviewHover" ];
          }

          # Toggle sidebar
          {
            "before" = [ "<C-n>" ];
            "commands" = [ "workbench.action.toggleSidebarVisibility" ];
          }
        ];

        # --------------------------------------------------
        # 👁️ Visual Mode
        # --------------------------------------------------

        "vim.visualModeKeyBindings" = [

          # Outdent selection
          {
            "before" = [ "<" ];
            "commands" = [ "editor.action.outdentLines" ];
          }

          # Indent selection
          {
            "before" = [ ">" ];
            "commands" = [ "editor.action.indentLines" ];
          }

          # Move selected lines down
          {
            "before" = [ "J" ];
            "commands" = [ "editor.action.moveLinesDownAction" ];
          }

          # Move selected lines up
          {
            "before" = [ "K" ];
            "commands" = [ "editor.action.moveLinesUpAction" ];
          }

          # Toggle comment
          {
            "before" = [ "<leader>" "c" ];
            "commands" = [ "editor.action.commentLine" ];
          }
        ];
      };
    };
  };
}
