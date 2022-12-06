{
  description = "Nix Home Manager module that allows a NixOS system to be used as a vscode remote";

  outputs = { self, nixpkgs }: {

    nixosModules.default = import ./module.nix;

  };
}
