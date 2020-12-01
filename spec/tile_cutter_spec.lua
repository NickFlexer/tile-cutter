---
-- tile_cutter_spec.lua


describe("Tile cutter", function ()

    local TileCutter = require "tile_cutter"

    local mock_img = {
        getDimensions = function () return 10, 20 end
    }

    _G.love = {
        graphics = {
            newImage = function () return mock_img end,
            newQuad = function () return "test_quad" end,
            draw = function () end
        }
    }

    describe("initialize", function ()

        it("valid initialization", function ()
            spy.on(_G.love.graphics, "newImage")

            local tc = TileCutter("test.png", 32)

            assert.is.Table(tc)
            assert.are.equals(tc._DESCRIPTION, "A small module for LÖVE that makes it easy to draw square tiles")
            assert.spy(_G.love.graphics.newImage).was_called_with("test.png")

            _G.love.graphics.newImage:revert()
        end)

        it("invalid tile size", function ()
            assert.has_error(
                function () TileCutter("test.png", "32") end, "TileCutter() tile size must be a number value"
            )
        end)
    end)

    describe("config tileset", function ()

        it("config single tile", function ()
            local tc = TileCutter("test.png", 16)

            spy.on(_G.love.graphics, "newQuad")

            tc:config_tileset({
                {"test_tile", 1, 1}
            })

            assert.spy(_G.love.graphics.newQuad).was_called(1)
            assert.spy(_G.love.graphics.newQuad).was_called_with(0, 0, 16, 16, 10, 20)
            assert.are.equals(tc.quads["test_tile"], "test_quad")

            _G.love.graphics.newQuad:revert()
        end)

        it("config multiple tiles", function ()
            local tc = TileCutter("test.png", 16)

            spy.on(_G.love.graphics, "newQuad")

            tc:config_tileset({
                {"test_tile_1", 1, 1},
                {"test_tile_2", 1, 2},
                {"test_tile_3", 1, 3},
                {"test_tile_4", 1, 4}
            })

            assert.spy(_G.love.graphics.newQuad).was_called(4)

            _G.love.graphics.newQuad:revert()
        end)

        it("config without tiles", function ()
            local tc = TileCutter("test.png", 16)

            spy.on(_G.love.graphics, "newQuad")

            tc:config_tileset({})

            assert.spy(_G.love.graphics.newQuad).was_called(0)

            _G.love.graphics.newQuad:revert()
        end)
    end)

    describe("draw tiles", function ()

        local tc

        setup(function ()
            tc = TileCutter("test.png", 16)
            tc:config_tileset({
                {"test_tile", 1, 1}
            })
        end)

        it("valid draw", function ()
            spy.on(_G.love.graphics, "draw")

            tc:draw("test_tile", 100, 200)

            assert.spy(_G.love.graphics.draw).was_called(1)
            assert.spy(_G.love.graphics.draw).was_called_with(mock_img, "test_quad", 100, 200)

            _G.love.graphics.draw:revert()
        end)

        it("valid draw with extra arguments", function ()
            spy.on(_G.love.graphics, "draw")

            tc:draw("test_tile", 64, 64, math.pi / 2, 1, 1, 0, 32)

            assert.spy(_G.love.graphics.draw).was_called(1)
            assert.spy(_G.love.graphics.draw).was_called_with(mock_img, "test_quad", 64, 64, math.pi / 2, 1, 1, 0, 32)

            _G.love.graphics.draw:revert()
        end)

        it("unknown tile name", function ()
            assert.has_error(
                function () tc:draw("unknown", 10, 20) end, "TileCutter:draw() invalid tile name 'unknown'"
            )
        end)
    end)

    describe("custom error handler", function ()
        local tc

        setup(function ()
            tc = TileCutter("test.png", 16)
            tc:config_tileset({
                {"test_tile", 1, 1}
            })
        end)

        it("set new handler", function ()
            local mock_handler = spy.new(function() end)

            tc:set_error_handler(mock_handler)

            tc:draw("unknown", 10, 20)

            assert.spy(mock_handler).was_called(1)
            assert.spy(mock_handler).was_called_with("unknown", 10, 20)
        end)

        it("set not callable handler", function ()
            assert.has_error(
                function () tc:set_error_handler() end, "TileCutter:set_error_handler() new_handler must be a function"
            )
        end)
    end)
end)