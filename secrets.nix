let
  toledo   = "age10prc9j3uu03exr554w8pyh6dmt0v5vpuxkd3z209tymryx76tgqqhn554v";
  xeon = "age1qq0jtpt03xhxv5440q9vjr5v6hp76gcjgx4qyvdnw8sy4q6r0q6qfxp735";
  laptop   = "age10prc9j3uu03exr554w8pyh6dmt0v5vpuxkd3z209tymryx76tgqqhn554v"; # TODO: reemplazar con clave real del laptop
in {
  # Secreto compartido: todos los hosts
  "secrets/g4ng_password.age".publicKeys = [ toledo xeon laptop ];

  # Secretos exclusivos de toledo
  "secrets/git_email.age".publicKeys = [ toledo ];
}