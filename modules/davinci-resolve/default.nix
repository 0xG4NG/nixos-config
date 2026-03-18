{ pkgs, ... }:

{
  # DaVinci Resolve con workarounds para RDNA 4 (gfx1201)
  # - Rusticl (Mesa OpenCL) en lugar de ROCm OpenCL
  # - Stub de libProResRAW.so para evitar crash ABI con GCC 15

  environment.systemPackages = [
    # DaVinci Resolve: stub de libProResRAW.so en LD_LIBRARY_PATH para evitar
    # crash ABI de std::filesystem (libProResRAW.so compilada con GCC viejo, incompatible con GCC 15)
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
    in pkgs.writeShellScriptBin "davinci-resolve" ''
      export LD_LIBRARY_PATH="${proResStub}/lib''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
      exec ${pkgs.davinci-resolve}/bin/davinci-resolve "$@"
    '')
    pkgs.clinfo
  ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      # Rusticl: OpenCL de Mesa, soporta RDNA 4 nativamente
      mesa.opencl
      # ROCm para HIP (btop-rocm, etc.) — sin .icd para evitar conflicto con Rusticl
      rocmPackages.clr
      rocmPackages.rocm-runtime
    ];
  };

  # ROCm: symlink para HIP
  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];

  environment.variables = {
    # Activar Rusticl para OpenCL con el driver radeonsi
    RUSTICL_ENABLE = "radeonsi";
    # Forzar ruta de ICD OpenCL (accesible dentro del sandbox bwrap de DaVinci)
    OCL_ICD_VENDORS = "/run/opengl-driver/etc/OpenCL/vendors";
    # Override GFX version para ROCm/HIP (btop-rocm, etc.)
    HSA_OVERRIDE_GFX_VERSION = "11.0.0";
  };
}
