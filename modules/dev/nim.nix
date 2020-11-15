{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
      nim
      (pkgs.writeScriptBin "nimx" ''
        bin=$1
        src="/etc/dotfiles/nimbin/src/$bin.nim"
        dst="/etc/dotfiles/nimbin/dst/$bin"
        shift

        if [[ ! -f "$dst" || "$src" -nt "$dst" ]]; then
            echo "Compiling $src..."
            ${pkgs.nim}/bin/nim c -r \
                --verbosity:0 \
                --hint[Processing]:off \
                --excessiveStackTrace:on \
                -d:release \
                --out:$dst \
                $src
        fi

        $dst $@
    '')
  ];
}
