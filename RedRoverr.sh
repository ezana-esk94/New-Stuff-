#!/bin/zsh

## Script scans my entire home subnet and
## reports active sessions of the specified port.
## Finally gives user the option to deep scan the open port

## Prep work
subnet="192.168.12.1/24"
tmp_file="tmp_file" #Helpful to define this file at the beginning to broaden the variable

# Update OpenSSL and Nmap (you may need to use the appropriate package manager for your system)
# For example, on Debian-based systems:
# sudo apt-get update
# sudo apt-get install --only-upgrade openssl nmap

# On MacOs,
# brew upgrade openssl nmap

# Some basic formatting
clear
echo
echo
echo
echo -e "\t\tJust a moment... Scanning for active  \e[33mPORT ${1}\e[0m  sessions"
echo
echo
echo
echo
echo -e "\t\e[32mScan in progress: \e[0m"
nmap -p "${1}" "${subnet}" | grep --color=always -i open -B 4 -A 1 | tee tmp_file


###############
sleep 4; echo
echo

########### exits if no open ports were discovered
if ! grep -q "open" "$tmp_file"; then
  echo -e "\t\tNo open ports found. Exiting the script."
  exit
fi
############### asks the user to scan further
echo -e "Continue to a deep port scan of \e[33mPORT ${1}\e[0m? (Y/N) \c"
read deep_scan
case $deep_scan in
Y | y | yes | Yes)

    grep --color=always -Eo "\b(?:\d{1,3}\.){3}\d{1,3}\b" "$tmp_file" | while read -r i
    do
      echo
      echo
      echo -e "\t\e[32mPort Scan Results: \e[0m"
      nmap -p ${1} -A $i -oN "${i}.nmap_scan"
    done
      ;;
N | n | no | No)
      exit
      ;;
*)
      echo "Invalid entry: Enter Yes or No"
      ;;
esac
