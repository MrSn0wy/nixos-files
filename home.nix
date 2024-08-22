{ pkgs, lib,  pkgs-stable, pkgs-unstable, spicetify-flake, ... }:

let
  spicePkgs = spicetify-flake.packages.${pkgs-unstable.system}.default;

in {
  imports = [ spicetify-flake.homeManagerModule ];

  # nix-flatpak setup
  services.flatpak.enable = true;

  services.flatpak.remotes = lib.mkOptionDefault [
    {
      name = "flathub";
      location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
    }
    {
      name = "flathub-beta";
      location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
    }
    # {
    #   name = "sober-vinegarhq";
    #   location = " https://sober.vinegarhq.org/sober.flatpakref";
    # }
  ];

  services.flatpak.update.auto.enable = true;
  # services.flatpak.uninstallUnmanaged = true;
  services.flatpak.packages = [
    { appId = "im.riot.Riot"; origin = "flathub"; }
    { appId = "com.system76.Popsicle"; origin = "flathub"; }
    { appId = "io.github.shiftey.Desktop"; origin = "flathub"; }
    { appId = "md.obsidian.Obsidian"; origin = "flathub"; }
    { appId = "net.blockbench.Blockbench"; origin = "flathub"; }
    { appId = "org.telegram.desktop"; origin = "flathub"; }
    { appId = "com.usebottles.bottles"; origin = "flathub"; }
    # { appId = "org.vinegarhq.Sober"; origin = "sober-vinegarhq"; }
  ];


  # configure spicetify :)
  programs.spicetify =
    {
      enable = true;
      spotifyPackage = pkgs-stable.spotify;
      theme = spicePkgs.themes.catppuccin;
      colorScheme = "mocha";

      enabledExtensions = with spicePkgs.extensions; [
        fullAppDisplay
        skipStats
        showQueueDuration
        genre
        adblock
        oneko
        star-ratings
      ];

      enabledCustomApps = with spicePkgs.apps; [
        marketplace
        lyrics-plus
      ];
    };

    # styling here  0.o
    # mocha my bloved <3

    home = {

      pointerCursor = {
        name = "phinger-cursors-light";
        package = pkgs.phinger-cursors;
        size = 24;
        gtk.enable = true;
        x11.enable = true;

        # name = "Simp1e-Nord-Dark";
        # package = pkgs.simp1e-cursors;
        # size = 24;
        # gtk.enable = true;
        # x11.enable = true;
      };



      packages = with pkgs-stable; [

        ## programming
        python3 # i need me calculator
        pkgs-unstable.jetbrains.rust-rover
        pkgs-unstable.jetbrains.webstorm
        pkgs-unstable.jetbrains.idea-ultimate
        pkgs-unstable.jetbrains.rider
        pkgs-unstable.jetbrains.phpstorm
        pkgs-unstable.ollama-cuda
        # pkgs-unstable.kdePackages.alpaka
        # pkgs-unstable.alpaca
        pkgs-unstable.zed-editor
        # pkgs-unstable.devenv
        pkgs-unstable.postman
        gnirehtet
        scrcpy
        ungoogled-chromium # pretty handy to have a basic chromium browser
        # godot_4
        unityhub
        # gparted
        # android-tools

        ## gaming
        qbittorrent
        protonup-qt
        protontricks
        pkgs-unstable.prismlauncher
        #pkgs-unstable.rustdesk
        lutris
        heroic

        ## General
        pkgs-unstable.obs-studio
        pkgs-unstable.davinci-resolve
        pkgs-unstable.vesktop
        pkgs-unstable.youtube-music
        furmark
        signal-desktop
        speedtest-cli
        krita
        # pkgs-unstable.brave
      ];
    };




    # xdg.desktopEntries.firefox-dev-edition-x11 = {
    #   name = "Firefox DevEdition X11";
    #   exec = "MOZ_ENABLE_WAYLAND=0 firefox-developer-edition";
    #   terminal = false;
    #   type = "Application";
    #   categories = [ "Network" "WebBrowser" ];
    #   mimeType = [ "text/html" "text/xml" "application/xhtml+xml" "application/vnd.mozilla.xul+xml" "x-scheme-handler/http" "x-scheme-handler/https" ];
    #   icon = "firefox-developer-edition";
    # };

    xdg = {
        enable = true;

        # /etc/profiles/per-user/snowy/share/applications/
        desktopEntries = {
            vesktop = {
                name = "Vesktop";
                genericName = "Discord but better :3";
                categories = ["Network" "InstantMessaging" "Chat"];
                mimeType = [];
                type = "Application";
                terminal = false;
                icon = "vesktop";
                exec = "vesktop --ozone-platform=wayland %U";
                settings = {
                    Keywords = "discord;vencord;electron;chat;vesktop";
                    StartupWMClass = "Vesktop";
                };
            };

            codium = {
                name = "VSCodium";
                genericName = "A shitty text editor everyone hates <3";
                categories = [ "Utility" "TextEditor" "Development" "IDE" ];
                mimeType = [ "text/plain" "inode/directory" ];
                type = "Application";
                terminal = false;
                icon = "vscodium";
                exec = "codium --ozone-platform=wayland %F";
                settings = {
                    Keywords = "vscode";
                    StartupWMClass = "vscodium";
                };
            };

            signal-desktop = {
                name = "Signal";
                genericName = "Based";
                categories = [ "Network" "InstantMessaging" "Chat" ];
                mimeType = [ "x-scheme-handler/sgnl" "x-scheme-handler/signalcaptcha" ];
                type = "Application";
                terminal = false;
                icon = "signal-desktop";
                exec = "signal-desktop --ozone-platform=wayland --no-sandbox %U";
                settings = {
                    Keywords = "signal";
                    StartupWMClass = "signal";
                };
            };

            spotify = {
                name = "Spotify";
                genericName = "Silly music player";
                categories = [ "Audio" "Music" "Player" "AudioVideo" ];
                mimeType = [ "x-scheme-handler/spotify" ];
                type = "Application";
                terminal = false;
                icon = "spotify-client";
                exec = "spotify --ozone-platform=wayland %U";
                settings = {
                    Keywords = "spotify";
                    StartupWMClass = "spotify";
                };
            };

            chromium-browser = {
                name = "Chromium";
                genericName = "html editor";
                categories = [ "Network" "WebBrowser" ];
                mimeType = [ ];
                type = "Application";
                terminal = false;
                icon = "chromium";
                exec = "chromium %U";
                settings = {
                    Keywords = "Chromium";
                    StartupWMClass = "chromium-browser";
                };
            };

            # element-desktop = {
            #     categories = ["Network" "InstantMessaging" "Chat"];
            #     exec = "element-desktop --ozone-platform=wayland %u";
            #     genericName = "Internet Messenger but silly";
            #     icon = "element";
            #     name = "Element Wayland";
            #     type = "Application";
            #     settings = {
            #         MimeType = "x-scheme-handler/element";
            #         StartupWMClass = "Element";
            #     };
            # };
        };

      mimeApps = {
        enable = true;
        associations.added = {
            "text/html" = ["firefox-developer-edition.desktop"];
            "x-scheme-handler/chrome" = ["firefox-developer-edition.desktop"];
            "x-scheme-handler/ftp" = ["firefox-developer-edition.desktop"];
            "x-scheme-handler/http" = ["firefox-developer-edition.desktop"];
            "x-scheme-handler/https" = ["firefox-developer-edition.desktop"];
            "x-www-browser" = ["firefox-developer-edition.desktop"];
            "inode/directory" = ["org.kde.dolphin.desktop"];
            "application/zip" = ["org.kde.ark.desktop"];
            "text/plain" = ["codium.desktop"];
            "application/octet-stream" = ["codium.desktop"];

            "image/png" = ["firefox-developer-edition.desktop"];
            "image/jpeg" = ["firefox-developer-edition.desktop"];
            "image/avif" = ["firefox-developer-edition.desktop"];
            "image/svg" = ["firefox-developer-edition.desktop"];
            "image/webp" = ["firefox-developer-edition.desktop"];

            # "video/*" = ["firefox-developer-edition.desktop"];
            # "audio/*" = ["firefox-developer-edition.desktop"];
        };
        defaultApplications = {
            "text/html" = ["firefox-developer-edition.desktop"];
            "x-scheme-handler/chrome" = ["firefox-developer-edition.desktop"];
            "x-scheme-handler/ftp" = ["firefox-developer-edition.desktop"];
            "x-scheme-handler/http" = ["firefox-developer-edition.desktop"];
            "x-scheme-handler/https" = ["firefox-developer-edition.desktop"];
            "x-www-browser" = ["firefox-developer-edition.desktop"];
            "inode/directory" = ["org.kde.dolphin.desktop"];
            "application/zip" = ["org.kde.ark.desktop"];
            "text/plain" = ["codium.desktop"];
            "application/octet-stream" = ["codium.desktop"];

            "image/png" = ["firefox-developer-edition.desktop"];
            "image/jpeg" = ["firefox-developer-edition.desktop"];
            "image/avif" = ["firefox-developer-edition.desktop"];
            "image/svg" = ["firefox-developer-edition.desktop"];
            "image/webp" = ["firefox-developer-edition.desktop"];

            # "video/*" = ["firefox-developer-edition.desktop"];
            # "audio/*" = ["firefox-developer-edition.desktop"];
        };
      };

      # config files boyo
      configFile = {
        "hypr/hyprland.conf".source = configs/hyprland.conf;
        "hypr/hyprpaper.conf".source = configs/hyprpaper.conf;
      };

    };

    programs = {

      btop = {
        enable = true;
      };

      vscode = {
        enable = true;
        package = pkgs.vscodium;
        extensions = with pkgs.vscode-extensions; [
          catppuccin.catppuccin-vsc
          jnoortheen.nix-ide
        ];
        # preferences = {
        #   "widget.use-xdg-desktop-portal.file-picker" = 1;
        # };
      };

      fastfetch = {
        enable = true;
        package = pkgs-unstable.fastfetch;
        # settings = {
        #   logo = {
        #     source = "nixos_small";
        #     padding = {
        #       right = 1;
        #     };
        #   };
        #   display = {
        #     binaryPrefix = "si";
        #     color = "blue";
        #     separator = " <U+F178> ";
        #   };
        #   modules = [
        #     {
        #       type = "datetime";
        #       key = "Date";
        #       format = "{1}-{3}-{11}";
        #     }
        #     {
        #       type = "datetime";
        #       key = "Time";
        #       format = "{14}:{17}:{20}";
        #     }
        #     "break"
        #     "player"
        #     "media"
        #   ];
        # };
      };

      zsh = {
        enable = true;

        autosuggestion = {
          enable = true;
        };

        syntaxHighlighting ={
          enable = true;
        };

        oh-my-zsh = {
          enable = true;
          plugins = [];
        };
      };

      wezterm = {
      enable = true;
      package = pkgs-stable.wezterm;
      enableZshIntegration = true;

      extraConfig = ''
       local config = {}

       if wezterm.config_builder then
         config = wezterm.config_builder()
       end

        config.font = wezterm.font("MesloLGS NF")
        config.color_scheme = 'Catppuccin Mocha'
        
        if os.getenv("XDG_CURRENT_DESKTOP") == "Hyprland" then
          config.window_decorations = "NONE"
        end
        
        config.use_fancy_tab_bar = false
        config.window_background_opacity = 0.9

        config.enable_wayland = false

       return config
      '';
      };

        # if os.getenv("XDG_CURRENT_DESKTOP") == "Hyprland" then
        #   config.enable_wayland = true
        # else
        #   config.enable_wayland = false
        # end

      git = {
        enable = true;
        package = pkgs-stable.git;
        userEmail = "61592704+MrSn0wy@users.noreply.github.com";
        userName = "MrSn0wy";
      };


      # firefox = {
      #   enable = true;
      #   package = pkgs-stable.firefox-beta;
      #   profiles = {
      #     snowy = {
      #       isDefault = true;
      #       name = "snowy";
      #       bookmarks = [
      #         {
      #           name = "Phoronix";
      #           keyword = "phoronix";
      #           url = "https://www.phoronix.com/";
      #         }
      #       ];
      #       search = {
      #         default = "Brave Search";
      #         force = true;
      #         privateDefault = "DuckDuckGo";
      #         order = [ "Brave Search" "Google" ];
      #         engines = {
      #           "Brave Search" = {
      #             urls = [{
      #               template = "https://search.brave.com/search";
      #               params = [
      #                 { name = "q"; value = "{searchTerms}"; }
      #               ];
      #             }];
      #             # icon = "https://cdn.search.brave.com/serp/v2/_app/immutable/assets/brave-search-icon.CsIFM2aN.svg";
      #             definedAliases = [ "!b" ];
      #           };
      #         };
      #       };
      #       settings = {
      #         # "browser.startup.homepage" = "https://search.brave.com/";
      #         # "browser.search.defaultenginename" = "Brave Search";
      #         # "browser.search.order.1" = "Brave Search";

      #         "privacy.resistFingerprinting" = true;
      #         "toolkit.telemetry.reportingpolicy.firstRun" = false;
      #         "toolkit.winRegisterApplicationRestart" = false;
      #         "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      #         "svg.context-properties.content.enabled" = true;
      #         "browser.dom.window.dump.enabled" = false;
      #         "browser.download.panel.shown" = true;
      #         "browser.policies.applied" = true;
      #         "browser.policies.runOncePerModification.extensionsInstall" = [
      #           "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi"
      #           "https://addons.mozilla.org/firefox/downloads/latest/canvasblocker/latest.xpi"
      #           "https://addons.mozilla.org/firefox/downloads/latest/clearurls/latest.xpi"
      #           "https://addons.mozilla.org/firefox/downloads/latest/facebook-container/latest.xpi"
      #           "https://addons.mozilla.org/firefox/downloads/latest/privacy-badger17/latest.xpi"
      #           "https://addons.mozilla.org/firefox/downloads/latest/user-agent-string-switcher/latest.xpi"

      #           "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi"
      #           "https://addons.mozilla.org/firefox/downloads/latest/return-youtube-dislikes/latest.xpi"
      #           "https://addons.mozilla.org/firefox/downloads/latest/catppuchin-mocha/latest.xpi"
      #         ];

      #         "browser.policies.runOncePerModification.extensionsUninstall" = "[\"DuckDuckGo@search.mozilla.org\",\"bing@search.mozilla.org\",\"amazondotcom@search.mozilla.org\",\"ebay@search.mozilla.org\",\"twitter@search.mozilla.org\"]";
      #         "browser.policies.runOncePerModification.removeSearchEngines" = "[\"DuckDuckGo\",\"Bing\",\"Amazon.com\",\"eBay\",\"Twitter\"]";
      #         "dom.security.https_only_mode_ever_enabled" = true;
      #         "network.captive-portal-service.enabled" = false;
      #         "network.connectivity-service.enabled" = false;
      #         "network.http.referer.disallowCrossSiteRelaxingDefault.top_navigation" = true;
      #         "network.predictor.enabled" = false;
      #         "network.prefetch-next" = false;
      #         "permissions.delegation.enabled" = false;
      #         "privacy.annotate_channels.strict_list.enabled" = true;
      #         "privacy.fingerprintingProtection" = true;
      #         "privacy.history.custom" = true;
      #         "privacy.query_stripping.enabled" = true;
      #         "privacy.query_stripping.enabled.pbmode" = true;
      #         "privacy.sanitize.pending"	= "[{\"id\":\"newtab-container\",\"itemsToClear\":[],\"options\":{}}]";
      #         "privacy.sanitize.sanitizeOnShutdown" = false;
      #         "privacy.trackingprotection.emailtracking.enabled" = true;
      #         "privacy.trackingprotection.enabled" = true;
      #         "privacy.trackingprotection.socialtracking.enabled" = true;
      #         "widget.use-xdg-desktop-portal.file-picker" = 1;
      #         "security.tls.enable_0rtt_data" = false;
      #         "services.sync.engine.addresses.available" = true;
      #       };
      #     };
      #   };
      # };


      ssh = {
        enable = true;
        package = pkgs-stable.openssh;
        extraConfig = ''
          Host server
            HostName 191.96.1.167
            User root
            Port 22

          Host *
            ServerAliveInterval 60
            IdentityFile ~/.ssh/id_ed25519
        '';
      };
    };

#    home.file = {
#      Downloads.source = config.lib.file.mkOutOfStoreSymlink "/mnt/SnowData/testsnowy/Downloads";
#      Documents.source = config.lib.file.mkOutOfStoreSymlink "/mnt/SnowData/testsnowy/Documents";
#      Videos.source = config.lib.file.mkOutOfStoreSymlink "/mnt/SnowData/testsnowy/Videos";
#      Music.source = config.lib.file.mkOutOfStoreSymlink "/mnt/SnowData/tetssnowy/Music";
#      Desktop.source = config.lib.file.mkOutOfStoreSymlink "/mnt/SnowData/testsnowy/Desktop";
#      Pictures.source = config.lib.file.mkOutOfStoreSymlink "/mnt/SnowData/testsnowy/Pictures";
#      Games.source = config.lib.file.mkOutOfStoreSymlink "/mnt/SnowData/testsnowy/Games";
#      unity.source = config.lib.file.mkOutOfStoreSymlink "/mnt/SnowData/testsnowy/unity";
#      ".ssh".source = config.lib.file.mkOutOfStoreSymlink "/mnt/SnowData/testsnowy/.ssh";
#      # ".config".source = config.lib.file.mkOutOfStoreSymlink "/mnt/SnowData/testsnowy/.config";
#      ".local".source = config.lib.file.mkOutOfStoreSymlink "/mnt/SnowData/testsnowy/.local";
#      ".var".source = config.lib.file.mkOutOfStoreSymlink "/mnt/SnowData/testsnowy/.var";
#      ".icons".source = config.lib.file.mkOutOfStoreSymlink "/mnt/SnowData/testsnowy/.icons";
#      ".steam".source = config.lib.file.mkOutOfStoreSymlink "/mnt/SnowData/testsnowy/.steam";
#      # ".rustup".source = config.lib.file.mkOutOfStoreSymlink "/mnt/SnowData/snowy/.rustup";
#      # ".cargo".source = config.lib.file.mkOutOfStoreSymlink "/mnt/SnowData/snowy/.cargo";
#      # ".android".source = config.lib.file.mkOutOfStoreSymlink "/mnt/SnowData/snowy/.android";
#      ".mozilla".source = config.lib.file.mkOutOfStoreSymlink "/mnt/SnowData/testsnowy/.mozilla";
#      ".ollama".source = config.lib.file.mkOutOfStoreSymlink "/mnt/SnowData/testsnowy/.ollama";
#    };
}
