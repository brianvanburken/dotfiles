{ pkgs, ... }:

{
  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  environment.systemPackages = with pkgs; [
    colima
    delta
    docker-client
    eza
    fd
    ffmpeg
    gh
    git
    gitleaks
    hyperfine
    jq
    mise
    ripgrep
    tree-sitter
    wget
    xq-xml
    yq-go
    yt-dlp
    zoxide
  ];
}
