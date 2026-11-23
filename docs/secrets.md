# Secretos (agenix)

Los secretos se guardan cifrados con [age](https://age-encryption.org) en `secrets/*.age` y se descifran **en el momento de la activación** en `/run/agenix/<nombre>`. Nunca llegan al store de Nix en claro.

## Ficheros

| Fichero | Contenido | Usado en | Destinatarios |
|---------|-----------|----------|---------------|
| `secrets/g4ng_password.age` | Hash (`mkpasswd -m yescrypt`) de la contraseña de `g4ng` | `users/g4ng/default.nix` → `hashedPasswordFile` | `admin`, `laptop` |
| `secrets/github_ssh.age` | Clave privada SSH para GitHub (propietario `g4ng`) | `hosts/laptop` + `users/g4ng/ssh.nix` | `admin`, `laptop` |

## Claves

[`secrets.nix`](../secrets.nix) define quién puede descifrar cada fichero. Solo lo lee la CLI `agenix`, no forma parte de la configuración NixOS.

| Clave | Tipo | Dónde vive |
|-------|------|------------|
| `admin` | age (`age1…`) | Clave personal de administración. En una máquina, en `/etc/age/keys.txt` (primer `age.identityPaths` de `_common`) o donde la use la CLI (`~/.config/age/keys.txt`, o pasarla con `-i`) |
| `laptop` | ssh-ed25519 | Clave de host `/etc/ssh/ssh_host_ed25519_key` del portátil |

`toledo` y `router` todavía no tienen su clave de host registrada (aparecen comentadas). Hasta entonces solo pueden descifrar si tienen la clave `admin` en `/etc/age/keys.txt`.

En cada host, agenix prueba las identidades de `age.identityPaths`:

```nix
# hosts/_common
age.identityPaths = [ "/etc/age/keys.txt" "/etc/ssh/ssh_host_ed25519_key" ];
```

## Operaciones

Todas desde el devShell (`nix develop`), en la raíz del repo, con una identidad capaz de descifrar (`-i ~/.config/age/keys.txt` si no está en la ruta por defecto).

```bash
# Editar o crear un secreto (debe estar declarado en secrets.nix)
agenix -e secrets/g4ng_password.age

# Recifrar todos los secretos tras cambiar destinatarios en secrets.nix
agenix -r
```

Generar el hash de la contraseña de usuario:

```bash
mkpasswd -m yescrypt
```

### Añadir un host como destinatario

1. Obtener su clave pública de host:

   ```bash
   ssh-keyscan -t ed25519 <ip>
   ```

   Se puede usar tal cual (`ssh-ed25519 AAAA…`) o convertirla con `ssh-to-age`.
2. Añadirla en `secrets.nix` y a la lista `publicKeys` de cada secreto que necesite.
3. `agenix -r` y commit de los `.age` recifrados.

> En una instalación nueva con `nixos-anywhere`, la clave de host se genera durante la instalación. Para que el primer arranque ya descifre los secretos, genera la clave antes y cópiala con `--extra-files`, o arranca una vez, registra la clave y vuelve a desplegar.

### Declarar y usar un secreto en un módulo

```nix
age.secrets.mi_token = {
  file  = ../../secrets/mi_token.age;
  owner = "g4ng";        # por defecto root
  mode  = "0400";
};

services.foo.tokenFile = config.age.secrets.mi_token.path;   # /run/agenix/mi_token
```

Desde home-manager se accede a la ruta con `osConfig.age.secrets.<nombre>.path`, como hace `users/g4ng/ssh.nix`.

Por qué funciona `hashedPasswordFile`: el script de activación `agenix` se ejecuta antes que `users`, así que `/run/agenix/g4ng_password` ya existe cuando se crean las cuentas. Como `users.mutableUsers = false`, si el secreto no se puede descifrar **no habrá contraseña** para `g4ng`: el acceso dependerá solo de las claves SSH.

## Historial

Los secretos pasaron de sops-nix a agenix. Quedan restos de esa etapa: la receta `just secret` (usa `sops`) y el secreto `git_email`, que se eliminó y aún se referencia en `toledo`. Ver [known-issues](known-issues.md).
