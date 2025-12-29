{ pkgs, ... }:
{
  nixpkgs.overlays = [
    (final: prev: {
      jetbrains = prev.jetbrains // {
        pycharm = prev.jetbrains.pycharm.overrideAttrs (old: {
          postFixup = (old.postFixup or "") + ''
            wrapProgram $out/bin/pycharm \
              --prefix LD_LIBRARY_PATH : ${final.lib.makeLibraryPath [ final.stdenv.cc.cc.lib ]}
          '';
        });
      };
    })
  ];
  home.packages = [ pkgs.jetbrains.pycharm ];
}
