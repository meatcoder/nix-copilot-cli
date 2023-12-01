{
  description = "AWS Copilot CLI with fixes for missing template files";

  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { inherit system; };
      in {
        packages = {
          default = pkgs.copilot-cli.overrideAttrs (oldAttrs: {
            nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ pkgs.minify ];

            preBuild = ''
              cd cf-custom-resources/lib && \
              RES_DEST_DIR="../../internal/pkg/template/templates/custom-resources" && \
              mkdir -p "$RES_DEST_DIR" && \
              minify -o "$RES_DEST_DIR" *.js && \
              cd ../..
            '';
          });
        };
      });
}
