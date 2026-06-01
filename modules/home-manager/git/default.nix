{...}: {
  programs.git = {
    enable = true;
    signing.format = "openpgp";
    settings = {
      user.name = "owen";
      user.email = "owenplesko@gmail.com";
      credential.helper = "!f() { echo \"password=$(cat /run/secrets/github/pat)\"; }; f";
    };
  };
}
