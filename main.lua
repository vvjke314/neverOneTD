local Map = require("map")
local Enemy = require("enemy")
local Towers = require("towers")

function love.load()
    love.window.setTitle("neverOneTD")
    love.window.setMode(1020, 800, {resizable = true})
    Map.load()
    Enemy.load()
    Towers.load()
    Weapon.load()
    enemyTimer = 0
end


function love.update(dt)
    enemyTimer = enemyTimer + dt
    if enemyTimer > 3 then
        Enemy.spawn()
        enemyTimer = 0
    end
    Enemy.update(dt)
    Towers.update(dt, enemies)
    Weapon.update(dt)
end

local scale = 3  -- Увеличение в 2 раза

function love.draw()
    love.graphics.push()
    love.graphics.scale(scale, scale)  -- Увеличиваем всё
    Map.draw()
    Towers.draw()    
    Enemy.draw()
    Weapon.draw()
    love.graphics.pop()
end

function love.mousepressed(x, y, button)
    if button == 1 then  -- Левая кнопка мыши
        local tileType, tileX, tileY = getTileAt(x, y)

        if tileType == 0 then  -- Проверяем, что тайл — трава
            local centerX = (tileX - 1) * tileSize + tileSize/2 - 15
            local centerY = (tileY - 1) * tileSize + tileSize/2 - 10

            Towers.add(centerX, centerY)  -- Добавляем башню
        end
    end
end


function getTileAt(x, y)
    x = x / 3
    y = y / 3
    local tileX = math.floor(x / tileSize) + 1
    local tileY = math.floor(y / tileSize) + 1

    if Map.tilemap[tileY] and Map.tilemap[tileY][tileX] then
        return Map.tilemap[tileY][tileX], tileX, tileY
    end

    return nil  -- Если кликнули за пределами карты
end

