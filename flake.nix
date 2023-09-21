{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.05";
#    nixpkgs.url = "github:Kiskae/nixpkgs/nixos-23.05";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nixseparatedebuginfod.url = "github:symphorien/nixseparatedebuginfod";
    nixseparatedebuginfod.inputs.nixpkgs.follows = "nixpkgs";
    srvos.url = "github:numtide/srvos";
    srvos.inputs.nixpkgs.follows = "nixpkgs";
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
