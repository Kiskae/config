self: super: {
  xwayland = self.enableDebugging (super.xwayland.overrideAttrs (_: {
    #patches = [./xwayland.patch];
  }));
}