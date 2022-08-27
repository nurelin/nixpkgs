{ stdenv, fetchFromGitHub, rustPlatform, lib, pkg-config, openssl, gtk3, just, bash }:

stdenv.mkDerivation rec {
  pname = "pop-launcher";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "launcher";
    rev = version;
    sha256 = "sha256-BQAO9IodZxGgV8iBmUaOF0yDbAMVDFslKCqlh3pBnb0=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-cTvrq0fH057UIx/O9u8zHMsg+psMGg1q9klV5OMxtok=";
  };

  nativeBuildInputs = [ pkg-config rustPlatform.cargoSetupHook rustPlatform.rust.cargo just ];
  buildInputs = [ openssl gtk3 ];

  postPatch = ''
    substituteInPlace ./justfile \
      --replace '/usr/bin/env sh' ${bash}/bin/sh

    substituteInPlace ./src/lib.rs \
      --replace '/usr/lib/pop-launcher' "$out/lib/pop-launcher"
  '';

  installPhase = ''
    runHook preInstall
    just
    just rootdir=$out base_dir=$out/ install
    runHook postInstall
  '';


  meta = with lib; {
    description = "Modular IPC-based desktop launcher service for Pop!_OS";
    maintainers = with maintainers; [ Enzime ];
    license = licenses.mpl20;
    homepage = "https://github.com/pop-os/launcher";
  };
}
