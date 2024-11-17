#!/usr/bin/env bash

echo "This script is derived from a script written by ParisNeo and forked from tkocou's repository at https://github.com/tkocou/ComfyUI-Linux-Install"
echo "It is used with the permission of ParisNeo (https://github.com/ParisNeo/lollms-webui)"

# Ask where to put the install and option to abort if dir exists
read -p "Folder name for install: " comfydir
if [[ -d $comfydir ]] ;then
    read -p "$comfydir already exists. Do you want to continue? [Y/N] " choice
    if [ ! "$choice" = "Y" ] || [ ! "$choice" = "y" ]; then
     echo "Cancelling installation..."
     exit 1
    fi
fi

if ping -q -c 1 google.com >/dev/null 2>&1; then
    echo -e "\e[32mInternet Connection working fine\e[0m"
    # Install git
    echo -n "Checking for Git..."
    if command -v git > /dev/null 2>&1; then
      echo "is installed"
    else
      read -p "Git is not installed. Would you like to install Git? [Y/N] " choice
      if [ "$choice" = "Y" ] || [ "$choice" = "y" ]; then
        echo "Installing Git..."
        sudo apt update
        sudo apt install -y git
      else
        echo "Please install Git and try again."
        exit 1
      fi
    fi

    # Check if repository exists
    if [[ -d .git ]] ;then
    echo Pulling latest changes
    git pull origin master
    #git pull origin main
    else
      if [[ -d $comfydir ]] ;then
        cd $comfydir
      else
        echo Cloning repository...
        git clone https://github.com/comfyanonymous/ComfyUI.git ./$comfydir
        cd $comfydir
      fi
    fi
    echo Pulling latest version...
    git pull

    # Install Python 3.12 and pip
    echo -n "Checking for python3.12..."
    if command -v python3.12 > /dev/null 2>&1; then
      echo "is installed"
    else
      read -p "Python3.12 is not installed. Would you like to install Python3.12? [Y/N] " choice
      if [ "$choice" = "Y" ] || [ "$choice" = "y" ]; then
        echo "Installing Python3.12..."
        sudo apt update
        sudo apt install -y python3.12 python3.12-venv
      else
        echo "Please install Python3.12 and try again."
        exit 1
      fi
    fi

    # Install venv module
    echo -n "Checking for venv module..."
    if python -m venv env > /dev/null 2>&1; then
      echo "is installed"
    else
      read -p "venv module is not available. Would you like to install it? [Y/N] " choice
      if [ "$choice" = "Y" ] || [ "$choice" = "y" ]; then
        echo "Installing venv module..."
        sudo apt update
        sudo apt install -y python3.12-venv
      else
        echo "Please install venv module and try again."
        exit 1
      fi
    fi

    # Create a new virtual environment
    echo -n "Creating virtual environment..."
    python -m venv env
    if [ $? -ne 0 ]; then
      echo "Failed to create virtual environment. Please check your Python installation and try again."
      echo "You might try renaming the old ComfyUI directory and restart this script for a fresh install."
      echo "And then copy over the contents of the old ComfyUI directory into the fresh copy of ComfyUI."
      exit 1
    else
      echo "is created"
    fi
fi


# Activate the virtual environment
echo -n "Activating virtual environment..."
if source env/bin/activate ; then
  echo "is active"
else
  echo "is not active. Use the 'bash' shell instead of 'sh'."
  exit 1
fi
source env/bin/activate

# Install the required packages
echo "Installing requirements..."
python -m pip install pip --upgrade
python -m pip install --upgrade torchvision
python -m pip install --upgrade -r requirements.txt

if [ $? -ne 0 ]; then
  echo "Failed to install required packages. Please check your internet connection and try again."
  exit 1
fi

# Install ComfyUI Manager
if [ ! -d "./custom_nodes/ComfyUI-Manager" ]; then
    git clone https://github.com/ltdrdata/ComfyUI-Manager.git ./custom_nodes/ComfyUI-Manager
fi

# Create new startup script
if [ ! -f "start.sh" ]; then
    printf "\x23\x21/usr/bin/env bash\n\nsource ./venv/bin/activate\ngit pull\npython main.py --listen" >> start.sh
    chmod +x start.sh
fi

# Cleanup

if [ -d "./tmp" ]; then
  rm -rf "./tmp"
  echo "Cleaning tmp folder"
fi

# Launch the Python application
read -p "Launch ComfyUI now? [Y/N] " choice
      if [ "$choice" = "Y" ] || [ "$choice" = "y" ]; then
        echo "Launching ComfyUI..."
      else
        echo "Exiting script. Launch the start.sh script in the new ComfyUI directory to start ComfyUI again."
        exit 1
      fi
python main.py --listen
