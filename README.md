# Turtlebot Unizar

This repository is intended to deploy software into turtlebot's from the RoPeRT group at Universidad de Zaragoza. The repository includes installation scripts, configuration files and launchfiles for basic navigation, mapping and perception.

## Requirements

This system was tested on Turtlebots' and ground station computers running ROS Melodic and Ubuntu 20.04.

## Install

To install the system first create a workspace of your choice on the robot or ground station computer:

```
mdkir -p ~/catkin_ws/src
cd ~/catkin_ws/
catkin init
```

Then, you should clone the repository in the 'src/' folder of the workspace:

```
cd ~/catkin_ws/src/
git clone https://github.com/dvdmc/turtlebot_unizar.git
```

Then, execute the 'install.sh' script and follow the installations steps on the terminal:

```
. install.sh
```

This script will install different tools (including ROS if required) and should work from a fresh Ubuntu 20.04 installation.
You can check this file to change the installation process.
If you want to reconfigure some settings without reinstalling anything you can check the 'setup.sh' file.


## Usage

Aside from useful configuration files, this repository includes modules for navigation, mapping and perception. You can check the specific modules in 'turtlebot_unizar_bringup'.

### Reactive navigation

You can simply start the robot and use its local navigation and odometry modules to perform reactive navigation with:

```
roslaunch turtlebot_unizar_bringup single_turtlebot_no_map.launch
```

### Create a map

For creating a new map, you can run the following:

```
roslaunch turtlebot_unizar_bringup single_turtlebot_gmapping.launch
```

You can send goals to the robot that will map its environment usng a Hokuyo 2D Lidar. When you think that the map is complete, you can save the map using:

```
rosrun map_server map_saver -f {PATH_TO_YOUR_MAP}
```

### Navigate of a previous map

For navigation using the AMCL localization method with the Lidar on a previous map, you can use:

```
roslaunch turtlebot_unizar_bringup single_turtlebot_amcl.launch map_file:={PATH_TO_YOUR_MAP}
```

## Structure

The structure is currently separated into three main modules:

- turtlebot_unizar_bringup: is used as the main entrypoint for most of the applications
- turtlebot_unizar_descriptions: it includes _xacro_ and _urdf_ files.
- basic_modules: it includes other modules used for perception that are not part of the main navigation and mapping functionalities.

## Contribution

If you want to contribute to the repository, you can open an issue with your problems or suggestions, or do a pull request with improvement changes. Currently, there is no specific guide for contributors.

## Acknowledgements

Most of the modules' organization and configuration files are based on an initial version created and previously maintained by Luis Riazuelo and Diego Martínez.