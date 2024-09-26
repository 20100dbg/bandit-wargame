#!/bin/bash

gen_passwd() {
	cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1
}

create_user() {
	pass=$(gen_passwd)

	useradd -m $1 -p $pass
	
	echo $pass > /etc/bandit_pass/$1
	chown $1 /etc/bandit_pass/$1
	chmod 400 /etc/bandit_pass/$1

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


mkdir /etc/bandit_pass
passwords=()

for i in {0..33}; do
	pass=$(create_user "bandit$i")
	passwords+=( $pass )
done


#level0 -> level1
goal='The password for the next level is stored in a file called readme located in the home directory. Use this password to log into bandit1 using SSH. Whenever you find a password for a level, use SSH (on port 2220) to log into that level and continue the game.'
commands='ls , cd , cat , file , du , find'
hints=''
echo "The password you are looking for is: ${passwords[0]}" > '/home/bandit0/readme'
set_perms 0 '/home/bandit0/readme'


#level1 -> level2
goal='The password for the next level is stored in a file called - located in the home directory'
commands='ls , cd , cat , file , du , find'
hints='Google Search for "dashed filename"
Advanced Bash-scripting Guide - Chapter 3 - Special Characters'

echo ${passwords[1]} > '/home/bandit1/-'
set_perms 1 '/home/bandit1/-'


#level2 -> level3
goal='The password for the next level is stored in a file called spaces in this filename located in the home directory'
commands='ls , cd , cat , file , du , find'
hints='Google Search for "spaces in filename"'

echo ${passwords[2]} > "/home/bandit2/spaces in this filename"
set_perms 2 "/home/bandit2/spaces in this filename"


#level3 -> level4
goal='The password for the next level is stored in a hidden file in the inhere directory.'
commands='ls , cd , cat , file , du , find'
hints=''

mkdir /home/bandit3/inhere
echo ${passwords[3]} > '/home/bandit3/inhere/...Hiding-From-You'
set_perms 3 '/home/bandit3/inhere/...Hiding-From-You'


#level4 -> level5
goal='The password for the next level is stored in the only human-readable file in the inhere directory. Tip: if your terminal is messed up, try the “reset” command.'
commands='ls , cd , cat , file , du , find'
hints=''

mkdir /home/bandit4/inhere
x=$(( RANDOM % 10))


for i in {0..9}; do
	if [[ $i -eq $x ]]
	then
		echo ${passwords[4]} > "/home/bandit4/inhere/-file0$i"
	else
	    cat /dev/urandom | fold -w 32 | head -n 1 > "/home/bandit4/inhere/-file0$i"
	fi
	set_perms 4 "/home/bandit4/inhere/-file0$i"
done



#level5 -> level6
goal='The password for the next level is stored in a file somewhere under the inhere directory and has all of the following properties:

    human-readable
    1033 bytes in size
    not executable
'
commands='ls , cd , cat , file , du , find'
hints=''

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
		pass="${passwords[5]}"
		x=" "
		for i in {1..1000}; do x="$x$x"; done

		echo $pass > "/home/bandit5/inhere/maybehere$i/-file2"
		chmod 750 /home/bandit5/inhere/maybehere$i/-file2
	fi
done



#level6 -> level7
goal='The password for the next level is stored somewhere on the server and has all of the following properties:

    owned by user bandit7
    owned by group bandit6
    33 bytes in size
'
commands='ls , cd , cat , file , du , find'
hints=''

mkdir -p /var/lib/dpkg/info/
echo ${passwords[6]} > /var/lib/dpkg/info/bandit7.password
chown bandit7 /var/lib/dpkg/info/bandit7.password
chgrp bandit6 /var/lib/dpkg/info/bandit7.password
chmod 640 /var/lib/dpkg/info/bandit7.password


#level7 -> level8
goal='The password for the next level is stored in the file data.txt next to the word millionth'
commands='man, grep, sort, uniq, strings, base64, tr, tar, gzip, bzip2, xxd'
hints=''

touch /home/bandit7/data.txt

while IFS= read -r line; do

	if [[ $line -eq millionth ]]
	then
		echo "millionth\t${passwords[7]}" >> /home/bandit7/data.txt
	else
		echo "$line `cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1`" >> /home/bandit7/data.txt
	fi
done < wordlist7.txt


#level8 -> level9
goal='The password for the next level is stored in the file data.txt and is the only line of text that occurs only once'
commands='man, grep, sort, uniq, strings, base64, tr, tar, gzip, bzip2, xxd'
hints=''

touch /home/bandit8/data_tmp.txt
x=$(( RANDOM % 1000))

for i in {1..100}; do
	
	rnd_string=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1`

	for j in {1..10}; do
		echo $rnd_string >> /home/bandit8/data_tmp.txt
	done
 
done

echo ${passwords[8]} >> /home/bandit8/data_tmp.txt

shuf /home/bandit8/data_tmp.txt > /home/bandit8/data.txt
rm /home/bandit8/data_tmp.txt



#level9 -> level10
goal='The password for the next level is stored in the file data.txt in one of the few human-readable strings, preceded by several ‘=’ characters.'
commands='man, grep, sort, uniq, strings, base64, tr, tar, gzip, bzip2, xxd'
hints=''

data='`cat data9.txt`'
echo data | base64 -d | tr FGUW5ilLVJrxX9kMYMmlN4MgbpfMiqey ${passwords[9]} > /home/bandit9/data.txt



#level10 -> level11
goal='The password for the next level is stored in the file data.txt, which contains base64 encoded data'
commands='man, grep, sort, uniq, strings, base64, tr, tar, gzip, bzip2, xxd'
hints=''

echo ${passwords[10]} | base64 > /home/bandit10/data.txt



#level11 -> level12
goal='The password for the next level is stored in the file data.txt, where all lowercase (a-z) and uppercase (A-Z) letters have been rotated by 13 positions'
commands='grep, sort, uniq, strings, base64, tr, tar, gzip, bzip2, xxd'
hints=''

echo ${passwords[11]} | tr 'a-mn-z' 'n-za-m' | tr 'A-MN-Z' 'N-ZA-M' > /home/bandit11/data.txt



#level12 -> level13
goal='The password for the next level is stored in the file data.txt, which is a hexdump of a file that has been repeatedly compressed. For this level it may be useful to create a directory under /tmp in which you can work. Use mkdir with a hard to guess directory name. Or better, use the command “mktemp -d”. Then copy the datafile using cp, and rename it using mv (read the manpages!)'
commands='grep, sort, uniq, strings, base64, tr, tar, gzip, bzip2, xxd, mkdir, cp, mv, file'
hints=''

