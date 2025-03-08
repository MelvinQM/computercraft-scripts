local function getInput(prompt)
    io.write(prompt .. ": ")
    return tonumber(io.read())
end

-- Get tunnel dimensions
local width = getInput("Enter tunnel width")
local height = getInput("Enter tunnel height")
local depth = getInput("Enter tunnel depth")

local torchInterval = 5
local minedDepth = 0
local fuelThreshold = 1000

print("Width:" .. width)
print("Height:" .. height)
print("Depth:" .. depth)

function refuelIfNeeded()
    if turtle.getFuelLevel() < fuelThreshold then
        for i = 1, 16 do
            turtle.select(i)
            if turtle.refuel(1) then
                print("Refueled using slot " .. i)
                break
            end
        end
    end
end

function digLayer(width, height, place_torch)
    -- Check inventory before digging
    if isInventoryFull() then
        move_to_chest(minedDepth) -- Return, drop items, and resume
    end

    turtle.dig()
    turtle.forward()

    for i = 1, height do
        turtle.turnRight()
        for j = 1, width - 1 do
            turtle.dig()
            turtle.forward()
        end
        
        if i ~= height then
            turtle.digUp()
            turtle.up()
            turtle.turnRight()
        end
    end

    for i = 1, height - 1 do
        turtle.down()
    end

    if height % 2 ~= 0 then
        turtle.turnRight()
        turtle.turnRight()
        for i = 1, width - 1 do
            turtle.forward()
        end
    end
    
    if place_torch then
        turtle.select(1)
        turtle.placeDown()
    end

    turtle.turnRight()
end

function drop_items()
    for i = 1, 16 do
        local wait = false
        while turtle.getItemCount(i) > 0 do
            turtle.select(i)
            turtle.refuel(64)
            turtle.drop()
        
            if wait then
                sleep(10)
                print("Chest is likely full! Waiting...")
            end
            wait = true
        end
    end
end

function move_to_chest(depth)
    turtle.turnRight()
    turtle.turnRight()
    for i = 1, depth - 1 do
        turtle.forward()
    end
    drop_items()
    return_to_last_position(depth)
end

function return_to_last_position(depth)
    for i = 1, depth - 1 do
        turtle.forward()
    end
    turtle.turnRight()
    turtle.turnRight()
end

function isInventoryFull()
    for i = 1, 16 do
        if turtle.getItemCount(i) == 0 then
            return false -- If there's an empty slot, it's not full
        end
    end
    return true
end

for i = 1, depth do
    minedDepth = i
    refuelIfNeeded()
    if i % torchInterval == 0 then
        digLayer(width, height, true)
    else 
        digLayer(width, height, false)
    end
end

move_to_chest(depth)
