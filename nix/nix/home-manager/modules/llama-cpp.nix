{ pkgs, config, ... }:

let
  llama-port = 1147;
  llama-variant = "Qwen3.6-35B-A3B-UD-Q4_K_XL.gguf";

  llama-package = pkgs.llama-cpp.override {
    cudaSupport = true;
  };
in
{
  home.packages = [
    llama-package
  ];

  systemd.user.services.llama-server = {
    Unit = {
      Description = "llama.cpp server";
      After = [ "default.target" ];
    };

    Service = {
      ExecStart = ''
        ${llama-package}/bin/llama-server \
          -m ${config.home.homeDirectory}/.cache/llama.cpp/${llama-variant} \
          --port ${toString llama-port} \
          -fitt 1536 \
          -c 131072 \
          -n 32768 \
          -fa on \
          -np 1 \
          -ctk q8_0 \
          -ctv q8_0 \
          -ctkd q8_0 \
          -ctvd q8_0 \
          -ctxcp 64 \
          --no-mmap \
          --mlock \
          --no-warmup \
          --spec-type draft-mtp \
          --spec-draft-n-max 2 \
          --chat-template-kwargs '{"preserve_thinking": true}' \
          --temp 0.6 \
          --top-p 0.95 \
          --top-k 20 \
          --min-p 0.0 \
          --presence-penalty 0.0 \
          --repeat-penalty 1.0
      '';

      Restart = "on-failure";
      RestartSec = 5;

      # Equivalent to `ulimit -l unlimited`
      LimitMEMLOCK = "infinity";

      WorkingDirectory = config.home.homeDirectory;

      StandardOutput = "journal";
      StandardError = "journal";
    };

    Install = {
      WantedBy = [ ];
    };
  };
}
