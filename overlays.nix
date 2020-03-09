[
  (self: super: with super; {
    my = {
      cached-nix-shell =
        (callPackage
          (builtins.fetchTarball
            https://github.com/xzfc/cached-nix-shell/archive/master.tar.gz) {});
    };

    # Occasionally, "stable" packages are broken or incomplete, so access to the
    # bleeding edge is necessary, as a last resort.
    unstable = import <nixos-unstable> { inherit config; };
  })

  (import (builtins.fetchTarball https://github.com/nix-community/emacs-overlay/archive/master.tar.gz))
  (import ./overlays/chromium.nix)
]
