let
  toledo   = "age10prc9j3uu03exr554w8pyh6dmt0v5vpuxkd3z209tymryx76tgqqhn554v";
  router = "age1gwakxlcx2tfwmxng3q9wsjgxh334mrv3rvsvyalgcma243ue897qm3uu0s";
  laptop   = "age10prc9j3uu03exr554w8pyh6dmt0v5vpuxkd3z209tymryx76tgqqhn554v"; # TODO: reemplazar con clave real del laptop
in {
  # Secreto compartido: todos los hosts
  "secrets/g4ng_password.age".publicKeys = [ toledo router laptop ];

  # Secretos exclusivos de toledo
  "secrets/git_email.age".publicKeys = [ toledo ];
}