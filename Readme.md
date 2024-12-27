### Introduction

This is an offline remake of the [Overthewire's wargame Bandit](https://overthewire.org/wargames/bandit/).
In this remake you will find the 33 original levels, and 5 additionnal levels I added.

Bandit is great to test your Linux skills and have a nice security related touch.


## Install instructions

You can install bandit@home with docker (recommended) or manually. If you chose to install this manually, you should do so in a in a virtual machine, as it creates many users, cronjobs, and other things.
Note : Passwords are randomly generated at each install.


## Docker install
Start with cloning this repository
```
git clone https://github.com/20100dbg/bandit-wargame
```

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


## Manual install

Again, we recommend to install this in a Virtual machine, NOT in your daily environment.

Start with cloning this repository
```
git clone https://github.com/20100dbg/bandit-wargame
```

We may need some additional softwares :
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
- Add a level related to NFS


### Contributors
Thanks to [https://github.com/kylir](Kylir) for writing the initial Dockerfile

