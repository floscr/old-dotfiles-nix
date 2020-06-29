let emacsOverlaySha = "076246e7d209313112f13f03a9ee92534f0bbf0a";
in [
  (self: super: with super; {
    my = {
      cached-nix-shell =
        (callPackage
          (builtins.fetchTarball
            https://github.com/xzfc/cached-nix-shell/archive/master.tar.gz) {});
      inriaFont = (callPackage ./inria.nix {});
    };

    # Occasionally, "stable" packages are broken or incomplete, so access to the
    # bleeding edge is necessary, as a last resort.
    unstable = import <nixpkgs-unstable> { inherit config; };
  })

  (import (builtins.fetchTarball {
    url = "https://github.com/nix-community/emacs-overlay/archive/${emacsOverlaySha}.tar.gz";
  }))
  (import ./chromium.nix)
]
