#!/bin/sh

nixbld_user=nixbld
nixbld_group=nixbld
storedir="$(nix-store --print-store-dir)"


# Setup build users
if ! getent group "$nixbld_group" >/dev/null; then
  groupadd -r "$nixbld_group"
fi

for i in $(seq 10); do
  if ! getent passwd "$nixbld_user$i" >/dev/null; then
    useradd -r -g "$nixbld_group" -G "$nixbld_group" -d /var/empty \
      -s /sbin/nologin \
      -c "Nix build user $i" "$nixbld_user$i"
  fi
done


# We may run in a VM with bind-mounted /nix/store, so ignore errors.
chgrp "$nixbld_group" "$storedir" || true
