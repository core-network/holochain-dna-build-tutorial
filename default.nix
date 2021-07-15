let
  holonixPath = builtins.fetchTarball {
    url = "https://github.com/holochain/holonix/archive/3e94163765975f35f7d8ec509b33c3da52661bd1.tar.gz";
    sha256 = "sha256:07sl281r29ygh54dxys1qpjvlvmnh7iv1ppf79fbki96dj9ip7d2";
  };
  holonix = import (holonixPath) {
    includeHolochainBinaries = true;
    holochainVersionId = "custom";

    holochainVersion = {
     rev = "0c283785ca98c78dbb2d27d7a3b8b417e4475ecb";  # current head of https://github.com/holochain/holochain/pull/829
     sha256 = "18qd6q3ly2spa0bkajbzfj49zl047clj6k14pq6fv1mf7wbxvf7v";
     cargoSha256 = "sha256:1xikr23lglh7629g8bdq52r2c20s1r0xdy90w2vlgpsrkq5zn69i";
     bins = {
       holochain = "holochain";
       hc = "hc";
     };
    };
    holochainOtherDepsNames = ["lair-keystore"];
  };
in holonix.main
