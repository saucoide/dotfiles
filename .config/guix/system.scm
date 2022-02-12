(use-modules
  (gnu) 
  (gnu packages shells)
  (nongnu packages linux)
  (nongnu system linux-initrd))

(use-service-modules
  cups
  desktop
  networking
  ssh
  xorg)

(operating-system
  (kernel linux)
  (initrd microcode-initrd)
  (firmware (list linux-firmware))
  (locale "en_US.utf8")
  (timezone "Europe/Berlin")
  (keyboard-layout (keyboard-layout "us"))
  (host-name "famara")
  (users (cons* (user-account
		  (name "saucoide")
		  (comment "saucoide")
		  (group "users")
          (shell (file-append fish "/bin/fish"))
		  (home-directory "/home/saucoide")
		  (supplementary-groups '("wheel" "netdev" "audio" "video")))
		%base-user-accounts))

  (packages
    (append
      (list (specification->package "qtile-scn")
	    (specification->package "picom")
	    (specification->package "alacritty")
	    (specification->package "dunst")
	    (specification->package "dmenu")
	    (specification->package "rofi")
	    (specification->package "fish")
	    (specification->package "neovim")
	    (specification->package "emacs")
        (specification->package "nss-certs")
        (specification->package "xf86-input-libinput")
	    (specification->package "git")
	    (specification->package "stow")
	    )
      %base-packages))

  (services
    (append
      (list (service xfce-desktop-service-type)
	    (service cups-service-type)
	    (set-xorg-configuration
          (xorg-configuration
            (keyboard-layout keyboard-layout)
            (extra-config (list
                "Section \"InputClass\"
                    Identifier \"Touchpads\"
                    Driver \"libinput\"
                    MatchDevicePath \"/dev/input/event*\"
                    MatchIsTouchpad \"on\"

                    Option \"Tapping\" \"on\"
                    Option \"TappingDrag\" \"on\"
                    Option \"DisableWhileTyping\" \"on\"
                    Option \"MiddleEmulation\" \"on\"
                    Option \"ScrollMethod\" \"twofinger\"
                EndSection
                Section \"InputClass\"
                    Identifier \"Keyboards\"
                    Driver \"libinput\"
                    MatchDevicePath \"/dev/input/event*\"
                    MatchIsKeyboard \"on\"
                EndSection
                ")))))
    (modify-services %desktop-services
      (guix-service-type config => (guix-configuration
	(inherit config)
	(substitute-urls
	  (append (list "https://substitutes.nonguix.org")
	    %default-substitute-urls))
	(authorized-keys
	  (append (list (plain-file "non-guix.pub"
				     "(public-key
					(ecc
					  (curve Ed25519)
					  (q #C1FD53E5D4CE971933EC50C9F307AE2171A2D3B52C804642A7A35F84F3A4EA98#)
					  )
					)"))
            %default-authorized-guix-keys))))))) 

  (bootloader
    (bootloader-configuration
      (bootloader grub-efi-bootloader)
      (targets (list "/boot/efi"))
      (keyboard-layout keyboard-layout)))
  
  (swap-devices
    (list (uuid "92b57a70-1483-4455-bcbc-00af949efecd")))

  (file-systems
    (cons* (file-system
             (mount-point "/boot/efi")
             (device (uuid "B554-3AA6" 'fat32))
             (type "vfat"))
           (file-system
             (mount-point "/")
             (device
               (uuid "39906d5f-499e-4320-8e2e-2b6fa3bdecad"
                     'ext4))
             (type "ext4"))
           %base-file-systems)))
