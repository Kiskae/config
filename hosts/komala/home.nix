{pkgs, ...}: {
  programs.gh.enable = true;

  programs.git = {
    enable = true;
    userName = "Kiskae";
    userEmail = "Kiskae@users.noreply.github.com";
  };

  home.file.".vscode-server/server-env-setup".source = ./server-env-setup.sh;
  home.stateVersion = "23.05";
}
