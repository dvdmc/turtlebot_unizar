#!/bin/bash

echo "Preparing turtlebot_unizar installation..."

# Ask for sudo permissions on terminal
sudo echo "Sudo permissions granted"

# Set color variables for messages
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Get path to script
SCRIPT_PATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

sudo apt update
# Ask if apt upgrade should be performed
printf "${YELLOW}Do you want to perform apt upgrade? (y/n)${NC}"
read -r apt_upgrade
if [ "$apt_upgrade" = "y" ]; then
    printf "${GREEN}apt upgrade started...\n${NC}"
    sudo apt upgrade
else
    printf "${GREEN}apt upgrade skipped\n${NC}"
fi

# Check if Ubuntu version is 20.04 or output a warning
if [ "$(lsb_release -rs)" != "20.04" ]; then
    printf "${RED}Warning: this script has been tested only on Ubuntu 20.04 \n${NC}"
fi

# Check if ros installed. Otherwise, ask if it should be installed
if [ -d "/opt/ros" ]; then
    printf "${GREEN}ROS is already installed ${NC}\n"
else
    printf "${YELLOW}ROS is not installed. Do you want to install it? (y/n) ${NC}"
    read -r install_ros
    if [ "$install_ros" = "y" ]; then
        . ${SCRIPT_PATH}/install/ros_install.sh
    else
        printf "${YELLOW}ROS installation skipped \n${NC}"
    fi
fi

# Install basic programs: git, vim, tmux, htop, net-tools, openssh-server
sudo apt install git vim tmux htop net-tools openssh-server


# Install catkin tools
sudo apt install python3-catkin-tools python-is-python3 # This is required for ros-noetic-linux-peripheral-interfaces

# Install turtlebot_unizar dependencies

# Mainly related to kobuki
sudo apt-get install -y ros-$ROS_DISTRO-sophus ros-$ROS_DISTRO-joy libusb-dev  libftdi-dev ros-$ROS_DISTRO-openni2-launch ros-$ROS_DISTRO-linux-peripheral-interfaces

# Mainly related to turtlebot2 and navigation
sudo apt-get install -y ros-$ROS_DISTRO-move-base ros-$ROS_DISTRO-base-local-planner ros-$ROS_DISTRO-move-base-msgs ros-$ROS_DISTRO-navigation

# Mainly related to scan mapping
sudo apt-get install -y ros-$ROS_DISTRO-slam-gmapping ros-$ROS_DISTRO-map-server ros-$ROS_DISTRO-amcl

# Install kobuki unizar
printf "${GREEN}Installing kobuki packages... \n${NC}"
sleep 3
. ${SCRIPT_PATH}/install/install_kobuki_noetic.sh

# Install turtlebot2 packages
printf "${GREEN}Installing turtlebot2 packages... \n${NC}"
sleep 3
. ${SCRIPT_PATH}/install/install_turtlebot2_noetic.sh

# Installing HOKUYO laser
printf "${GREEN}Installing HOKUYO laser... \n${NC}"
sleep 3
. ${SCRIPT_PATH}/install/install_hokuyo_noetic.sh

# Installing realsense camera
printf "${GREEN}Installing realsense camera... \n${NC}"
sleep 3
sudo apt-get install -y ros-$ROS_DISTRO-realsense2-camera ros-$ROS_DISTRO-realsense2-description

# Ask the user to register the hostname and IP in the router for DHCP
printf "${YELLOW}Please, register the hostname in the router for DHCP\n"
printf "Hostname: $(hostname)\n"
printf "IP: $(hostname -I)\n"
printf "Press enter when done \n${NC}"
read -r

# Check if this computer is the robot or the workstation
printf "${YELLOW}Is this computer the robot or the workstation? (robot/workstation)${NC}"
read -r computer_type

# If it is the robot add the following:
if computer_type="robot"; then
    # Copy the file ./install/entrypoint.md to home directory
    printf "${GREEN}There is an entrypoint file in the home directory for help :-)\n${NC}"
    cp ${SCRIPT_PATH}/install/entrypoint.md ~/

    # Ask if the user wants further configuration as it is in the robot:
    printf "${YELLOW}Do you want to configure the robot platform (default: y)? (y/n)${NC}"
    read -r configure_robot
    if [ "$configure_robot" = "n" ]; then
        printf "${YELLOW}Robot configuration skipped\n${NC}"
    else
        printf "${GREEN}Configuring robot...\n${NC}"

        # Ask if the user wants to change the ssh welcome message for the file ./install/ssh_welcome_message.md
        printf "Do you want to change the ssh welcome message (default: y)? (y/n)"
        read -r change_ssh_welcome_message
        if [ "$change_ssh_welcome_message" = "n" ]; then
            printf "${YELLOW}SSH welcome message not changed \n${NC}"
        else
            printf "${GREEN}Changing SSH welcome message... \n${NC}"
            sudo cp ${SCRIPT_PATH}/install/ssh_welcome_message.md /etc/motd
        fi

        # Configure optenv variables in the robot and include it in .bashrc
        printf "${GREEN}Configuring env variables...\n"
        # Ask for base, stack, 3d sensor
        printf "${YELLOW}Please, enter the base (default: kobuki): ${NC}"
        read -r base
        if [ "$base" = "" ]; then
            base="kobuki"
        fi
        printf "${YELLOW}Please, enter the stack (default: hexagons): ${NC}"
        read -r stack
        if [ "$stack" = "" ]; then
            stack="hexagons"
        fi
        printf "${YELLOW}Please, enter the 3d sensor (default: hokuyo_top): ${NC}"
        read -r sensor
        if [ "$sensor" = "" ]; then
            sensor="hokuyo_top"
        fi

        # Include the optenv variables in .bashrc
        echo "export TURTLEBOT_BASE=$base" >> ~/.bashrc
        echo "export TURTLEBOT_STACKS=$stack" >> ~/.bashrc
        echo "export TURTLEBOT_3D_SENSOR=$sensor" >> ~/.bashrc

    fi
fi
