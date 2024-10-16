#!/bin/bash

#Generates 32chars long password
gen_passwd() {
	cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1
}

#Creates a bandit user, including password, home folder
create_user() {

	if [ "$1" = "bandit0" ]
	then
		pass='bandit0'
	else
		pass=$(gen_passwd)
	fi

	useradd -m "$1" -k "/etc/bandit_skel" -s "/bin/bash" -p $(openssl passwd -1 -salt "bandit" "$pass")
	
	mkdir "/home/$1/.ssh"
	echo "$pass" > "/etc/bandit_pass/$1"
	chown "$1" "/etc/bandit_pass/$1"
	chgrp "$1" "/etc/bandit_pass/$1"
	chmod 400 "/etc/bandit_pass/$1"
	echo $pass
}

#Sets specific permissions on given file : 
#banditX as group, banditX+1 as owner, and chmod 640
set_perms() {
	# $1 = current user id
	# $2 = file to set perms
	# $3 = chmod to apply
	chown bandit$(($1+1)) "$2"
	chgrp bandit$1 "$2"
	chmod $3 "$2"
}

#Create user MOTD (and few settings) :
#MOTD contains user's goal
#We also add a goal alias
create_motd() {
	# $1 = user id
	# $2 = goal
	echo -e "$2" > "/etc/bandit_goal/bandit$1"
	chmod 444 "/etc/bandit_goal/bandit$1"

	echo "alias goal='cat /etc/bandit_goal/bandit$1'" > "/home/bandit$1/.profile"

	echo "echo 'Level $1'" >> "/home/bandit$1/.profile"
	echo "echo 'Your goal is :'" >> "/home/bandit$1/.profile"
	echo "cat /etc/bandit_goal/bandit$1" >> "/home/bandit$1/.profile"

}

goals=()
goals+=( "The password for the next level is stored in a file called readme located in the home directory. Use this password to log into bandit1 using SSH. Whenever you find a password for a level, use SSH (on port 2220) to log into that level and continue the game." )
goals+=( "The password for the next level is stored in a file called - located in the home directory" )
goals+=( "The password for the next level is stored in a file called spaces in this filename located in the home directory" )
goals+=( "The password for the next level is stored in a hidden file in the inhere directory." )
goals+=( "The password for the next level is stored in the only human-readable file in the inhere directory. Tip: if your terminal is messed up, try the 'reset' command." )
goals+=( "The password for the next level is stored in a file somewhere under the inhere directory and has all of the following properties: \n-human-readable\n-1033 bytes in size\n-not executable" )
goals+=( "The password for the next level is stored somewhere on the server and has all of the following properties: \n-owned by user bandit7\n-owned by group bandit6\n-33 bytes in size" )
goals+=( "The password for the next level is stored in the file data.txt next to the word millionth" )
goals+=( "The password for the next level is stored in the file data.txt and is the only line of text that occurs only once" )
goals+=( "The password for the next level is stored in the file data.txt in one of the few human-readable strings, preceded by several '=' characters." )
#level 10
goals+=( "The password for the next level is stored in the file data.txt, which contains base64 encoded data" )
goals+=( "The password for the next level is stored in the file data.txt, where all lowercase (a-z) and uppercase (A-Z) letters have been rotated by 13 positions" )
goals+=( "The password for the next level is stored in the file data.txt, which is a hexdump of a file that has been repeatedly compressed. For this level it may be useful to create a directory under /tmp in which you can work. Use mkdir with a hard to guess directory name. Or better, use the command 'mktemp -d'. Then copy the datafile using cp, and rename it using mv (read the manpages!)" )
goals+=( "The password for the next level is stored in /etc/bandit_pass/bandit14 and can only be read by user bandit14. For this level, you don't get the next password, but you get a private SSH key that can be used to log into the next level. Note: localhost is a hostname that refers to the machine you are working on" )
goals+=( "The password for the next level can be retrieved by submitting the password of the current level to port 30000 on localhost." )
goals+=( "The password for the next level can be retrieved by submitting the password of the current level to port 30001 on localhost using SSL/TLS encryption. Helpful note: Getting 'DONE', 'RENEGOTIATING' or 'KEYUPDATE'? Read the 'CONNECTED COMMANDS' section in the manpage." )
goals+=( "The credentials for the next level can be retrieved by submitting the password of the current level to a port on localhost in the range 31000 to 32000. First find out which of these ports have a server listening on them. Then find out which of those speak SSL/TLS and which don't. There is only 1 server that will give the next credentials, the others will simply send back to you whatever you send to it. Helpful note: Getting 'DONE', 'RENEGOTIATING' or 'KEYUPDATE'? Read the 'CONNECTED COMMANDS' section in the manpage." )
goals+=( "There are 2 files in the homedirectory: passwords.old and passwords.new. The password for the next level is in passwords.new and is the only line that has been changed between passwords.old and passwords.new\n\nNOTE: if you have solved this level and see ‘Byebye!’ when trying to log into bandit18, this is related to the next level, bandit19" )
goals+=( "The password for the next level is stored in a file readme in the homedirectory. Unfortunately, someone has modified .bashrc to log you out when you log in with SSH." )
goals+=( "To gain access to the next level, you should use the setuid binary in the homedirectory. Execute it without arguments to find out how to use it. The password for this level can be found in the usual place (/etc/bandit_pass), after you have used the setuid binary." )
#level 20
goals+=( "There is a setuid binary in the homedirectory that does the following: it makes a connection to localhost on the port you specify as a commandline argument. It then reads a line of text from the connection and compares it to the password in the previous level (bandit20). If the password is correct, it will transmit the password for the next level (bandit21).\n\nNOTE: Try connecting to your own network daemon to see if it works as you think" )
goals+=( "A program is running automatically at regular intervals from cron, the time-based job scheduler. Look in /etc/cron.d/ for the configuration and see what command is being executed." )
goals+=( "A program is running automatically at regular intervals from cron, the time-based job scheduler. Look in /etc/cron.d/ for the configuration and see what command is being executed.\n\nNOTE: Looking at shell scripts written by other people is a very useful skill. The script for this level is intentionally made easy to read. If you are having problems understanding what it does, try executing it to see the debug information it prints." )
goals+=( "A program is running automatically at regular intervals from cron, the time-based job scheduler. Look in /etc/cron.d/ for the configuration and see what command is being executed.\n\nNOTE: This level requires you to create your own first shell-script. This is a very big step and you should be proud of yourself when you beat this level!\n\nNOTE 2: Keep in mind that your shell script is removed once executed, so you may want to keep a copy around…" )
goals+=( "A daemon is listening on port 30002 and will give you the password for bandit25 if given the password for bandit24 and a secret numeric 4-digit pincode. There is no way to retrieve the pincode except by going through all of the 10000 combinations, called brute-forcing.\nYou do not need to create new connections each time" )
goals+=( "Logging in to bandit26 from bandit25 should be fairly easy… The shell for user bandit26 is not /bin/bash, but something else. Find out what it is, how it works and how to break out of it.\n\nNOTE: if you’re a Windows user and typically use Powershell to ssh into bandit: Powershell is known to cause issues with the intended solution to this level. You should use command prompt instead." )
goals+=( "Good job getting a shell! Now hurry and grab the password for bandit27!" )
goals+=( "There is a git repository at ssh://bandit27-git@localhost/home/bandit27-git/repo via the port 2220. The password for the user bandit27-git is the same as for the user bandit27.\n\nClone the repository and find the password for the next level." )
goals+=( "There is a git repository at ssh://bandit28-git@localhost/home/bandit28-git/repo via the port 2220. The password for the user bandit27-git is the same as for the user bandit27.\n\nClone the repository and find the password for the next level." )
goals+=( "There is a git repository at ssh://bandit29-git@localhost/home/bandit29-git/repo via the port 2220. The password for the user bandit29-git is the same as for the user bandit29.\n\nClone the repository and find the password for the next level." )
#level 30
goals+=( "There is a git repository at ssh://bandit30-git@localhost/home/bandit30-git/repo via the port 2220. The password for the user bandit30-git is the same as for the user bandit30.\n\nClone the repository and find the password for the next level." )
goals+=( "There is a git repository at ssh://bandit31-git@localhost/home/bandit31-git/repo via the port 2220. The password for the user bandit31-git is the same as for the user bandit31.\n\nClone the repository and find the password for the next level." )
goals+=( "After all this git stuff, it’s time for another escape. Good luck!" )
goals+=( "The password for the next level is stored in an environment variable" )
goals+=( "The password for the next level is stored in a recently modified file" )
goals+=( "Get the password for the next level using a SUID file" )
goals+=( "Get the password for the next level using a SUID file" )
goals+=( "Get the password for the next level using a SUID file" )
goals+=( "The password for the next level is stored in a NFS share" )
goals+=( "The password for the next level is stored in your home folder, but the shell has been changed" )
#level 40


touch /etc/motd
mv /etc/motd /etc/motd.bak
cat motd.txt >/etc/motd

mkdir /etc/bandit_scripts
mkdir /etc/bandit_pass
mkdir /etc/bandit_goal
mkdir /etc/bandit_skel


current_path=$(pwd)
tmp_path=$(mktemp -d)
cd $tmp_path

passwords=()


echo -n "Creating users... "

for i in {0..40}; do
	pass=$(create_user "bandit$i")

  	$(create_motd "$i" "${goals[$i]}\n\n")
	passwords+=( $pass )
done

echo "done"


#level0 -> level1
echo -n "Creating level 0... "
echo -e "\nThe password you are looking for is: ${passwords[1]}\n" > '/home/bandit0/readme'
set_perms 0 '/home/bandit0/readme' 640
echo "done"


#level1 -> level2
echo -n "Creating level 1... "
echo ${passwords[2]} > '/home/bandit1/-'
set_perms 1 '/home/bandit1/-' 640
echo "done"


#level2 -> level3
echo -n "Creating level 2... "
echo ${passwords[3]} > "/home/bandit2/spaces in this filename"
set_perms 2 "/home/bandit2/spaces in this filename" 640
echo "done"


#level3 -> level4
echo -n "Creating level 3... "
mkdir /home/bandit3/inhere
echo ${passwords[4]} > '/home/bandit3/inhere/...Hiding-From-You'
set_perms 3 '/home/bandit3/inhere/...Hiding-From-You' 640
echo "done"


#level4 -> level5
echo -n "Creating level 4... "
mkdir /home/bandit4/inhere
x=$(( RANDOM % 10))

for i in {0..9}; do
	if [[ $i -eq $x ]]
	then
		echo ${passwords[5]} > "/home/bandit4/inhere/-file0$i"
	else
	    cat /dev/urandom | fold -w 32 | head -n 1 > "/home/bandit4/inhere/-file0$i"
	fi
	set_perms 4 "/home/bandit4/inhere/-file0$i" 640
done
echo "done"


#level5 -> level6
echo -n "Creating level 5... "
mkdir /home/bandit5/inhere

for i in $(seq -w 0 19)
do
	mkdir "/home/bandit5/inhere/maybehere$i"

	for j in $(seq 0 9)
	do
		if [[ $(( RANDOM % 5 )) -eq 0 ]]
		then 
			size=1033
		else
			size=$(( RANDOM ))
		fi

		if [[ $(( RANDOM % 5 )) -eq 0 ]]
		then
			cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w "$((size-1))" | head -n 1 > "/home/bandit5/inhere/maybehere$i/file$j"
		else
			$(python "$current_path/scripts/5_write_bin_file.py" "$size" "/home/bandit5/inhere/maybehere$i/file$j")
		fi

		if [[ $(( RANDOM % 4 )) -eq 0 ]]
		then
			chmod 640 "/home/bandit5/inhere/maybehere$i/file$j"
		else
			chmod 750 "/home/bandit5/inhere/maybehere$i/file$j"
		fi

		chgrp bandit5 "/home/bandit5/inhere/maybehere$i/file$j"
	done
done

rnd_dir=$(seq -w 0 19 | shuf | head -n 1)
rnd_file=$(seq -w 0 9 | shuf | head -n 1)

spaces=$(python -c "print(' ' * 984)")
echo "The password is ${passwords[6]}$spaces" > "/home/bandit5/inhere/maybehere$rnd_dir/file$rnd_file"
chmod 640 "/home/bandit5/inhere/maybehere$rnd_dir/file$rnd_file"

echo "done"


#level6 -> level7
echo -n "Creating level 6... "
mkdir -p /var/lib/dpkg/info/
echo ${passwords[7]} > /var/lib/dpkg/info/bandit7.password
set_perms 6 /var/lib/dpkg/info/bandit7.password 640
echo "done"


#level7 -> level8
echo -n "Creating level 7... "

cp "$current_path/data/7_wordlist.txt.gz" /home/bandit7/7_wordlist.txt.gz
gzip -d /home/bandit7/7_wordlist.txt.gz

word="millionth"
line=$(grep "$word" /home/bandit7/7_wordlist.txt)
sed -i "s/$line/$word\t${passwords[8]}/" "/home/bandit7/7_wordlist.txt"

mv /home/bandit7/7_wordlist.txt /home/bandit7/data.txt
set_perms 7 /home/bandit7/data.txt 640

echo "done"


#level8 -> level9
echo -n "Creating level 8... "
touch /home/bandit8/data_tmp.txt

for i in {1..100}; do
	
	rnd_string=$(gen_passwd)

	for j in {1..10}; do
		echo $rnd_string >> /home/bandit8/data_tmp.txt
	done
 
done

echo ${passwords[9]} >> /home/bandit8/data_tmp.txt

shuf /home/bandit8/data_tmp.txt > /home/bandit8/data.txt
rm /home/bandit8/data_tmp.txt
echo "done"


#level9 -> level10
echo -n "Creating level 9... "
cat /dev/urandom | fold -w $(( RANDOM % 9000 )) | head -n 1 > /home/bandit9/data.txt
echo -n "$before====== ${passwords[10]}     $after" >> /home/bandit9/data.txt
cat /dev/urandom | fold -w $(( RANDOM % 9000 )) | head -n 1 >> /home/bandit9/data.txt
echo "done"


#level10 -> level11
echo -n "Creating level 10... "
echo "The password is ${passwords[11]}" | base64 > /home/bandit10/data.txt
echo "done"


#level11 -> level12
echo -n "Creating level 11... "
echo "The password is ${passwords[12]}" | tr 'a-mn-z' 'n-za-m' | tr 'A-MN-Z' 'N-ZA-M' > /home/bandit11/data.txt
echo "done"


#level12 -> level13
echo -n "Creating level 12... "
echo ${passwords[13]} > "data8"
gzip -c "data8" > "data8.bin"
tar cvf "data7.tar" --absolute-names "data8.bin" 1>/dev/null 2>/dev/null
bzip2 -c "data7.tar" > "data6.bin"
tar cvf "data5.bin" --absolute-names "data6.bin" 1>/dev/null 2>/dev/null
tar cvf "data4.bin" --absolute-names "data5.bin" 1>/dev/null 2>/dev/null
gzip -c "data4.bin" > "data3.bin"
bzip2 -c "data3.bin" > "data2.bin"
gzip -c "data2.bin" > "data1.bin"
xxd "data1.bin" > /home/bandit12/data.txt
rm data*
echo "done"


#level13 -> level14
echo -n "Creating level 13... "
ssh-keygen -q -f ./sshkey.private -N "" 1>/dev/null 2>/dev/null
mv ./sshkey.private /home/bandit13/
set_perms 13 "/home/bandit13/sshkey.private" 640
mv ./sshkey.private.pub /home/bandit14/.ssh/authorized_keys
echo "done"


#level14 -> level15
echo -n "Creating level 14... "
cp "$current_path/scripts/14_listener_tcp.py" /etc/bandit_scripts/script14.py
echo "@reboot root python /etc/bandit_scripts/script14.py &> /dev/null" > /etc/cron.d/cronjob_bandit14
echo "done"


#level15 -> level16
echo -n "Creating level 15... "
cp "$current_path/scripts/15_listener_ssl.py" /etc/bandit_scripts/script15.py
echo "@reboot root python /etc/bandit_scripts/script15.py &> /dev/null" > /etc/cron.d/cronjob_bandit15
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout "/etc/bandit_scripts/script15.key" -out "/etc/bandit_scripts/script15.pem" -subj "/" 1>/dev/null 2>/dev/null
echo "done"


#level16 -> level17
echo -n "Creating level 16... "

ssh-keygen -q -f ./sshkey17.private -N "" 1>/dev/null 2>/dev/null
mv ./sshkey17.private /etc/bandit_scripts/sshkey17.private
mv ./sshkey17.private.pub /home/bandit17/.ssh/authorized_keys

cp "$current_path/scripts/16_multiple_listeners.py" /etc/bandit_scripts/script16.py
echo "@reboot root python /etc/bandit_scripts/script16.py &> /dev/null" > /etc/cron.d/cronjob_bandit16

openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout "/etc/bandit_scripts/script16.key" -out "/etc/bandit_scripts/script16.pem" -subj "/" 1>/dev/null 2>/dev/null
echo "done"


#level17 -> level18
echo -n "Creating level 17... "

touch "/home/bandit17/passwords.old"
set_perms 17 "/home/bandit17/passwords.old" 640

for i in {1..100}; do
	gen_passwd >> "/home/bandit17/passwords.old"
done

rnd_line=$(sed -n -e $((RANDOM % 100 +1))p /home/bandit17/passwords.old)
sed "s/$rnd_line/${passwords[18]}/" "/home/bandit17/passwords.old" > "/home/bandit17/passwords.new"
echo "done"


#level18 -> level19
echo -n "Creating level 18... "
echo ${passwords[19]} > "/home/bandit18/readme"
echo 'exit 0' >> "/home/bandit18/.profile"
echo "done"


#level19 -> level20
echo -n "Creating level 19... "
gcc "$current_path/scripts/19_suid.c" -o "/home/bandit19/bandit20-do"
set_perms 19 "/home/bandit19/bandit20-do" 4750
echo "done"


#level20 -> level21
echo -n "Creating level 20... "
gcc "$current_path/scripts/20_tcp_connect.c" -o "/home/bandit20/suconnect"
set_perms 20 "/home/bandit20/suconnect" 4750
echo "done"


#level21 -> level22
echo -n "Creating level 21... "
echo "@reboot bandit22 /usr/bin/cronjob_bandit22.sh &> /dev/null" > /etc/cron.d/cronjob_bandit22
echo "* * * * * bandit22 /usr/bin/cronjob_bandit22.sh &> /dev/null" >> /etc/cron.d/cronjob_bandit22

sed "s/__PLACEHOLDER__/$(gen_passwd)/" "$current_path/scripts/22_tmp_file.sh" > "/usr/bin/cronjob_bandit22.sh"

set_perms 21 "/usr/bin/cronjob_bandit22.sh" 750
echo "done"


#level22 -> level23
echo -n "Creating level 22... "
echo "@reboot bandit23 /usr/bin/cronjob_bandit23.sh &> /dev/null" > /etc/cron.d/cronjob_bandit23
echo "* * * * * bandit23 /usr/bin/cronjob_bandit23.sh &> /dev/null" >> /etc/cron.d/cronjob_bandit23

cp "$current_path/scripts/23_tmp_file2.sh" "/usr/bin/cronjob_bandit23.sh"
set_perms 22 "/usr/bin/cronjob_bandit23.sh" 750
echo "done"


#level23 -> level24
echo -n "Creating level 23... "

echo "@reboot bandit24 /usr/bin/cronjob_bandit24.sh &> /dev/null" > /etc/cron.d/cronjob_bandit24
echo "* * * * * bandit24 /usr/bin/cronjob_bandit24.sh &> /dev/null" >> /etc/cron.d/cronjob_bandit24

mkdir -p "/var/spool/bandit24/foo"
chmod 777 "/var/spool/bandit24/foo"

cp "$current_path/scripts/24_script_launcher.sh" "/usr/bin/cronjob_bandit24.sh"
set_perms 23 "/usr/bin/cronjob_bandit24.sh" 750
echo "done"


#level24 -> level25
echo -n "Creating level 24... "

pin=$(seq -w 0 9999 | shuf | head -n 1)
echo "$pin" > "/etc/bandit_pass/bandit25pin"
set_perms 25 "/etc/bandit_pass/bandit25pin" 400

cp "$current_path/scripts/25_listener_pin.py" /etc/bandit_scripts/script25.py
echo "@reboot root python /etc/bandit_scripts/script25.py &> /dev/null" > /etc/cron.d/cronjob_bandit25

echo "done"


#level25 -> level26
echo -n "Creating level 25... "

ssh-keygen -q -f ./bandit26.sshkey -N "" 1>/dev/null 2>/dev/null
mv ./bandit26.sshkey /home/bandit25/
set_perms 25 "/home/bandit25/bandit26.sshkey" 640
mv ./bandit26.sshkey.pub /home/bandit26/.ssh/authorized_keys

touch /usr/bin/showtext
echo '#!/bin/sh' >> /usr/bin/showtext
echo 'export TERM=linux' >> /usr/bin/showtext
echo 'exec more /etc/motd' >> /usr/bin/showtext
echo 'exit 0' >> /usr/bin/showtext

chmod +x "/usr/bin/showtext"
usermod -s /usr/bin/showtext bandit26
echo "done"


#level26 -> level27
echo -n "Creating level 26... "
gcc "$current_path/scripts/19_suid.c" -o "/home/bandit26/bandit27-do"
set_perms 26 "/home/bandit26/bandit27-do" 4750

echo "done"



#level27 -> level28
echo -n "Creating level 27... "

useradd -m "bandit27-git" -k "/etc/bandit_skel" -s "/usr/bin/git-shell" -p $(openssl passwd -1 -salt "bandit" "${passwords[27]}")

sudo -u bandit27-git bash -c "git config --global user.name 'bandit' && git config --global user.email 'bandit@world.net' \
&& mkdir -p /home/bandit27-git/repo \
&& cd /home/bandit27-git/repo \
&& git init -q \
&& echo 'The password to the next level is : ${passwords[28]}' > readme \
&& git add . \
&& git commit -m 'initial commit' -q"

echo "done"



#level28 -> level29
echo -n "Creating level 28... "
useradd -m "bandit28-git" -k "/etc/bandit_skel" -s "/usr/bin/git-shell" -p $(openssl passwd -1 -salt "bandit" "${passwords[28]}")

sudo -u bandit28-git bash -c "git config --global user.name 'bandit' && git config --global user.email 'bandit@world.net' \
&& mkdir -p /home/bandit28-git/repo \
&& cd /home/bandit28-git/repo \
&& git init -q \
&& echo -e '# Bandit Notes\nSome notes for level29 of bandit.\n\n## credentials\n\n- username: bandit29\n- password: <TBD>\n' > readme \
&& git add . \
&& git commit -m 'initial commit' -q \
&& echo -e '# Bandit Notes\nSome notes for level29 of bandit.\n\n## credentials\n\n- username: bandit29\n- password: ${passwords[29]}\n' > readme \
&& git add . \
&& git commit -m 'add missing data' -q \
&& echo -e '# Bandit Notes\nSome notes for level29 of bandit.\n\n## credentials\n\n- username: bandit29\n- password: xxxxxxxxxxxx\n' > readme \
&& git add . \
&& git commit -m 'fix info leak' -q"
echo "done"



#level29 -> level30
echo -n "Creating level 29... "
useradd -m "bandit29-git" -k "/etc/bandit_skel" -s "/usr/bin/git-shell" -p $(openssl passwd -1 -salt "bandit" "${passwords[29]}")

sudo -u bandit29-git bash -c "git config --global user.name 'bandit' && git config --global user.email 'bandit@world.net' \
&& mkdir -p /home/bandit29-git/repo \
&& cd /home/bandit29-git/repo \
&& git init -q \
&& echo -e '# Bandit Notes\nSome notes for level29 of bandit.\n\n## credentials\n\n- username: bandit29\n- password: <no passwords in production !>\n' > readme \
&& git add . \
&& git commit -m 'initial commit' -q \
&& echo -e '# Bandit Notes\nSome notes for level30 of bandit.\n\n## credentials\n\n- username: bandit30\n- password: <no passwords in production !>\n' > readme \
&& git add . \
&& git commit -m 'fix username' -q \
&& git checkout -b sploits-dev -q \
&& mkdir exploits \
&& touch exploits/pwn_everything.sh \
&& git add . \
&& git commit -m 'just adding the ultime exploit' -q \
&& git checkout -b dev -q \
&& mkdir code \
&& touch code/simple_script.sh \
&& git add . \
&& git commit -m 'Simple script' -q \
&& echo -e '# Bandit Notes\nSome notes for level30 of bandit.\n\n## credentials\n\n- username: bandit30\n- password: ${passwords[30]}\n' > readme \
&& git add . \
&& git commit -m 'add data needed' -q \
&& git checkout master -q"

echo "done"


#level30 -> level31
echo -n "Creating level 30... "

useradd -m "bandit30-git" -k "/etc/bandit_skel" -s "/usr/bin/git-shell" -p $(openssl passwd -1 -salt "bandit" "${passwords[30]}")

sudo -u bandit30-git bash -c "git config --global user.name 'bandit' && git config --global user.email 'bandit@world.net' \
&& mkdir -p /home/bandit30-git/repo \
&& cd /home/bandit30-git/repo \
&& git init -q \
&& echo 'Just an empty file ahahah' > readme \
&& git add . \
&& git commit -m 'initial commit' -q"

sudo -u bandit30-git bash -c "cd /home/bandit30-git/repo \
&& echo ${passwords[31]@Q} | git hash-object -w --stdin > hash \
&& git tag -a -m ${passwords[31]@Q} secret < hash \
&& cat hash | tr -d '\n' > .git/packed-refs \
&& echo ' refs/tags/secret' >> .git/packed-refs \
&& rm .git/refs/tags/secret \
&& rm hash"

echo "done"



#level31 -> level32
echo -n "Creating level 31... "

useradd -m "bandit31-git" -k "/etc/bandit_skel" -s "/usr/bin/git-shell" -p $(openssl passwd -1 -salt "bandit" "${passwords[31]}")

sudo -u bandit31-git bash -c "git config --global user.name 'bandit' && git config --global user.email 'bandit@world.net' \
&& mkdir -p /home/bandit31-git/repo \
&& cd /home/bandit31-git/repo \
&& git init -q \
&& echo \"This time you'll need to commit and push a file name key.txt that contains 'Can I come in?'\" > readme \
&& git add . \
&& git commit -m 'initial commit' -q \
&& mv .git ../repo.git \
&& cd .. \
&& rm -fr repo \
&& cd repo.git \
&& git config --bool core.bare true"

sed "s/__PLACEHOLDER__/${passwords[32]}/" "$current_path/scripts/31_git_hook" > "/home/bandit31-git/repo.git/hooks/pre-receive"
chown bandit31-git "/home/bandit31-git/repo.git/hooks/pre-receive"
chgrp bandit31-git "/home/bandit31-git/repo.git/hooks/pre-receive"
chmod +x /home/bandit31-git/repo.git/hooks/pre-receive

echo "done"


#level32 -> level33
#shell jail
echo -n "Creating level 32... "
echo "${passwords[33]}" >> /home/bandit32/readme

gcc "$current_path/scripts/32_uppershell.c" -o "/home/bandit32/uppershell"
set_perms 32 "/home/bandit32/uppershell" 4750
usermod -s /home/bandit32/uppershell bandit32
echo "done"


#level33 -> level34
echo -n "Creating level 33... "
echo "export bandit34=${passwords[34]}" >> /home/bandit33/.profile
echo "head -n 4 /home/bandit33/.profile > /home/bandit33/profile2" >> /home/bandit33/.profile
echo "mv /home/bandit33/profile2 /home/bandit33/.profile" >> /home/bandit33/.profile
chown bandit33 /home/bandit33/.profile
chgrp bandit33 /home/bandit33/.profile
chmod 744 /home/bandit33/.profile
echo "done"


#level34 -> level35
echo -n "Creating level 34... "
mkdir -p "/usr/local/share/man/"
rnd_file=$(gen_passwd)

echo ${passwords[35]} > "/usr/local/share/man/$rnd_file"


echo "@reboot bandit35 /usr/bin/cronjob_bandit35.sh &> /dev/null" > /etc/cron.d/cronjob_bandit35
echo "* * * * * bandit35 /usr/bin/cronjob_bandit35.sh &> /dev/null" >> /etc/cron.d/cronjob_bandit35

sed "s/__PLACEHOLDER__/$rnd_file/" "$current_path/scripts/35_cron_touch.sh" > "/usr/bin/cronjob_bandit35.sh"


chown bandit35 "/usr/bin/cronjob_bandit35.sh"
chgrp bandit35 "/usr/bin/cronjob_bandit35.sh"
chmod 750 "/usr/bin/cronjob_bandit35.sh"

echo "done"


#level35 -> level36
echo -n "Creating level 35... "

cp /bin/base64 /home/bandit35/base64
set_perms 35 "/home/bandit35/base64" 4750
echo "done"


#level36 -> level37
echo -n "Creating level 36... "

cp /bin/find /home/bandit36/find
set_perms 36 "/home/bandit36/find" 4750
echo "done"


#level37 -> level38
echo -n "Creating level 37... "

cp /bin/cp /home/bandit37/cp
set_perms 37 "/home/bandit37/cp" 4750
echo "done"


#level38 -> level39
echo -n "Creating level 38... "

mkdir -p /mnt/bandit38
set_perms 38 "/mnt/bandit38" 750

echo ${passwords[39]} > "/mnt/bandit38/readme"
set_perms 38 "/mnt/bandit38/readme" 640

echo '/mnt/bandit38 *(ro,subtree_check,all_squash)' >> /etc/exports
service nfs-kernel-server restart
#exportfs -a

echo "done"


#level39 -> level40
echo -n "Creating level 39... "
echo ${passwords[40]} > "/home/bandit39/readme"
set_perms 37 "/home/bandit39/readme" 640
usermod -s /usr/bin/python bandit39
echo "done"


#level40
echo -n "Creating level 40... "
echo 'Thanks for playing !' > '/home/bandit40/readme'
echo "done"


echo;
echo "If you are starting this script manually (not with docker), you need to reboot to activate cronjobs !"
echo "Enjoy !"