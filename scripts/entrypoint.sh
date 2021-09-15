#!/bin/sh
# Script to ensure correct ownership of config files, establish a run user,
# and drop permissions to those of the run user

UID="${PUID:-65534}"
GID="${PGID:-65534}"

# Add 'bliss' group and 'bliss' user as alias of existing group and user
# Note that /config becomes the home folder for this user,
# ensuring that config data is saved to the volume and persists
groupadd --non-unique \
    --gid "$GID" \
    bliss
useradd --non-unique \
    --no-log-init \
    --uid "$UID" \
    --no-create-home --home /config \
    --gid bliss \
    bliss

# Ensure that permissions are good on the install path and config volume
chown -R bliss:bliss /config
chown -R bliss:bliss /bliss

# Execute runner without root privileges
exec su-exec bliss "$@"
