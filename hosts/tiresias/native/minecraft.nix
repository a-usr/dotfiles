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
  inherit (lib') filterFileType getFileBaseNameWithoutExtension getItemsFromDir;

  formatVersion = ver: replaceString "." "_" ver;

  modpacks = map (modpackFile: {
    name = "${getFileBaseNameWithoutExtension modpackFile}";
    value = lib.importJSON modpackFile;
  }) (filterFileType "json" (getItemsFromDir "regular" ./minecraftModpacks));

  mkModpack =
    modpack: extraAttrs:
    let
      modloader = findFirst (dep: dep.name != "minecraft") null (attrsToList modpack.dependencies);

      serverPackage =
        let
          type = if modloader != null then modloader.type else "vanilla";
          minecraftVersion = formatVersion modpack.dependencies.minecraft;
        in
        if type == "vanilla" then
          pkgs.minecraftServers."vanilla-${minecraftVersion}"
        else if type == "fabric-loader" then
          pkgs.minecraftServers."fabric-${minecraftVersion}".override {
            loaderVersion = modloader.version;
          }
        else if type == "neoforge" then
          pkgs.minecraftServers."neoforge-${minecraftVersion}-${formatVersion modloader.version}"
        else
          throw "unimplemented modloader: ${type}";
    in
    {
      jvmOpts = "-Xmx4G -Xms2G";
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
