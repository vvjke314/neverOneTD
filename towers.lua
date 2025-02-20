Weapon = require("weapons")
local Towers = {}

local towerSizeX, towerSizeY = 21, 30


Towers.list = {}
local quads = {}



function Towers.load() 
    towerImage = love.graphics.newImage("assets/towers.png")  -- Загружаем спрайт башни
    quads[0] = love.graphics.newQuad(4, 0, towerSizeX, towerSizeY, towerImage:getDimensions())
end

function Towers.add(x, y)
    table.insert(Towers.list, { x = x, y = y, range = 100, fireRate = 1, timer = 0 })
end

function Towers.update(dt, enemies)
    for _, tower in ipairs(Towers.list) do
        tower.timer = tower.timer + dt  -- Считаем время до следующего выстрела

        if tower.timer >= tower.fireRate then
            for _, enemy in ipairs(enemies) do
                local dx = enemy.x - tower.x
                local dy = enemy.y - tower.y
                local distance = math.sqrt(dx * dx + dy * dy)

                if distance <= tower.range then
                    tower.timer = 0  -- Башня стреляет и сбрасывает таймер
                    Weapon.shoot(tower.x, tower.y, enemy)
                    break  -- Стреляем только по одному врагу
                end
            end
        end
    end
end

function Towers.draw()
    for _, tower in ipairs(Towers.list) do
        love.graphics.draw(towerImage, quads[0], tower.x, tower.y)
        love.graphics.circle("line", tower.x + 23, tower.y + 23, tower.range)  -- Радиус атаки
    end
end

return Towers
