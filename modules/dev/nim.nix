{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
      unstable.nim
      (pkgs.writeScriptBin "nimx" ''
        bin=$1
        src="$bin.nim"
        shift

        if [[ ! -f "$bin" || "$src" -nt "$bin" ]]; then
            echo "Compiling $src..."
            ${pkgs.nim}/bin/nim c -r --verbosity:0 --hint[Processing]:off --excessiveStackTrace:on -d:release $src
        fi

        $bin $@
    '')
  ];
}
