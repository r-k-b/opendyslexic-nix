{
  description = "antijingoist/opendyslexic as a Nix Flake.";

  inputs = { utils.url = "github:numtide/flake-utils"; };

  outputs = { self, nixpkgs, utils }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages."${system}";
        inherit (pkgs) lib fetchzip mkShell;
        opendyslexic = let version = "2021-06-12";
        in fetchzip {
          name = "open-dyslexic-${version}";

          url =
            "https://github.com/antijingoist/opendyslexic/archive/e7ac50af1aabb8cb0fbf81db105f21f81fbb5284.zip";

          postFetch = ''
            mkdir -p $out/share/{doc,fonts}
            unzip -j $downloadedFile \*.otf       -d $out/share/fonts/opentype
            unzip -j $downloadedFile \*/README.md -d $out/share/doc/open-dyslexic
          '';

          sha256 = "O7RHr0v6A9P3o+1Af1nKLls/Bt1n0NvNO0UP6FK8z30=";

          meta = with lib; {
            homepage = "https://opendyslexic.org/";
            description =
              "Font created to increase readability for readers with dyslexia";
            license = licenses.ofl;
            platforms = platforms.all;
            maintainers = [ maintainers.rycee ];
          };
        };
      in {
        # `nix build`
        packages.opendyslexic = opendyslexic;
        defaultPackage = opendyslexic;

        # `nix develop`
        devShell = mkShell { nativeBuildInputs = with pkgs; [ opendyslexic ]; };
      });
}
