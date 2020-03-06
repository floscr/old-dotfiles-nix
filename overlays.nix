[
  (self: super: with super; {
    my = {
      cached-nix-shell =
        (callPackage
          (builtins.fetchTarball
            https://github.com/xzfc/cached-nix-shell/archive/master.tar.gz) {});
    };
  })
  (import ./overlays/chromium.nix)
]
