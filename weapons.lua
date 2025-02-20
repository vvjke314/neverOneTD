local Weapon = {}

local arrowSizeX, arrowSizeY = 17, 8
local arrowSpeed = 200

Weapon.projectiles = {}  -- Список всех стрел

function Weapon.load() 
    Weapon.image = love.graphics.newImage("assets/weapons.png")
    Weapon.arrowQuad = love.graphics.newQuad(31, 4, arrowSizeX, arrowSizeY, Weapon.image:getDimensions())
end


function Weapon.shoot(x, y, target)
    local dx, dy = target.x - x, target.y - y
    local distance = math.sqrt(dx * dx + dy * dy)

    if distance > 0 then
        local directionX = dx / distance
        local directionY = dy / distance

        table.insert(Weapon.projectiles, {
            x = x,
            y = y,
            dirX = directionX,
            dirY = directionY,
            speed = arrowSpeed,
            target = target
        })
    end
end


function Weapon.update(dt)
    for i = #Weapon.projectiles, 1, -1 do
        local proj = Weapon.projectiles[i]

        proj.x = proj.x + proj.dirX * proj.speed * dt
        proj.y = proj.y + proj.dirY * proj.speed * dt

        -- Проверяем, попала ли стрела в цель
        local dx = proj.target.x - proj.x
        local dy = proj.target.y - proj.y
        local distance = math.sqrt(dx * dx + dy * dy)

        if distance < 5 then  -- Условие попадания (можно менять)
            table.remove(Weapon.projectiles, i)  -- Удаляем стрелу
            proj.target.hp = proj.target.hp - 10  -- Наносим урон врагу
        end
    end
end


function Weapon.draw()
    for _, proj in ipairs(Weapon.projectiles) do
        love.graphics.draw(Weapon.image, Weapon.arrowQuad, proj.x, proj.y, 0, 1, 1)
    end
end

return Weapon