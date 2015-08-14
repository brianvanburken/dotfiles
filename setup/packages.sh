#!/bin/sh

if [ ! -f /usr/local/bin/brew ]
then
  echo "Installing: brew"
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  brew update
  brew upgrade
else
  echo "Found: brew"
fi

if [ ! -f /usr/local/bin/git ]
then
  echo "Installing: git"
  brew install git
else
  echo "Found: git"
fi

if [ ! -f /usr/local/bin/node ]
then
  echo "Installing: node"
  brew install node
else
  echo "Found: node"
fi

if [ ! -f /usr/local/bin/ag ]
then
  echo "Installing: the_silver_searcher"
  brew install ag
else
  echo "Found: the_silver_searcher"
fi

if [ ! -e /usr/local/bin/sqlite* ]
then
  echo "Installing: sqlite"
  brew install sqlite
else
  echo "Found: sqlite"
fi

if [ ! -e /usr/local/bin/postgres ]
then
  echo "Installing: postgres"
  brew install postgresql --without-ossp-uuid
  initdb /usr/local/var/postgres -E utf8
  mkdir -p ~/Library/LaunchAgents
  cp `brew --prefix postgres`/homebrew.mxcl.postgresql.plist ~/Library/LaunchAgents/
  launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist
else
  echo "Found: postgres"
fi

if [ ! -e /usr/local/bin/redis ]
then
  echo "Installing: redis"
  brew install redis
  mkdir -p ~/Library/LaunchAgents
  cp `brew --prefix redis`/homebrew.mxcl.redis.plist ~/Library/LaunchAgents/
  launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.redis.plist
else
  echo "Found: redis"
fi

if [ ! -e /usr/local/bin/memcached ]
then
  echo "Installing: memcached"
  brew install memcached
  mkdir -p ~/Library/LaunchAgents
  cp `brew --prefix memcached`/homebrew.mxcl.memcahed.plist ~/Library/LaunchAgents/
  launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.memcached.plist
else
  echo "Found: memcached"
fi

if [ ! -e /usr/local/bin/mongodb ]
then
  echo "Installing: mongodb"
  brew install mongodb
  mkdir -p ~/Library/LaunchAgents
  cp `brew --prefix mongodb`/homebrew.mxcl.mongodb.plist ~/Library/LaunchAgents/
  launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.mongodb.plist
else
  echo "Found: mongodb"
fi

if [ ! `which rbenv` ]
then
  echo "Installing: rbenv"
  brew install rbenv ruby-build
else
  echo "Found: rbenv"
fi

if [ ! `which csslint` ]
then
  echo "Installing: CSSLint"
  npm install -g csslint
else
  echo "Found: CSSLint"
fi

if [ ! `which jshint` ]
then
  echo "Installing: JSHint"
  npm install -g jshint
else
  echo "Found: JSHint"
fi

if [ ! `which csscomb` ]
then
  echo "Installing: CSSComb"
  npm install -g csscomb
else
  echo "Found: CSSComb"
fi

if [ ! `which ember` ]
then
  echo "Installing: Ember"
  npm install -g ember-cli
else
  echo "Found: Ember"
fi

if [ ! `which bower` ]
then
  echo "Installing: Bower"
  npm install -g bower
else
  echo "Found: Bower"
fi

if [ ! `which gulp` ]
then
  echo "Installing: Gulp"
  npm install -g gulp
else
  echo "Found: Gulp"
fi

if [ ! `which git` ]
then
  echo "Configuring: git"
  echo -n "Would you like to configure your git name and email? (y/n) => "; read answer
  if [[ $answer = "Y" ]] || [[ $answer = "y" ]]; then
      echo -n "What is your git user name => "; read name
      git config --global user.name "$name"
      echo -n "What is your git email => "; read email
      git config --global user.email "$email"
      git config --gloabl push.default current
  fi
fi

echo "Cleanup"
brew prune
brew cleanup

echo "Done with packages!"
