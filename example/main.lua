---
-- main.lua


package.path = package.path .. ";../?.lua"


local TileCutter = require "tile_cutter"


local tc


function love.load()
    tc = TileCutter("fantasy-tileset.png", 32)
    tc:config_tileset(
        {
            {"elf", 1, 19},
            {"dwarf", 2, 19},
            {"barbarian", 3, 19},
            {"rabbit", 2, 21}
        }
    )

    -- change default behavior of error handler
    -- if we dont know an tile, we draw rabbit tile
    tc:set_error_handler(
        function (name, x, y, ...)
            tc:draw("rabbit", x, y, ...)
        end
    )
end


function love.update(dt)

end


function love.draw()
    -- simple drawing of tiles
    tc:draw("elf", 100, 100)
    tc:draw("barbarian", 500, 100)

    -- draw tile with extra arguments
    tc:draw("dwarf", 300, 400, 2, 2, 2)

    -- unknown tile name
    tc:draw("Wizard", 600, 300)
end
