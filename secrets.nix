let
  admin  = "age1rmrf74d4h90x93c0lhzt9agnkt2v03e6xtaq8hqcx4mqcud7ngjs4arvs3";
  laptop = "age12m5dupqr36z9a2tuv8qp0c4mljsm26066g08y9yll9jwelet9gnsfdy3rk";
  # toledo = "age1…";   # cuando lo reinstales
  # router = "age1…";
in
{
  "secrets/g4ng_password.age".publicKeys = [ admin laptop ];
}