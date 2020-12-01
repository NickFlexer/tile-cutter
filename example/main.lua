---
-- main.lua


package.path = package.path .. ";../?.lua"


local TileCutter = require "tile_cutter"


local tc


function love.load()
    tc = TileCutter("fantasy-tileset.png", 32)
    tc:config_tileset(
        {
            {"elve", 1, 19},
            {"dwarf", 2, 19},
            {"barbarian", 3, 19},
            {"rabbit", 2, 21}
        }
    )

    -- change default behavior of error handler
    -- if we dont know an tile, we draw rabbit tile
    tc:set_error_handler(
        function (_, x, y, ...)
            tc:draw("rabbit", x, y, ...)
        end
    )
end


function love.update()

end


function love.draw()
    -- simple drawing of tiles
    tc:draw("elve", 32, 64)

    -- scaling
    tc:draw("elve", 96, 64, 0, 2)

    -- rotation
    tc:draw("elve", 64, 64, math.pi / 2, 1, 1, 0, 32)

    -- unknown tile name
    tc:draw("Wizard", 256, 64)
end
