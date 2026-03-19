{
  pkgs,
  lib,
  lib',
  ...
}:
let
  inherit (lib.attrsets) attrsToList concatMapAttrs;
  inherit (lib.lists) findFirst;
  inherit (lib.strings) replaceString;
  inherit (lib') filterFileTypes getFileBaseNameWithoutExtension getItemsFromDir;

  formatVersion = ver: replaceString "." "_" ver;

  rootComponent = path: builtins.head (builtins.split "/" path);

  extractModpack =
    path:
    pkgs.runCommand "extracted-modpack-${path}" { nativeBuildInputs = with pkgs; [ unzip ]; } ''
      		cd $out
      		unzip ${path}
      	'';

  modpacks = map (modpackFile: {
    name = "${getFileBaseNameWithoutExtension modpackFile}";
    value = extractModpack modpackFile;
  }) (filterFileTypes [ "zip" "mrpack" ] (getItemsFromDir "regular" ./minecraftModpacks));

  mkServer =
    modpack: extraAttrs:
    let

      index = lib.importJSON "${modpack}/modrinth-index.json";

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
    in
    {
      jvmOpts = "-Xmx4G -Xms2G -Djava.net.preferIPv4Stack=true";
      package = serverPackage;
      symlinks.mods = pkgs.linkFarmFromDrvs "mods" (
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
      persistentFiles = modpack;
    }
    // extraAttrs;
in
{
  services.minecraft-servers = {
    enable = true;
    eula = true;
    openFirewall = true;
    servers = builtins.mapAttrs (name: modpack: mkServer modpack { enable = true; }) (
      builtins.listToAttrs modpacks
    );
  };
}
