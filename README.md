# Veracrypt in Docker with Shared Network Access

The goal of this project was to have a Veracrypt container accessible from a
network share from a NAS running [unRAID](https://unraid.net).

## Running Veracrypt

Veracrypt is not available via the unRAID
[NERDPACK](https://forums.unraid.net/topic/35866-unraid-6-nerdpack-cli-tools-iftop-iotop-screen-kbd-etc/)
plugin. Compiling Veracrypt from source was not a desired option for me.
Running Veracrypt in Docker gives us some portability of Docker images.

The `Dockerfile` in this repo can be built using the following command on unRAID.

```bash
docker build -t veracrypt:latest .
```

The Veracrypt contain can then be started using:

```bash
docker run \
  -it \
  --rm \
  --privileged \
  --volume /mnt/user/my_unraid_share/:/mnt/my_unraid_share:shared \
  veracrypt \ 
  /bin/sh
```

The privileged flag appears required. There were issues creating and mounting
Veracrypt containers without it. `/mnt/my_unraid_share` is path of the your
share on the unRAID server. The `shared` option on the `--volume` is important.
It allows the mount points in the Docker container to propagate to the host.

## Creating a Veracrypt Volume

Inside the Docker container, the following command can be used to create a
Veracrypt volume. Substitute the password you want to use for the Veracrypt
container.

```bash
 veracrypt \
   --create \
   --volume-type=normal \
   --encryption=aes \
   --hash=sha512 \
   --filesystem=btrfs \
   --size=100M \
   --password=$PASSWORD \
   --non-interactive \
   /mnt/my_unraid_share/test.vc
```

## Mounting the Veracrypt Volume

To mount the Veracrypt volume that was created in the previous step use:

```bash
veracrypt \
  -t \
  -k "" \
  --pim=0 \
  --protect-hidden=no \
  -p $PASSWORD \
  /mnt/my_unraid_share/test.vc \
  /mnt/my_unraid_share/test_vc
```

## Validate Veracrypt Volume is Accessible From Network

Create a file in the Veracrypt volume from inside the Docker container using:

```bash
touch /mnt/my_unraid_share/test_vc/test_file
```

Browse to the network share where your Veracrypt container is mounted. You
should see a file called `test_file`.

## Unmounting Veracrypt Volume

To unmount the Veracrypt volume use the command

```bash
veracrypt -d /mnt/my_unraid_share/test_vc
```
