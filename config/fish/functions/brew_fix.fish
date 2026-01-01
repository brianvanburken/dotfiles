function brew_fix -d "Resets homebrew and cleans up junk"
    brew update-reset;
    brew doctor;
    brew autoremove;
    brew cleanup -s;

    rm -rf $(brew --cache)/;
    mkdir $(brew --cache)/;

    rm -rf $(brew --prefix)/var/homebrew/locks/;
    mkdir $(brew --prefix)/var/homebrew/locks/;

    sudo chown -R $(whoami) $(brew --prefix)/*;
end
