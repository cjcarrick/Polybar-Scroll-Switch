#!/usr/bin/env bash

#
# ARGUMENTS
#
# $1: 'next' or 'prev' wallpaper (or 'query')
#   - if not provided, will default to $defaultWallpaper
#

# wallpapers are set in alphabetical order. filnames can't contain spaces
targetDir=~/wallpapers
labels=(240sx evo jet la polar\ bears r32 rocket senna window wrx)

# the wallpaper to use (from the targetDir) by defualt
defaultWallpaper=evo.jpg

if [ ! -z $1 ]; then

    # find all images in target directory
    targets=($targetDir/*)

    currentWallpaper=$(cat ~/.fehbg | grep -o '/.*\.[a-zA-Z]*')
    currentWallpaperIndex=$(printf '%s\n' "${targets[@]}" | grep -n ${currentWallpaper} | grep -oP '^[0-9]++')
    # grep -n is 1-based, but in bash the array indices are 0-based. This corrects that
    let currentWallpaperIndex--

    if [ "$1" = "query" ]; then

        if [ $(($currentWallpaperIndex + 0)) -gt $((${#labels[@]} - 1)) ]; then
            echo "Err: Not enough Labels"
        else
            echo ${labels[currentWallpaperIndex]}
        fi
        exit 0

    else

        echo "Current wallpaper: $currentWallpaper (index: $currentWallpaperIndex)"
        targetIndex=$currentWallpaperIndex

        if [ "$1" = "prev" ]; then

            let targetIndex--

            # if targetIndex is already at index 0, rollover to the highest possible index
            if [ $targetIndex -lt 0 ]; then
                targetIndex=${#targets[@]}
                # corrects it to be 0-based
                let targetIndex--
            fi

            echo "Going to previus wallpaper at index $targetIndex"

        elif
            [ "$1" == "next" ]
        then

            let targetIndex++

            # if targetIndex is already at highest possible index, rollover to index 0
            if [ $(($targetIndex + 0)) -gt $((${#targets[@]} - 1)) ]; then
                #^^^            ^^^^^^ force $targetIndex to be a number, because aparantly bash doesn't think it is
                targetIndex=0
            fi

        else
            echo "invalid argument '$1' given. must be either 'prev' or 'next'."
            exit 10
        fi

        # find the name (not index) of the wallpaper to be used
        target=${targets[targetIndex]}
        echo "setting wallpaper at '$target'"

    fi

else

    defaultWallpaperIndex=$(printf '%s\n' "${targets[@]}" | grep -n ${defaultWallpaper} | grep -oP '^[0-9]++')
    # grep -n is 1-based, but in bash the array indices are 0-based. This corrects that
    let defaultWallpaperIndex--

    target=${targets[defaultWallpaperIndex]}
    echo "Setting default wallpaper at '$target'"

fi

# set wallpaper
echo "target: $target"
feh --bg-scale $target &

# set colors
wal -i $target
