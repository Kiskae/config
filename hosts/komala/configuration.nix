{ lib, pkgs, ... }: {
  wsl = {
    enable = true;
    wslConf = {
      automount.root = "/mnt";
    };
    defaultUser = "kiskae";
    startMenuLaunchers = true;

    nativeSystemd = true;
  };

  networking.hostName = "komala";
  networking.useNetworkd = false;
  services.pipewire.enable = false;

  environment.systemPackages = [
    pkgs.wslu
  ];

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  system.stateVersion = "23.05";
  nixpkgs.hostPlatform = "x86_64-linux";

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.kiskae = import ./home.nix;
  };
}