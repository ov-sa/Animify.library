----------------------------------------------------------------
--[[ Resource: Animify Library
     Script: handlers: cinemator.lua
     Server: -
     Author: OvileAmriam
     Developer: -
     DOC: 08/09/2021 (OvileAmriam)
     Desc: Cinemator Handler ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    unpack = unpack,
    pairs = pairs,
    ipairs = ipairs,
    tocolor = tocolor,
    addEventHandler = addEventHandler,
    getCursorPosition = getCursorPosition,
    getAbsoluteCursorPosition = getAbsoluteCursorPosition,
    isMouseOnCircularPosition = isMouseOnCircularPosition,
    isKeyOnHold = isKeyOnHold,
    isMouseClicked = isMouseClicked,
    createPed = createPed,
    createObject = createObject,
    removePedClothes = removePedClothes,
    setElementCollidableWith = setElementCollidableWith,
    getElementPosition = getElementPosition,
    setElementPosition = setElementPosition,
    getElementRotation = getElementRotation,
    setElementRotation = setElementRotation,
    getElementBoneRotation = getElementBoneRotation,
    setElementBoneRotation = setElementBoneRotation,
    updateElementRpHAnim = updateElementRpHAnim,
    getScreenFromWorldPosition = getScreenFromWorldPosition,
    processLineOfSight = processLineOfSight,
    dxCreateTexture = dxCreateTexture,
    dxCreateShader = dxCreateShader,
    dxSetShaderValue = dxSetShaderValue,
    dxDrawImage = dxDrawImage,
    engineApplyShaderToWorldTexture = engineApplyShaderToWorldTexture,
    Vector3 = Vector3,
    showChat = showChat,
    getCamera = getCamera,
    setCameraMatrix = setCameraMatrix
}


-------------------
--[[ Variables ]]--
-------------------

local prevMouseKeyClickState = false
local cinemationData = {
    pedData = {
        createdPed = false,
        boneData = false,
        skin = 0,
        position = {1483.508544921875, -1466.627685546875, 40.5234375},
        rotation = 90,
        cameraMatrix = {1480.912963867188, -1466.779541015625, 40.06010055541992, 1481.8369140625, -1466.725463867188, 40.23865585327148, 0, 80}
    },
    boneIndicator = {
        size = 10,
        focussedColor = imports.tocolor(255, 255, 255, 255),
        unfocussedColor = imports.tocolor(255, 255, 255, 10),
        bgPath = imports.dxCreateTexture(":beautify_library/files/assets/images/canvas/circle.rw", "argb", true, "clamp")
    },
    axisRings = {
        x = {
            axisIndex = 1,
            rotationIndex = "x",
            color = {255, 0, 0}
        },
        y = {
            axisIndex = 2,
            rotationIndex = "y",
            color = {0, 255, 0}
        },
        z = {
            axisIndex = 3,
            rotationIndex = "y",
            color = {0, 0, 255}
        }
    }
}


------------------------------------------------
--[[ Functions: Renders Cinemator/Ped-Bones ]]--
------------------------------------------------

local boneRotCache = false

local function renderPedBones()

    if boneRotCache then
        imports.setElementBoneRotation(cinemationData.pedData.createdPed, cinemationData.pedData.boneData.boneID, imports.unpack(boneRotCache))
        imports.updateElementRpHAnim(cinemationData.pedData.createdPed)
    end

end

local function renderCinemator(isFetchingInput, cbArguments)

    if not isFetchingInput then
        local indicatorRadius = cinemationData.boneIndicator.size*0.5
        local _, _, pedRotation = imports.getElementRotation(cinemationData.pedData.createdPed)
        for i, j in imports.pairs(availablePedBones) do
            local isBoneSelected = cinemationData.pedData.boneData and (cinemationData.pedData.boneData.boneID == i)
            local bonePosVector = imports.Vector3(getPedBonePosition(cinemationData.pedData.createdPed, i))
            if isBoneSelected then
                imports.setElementPosition(cinemationData.axisRings.x.object, bonePosVector)
                imports.setElementPosition(cinemationData.axisRings.y.object, bonePosVector)
                imports.setElementPosition(cinemationData.axisRings.z.object, bonePosVector)
                imports.setElementRotation(cinemationData.axisRings.y.object, 0, 0, pedRotation)
                imports.setElementRotation(cinemationData.axisRings.y.object, 0, 90, pedRotation)
                imports.setElementRotation(cinemationData.axisRings.z.object, 90, 0, pedRotation)
            end
            local indicatorX, indicatorY = imports.getScreenFromWorldPosition(bonePosVector)
            if indicatorX and indicatorY then
                if not isBoneSelected and imports.isMouseOnCircularPosition(indicatorX, indicatorY, indicatorRadius) then
                    if prevMouseKeyClickState == "mouse1" then
                        boneRotCache = false
                        cinemationData.pedData.boneData = {
                            boneID = i,
                            axisID = false
                        }
                    end
                end
                indicatorX, indicatorY = indicatorX - indicatorRadius, indicatorY - indicatorRadius
                imports.dxDrawImage(indicatorX, indicatorY, cinemationData.boneIndicator.size, cinemationData.boneIndicator.size, cinemationData.boneIndicator.bgPath, 0, 0, 0, (isBoneSelected and cinemationData.boneIndicator.focussedColor) or cinemationData.boneIndicator.unfocussedColor, false)
            end
        end
        for i, j in imports.ipairs(coreUI.viewportUI.sliders) do
            local _, sliderPercent = beautify.slider.getPercent(j.createdElement)
            if sliderPercent then
                sliderPercent = sliderPercent/100
                if j.sliderType == "ped_rotation" then
                    imports.setElementRotation(cinemationData.pedData.createdPed, 0, 0, sliderPercent*360)
                elseif j.sliderType == "camera_fov" then
                    cinemationData.pedData.cameraMatrix[8] = 40 + (sliderPercent*40)
                end
            end
        end
        imports.showChat(false)
        imports.setCameraMatrix(imports.unpack(cinemationData.pedData.cameraMatrix))
    else
        local isMouseKeyClicked = imports.isMouseClicked()
        local isLMBOnHold = (isMouseKeyClicked ~= "mouse1") and imports.isKeyOnHold("mouse1")
        prevMouseKeyClickState = isMouseKeyClicked
        local focussedAxis = false
        if cinemationData.pedData.boneData then
            if isMouseKeyClicked == "mouse2" then
                boneRotCache = false
                cinemationData.pedData.boneData = false
            else
                if not cinemationData.pedData.boneData.axisID or not isLMBOnHold then
                    local cursorX, cursorY = imports.getAbsoluteCursorPosition()
                    local cameraDistance = imports.Vector3(imports.getElementPosition(imports.getCamera())) - imports.Vector3(imports.getElementPosition(cinemationData.pedData.createdPed))
                    cameraDistance = cameraDistance.length + 1
                    local sightData = {imports.processLineOfSight(imports.Vector3(getWorldFromScreenPosition(cursorX, cursorY, 0)), imports.Vector3(getWorldFromScreenPosition(cursorX, cursorY, cameraDistance)), false, false, false, true, false, false, false, false, cinemationData.pedData.createdPed)}
                    if sightData[1] and sightData[5] then
                        focussedAxis = sightData[5]
                    end
                else
                    if isLMBOnHold then
                        local cursorRelX, cursorRelY = imports.getCursorPosition()
                        if not boneRotCache then
                            --yaw, pitch, roll --TODO: 
                            boneRotCache = {imports.getElementBoneRotation(cinemationData.pedData.createdPed, cinemationData.pedData.boneData.boneID)}
                        end
                        local boneAxisID = cinemationData.axisRings[(cinemationData.pedData.boneData.axisID)].axisIndex
                        boneRotCache[boneAxisID] = (((cinemationData.axisRings[(cinemationData.pedData.boneData.axisID)].rotationIndex == "x") and cursorRelX) or cursorRelY)*360
                    end
                end
            end
        end
        for i, j in imports.pairs(cinemationData.axisRings) do
            if (focussedAxis == j.object) and (cinemationData.pedData.boneData.axisID ~= i) then
                if isMouseKeyClicked == "mouse1" then
                    cinemationData.pedData.boneData.axisID = i
                end
            end
            imports.dxSetShaderValue(j.shader, "axisAlpha", (not cinemationData.pedData.boneData and 0) or (((cinemationData.pedData.boneData and (cinemationData.pedData.boneData.axisID == i)) or (j.object == focussedAxis)) and 1) or 0.05)
        end
    end

end


-----------------------------------------
--[[ Function: Initializes Cinemator ]]--
-----------------------------------------

function initCinemator()

    initModels()
    cinemationData.pedData.createdPed = imports.createPed(cinemationData.pedData.skin, cinemationData.pedData.position[1], cinemationData.pedData.position[2], cinemationData.pedData.position[3], cinemationData.pedData.rotation)
    for i = 0, 17 do
        imports.removePedClothes(cinemationData.pedData.createdPed, i)
    end
    for i, j in imports.pairs(cinemationData.axisRings) do
        j.object = imports.createObject(Animify_Models["axisRing"].modelID, 0, 0, 0)
        imports.setElementCollidableWith(j.object, cinemationData.pedData.createdPed, false)
        j.shader = imports.dxCreateShader(Animify_Shaders["Axisifier"])
        imports.engineApplyShaderToWorldTexture(j.shader, "animify_axis_ring", j.object)
        imports.dxSetShaderValue(j.shader, "axisColor", j.color[1]/255, j.color[2]/255, j.color[3]/255, 1)
        for k, v in imports.pairs(cinemationData.axisRings) do
            if v.object and (j.object ~= v.object) then
                imports.setElementCollidableWith(j.object, v.object, false)
            end
        end
    end
    beautify.render.create(renderCinemator, nil, true)
    beautify.render.create(renderCinemator)
    imports.addEventHandler("onClientPedsProcessed", root, renderPedBones)
    return true

end