{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    gitAndTools.hub
    gitAndTools.diff-so-fancy
  ];
  my.zsh.rc = lib.readFile <config/git/aliases.zsh>;

  my.home.xdg.configFile = {
    "git/config".source = <config/git/config>;
    "git/ignore".source = <config/git/ignore>;
  };
}
