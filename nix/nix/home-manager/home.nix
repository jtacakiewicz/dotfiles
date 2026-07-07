{ pkgs, inputs, home-manager }:
let
  mkHome = { pkgs, mods ? [], user ? "", homeDir ? "" }:
    home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = { inherit inputs user homeDir; };
      modules = [ ./common.nix ] ++ mods;
    };
in
{
    ogisui = mkHome { 
        pkgs=pkgs;
        mods=[
            ./common-gui.nix
            ./ogisui.nix
        ];
        user = "jamjan";
        homeDir = "/home/jamjan"; 
    };

    darwin = mkHome {
        pkgs=pkgs;
        mods=[
            ./common-gui.nix
            ./macos.nix
        ];
        user = "epi";
        homeDir = "/Users/epi";
    };

    truncatum = mkHome {
        pkgs=pkgs;
        mods=[
            ./truncatum.nix
        ];
        user = "jamjan";
        homeDir = "/home/jamjan";
    };
}

