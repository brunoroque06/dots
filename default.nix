let
  pkgs = import ./nixpkgs {};
  
  tmux = import ./tmux (with pkgs;
    { inherit
        symlinkJoin
        makeWrapper
        ;
      tmux = pkgs.tmux;
    });
  
  vim = import ./vim (with pkgs;
    { inherit
        symlinkJoin
        makeWrapper
        vim_configurable
        vimUtils
        vimPlugins
        ;
    });

  packages =
    [
    tmux
    vim

    pkgs.bash
    pkgs.bat
    pkgs.exa
    pkgs.fd
    pkgs.fish
    pkgs.git
    pkgs.git-lfs
    pkgs.gitAndTools.delta
    pkgs.go_1_15
    pkgs.jq
    pkgs.lazygit
    pkgs.lf
    pkgs.nodejs-13_x
    pkgs.pgcli
    pkgs.postgresql_10
    pkgs.python38
    pkgs.python38Packages.pylint
    pkgs.python38Packages.black
    pkgs.python38Packages.pre-commit
    pkgs.ripgrep
    pkgs.ruby
    pkgs.shellcheck
    pkgs.shfmt
    pkgs.starship
    pkgs.stow
    pkgs.yarn
    ];

in packages
