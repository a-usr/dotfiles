{
  pkgs,
  lib,
  lib',
  ...
}:
let
  inherit (lib.attrsets) attrsToList concatMapAttrs;
  inherit (lib.lists) findFirst;
  inherit (lib.strings) replaceString concatStringsSep;
  inherit (lib.fileset) toSource;
  inherit (lib')
    filterFileTypes
    getFileBaseNameWithoutExtension
    getBaseName
    getItemsFromDir
    ;

  formatVersion = ver: replaceString "." "_" ver;

  rootComponent = path: builtins.head (builtins.split "/" path);

  extractModpack =
    path: name:
    pkgs.runCommand "extracted-modpack-${name}"
      {
        nativeBuildInputs = with pkgs; [
          unzip
        ];

        src = toSource {
          root = ./minecraftModpacks;
          fileset = path;
        };
      }
      ''
        mkdir -p $out
        unzip $src/${getBaseName path} -d $out
      '';
  modpackSpecs = {
    createThing = {
      excludedFiles = [
        "mods/voxy-*"
        "shaderpacks"
      ];
    };
  };
  modpackBundles = (
    filterFileTypes [ "zip" "mrpack" ] (getItemsFromDir "regular" ./minecraftModpacks)
  );
  modpacks = builtins.mapAttrs (
    name: value:
    let
      bundle = builtins.head (
        builtins.filter (bundle: name == (getFileBaseNameWithoutExtension bundle)) modpackBundles
      );
    in
    {
      inherit name;
      files = extractModpack bundle name;
      settings = value;
    }
  ) modpackSpecs;

  mkServer =
    name: modpack: extraAttrs:
    let

      index = lib.importJSON "${modpack.files}/modrinth.index.json";

      modloader = findFirst (dep: dep.name != "minecraft") null (attrsToList index.dependencies);

      serverPackage =
        let
          type = if modloader != null then modloader.name else "vanilla";
          minecraftVersion = formatVersion index.dependencies.minecraft;
        in
        if type == "vanilla" then
          pkgs.minecraftServers."vanilla-${minecraftVersion}"
        else if type == "fabric-loader" then
          pkgs.minecraftServers."fabric-${minecraftVersion}".override {
            loaderVersion = modloader.value;
          }
        else if type == "neoforge" then
          pkgs.minecraftServers."neoforge-${minecraftVersion}-${formatVersion modloader.value}"
        else
          throw "unimplemented modloader: ${type}";

      mods = pkgs.linkFarmFromDrvs "mods" (
        map
          (
            mod:
            pkgs.fetchurl {
              url = builtins.head (mod.downloads);
              sha512 = mod.hashes.sha512;
            }
          )
          (
            builtins.filter (
              mod: (rootComponent mod.path) == "mods" && mod.env.server != "unsupported"
            ) index.files
          )
      );
      excludedFiles = concatStringsSep " " (
        map (exclude: "--exclude='${exclude}'") modpack.settings.excludedFiles
      );

      files = pkgs.runCommand "minecraft-server-${name}-files" { nativeBuildInputs = [ pkgs.rsync ]; } ''
        mkdir -p $out/mods
        for f in ${mods}/*; do
          cp "$f" "$out/mods/"
        done
        rsync -a ${excludedFiles} ${(modpack.files + "/overrides/*")} $out
      '';

    in
    {
      jvmOpts = "-Xmx4G -Xms2G -Djava.net.preferIPv4Stack=true";
      package = serverPackage;
      persistentFiles = files.outPath;
    }
    // extraAttrs;
in
{
  services.minecraft-servers = {
    enable = true;
    eula = true;
    openFirewall = true;
    servers = builtins.mapAttrs (name: modpack: mkServer name modpack { enable = true; }) modpacks;
  };
}
