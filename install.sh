#!/bin/bash
############################
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

########## Variables

dotfiles=~/dotfiles            # dotfiles directory
backup=~/test_backup        # dotfiles backup directory
files="gitconfig compton.conf config/qtile config/dunst config/ulauncher"           # list of files/folders to symlink in homedir

##########

# create backup dir
echo "Creating $backup for backup of any existing dotfiles in ~"
mkdir -p $backup
echo "...done"

# change to the dotfiles directory
echo "Changing to the $dotfiles directory"
cd $dotfiles
echo "...done"

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks 
for file in $files; do
    
    echo "Moving any existing dotfiles from ~ to $olddir"
    mv ~/$file $backup
    echo "...done"
    
    echo "Creating symlink to $file in home directory."
    ln -s $dotfiles/$file ~/.$file
    echo "...done"
done
