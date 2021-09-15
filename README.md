# bliss-docker

Lightweight Docker container with [bliss](https://www.blisshq.com/), based on [romancin/bliss-docker](https://github.com/romancin/bliss-docker).  Compared to that project, this one has two primary functional differences:
- The container process runs as a non-root user.  Running as a non-root user helps ensure that config files can be accessed without root permissions, and is important for security, as it limits the impact of any potential container breakout exploit.
- The runner script (which exists to ensure that the container doesn't exit when bliss restarts across an upgrade) traps various signals and passes them on to the bliss process.  In particular this includes SIGTERM which is issued by Docker when a container is stopped.  This permits cleaner (and faster) shutdown of the container.

This image is also almost 30% smaller.

![docker pulls](https://img.shields.io/docker/pulls/cooperised/bliss.svg) ![docker stars](https://img.shields.io/docker/stars/cooperised/bliss.svg) [![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.com/donate?hosted_button_id=9X3M7PSXCTFWY)

Latest versions:

![Docker Image Version (latest semver)](https://img.shields.io/docker/v/cooperised/bliss) ![docker size](https://img.shields.io/docker/image-size/cooperised/bliss) 

bliss can be upgraded within the container from its own web UI, and settings will be preserved across the upgrade.

Tested on Ubuntu 20.04 and Debian Bullseye x86_64 hosts.  Not built or tested for any other host architecture, but it would likely work.  Open an issue if you'd like to request this.

## Instructions 
- Map any local port to 3220 for web access
- Map any local port to 3221 (used for bliss internal web server)
- Map a local volume to /config (Stores configuration data)
- Map a local volume to wherever you like, perhaps /music (This is the directory wher you should put your music for bliss to scan, and you can select it on first startup)
- Choose the user and group that bliss should run under, and pass these using the `PUID` and `PGID` environment variables

The container will run with the effective UID and GID provided.  If these are omitted it will run with `UID=65534 (nobody)` and `GID=65534 (nogroup)`.  

Sample run command, running as the existing host user `user`:

```bash
docker run -d --name=bliss \
-v /share/Container/bliss:/config \
-v /share/MyMusic:/music \
-e PGID=`id -u user` -e PUID=`id -g user` \
-e TZ=Europe/London \
-p 3220:3220 \
-p 3221:3221 \
cooperised/bliss:latest
```
