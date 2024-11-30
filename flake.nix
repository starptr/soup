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
    flake-compat.url = "https://flakehub.com/f/edolstra/flake-compat/1.tar.gz";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    love = {
      url = "https://github.com/love2d/love/releases/download/11.5/love-11.5-macos.zip";
      flake = false;
    };
    chaseln = {
      url = "github:starptr/chaseln";
      inputs = {
        nixpkgs.follows = "nixpkgs-devenv";
        devenv.follows = "devenv";
      };
    };
    dark-notify = {
      url = "github:starptr/dark-notify";
      inputs = {
        nixpkgs.follows = "nixpkgs-devenv";
        devenv.follows = "devenv";
        fenix.follows = "fenix";
      };
    };
    check-gits = {
      url = "github:starptr/check-gits";
      inputs = {
        nixpkgs.follows = "nixpkgs-devenv";
        devenv.follows = "devenv";
      };
    };
  };

  nixConfig = {
    extra-trusted-public-keys = [
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    extra-substituters = [
      "https://devenv.cachix.org"
      "https://nix-community.cachix.org"
    ];
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
      flake-inputs = {
        inherit (inputs) love chaseln dark-notify fenix check-gits;
      };
    in
    {
      legacyPackages = forAllSystems (system: import ./default.nix {
        maybe-flake-inputs = flake-inputs;
        pkgs = import nixpkgs { inherit system; };
      });
      packages = forAllSystems (system: nixpkgs.lib.filterAttrs (_: v: nixpkgs.lib.isDerivation v) self.legacyPackages.${system});
      overlays = import ./overlays { maybe-flake-inputs = flake-inputs; };
    };
}
