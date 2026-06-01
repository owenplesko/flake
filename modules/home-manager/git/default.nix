{...}: {
  programs.git = {
    enable = true;
    signing.format = "openpgp";
    settings = {
      user.name = "owen";
      user.email = "owenplesko@gmail.com";
    };
    extraConfig = {
      credential.helper = "!f() { echo \"password=$(cat /run/secrets/github/pat)\"; }; f";
    };
  };
}
