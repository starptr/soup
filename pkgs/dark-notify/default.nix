{ stdenv, lib, makeRustPlatform, fetchFromGitHub, rustPackages, maybe-flake-inputs }:
let
  fenix-pkgs = if builtins.isNull maybe-flake-inputs
    then
      abort "non-flake fenix is not implemented yet"
    else
      maybe-flake-inputs.fenix;
  fenix = fenix-pkgs.packages.${stdenv.hostPlatform.system};
  version = "11.5";
  src = if builtins.isNull maybe-flake-inputs
    then
      fetchFromGitHub {
        owner = "cormacrelf";
        repo = "dark-notify";
        rev = "";
        hash = "";
      }
    else
      maybe-flake-inputs.dark-notify;
in
(makeRustPlatform {
  cargo = fenix.complete.toolchain;
  rustc = fenix.complete.toolchain;
}).buildRustPackage {
  pname = "dark-notify";
  version = "0.1.2";

  inherit src;

  cargoLock = {
    lockFile = "${src}/Cargo.lock";
  };

  meta = {
    changelog = "";
    description = "Watcher for macOS 10.14+ light/dark mode changes";
    homepage = "https://github.com/cormacrelf/dark-notify";
    mainProgram = "dark-notify";
    platforms = lib.platforms.darwin;
  };

}