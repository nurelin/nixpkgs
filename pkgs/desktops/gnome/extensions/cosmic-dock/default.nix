{ stdenv, lib, fetchFromGitHub, glib, sassc }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-cosmic-dock";
  version = "unstable-2022-08-27";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-dock";
    # from branch `master_jammy`
    rev = "0544fb13f2fbfd4feff1289bac66ed07291981fb";
    sha256 = "sha256-//a1qB2FrZ8P5Ix1c84cEGAuehdyO5WhlcHQCRW1T7M=";
  };

  nativeBuildInputs = [ glib sassc ];

  makeFlags = [ "XDG_DATA_HOME=$(out)/share" "DESTDIR=$(out)" ];

  postPatch = ''
    substituteInPlace ./Makefile \
      --replace 'SHARE_PREFIX = $(DESTDIR)/usr/share' 'SHARE_PREFIX = $(DESTDIR)/share'
  '';

  passthru = {
    extensionUuid = "cosmic-dock@system76.com";
    extensionPortalSlug = "cosmic-dock";
  };

  meta = with lib; {
    description = "Cosmic Dock (Pop!_OS fork of Ubuntu Dock)";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ Enzime ];
    homepage = "https://github.com/pop-os/cosmic-dock";
  };
}
