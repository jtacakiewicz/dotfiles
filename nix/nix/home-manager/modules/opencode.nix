{ config, pkgs, ... }:

let
    skills = pkgs.stdenvNoCC.mkDerivation {
        name = "opencode-skills";
        src = ./assets/skills;
        installPhase = "cp -r --no-preserve=mode,ownership $src $out";
    };
in
{
    xdg.configFile."opencode/skills".source = skills;
    programs.opencode = {
        enable = true;
        settings = {
            plugin = [ "opencode-models-discovery-wz@latest" ];
            provider = {
                llamacpp = {
                    npm = "@ai-sdk/openai-compatible";
                    name = "Local llama.cpp";
                    options = {
                        baseURL = "http://localhost:1147/v1";
                    };
                    models = {
                        qwen36 = {
                            name = "Qwen3.6 (local)";
                        };
                    };
                };
            };
            permission = {
                external_directory = {
                  "${config.home.homeDirectory}/opencode/**" = "allow";
                  "${config.home.homeDirectory}/.config/**" = "allow";
                  "${config.home.homeDirectory}/.dotfiles/**" = "allow";
                  "*" = "deny";
                };
            };
        };
    };
}
