{
  pkgs,
  lib,
  lib',
  ...
}:
let
  inherit (lib.attrsets) attrsToList;
  inherit (lib.lists) findFirst;
  inherit (lib.strings) replaceString;

  formatVersion = ver: replaceString "." "_" ver;

  modpacks = map (modpackFile: {
    name = "${lib'.getFileBaseNameWithoutExtension modpackFile}";
    value = lib.importJSON modpackFile;
  }) (lib'.getItemsFromDir "regular" ./minecraftModpacks);

  mkModpack =
    modpack: extraAttrs:
    let
      modloader =
        let
          unsanitized = findFirst (dep: dep.name != "minecraft") null (attrsToList modpack.dependencies);
        in
        if unsanitized != null then
          {
            type = "${replaceString "-loader" "" unsanitized.name}";
            version = unsanitized.value;
          }
        else
          null;

      serverPackage =
        let
          type = if modloader != null then modloader.type else "vanilla";
          minecraftVersion = formatVersion modpack.dependencies.minecraft;
        in
        if type == "vanilla" then
          pkgs.minecraftServers."vanilla-${minecraftVersion}"
        else if type == "fabric" then
          pkgs.minecraftServers."fabric-${minecraftVersion}".override {
            loaderVersion = modloader.version;
          }
        else
          throw "unimplemented modloader: ${type}";
    in
    {
      jvmOpts = "-Xmx4G -Xms2G -Djava.net.preferIPv4Stack=false -Djava.net.preferIPv6Addresses=true";
      package = serverPackage;
      symlinks.mods = pkgs.linkFarmFromDrvs "mods" (
        map (
          mod:
          pkgs.fetchurl {
            url = builtins.head (mod.downloads);
            sha512 = mod.hashes.sha512;
          }
        ) (builtins.filter (mod: mod.env.server != "unsupported") modpack.files)
      );
    }
    // extraAttrs;
in
{
  services.minecraft-servers = {
    enable = true;
    eula = true;
    openFirewall = true;
    servers = builtins.mapAttrs (name: modpack: mkModpack modpack { enable = true; }) (
      builtins.listToAttrs modpacks
    );
  };
}
