{ pkgs, ... }: {
  programs.gh.enable = true;

  programs.git = {
    enable = true;
    userName = "Kiskae";
    userEmail = "Kiskae@users.noreply.github.com";
  };

  home.file.".vscode-server/server-env-setup".source = pkgs.writeShellScript "setup-vs-env" ''
    . /etc/set-environment

    export NIX_LD=$(cat "${pkgs.stdenv.cc}/nix-support/dynamic-linker")
  '';
  
  home.stateVersion = "23.05";
}