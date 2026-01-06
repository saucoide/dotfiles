{
  inputs,
  pkgs,
  ...
}: let
  firefox-addons = inputs.nur.legacyPackages.${pkgs.stdenv.hostPlatform.system}.repos.rycee.firefox-addons;
in {
  programs.firefox = {
    enable = true;
    profiles = {
      default = {
        id = 0;
        name = "default";
        isDefault = true;
        settings = {
          # styling
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          # Disable "save password" prompt
          "signon.rememberSignons" = false;
          # privacy
          "privacy.trackingprotection.enabled" = true;
          # telemetry
          "app.shield.optoutstudies.enabled" = false;
          "browser.discovery.enabled" = false;
          "browser.newtabpage.activity-stream.feeds.telemetry" = false;
          "browser.newtabpage.activity-stream.telemetry" = false;
          "browser.ping-centre.telemetry" = false;
          "datareporting.healthreport.service.enabled" = false;
          "datareporting.healthreport.uploadEnabled" = false;
          "datareporting.policy.dataSubmissionEnabled" = false;
          "datareporting.sessions.current.clean" = true;
          "devtools.onboarding.telemetry.logged" = false;
          "toolkit.telemetry.archive.enabled" = false;
          "toolkit.telemetry.bhrPing.enabled" = false;
          "toolkit.telemetry.enabled" = false;
          "toolkit.telemetry.firstShutdownPing.enabled" = false;
          "toolkit.telemetry.hybridContent.enabled" = false;
          "toolkit.telemetry.newProfilePing.enabled" = false;
          "toolkit.telemetry.prompted" = 2;
          "toolkit.telemetry.rejected" = true;
          "toolkit.telemetry.reportingpolicy.firstRun" = false;
          "toolkit.telemetry.server" = "";
          "toolkit.telemetry.shutdownPingSender.enabled" = false;
          "toolkit.telemetry.unified" = false;
          "toolkit.telemetry.unifiedIsOptIn" = false;
          "toolkit.telemetry.updatePing.enabled" = false;
        };
        userChrome = ''
          #main-window #TabsToolbar {
            visibility: collapse;
          }
          #main-window[privatebrowsingmode=temporary]  #TabsToolbar,
          #main-window[privatebrowsingmode=permanent]  #TabsToolbar {
            visibility: visible !important;
          }

          #sidebar-header {
            display: none;
          }
        '';
        search = {
          force = true;
          default = "google-en";
          engines = {
            google-en = {
              name = "GoogleEn";
              urls = [
                {
                  template = "https://www.google.com/search";
                  params = [
                    {
                      name = "hl";
                      value = "en";
                    }
                    {
                      name = "q";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              definedAliases = ["g"];
            };
            nix-packages = {
              name = "NixOS Search";
              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  params = [
                    {
                      name = "type";
                      value = "packages";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = ["np"];
            };

            nixos-wiki = {
              name = "NixOS Wiki";
              urls = [{template = "https://wiki.nixos.org/w/index.php?search={searchTerms}";}];
              iconMapObj."16" = "https://wiki.nixos.org/favicon.ico";
              definedAliases = ["nw"];
            };
            bing.metaData.hidden = true;
            ddg.metaData.alias = "ddg";
          };
        };
        extensions = {
          packages = with firefox-addons; [
            ublock-origin
            bitwarden
            sidebery
            tridactyl
            multi-account-containers
            temporary-containers
            duckduckgo-privacy-essentials
            privacy-badger
          ];
        };
      };
      extra = {
        id = 1;
        name = "extra";
        isDefault = false;
        extensions = {
          packages = with firefox-addons; [
            ublock-origin
            bitwarden
            duckduckgo-privacy-essentials
            privacy-badger
          ];
        };
      };
    };
  };

  xdg.configFile."tridactyl/tridactylrc" = {
    source = ./tridactylrc;
  };
}
