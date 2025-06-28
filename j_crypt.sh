#! /bin/bash
# This script is designed to encrypt/decrypt certain parts of itself and later execute some (or several) secret code(s).
#
#
# You can test this script using the following method:
# MYVAR=PASS bash /tmp/j_crypt.sh
# The output should be:
# Hello Encrypted Word!
#
# The "secret code" segments are at the end of this file, each segment is marked by 5 random words separated by  underscores (_) with these
# words enclosed within a hash (#) marker -->   #word_word_word_word_word#.
# To facilitate storage and portability of the code, the encrypted portion (using OpenSSL) is converted to base64, making it easier to open
# and edit the file without the text editor altering the "binary" content of the encrypted section.
#
#
###########################################################################################################################################
###########################################################################################################################################
#
#
#
# The FIND variable stores the MD5 hash of a string formed by a <VARIABLE>=<VALUE>.
# Here, we look for this variable with its exact value, which corresponds to the password that decrypts some code snippet.
# EXAMPLE: We declare the variable MYVAR=PASS. If we take the string "MYVAR=PASS" and pass it through the md5sum function, we get the value
# c2b3374c46fed462ca3da4c8bdea2e17, so in our example FIND="c2b3374c46fed462ca3da4c8bdea2e17", since we are looking for the password PASS,
# which must be stored in the variable MYVAR.
FIND="c2b3374c46fed462ca3da4c8bdea2e17"

# This function executes the output of the terminal pipe, adding the value of the variable VAR=$VAR to the bash execution environment.
function crysh () {
	env "VAR=$VAR" bash
}

# This function encrypts the input from the pipe, requiring the name of the variable "$1" that holds the encryption password.
function enc(){
	openssl enc -aes-256-cbc -pbkdf2 -nosalt  -base64 -pass "env:$1"
}

# This function dencrypts the input from the pipe, requiring the name of the variable "$1" that holds the dencryption password.
function dec() {
	openssl enc -aes-256-cbc -d -pbkdf2 -nosalt  -base64 -pass "env:$1"
}

# This function searches for code segments separated by delimiters, which were previously mentioned at the beginning of the script, line 10.
# The first variable indicates the upper delimiter, meaning where the segment starts.
# The second variable indicates the lower delimiter, meaning where the segment ends.
# In the end, sed is used to print only the lines between the delimiters.
function get_script(){
	A=$( awk "/^$1/ {print FNR}" $0 )
	B=$( awk "/^$2/ {print FNR}" $0 )
	sed -n "$(( ++A )),$(( --B ))p" $0
}

# This section begins the execution of the script, reading all environment variables and checking whether each variable and its respective
# value match the MD5 hash already stored in the $FIND variable, on line 26.
# If the hash matches, it means the variable and its corresponding value (the password) were found, and the code continues execution.
# In the example below, the uncommented line calls get_script, passing the two markers INITIAL and FINAL so that it can be decrypted by the
# dec function. In this way, the code execution simply prints the value to the screen.
env | while read THIS; do
	if [ $( echo "$THIS" | md5sum | awk '{ print $1 }' | grep -c "$FIND" ) -ne 0 ]; then
		VAR=$( echo $THIS | awk -F "=" '{ print $1 }' )

		printf  "Test#1:\n"
		get_script "#cloud_mirror_jump_silent_tiger#" "#river_glass_shadow_dream_fire#" | dec "$VAR"

		printf "\n\nTeste#2:\n"
		get_script "#river_glass_shadow_dream_fire#" "#stone_light_whisper_branch_wind#"  | enc "$VAR"

		printf "\n\nTeste#3 DECODE:\n"
		get_script "#stone_light_whisper_branch_wind#" "#apple_bridge_random_glow_silent#" | dec "$VAR"
		printf "Teste#3 DECODE AND EXECUTE:\n"
		get_script "#stone_light_whisper_branch_wind#" "#apple_bridge_random_glow_silent#"  | dec "$VAR" | crysh

		exit
	fi
done


exit
#cloud_mirror_jump_silent_tiger#

6IOKWJYxb2nctemDlyiDE3EeuwYcVmzOIIufjs9DRIw=

#river_glass_shadow_dream_fire#
This line will simply be encrypted!
Bye World!

#stone_light_whisper_branch_wind#

TRrqwP3j8hz14KXdPfcHk2kb1oOa8kQ17gg0b/n9kYKiOEb1V5WbJ3hgfg1RDE8G
9vll4oe9v7scXTUMS6C+TpbiHW63OF9+93YbppqR+PpuLRegj25uakmhv8MMvLUa

#apple_bridge_random_glow_silent#


#forest_jump_cloud_spark_wonder#

#dream_stone_light_wave_shadow#
