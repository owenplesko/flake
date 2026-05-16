{...}: {
  programs.git = {
    enable = true;
    signing.format = "openpgp";
    settings = {
      user.name = "owen";
      user.email = "owenplesko@gmail.com";
    };
  };
}
