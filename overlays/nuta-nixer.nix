self: super:
let
  name = "nuta-nixer";
  version = "1.1.0";
in {
  nuta-nixer = super.buildDotnetModule {
    pname = "${name}";
    version = "${version}";

    src = /serit/Innovasjon/nuta-nixer;

    projectFile = "src/Server/Server.fsproj";
    nugetDeps = ./nuta-nixer-deps.nix;

    dotnet-sdk = super.dotnet-sdk_6;
    dotnet-runtime = super.dotnet-aspnetcore;

    executables = [ "Server" ];
  };
}
