# Latex formula for the emacs package: calctex-mode
# https://github.com/johnbcoughlin/calctex
# Not working yet: Regular numbers (fonts missing)
{ config, lib, pkgs, ... }:

with lib;
let
  tex = pkgs.unstable.texlive.combine {
    inherit (pkgs.unstable.texlive)
      scheme-basic
      # Undocumented CalcTex Packages
      collection-fontsrecommended
      collection-mathscience
      collection-fontsextra
      xkeyval
      enumitem
      mathpazo
      palatino
      # CalcTex Packages
      dvipng
      xcolor
      soul
      adjustbox
      l3kernel # xparse.sty
      l3packages # xparse.sty
      collectbox
      amsfonts # amssym
      amsmath
      siunitx
      # Display math in org mode
      dvisvgm
      unicode-math
      ulem
      collection-latex
      subfigure
    ;
  };
in {
  options.modules.editors.emacsCalcTex = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.editors.emacsCalcTex.enable {
    my.packages = with pkgs; [
      tex
    ];
  };
}
