{ inputs, ... }:
{
  flake.darwinModules.virby =
    { ... }:
    {
      imports = [
        inputs.virby.darwinModules.default
      ];

      services.virby = {
        enable = true;
        rosetta = true;
        debug = true;
        cores = 10;
        memory = 8192;
        diskSize = "50GiB";
        onDemand = {
          enable = true;
          ttl = 60;
        };
      };
    };
}
