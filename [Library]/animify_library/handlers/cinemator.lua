----------------------------------------------------------------
--[[ Resource: Animify Library
     Script: handlers: cinemator.lua
     Server: -
     Author: OvileAmriam
     Developer: -
     DOC: 08/09/2021 (OvileAmriam)
     Desc: Cinemator Handler ]]--
----------------------------------------------------------------


-------------------
--[[ Variables ]]--
-------------------

local cinemationData = {
    pedData = {
        createdPed = false,
        createdPedDisc = false,
        skin = 0,
        position = {1483.508544921875, -1466.627685546875, 40.5234375},
        rotation = 90,
        cameraMatrix = {1480.912963867188, -1466.779541015625, 40.06010055541992, 1481.8369140625, -1466.725463867188, 40.23865585327148, 0, 90}
    },
    axisRings = {
        x = {
            color = {255, 0, 0}
        },
        y = {
            color = {0, 255, 0}
        },
        z = {
            color = {0, 0, 255}
        }
    }
}


-----------------------------------------
--[[ Function: Initializes Cinemator ]]--
-----------------------------------------

function initCinemator()

    initModels()
    cinemationData.pedData.createdPed = createPed(cinemationData.pedData.skin, cinemationData.pedData.position[1], cinemationData.pedData.position[2], cinemationData.pedData.position[3], cinemationData.pedData.rotation)

    cinemationData.pedData.createdPedDisc = createObject(Animify_Models["spawnDisc"].modelID, 0, 0, 0)
    discShader = dxCreateShader(Animify_Shaders["Axisifier"])
    engineApplyShaderToWorldTexture(discShader, "ring", cinemationData.pedData.createdPedDisc)
    dxSetShaderValue(discShader, "axisColor", 5/255, 5/255, 5/255, 1)
    setElementCollidableWith(cinemationData.pedData.createdPedDisc, cinemationData.pedData.createdPed, false)

    for i, j in pairs(cinemationData.axisRings) do
        j.object = createObject(Animify_Models["axisRing"].modelID, 0, 0, 0)
        setElementCollidableWith(j.object, cinemationData.pedData.createdPed, false)
        j.shader = dxCreateShader(Animify_Shaders["Axisifier"])
        engineApplyShaderToWorldTexture(j.shader, "animify_axis_ring", j.object)
        dxSetShaderValue(j.shader, "axisColor", j.color[1]/255, j.color[2]/255, j.color[3]/255, 1)
        
    end
    for i, j in pairs(cinemationData.axisRings) do
        for k, v in pairs(cinemationData.axisRings) do
            if j.object ~= v.object then
                setElementCollidableWith(j.object, v.object, false)
            end
        end
    end

    setCameraMatrix(unpack(cinemationData.pedData.cameraMatrix))

end

local circleTexture = dxCreateTexture(":beautify_library/files/assets/images/canvas/circle.rw", "argb", true, "clamp")

local function isCoordWithinCircle(x, y, cx, cy, cr)



end

beautify.render.create(function()

    if not cinemationData.pedData.createdPed then return false end

    local _, _, pedRotation = getElementRotation(cinemationData.pedData.createdPed)
    for i, j in pairs(availablePedBones) do
        local bone_posVector = Vector3(getPedBonePosition(cinemationData.pedData.createdPed, i))
        if i == 24 then
            setElementPosition(cinemationData.axisRings.x.object, bone_posVector)
            setElementPosition(cinemationData.axisRings.y.object, bone_posVector)
            setElementPosition(cinemationData.axisRings.z.object, bone_posVector)
            setElementRotation(cinemationData.axisRings.y.object, 0, 0, pedRotation)
            setElementRotation(cinemationData.axisRings.y.object, 0, 90, pedRotation)
            setElementRotation(cinemationData.axisRings.z.object, 90, 0, pedRotation)
        end
        local x, y = getScreenFromWorldPosition(bone_posVector)
        if x and y then
            local size = 10
            if i == 24 then
                dxDrawImage(x - (size*0.5), y - (size*0.5), size, size, circleTexture, 0, 0, 0, -1, false)
            else
                dxDrawImage(x - (size*0.5), y - (size*0.5), size, size, circleTexture, 0, 0, 0, tocolor(255, 255, 255, 10), false)
            end
            --dxDrawRectangle(x - (size*0.5), y - (size*0.5), size, size, tocolor(0, 0, 0, 255), false)
        end
    end

    local pedPosition = {getElementPosition(cinemationData.pedData.createdPed)}
    setElementPosition(cinemationData.pedData.createdPedDisc, pedPosition[1], pedPosition[2], pedPosition[3] - 1)

    if getKeyState("lctrl") then
        pedRotation = (pedRotation + 1)
    elseif getKeyState("rctrl") then
        pedRotation = (pedRotation - 1)
    end
    pedRotation = pedRotation%360
    setElementRotation(cinemationData.pedData.createdPed, 0, 0, pedRotation)
    setElementRotation(cinemationData.pedData.createdPedDisc, 0, 0, pedRotation)

    local focussedAxis = false
    if isCursorShowing() then
        local cursorX, cursorY = getCursorPosition()
        local sightData = {processLineOfSight(Vector3(getWorldFromScreenPosition(cursorX*CLIENT_MTA_RESOLUTION[1], cursorY*CLIENT_MTA_RESOLUTION[2], 0)), Vector3(getWorldFromScreenPosition(cursorX*CLIENT_MTA_RESOLUTION[1], cursorY*CLIENT_MTA_RESOLUTION[2], 5)), false, false, false, true, false, false, false, false, cinemationData.pedData.createdPed)}
        if sightData[1] and sightData[5] then
            focussedAxis = sightData[5]
        end
    end
    for i, j in pairs(cinemationData.axisRings) do
        dxSetShaderValue(j.shader, "axisAlpha", ((j.object == focussedAxis) and 1) or 0.05)
    end

end)