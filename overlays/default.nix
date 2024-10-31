{ maybe-flake-inputs }: {
  # Add your overlays here
  #
  # my-overlay = import ./my-overlay;
  expand-love = self: super: {
    love = if self.stdenv.hostPlatform.isDarwin
      then (self.callPackage ./.. { inherit maybe-flake-inputs; }).love
      else super.love;
  };

  # This overlay naively adds all of the pkgs.
  #default = import ../overlay.nix;
  chaseln = if builtins.isNull maybe-flake-inputs
    then
      self: super: {
        chaseln = (self.callPackage ../. { inherit maybe-flake-inputs; }).chaseln;
      }
    else
      maybe-flake-inputs.chaseln.overlays.default;
}
