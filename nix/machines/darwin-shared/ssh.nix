{
  # Git signs with the agent's key, so load it before the first SSH connection
  launchd.user.agents.ssh-add.serviceConfig = {
    ProgramArguments = [
      "/usr/bin/ssh-add"
      "-q"
      "--apple-load-keychain"
    ];
    RunAtLoad = true;
  };
}
