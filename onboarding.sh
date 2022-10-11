#! /bin/bash

# Read users files
userfile=$(cat names.csv)
PASSWORD=password

# Check if User has root privilege
if [ $(id -u) -eq 0 ];  then

# read the User in CSV file
    for user in $userfile;
    do
        echo $user
    if id "$user" &>/dev/null
    then
            echo "User `$user` Exist"
    else

        # Create a new User
        useradd -m -d /home/$user -s /bin/bash -g developers $user
        echo "Created `$user` Successfuly"
        echo


        # Creat ssh folder in the user home directory
        su - -c "mkdir ~/.ssh" $user
        echo ".ssh directory created for `$user`"
        echo

        # Set user permission for the ssh directory
        su - -c "chmod 700 ~/.ssh" $user
        echo "user `$user` permission for .ssh directory is set"
        echo

        # Create an authorized-key file
        su - -c "touch ~/.ssh/authorized_keys" $user
        echo "Authorized Key File Created for `$user`"
        echo

        # Set permission for the key file
        su - -c "chmod 600 ~/.ssh/authorized_keys" $user
        echo "user permission for the Authorized Key File set"
        echo

        # Create and set public key for users in the server
        cp -R "/home/ubuntu/Shell/id_rsa.pub" "/home/$user/.ssh/authorized_keys"
        echo "Copied the Public Key to `$user` Account on the server"
        echo
        echo

        echo "USER `$user` is CREATED"

# Generate a password.
sudo echo -e "$PASSWORD\n$PASSWORD" | sudo passwd "$user" 
sudo passwd -x 3 $user
            fi
        done
    else
    echo "Only Admin Can Onboard A User"
    fi