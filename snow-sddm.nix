{ lib
, stdenv
, fetchFromGitHub
, qtgraphicaleffects
, themeConfig ? { }
}:
let
  customToString = x: if builtins.isBool x then lib.boolToString x else toString x;
  configLines = lib.mapAttrsToList (name: value: lib.nameValuePair name value) themeConfig;
  configureTheme = "cp theme.conf theme.conf.orig \n" +
    (lib.concatMapStringsSep "\n"
      (configLine:
        "grep -q '^${configLine.name}=' theme.conf || echo '${configLine.name}=' >> \"$1\"\n" +
          "sed -i -e 's/^${configLine.name}=.*$/${configLine.name}=${
        lib.escape [ "/" "&" "\\"] (customToString configLine.value)
      }/' theme.conf"
      )
      configLines);
in
stdenv.mkDerivation {
  pname = "sddm-snow";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "MrSn0wy";
    repo = "sddm-snow";
    rev = "a27bc2aceefcdc8cc1731560f032a6bc537133f2";
    sha256 = "9+70l1ULzL+/E2rqpTGn2i/HCeg0Tm5RotVNlbrCyQU=";
  };

  propagatedBuildInputs = [
    qtgraphicaleffects
  ];

  dontWrapQtApps = true;

  preInstall = configureTheme;

  postInstall = ''
    mkdir -p $out/share/sddm/themes/snow

    mv * $out/share/sddm/themes/snow/
    # echo '
    # [General]
    # background=/mnt/SnowData/snowy/Pictures/contents/images_dark/1920x1080.png

    # ScreenWidth=1920
    # ScreenHeight=1080

    # blur=true
    # recursiveBlurLoops=4
    # recursiveBlurRadius=5

    # PasswordFieldOutlined=false

    # PowerIconSize=
    # FontPointSize=
    # AvatarPixelSize=

    # translationReboot=
    # translationSuspend=
    # translationPowerOff=
    # ' > $out/share/sddm/themes/chili/theme.conf


    # echo '
    # [General]
    # background=assets/background.jpg

    # ScreenWidth=1440
    # ScreenHeight=900

    # blur=true
    # recursiveBlurLoops=4
    # recursiveBlurRadius=15

    # PasswordFieldOutlined=false

    # PowerIconSize=
    # FontPointSize=
    # AvatarPixelSize=

    # translationReboot=
    # translationSuspend=
    # translationPowerOff=
    # ' > $out/share/sddm/themes/chili/theme.conf

    # cp /mnt/SnowData/snowy/Pictures/contents/images_dark/1920x1080.png $out/share/sddm/themes/chili/assets/
    # mv $out/share/sddm/themes/chili/assets/1920x1080.png  $out/share/sddm/themes/chili/assets/background.png 
  '';

  postFixup = ''
    mkdir -p $out/nix-support

    echo ${qtgraphicaleffects} >> $out/nix-support/propagated-user-env-packages
  '';
  meta = with lib; {
    license = licenses.gpl3;
    maintainers = with lib.maintainers; [ MrSn0wy ];
    homepage = "https://github.com/MrSn0wy/sddm-snow/blob/master/theme.conf";
    description = "The snow login theme for SDDM";
    longDescription = ''
      A customized version of sddm-chili, mostly intended for me but feel free to use it! 
    '';
  };
}