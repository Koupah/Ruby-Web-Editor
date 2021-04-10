#!/bin/bash

broadcast()
{
echo " "
echo $1
echo " "
}

broadcast "Ruby Web Editor - Installer"

broadcast "Installing Gems: "

# Installs the gems from the Gemfile
bundle install

broadcast "Gems Installed!"

broadcast "Creating start_script!"
rm start_script.sh
start_script="start_script.sh"
echo "echo \"Please specify any arguments you'd like to start Ruby Web Editor with or just press enter to run Ruby Web Editor!\"" >> $start_script
echo "read arguments" >> $start_script
echo "ruby rwe.rb \$arguments " >> $start_script
echo "echo \" \"" >> $start_script
cat $start_script

chmod +x ./start_script.sh

broadcast "start_script Created!"

# Such a simple and quick installation!
broadcast "Installation Complete!"

# DISPLAYING HELP MESSAGE OF APP

echo "Would you like to see the 'help' message of Ruby Web Editor? (Y/N) " # -n Removes newline at the end of 'echo'
read -n 1 showHelp

if [ $showHelp == "y" ] || [ $showHelp == "Y" ]
then
    ruby rwe.rb -h
    echo " "
else
echo " "
fi

# RUNNING THE APP

echo "Would you like to run Ruby Web Editor? (Y/N) "
read -n 1 runWRE

if [ $runWRE == "y" ] || [ $runWRE == "Y" ]
then

echo " "
./start_script.sh

fi

broadcast "Thanks for installing Ruby Web Editor!"

echo "Press any key to exit!"

read -n 1

