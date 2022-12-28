# Overriding a buildGoModule package with dependencies changes is a PITA
# Whole package implementation has been copied
# See https://github.com/FiloSottile/yubikey-agent/pull/136
{ stdenv, lib, fetchFromGitHub, buildGoModule, libnotify, pcsclite, pkg-config, darwin }:

buildGoModule rec {
  pname = "yubikey-agent";

  version = "unstable-2022-03-17";
  src = fetchFromGitHub {
    owner = "LeSuisse";
    repo = "yubikey-agent";
    rev = "91a0c99b47ed663f84324c235d08aa0016504700";
    sha256 = "sha256-XkM7g8X3TAkz/ameBM+H6X7gbDPSYvawDplUCdSpS+k=";
  };

  buildInputs =
    lib.optional stdenv.isLinux (lib.getDev pcsclite)
    ++ lib.optional stdenv.isDarwin (darwin.apple_sdk.frameworks.PCSC);

  nativeBuildInputs = lib.optionals stdenv.isLinux [ pkg-config ];

  postPatch = lib.optionalString stdenv.isLinux ''
    substituteInPlace main.go --replace 'notify-send' ${libnotify}/bin/notify-send
  '';

  vendorSha256 = "sha256-4+Jc9qfITirXeO8rhyrRP6Xri+0RVp231p8W294kMKs=";

  doCheck = false;

  subPackages = [ "." ];

  ldflags = [ "-s" "-w" "-X main.Version=${version}" ];

  postInstall = lib.optionalString stdenv.isLinux ''
    mkdir -p $out/lib/systemd/user
    substitute contrib/systemd/user/yubikey-agent.service $out/lib/systemd/user/yubikey-agent.service \
      --replace 'ExecStart=yubikey-agent' "ExecStart=$out/bin/yubikey-agent"
  '';

  meta = with lib; {
    description = "A seamless ssh-agent for YubiKeys";
    license = licenses.bsd3;
    homepage = "https://filippo.io/yubikey-agent";
    maintainers = with lib.maintainers; [ philandstuff rawkode ];
    platforms = platforms.darwin ++ platforms.linux;
  };
}
