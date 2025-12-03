{...}: {
  programs.git = {
    enable = true;
    settings = {
      user.name = "owen";
      user.email = "owenplesko@gmail.com";
    };
  };
}
