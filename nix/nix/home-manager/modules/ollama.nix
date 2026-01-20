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
                ${pkgs.ollama-cuda}/bin/ollama serve
            ''}";
            Environment = [
                "OLLAMA_GPU=1"
                "CUDA_VISIBLE_DEVICES=0"
            ];
            Restart = "on-failure";
        };
    };
}

