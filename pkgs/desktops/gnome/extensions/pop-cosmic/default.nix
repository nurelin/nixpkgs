{ stdenv, lib, fetchFromGitHub, glib }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-pop-cosmic";
  version = "unstable-2022-08-27";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic";
    # from branch `master_jammy`
    rev = "182d3e768579857710107c5a65fae92b021abaa0";
    sha256 = "sha256-s4QJzrWP1GVFYpYLddaF7X/xEF1ghnRGEKC9jlzD4BU=";
  };

  nativeBuildInputs = [ glib ];

  makeFlags = [ "XDG_DATA_HOME=$(out)/share" ];

  passthru = {
    extensionUuid = "pop-cosmic@system76.com";
    extensionPortalSlug = "pop-cosmic";
  };

  meta = with lib; {
    description = "Computer Operating System Main Interface Components";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ Enzime ];
    homepage = "https://github.com/pop-os/cosmic";
  };
}
