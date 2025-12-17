{ pkgs, ... }:
{
  home.pointerCursor = {
    package = pkgs.capitaine-cursors;
    name = "capitaine-cursors";
    size = 32;
  };
}
