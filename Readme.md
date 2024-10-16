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
sudo apt install xxd git bzip2 gcc nfs-common nfs-kernel-server netcat-traditionnal nmap
```

Start installer as root

```
sudo ./install.sh
```

Enjoy !



### Todo
- Level checked : 37
- level 16b : hide another flag
- test the docker file
- verfier que showmount est dans le path


new levels :
- find a process XXX -> readable .sh ? listening port as parameter ?
- find a service -> flag in .service file ? in .sh file ?


### Contributors
[https://github.com/kylir](Kylir)

