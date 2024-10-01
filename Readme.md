### Install instructions

We may need to install xxd

```
sudo apt install xxd
```

Clone or zip download this repository

```
git clone https://github.com/20100dbg/bandit-wargame
```

Start installer as root

```
sudo ./install.sh
```

You'll need to reboot to activate startup scripts

Enjoy !

### Run it in a docker container

Alternatively, you can run it in a container.

Clone the repository and build the container

```
docker build . -t bandit
```

Start the container

```
docker run -d --name bandit -p 2220:22 bandit:latest
```

This will start a ssh server listening on port 2220.

Connect as user `bandit0` (it's a zero!) with:

```
ssh bandit0@localhost -p 2220
```

### Todo

- Level checked : 26
- level 16b : hide another flag
- test the docker file
