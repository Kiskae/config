{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations = {
    cetoddle = inputs.nixpkgs.lib.nixosSystem {
      modules = let
        nixosHardware = inputs.nixos-hardware.nixosModules;
        srvos = inputs.srvos.nixosModules;
      in [
        nixosHardware.common-cpu-intel
        nixosHardware.common-pc-ssd
        nixosHardware.common-pc
        srvos.desktop
        srvos.mixins-systemd-boot
        inputs.nixseparatedebuginfod.nixosModules.default
        ./cetoddle/configuration.nix
        ./cetoddle/direnv.nix
      ];
    };

    komala = inputs.nixpkgs.lib.nixosSystem {
      modules = [
        inputs.srvos.nixosModules.desktop
        inputs.nixos-wsl.nixosModules.wsl
        inputs.home-manager.nixosModules.home-manager
        ./komala/configuration.nix
      ];
    };

    yubikey = inputs.nixpkgs.lib.nixosSystem {
      modules = [
        ./yubikey.nix
        ({modulesPath, ...}: {
          imports = [
            "${modulesPath}/installer/cd-dvd/installation-cd-graphical-calamares-gnome.nix"
          ];
        })
        {
          nixpkgs.hostPlatform = "x86_64-linux";
        }
      ];
    };
  };
}
