{ stdenvNoCC, fetchurl, lib, unzip }:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "love";
  version = "11.5";

  src = fetchurl {
    url = "https://github.com/love2d/love/releases/download/${finalAttrs.version}/love-${finalAttrs.version}-macos.zip";
    hash = "sha256-Z5W7OhZWr2ov3+dB4VB4e0gYhtOigDJ6Jho/3e1YaRM=";
  };

  nativeBuildInputs = [ unzip ];

  sourceRoot = "love.app";

  installPhase = ''
    mkdir -p $out/{bin,Applications/love.app}
    cp -R . "$out/Applications/love.app"
    ln -s "$out/Applications/love.app/Contents/MacOS/love" "$out/bin/love"
  '';

  meta = {
    changelog = "";
    description = "Lua-based 2D game engine/scripting language";
    homepage = "https://love2d.org";
    mainProgram = "love";
    platforms = lib.platforms.darwin;
  };

})