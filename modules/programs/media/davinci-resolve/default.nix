{ pkgs, ... }:

{
  environment.systemPackages = [
    # Bundled libProResRAW.so exports _M_split_cmpts with old GCC ABI,
    # causing segfaults when Rusticl resolves it via symbol interposition.
    # This stub shadows it with no-op implementations.
    (let
      proResStub = pkgs.runCommand "libProResRAW-stub" {
        nativeBuildInputs = [ pkgs.gcc ];
      } ''
        mkdir -p $out/lib
        cat > stub.c << 'STUB'
        #include <stddef.h>
        #define S(name) void name() {}
        #define R(name) void* name() { return NULL; }
        #define I(name) int name() { return 0; }
        I(PRRawGetRawConversionPlugIns)
        I(PRRawGetRawConversionPlugInVersionMajor)
        I(PRRawGetRawConversionPlugInVersionMinor)
        R(PRRawGetRawConversionPlugInIdentifier)
        R(PRRawGetRawConversionPlugInName)
        R(PRRawGetRawConversionPlugInLoadingErrorInfo)
        I(PRRawIsRawConversionPlugInCompatibleWithClip)
        R(PRRawCreateDecoder) S(PRRawDestroyDecoder)
        R(PRRawCreateOpenCLProcessorForQueue) S(PRRawDestroyOpenCLProcessor)
        R(PRRawCreateCUDAProcessor) S(PRRawDestroyCUDAProcessor)
        I(PRRawDecodeFrame)
        I(PRRawOpenCLProcessFrame_Texture)
        I(PRRawCUDAProcessFrame_Texture)
        I(PRRawGetWidth) I(PRRawGetHeight)
        I(PRRawGetFrameHeaderMetadata)
        R(PRRawCreateRawImageMetadata) S(PRRawDestroyRawImageMetadata)
        I(PRRawImageMetadataGetWidth) I(PRRawImageMetadataGetHeight)
        I(PRRawImageMetadataGetBytesPerRow) I(PRRawImageBytesPerRowNeeded)
        R(PRRawCreateClipSettingsContext) S(PRRawDestroyClipSettingsContext)
        R(PRRawCreateClipSettingsRawConversionParams) S(PRRawDestroyClipSettingsRawConversionParams)
        I(PRRawGetSupportedSettings)
        I(PRRawGetSettingPropertyValue) I(PRRawGetSettingPropertyValueType)
        I(PRRawSetSettingCurrentValue)
        R(PRRawGetOutputColorSpecifier)
        I(PRRawGetArraySettingPropertyValue) I(PRRawGetArraySettingPropertyValueSize)
        R(PRRawCreateFloat32SettingPropertyValue) I(PRRawGetFloat32SettingPropertyValue)
        R(PRRawCreateInt32SettingPropertyValue) I(PRRawGetInt32SettingPropertyValue)
        R(PRRawCreateUInt32SettingPropertyValue) I(PRRawGetUInt32SettingPropertyValue)
        R(PRRawCreateBooleanSettingPropertyValue) I(PRRawGetBooleanSettingPropertyValue)
        R(PRRawCreateUTF8StringSettingPropertyValue)
        I(PRRawGetUTF8StringSettingPropertyValue) I(PRRawGetUTF8StringSettingPropertyValueLength)
        S(PRRawDestroySettingPropertyValue)
        R(PRRawMetadataDictionaryCreate) S(PRRawMetadataDictionaryDestroy)
        S(PRRawMetadataDictionaryAddFloat32Item)
        S(PRRawMetadataDictionaryAddUInt32Item)
        S(PRRawMetadataDictionaryAddUTF8StringItem)
        S(PRRawMetadataDictionaryAddBinaryDataItem)
        STUB
        gcc -shared -o $out/lib/libProResRAW.so stub.c
      '';
      wrapper = pkgs.writeShellScriptBin "davinci-resolve" ''
        export LD_LIBRARY_PATH="${proResStub}/lib''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
        exec ${pkgs.davinci-resolve}/bin/davinci-resolve "$@"
      '';
    in pkgs.symlinkJoin {
      name = "davinci-resolve-wrapped";
      paths = [ wrapper pkgs.davinci-resolve ];
    })
    pkgs.clinfo

    (pkgs.writeShellApplication {
      name = "davinci-import";
      runtimeInputs = [ pkgs.ffmpeg ];
      text = ''
        if [ $# -lt 1 ]; then
          echo "uso: davinci-import <entrada> [<entrada>...]" >&2
          echo "transcodifica a DNxHR HQ + PCM en MOV (legible por DaVinci Free)" >&2
          exit 1
        fi
        for src in "$@"; do
          if [ ! -f "$src" ]; then
            echo "archivo no encontrado: $src" >&2
            continue
          fi
          dst="''${src%.*}.dnxhr.mov"
          echo ">> $src -> $dst"
          ffmpeg -hide_banner -y -i "$src" \
            -c:v dnxhd -profile:v dnxhr_hq -pix_fmt yuv422p \
            -c:a pcm_s16le \
            "$dst"
        done
      '';
    })

    (pkgs.writeShellApplication {
      name = "davinci-export";
      runtimeInputs = [ pkgs.ffmpeg ];
      text = ''
        if [ $# -lt 1 ]; then
          echo "uso: davinci-export <render-de-davinci> [<render>...]" >&2
          echo "transcodifica DNxHR/ProRes MOV a MP4 H.264 + AAC reproducible" >&2
          exit 1
        fi
        for src in "$@"; do
          if [ ! -f "$src" ]; then
            echo "archivo no encontrado: $src" >&2
            continue
          fi
          dst="''${src%.*}.mp4"
          echo ">> $src -> $dst"
          ffmpeg -hide_banner -y -i "$src" \
            -c:v libx264 -preset slow -crf 18 -pix_fmt yuv420p \
            -c:a aac -b:a 192k \
            -movflags +faststart \
            "$dst"
        done
      '';
    })
  ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      mesa.opencl
      rocmPackages.clr
      rocmPackages.rocm-runtime
    ];
  };

  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];

  environment.variables = {
    RUSTICL_ENABLE = "radeonsi";
    OCL_ICD_VENDORS = "/run/opengl-driver/etc/OpenCL/vendors";
    HSA_OVERRIDE_GFX_VERSION = "11.0.0";
  };
}
