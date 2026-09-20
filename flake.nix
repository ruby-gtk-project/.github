{
  description = "OpenTofu + GitHub provider for the fork registry";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, utils }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        gems = pkgs.bundlerEnv {
          name = "opentofu-gems";
          ruby = pkgs.ruby_3_4;
          gemdir = ./opentofu;
        };
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            (pkgs.opentofu.withPlugins (p: [ p.integrations_github ]))
            gems
            gems.wrappedRuby
          ];
        };
        devShells.bootstrap = pkgs.mkShell {
          buildInputs = with pkgs; [ ruby_3_4 bundler bundix ];
        };
      }
    );
}
