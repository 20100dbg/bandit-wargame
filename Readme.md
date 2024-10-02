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





### Todo
Level checked : 26
level 16b : hide another flag
docker it

new levels :
- suid on bin like find, cat, base64, cp 
- flag in env variable
- find recently edited file
- mount nfs
- jail python
- script writable ?
- find a process XXX -> .sh lisible ? port d'écoute en paramètre ?
- find a service -> flag in .service file ? in .sh file ?

- exploit PATH injection
- config sudo
- capabilities
- Wildcard Injection
- unquoted string in bash script