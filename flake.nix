{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    node-toolchain.url = "git+https://git.natsukium.com/natsukium/node-toolchain.nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      node-toolchain,
    }:
    let
      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-darwin"
      ];
    in
    {
      devShells = forAllSystems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          toolchain = node-toolchain.lib.mkToolchain {
            inherit pkgs;
            src = self;
          };
        in
        {
          default = pkgs.mkShell {
            buildInputs = toolchain.packages ++ [ pkgs.terraform ];
          };
        }
      );
    };
}
