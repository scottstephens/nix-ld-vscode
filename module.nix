{ config, pkgs, ... }:
let 
  nix_ld_library_path_val = pkgs.lib.makeLibraryPath [
    pkgs.stdenv.cc.cc
  ];
  nix_ld_path_file = "${pkgs.stdenv.cc}/nix-support/dynamic-linker";
in
{
  imports = [
  ];

  options = {
  };

  config.home.file = {
    vscode = {
      target = ".vscode-server/server-env-setup"; 
      text = ''
        export NIX_LD_LIBRARY_PATH=${nix_ld_library_path_val}
        export NIX_LD=$(cat ${nix_ld_path_file})
        '';
    };
  };

  config.programs.bash = {
    enable = true;
    profileExtra = ''
      #echo "nix-ld-vscode: running profileExtra";
      #export NIX_LD_VSCODE_TRACE="$NIX_LD_VSCODE_TRACE:profileExtra";
      '';
    initExtra = ''
      #export NIX_LD_VSCODE_TRACE="$NIX_LD_VSCODE_TRACE:initExtra";
      #echo "nix-ld-vscode: running initExtra";
      '';
    bashrcExtra = ''
      #export NIX_LD_VSCODE_TRACE="$NIX_LD_VSCODE_TRACE:bashrcExtra";
      #echo "nix-ld-vscode: running bashrcExtra";
      #echo "nix-ld-vscode: printing environment";
      #env;
      if [[ $- == *i* ]]; then 
         is_interactive=1;
      else
         is_interactive=0;
      fi;
      if [[ "$is_vscode" == "1" && "$is_interactive" == 0 ]]; then
        #export NIX_LD_VSCODE_TRACE="$NIX_LD_VSCODE_TRACE:vscode_noninteractive";
        echo "nix-ld-vscode: detected a vscode non-interactive session";
        export NIX_LD_LIBRARY_PATH=${nix_ld_library_path_val};
        export NIX_LD=$(cat ${nix_ld_path_file});
      fi
      if [[ $TERM_PROGRAM == "vscode" ]]; then
        #export NIX_LD_VSCODE_TRACE="$NIX_LD_VSCODE_TRACE:vscode_interactive";
        echo "nix-ld-vscode: detected a vscode interactive session";
        unset NIX_LD;
        unset NIX_LD_LIBRARY_PATH;
        unset LD_LIBRARY_PATH;
      fi
      '';
    logoutExtra = ''
      #echo "nix-ld-vscode: running logoutExtra";
      '';
  };  
}
