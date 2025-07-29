#!/bin/bash

export LC_CTYPE=C
export LC_ALL=C

THIS_DIR=$(dirname "$(realpath "$0")")
ROOT_DIR=$(dirname ${THIS_DIR})

# metadata
DATE=$(date +%Y.%m.%d)
BACKUP_DIRECTORY=${HOME}/Backups/${DATE}_backup

# veracrypt configs
SIZE="200MiB"
ENCRYPTION="AES"
HASH="SHA-512"
FILESYSTEM="exFAT"
PIM=120
VOLUME_NAME=${DATE}_"backup_files"

# create directory
check_directory(){
    if [ -d "$HOME/Backups/${DATE}_backup" ]; then
        echo "$HOME/Backups/${DATE}_backup directory exist..."
        echo "Exiting without backing up"
        exit 1
    else
        mkdir -p ~/Backups/${DATE}_backup
    fi
}

# rm -rf ~/Backups/${DATE}_backup


check_software(){
    # Check that we have the necessary command line tools
    if ! command -v veracrypt >/dev/null 2>&1; then
        echo "Error: VeraCrypt is not installed or not in PATH."
        return 1
    fi

    if ! command -v bw >/dev/null 2>&1; then
        echo "Error: Bitwarden CLI not installed. Install with 'brew install bitwarden-cli' "
        return 1
    fi

    if ! command -v openssl >/dev/null 2>&1; then
        echo "Error: Openssl not installed."
        return 1
    fi
}

encrypted_mount(){
    # creates a VeraCrypt volume, gives instructions to what to copy
    # and unmounts the volume. In this step we want to backup:
    # Obsidian notes, Aegis 2FA, Firefox Bookmarks, Phone contacts and
    # ~/.ssh directory.
    
    # Create volume
    veracrypt --text --create \
        --size=${SIZE} \
        --volume-type=normal \
        --encryption=${ENCRYPTION} \
        --hash=${HASH} \
        --password=${PASSWORD} \
        --filesystem=${FILESYSTEM} \
        --pim=${PIM} \
        --keyfiles=${KEYFILES} \
        --random-source /dev/urandom \
        ${BACKUP_DIRECTORY}/${VOLUME_NAME}.hc

    # Mount volume
    veracrypt --text --mount \
        ${BACKUP_DIRECTORY}/${VOLUME_NAME}.hc \
        --password=${PASSWORD} \
        --pim=${PIM} \
        --protect-hidden=no \
        --keyfiles=${KEYFILES} \
        /Volumes/${VOLUME_NAME}

    echo ""
    echo "======================================================================================="
    echo "📂  Place the files in the mounted encrypted directory: $BACKUP_DIRECTORY"
    echo "======================================================================================="
    echo ""

    echo "📝  Obsidian Notes"
    echo "    ----------------------------------------"
    echo "    Copy your notes folder:"
    echo "        cp -r ~/obsidian_notes /Volumes/${VOLUME_NAME}"
    echo ""

    echo "🔐  Aegis Two-Factor Authentication Backup"
    echo "    ----------------------------------------"
    echo "    1. Open the Aegis app on your phone"
    echo "    2. Go to: Settings > Import & Export > Export > Aegis (.JSON)"
    echo "    3. Make sure 'Encrypt the vault' is enabled"
    echo "    4. Save to Google Drive, download manually to ~/Downloads"
    echo "    5. Delete the file from Google Drive"
    echo "    6. Move it to the encrypted volume:"
    echo "        mv ~/Downloads/aegis-*.json /Volumes/${VOLUME_NAME}"
    echo ""

    echo "🌐  Firefox Bookmarks"
    echo "    ----------------------------------------"
    echo "    1. In Firefox: Bookmarks > Manage Bookmarks"
    echo "    2. Click the up/down arrow > Backup (JSON)"
    echo "    3. Download the file directly to /Volumes/${VOLUME_NAME}"
    echo ""

    echo "📇  Phone Contacts"
    echo "    ----------------------------------------"
    echo "    1. Open the Contacts app on your phone"
    echo "    2. Export to file > Device > Save to Google Drive"
    echo "    3. Download to your computer and remove from Drive"
    echo "    4. Move it to the encrypted volume:"
    echo "        mv ~/Downloads/contacts.vcf /Volumes/${VOLUME_NAME}"
    echo ""

    echo "🔑  SSH Keys"
    echo "    ----------------------------------------"
    echo "    Copy your .ssh directory:"
    echo "        cp -r ~/.ssh /Volumes/${VOLUME_NAME}/ssh"
    echo ""


    read -n 1 -s -r -p "Press any key to continue..."
    echo


    # Unmount VeraCrypt volume when finished
    echo ""
    echo "Unmounting VeraCrypt volume..."
    veracrypt --text --unmount ${BACKUP_DIRECTORY}/${VOLUME_NAME}.hc
}

ask_password() {
    # a function that prompts the password, the veracrypt volume will be encrypted
    # using the password provided.
    local pw1 pw2
    while true; do
        read -s -p "Enter password: " pw1
        echo
        read -s -p "Confirm password: " pw2
        echo
        if [[ "$pw1" == "$pw2" ]]; then
            PASSWORD="$pw1"
            break
        else
            echo "Passwords do not match. Please try again."
            exit 1
        fi
    done
}

bitwarden_backup(){
    # use bw CLI to create the backup, have the YubiKey handy
    # based on:
    # https://bitwarden.com/blog/how-to-back-up-and-encrypt-your-bitwarden-vault-from-the-command-line/
    read -p "Bitwarden account email: " BW_ACCOUNT
    read -p "Master Password (hidden): " -s BW_PASS
    export BW_SESSION=$(bw login $BW_ACCOUNT $BW_PASS --raw)

    EXPORT_OUTPUT_BASE="bw_export_"
    TIMESTAMP=$(date "+%Y%m%d%H%M%S")
    ENC_OUTPUT_FILE=$BACKUP_DIRECTORY/$EXPORT_OUTPUT_BASE$TIMESTAMP.enc
    bw --raw --session $BW_SESSION export --format json | openssl enc -aes-256-cbc -pbkdf2 -iter 600000 -k $BW_PASS -out $ENC_OUTPUT_FILE

    # to restore backup decrypt with
    # openssl enc -aes-256-cbc -pbkdf2 -iter 600000 -d -nopad -in bw_export_20220822140328.enc -out bw_export.json
    bw logout > /dev/null
    unset BW_SESSION
    unset BW_PASS
    unset BW_ACCOUNT
}

print_help() {
    echo "============================================================"
    echo "🛡️   BackupBuddy – CLI Backup Tool"
    echo "============================================================"
    echo "👤  Author : Sebastia Agramunt Puig"
    echo ""
    echo "📦  Creates a backup for today in:"
    echo "     ${HOME}/Backups/${DATE}_backup"
    echo ""
    echo "📘  Usage:"
    echo "     backup --help      # Show this help message"
    echo "     backup             # Run the backup"
    echo "============================================================"
}


run_backup(){
    # print help
    [[ "$1" == "-h" || "$1" == "--help" ]] && { print_help; exit 0; }

    echo "0) Check all required software is installed"
    check_software

    echo "1) Asking password to encrypt the volume using VeraCrypt..."
    ask_password

    echo "2) Creating volume to backup files..."
    encrypted_mount

    echo "5) Running bitwarden backup..."
    bitwarden_backup

    echo ""
    echo "✅ Backup Complete!"
    echo "📁 Your backup is saved in: ${BACKUP_DIRECTORY}"
    echo ""
    echo "🔁 For redundancy, please copy it to:"
    echo "   • External drives"
    echo "   • Cloud storage providers (e.g., MEGA, Dropbox, Google Drive)"
    echo ""
    echo "💡 Tip: Keep at least one off-site copy for disaster recovery."
}


run_backup "$@"
