### Introduction

This is an offline adaptation of the [https://overthewire.org/wargames/bandit/](overthewire's wargame bandit).
Bandit is great to test your Linux skills


Passwords are randomly generated at each install.


### Install instructions

You can install bandit@home with docker (recommended) or manually. If you chose to install this manually, you should do so in a in a virtual machine, as it creates many users, cronjobs, and other things.


Start with cloning this repository

```
git clone https://github.com/20100dbg/bandit-wargame
```


### Docker install

Build the container
```
docker build . -t bandit
```

Start the container
```
docker run -d --name bandit -p 2220:22 bandit:latest
```

Connect as user `bandit0`, password `bandit0` with:
```
ssh bandit0@localhost -p 2220
```


### Manual install

Again, we recommend to install this in a Virtual machine, NOT in your daily environment.

First, we may need some additional softwares :
```
sudo apt install xxd git bzip2 gcc netcat-traditionnal nmap
```

Start installer as root
```
sudo ./install.sh
```

At this point you should reboot in order to enable some cronjobs.
```
sudo reboot
```

Then, connect as user `bandit0`, password `bandit0` with:
```
ssh bandit0@127.0.0.1
```

Enjoy !



### Todo
- retester 16, et à partir de 24
- add a level related to NFS ?



### Contributors
Thanks to [https://github.com/kylir](Kylir) for writing the initial Dockerfile

