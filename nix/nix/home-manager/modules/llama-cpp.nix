{ pkgs, config, ... }:

let
    llama-port = 1147;
    llama-variant = "Qwen3.6-35B-A3B-UD-Q4_K_XL.gguf";
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
                
                sudo true
                
                sudo sh -c "ulimit -l unlimited && exec sudo -u $USER ${llama-package}/bin/llama-server \
                  -m ${config.home.homeDirectory}/.cache/llama.cpp/${llama-variant} \
                  --port ${toString llama-port} \
                  -fitt 1536 \
                  -c 262144 \
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
                  --chat-template-kwargs '{\"preserve_thinking\": true}' \
                  --temp 0.6 \
                  --top-p 0.95 \
                  --top-k 20 \
                  --min-p 0.0 \
                  --presence-penalty 0.0 \
                  --repeat-penalty 1.0" > /tmp/llama-server.log 2>&1 &
                
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
}

