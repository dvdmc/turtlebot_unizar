#!/bin/bash

sudo apt install ros-noetic-urg-node ros-noetic-urg-*
sudo adduser "$USER" dialout
echo "User $USER added to dialout group to access the serial port /dev/ttyACM0"
echo "Please, reboot the computer to apply changes and use the laser"