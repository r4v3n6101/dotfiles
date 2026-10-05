_: {
  perSystem = _: {
    treefmt.programs = {
      deadnix = {
        enable = true;
        priority = -20;
      };

      statix = {
        enable = true;
        priority = -10;
      };

      nixfmt = {
        enable = true;
        priority = 0;
      };
    };
  };
}
