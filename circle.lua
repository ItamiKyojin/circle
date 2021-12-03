function Round(num, digit)
    digit = digit or 0
    local multiplier = 10 ^ digit
    return (math.floor((num * multiplier) + 0.5)) / multiplier
end

function Setblock(x, y, z, block)
    commands.setblock("~" .. x, "~" .. y, "~" .. z, "minecraft:" .. block)
end

local globalCoordsBuffer = {}

function PlaceAndDestroy(coords, block, buffer)
    buffer = buffer or 0
    Setblock(coords[1], coords[2], coords[3], block)
    table.insert(globalCoordsBuffer, 1, coords)
    if table.getn(globalCoordsBuffer) > buffer then
        local removeMe = table.remove(globalCoordsBuffer)
        Setblock(removeMe[1], removeMe[2], removeMe[3], "air")
    end
end

function PlaceAndDestroyList(coordList, block, buffer)
    buffer = buffer or 0
    for _, coords in ipairs(coordList) do
        PlaceAndDestroy(coords, block, buffer)
    end
end

-- 
--[[ while true do
    PlaceAndDestroyList({{0, 3, 0}, {1, 4, 0}, {2, 4, 0}, {3, 5, 0}, {4, 5, 0}, {5, 5, 0}, {6, 5, 0}, {7, 4, 0}, {7, 3, 0}, {7, 2, 0}, {6, 1, 0}, {5, 1, 0}, {4, 1, 0},
    {3, 1, 0}, {2, 2, 0}, {1, 2, 0}, {0, 3, 0}, {-1, 4, 0}, {-2, 4, 0}, {-3, 5, 0}, {-4, 5, 0}, {-5, 5, 0}, {-6, 5, 0}, {-7, 4, 0}, {-7, 3, 0}, {-7, 2, 0}, {-6, 1, 0},
    {-5, 1, 0}, {-4, 1, 0}, {-3, 1, 0}, {-2, 2, 0}, {-1, 2, 0}}, "lapis_block", 5)
end ]]

function PointOnCircle(centerX, centerZ, radius, angle)
    local x = radius * math.cos(math.rad(angle)) + centerX
    local z = radius * math.sin(math.rad(angle)) + centerZ
    return x, z
end

function Main(height, radius, numPoints, buffer)
    -- get list of points on circle
    local centerPoint = {0, 0}
    local points = {}
    for i = 1, numPoints, 1 do
        local x, z = PointOnCircle(centerPoint[1], centerPoint[2], radius, (360/numPoints)*i)
        -- +++ translate (round) to blocks
        table.insert(points, {Round(x), Round(z)})
    end

    -- (get rid of duplicate blocks)

    -- update points to 3d (only when height is set)
    --[[for index, point in ipairs(points) do
        points[index] = {point[1], height, point[2]}
    end

    while true do
        PlaceAndDestroyList(points, "lapis_block", buffer)
    end]]

    while true do
        for _, point in ipairs(points) do
            PlaceAndDestroy({point[1], height, point[2]}, "lapis_block", buffer)
        end
    end
end

local _height = arg[1] + 0
local _radius = arg[2] + 0
local _numPoints = arg[3] + 0
local _buffer = arg[4] + 0
Main(_height, _radius, _numPoints, _buffer)

--[[
    Nice numbers: radius 5; numPoints 28
    Nice numbers: radius 5; numPoints 32
]]