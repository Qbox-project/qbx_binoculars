![image](https://github.com/alberttheprince/qbx_binoculars/assets/85725579/d0061798-fc62-4e93-957b-f580fbeb9506)


# qbx_binoculars

A small resource that allows players to use binoculars!

# Features

- Use binoculars (Wow!)
- Clean camera animation
- Use the scroll wheel to zoom in and out
- Close with Backspace

# Advanced Editing

The following values found in the client.lua file can be modified to adjust the zoom levels and style of binoculars.

```
local MAX_FOV = 70.0 -- Minimum Zoom level 
local MIN_FOV = 5.0 -- max zoom level (smaller FoV results in more zoom)
local ZOOM_SPEED = 10.0 -- camera zoom speed
local LR_SPEED = 8.0 -- speed by which the camera pans left-right
local UD_SPEED = 8.0 -- speed by which the camera pans up-down
local STORE_BINOCULAR_KEY = 177 -- backspace
```
