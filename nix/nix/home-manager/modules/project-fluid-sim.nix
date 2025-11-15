{
    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
        fluid-sim-gen = {
            url = "git+https://github.com/jtacakiewicz/flip-fluid-parallel";
            flake = false;
        };
    };
    outputs = { pkgs, ... }@inputs: let
        forEachSystem = pkgs.lib.genAttrs pkgs.lib.platforms.all;
        gcc12 = pkgs.gcc12;
        sfmlWithGcc12 = pkgs.sfml.overrideAttrs (old: {
            nativeBuildInputs = old.nativeBuildInputs ++ [ pkgs.gcc12 ];
            CXX = "${pkgs.gcc12}/bin/g++";
            CC  = "${pkgs.gcc12}/bin/gcc";
        });
        APPNAME = "fluid-sim";
        appdrv = { stdenv, fluid-sim-gen, cmake, freetype, libpng }:
            stdenv.mkDerivation {
                name = APPNAME;
                src = fluid-sim-gen; # <- put your fetch here, add fetchSubmodules = true;
                nativeBuildInputs = [
                    cmake 
                ];
                buildInputs = with pkgs; [ 
                    freetype 
                    libpng 
                    cudaPackages.cuda_cudart
                    cudaPackages.cuda_nvcc
                    cudaPackages.cuda_cccl
                    cudaPackages.cudatoolkit
                    cudaPackages.cuda_nvprof
                    cudaPackages.cuda_nvvp
                    jdk8
                    linuxPackages.nvidia_x11
                    gcc12
                    libGLU libGL
                    glm
                    glfw
                    sfmlWithGcc12
                    freetype
                    vulkan-loader
                    pkg-config
                    xorg.libX11
                    xorg.libXrandr
                    xorg.libXinerama
                    xorg.libXcursor
                    xorg.libXi
                    cmake
                    libvorbis
                    flac

                ];
                installPhase = ''
                    export SFML_PATH=${sfmlWithGcc12}/lib/cmake
                    export JAVA_HOME=${pkgs.jdk8}
                    export CC=${pkgs.gcc12}/bin/gcc
                    export CXX=${pkgs.gcc12}/bin/g++

                    export CUDAHOSTCXX=${pkgs.gcc12}/bin/g++
                    export CUDA_HOST_COMPILER=${pkgs.gcc12}/bin/gcc

                    export CUDA_HOME=${pkgs.cudaPackages.cuda_cudart}
                    export CUDA_PATH=${pkgs.cudaPackages.cuda_cudart}
                    #
                    export LD_LIBRARY_PATH=${pkgs.cudaPackages.cuda_cudart}/lib64:${pkgs.cudaPackages.cuda_cudart}/lib:$LD_LIBRARY_PATH
                    export LD_LIBRARY_PATH=${stdenv.cc.cc.lib}/lib:$LD_LIBRARY_PATH
                    export LD_LIBRARY_PATH=${pkgs.linuxPackages.nvidia_x11}/lib:$LD_LIBRARY_PATH
                    export LD_LIBRARY_PATH="$JAVA_HOME/lib:$JAVA_HOME/lib/server:$LD_LIBRARY_PATH"
                    export LD_LIBRARY_PATH=${pkgs.libvorbis}/lib:$LD_LIBRARY_PATH
                    export LD_LIBRARY_PATH=${pkgs.flac}/lib:$LD_LIBRARY_PATH

                    export LIBRARY_PATH=${pkgs.cudaPackages.cuda_cudart}/lib64:${pkgs.cudaPackages.cuda_cudart}/lib:$LIBRARY_PATH
                    export PATH=$SFML_PATH/bin:$PATH
                    mkdir build
                '';
            };
        appOverlay = final: prev: {
            ${APPNAME} = final.callPackage appdrv { inherit (inputs) fluid-sim-gen; };
        };
    in {
        overlays.default = appOverlay;
        packages = forEachSystem (system: let
            pkgs = import pkgs { inherit system; overlays = [ appOverlay ]; };
        in{
            default = pkgs.${APPNAME};
        });
    };
}
