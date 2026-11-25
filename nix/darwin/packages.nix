{ pkgs, ... }:

{
  # Linux runs containers natively, macOS needs a VM
  environment.systemPackages = with pkgs; [
    colima
    docker-client
  ];
}
