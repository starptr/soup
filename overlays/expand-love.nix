self: super: {
  love = if self.stdenv.hostPlatform.isDarwin
    then (self.callPackage ./.. { }).love
    else super.love;
}