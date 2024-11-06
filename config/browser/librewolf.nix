{pkgs, ...}: {
  # Module installing librewolf as default browser
  home.packages = [pkgs.librewolf-wayland];

  home.sessionVariables = {
    DEFAULT_BROWSER = "${pkgs.librewolf-wayland}/bin/librewolf";
  };

  home.file.".librewolf/librewolf.overrides.cfg".text = ''
    defaultPref("font.name.serif.x-western","JetBrainsMono Nerd Font Mono");

    defaultPref("identity.fxaccounts.enabled", true);
    defaultPref("font.size.variable.x-western",20);
    defaultPref("browser.toolbars.bookmarks.visibility","always");
    defaultPref("privacy.resisttFingerprinting.letterboxing", true);
    defaultPref("network.http.referer.XOriginPolicy",2);
    defaultPref("privacy.clearOnShutdown.history",false);
    defaultPref("privacy.clearOnShutdown.downloads",false);
    defaultPref("privacy.clearOnShutdown.cookies",false);
    defaultPref("gfx.webrender.software.opengl",false);
    defaultPref("webgl.disabled",true);
    pref("font.name.serif.x-western","JetBrainsMono Nerd Font Mono");
    pref("font.size.variable.x-western",20);
    pref("browser.toolbars.bookmarks.visibility","always");
    pref("privacy.resisttFingerprinting.letterboxing", true);
    pref("network.http.referer.XOriginPolicy",2);
    pref("privacy.clearOnShutdown.history",true);
    pref("privacy.clearOnShutdown.downloads",true);
    pref("privacy.clearOnShutdown.cookies",true);
    pref("gfx.webrender.software.opengl",false);
    pref("webgl.disabled",true);

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
