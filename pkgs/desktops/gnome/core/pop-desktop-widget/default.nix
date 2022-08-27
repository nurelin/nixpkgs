{ stdenv, fetchFromGitHub, rustPlatform, lib, pkg-config, glib, gst_all_1, gtk3, libhandy }:

stdenv.mkDerivation rec {
  pname = "pop-desktop-widget";
  version = "unstable-2022-08-27";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "desktop-widget";
    # master_jammy branch
    rev = "1619b241e23b16caabe97c15cf21713307c0a6f8";
    sha256 = "sha256-7oCtQvCu/QZtePsdHB85kdisQzKFmsomUIiQ55qk/5E=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-qhh8/38VQpxUXga1lmrjy07m0wlaOPQMccAKVMqCoj4=";
  };

  nativeBuildInputs = [ pkg-config glib rustPlatform.cargoSetupHook rustPlatform.rust.cargo ];
  buildInputs = [ gst_all_1.gstreamer gtk3 libhandy ];

  buildFlags = [ "prefix=$(out)" "DESTDIR=" ];
  installFlags = [ "prefix=$(out)" "DESTDIR=" ];

  postInstall = ''
    cd $out/lib
    ln -s libpop_desktop_widget.so libpop_desktop_widget.so.0
  '';

  meta = with lib; {
    description = "GTK desktop settings widget for Pop!_OS";
    maintainers = with maintainers; [ Enzime ];
    license = licenses.mit;
    homepage = "https://github.com/pop-os/desktop-widget";
  };
}
