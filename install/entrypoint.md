############################
#			   #
# Welcome to divcore-NUC-0 #
#			   #
############################

My name is David Morilla (davidmc@unizar.es). This document is intended to be an entrypoint to this robot. It contains relevant info and pointers to further documentation. Please, treat me gently. If in doubt when installing stuff, it is better to ask for advice.

# How do I work?

Potentially, several people will work with this robot over the time and concurrently. In order to keep some ordering there are a set of rules that will avoid problems:

1. Each person will work in workspaces that can be *identified* by its name or, ideally, with a description file inside the folder. Good: davidm_ws, davidmctest_ws. Bad: test_ws

2. Don't add "source" commands in the .bashrc as that will include your workspace packages over the basic ROS packages even when other people want to work with it. For repetitive commands like "export ROS_MASTER_URI...", you can create a setup.sh script in your workspace that won't interfere with anyone.

3. Required Python packages will be installed inside a virtual environment that will be placed inside of the workspace (instructions below)

4. Each person is responsible for their workspaces. When leaving the lab, remember to back-up your data and code. When leaving the group, remember to delete workspaces or files.

## Creating a workspace

All workspaces are stored in ~/ros folder.

```
cd ~/ros/
mkdir XXXXX_ws
cd XXXXX_ws
mkdir src
catkin init
python -m venv ./XXXX_env
```

REMEMBER! to activate your python environment before installing any package with pip. There shouldn't be big issues with normal packages, but specific packages may break Python package manager.
Basic packages like numpy, matplotlib... will be installed in the global python installation.

# Robot specs

## Hardware 

- Intel NUC: onboard computer. It can be powered with "FSP 19V" power sources and XTPower batteries. The later are charged with the same power sources.

- Kobuki base: moves the wheels and keeps odometry. It works with a battery which is charged with "CUD" 18.6V chargers.

- Hokuyo: laser sensor currently mounted on top of the robot. It is connected to the NUC via USB and powered with the Kobuki base.

- PTZ (camera control): device that controls the pitch and yaw of a camera. It is connected to the NUC via USB and powered by the Kobuki base.

## Software: 

- Ubuntu 20.04

- ROS Noetic

## Network

- The robot connects automatically to RT-ART router with DHCP. It can be accessed via ssh with user/password (ask responsible).

## Basic functions

This section introduces some of the basic functions that you might want to do with this robot.

### Navigation and Mapping

The robot uses GMapping for mapping with the Hokuyo laser sensor. It uses the navigation stack for moving with a particle filter (ACML)