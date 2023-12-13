{
  description = "A very basic flake";

  inputs = {
    blank.url = "github:divnix/blank";
    nixpkgs.url = "nixpkgs/nixos-23.11";
#    nixpkgs.url = "github:Kiskae/nixpkgs/nixos-23.05";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-utils.url = "github:numtide/flake-utils";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nixseparatedebuginfod.url = "github:symphorien/nixseparatedebuginfod";
    nixseparatedebuginfod.inputs.nixpkgs.follows = "nixpkgs";
    nixseparatedebuginfod.inputs.flake-utils.follows = "flake-utils";
    srvos.url = "github:nix-community/srvos";
    srvos.inputs.nixpkgs.follows = "nixpkgs";
    srvos.inputs."nixos-stable".follows = "blank";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";
    nixos-wsl.inputs.flake-utils.follows = "flake-utils";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];
      imports = [
        ./hosts/flake-module.nix
      ];
      perSystem = {
        pkgs,
        config,
        self',
        inputs',
        ...
      }: {
        packages = let
          inherit (inputs.nixpkgs) lib;
          overlay = self: super: {
            vkcube-test = self.writeShellScriptBin "run-test.sh" ''
              export VK_LOADER_DEBUG=driver
              exec \
                ${lib.getExe self.gamescope} -w 1920 -h 1080 -i --rt -- \
                env \
                VK_ICD_FILENAMES=$(find ${self.mesa.drivers} -name 'intel_icd*') \
                ${self.vulkan-tools}/bin/vkcube
            '';
          };
          pkgs = inputs'.nixpkgs.legacyPackages.extend overlay;
        in {
          inherit (pkgs) vkcube-test;
          derp = pkgs.runCommand "break-ca" {} ''
            mkdir -p $out
            touch $out/$(basename $out)
            touch $out/$(basename $out | head -c 5)
            touch $out/$(basename $out | head -c 5)zzz
            ls -la $out
          '';
        };
      };
    };
}
