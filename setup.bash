# This file sets up certain enrionment variables without installing anything
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
