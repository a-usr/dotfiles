{ inputs, ... }:
let
  nixpkgsoverlay =
    final: prev:
    let
      getPkgs = input: input.packages."${final.stdenv.hostPlatform.system}";
    in
    {
      hyprland = (getPkgs inputs.hyprland).default;
      stash = (getPkgs inputs.stash).default;
      # temp issue
      openldap = prev.openldap.overrideAttrs {
        doCheck = !prev.stdenv.hostPlatform.isi686;
      };

      vencord = prev.vencord.overrideAttrs (
        finalAttrs: prevAttrs: {
          version = "1.15.16";
          src = final.fetchFromGitHub {
            owner = "Vendicated";
            repo = "Vencord";
            tag = "v1.15.16";
            hash = "sha256-aUJubLJpyLAZWiOezqFxPY6oVPgWVPQpajFqrJvrO9U=";
          };
          patches = [
            (final.fetchpatch {
              url = "https://github.com/Vendicated/Vencord/compare/main...Vendicated:Vencord:82825bd933b85993dc19b762bc0b13ca545bae76.diff";
              hash = "sha256-sbt1We65RWA6CmJBuN7ncp2c5a/L/y5rUSRidOpIK4Y=";
            })
          ];
          postPatch = "";
          pnpmDeps = final.fetchPnpmDeps {
            inherit (finalAttrs)
              pname
              src
              ;
            pnpm = final.pnpm_11;
            fetcherVersion = 4;
            hash = "sha256-HS8uZNepvDefjrsG3buVLFCVv7sHvazcwdpcT3EQ/78=";
          };
        }
      );

      openasar = prev.openasar.overrideAttrs (prevAttrs: {
        patches = (if prevAttrs ? patches then prevAttrs.patches else [ ]) ++ [
          # ./OpenASAR_dont_disable_vulkan.patch
          ./OpenASAR_dont_discard_cli_args.patch
        ];
        postPatch = (prevAttrs.postPatch or "") + ''
          substituteInPlace src/cmdSwitches.js \
            --replace-fail 'libopenh264-2.5.1-linux64.7.so' \
              'libopenh264-2.7.0-linux64.8.so' \
            --replace-fail 'EnableDrDc,' ""
        '';
      });

      discord = prev.discord.override {
        commandLineArgs = "--use-gl=angle --use-angle=gles --disable-features=UseChromeOSDirectVideoDecoder --enable-features=CanvasOopRasterization,VaapiIgnoreDriverChecks,VaapiVideoDecoder,UseMultiPlaneFormatForHardwareVideo,VaapiVideoEncoder";
      };
    };
in
[
  nixpkgsoverlay
]
