{
  description = "ORR viewer";

  inputs.nixpkgs.url = "nixpkgs/nixos-23.11";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = inputs: inputs.flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = inputs.nixpkgs.legacyPackages."${system}";
    in
    rec
    {
      packages = {
        orr = pkgs.stdenvNoCC.mkDerivation (finalAttrs: {
          pname = "orr";
          version = "0.1.0";

          propagatedBuildInputs = [
            pkgs.fzf
            pkgs.jq
            pkgs.mpv
          ];

          phases = [ "installPhase" ];
          installPhase = ''
            mkdir -p        $out/bin
            cp -v ${./orr}  $out/bin/orr
            chmod +x        $out/bin/orr
          '';
        });

        orr-update = pkgs.stdenvNoCC.mkDerivation (finalAttrs: {
          pname = "orr-update";
          version = "0.1.0";

          propagatedBuildInputs = [
            pkgs.curl
          ];

          phases = [ "installPhase" ];
          installPhase = ''
            mkdir -p                $out/bin
            cp -v ${./orr-update}   $out/bin/orr-update
            chmod +x                $out/bin/orr-update
          '';
        });
      };

      apps = {
        default = apps.orr;
        orr = inputs.flake-utils.lib.mkApp {
          drv = inputs.self.packages."${system}".orr;
        };

        orr-update = inputs.flake-utils.lib.mkApp {
          drv = inputs.self.packages."${system}".orr-update;
        };
      };
    });
}
