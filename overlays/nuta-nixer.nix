self: super:
let
  pname = "nuta-nixer";
  version = "0.0.1";
in {
  nuta-nixer = super.buildDotnetModule {
    pname = "${pname}";

    src = super.fetchFromGitLab {
      rev = "${version}";
      owner = "serit";
      repo = "nuta-nixer";
      sha256 = "";
    };

    projectFile = "src/Server/Server.fsproj";
    nugetDeps = ./nuta-nixer-deps.nix;

    dotnet-sdk = super.dotnet-sdk_6;

    executables = [ "Server" ];
  };
}
