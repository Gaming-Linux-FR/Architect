# ARCH LINUX POST-INSTALLATION TUTORIAL AND SCRIPT

## PREAMBLE
### IMPORTANT !! ###
**This tutorial must be followed exactly in the order given!**

### Presentation

Arch is a technical distribution aimed at a more advanced audience, consisting of "building blocks". Think of it like a set of blank Lego, with a base that you need to build and shape as you wish, and if you do it wrong, things can break.

The purpose of this tutorial is to install a stock Arch with a minimum of packages, according to our needs for office work and/or gaming.

<img src="https://github.com/Cardiacman13/Tuto-Arch/blob/main/assets/images/Cardiac-icon.png" width="30" height="30"> This icon redirects you to my videos on certain parts of this tutorial.

<img src="assets/images/Cardiac-icon.png" width="30" height="30"> [ Arch Linux Tutorial Playlist ](https://www.youtube.com/watch?v=JE6VwNHLcyk&list=PLuIP_-MWRwtWEX0tyDpZPdwU6zCE1O1cY)

### Conditions

The script you will find later works regardless of your choices of DE / BOOT LOADER / FS.

The tutorial is optimized for the following choices:

- systemd-boot
- Ext4
- KDE
- A pure Arch (incompatible with Garuda, EndeavourOS, Manjaro…) 

However, if you know what you are doing, the modifications for other choices are minimal.

Download the ISO: [**Arch Linux - Downloads**](https://archlinux.org/download/)

### Table of Contents
1. [Installation](#section-1)
2. [Post installation](#section-2)
3. [Hardware Support](#section-3)
4. [Basic Software](#section-4)
5. [Gaming](#section-5)
6. [Bonus](#section-6)

## INSTALLATION    <a name="section-1"></a>

**Follow this video meticulously:**
<img src="assets/images/Cardiac-icon.png" width="30" height="30"> [ Arch Linux Tutorial Part 1: Archinstall ](https://www.youtube.com/watch?v=JE6VwNHLcyk)

For all the following steps, when you have text presented in this way, it will indicate a command to type in your terminal:
```
echo "Hello world !"            # Example command
```

1. **Set the keyboard to French**
    Be careful here: by default, you will be in QWERTY, so the "a" will be, and only for this command, on the "q" key of your keyboard.
    ```
    loadkeys fr
    ```

2. **Set up your Wi-Fi**
    ```
    iwctl
    ```
    Then (replace YOUR-WIFI-NAME with the name of your wifi)
    ```
    station wlan0 connect YOUR-WIFI-NAME (SSID)
    ```
    Enter your wifi password then `quit` to exit iwctl.

3. **Archinstall**
    ```
    pacman -Syu archinstall      # update the archinstall script before installation
    archinstall                 # to launch the installation help script for arch linux
    ```
    **/!\ The archinstall menu is subject to change with updates to the script /!\\**
    
## POST INSTALLATION    <a name="section-2"></a>
<img src="assets/images/Cardiac-icon.png" width="30" height="30"> [ Arch Linux Tutorial Part 2: Post Installation ](https://youtu.be/FEFhC46BkXo?si=Gi-6BOhqENLoh5Ak)

This script is to be executed on a clean installation, **freshly installed with archinstall**; it will perform the tutorial for you regardless of your choices of DE, bootloader, and file system.

If Nvidia, ensure that your card is compatible with the latest Nvidia drivers. In general, this script/tutorial is not intended for very old computers.

**Post-installation script:**

   ```
   sudo pacman -Syu git
   git clone https://github.com/Cardiacman13/Tuto-Arch.git
   cd Tuto-Arch
   ./post-installation
   ```
Feel free to report any bugs, thank you :)

### Optimize pacman

1. This [modification](https://wiki.archlinux.org/title/Pacman#Enabling_parallel_downloads) allows for parallelization of package downloads. (PS: with kate, when you save, you might be asked to enter a password. Enter your root/sudo password.)

   ```
   kate /etc/pacman.conf
   ```

   Uncomment (remove the **#** from the following lines):
   
   ```
   #Misc options
   #UseSyslog
   Color <-
   #NoProgressBar
   #CheckSpace
   VerbosePkgLists <- 
   ParallelDownloads = 5 <-
   ```

2. Installing yay

   [Yay](https://github.com/Jguer/yay) is a handy tool for managing the installation and updating of software on Arch Linux-based systems.
   Yay especially makes it easier to use the AUR repository, a community-managed repository that significantly expands the available software library. This includes compiling these programs from their source, unless "-bin" is specified at the end of their name.
   **/!\ Be cautious /!\ As the packages in AUR are community-provided, don't install just anything!**
   
   ```
   sudo pacman -S --needed git base-devel
   git clone https://aur.archlinux.org/yay-bin.git
   cd yay-bin
   makepkg -si
   ```

   Adding support for updates of git packages. (Normally only needs to be done once)
   ```
   yay -Y --gendb
   yay -Y --devel --save
   ```

3. Maintenance aliases:

   <img src="assets/images/Cardiac-icon.png" width="30" height="30"> [ Arch Linux Tutorial Part 4: Maintenance ](https://www.youtube.com/watch?v=Z7POSK2jnII)

   This modification allows you to simply type “update-arch” in a terminal to update the system, “clean-arch” to clean it, or “fix-key” in case of an error with the gpg keys.

   ```
   kate ~/.bashrc
   ```
   Add each of these lines to the end of the file:
   ```
   alias update-arch='yay -Syu && flatpak update'
   ```
   ```
   alias clean-arch='yay -Sc && yay -Yc && flatpak remove --unused'
   ```
   ```
   alias fix-key='sudo rm /var/lib/pacman/sync/* && sudo rm -rf /etc/pacman.d/gnupg/* && sudo pacman-key --init && sudo pacman-key --populate && sudo pacman -Sy --noconfirm archlinux-keyring && sudo pacman --noconfirm -Su'
   ```
   
   Restart the terminal.

## HARDWARE SUPPORT    <a name="section-3"></a>

### NVIDIA (stay on X11 at least until the release of KDE 6)
Supplementary video explaining how to regain access to Wayland from GDM:
<img src="assets/images/Cardiac-icon.png" width="30" height="30"> [Debian and Arch Linux Gnome Wayland with Nvidia (Debian in the doc)](https://www.youtube.com/watch?v=DVkWLvwtQ18)

1. **Install the core components:**
    ```
    yay -S --needed nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader cuda
    ```

2. **Enable nvidia-drm.modeset=1:**

This setting allows the Nvidia module to be launched at startup.

   - **If using systemd boot**

In the folder:

```
/boot/loader/entries/
```

   There are several .conf files, you need to add nvidia-drm.modeset=1 to the “options” line of each file.
   Example: options root=PARTUUID=fb680c54-466d-4708-a1ac-fcc338ed57f1 rw rootfstype=ext4 nvidia-drm.modeset=1

- **If using GRUB**

    ```
    kate /etc/default/grub
    ```

    Add **nvidia-drm.modeset=1** to the "grub_cmdline_linux_default=" line

    Example: GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet nvidia-drm.modeset=1"

    Then:

    ```
    sudo grub-mkconfig -o /boot/grub/grub.cfg
    ```
   
3. **Load Nvidia modules as a priority at Arch launch:**
    This step is sometimes necessary for certain desktop environments or window managers.
    ```
    kate /etc/mkinitcpio.conf
    ```
    Modify the MODULES=() line to:
    ```
    MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)
    ```
    If using btrfs:
    ```
    MODULES=(btrfs nvidia nvidia_modeset nvidia_uvm nvidia_drm)
    ```

4. **mkinitcpio Hook:**
    This hook automates the rebuilding of initramfs (the basic boot file) with every Nvidia driver modification.
    ```
    sudo mkdir /etc/pacman.d/hooks/
    kate /etc/pacman.d/hooks/nvidia.hook
    ```
    Add:
    ```
    [Trigger]
    Operation=Install
    Operation=Upgrade
    Operation=Remove
    Type=Package
    Target=nvidia-dkms
    Target=nvidia-470xx-dkms
    Target=usr/lib/modules/*/vmlinuz

    [Action]
    Description=Update NVIDIA module in initcpio
    Depends=mkinitcpio
    When=PostTransaction
    NeedsTargets
    Exec=/bin/sh -c 'while read -r trg; do case $trg in linux) exit 0; esac; done; /usr/bin/mkinitcpio -P'
    ```

5. **Rebuilding initramfs:**
    Since we've already installed the drivers at step 1, thus before setting up the hook, we need to manually trigger the initramfs rebuilding:
    ```
    mkinitcpio -P
    ```

### AMD (do not do if Nvidia)
Install the core components:
```
yay -S --needed mesa lib32-mesa vulkan-radeon lib32-vulkan-radeon vulkan-icd-loader lib32-vulkan-icd-loader vulkan-mesa-layers lib32-vulkan-mesa-layers
```

### INTEL (do not do if Nvidia)
Install the core components:
```
yay -S --needed mesa lib32-mesa vulkan-intel lib32-vulkan-intel vulkan-icd-loader lib32-vulkan-icd-loader intel-media-driver
```

### Printers
- Essentials
    ```
    yay -S ghostscript gsfonts cups cups-filters cups-pdf system-config-printer
    avahi --needed
    sudo systemctl enable --now avahi-daemon cups
    ```
- Drivers
    ```
    yay -S foomatic-db-engine foomatic-db foomatic-db-ppds foomatic-db-nonfree foomatic-db-nonfree-ppds gutenprint foomatic-db-gutenprint-ppds --needed
    ```
- HP Printers
    ```
    yay -S python-pyqt5 hplip --needed
    ```
- Epson Printers
    ```
    yay -S --needed epson-inkjet-printer-escpr epson-inkjet-printer-escpr2 epson-inkjet-printer-201601w epson-inkjet-printer-n10-nx127
    ```

### Bluetooth
The second command below asks systemd to immediately start the bluetooth service, and also to activate it on every boot.
```
yay -S --needed bluez bluez-utils bluez-plugins
sudo systemctl enable

## BASIC SOFTWARE <a name="section-4"></a>

### Basic Components
Here you will find codecs, utilities, fonts, drivers:
```
yay -S gst-plugins-bad gst-plugins-base gst-plugins-ugly gst-plugin-pipewire gstreamer-vaapi gst-plugins-good gst-libav gstreamer reflector-simple downgrade rebuild-detector mkinitcpio-firmware xdg-desktop-portal-gtk xdg-desktop-portal neofetch power-profiles-daemon lib32-pipewire hunspell hunspell-fr p7zip unrar ttf-liberation noto-fonts noto-fonts-emoji adobe-source-code-pro-fonts otf-font-awesome ttf-droid ntfs-3g fuse2fs exfat-utils fuse2 fuse3 bash-completion man-db man-pages --needed
```

## BASIC SOFTWARE <a name="section-4"></a>

### Basic Components
Here you will find codecs, utilities, fonts, drivers:
```
yay -S gst-plugins-bad gst-plugins-base gst-plugins-ugly gst-plugin-pipewire gstreamer-vaapi gst-plugins-good gst-libav gstreamer reflector-simple downgrade rebuild-detector mkinitcpio-firmware xdg-desktop-portal-gtk xdg-desktop-portal neofetch power-profiles-daemon lib32-pipewire hunspell hunspell-fr p7zip unrar ttf-liberation noto-fonts noto-fonts-emoji adobe-source-code-pro-fonts otf-font-awesome ttf-droid ntfs-3g fuse2fs exfat-utils fuse2 fuse3 bash-completion man-db man-pages --needed
```

### Miscellaneous Software
```
yay -S libreoffice-fresh libreoffice-fresh-fr vlc discord gimp obs-studio gnome-disk-utility visual-studio-code-bin
```

### KDE Software

Here are various software for graphics, video (editing, codec support), graphical interface utilities, etc.
```
yay -S xdg-desktop-portal-kde okular print-manager kdenlive gwenview spectacle partitionmanager ffmpegthumbs qt6-wayland kdeplasma-addons powerdevil kcalc plasma-systemmonitor qt6-multimedia qt6-multimedia-gstreamer qt6-multimedia-ffmpeg kwalletmanager
```

Additional Video:
<img src="assets/images/Cardiac-icon.png" width="30" height="30"> [Customizing KDE Part 1 Layout, Theme, Kvantum, best practices!](https://www.youtube.com/watch?v=vdlj83sb84s&t=1240s)

### Firewall
The default configuration may block access to printers and other devices on your local network.
Here is a little link to help you: https://www.dsfc.net/infra/securite/configurer-firewalld/
```
sudo pacman -S --needed --noconfirm firewalld python-pyqt5 python-capng
sudo systemctl enable --now firewalld.service
firewall-applet &
```

### Reflector for automatic mirror updates

```
yay -S reflector-simple
```

A command to generate a list of mirrors, to be done once after the first installation and repeated if you travel, or change countries, or if you find package downloading too slow, or if you encounter an error telling you that a mirror is down:

```
sudo reflector --score 20 --fastest 5 --sort rate --save /etc/pacman.d/mirrorlist
```

## GAMING <a name="section-5"></a>

### Steam
Note that AMD or Nvidia drivers must be installed beforehand as mentioned in the [HARDWARE SUPPORT](#HARDWARE-SUPPORT) section.
```
yay -S steam
```

### Lutris

Lutris is a FOSS (Free, Open Source) game manager for Linux-based operating systems.
Lutris allows searching for a game or a platform (Ubisoft Connect, EA Store, GOG, Battlenet, etc.) and proposes an installation script that will configure what's needed for your choice to work with Wine or Proton.

```
sudo pacman -S --needed lutris wine-staging
```

Additional Video:
    <img src="assets/images/Cardiac-icon.png" width="30" height="30"> [Setting up Lutris for Intel/Nvidia laptop ](https://www.youtube.com/watch?v=Am3pgTXiUAA)

### Advanced controller support

Advanced Linux driver for Xbox 360|One|S|X wireless controllers (supplied with Xbox One S) and a lot of other controllers like 8bitdo ([xpadneo](https://github.com/atar-axis/xpadneo)) ([xone](https://github.com/medusalix/xone))


```
yay -S --needed xpadneo-dkms 
```
Advanced Linux driver for PS4/PS5 controllers
```
yay -S --needed bluez-utils-compat ds4drv dualsencectl
```

### Displaying in-game performance

[MangoHud](https://wiki.archlinux.org/title/MangoHud) is a Vulkan and OpenGL overlay that allows monitoring system performance within applications and recording metrics for benchmarking.
It's the tool you need if you want to see your in-game FPS, your CPU or GPU load, etc. Or even record these results in a file.
Here, we install GOverlay which is a graphical interface to configure MangoHud.

```
yay -S goverlay --needed
```

### Improving compatibility of Windows games

We increase the default value of this variable, allowing for the storage of more "memory map areas". The default value is very low. The goal is to improve compatibility with Windows games via Wine or Steam (See [ProtonDB](https://www.protondb.com/)), knowing that some poorly

 optimized games tend to reach this limit quickly, which can result in a crash.

**Warning**: This operation is to be done after the installation of a Kernel, whether it is the stock kernel or a TKG (see section [KERNEL](#section-7)). It will have to be done again at each kernel change.

Here is a small script to automate this operation:

```bash
sudo bash -c 'echo "vm.max_map_count=262144" >> /etc/sysctl.d/99-sysctl.conf'
sudo sysctl -p /etc/sysctl.d/99-sysctl.conf
```

## SYSTEM PERFORMANCE & TWEAKING <a name="section-6"></a>

### System backup with Timeshift

Timeshift is primarily designed to protect system files and settings. User data such as documents, pictures, music, and videos are not backed up.

```
yay -S timeshift
```

### Kernel (Including TKG PDS & BMQ versions)

```
yay -S linux-tkg-pds-zen linux-tkg-pds-zen-headers linux-tkg-muqss-zen linux-tkg-muqss-zen-headers linux-tkg-bmq-zen linux-tkg-bmq-zen-headers
```

### Mesa-tkg-git

Mesa-tkg-git is a version of Mesa optimized for performance.
This can be useful, especially if you are playing games using Vulkan or OpenGL.
For AMD GPUs only:

```
yay -S mesa-tkg-git
```

### Optimizing system performance

When it comes to system performance, not only the hardware but also the configuration matters. Here are some tricks and tools to optimize your Arch Linux installation.

#### Feral Interactive's Gamemode

[GameMode](https://github.com/FeralInteractive/gamemode) is an open-source daemon/lib combo for Linux that allows games to request a set of optimizations be temporarily applied to the host OS and/or a game process.
GameMode improves gaming performance by applying various optimizations, such as optimizing CPU governor or GPU performance mode, when a compatible game is running.

```
yay -S gamemode
```

## SYSTEM MAINTENANCE & PROBLEM-SOLVING <a name="section-7"></a>

### Useful video links for troubleshooting Arch Linux
- [Troubleshooting Arch Linux Common Problems](https://www.youtube.com/watch?v=hmZrJyFPc10)
- [Fixing Common Arch Linux Installation Errors](https://www.youtube.com/watch?v=ZrMNkrC3vYg)

Sources et liens utiles :
- [ArchWiki](https://wiki.archlinux.org/)
<img src="assets/images/Cardiac-icon.png" width="30" height="30"> [Fonctionnement du WIKI d'Arch.](https://www.youtube.com/watch?v=TQ3A9l2N5lI)
- [Site GLF](https://www.gaminglinux.fr/)
- [Discord GLF](http://discord.gg/EP3Jm8YMvj)
- [Ma chaine Youtube](https://www.youtube.com/@Cardiacman)