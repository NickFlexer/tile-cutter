# tile-cutter

A small module for [LÖVE](https://love2d.org/) that makes it easy to draw square tiles. Works with tilesets with square tiles without borders between tiles



## Simple example

```lua
local TileCutter = require "tile_cutter"


local tc


function love.load()
    tc = TileCutter("fantasy-tileset.png", 32)
    tc:config_tileset(
        {
            {"elve", 1, 19},
            {"dwarf", 2, 19},
            {"barbarian", 3, 19}
        }
    )
end

function love.draw()
    -- now you can draw, scale or rotate tiles
    tc:draw("elve", 32, 64)
    tc:draw("elve", 96, 64, 0, 2)
    tc:draw("elve", 64, 64, math.pi / 2, 1, 1, 0, 32)
end
```

The result will be something like this:



## Documentation

**```TileCutter(path_to_file, tile_size)```**

Create new TileCutter object

Arguments:
* ```path_to_file``` ```(string)``` - Path to tileset file (for example, "my_tileset.png")
* ```tile_size``` ```(number)``` - Size of tile (for example 16, 32, ets)

Returns:
* ```TileCutter``` ```(table)``` - The TileCutter object

---

**```:config_tileset(tileset_data)```**

Prepare tiles for drawning

Arguments:
* ```tileset_data``` ```(table)``` - Table containing list of tables with the name of the tile and its coordinates (X and Y) in the dimensions of a single tile

```lua
tile_cutter:config_tileset({
    {"first_tile", 10, 20},
    {"second_tile", 11, 20},
    ...
})
```

---

**```:draw(name, x, y, ...)```**

Draws a tile with the given name at the given screen coordinates

Arguments:
* ```name``` ```(string)``` - Tile name
* ```x``` ```(number)``` - X coordinate
* ```y``` ```(number)``` - Y coordinate
* ```...``` ```(mixin)``` - extra arguments of [love.graphics.draw](https://love2d.org/wiki/love.graphics.draw)

If TileCutter doesn't know the passed tile name it thrown an exception:

```invalid tile name```

---

**```:set_error_handler(new_handler)```**

If you want to change the behavior of the TileCutter when trying to draw a tile with an unknown name, set the new behavior in the ```new_handler``` function

Arguments:
* ```new_handler``` ```(function)``` - New handler function

The error handling function receives as parameters all the data from the ```draw``` function

```lua
-- draw default tile when getting unknown tile name
tile_cutter:set_error_handler(
    function (name, x, y, ...)
        tc:tile_cutter("default_tile", x, y, ...)
    end
)
```

