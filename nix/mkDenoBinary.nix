{
  lib,
  deno,
  denoPlatform,
}: {
  name,
  permissions ? {},
  unstable ? false,
  entryPoint ? "main.ts",
  binaryName ? name,
  additionalDenoArgs ? [],
  scriptArgs ? [],
  ...
} @ args: let
  compileArgs = denoPlatform.lib.generateFlags {
    inherit permissions unstable entryPoint scriptArgs;
    additionalDenoArgs = ["--output" binaryName] ++ additionalDenoArgs;
  };
in
  denoPlatform.mkDenoDerivation ({
      # fixup corrupts the binary, leaving it in a Deno REPL-only state
      dontFixup = true;

      buildPhase = "deno compile ${compileArgs}";
      installPhase = "install -Dm755 ${binaryName} $out/bin/${binaryName}";

      # default to Deno's platforms
      meta.platforms = deno.meta.platforms;
    }
    // (builtins.removeAttrs args ["permissions"]))
