{ stdenv, flake-inputs }:
let
  chaseln-flake = if builtins.isNull flake-inputs
    then
      builtins.getFlake "github:starptr/chaseln/fa"
    else
      flake-inputs.chaseln;
in
chaseln-flake.packages.${stdenv.hostPlatform.system}.default