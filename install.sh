#!/bin/bash

gen_passwd() {
	cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1
}

create_user() {

	if [ "$1" = "bandit0" ]
	then
		pass='bandit0'
	else
		pass=$(gen_passwd)
	fi

	useradd -m "$1" -s "/bin/bash" -p `openssl passwd -1 -salt "bandit" "$pass"`
	
	mkdir "/home/$1/.ssh"
	echo "$pass" > "/etc/bandit_pass/$1"
	chown "$1" "/etc/bandit_pass/$1"
	chmod 400 "/etc/bandit_pass/$1"

	echo $pass
}

set_perms() {
	
	# $1 = id user courant
	# $2 = fichier
	x=$(($1+1))

	chown bandit$x "$2"
	chgrp bandit$1 "$2"
	chmod 640 "$2"
}

create_motd() {
	# $1 = user
	# $2= goal
	echo "$2" > "/etc/bandit_goal/$1"
	chown "$1" "/etc/bandit_goal/$1"
	chmod 400 "/etc/bandit_goal/$1"

	echo "cat /etc/bandit_goal/$1" > "/home/$1/.ssh/rc"
}

mv /etc/motd /etc/motd.bak
echo "=====================================================
Welcome on bandit's wargame at home !
=====================================================">/etc/motd
mkdir /etc/bandit_scripts
mkdir /etc/bandit_pass
mkdir /etc/bandit_goal
passwords=()

goals=()
goals+=( 'The password for the next level is stored in a file called readme located in the home directory. Use this password to log into bandit1 using SSH. Whenever you find a password for a level, use SSH (on port 2220) to log into that level and continue the game.' )
goals+=( 'The password for the next level is stored in a file called - located in the home directory' )
goals+=( 'The password for the next level is stored in a file called spaces in this filename located in the home directory' )
goals+=( 'The password for the next level is stored in a hidden file in the inhere directory.' )
goals+=( 'The password for the next level is stored in the only human-readable file in the inhere directory. Tip: if your terminal is messed up, try the “reset” command.' )
goals+=( 'The password for the next level is stored in a file somewhere under the inhere directory and has all of the following properties: human-readable, 1033 bytes in size, not executable' )
goals+=( 'The password for the next level is stored somewhere on the server and has all of the following properties: owned by user bandit7, owned by group bandit6, 33 bytes in size' )
goals+=( 'The password for the next level is stored in the file data.txt next to the word millionth' )
goals+=( 'The password for the next level is stored in the file data.txt and is the only line of text that occurs only once' )
goals+=( 'The password for the next level is stored in the file data.txt in one of the few human-readable strings, preceded by several ‘=’ characters.' )
goals+=( 'The password for the next level is stored in the file data.txt, which contains base64 encoded data' )
goals+=( 'The password for the next level is stored in the file data.txt, where all lowercase (a-z) and uppercase (A-Z) letters have been rotated by 13 positions' )
goals+=( 'The password for the next level is stored in the file data.txt, which is a hexdump of a file that has been repeatedly compressed. For this level it may be useful to create a directory under /tmp in which you can work. Use mkdir with a hard to guess directory name. Or better, use the command “mktemp -d”. Then copy the datafile using cp, and rename it using mv (read the manpages!)' )
goals+=( 'The password for the next level is stored in /etc/bandit_pass/bandit14 and can only be read by user bandit14. For this level, you don’t get the next password, but you get a private SSH key that can be used to log into the next level. Note: localhost is a hostname that refers to the machine you are working on' )
goals+=( 'The password for the next level can be retrieved by submitting the password of the current level to port 30000 on localhost.' )
goals+=( 'The password for the next level can be retrieved by submitting the password of the current level to port 30001 on localhost using SSL/TLS encryption. Helpful note: Getting “DONE”, “RENEGOTIATING” or “KEYUPDATE”? Read the “CONNECTED COMMANDS” section in the manpage.' )
goals+=( 'The credentials for the next level can be retrieved by submitting the password of the current level to a port on localhost in the range 31000 to 32000. First find out which of these ports have a server listening on them. Then find out which of those speak SSL/TLS and which don’t. There is only 1 server that will give the next credentials, the others will simply send back to you whatever you send to it. Helpful note: Getting “DONE”, “RENEGOTIATING” or “KEYUPDATE”? Read the “CONNECTED COMMANDS” section in the manpage.' )
goals+=( )
goals+=( )
goals+=( )
goals+=( )
goals+=( )



echo -n "Creating users... "

for i in {0..33}; do
	pass=$(create_user "bandit$i")

  	$(create_motd "bandit$i" "${goals[$i]}")
	passwords+=( $pass )
done

echo "done"

echo "Creating levels... "

#level0 -> level1
echo -ne "\r0"
echo "The password you are looking for is: ${passwords[1]}" > '/home/bandit0/readme'
set_perms 0 '/home/bandit0/readme'


#level1 -> level2
echo -ne "\r1"
echo ${passwords[2]} > '/home/bandit1/-'
set_perms 1 '/home/bandit1/-'


#level2 -> level3
echo -ne "\r2"
echo ${passwords[3]} > "/home/bandit2/spaces in this filename"
set_perms 2 "/home/bandit2/spaces in this filename"


#level3 -> level4
echo -ne "\r3"
mkdir /home/bandit3/inhere
echo ${passwords[4]} > '/home/bandit3/inhere/...Hiding-From-You'
set_perms 3 '/home/bandit3/inhere/...Hiding-From-You'


#level4 -> level5
echo -ne "\r4"
mkdir /home/bandit4/inhere
x=$(( RANDOM % 10))


for i in {0..9}; do
	if [[ $i -eq $x ]]
	then
		echo ${passwords[5]} > "/home/bandit4/inhere/-file0$i"
	else
	    cat /dev/urandom | fold -w 32 | head -n 1 > "/home/bandit4/inhere/-file0$i"
	fi
	set_perms 4 "/home/bandit4/inhere/-file0$i"
done


#level5 -> level6
echo -ne "\r5"
mkdir /home/bandit5/inhere
x=$(( RANDOM % 19))

for i in $(seq 0 19)
do
	mkdir "/home/bandit5/inhere/maybehere$i"

	for j in $(seq 1 9)
	do		
		if [[ $(( RANDOM % 2 )) -eq 0 ]]
		then
			cat /dev/urandom | fold -w $(( RANDOM )) | head -n 1 > "/home/bandit5/inhere/maybehere$i/file$j"
		else
			cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w $(( RANDOM )) | head -n 1 > "/home/bandit5/inhere/maybehere$i/file$j"
		fi

		if [[ $(( RANDOM % 2 )) -eq 0 ]]
		then
			chmod 640 "/home/bandit5/inhere/maybehere$i/file$j"
		else
			chmod 750 "/home/bandit5/inhere/maybehere$i/file$j"
		fi

		chgrp bandit5 "/home/bandit5/inhere/maybehere$i/file$j"
	done

	if [[ $i -eq $x ]]
	then
		spaces=`python -c "print(' ' * 1000)"`

		echo "$spaces${passwords[6]}" > "/home/bandit5/inhere/maybehere$i/-file2"
		chmod 750 /home/bandit5/inhere/maybehere$i/-file2
	fi
done


#level6 -> level7
echo -ne "\r6"
mkdir -p /var/lib/dpkg/info/
echo ${passwords[7]} > /var/lib/dpkg/info/bandit7.password
chown bandit7 /var/lib/dpkg/info/bandit7.password
chgrp bandit6 /var/lib/dpkg/info/bandit7.password
chmod 640 /var/lib/dpkg/info/bandit7.password



#level7 -> level8
echo -ne "\r7"
touch /home/bandit7/data.txt

while IFS= read -r line; do

	if [ "$line" = "millionth" ]
	then
		echo "millionth\t${passwords[8]}" >> /home/bandit7/data.txt
	else
		echo "$line `cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1`" >> /home/bandit7/data.txt
	fi
done < wordlist7b.txt



#level8 -> level9
echo -ne "\r8"
touch /home/bandit8/data_tmp.txt
x=$(( RANDOM % 1000))

for i in {1..100}; do
	
	rnd_string=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1`

	for j in {1..10}; do
		echo $rnd_string >> /home/bandit8/data_tmp.txt
	done
 
done

echo ${passwords[9]} >> /home/bandit8/data_tmp.txt

shuf /home/bandit8/data_tmp.txt > /home/bandit8/data.txt
rm /home/bandit8/data_tmp.txt



#level9 -> level10
echo -ne "\r9"
data='`cat data9.txt`'
echo data | base64 -d | tr FGUW5ilLVJrxX9kMYMmlN4MgbpfMiqey ${passwords[10]} > /home/bandit9/data.txt



#level10 -> level11
echo -ne "\r10"
echo ${passwords[11]} | base64 > /home/bandit10/data.txt



#level11 -> level12
echo -ne "\r11"
echo ${passwords[12]} | tr 'a-mn-z' 'n-za-m' | tr 'A-MN-Z' 'N-ZA-M' > /home/bandit11/data.txt


#level12 -> level13
echo -ne "\r12"
tmp=$(mktemp -d)
echo ${passwords[13]} > "$tmp/data8"
gzip -c "$tmp/data8" > "$tmp/data8.bin"
tar cvf "$tmp/data7.tar" "$tmp/data8.bin"
bzip2 -c "$tmp/data7.tar" > "$tmp/data6.bin"
tar cvf "$tmp/data5.bin" "$tmp/data6.bin"
tar cvf "$tmp/data4.bin" "$tmp/data5.bin"
gzip -c "$tmp/data4.bin" > "$tmp/data3.bin"
bzip2 -c "$tmp/data3.bin" > "$tmp/data2.bin"
gzip -c "$tmp/data2.bin" > "$tmp/data1.bin"
xxd "$tmp/data1.bin" > data.txt

#level13 -> level14
echo -ne "\r13"
ssh-keygen -f ./sshkey.private -N ""
mkdir /home/bandit13/.ssh/
mv ./sshkey.private /home/bandit13/
mv ./sshkey.private.pub /home/bandit13/authorized_keys


#level14 -> level15
echo -ne "\r14"
cp script14.py /etc/bandit_scripts/script14.py

crontab -u root -l > mycron
echo "@reboot sleep 30 && python /etc/bandit_scripts/script14.py" >> mycron
crontab mycron && rm mycron


#level15 -> level16
echo -ne "\r15"
cp script15.py /etc/bandit_scripts/script15.py

crontab -u root -l > mycron
echo "@reboot sleep 30 && python /etc/bandit_scripts/script15.py" >> mycron
crontab mycron && rm mycron
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout "/etc/bandit_scripts/script15.key" -out "/etc/bandit_scripts/script15.pem" -subj "/"







echo;
echo "All done, reboot and enjoy !"
