{ lib, pkgs, ... }: {
  wsl = {
    enable = true;
    defaultUser = "kiskae";
    startMenuLaunchers = true;
  };

  networking.hostName = "komala";
  networking.useNetworkd = false;
  services.pipewire.enable = false;

  programs.nix-ld.enable = true;

  environment.systemPackages = with pkgs; [
    wslu
    wget
  ];

  system.stateVersion = "23.05";
  nixpkgs.hostPlatform = "x86_64-linux";

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.kiskae = import ./home.nix;
  };
}
