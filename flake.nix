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
              cd cf-custom-resources && \
              minify *.js -o ../internal/pkg/template/templates/custom-resources && \
              cd ..
            '';
          });
        };
      });
}
