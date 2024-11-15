{pkgs, ...}: {
  # Module installing librewolf as default browser
  home.packages = [pkgs.librewolf-wayland];

  home.sessionVariables = {
    DEFAULT_BROWSER = "${pkgs.librewolf-wayland}/bin/librewolf";
  };

  home.file.".librewolf/librewolf.overrides.cfg".text = ''
    pref("identity.fxaccounts.enabled", true);
    pref("browser.toolbars.bookmarks.visibility","always");
    pref("privacy.resisttFingerprinting.letterboxing", false);
    pref("network.http.referer.XOriginPolicy",2);
    pref("privacy.clearOnShutdown.history",false);
    pref("privacy.clearOnShutdown.downloads",false);
    pref("privacy.clearOnShutdown.cookies",false);
    pref("gfx.webrender.software.opengl",false);
    pref("webgl.disabled",true);
    pref("font.name.serif.x-western","JetBrainsMono Nerd Font Mono");
    pref("font.size.variable.x-western",18);


    pref("network.trr.mode", 2);
    pref("network.trr.uri", "https://dns.quad9.net/dns-query"); // Current 'reasonable default': No Filering

    // Additions by Acideburn in https://codeberg.org/librewolf/issues/issues/1975#issuecomment-2301916 , and other PR's
    pref("network.trr.default_provider_uri", "https://doh.dns4all.eu/dns-query");  // Define a fallback DoH server (used only in mode 1)
    pref("network.trr.strict_native_fallback", false); // Allow native fallback
    pref("network.trr.retry_on_recoverable_errors", true); // Retry on recoverable errors
    pref("network.trr.disable-heuristics", true); // Disables the canary telemetry detection request "use-application-dns.net" for DOH
    pref("network.trr.allow-rfc1918", true); // Allows the use of private IP addresses (RFC 1918) in DOH responses
  '';

  xdg.mimeApps.defaultApplications = {
    "text/html" = "librewolf.desktop";
    "x-scheme-handler/http" = "librewolf.desktop";
    "x-scheme-handler/https" = "librewolf.desktop";
    "x-scheme-handler/about" = "librewolf.desktop";
    "x-scheme-handler/unknown" = "librewolf.desktop";
  };
}
