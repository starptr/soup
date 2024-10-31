{
  description = "My personal NUR repository";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nixpkgs-devenv.url = "github:cachix/devenv-nixpkgs/rolling";
    systems.url = "github:nix-systems/default";
    devenv = {
      url = "github:cachix/devenv";
      inputs.nixpkgs.follows = "nixpkgs-devenv";
    };

    love = {
      url = "https://github.com/love2d/love/releases/download/11.5/love-11.5-macos.zip";
      flake = false;
    };
    chaseln = {
      url = "github:starptr/chaseln";
      inputs = {
        nixpkgs.follows = "nixpkgs-devenv";
        systems.follows = "systems";
        devenv.follows = "devenv";
      };
    };
  };
  outputs = { self, nixpkgs, ... } @ inputs:
    let
      systems = [
        "x86_64-linux"
        "i686-linux"
        "x86_64-darwin"
        "aarch64-darwin"
        "aarch64-linux"
        "armv6l-linux"
        "armv7l-linux"
      ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);
    in
    {
      legacyPackages = forAllSystems (system: import ./default.nix {
        pkgs = import nixpkgs { inherit system; };
        flake-inputs = {
          inherit (inputs) love chaseln;
        };
      });
      packages = forAllSystems (system: nixpkgs.lib.filterAttrs (_: v: nixpkgs.lib.isDerivation v) self.legacyPackages.${system});
      overlays = import ./overlays;
    };
}
