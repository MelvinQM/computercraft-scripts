function digLayer()
    turtle.dig()
    turtle.forward()
    turtle.turnRight()

    turtle.dig()
    turtle.forward()
    turtle.turnRight()

    turtle.dig()
    turtle.forward()
end

function isTargetBlock()
    local success, block = turtle.inspectUp()
    if success then
        return block.name == "minecraft:spruce_log" or 
               block.name == "minecraft:spruce_leaves" or
               block.name == "minecraft:jungle_log" or 
               block.name == "minecraft:jungle_leaves"
    end
    return false
end

local moveUp = true

-- Start program

-- Enter tree
turtle.dig()
turtle.forward()

-- Cut tree
while moveUp do
    digLayer()
    turtle.digUp()
    turtle.up()
    turtle.turnRight()
    moveUp = isTargetBlock()
end

-- Move back down until ground is reached
while true do
    local success, block = turtle.inspectDown()
    
    if not success then
        -- No block below (air), meaning it's safe to go down
        turtle.down()
    else
        -- Block detected, likely ground, stop moving down
        break
    end
end
