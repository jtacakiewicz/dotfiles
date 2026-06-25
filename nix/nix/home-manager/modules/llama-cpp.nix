{ pkgs, config, ... }:

let
    llama-port = 1147;
    llama-package = pkgs.llama-cpp.override { 
        cudaSupport = true; 
    };
    llama-ctl = pkgs.writeShellScriptBin "llama-ctl" ''
        case "$1" in
            start)
                if pgrep -f "llama-server" > /dev/null; then
                    echo "Llama server is already running."
                else
                    echo "Starting llama-cpp server with Qwen3.6..."
                    
                    ${llama-package}/bin/llama-server -m ${config.home.homeDirectory}/.cache/huggingface/Qwen3.6-35B-A3B-UD-Q2_K_XL.gguf -ngl 24 -c 81920 --flash-attn on --threads 8 --port ${toString llama-port} > /tmp/llama-server.log 2>&1 &
                    disown
                    echo "Server started in background. Logs are at /tmp/llama-server.log"
                fi
                ;;
                
            stop)
                if pgrep -f "llama-server" > /dev/null; then
                    echo "Stopping llama server..."
                    pkill -f "llama-server"
                    echo "Server stopped."
                else
                    echo "Llama server is not running."
                fi
                ;;
                
            *)
                echo "Usage: $0 {start|stop}"
                exit 1
                ;;
        esac
    '';
in
{
    home.packages = [
        llama-package
        llama-ctl
    ];
    programs.opencode = {
        enable = true;
        settings = {
            plugin = [ "opencode-models-discovery-wz@latest" ];
            provider = {
                llamacpp = {
                    npm = "@ai-sdk/openai-compatible";
                    name = "Local llama.cpp";
                    options = {
                        baseURL = "http://localhost:${toString llama-port}/v1";
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

