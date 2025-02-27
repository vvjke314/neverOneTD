local Enemy = {}

local tileSize = 45
local enemySize = 30
local enemySpeed = 50
enemies = {}
local enemySprite = {}
local quad = {}
local HP = require("hp")
-- Счетчик количества врагов
local counter = 0


local path = {
    {{0, 2}, {1,2}, {2,2}, {3,2}, {4,2}, {4,1}, {4, 0}, {5, 0}, {6, 0}, {7, 0}, {8,0}, {9,0}, {9, 1}, {9, 2}, {9, 3}, {9, 4}},
    {{0, 2}, {1,2}, {2,2}, {3,2}, {4,2}, {4,3}, {4, 4}, {5, 4}, {6, 4}, {7, 4}, {8,4}, {9,4}}
}

function Enemy.load()
    -- Загружаем спрайт сет врагов
    enemySprite = love.graphics.newImage("assets/orc-run.png")  -- Загружаем спрайт врага

    -- Загружаем анимацию бега оппонента
    quad[0] = love.graphics.newQuad(23, 32, enemySize, enemySize, enemySprite:getDimensions())
    quad[1] = love.graphics.newQuad(85, 32, enemySize, enemySize, enemySprite:getDimensions())
    quad[2] = love.graphics.newQuad(149, 32, enemySize, enemySize, enemySprite:getDimensions())

    -- Загружаем шрифт полоски здоровья
    HP.load()
end

-- Генерируем врагов
function Enemy.spawn()
    -- Увеличиваем счетчик количества врагов
    counter = counter + 1
    -- Инициализируем врага
    local enemy = {
        -- Номер врага
        number = counter,
        x = path[counter%2+1][1][1] * tileSize,  -- Начальная позиция (в пикселях)
        y = (path[counter%2+1][1][2]+1) * tileSize,
        targetIndex = 2,  -- Следующая точка маршрута
        speed = enemySpeed,
        state = 0, -- Состояние для отрисовки спрайта
        timer = 0,
        hp = 100,
    }
    -- Генерируем полоску здоровья
    HP.add(enemy.hp, enemy.x, enemy.y)
    table.insert(enemies, enemy)
end


local prevBuffTime = 10
-- Обновляем врагов (двигаем их)
function Enemy.update(dt, timer)
    for i, enemy in ipairs(enemies) do
        -- Удаляем врагов
        if enemy.hp < 1 then  -- Закончилось здоровье
            table.remove(enemies, i)
            -- Убираем полоску здоровья
            table.remove(HpList, i)
        else 
            -- Обновляем полоску здоровья
            HP.update(i, enemy)
        end

        enemy.timer = enemy.timer + dt
        local target = path[enemy.number%2+1][enemy.targetIndex]  -- Берём следующую точку пути
        if target then
            local targetX = target[1] * tileSize
            local targetY = (target[2] + 1) * tileSize

            -- Усиливаем врагов
            if timer - prevBuffTime > 0 then enemySpeed = enemySpeed*1.1; enemy.speed = enemySpeed; prevBuffTime = prevBuffTime*2 end

            -- Рассчитываем направление движения
            local dx, dy = targetX - enemy.x, targetY - enemy.y
            local distance = math.sqrt(dx * dx + dy * dy)

            -- Меняем анимацию движения
            if enemy.timer > 0.25 then
                enemy.state = enemy.state + 1
                if enemy.state > 2 then enemy.state = 0 end
                enemy.timer = 0
            end

            if distance > 0 then
                -- Перемещаем врага к точке
                enemy.x = enemy.x + (dx / distance) * enemy.speed * dt
                enemy.y = enemy.y + (dy / distance) * enemy.speed * dt
               
                -- Если враг почти достиг точки, переключаемся на следующую
                if distance < 1 then
                    if path[enemy.number%2+1][enemy.targetIndex][1] == 9 and path[enemy.number%2+1][enemy.targetIndex][2] == 4 then -- Враги добежали до финиша  
                        table.remove(enemies, i)
                        -- Убираем полоску здоровья
                        table.remove(HpList, i) 
                    end
                    enemy.targetIndex = enemy.targetIndex + 1
                end
            end
        end
    end
end


-- Отрисовка врагов
function Enemy.draw()
    for _, enemy in ipairs(enemies) do
        love.graphics.draw(enemySprite, quad[enemy.state], enemy.x, enemy.y)
    end
    HP.draw()
end


return Enemy