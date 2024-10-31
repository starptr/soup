{ stdenv, maybe-flake-inputs }:
let
  chaseln-flake = if builtins.isNull maybe-flake-inputs
    then
      builtins.getFlake "github:starptr/chaseln/9a72313e441b55104e1cdf759f8da20c39ac32b6"
    else
      maybe-flake-inputs.chaseln;
in
chaseln-flake.packages.${stdenv.hostPlatform.system}.default