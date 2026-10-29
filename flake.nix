{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    node-toolchain.url = "git+https://git.natsukium.com/natsukium/node-toolchain.nix";
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.flake-compat.follows = "";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ self, ... }:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];

      imports = [
        inputs.git-hooks.flakeModule
        inputs.treefmt-nix.flakeModule
      ];

      perSystem =
        {
          config,
          pkgs,
          system,
          ...
        }:
        {
          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };

          treefmt = {
            projectRootFile = "flake.nix";
            flakeCheck = false;
            programs = {
              nixfmt.enable = true;
              terraform.enable = true;
            };
          };

          pre-commit = {
            check.enable = true;
            settings.hooks = {
              actionlint.enable = true;
              oxlint.enable = true;
              treefmt.enable = true;
              typos.enable = true;
            };
          };

          devShells.default =
            let
              toolchain = inputs.node-toolchain.lib.mkToolchain {
                inherit pkgs;
                src = self;
              };
            in
            pkgs.mkShell {
              buildInputs =
                toolchain.packages
                ++ config.pre-commit.settings.enabledPackages
                ++ [
                  pkgs.terraform
                ];
              shellHook = config.pre-commit.installationScript;
            };
        };
    };
}
