{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
      nim
      (pkgs.writeScriptBin "nimx" ''
        bin=$1
        src="$bin.nim"
        shift

        if [[ ! -f "$bin" || "$src" -nt "$bin" ]]; then
            echo "Compiling $src..."
            ${pkgs.nim} c --verbosity:0 --hint[Processing]:off --excessiveStackTrace:on $src
        fi

        $bin $@
    '')
  ];
  my = {
    # env.PATH = [<nimbin>];
  };
}
