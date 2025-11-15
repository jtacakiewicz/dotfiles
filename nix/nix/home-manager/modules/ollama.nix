{ pkgs, ... }:

{
    home.packages = [
        pkgs.ollama-cuda
    ];
    systemd.user.services.ollama-serve = {
        Unit = {
            Description = "ollama serve";
        };
        Install = {
            WantedBy = [ "default.target" ];
        };
        Service = {
            ExecStart = "${pkgs.writeShellScript "ollama-serve-start" ''
                ${pkgs.ollama}/bin/ollama serve
            ''}";
        };
        # Optionally you can specify other settings like environment variables, working directory, etc.
    };
}

