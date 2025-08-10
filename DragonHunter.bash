#!/bin/bash

# Check dependencies
command -v nmap >/dev/null 2>&1 || { echo >&2 "nmap is required but not installed. Aborting."; exit 1; }
command -v curl >/dev/null 2>&1 || { echo >&2 "curl is required but not installed. Aborting."; exit 1; }
command -v gobuster >/dev/null 2>&1 || { echo >&2 "gobuster is required but not installed. Aborting."; exit 1; }
command -v subfinder >/dev/null 2>&1 || { echo >&2 "subfinder is required but not installed. Aborting."; exit 1; }
command -v figlet >/dev/null 2>&1 || { echo >&2 "figlet is required but not installed. Aborting."; exit 1; }
command -v lolcat >/dev/null 2>&1 || { echo >&2 "lolcat is required but not installed. Aborting."; exit 1; }

# Clear Screen
clear

# Dragon ASCII Banner
echo -e "\e[31m" # Set text color to red
cat << "EOF" | lolcat
           \                    / \  //\
            )  (   (            )  (/  \)
           (   )  ) (            )   (/  )
           ) (   (  )           (   ( ) (
        ,----|  |------,      ,-----|  |----.
       /       \ |      \    /      / |      \
      |  o  o  ||  o  o  |  |  o  o  ||  o  o  |
      |   --   ||   --   |  |   --   ||   --   |
      |  \__/  ||  \__/  |  |  \__/  ||  \__/  |
      \_______/\_______/  \_______/\_______/
       /   /        \   \  /   /        \   \
      (   )          (   )(   )          (   )
EOF
echo -e "\e[33m🔥 Welcome to DragonHunter - The Ultimate Bug Bounty Scanner 🔥\e[0m"
echo -e "\e[32m--------------------------------------------------------------\e[0m"
echo -e "\e[36mAuthor: ALLU444 | Version: 1.0\e[0m"
echo ""
# Adding BIG Dragon ASCII for ALLU444
cat << "EOF"
                                              ,d888*`
                                              ,d888`
                                            ,d888`
                                           ,d88`
                                         ,d88`
                                        ,d8`
                                      ,d8*                 ..d**
                                    ,d88*             ..d**`
                                  ,d88`         ..d8*`
                                ,d888`    ..d8P*`
                        .     ,d8888*8888*`
                      ,*     ,88888*8P*
                    ,*      d888888*8b.
                  ,P       dP  *888.*888b.
                ,8*        8    *888  `**88888b.
              ,dP                *88           *88b.
             d8`                  *8b               *8b.
           ,d8`                    *8.                  *88b.
          d8P                       88.                    *88b
        ,88P                        888
       d888*       .d88P            888
      d8888b..d888888*              888
    ,888888888888888b.              888
   ,8*;88888P*****788888888ba.      888
  ,8;,8888*        `88888*          d88*
  )8e888*          ,88888be.        888
 ,d888`           ,8888888***     d888
,d88P`           ,8888888Pb.     d888`
888*            ,88888888**   .d8888*
`88            ,888888888    .d88888b
 `P           ,8888888888bd888888*
              d888888888888d888*
              8888888888888888b.
              88*. *88888888888b.        .db
              `888b.`8888888888888b. .d8888P
               **88b.`*8888888888888888888888b...
                *888b.`*8888888888P***7888888888888e.
                 88888b.`********.d8888b**`88888P*
                 `888888b     .d88888888888**`8888.
                  )888888.   d888888888888P   `8888888b.
                 ,88888*    d88888888888**`    `8888b
                ,8888*    .8888888888P`          `888b.
               ,888*      888888888b...            `888P88b.
      .db.   ,d88*        88888888888888b          `8888
  ,d888888b.8888`         `*888888888888888888P`   `888b.
 /*****8888b**`              `***8888P*``8888`       `8888b.
      /**88`                 .ed8b..  .d888P`            `88888
                           d8**888888888P*               `88b
                          (*``,d8888***`                    `88
                             (*`                             `88
                                                              88
                                                              88
                                                             `8
                                                             d8
EOF
echo -e "\e[0m" # Reset text color
echo -e "\e[32m🐉 DragonHunter has Completed the Hunt! 🐉\e[0m"
echo -e "\e[32m🐉 Check the Results in the Files Generated 🐉\e[0m"
echo -e "\e[32m🐉 Happy Hunting! 🐉\e[0m"

# Check if URL is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <target_url>"
    exit 1
fi

target="$1"
HOST=$(echo "$target" | awk -F/ '{print $3}')

if [ -z "$HOST" ]; then
    echo "Invalid target URL"
    exit 1
fi

echo -e "\n\e[35m🐉 Scanning Target: $target ($HOST) 🐉\e[0m\n"

# Spinner function
spinner() {
    local pid=$!
    local delay=0.1
    local spinstr='🔥🔥🔥🔥🔥🔥'
    echo -n " "
    while kill -0 $pid 2>/dev/null; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    echo " 🐲 Done!"
}

# Function: Port Scan
port_scan() {
    echo -e "\e[31m🔥 Breathing Fire on Open Ports... 🔥\e[0m"
    nmap -p 80,443 --min-rate=10000 -T4 -A --script=vuln "$HOST" | tee port_scan_results.txt & spinner
}

# Function: HTTP Enumeration
http_enum() {
    echo -e "\e[33m🛡️ Scanning Web Shields... 🛡️\e[0m"
    nmap -p 80,443 --script=http-enum,http-title,http-headers,http-methods,http-vuln* "$HOST" | tee http_enum_results.txt & spinner
}

# Function: Find Valid Endpoints
find_valid_endpoints() {
    echo -e "\e[34m🔍 Seeking Hidden Dragon Passages... 🔍\e[0m"
    COMMON_PARAMS=("id" "user" "data" "page" "product" "article" "post" "listproducts")
    > valid_endpoints.txt
    for param in "${COMMON_PARAMS[@]}"; do
        RESPONSE=$(curl -s --max-time 5 "$target/?$param=1")
        if [[ "$RESPONSE" =~ "error" || "$RESPONSE" =~ "database" || "$RESPONSE" =~ "id" ]]; then
            echo -e "\e[32m[+] Found Hidden Endpoint: $target/?$param=1\e[0m"
            echo "$target/?$param=" >> valid_endpoints.txt
        fi
    done
}

# Function: SQL Injection Test
check_sql_injection() {
    echo -e "\e[31m🔥 Testing Dragon's Fury (SQLi)... 🔥\e[0m"
    PAYLOADS=("' OR '1'='1' --" "' OR '1'='1' #" "' OR 'a'='a' --" "' OR '1'='1' /*")
    while read -r ENDPOINT; do
        for PAYLOAD in "${PAYLOADS[@]}"; do
            RESPONSE=$(curl -s --max-time 5 "$ENDPOINT$PAYLOAD")
            if [[ "$RESPONSE" =~ "error" || "$RESPONSE" =~ "SQL" || "$RESPONSE" =~ "mysql" ]]; then
                echo -e "\e[31m[!] Possible SQL Injection at: $ENDPOINT\e[0m"
            fi
        done
    done < valid_endpoints.txt
}

# Function: XSS Check
check_xss() {
    echo -e "\e[33m⚡ Spitting Fire at XSS Vulnerabilities... ⚡\e[0m"
    PAYLOAD="<script>alert('XSS')</script>"
    while read -r ENDPOINT; do
        RESPONSE=$(curl -s --max-time 5 "$ENDPOINT$PAYLOAD")
        if [[ "$RESPONSE" =~ "$PAYLOAD" ]]; then
            echo -e "\e[31m[!] Possible XSS at: $ENDPOINT\e[0m"
        fi
    done < valid_endpoints.txt
}

# Function: Subdomain Enumeration
check_subdomains() {
    echo -e "\e[36m🌍 Searching for Dragon Lairs (Subdomains)... 🌍\e[0m"
    subfinder -d "$HOST" | tee subdomains.txt & spinner
}

# Function: Directory Bruteforce
check_directory_bruteforce() {
    echo -e "\e[34m🗝️ Unlocking Hidden Caves (Directories)... 🗝️\e[0m"
    gobuster dir -u "$target" -w /usr/share/wordlists/dirb/common.txt -t 50 | tee dir_brute_results.txt & spinner
}

# Function: Host Header Injection
check_host_header_injection() {
    echo -e "\e[31m🔥 Testing Host Header Injection... 🔥\e[0m"
    RESPONSE=$(curl -s -H "Host: evil.com" "$target")
    if [[ "$RESPONSE" =~ "evil.com" ]]; then
        echo -e "\e[31m[!] Possible Host Header Injection at: $target\e[0m"
    fi
}

# Function: Run All Scans
run_scans() {
    port_scan
    http_enum
    find_valid_endpoints
    check_sql_injection
    check_xss
    check_subdomains
    check_directory_bruteforce
    check_host_header_injection
}

# Start Scanning
echo -e "\n\e[32m🐉 Unleashing the Dragon... Scanning Begins! 🐉\e[0m\n"
run_scans
echo -e "\n\e[32m🐉 The Dragon Hunt is Complete! 🐉\e[0m"
figlet "Mission Accomplished!" | lolcat

# Scary Dragon ASCII Image
echo -e "\e[31m" # Set text color to red
cat << "EOF"
                           __====-_  _-====___
                      _--^^^#####//      \\#####^^^--_
                   _-^##########// (    ) \\##########^-_
                  -############//  |\^^/|  \\############-
                _/############//   (@::@)   \\############\_
               /#############((     \\//     ))#############\
              -###############\\    (oo)    //###############-
             -#################\\  / UUU \  //#################-
            -###################\\/  (   )  \/###################-
           _/|##########/\######(   /     \   )######/\##########|_
          |/ |#/\#/\#/\/  \#/\##\  ( (       ) )  /##/\#/  \/\#/\| |
          U  |/  V  |/    |/   \#\  \ \     / /  /#/\#\|   |  |   |
             |/ |  |/  |    |/  |   | |/  |/  |/  |  |  |  |/   |
             |/   |  |   |  |   |   |/  |  |   |  |  |/   | |  |/
              |  |  |  |   |  |/|  |   |  |/  |  |  |/  |  | |  |
              |  |  |  |   |  |  |   |  |   |  |  |   |  |   |   |
EOF
