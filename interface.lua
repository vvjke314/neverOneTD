Interface = {}
local ed = 0
local timer = 0

function Interface.load()
    local font = love.graphics.newFont("assets/enemy-hpbar.ttf")
end


function Interface.update(dt)
    ed = ed + dt
    if ed > 1 then timer = timer + 1; ed = 0 end
    return timer
end

function Interface.draw()
    love.graphics.print(timer, 0, 0)
end

return Interface