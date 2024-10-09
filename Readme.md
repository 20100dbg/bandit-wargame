### Install instructions

You can install bandit@home with docker or manually. If you chose the manual version, we recommend to install it in a virtual machine.

Before anything, clone this repository (you can also zip download it)

```
git clone https://github.com/20100dbg/bandit-wargame
```


### Run it in a docker container

Build the container

```
docker build . -t bandit
```

Start the container

```
docker run -d --name bandit -p 2220:22 bandit:latest
```

This will start a ssh server listening on port 2220.

Connect as user `bandit0`, password `bandit0` with:

```
ssh bandit0@localhost -p 2220
```


### Install instructions


We may need some softwares :
```
sudo apt install xxd git bzip2 gcc nfs-kernel-server
```

Start installer as root

```
sudo ./install.sh
```

Enjoy !



### Todo
- Level checked : 31
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

