[ -f ~/.Xmodmaprc ] && xmodmap ~/.Xmodmaprc
[ -f ~/.Xresources ] && xrdb -merge ~/.Xresources
[ -f ~/.xprofile ] && . ~/.xprofile
exec spectrwm
