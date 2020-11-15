# modules/dev --- common settings for dev modules

{ pkgs, ... }:
{
  imports = [
    ./commonlisp.nix
    ./docker.nix
    ./mysql.nix
    ./node.nix
    ./reasonml.nix
    ./nim.nix
    ./elixir.nix
    # ./rust.nix
  ];

  options = {};
  config = {};
}
