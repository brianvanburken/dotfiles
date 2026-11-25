{ pkgs, ... }:

{
  environment.variables.EDITOR = "nvim";

  environment.systemPackages = with pkgs; [
    colima
    delta
    docker-client
    exercism
    eza
    fd
    ffmpeg
    gh
    git
    gitleaks
    hyperfine
    jq
    mise
    neovim
    ripgrep
    tree-sitter
    wget
    xq-xml
    yq-go
    yt-dlp
    zoxide
  ];
}
