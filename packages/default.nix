let emacsOverlaySha = "cba999dda3899d83ffc30b97b0f34243ac198854";
in [
  (self: super: with super; {
    my = {
      inriaFont = (callPackage ./inria.nix {});
      rofimoji = (callPackage ./rofimoji.nix {});
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
