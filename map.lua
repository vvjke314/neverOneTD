local Map = {}

tileSize = 45
local tiles = {}
local quads = {}

Map.tilemap = {
    {0, 0, 0, 0, 1, 1, 1, 1, 1, 1},
    {0, 0, 0, 0, 1, 0, 0, 0, 0, 1},
    {1, 1, 1, 1, 1, 0, 0, 0, 0, 1},
    {0, 0, 0, 0, 1, 0, 0, 0, 0, 1},
    {0, 0, 0, 0, 1, 1, 1, 1, 1, 1}
}

function Map.load()
    tileset = love.graphics.newImage("assets/Tiles.png")

    quads[0] = love.graphics.newQuad(161, 0, tileSize, tileSize, tileset:getDimensions())
    quads[1] = love.graphics.newQuad(128, 112, tileSize, tileSize, tileset:getDimensions())
end

function Map.draw()
    for y = 1, #Map.tilemap do
        for x = 1, #Map.tilemap[y] do
            local tileType = Map.tilemap[y][x]
            love.graphics.draw(tileset, quads[tileType], (x-1) * tileSize, (y-1) * tileSize)
        end
    end
end

return Map