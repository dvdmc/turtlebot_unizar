############################
#			   #
# Welcome to divcore-NUC-0 #
#			   #
############################

If this is your first login, check the document "entrypoint.txt" in the main directory.
Open it with `cat ~/entrypoint.txt`. It is intended to be a simple guide for next steps.
Please, treat me gently. If in doubt when installing stuff, it is better to ask for advice.
Contact person: David Morilla (davidmc@unizar.es)

Remember to set ROS IPs to current robot. Execute commands:

- On the robot:

export ROS_MASTER_URI=http://$(hostname -I | cut -d' ' -f1):11311
export ROS_IP=$(hostname -I | cut -d' ' -f1)

- On the remote PC:

export ROS_MASTER_URI= http://(#CHECK ROBOT IP WITH "hostname -I" ON ROBOT TERMINAL):11311
export ROS_IP= #CHECK REMOTE PC IP WITH "hostname -I" ON REMOTE PC TERMINAL