{
  description = "Apic crate flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    crane.url = "github:ipetkov/crane";
    flake-utils.url = "github:numtide/flake-utils";
    fenix.url = "github:nix-community/fenix";
  };

  outputs = {
    flake-utils,
    nixpkgs,
    fenix,
    ...
  } @ inputs:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      crane = inputs.crane.mkLib pkgs;
      toolchain = fenix.packages.${system}.fromToolchainFile {
        file = ./rust-toolchain;
        sha256 = "sha256-3bAD7erEALKbg6tqraZbgnUo6QXocekG7M7WSWlwHdE=";
      };
      craneLib = crane.overrideToolchain toolchain;
    in {
      formatter = pkgs.alejandra;
      devShells.default = craneLib.devShell {
        packages = [toolchain];
      };
    });
}
