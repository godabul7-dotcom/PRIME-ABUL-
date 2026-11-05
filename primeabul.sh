#!/data/data/com.termux/files/usr/bin/bash

RED='\033[1;31m'
GREEN='\033[1;32m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
PURPLE='\033[1;35m'
WHITE='\033[1;37m'
RESET='\033[0m'

center() {
    local width plain pad
    width=$(tput cols 2>/dev/null)
    width=${width:-40}

    plain=$(printf '%b' "$1" | sed -E 's/\x1B\[[0-9;]*[[:alpha:]]//g')
    pad=$(( (width-${#plain})/2 ))
    ((pad < 0)) && pad=0

    printf "%*s" "$pad" ""
    printf '%b\n' "$1"
}

draw_header() {
    echo
    center "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    center "${GREEN}SYSTEM ONLINE 🟢${RESET}"
    center "${PURPLE}OWNER: PRIME ABUL${RESET}"
    center "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo
}

banner() {
    clear

    local width ART total delay line pad i
    width=$(tput cols 2>/dev/null)
    width=${width:-40}

    ART=$(figlet -f small -w "$width" "PRIME ABUL" 2>/dev/null)
    [ -z "$ART" ] && ART="PRIME ABUL"

    mapfile -t lines <<< "$ART"

    total=0
    for line in "${lines[@]}"; do
        total=$((total+${#line}))
    done

    [ "$total" -lt 1 ] && total=1
    delay=$(awk -v n="$total" 'BEGIN {printf "%.4f",20/n}')

    printf '%b' "$WHITE"

    for line in "${lines[@]}"; do
        pad=$(( (width-${#line})/2 ))
        ((pad < 0)) && pad=0

        printf "%*s" "$pad" ""

        for ((i=0; i<${#line}; i++)); do
            printf "%s" "${line:i:1}"
            sleep "$delay"
        done
        echo
    done
}

pause() {
    echo
    read -r -p "Press ENTER to continue..."
    clear
}

device_info() {
    echo -e "${CYAN}===== DEVICE INFORMATION =====${RESET}"
    echo "Device: $(getprop ro.product.model)"
    echo "Brand: $(getprop ro.product.brand)"
    echo "Manufacturer: $(getprop ro.product.manufacturer)"
    echo "Android: $(getprop ro.build.version.release)"
    echo "SDK: $(getprop ro.build.version.sdk)"
    echo "Architecture: $(uname -m)"
    echo "Kernel: $(uname -r)"
}

network_info() {
    echo -e "${CYAN}===== NETWORK INFORMATION =====${RESET}"
    echo
    echo "IP Addresses:"
    ip -brief addr 2>/dev/null
    echo
    echo "Default Route:"
    ip route 2>/dev/null
    echo
    echo "Internet Test:"
    ping -c 3 -W 2 1.1.1.1 2>/dev/null
}

storage_info() {
    echo -e "${CYAN}===== STORAGE INFORMATION =====${RESET}"
    echo
    echo "Termux Storage:"
    df -h "$HOME"
    echo
    if [ -d /sdcard ]; then
        echo "Phone Storage:"
        df -h /sdcard
    else
        echo "Phone storage unavailable."
    fi
}

battery_info() {
    echo -e "${CYAN}===== BATTERY INFORMATION =====${RESET}"
    echo

    if command -v termux-battery-status >/dev/null 2>&1; then
        termux-battery-status
    else
        echo "Termux:API unavailable."
        echo "Install Termux:API app and grant permission."
    fi

    if [ -r /sys/class/power_supply/battery/capacity ]; then
        echo "Battery Capacity: $(cat /sys/class/power_supply/battery/capacity)%"
    fi

    if [ -r /sys/class/power_supply/battery/status ]; then
        echo "Battery Status: $(cat /sys/class/power_supply/battery/status)"
    fi
}

date_info() {
    echo -e "${CYAN}===== DATE & TIME =====${RESET}"
    echo
    echo "Date: $(date '+%d-%m-%Y')"
    echo "Time: $(date '+%I:%M:%S %p')"
    echo "Day: $(date '+%A')"
    echo "Timezone: $(date '+%Z')"
}

cpu_ram_info() {
    echo -e "${CYAN}===== CPU & RAM INFORMATION =====${RESET}"
    echo
    echo "Architecture: $(uname -m)"
    echo "CPU Cores: $(nproc)"
    echo
    echo "RAM Information:"
    free -h
    echo
    echo "System Uptime:"
    uptime
}

thanks_message() {
    local message="THANKS FOR USING PRIME ABUL"
    local delay
    delay=$(awk 'BEGIN {printf "%.4f",2/27}')

    printf '%b' "$GREEN"
    for ((i=0; i<${#message}; i++)); do
        printf '%s' "${message:i:1}"
        sleep "$delay"
    done
    echo
    printf '%b' "$RESET"
}

# STARTUP: animated banner only once
banner

while true; do

    # Static header: no animation when returning to menu
    draw_header

    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo -e "${YELLOW}             MAIN MENU${RESET}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo
    echo -e "${GREEN}[1]${WHITE} Device Information"
    echo -e "${GREEN}[2]${WHITE} Network Information"
    echo -e "${GREEN}[3]${WHITE} Storage Information"
    echo -e "${GREEN}[4]${WHITE} Battery Information"
    echo -e "${GREEN}[5]${WHITE} Date & Time"
    echo -e "${GREEN}[6]${WHITE} CPU & RAM Information"
    echo -e "${RED}[7]${WHITE} Exit"
    echo

    read -r -p "$ " choice

    case "$choice" in
        1)
            clear
            device_info
            pause
            ;;
        2)
            clear
            network_info
            pause
            ;;
        3)
            clear
            storage_info
            pause
            ;;
        4)
            clear
            battery_info
            pause
            ;;
        5)
            clear
            date_info
            pause
            ;;
        6)
            clear
            cpu_ram_info
            pause
            ;;
        7|exit|quit)
            clear
            thanks_message
            sleep 1
            clear
            exit 0
            ;;
        *)
            echo -e "${RED}INVALID INPUT! Select 1-7.${RESET}"
            sleep 2
            clear
            ;;
    esac
done
