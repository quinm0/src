{ lib
, stdenv
, stdenvNoCC
, fetchurl
, dpkg
, autoPatchelfHook
, makeWrapper
, libusb1
, pulseaudio
, xdotool
, dbus
, zlib
, udev
, xorg
}:

stdenvNoCC.mkDerivation rec {
  pname = "pcpanel";
  version = "2.0.95";

  src = fetchurl {
    # Adjust this if the release uses a different tag or filename.
    url = "https://github.com/nvdweem/PCPanel/releases/download/v${version}/pcpanel_${version}_amd64.deb";
    hash = "sha256-UwokNny/oUCFL0alQiHMsXG6qnACDOjsmWQ/WNeSOJU=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    libusb1
    dbus
    zlib
    udev

    # libgcc_s.so.1
    stdenv.cc.cc.lib

    # Java AWT/X11 dependencies
    xorg.libX11
    xorg.libXext
    xorg.libXi
    xorg.libXrender
    xorg.libXtst
  ];

  dontConfigure = true;
  dontBuild = true;

  unpackPhase = ''
    runHook preUnpack

    mkdir extracted
    dpkg-deb -x "$src" extracted

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/opt/pcpanel"
    cp -r extracted/opt/pcpanel/. "$out/opt/pcpanel/"

    mkdir -p "$out/bin"
    ln -s "$out/opt/pcpanel/PCPanel" "$out/bin/pcpanel"

    # Install udev rules regardless of whether the Debian package
    # places them under /lib or /usr/lib.
    mkdir -p "$out/lib/udev/rules.d"

    for rulesDir in \
      extracted/lib/udev/rules.d \
      extracted/usr/lib/udev/rules.d
    do
      if [ -d "$rulesDir" ]; then
        find "$rulesDir" \
          -maxdepth 1 \
          -type f \
          -name '*.rules' \
          -exec cp {} "$out/lib/udev/rules.d/" \;
      fi
    done

    # Install desktop entries, if provided.
    if [ -d extracted/usr/share/applications ]; then
      mkdir -p "$out/share/applications"

      cp extracted/usr/share/applications/*.desktop \
        "$out/share/applications/" || true

      for desktopFile in "$out"/share/applications/*.desktop; do
        [ -e "$desktopFile" ] || continue

        # Point the desktop entry at the Nix-installed executable.
        sed -i \
          "s|^Exec=.*|Exec=$out/bin/pcpanel|" \
          "$desktopFile"

        # Fix TryExec if the desktop entry contains it.
        sed -i \
          "s|^TryExec=.*|TryExec=$out/bin/pcpanel|" \
          "$desktopFile"
      done
    fi

    # Make pactl and xdotool available to PCPanel.
    wrapProgram "$out/opt/pcpanel/PCPanel" \
      --prefix PATH : ${lib.makeBinPath [
        pulseaudio
        xdotool
      ]} \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [
        udev
      ]}

    runHook postInstall
  '';

  meta = {
    description = "Control PCPanel hardware on Linux";
    homepage = "https://github.com/nvdweem/PCPanel";
    license = lib.licenses.mit;
    mainProgram = "pcpanel";
    platforms = [ "x86_64-linux" ];
  };
}
