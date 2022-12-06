{ config, pkgs, ... }:

{
  imports = [
  ];

  options = {
  };

  config.home.file = {
    vscode = {
      target = ".vscode-server/server-env-setup"; 
      text = 
        let
          nix_ld_library_path_val = pkgs.lib.makeLibraryPath [
            pkgs.stdenv.cc.cc
          ];
          nix_ld_path_file = "${pkgs.stdenv.cc}/nix-support/dynamic-linker";
        in ''
          export NIX_LD_LIBRARY_PATH=${nix_ld_library_path_val}
          export NIX_LD=$(cat ${nix_ld_path_file})
          '';
    };
  };
}
