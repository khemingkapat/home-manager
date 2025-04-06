{
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      format = ''
        [╭──](bold green)$env_var on $hostname at $directory
        [│](bold green) $all
        [╰──>](bold green) '';
      character = {
        disabled = false;
      };
      env_var.USER = {
        format = "[$env_value](white)";
        variable = "USER";
        disabled = false;
      };
      hostname = {
        ssh_only = false;
        format = "[$hostname](bold yellow)";
        disabled = false;
      };
      line_break = {
        disabled = true;
      };
      command_timeout = 5000;
    };
  };
}
