# nix-ld-vscode
This project is a Nix Home Manager module that allows a WSL NixOS system to be used as a Visual Studio Code remote.

Vscode is problematic in NixOS because it copies binaries to the remote system and then expects them to run. NixOS has different conventions for the interpreter location and how RPATH entries are used to resolve dlls than most linux distributions.

This project uses [nix-ld](https://github.com/Mic92/nix-ld) to run those binaries without patching them.

## Usage

## Remote System Configuration Setup

1. Enable nix-ld. In NixOS 22.05 and later, this can be done by placing `programs.nix-ld.enable = true;` in your config module (traditionally named `configuration.nix`).
2. (Only required for SSH remotes, not WSL remotes) Configure sshd to accept client requests to set the `is_vscode` environment variable. This can be done by putting 
```
services.openssh.extraConfig = ''
    AcceptEnv is_vscode
    '';
```
into your config module.

## Remote Home Manager Setup

This project is a flake which outputs a Home Manager module to `nixosModules.default`, which is then used like any other Home Manager module.

In brief you must:
1. Declare this repo as an input in your Home Manager `flake.nix` file. 
2. Include this project's `nixosModules.default` output in the imports section of one of the modules making up your `home-manager` config.

## Local Setup

(Only required for ssh remotes, not WSL remotes.)

Your local vscode must be configured to request the remote ssh server to set the `is_vscode` environment variable to `1`. This can be accomplished by creating a new `~/.ssh/config_vscode` file with the following contents:
```
SetEnv is_vscode=1
Include C:\Users\scott\.ssh\config # change to match your normal config file
```
then selecting that as the SSH config file to use in vscode.

## Example Home Manager configs

`flake.nix`:
```
{
  inputs = {
    
    nix-ld-vscode = {
      url = "github:scottstephens/nix-ld-vscode/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # other inputs    
  };

  # other sections
}
```

`home.nix`:
```
{pkgs, config, nix-ld-vscode, ...}
{
    imports = [
        nix-ld-vscode.nixosModules.default
        # other imports
    ];

    # other sections
}
```
