#!/usr/bin/env bash

#
# ARGUMENTS
#
# $1: 'next' or 'prev' item (or 'query')
#   - if not provided, will default to $default
#
# See https://github.com/cjcarrick/Polybar-Scroll-Switch/ for details and examples
#

# an array of all the items you want to interate through (in order) from the config file
targets=(___, ___, ...)

# the item to use (from the 'targets' array) by defualt
default=___

if [ ! -z $1 ]; then

    currentItem=$(ps auxw --sort=start_time | grep polybar | grep -oP '[^ ]++$' | head -n 1)

    currentItemIndex=$(printf '%s\n' "${targets[@]}" | grep -n ${currentItem} | grep -oP '^[0-9]++')

    # grep -n is 1-based, but in bash the array indices are 0-based. This corrects that
    let currentItemIndex--

    if [ "$1" = "query" ]; then

        echo ${labels[currentItemIndex]}
        exit 0

    else

        echo "Current item: $currentItem (index: $currentItemIndex)"

        targetIndex=$currentItemIndex

        if [ "$1" = "prev" ]; then

            let targetIndex--

            # if targetIndex is already at index 0, rollover to the highest possible index
            if [ targetIndex -lt 0 ]; then

                targetIndex=${#targets[@]}

                # corrects it to be 0-based
                let targetIndex--

            fi

            echo "Going to previus item at index $targetIndex"

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

        # find the name (not index) of the item to be used
        target=${targets[targetIndex]}

        echo "Switching to item: '$target'"

    fi

else

    defaultIndex=$(printf '%s\n' "${targets[@]}" | grep -n ${default} | grep -oP '^[0-9]++')

    # grep -n is 1-based, but in bash the array indices are 0-based. This corrects that
    let defaultIndex--
    target=${targets[defaultIndex]}

    echo "Running default item '$target'"

fi

# do something with your target
echo "$target (index $targetIndex)"