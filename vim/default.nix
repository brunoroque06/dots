{ symlinkJoin, makeWrapper, vim_configurable, vimUtils, vimPlugins }:
let
  extraPackages = with vimPlugins;
    [
      ale
      gruvbox-community
      lightline-vim
      vim-commentary
      vim-polyglot
      vim-surround
    ];
  customRC = vimUtils.vimrcFile
    { 
      customRC = builtins.readFile ./vimrc;
      packages.mvc.start = extraPackages;
    };
in
symlinkJoin {
  name = "vim";
  buildInputs = [ makeWrapper ];
  paths = [ vim_configurable ];
  postBuild = ''wrapProgram "$out/bin/vim" --add-flags "-u ${customRC}"'';
}
