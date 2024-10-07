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


### Install instructions

You can also install it manually, for example in a VM :

We may need some softwares :
```
sudo apt install xxd git bzip2 gcc nfs-kernel-server
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



### Todo
- Level checked : 30
- level 16b : hide another flag

34->35
36->37

- test the docker file

new levels :
- flag in env variable
- find recently edited file (don't forget a script that update the file frequently)
- suid on bin like find, cat, base64, cp 
- mount nfs
- jail python
- find a process XXX -> readable .sh ? listening port as parameter ?
- find a service -> flag in .service file ? in .sh file ?

- exploit PATH injection
- config sudo
- capabilities
- Wildcard Injection
- unquoted string in bash script


### Contributors
[https://github.com/kylir](Kylir)

