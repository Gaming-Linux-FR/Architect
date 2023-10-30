source src/cmd.sh

function sound_server() {
    local -r uninstall_lst=(
        pulseaudio
        pulseaudio-bluetooth
        pulseaudio-alsa
        jack2
        pipewire-media-session
    )
    local -r install_lst=(
        pipewire
        lib32-pipewire
        pipewire-pulse
        pipewire-alsa
        pipewire-jack
        wireplumber
        alsa-utils
        alsa-firmware
        alsa-tools
    )

    for pkg in "${uninstall_lst[@]}"; do
        exec_log "sudo pacman -Rdd --noconfirm ${pkg}" "Uninstalling ${pkg}"
    done

    for pkg in "${install_lst[@]}"; do
        exec_log "sudo pacman -S --noconfirm --needed ${pkg}" "Installing ${pkg}"
    done
}

function setup_system_loaders() {
    if [[ $BOOT_LOADER != "GRUB" ]]; then
        return
    fi

    exec_log "sudo mkdir -p '/etc/pacman.d/hooks/'" "Creating /etc/pacman.d/hooks/"
    exec_log "sudo cp 'assets/data/grub.hook' '/etc/pacman.d/hooks/'" "Copying grub.hook to /etc/pacman.d/hooks/"
    exec_log "${AUR} -S --noconfirm --needed update-grub" "Installing update-grub"
}

function firewall() {
    read -rp "Do you want to install a firewall /!\ Install and activate firewalld? The default configuration may block access to printers and other devices on your local network ? (y/N) : " choice
    choice="${choice,,}"

    if [[ $choice =~ ^(yes|y)$ ]]; then
        exec_log "sudo pacman -S --noconfirm --needed firewalld python-pyqt5 python-capng" "Installing firewalld"
        exec_log "sudo systemctl enable --now firewalld.service" "Enabling firewalld"
    fi
}