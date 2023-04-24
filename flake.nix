{
  description = "A simple application";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:

    flake-utils.lib.eachDefaultSystem (system:
      let
        overlay = final: prev: {
          demo-app = with final; pkgs.python3Packages.buildPythonApplication {
            pname = "demo-app";
            version = "0.0.1";
            propagatedBuildInputs = [ pkgs.python3Packages.flask ];
            src = ./.;
          };
        };
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ overlay ];
        };
      in
      {
        devShell = pkgs.mkShell {
          name = "docker-example";
          buildInputs = [ pkgs.python3 ];
        };
        defaultPackage = pkgs.demo-app;
      }
    );
}
