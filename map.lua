local Map = {}

tileSize = 45
local tiles = {}
local quads = {}

Map.tilemap = {
    {2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2},
    {0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0},
    {0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0},
    {1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 0},
    {0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0},
    {0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0},
    {2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2}
}

function Map.load()
    -- Загрузим тайлы дороги. 0 и 1
    tileset = love.graphics.newImage("assets/Tiles.png")
    -- Загрузим тайлы стенки. 2
    walls = love.graphics.newImage("assets/rocks.png")
    -- Загрузим финишную точку врагов. 3
    finishPoint = love.graphics.newImage("assets/cave.png")

    quads[0] = love.graphics.newQuad(161, 0, tileSize, tileSize, tileset:getDimensions())
    quads[1] = love.graphics.newQuad(128, 112, tileSize, tileSize, tileset:getDimensions())
    quads[2] = love.graphics.newQuad(0, 11, tileSize, tileSize-11, walls:getDimensions())
    quads[3] = love.graphics.newQuad(2, 2, 42, 50, finishPoint:getDimensions())
end

local currX, currY = 0, 0

function Map.draw()
    -- Рисуем первую стенку
    for x = 1, #Map.tilemap[1] do
        love.graphics.draw(walls, quads[2], (x-1)*tileSize, 0)
    end
    -- Рисуем основную карту
    for y = 2, #Map.tilemap-1 do
        for x = 1, #Map.tilemap[y] do
            local tileType = Map.tilemap[y][x]
                love.graphics.draw(tileset, quads[tileType], (x-1) * tileSize, (y-1) * tileSize-11)   
        end
    end
    -- Рисуем вторую стенку
    for x = 1, #Map.tilemap[7] do
        love.graphics.draw(walls, quads[2], (x-1)*tileSize, 6*tileSize-11)
    end

    love.graphics.draw(finishPoint, quads[3], 9*tileSize, 5*tileSize-20)
end

return Map