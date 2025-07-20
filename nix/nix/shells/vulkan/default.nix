with import <nixpkgs> {};

mkShell {
    name = "vulkan";
    packages = [
        glm
        glfw
        freetype
        vulkan-headers
        vulkan-loader
        vulkan-validation-layers
        vulkan-tools        # vulkaninfo
        shaderc             # GLSL to SPIRV compiler - glslc
        glslang
        renderdoc           # Graphics debugger
        tracy               # Graphics profiler
        vulkan-tools-lunarg # vkconfig
        valgrind
        kdePackages.kcachegrind
    ];

    buildInputs = with pkgs; [
        systemd
        libvorbis.dev
        libogg.dev
        xorg.libX11
        xorg.libX11.dev
        xorg.libXext
        xorg.libXext.dev
        xorg.libXrandr
        xorg.libXrandr.dev
        xorg.libXi
        xorg.libXi.dev
        xorg.libXcursor
        xorg.libXcursor.dev
        xorg.libXinerama
        xorg.libXinerama.dev
        xorg.libXrender
        xorg.libXrender.dev
        xorg.libXfixes
        xorg.libXfixes.dev
        mesa.dev
        libGL
        libGLU
        glm
        glfw
        sfml
        csfml
        freetype
        vulkan-loader
    ];

    LD_LIBRARY_PATH = "${pkgs.vulkan-loader}/lib:${pkgs.glfw}/lib/cmake";
    VULKAN_SDK = "${vulkan-headers}";
    VK_LAYER_PATH = "${vulkan-validation-layers}/share/vulkan/explicit_layer.d";
    SFML_PATH = "${sfml}/lib/cmake";
    shellHook = ''
        # Prepend or append directories to the PATH
        export PATH="$PATH:$LD_LIBRARY_PATH:$SFML_PATH:${pkgs.xorg.libX11.dev}/lib/pkgconfig:${pkgs.libGL}/lib"
    '';
}
