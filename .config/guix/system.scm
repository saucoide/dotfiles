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
		(keyboard-layout keyboard-layout))))
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
      (bootloader grub-bootloader)
      (targets (list "/dev/sda"))
      (keyboard-layout keyboard-layout)))
  (swap-devices
    (list (uuid "d8a2d1ef-1c33-4e36-b01d-e9e27bbc4596")))
  (file-systems
    (cons* (file-system
             (mount-point "/")
             (device
               (uuid "dcea7200-698a-483f-916c-0cefd419b810"
                     'ext4))
             (type "ext4"))
           %base-file-systems)))

