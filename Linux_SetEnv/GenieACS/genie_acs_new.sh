#!/bin/bash

# Function to handle Node.js installation for any Ubuntu version.
install_nodejs() {
    echo "========================================"
    echo "========Step 1: Installing Node.js (v14)========"
    echo "========================================"
    # Download the Node.js setup script for the LTS version (v14)
    # Node.js 14 is a common LTS version and a good default choice.
    curl -sL https://deb.nodesource.com/setup_14.x -o nodesource_setup.sh
    
    # Run the setup script to add the Node.js repository
    sudo bash nodesource_setup.sh
    
    # Install Node.js
    sudo apt install -y nodejs
    
    # Verify the installation
    echo "========================================"
    echo "Node.js installation complete. "
    node -v
    echo "========================================"
}


# Function to install the appropriate MongoDB version based on OpenSSL.
install_mongodb() {
    echo "========================================"
    echo "========Step 2: Installing MongoDB ========"
    echo "========================================"
    # Get the OpenSSL version string, parsing just the version number.
    SSL_VERSION=$(openssl version | awk '{print $2}')
    echo "Detected OpenSSL version: $SSL_VERSION"
    
    case "$SSL_VERSION" in
        # Pattern for OpenSSL 1.1.x, which is the default for Ubuntu 20.04.
        1.1.*)
            echo "Installing MongoDB 4.4 for OpenSSL 1.1.x"
            # The commands for MongoDB 4.4 are different due to older repository setup methods.
            # Import the official MongoDB PGP key for version 4.4
            curl -fsSL https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -
            
            # Add the MongoDB repository for Focal (Ubuntu 20.04)
            echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list
            
            # Update the package list and install MongoDB
            sudo apt update
            sudo apt install -y mongodb-org
            ;;
            
        # Pattern for OpenSSL 3.x, which is the default for Ubuntu 22.04 and 24.04.
        3.*)
            echo "Installing MongoDB 8.0 for OpenSSL 3.x"
            # The commands for MongoDB 8.0 use a newer, more secure GPG key management method.
            
            # Install gnupg and curl if not present
            sudo apt update
            sudo apt install -y gnupg curl
            
            # Import the official MongoDB PGP key for version 8.0
            curl -fsSL https://www.mongodb.org/static/pgp/server-8.0.asc | \
                sudo gpg -o /usr/share/keyrings/mongodb-server-8.0.gpg --dearmor
            
            # Add the MongoDB repository for Jammy (Ubuntu 22.04)
            # This repository also works for 24.04
            echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-8.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/8.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-8.0.list
            
            # Update the package list and install MongoDB
            sudo apt update
            sudo apt install -y mongodb-org
            ;;
            
        *)
            # Exit if an unsupported OpenSSL version is found.
            echo "ERROR: Unsupported OpenSSL version: $SSL_VERSION"
            echo "This script only supports OpenSSL 1.1.x and 3.x."
            exit 1
            ;;
    esac
    
    # Start and enable the MongoDB service for all versions
    sudo systemctl start mongod.service
    sudo systemctl enable mongod.service
    
    # Check the service status
    sudo systemctl status mongod.service  --no-pager
    
    # Verify the installation with a connection test
    # The 'mongo' command is deprecated; 'mongosh' is the new shell.
    # We will try both for backward compatibility.
    if command -v mongosh &> /dev/null
    then
        mongosh --eval 'db.runCommand({ connectionStatus: 1 })'
    else
        mongo --eval 'db.runCommand({ connectionStatus: 1 })'
    fi
    
    echo "========================================"
    echo "MongoDB installation complete."
    #mongod --version | awk 'NR==1{print $3}'
    mongod --version | grep "db version" | awk '{print $3}'
    echo "========================================"
}



# Function to handle GenieACS installation and configuration.
install_genieacs() {
echo "========================================"
    echo "========Step 3: Installing GenieACS ========"
    echo "========================================"
    
    # Install npm if it's not present
    sudo apt install -y npm 
    # Install GenieACS globally
    sudo npm install -g genieacs@1.2.13 
   
    # Create the GenieACS system user and group
    sudo useradd --system --no-create-home --user-group genieacs
    
    # Create necessary directories and set ownership
    sudo mkdir -p /opt/genieacs /opt/genieacs/ext /var/log/genieacs
    sudo chown -R genieacs:genieacs /opt/genieacs/ext /var/log/genieacs
    
    # Create the genieacs.env file using a here-document
    echo "Creating GenieACS environment file..."
    cat <<'EOF' | sudo tee /opt/genieacs/genieacs.env > /dev/null
	GENIEACS_CWMP_ACCESS_LOG_FILE=/var/log/genieacs/genieacs-cwmp-access.log
	GENIEACS_NBI_ACCESS_LOG_FILE=/var/log/genieacs/genieacs-nbi-access.log
	GENIEACS_FS_ACCESS_LOG_FILE=/var/log/genieacs/genieacs-fs-access.log
	GENIEACS_UI_ACCESS_LOG_FILE=/var/log/genieacs/genieacs-ui-access.log
	GENIEACS_DEBUG_FILE=/var/log/genieacs/genieacs-debug.yaml
	NODE_OPTIONS=--enable-source-maps
	GENIEACS_EXT_DIR=/opt/genieacs/ext
EOF

    # Set the correct permissions on the environment file
    sudo chown genieacs:genieacs /opt/genieacs/genieacs.env
    sudo chmod 600 /opt/genieacs/genieacs.env

    # Generate and append the JWT secret to the environment file
    echo "=====Generating and adding JWT secret...======"
    node -e "console.log(\"GENIEACS_UI_JWT_SECRET=\" + require('crypto').randomBytes(128).toString('hex'))" | sudo tee -a /opt/genieacs/genieacs.env > /dev/null

    echo "========================================"    
    echo "GenieACS installation complete."
    echo "npm version: $(npm -v)"
    echo "npm version: $(npm list -g genieacs)"
    echo "========================================"  
}

# Function to start and check the status of all GenieACS services.
genieacs_service() {
    echo "======== Step 5: Starting and enabling GenieACS services ========"
    
    sudo systemctl enable genieacs-cwmp
    sudo systemctl start genieacs-cwmp
    sudo systemctl status genieacs-cwmp --no-pager
    
    sudo systemctl enable genieacs-nbi
    sudo systemctl start genieacs-nbi
    sudo systemctl status genieacs-nbi --no-pager
    
    sudo systemctl enable genieacs-fs
    sudo systemctl start genieacs-fs
    sudo systemctl status genieacs-fs --no-pager
    
    sudo systemctl enable genieacs-ui
    sudo systemctl start genieacs-ui
    sudo systemctl status genieacs-ui --no-pager
    
    echo "All GenieACS services have been started."
}

# Function to create the genieacs-nbi service file.
create_genieacs_nbi_service() {
    echo "Step4.1: Creating systemd service file for genieacs-nbi..."

    # Find the executable path for genieacs-nbi
    genieacs_nbi_location=$(which genieacs-nbi)
    
    if [ -z "$genieacs_nbi_location" ]; then
        echo "Error: genieacs-nbi executable not found. Cannot create service file."
        exit 1
    fi

    # Use a here-document to write the service file contents to /etc/systemd/system
    cat <<EOF | sudo tee /etc/systemd/system/genieacs-nbi.service > /dev/null
[Unit]
Description=GenieACS NBI
After=network.target
 
[Service]
User=genieacs
EnvironmentFile=/opt/genieacs/genieacs.env
ExecStart=$genieacs_nbi_location
 
[Install]
WantedBy=default.target
EOF

# Reload the systemd daemon to recognize the new service file
sudo systemctl daemon-reload
echo "Service file created and daemon reloaded."
echo ""
}


# Function to create the genieacs-cwmp service file.
create_genieacs_cwmp_service() {
echo "Step4.2:Creating systemd service file for genieacs-cwmp..."

genieacs_cwmp_location=$(which genieacs-cwmp)
    
if [ -z "$genieacs_cwmp_location" ]; then
    echo "Error: genieacs-cwmp executable not found. Cannot create service file."
    exit 1
fi

    cat <<EOF | sudo tee /etc/systemd/system/genieacs-cwmp.service > /dev/null
[Unit]
Description=GenieACS CWMP
After=network.target

[Service]
User=genieacs
EnvironmentFile=/opt/genieacs/genieacs.env
ExecStart=$genieacs_cwmp_location

[Install]
WantedBy=default.target
EOF

    sudo systemctl daemon-reload
    echo "Service file created and daemon reloaded."
    echo ""
}

# Function to create the genieacs-fs service file.
create_genieacs_fs_service() {
    echo "Step4.3: Creating systemd service file for genieacs-fs..."
    
    genieacs_fs_location=$(which genieacs-fs)
    
    if [ -z "$genieacs_fs_location" ]; then
        echo "Error: genieacs-fs executable not found. Cannot create service file."
        exit 1
    fi

    cat <<EOF | sudo tee /etc/systemd/system/genieacs-fs.service > /dev/null
[Unit]
Description=GenieACS FS
After=network.target

[Service]
User=genieacs
EnvironmentFile=/opt/genieacs/genieacs.env
ExecStart=$genieacs_fs_location

[Install]
WantedBy=default.target
EOF

    sudo systemctl daemon-reload
    echo "Service file created and daemon reloaded."
    echo ""
}

# Function to create the genieacs-ui service file.
create_genieacs_ui_service() {

    echo "Step4.4:Creating systemd service file for genieacs-ui..."

    
    genieacs_ui_location=$(which genieacs-ui)
    
    if [ -z "$genieacs_ui_location" ]; then
        echo "Error: genieacs-ui executable not found. Cannot create service file."
        exit 1
    fi

    cat <<EOF | sudo tee /etc/systemd/system/genieacs-ui.service > /dev/null
[Unit]
Description=GenieACS UI
After=network.target

[Service]
User=genieacs
EnvironmentFile=/opt/genieacs/genieacs.env
ExecStart=$genieacs_ui_location

[Install]
WantedBy=default.target
EOF

    sudo systemctl daemon-reload
    echo "Service file created and daemon reloaded."
    echo ""
}

# Function to create a logrotate file for GenieACS.
create_logrotate_file() {
    echo "Step 4.5: Creating logrotate configuration file for GenieACS..."
    # Use a here-document to write the logrotate config to a new file.
    # The `> /dev/null` is not needed here as `tee` handles the output.
    cat <<'EOF' | sudo tee /etc/logrotate.d/genieacs > /dev/null
/var/log/genieacs/*.log /var/log/genieacs/*.yaml {
    daily
    rotate 30
    compress
    delaycompress
    dateext
}
EOF
echo "Logrotate configuration created."
echo ""

}

clear_apt_locks() {
    echo "========================================"
    echo "Checking for and removing any apt locks..."
    echo "========================================"
    sudo rm -f /var/lib/dpkg/lock-frontend
    sudo rm -f /var/lib/dpkg/lock
    sudo rm -f /var/cache/apt/archives/lock
    sudo dpkg --configure -a
    sudo apt update
    
}




# Function to ===create and enable the systemd service files.
genieacs_configure() {
echo "========================================"
echo "========Step 4: Configuring GenieACS services and logs XS ========"
echo "========================================"
create_genieacs_nbi_service
create_genieacs_cwmp_service
create_genieacs_fs_service
create_genieacs_ui_service
# Create the log rotation file
create_logrotate_file

}



#######################################################################################33
# --- Main Script Logic ---

# Get the Ubuntu version number
OS_VERSION=$(lsb_release -rs)
echo "*********Detected Ubuntu version: $OS_VERSION*************"

# Use a case statement to handle different Ubuntu versions.
case "$OS_VERSION" in
    "20.04"|"22.04"|"24.04"| "25.04")
    	# For all supported Ubuntu versions, first install Node.js, then MongoDB, and then GenieACS.
        # Clear any locks before starting      
	clear_apt_locks
	sudo snap install curl  
        install_nodejs
        install_mongodb
        install_genieacs
	genieacs_configure
        genieacs_service
        ;;
    *)
        # Exit if the OS version is not supported.
        echo "ERROR: Your Ubuntu version ($OS_VERSION) is too old, maybe you need to manually install."
       # echo "This script supports versions 20.04, 22.04, and 24.04."
        exit 1
        ;;
esac
echo "========================================"
echo "========All installation steps finished successfully.========"
echo "node version: $(node -v)"
echo echo "mongo version: $(mongod --version | grep "db version" | awk '{print $3}')"
echo "npm version: $(npm -v)"
echo "genieacs version: $(npm list -g genieacs)"
echo "========================================"



