#!/data/data/com.termux/files/usr/bin/bash

GREEN='\033[1;32m'
CYAN='\033[1;36m'
RED='\033[1;31m'
RESET='\033[0m'

clear
echo -e "${CYAN}=============================="
echo "       PRIME ABUL INSTALLER"
echo -e "==============================${RESET}"

if [ ! -d "$PREFIX" ]; then
    echo -e "${RED}Termux environment required!${RESET}"
    exit 1
fi

echo -e "${GREEN}[+] Installing packages...${RESET}"
pkg install figlet coreutils iproute2 procps termux-api -y

echo -e "${GREEN}[+] Installing PRIME ABUL...${RESET}"

cp "$(dirname "$0")/primeabul.sh" "$PREFIX/bin/primeabul"
chmod +x "$PREFIX/bin/primeabul"

echo
echo -e "${GREEN}PRIME ABUL INSTALLED SUCCESSFULLY!${RESET}"
echo
echo "Run your tool using:"
echo -e "${CYAN}primeabul${RESET}"
