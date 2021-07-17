#!/usr/bin/env bash

#
# ARGUMENTS
#
# $1: 'next' or 'prev' bar (or 'query')
#   - if not provided, will default to $defaultBar
#

# an array of all the bars you want to switch to (in order) from the config file
targets=(min mid max)

# the bar to use (from the 'targets' array) by defualt
defaultBar=max

# determine what bar to draw
if [ ! -z $1 ]; then

    runningBar=$(ps auxw --sort=start_time | grep polybar | grep -oP '[^ ]++$' | head -n 1)

    runningBarIndex=$(printf '%s\n' "${targets[@]}" | grep -n ${runningBar} | grep -oP '^[0-9]++')

    # grep -n is 1-based, but in bash the array indices are 0-based. This corrects that
    let runningBarIndex--

    if [ "$1" = "query" ]; then

        echo ${labels[runningBarIndex]}
        exit 0

    else

        echo "Current bar: $runningBar (index: $runningBarIndex)"

        # remove the bar that's already there
        pkill -f "polybar -c /home/< *******YOUR HOME DIR HERE******* >/.config/polybar/config $runningBar"
        # (this should be the path to your polybar config file)

        targetIndex=$runningBarIndex

        if [ "$1" = "prev" ]; then

            let targetIndex--

            # if targetIndex is already at index 0, rollover to the highest possible index
            if [ $targetIndex -lt 0 ]; then

                targetIndex=${#targets[@]}

                # corrects it to be 0-based
                let targetIndex--

            fi

            echo "Going to previus bar at index $targetIndex"

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

        # find the name (not index) of the bar to be used
        target=${targets[targetIndex]}

        echo "Switching to bar: '$target'"

    fi

else

    defaultBarIndex=$(printf '%s\n' "${targets[@]}" | grep -n ${defaultBar} | grep -oP '^[0-9]++')

    # grep -n is 1-based, but in bash the array indices are 0-based. This corrects that
    let defaultBarIndex--
    target=${targets[defaultBarIndex]}

    echo "Running default bar '$target'"

fi

# add bar
polybar -c /home/cervidae/.config/polybar/config $target &
