#!/bin/bash

# For this block of code, all the directories that match the pattern submission_reminder_* are stored in an array called matches
# If  the first item in the matches directory is submission_reminder_*, then there were no matches.
# The conditional thus checks if there were no matches. If there were matches, the code goes on to update the  config file
# If there were no matches, the code runs the create_environment script and runs the copilot.sh  script again.



matches=(./submission_reminder_*)

if [ ${matches[0]} == "./submission_reminder_*" ]; then
        echo "No submission environments found."
        echo "Let's get you an environment"
        ./create_environment.sh
        echo "                                      "
        echo "running copilot_shell_script.sh again..."
        ./copilot_shell_script.sh


else
        #This for loop ensures that all environments are updated

        for dir in "${matches[@]}"; do

                echo -e "The environment $dir has been found."
                read -p "What is the name of the assignment that you want to check?: " reply
                assignments=("Shell Navigation" "Git" "Shell Basics" "vi" "Emacs")
                is_present="false"

                #This for loop is used for error handling, incase you entered an invalid assignment name
                for assignment in "${assignments[@]}"; do
                        if [[ "$reply" == "$assignment" ]]; then
                                is_present="true"
                                break
                        else
                                :

                        fi
                done



                if [ $is_present == "false" ]; then
                        echo "The assignment, $reply, you have entered is invalid"
                        echo "Valid assignments: vi, Git, Shell Basics, Git, Emacs"
                        echo "NOTE: The case of your input matters"
                        echo "____________________________________________________"

		elif [ ! -f ./$dir/config/config.env ]; then
			echo -e "Your environemnt is incomplete, your config.env file is missing. \nLet's get you a complete one!"
			echo "Deleting incomplete environment" 
			rm -rf $dir
			echo "Running create_environment.sh ....."
			chmod +x create_environment.sh
			./create_environment.sh
			echo "Running the copilot_shell_script again......."
			./copilot_shell_script.sh
			echo "                                      "

                else
                        sed -i "2cASSIGNMENT=\"$reply\"" "$dir/config/config.env"
                        echo "The config file in $dir has been updated."
                        echo "You can now run the startup.sh file"
                        echo "___________________________________________"
fi

        done

fi
