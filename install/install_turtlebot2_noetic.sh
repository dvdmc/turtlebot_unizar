#!/bin/bash

# Make the workspace
mkdir -p ~/tmp_ws/src

# Save previous dir
current_dir=$(pwd)

cd ~/tmp_ws/src

# Clone the required repositories
git clone https://github.com/turtlebot/turtlebot.git
git clone https://github.com/turtlebot/turtlebot_msgs.git
git clone https://github.com/turtlebot/turtlebot_apps.git
git clone https://github.com/turtlebot/turtlebot_simulator

# Following https://github.com/yujinrobot/kobuki/issues/427
git clone https://github.com/yujinrobot/yujin_ocs.git
# Remove all but 'yocs_cmd_vel_mux', 'yocs_controllers', and 'yocs_velocity_smoother'
mv yujin_ocs/yocs_cmd_vel_mux yujin_ocs/yocs_controllers yujin_ocs/yocs_velocity_smoother .
rm -rf yujin_ocs


# Add the battery monitor package
git clone https://github.com/ros-drivers/linux_peripheral_interfaces.git
mv linux_peripheral_interfaces/laptop_battery_monitor ./
rm -rf linux_peripheral_interfaces

sudo apt install liborocos-kdl-dev -y
sudo apt install ros-noetic-joy 
rosdep install --from-paths . --ignore-src -r -y

# Build the packages
cd ..
# Set install directory to /opt/ros/noetic
catkin config --install --install-space /opt/ros/noetic
sudo catkin build

# Return to previous dir
cd "$current_dir"

# Remove the workspace
sudo rm -rf ~/tmp_ws

# Resource the workspace
source /opt/ros/noetic/setup.bash