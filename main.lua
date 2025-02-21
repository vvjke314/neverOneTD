local Map = require("map")
local Enemy = require("enemy")
local Towers = require("towers")
local Interface = require("interface")
local timer = 0

function love.load()
    love.window.setTitle("neverOneTD")
    love.window.setMode(1020, 800, {resizable = true})
    Map.load()
    Enemy.load()
    Towers.load()
    Weapon.load()
    Interface.load()
    enemyTimer = 0
end


function love.update(dt)
    enemyTimer = enemyTimer + dt
    if enemyTimer > 3 then
        Enemy.spawn()
        enemyTimer = 0
    end
    timer = Interface.update(dt)
    Enemy.update(dt, timer)
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
    Interface.draw()
    love.graphics.pop()
end

function love.mousepressed(x, y, button)
    if button == 1 then  -- Левая кнопка мыши
        local tileType, tileX, tileY = getTileAt(x, y)

        if tileType == 0 then  -- Проверяем, что тайл — трава
            -- Центрим расположение башни
            local centerX = (tileX - 1) * tileSize + tileSize/2 - 15
            local centerY = (tileY - 1) * tileSize + tileSize/2 - 21

            Towers.add(centerX, centerY)  -- Добавляем башню
        end
    end


    if button == 2 then -- Правая кнопка мыши
        local tileType, tileX, tileY = getTileAt(x, y)
        if tileType == 0 then  -- Проверяем, что тайл — трава
            -- Получаем центры башни
            local centerX = (tileX - 1) * tileSize + tileSize/2 - 15
            local centerY = (tileY - 1) * tileSize + tileSize/2 - 21

            local number = Towers.getTower(centerX, centerY)
            if number then
                Towers.remove(number)
            end
        end
    end
end

-- Получаем тип и координаты тайла на который кликнули
function getTileAt(x, y)
    x = x / 3 -- Уменьшаем зум в пискелях
    y = y / 3
    local tileX = math.floor(x / tileSize) + 1
    local tileY = math.floor(y / tileSize) + 1

    -- Если такой тайл существует то возвращаем результат
    if Map.tilemap[tileY] and Map.tilemap[tileY][tileX] then
        return Map.tilemap[tileY][tileX], tileX, tileY
    end

    return nil  -- Если кликнули за пределами карты
end

