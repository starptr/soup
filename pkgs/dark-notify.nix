{ stdenv, lib, makeRustPlatform, fetchFromGitHub, rustPackages, maybe-flake-inputs }:
let
  dark-notify-flake = if builtins.isNull maybe-flake-inputs
    then
      abort "non-flake dark-notify is not implemented yet"
    else
      maybe-flake-inputs.dark-notify;
in
dark-notify-flake.packages.${stdenv.hostPlatform.system}.default