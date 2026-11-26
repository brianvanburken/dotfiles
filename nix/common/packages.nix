{ pkgs, ... }:

{
  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  environment.systemPackages = with pkgs; [
    delta
    eza
    fd
    ffmpeg
    gh
    git
    gitleaks
    hyperfine
    jq
    ripgrep
    wget
    xq-xml
    yq-go
    yt-dlp
    zoxide
  ];
}
