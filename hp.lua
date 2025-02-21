local HP = {}
HpList = {}

function HP.load()
    HPfont = love.graphics.newFont("assets/enemy-hpbar.ttf", 8)
end


function HP.add(hp, enemyX, enemyY)
    table.insert(HpList,
    {
        hp = 100,
        text = hp .. "/100",
        x = enemyX - 3,
        y = enemyY - 10
    })
end

function HP.update(i, enemy)
    HpList[i].hp = enemy.hp
    HpList[i].x = enemy.x - 3
    HpList[i].y = enemy.y - 10
    HpList[i].text = enemy.hp .. "/100"
end

function HP.draw()
    for _, bar in ipairs(HpList) do
        love.graphics.setColor(255, 0, 0)
        love.graphics.print(bar.text, HPfont, bar.x, bar.y)
        love.graphics.setColor(255, 255, 255)
    end 
end

return HP