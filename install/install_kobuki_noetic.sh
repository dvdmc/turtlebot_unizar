#!/bin/bash

sudo apt install liborocos-kdl-dev
sudo apt-get install ros-noetic-ecl-*
sudo apt-get install libusb-dev
sudo apt-get install libftdi-dev

# Save current dir
current_dir=$(pwd)

mkdir -p ~/tmp_ws/src
cd ~/tmp_ws/src
git clone https://github.com/yujinrobot/kobuki.git
git clone https://github.com/yujinrobot/yujin_ocs.git
git clone https://github.com/yujinrobot/kobuki_msgs.git
git clone https://github.com/yujinrobot/kobuki_core.git

cd yujin_ocs
mkdir save
mv yocs_cmd_vel_mux save
mv yocs_controllers save
mv yocs_velocity_smoother save
rm -rf yocs*
cd save
mv * ..
cd .. && rmdir save
cd ~/tmp_ws/

# Set install directory to /opt/ros/noetic
catkin config --install --install-space /opt/ros/noetic
sudo catkin build

# Resource the workspace
source /opt/ros/noetic/setup.bash

rosrun kobuki_ftdi create_udev_rules

# Return to previous dir
cd "$current_dir"

# Remove tmp_ws
sudo rm -rf ~/tmp_ws

# Resource the workspace
source /opt/ros/noetic/setup.bash
