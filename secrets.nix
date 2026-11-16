let
  admin  = "age1rmrf74d4h90x93c0lhzt9agnkt2v03e6xtaq8hqcx4mqcud7ngjs4arvs3";
  laptop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHy8atxzI/bzhclnp2BOro9uCSgtipgecupfwHqBAS1c";
  # toledo = "age1…";   # cuando lo reinstales
  # router = "age1…";
in
{
  "secrets/g4ng_password.age".publicKeys = [ admin laptop ];
}