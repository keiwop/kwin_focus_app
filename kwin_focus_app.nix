# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright (C): 2025 - keiwop <keiwop.dev@gmail.com>

# I install focus_app in my configuration.nix this way:
# environment.systemPackages = with pkgs; [
#   (pkgs.callPackage ./kwin_focus_app.nix {})
# ];

{
  lib,
  stdenv,
  fetchgit,
}:

stdenv.mkDerivation rec {
  pname = "kwin_focus_app";
  version = "0.1";

  src = fetchgit {
    url = "https://bitbucket.org/keiwop/kwin_focus_app.git";
    rev = "v${version}";
    sha256 = "062d510rsj65kggljj640l7486ixpr9zykd2f5knwnacvqcjc0cw";
  };
  # src = lib.cleanSource /_/src/js/kwin_focus_app;

  installPhase = ''
    mkdir -p $out/share/kwin/scripts/focus_app
    cp metadata.json $out/share/kwin/scripts/focus_app/
    cp -r contents $out/share/kwin/scripts/focus_app/
  '';

  meta = with lib; {
    description = "KWin script to focus applications and cycle through windows";
    homepage = "https://bitbucket.org/keiwop/kwin_focus_app.git";
    license = licenses.gpl3Plus;
    maintainers = [ "keiwop.dev@gmail.com" ];
    platforms = platforms.linux;
  };
}
