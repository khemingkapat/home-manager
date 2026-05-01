{
  programs.nixgl = {
    # Enable the nixGL wrapper
    enable = true;

    # Use the generic "mesa" wrapper, which is correct for your Intel GPU
    defaultWrapper = "mesa";

    # THIS IS THE MAGIC LINE:
    # Automatically wrap all GUI applications
    auto.enable = true;
  };
}
