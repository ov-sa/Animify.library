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
        selectedBone = false,
        skin = 0,
        position = {1483.508544921875, -1466.627685546875, 40.5234375},
        rotation = 90,
        cameraMatrix = {1480.912963867188, -1466.779541015625, 40.06010055541992, 1481.8369140625, -1466.725463867188, 40.23865585327148, 0, 80}
    },
    boneIndicator = {
        size = 10,
        focussedColor = tocolor(255, 255, 255, 255),
        unfocussedColor = tocolor(255, 255, 255, 10),
        bgPath = dxCreateTexture(":beautify_library/files/assets/images/canvas/circle.rw", "argb", true, "clamp")
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


-------------------------------------
--[[ Function: Renders Cinemator ]]--
-------------------------------------

local function renderCinemator()

    local _, _, pedRotation = getElementRotation(cinemationData.pedData.createdPed)
    for i, j in pairs(availablePedBones) do
        local isBoneSelected = (cinemationData.pedData.selectedBone == i)
        local bone_posVector = Vector3(getPedBonePosition(cinemationData.pedData.createdPed, i))
        if isBoneSelected then
            setElementPosition(cinemationData.axisRings.x.object, bone_posVector)
            setElementPosition(cinemationData.axisRings.y.object, bone_posVector)
            setElementPosition(cinemationData.axisRings.z.object, bone_posVector)
            setElementRotation(cinemationData.axisRings.y.object, 0, 0, pedRotation)
            setElementRotation(cinemationData.axisRings.y.object, 0, 90, pedRotation)
            setElementRotation(cinemationData.axisRings.z.object, 90, 0, pedRotation)
        end
        local x, y = getScreenFromWorldPosition(bone_posVector)
        if x and y then
            dxDrawImage(x - (cinemationData.boneIndicator.size*0.5), y - (cinemationData.boneIndicator.size*0.5), cinemationData.boneIndicator.size, cinemationData.boneIndicator.size, cinemationData.boneIndicator.bgPath, 0, 0, 0, (isBoneSelected and cinemationData.boneIndicator.focussedColor) or cinemationData.boneIndicator.unfocussedColor, false)
        end
    end

    local focussedAxis = false
    if isCursorShowing() and cinemationData.pedData.selectedBone and not cinemationData.pedData.selectedBone.selectedAxis then
        local cursorX, cursorY = getCursorPosition()
        local sightData = {processLineOfSight(Vector3(getWorldFromScreenPosition(cursorX*CLIENT_MTA_RESOLUTION[1], cursorY*CLIENT_MTA_RESOLUTION[2], 0)), Vector3(getWorldFromScreenPosition(cursorX*CLIENT_MTA_RESOLUTION[1], cursorY*CLIENT_MTA_RESOLUTION[2], 5)), false, false, false, true, false, false, false, false, cinemationData.pedData.createdPed)}
        if sightData[1] and sightData[5] then
            focussedAxis = sightData[5]
        end
    end
    for i, j in pairs(cinemationData.axisRings) do
        dxSetShaderValue(j.shader, "axisAlpha", ((j.object == focussedAxis) and 1) or 0.05)
    end

    showChat(false)
    setCameraMatrix(unpack(cinemationData.pedData.cameraMatrix))
    for i, j in ipairs(coreUI.viewportUI.sliders) do
        local _, sliderPercent = beautify.slider.getPercent(j.createdElement)
        if sliderPercent then
            sliderPercent = sliderPercent/100
            if j.sliderType == "ped_rotation" then
                setElementRotation(cinemationData.pedData.createdPed, 0, 0, sliderPercent*360)
            elseif j.sliderType == "camera_fov" then
                cinemationData.pedData.cameraMatrix[8] = 40 + (sliderPercent*40)
            end
        end
    end

end


-----------------------------------------
--[[ Function: Initializes Cinemator ]]--
-----------------------------------------

function initCinemator()

    initModels()
    cinemationData.pedData.createdPed = createPed(cinemationData.pedData.skin, cinemationData.pedData.position[1], cinemationData.pedData.position[2], cinemationData.pedData.position[3], cinemationData.pedData.rotation)
    for i = 0, 17 do
        removePedClothes(cinemationData.pedData.createdPed, i)
    end

    for i, j in pairs(cinemationData.axisRings) do
        j.object = createObject(Animify_Models["axisRing"].modelID, 0, 0, 0)
        setElementCollidableWith(j.object, cinemationData.pedData.createdPed, false)
        j.shader = dxCreateShader(Animify_Shaders["Axisifier"])
        engineApplyShaderToWorldTexture(j.shader, "animify_axis_ring", j.object)
        dxSetShaderValue(j.shader, "axisColor", j.color[1]/255, j.color[2]/255, j.color[3]/255, 1)
        for k, v in pairs(cinemationData.axisRings) do
            if j.object ~= v.object then
                setElementCollidableWith(j.object, v.object, false)
            end
        end
    end
    beautify.render.create(renderCinemator)
    return true

end
