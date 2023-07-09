{
  lib,
  fetchFromGitHub,
  mkYarnPackage,
  fetchYarnDeps,
  nodejs,
  nodePackages,
  yarn,
}:
mkYarnPackage rec {
  pname = "redis-insight";
  version = "2.28.0";

  src = fetchFromGitHub {
    owner = "RedisInsight";
    repo = "RedisInsight";
    rev = "64b6ce212d037d5cb6d9259cd89aa5419f29e1e1";
    sha256 = "sha256-z/e5nMVq4HrLMOP0bjibxeUIdQfmJO3nnDbfnUoOGYA=";
  };

  packageJSON = "${src}/package.json";

  nativeBuildInputs = [
    yarn
    nodejs
    nodePackages.typescript
    nodePackages.ts-node
    nodePackages.rimraf
  ];

  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    sha256 = "sha256-YU85pDRqtBPjxkBURG1/WUQKZu6Y6F9JkU/herYaYAY=";
  };

  buildPhase = ''
    yarn --offline install
    yarn --offline --cwd redisinsight/api/ install
    yarn --offline package:prod
  '';

  #TODO
  installPhase = ''
    ls -alR ./release
  '';

  meta = with lib; {
    description = "Redis GUI by Redis";
    homepage = "https://github.com/RedisInsight/RedisInsight";
    longDescription = ''
      RedisInsight is a visual tool that provides capabilities to design, develop and optimize your Redis application.
      Query, analyse and interact with your Redis data.
    '';
    license = licenses.sspl;
    #TODO
    maintainers = [];
    platforms = platforms.linux;
  };
}
