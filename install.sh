#!/bin/bash

echo "Preparing turtlebot_unizar installation..."

# Ask for sudo permissions on terminal
sudo echo "Sudo permissions granted"

sudo apt update
# Ask if apt upgrade should be performed
echo "Do you want to perform apt upgrade? (y/n)"
read -r apt_upgrade
if [ "$apt_upgrade" = "y" ]; then
    sudo apt upgrade
else
    echo "apt upgrade skipped"
fi

# Check if Ubuntu version is 20.04 or output a warning
if [ "$(lsb_release -rs)" != "20.04" ]; then
    echo "Warning: this script has been tested only on Ubuntu 20.04"
fi

# Check if ros installed. Otherwise, ask if it should be installed
if [ -d "/opt/ros" ]; then
    echo "ROS is already installed"
else
    echo "ROS is not installed. Do you want to install it? (y/n)"
    read -r install_ros
    if [ "$install_ros" = "y" ]; then
        sudo ./install/ros_install.sh
    else
        echo "ROS installation skipped"
    fi
fi

# Install basic programs: git, vim, tmux, htop, net-tools, openssh-server
sudo apt install git vim tmux htop net-tools openssh-server

# Ask the user to register the hostname and IP in the router for DHCP
echo "Please, register the hostname in the router for DHCP"
echo "Hostname: $(hostname)"
echo "IP: $(hostname -I)"
echo "Press enter when done"

# Install catkin tools
sudo apt install python3-catkin-tools python-is-python3 # This is required for ros-noetic-linux-peripheral-interfaces

# Install turtlebot_unizar dependencies
sudo apt-get install ros-noetic-sophus ros-noetic-joy libusb-dev ros-noetic-move-base libftdi-dev ros-noetic-base-local-planner ros-noetic-move-base-msgs ros-noetic-linux-peripheral-interfaces ros-noetic-openni2-launch ros-noetic-slam-gmapping ros-noetic-map-server ros-noetic-amcl ros-noetic-navigation

# Install kobuki unizar
echo "Installing kobuki packages..."
wait 5
sudo ./install/install_kobuki_noetic.sh

# Install turtlebot2 packages
echo "Installing turtlebot2 packages..."
wait 5
sudo ./install/install_turtlebot2_noetic.sh

# Installing HOKUYO laser
echo "Installing HOKUYO laser..."
wait 5
sudo ./install/install_hokuyo_noetic.sh

# Copy the file ./install/entrypoint.md to home directory
echo "There is an entrypoint file in the home directory for help :-)"
cp ./install/entrypoint.md ~/

# Ask if the user wants further configuration as it is in the robot:
echo "Do you want to configure the robot platform (default: y)? (y/n)"
read -r configure_robot
if [ "$configure_robot" = "n" ]; then
    echo "Robot configuration skipped"
else
    echo "Configuring robot..."

    # Ask if the user wants to change the ssh welcome message for the file ./install/ssh_welcome_message.md
    echo "Do you want to change the ssh welcome message (default: y)? (y/n)"
    read -r change_ssh_welcome_message
    if [ "$change_ssh_welcome_message" = "n" ]; then
        echo "SSH welcome message not changed"
    else
        echo "Changing SSH welcome message..."
        sudo cp ./install/ssh_welcome_message.md /etc/motd
    fi

    # Configure optenv variables in the robot and include it in .bashrc
    echo "Configuring env variables..."
    # Ask for base, stack, 3d sensor
    echo "Please, enter the base (default: kobuki):"
    read -r base
    if [ "$base" = "" ]; then
        base="kobuki"
    fi
    echo "Please, enter the stack (default: hexagons):"
    read -r stack
    if [ "$stack" = "" ]; then
        stack="hexagons"
    fi
    echo "Please, enter the 3d sensor (default: hokuyo_top):"
    read -r sensor
    if [ "$sensor" = "" ]; then
        sensor="hokuyo_top"
    fi

    # Include the optenv variables in .bashrc
    echo "export TURTLEBOT_BASE=$base" >> ~/.bashrc
    echo "export TURTLEBOT_STACKS=$stack" >> ~/.bashrc
    echo "export TURTLEBOT_3D_SENSOR=$sensor" >> ~/.bashrc

fi
