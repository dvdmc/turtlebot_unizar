#!/usr/bin/env bash

source devel/setup.bash
export ROS_MASTER_URI=http://$(hostname -I | cut -d' ' -f1):11311
export ROS_IP=$(hostname -I | cut -d' ' -f1)