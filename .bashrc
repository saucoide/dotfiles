#
# Generated from ~/dotfiles/system.org
#

# PS1='\[\e[31m\]\u\[\e[34m\]@\h:\[\e[32m\]\w$ \[\e[0m\]'

# PATH

# if [ -d "$HOME/.bin" ] ;
#   then PATH="$HOME/.bin:$PATH"
# fi

# if [ -d "$HOME/.local/bin" ] ;
#   then PATH="$HOME/.local/bin:$PATH"
# fi

# export PATH=~/.local/bin:$PATH
# export PATH=~/.emacs.d/bin:$PATH
# export PATH=~/.poetry/bin:$PATH

# export EDITOR=vim

# use vim as manpager
# export MANPAGER='/bin/bash -c "vim -MRn -c \"set buftype=nofile showtabline=0 ft=man ts=8 nomod nolist norelativenumber nonu noma\" -c \"normal L\" -c \"nmap q :qa<CR>\"</dev/tty <(col -b)"'

# #readable output
# alias df='df --human-readable'

# #pacman unlock
# alias unlock="sudo rm /var/lib/pacman/db.lck"

# #free
# alias free="free -mt"

# #use all cores
# alias uac="sh ~/.bin/main/000*"

# #continue download
# alias wget="wget -c"

# #userlist
# alias userlist="cut -d: -f1 /etc/passwd"

# #merge new settings
# alias merge="xrdb -merge ~/.Xresources"

# # Aliases for software managment
# # pacman or pm
# alias pacman='sudo pacman --color auto'
# alias update='sudo pacman -Syyu'

# # yay as aur helper - updates everything
# alias upall="yay -Syu"

# #ps
# alias psa="ps auxf"
# alias psgrep="ps aux | grep -v grep | grep -i -e VSZ -e"

# #grub update
# alias update-grub="sudo grub-mkconfig -o /boot/grub/grub.cfg"

# #add new fonts
# alias update-fc='sudo fc-cache -fv'

# #copy/paste all content of /etc/skel over to home folder - backup of config created - beware
# alias skel='cp -Rf ~/.config ~/.config-backup-$(date +%Y.%m.%d-%H.%M.%S) && cp -rf /etc/skel/* ~'
# #backup contents of /etc/skel to hidden backup folder in home/user
# alias bupskel='cp -Rf /etc/skel ~/.skel-backup-$(date +%Y.%m.%d-%H.%M.%S)'

# #switch between bash and zsh
# alias tobash="sudo chsh $USER -s /bin/bash && echo 'Now log out.'"
# alias tozsh="sudo chsh $USER -s /bin/zsh && echo 'Now log out.'"

# #hardware info --short
# alias hw="hwinfo --short"

# #get fastest mirrors in your neighborhood
# alias mirror="sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist"
# alias mirrord="sudo reflector --latest 50 --number 20 --sort delay --save /etc/pacman.d/mirrorlist"
# alias mirrors="sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist"
# alias mirrora="sudo reflector --latest 50 --number 20 --sort age --save /etc/pacman.d/mirrorlist"

# #mounting the folder Public for exchange between host and guest on virtualbox
# alias vbm="sudo mount -t vboxsf -o rw,uid=1000,gid=1000 Public /home/$USER/Public"

# #calendar
# alias cal="cal -y -m"

# #youtube-dl
# alias yta-best="youtube-dl --extract-audio --audio-format best "
# alias yta-mp3="youtube-dl --extract-audio --audio-format mp3 "
# alias yta-wav="youtube-dl --extract-audio --audio-format wav "
# alias ytv-best="youtube-dl -f bestvideo+bestaudio "

# #Recent Installed Packages
# alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"
# alias riplong="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -3000 | nl"

# #Cleanup orphaned packages
# alias cleanup='sudo pacman -Rns $(pacman -Qtdq)'

# #get the error messages from journalctl
# alias jctl="journalctl -p 3 -xb"

# #emacs for important configuration files
# #know what you do in these files
# alias elightdm="sudo emacs /etc/lightdm/lightdm.conf"
# alias epacman="sudo emacs /etc/pacman.conf"
# alias egrub="sudo emacs /etc/default/grub"
# alias eoblogout="sudo emacs /etc/oblogout.conf"
# alias bls="betterlockscreen -u /usr/share/backgrounds/arcolinux/"
