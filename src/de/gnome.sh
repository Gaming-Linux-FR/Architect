source src/cmd.sh

function config_gnome() {
    local -r install_lst=(
        adwaita-icon-theme
        eog
        evince
        file-roller
        gdm
        gnome-calculator
        gnome-console
        gnome-control-center
        gnome-disk-utility
        gnome-keyring
        gnome-nettool
        gnome-power-manager
        gnome-screenshot
        gnome-shell
        gnome-text-editor
        gnome-themes-extra
        gnome-tweaks
        gnome-usage
        gvfs
        gvfs-afc
        gvfs-gphoto2
        gvfs-mtp
        gvfs-nfs
        gvfs-smb
        nautilus
        nautilus-sendto
        sushi
        totem
        xdg-user-dirs-gtk
        gnome-browser-connector
        adw-gtk3
    )

    for package in "${install_lst[@]}"; do
        exec_log "${AUR} -S --noconfirm --needed ${package}" "installing of ${package}"
    done

    exec_log "gsettings set org.gnome.desktop.interface gtk-theme adw-gtk3" "Setting gtk theme to adw-gtk3"
    exec_log "gsettings set org.gnome.desktop.peripherals.keyboard numlock-state true" "Enabling numlock on startup"
}
