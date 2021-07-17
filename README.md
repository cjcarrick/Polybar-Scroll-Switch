# Polybar-Scroll-Switch
See examples for usage

The basic version of this script is `PolybarScrollSwitch.sh`, but you might want to base your own script off of one of the examples.

Feel free to fork this into something cool so other people can use it!

## Examples

### Switch Wallpapers
Uses `feh` to switch your wallpaper (and `pywal` to change colors) through other ones you have in a specified directory.

Module:
```
[module/switchWallpaper]
type = custom/script
interval=1
format = <label>
exec = ~/.config/polybar/switchWallpaper.sh query
label = %output%
scroll-up = ~/.config/polybar/switchWallpaper.sh prev
scroll-down = ~/.config/polybar/switchWallpaper.sh next
```

### Switch Bars
This lets you switch through different bars you have. Useful if there's a lot of stuff you want to show but it won't all fit on one bar. It's actually a special `launch.sh` file that does all the work here, with the names of all your bars in an array at the top of the script.

Module:
```
[module/switchBar]
type = custom/script
interval=1
format = <label>
exec = ps auxw --sort=start_time | grep polybar | grep -oP '[^ ]++$' | head -n 1
label = %output%
scroll-up = ~/.config/polybar/launch.sh prev
scroll-down = ~/.config/polybar/launch.sh next
```
