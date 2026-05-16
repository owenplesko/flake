{pkgs, ...}: {
  programs.firefox = {
    enable = true;
    configPath = ".mozilla/firefox";
    policies = {
      DisableFirefoxAccounts = true;
    };

    profiles = {
      default = {
        isDefault = true;
        settings = {
          "browser.startup.homepage" = "about:blank";
          "browser.startup.page" = 0;
          "browser.newtabpage.enabled" = false;
          "extensions.autoDisableScopes" = 0;
          "extensions.update.autoUpdateDefault" = false;
          "extensions.update.enabled" = false;
        };
        extensions = {
          force = true;
          packages = with pkgs.nur.repos.rycee.firefox-addons; [
            ublock-origin
          ];
        };
        bookmarks = {
          force = true;
          settings = [
            {
              name = "toolbar";
              toolbar = true;
              bookmarks = [
                {
                  name = "Nix Resources";
                  bookmarks = [
                    {
                      name = "Nix Pkgs";
                      url = "https://search.nixos.org/packages";
                    }
                    {
                      name = "Home Manager";
                      url = "https://nix-community.github.io/home-manager/options.xhtml";
                    }
                    {
                      name = "Stylix";
                      url = "https://nix-community.github.io/stylix/";
                    }
                    {
                      name = "Tinted Gallery";
                      url = "https://tinted-theming.github.io/tinted-gallery/";
                    }
                  ];
                }
              ];
            }
          ];
        };
      };
    };
  };

  stylix.targets.firefox = {
    colorTheme.enable = true;
    profileNames = ["default"];
  };
}
