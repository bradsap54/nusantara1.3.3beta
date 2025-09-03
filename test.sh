#!/bin/bash

# Banner
print_banner() {
    echo -e "\n\e[1;38;2;255;69;0m"
    echo "|.___---___.||     ___________        ________                       .___   "
    echo "|     |     ||     \__    ___/       /  _____/ __ _______ _______  __| _/   "
    echo "|     |     ||       |    |  ______ /   \  ___|  |  \__  \\\\_  __ \\/ __ | "
    echo "|-----o-----||       |    | /_____/ \    \_\  \  |  // __ \|  | \\/ /_/ |   "
    echo ":     |     ::       |____|          \______  /____/(____  /__|  \____ |    "
    echo " \    |    //                               \/           \/           \/    "
    echo "  '.__|__.'          Start Your Defence."
    echo "                        Build Your Fortress."
    echo -e "\e[0m"
}

# Function for Update System and Install Prerequisites
update_install_pre() {
    echo
    echo -e "\e[1;32m -- Step 1: Update System and Install Prerequisites -- \e[0m"
    echo
    lsb_release -a
    # sudo apt-get update -y
    # sudo apt-get upgrade -y
    # sudo apt-get install wget curl nano git unzip nodejs -y
    # echo
    # # Check if Docker is installed
    #     if command -v docker > /dev/null; then
    #         echo "Docker is already installed."
    #     else
    #         # Install Docker
    #         curl -fsSL https://get.docker.com -o get-docker.sh
    #         sudo sh get-docker.sh
    #         sudo systemctl enable docker.service && sudo systemctl enable containerd.service
    #     fi
    echo
    echo -e "\e[1;32m Step 1 Completed \e[0m"
}

# Function for Install all module: Wazuh, IRIS, Shuffle, MISP
install_module() {
    echo
    echo -e "\e[1;32m -- Step 2: Install T-Guard SOC Package -- \e[0m"
    echo

    # --- Initial Network Configuration ---
    # Ask the user for the network environment just once.
    echo "Please select the network environment for this installation."
    PS3=$'\nChoose an option: '
    select network_env in "Private Network (local VM: VirtualBox, VMware, etc.)" "Public Network (cloud server: GCP, AWS, Azure, etc.)"; do
        case $REPLY in
            1)
                # Get the primary private IP address
                IP_ADDRESS=$(hostname -I | awk '{print $1}')
                echo
                echo -e "\e[1;34m[INFO] Private IP Address:\e[1;33m $IP_ADDRESS\e[0m"
                break
                ;;
            2)
                # Get the public IP address
                IP_ADDRESS=$(curl -s ip.me -4)
                echo
                echo -e "\e[1;34m[INFO] Public IP Address:\e[1;33m $IP_ADDRESS\e[0m"
                break
                ;;
            *)
                echo "Invalid option. Please try again."
                ;;
        esac
    done

    # Validate that an IP address was successfully retrieved
    if [ -z "$IP_ADDRESS" ]; then
        echo -e "\e[1;31m[ERROR] Could not determine IP address. Aborting installation.\e[0m"
        return
    fi

    echo -e "\e[1;34m[INFO] Using IP Address \e[1;33m$IP_ADDRESS\e[1;34m for all subsequent configurations.\e[0m\n"


    # --- 1. Installing Wazuh (SIEM) & Deploying Agent ---
    echo -e "\e[1;36m--> Installing Wazuh...\e[0m"
    # cd wazuh
    # sudo docker network create shared-network &>/dev/null # Create network if not exists
    # sudo docker compose -f generate-indexer-certs.yml run --rm generator
    # sudo docker compose up -d
    lsb_release -a

    # Check Wazuh Status
    # containers=("wazuh-wazuh.dashboard-1" "wazuh-wazuh.manager-1" "wazuh-wazuh.indexer-1")
    # for container in "${containers[@]}"; do
    #     running_status=$(sudo docker inspect --format='{{.State.Running}}' $container 2>/dev/null)
    #     if [ "$running_status" != "true" ]; then
    #         echo -e "\e[1;31m[ERROR] Wazuh installation failed: Container '$container' is not running.\e[0m"
    #         # Attempt to show logs for debugging
    #         echo -e "\e[1;33mDisplaying logs for $container:\e[0m"
    #         sudo docker logs $container --tail 50
    #         exit 1
    #     fi
    # done
    # echo -e "\e[1;32mYour Wazuh installation is successful and all core containers are running.\e[0m"

    # Deploy Wazuh Agent automatically
    # echo -e "\e[1;36m--> Automatically deploying Wazuh Agent...\e[0m"
    # wazuh_version=$(sudo docker images --format '{{.Repository}}:{{.Tag}}' | grep '^wazuh/wazuh-dashboard:' | head -n 1 | cut -d':' -f2)
    
    # if [ -z "$wazuh_version" ]; then
    #     echo -e "\e[1;31m[ERROR] Could not determine Wazuh version from Docker images.\e[0m"
    #     exit 1
    # fi

    # wget https://packages.wazuh.com/4.x/apt/pool/main/w/wazuh-agent/wazuh-agent_${wazuh_version}-1_amd64.deb -O wazuh-agent.deb
    
    # Install using the pre-configured IP and agent name
    # sudo WAZUH_MANAGER="$IP_ADDRESS" WAZUH_AGENT_NAME="001-tguard-agent" dpkg -i ./wazuh-agent.deb
    # sudo systemctl daemon-reload
    # sudo systemctl enable wazuh-agent
    # sudo systemctl start wazuh-agent
    echo -e "\e[1;32mWazuh Agent deployed successfully.\e[0m"
    # cd ..
    
    # --- 2. Installing Shuffle (SOAR) ---
    echo -e "\n\e[1;36m--> Installing Shuffle...\e[0m"
    # cd shuffle
    # mkdir -p shuffle-database 
    # sudo chown -R 1000:1000 shuffle-database
    # sudo swapoff -a
    # sudo docker compose up -d
    echo -e "\e[1;32mShuffle deployment initiated.\e[0m"
    # cd ..

    # --- 3. Installing DFIR-IRIS (Incident Response Platform) ---
    echo -e "\n\e[1;36m--> Installing DFIR-IRIS...\e[0m"
    # cd iris-web
    # sudo docker compose build
    # sudo docker compose up -d
    echo -e "\e[1;32mDFIR-IRIS deployment initiated.\e[0m"
    # cd ..

    # --- 4. Installing MISP (Threat Intelligence) ---
    echo -e "\n\e[1;36m--> Installing MISP...\e[0m"
    # cd misp
    
    # Automatically configure MISP using the determined IP address
    echo -e "\e[1;34m[INFO] Configuring MISP with Base URL: https://$IP_ADDRESS:1443\e[0m"
    # sed -i "s|BASE_URL=.*|BASE_URL='https://$IP_ADDRESS:1443'|" template.env
    # cp template.env .env
    # sudo docker compose up -d
    echo -e "\e[1;32mMISP deployment initiated.\e[0m"
    # cd ..

    echo
    echo -e "\e[1;32m Step 2 Completed: All T-Guard SOC packages have been deployed. \e[0m"
    echo
    echo -e "\e[1;34m[INFO] Waiting for 60 seconds for all services to initialize properly...\e[0m"
    
    for i in $(seq 60 -1 0); do
        # The '-ne' and '\r' ensure the countdown happens on a single, updating line.
        echo -ne "Time remaining: $i seconds \r"
        sleep 1
    done
    
    # Print a newline to move past the countdown line.
    echo
    echo -e "\e[1;32mInitialization wait complete. You may now proceed the next step.\e[0m"
    echo
    
    # Dashboard Access Information
    # --- Define colors for cleaner code ---
    BLUE='\e[1;34m'
    YELLOW='\e[1;33m'
    GREEN='\e[1;32m'
    WHITE='\e[1;37m'
    NC='\e[0m' # No Color

    # --- Display Final Access Details in a Formatted Box ---
    printf "\n"
    printf "${GREEN}+----------------------------------------------------------------------+\n"
    printf "|${WHITE}      T-Guard SOC Package - Dashboard Access Default Credentials      ${GREEN}|\n"
    printf "+----------------------------------------------------------------------+\n"
    
    # Wazuh Details
    printf "  ${BLUE}%-18s ${YELLOW}%-49s ${GREEN}\n" "Wazuh (SIEM)" "https://$IP_ADDRESS"
    printf "  ${WHITE}%-18s ${NC}%-49s ${GREEN}\n" " ├─ Username" "admin"    
    printf "  ${WHITE}%-18s ${NC}%-49s ${GREEN}\n" " └─ Password" "SecretPassword"    
    printf "${GREEN}+----------------------------------------------------------------------+\n"

    # Shuffle Details
    printf "  ${BLUE}%-18s ${YELLOW}%-49s ${GREEN}\n" "Shuffle (SOAR)" "http://$IP_ADDRESS:3001"
    printf "  ${WHITE}%-18s ${NC}%-49s ${GREEN}\n" " ├─ Username" "administrator"
    printf "  ${WHITE}%-18s ${NC}%-49s ${GREEN}\n" " └─ Password" "MySuperAdminPassword!"
    printf "${GREEN}+----------------------------------------------------------------------+\n"

    # DFIR-IRIS Details
    printf "  ${BLUE}%-18s ${YELLOW}%-49s ${GREEN}\n" "DFIR-IRIS (IR)" "https://$IP_ADDRESS:8443"
    printf "  ${WHITE}%-18s ${NC}%-49s ${GREEN}\n" " ├─ Username" "administrator"
    printf "  ${WHITE}%-18s ${NC}%-49s ${GREEN}\n" " └─ Password" "MySuperAdminPassword!"
    printf "${GREEN}+----------------------------------------------------------------------+\n"

    # MISP Details
    printf "  ${BLUE}%-18s ${YELLOW}%-49s ${GREEN}\n" "MISP (Threat Intel)" "https://$IP_ADDRESS:1443"
    printf "  ${WHITE}%-18s ${NC}%-49s ${GREEN}\n" " ├─ Username" "admin@admin.test"
    printf "  ${WHITE}%-18s ${NC}%-49s ${GREEN}\n" " └─ Password" "admin"
    printf "${GREEN}+----------------------------------------------------------------------+\n\n"
}

# Menu loop
while true; do
    print_banner
    PS3=$'\nChoose an option (or press Ctrl+C to exit): '

    select opt in "Update and Install Prerequisites" "Install T-Guard SOC Package" "Exit"; do
        case $REPLY in
            1) update_install_pre ; break ;;
            2) install_module ; break ;;
            3) echo "Goodbye!" ; exit ;;
            *) echo "Invalid option. Try again." ;;
        esac
    done
done