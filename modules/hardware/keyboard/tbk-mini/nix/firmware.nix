{ keymapSrc }:

let
  keyboard   = "bastardkb/tbkmini/v2/splinky_3";
  keymapDir  = "bastardkb/tbkmini/keymaps";
  keymapName = "g4ng";

  qmkRev  = "df7378eb3bab077d450f46cb21a58bf903a0b3cb";
  qmkHash = "sha256-4zOr1SPhFI1gOlIhs4IVNJm7iEE5l9CAu+9xrJbmF48=";
in

{ pkgs }:

let
  qmkFirmware = pkgs.fetchFromGitHub {
    owner           = "vial-kb";
    repo            = "vial-qmk";
    rev             = qmkRev;
    fetchSubmodules = true;
    hash            = qmkHash;
  };
in

pkgs.stdenv.mkDerivation {
  pname   = "tbk-mini-firmware";
  version = "0.1.0";

  src = qmkFirmware;

  nativeBuildInputs = with pkgs; [
    qmk
    python3
    git
    which
  ];

  dontConfigure          = true;
  dontFixup              = true;
  enableParallelBuilding = true;

  unpackPhase = ''
    runHook preUnpack
    cp -r $src qmk_firmware
    chmod -R u+w qmk_firmware
    cd qmk_firmware
    runHook postUnpack
  '';

  postPatch = ''
    rm -rf keyboards/${keymapDir}/${keymapName}
    mkdir -p keyboards/${keymapDir}/${keymapName}
    cp -r ${keymapSrc}/. keyboards/${keymapDir}/${keymapName}/
    chmod -R u+w keyboards/${keymapDir}/${keymapName}

    substituteInPlace builddefs/common_rules.mk \
      --replace-warn '>/dev/null 2>&1' ""

    patchShebangs util/uf2conv.py
  '';

  buildPhase = ''
    runHook preBuild
    export PATH="${pkgs.gcc-arm-embedded-13}/bin:$PATH"
    export HOME=$TMPDIR
    export SKIP_GIT=yes
    export SKIP_VERSION=yes
    make -j$NIX_BUILD_CORES ${keyboard}:${keymapName}
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    shopt -s nullglob
    for f in *.uf2 *.hex *.bin; do
      cp "$f" $out/
    done
    shopt -u nullglob
    if [ -z "$(ls -A $out)" ]; then
      echo "No firmware artifact was produced" >&2
      exit 1
    fi
    runHook postInstall
  '';
}
