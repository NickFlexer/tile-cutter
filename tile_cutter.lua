---
-- tile_cutter.lua


local TileCutter = {}

local TileCutter_mt = {__index = TileCutter}

function TileCutter:new(image, tile_size)
    self.img = love.graphics.newImage(image)
    self.tile_size = tile_size
    self.quads = {}
    self.error_handler = function (name)
        error("invalid tile name " .. name)
    end

    return setmetatable({}, TileCutter_mt)
end

function TileCutter:config_tileset(tileset_data)
    for _, tile_data in ipairs(tileset_data) do
        self.quads[tile_data[1]] = love.graphics.newQuad(
            (self.tile_size * tile_data[2]) - self.tile_size,
            (self.tile_size * tile_data[3]) - self.tile_size,
            self.tile_size,
            self.tile_size,
            self.img:getDimensions()
        )
    end
end

function TileCutter:draw(name, x, y, ...)
    if self:_check_name_valid(name) then
        love.graphics.draw(self.img, self.quads[name], x, y, ...)
    else
        self.error_handler(name, x, y, ...)
    end
end

function TileCutter:set_error_handler(new_handler)
    self.error_handler = new_handler
end

function TileCutter:_check_name_valid(name)
    return not not self.quads[name]
end

return setmetatable(TileCutter, {__call = TileCutter.new})
