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
    removePedClothes = removePedClothes,
    getAnimFrameCache = getAnimFrameCache,
    createPed = createPed,
    createObject = createObject,
    setElementCollidableWith = setElementCollidableWith,
    getElementPosition = getElementPosition,
    setElementPosition = setElementPosition,
    getElementRotation = getElementRotation,
    setElementRotation = setElementRotation,
    getElementBoneRotation = getElementBoneRotation,
    setElementBoneRotation = setElementBoneRotation,
    getPedBonePosition = getPedBonePosition,
    updateElementRpHAnim = updateElementRpHAnim,
    getScreenFromWorldPosition = getScreenFromWorldPosition,
    getWorldFromScreenPosition = getWorldFromScreenPosition,
    processLineOfSight = processLineOfSight,
    dxCreateTexture = dxCreateTexture,
    dxCreateShader = dxCreateShader,
    dxSetShaderValue = dxSetShaderValue,
    dxDrawImage = dxDrawImage,
    engineApplyShaderToWorldTexture = engineApplyShaderToWorldTexture,
    Vector3 = Vector3,
    setPlayerHudComponentVisible = setPlayerHudComponentVisible,
    showChat = showChat,
    camera = getCamera(),
    setCameraMatrix = setCameraMatrix,
    table = {
        clone = table.clone
    },
    math = {
        sin = math.sin,
        cos = math.cos,
        rad = math.rad
    },
    angle = {
        shortTarget = angle.shortTarget
    },
    string = {
        upper = string.upper
    }
}


-------------------
--[[ Variables ]]--
-------------------

local prevMouseKeyClickState = false
local prevCursorRel = false
local cinemationData = {
    frameData = false,
    isPlayingAnim = false,
    cameraData = {
        fov = 80,
        radius = 3.25,
        position = {0, 0, 0}
    },
    pedData = {
        createdPed = false,
        boneData = false,
        skin = 1,
        position = {1483.508544921875, -1466.627685546875, 40.5234375},
        rotation = 90
    },
    boneIndicator = {
        size = 10,
        focussedColor = imports.tocolor(255, 255, 255, 255),
        unfocussedColor = imports.tocolor(255, 255, 255, 10),
        bgPath = beautify.assets["images"]["canvas/circle.rw"]
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

local function renderPedBones()

    if not cinemationData.frameData or cinemationData.isPlayingAnim then return false end

    for i, j in imports.pairs(cinemationData.frameData["Bones"]) do
        imports.setElementBoneRotation(cinemationData.pedData.createdPed, i, imports.unpack(j))
    end
    imports.updateElementRpHAnim(cinemationData.pedData.createdPed)

end

local function renderCinemator(renderData, cbArguments)

    if renderData.renderType ~= "input" then
        local indicatorRadius = cinemationData.boneIndicator.size*0.5
        local _, _, pedRotation = imports.getElementRotation(cinemationData.pedData.createdPed)
        for i, j in imports.pairs(availablePedBones) do
            local isBoneSelected = cinemationData.pedData.boneData and (cinemationData.pedData.boneData.boneID == i)
            local bonePosVector = imports.Vector3(imports.getPedBonePosition(cinemationData.pedData.createdPed, i))
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
                if cinemationData.frameData and not cinemationData.isPlayingAnim and not isBoneSelected and imports.isMouseOnCircularPosition(indicatorX, indicatorY, indicatorRadius) then
                    if prevMouseKeyClickState == "mouse1" then
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
        for i, j in imports.ipairs(viewportUI.sliders) do
            local _, sliderPercent = beautify.slider.getPercent(j.createdElement)
            if sliderPercent then
                sliderPercent = sliderPercent/100
                if j.sliderType == "ped_rotation" then
                    imports.setElementRotation(cinemationData.pedData.createdPed, 0, 0, sliderPercent*360)
                elseif j.sliderType == "camera_rotation" then
                    cinemationData.cameraData.rotation = imports.math.rad(sliderPercent*360)
                    cinemationData.cameraData.position[1], cinemationData.cameraData.position[2], cinemationData.cameraData.position[3] = cinemationData.pedData.position[1] + (cinemationData.cameraData.radius*imports.math.cos(cinemationData.cameraData.rotation)), cinemationData.pedData.position[2] + (cinemationData.cameraData.radius*imports.math.sin(cinemationData.cameraData.rotation)), cinemationData.pedData.position[3]
                elseif j.sliderType == "camera_fov" then
                    cinemationData.cameraData.fov = 40 + (sliderPercent*40)
                end
            end
        end
        for i, j in imports.ipairs(viewportUI.labels) do
            if not cinemationData.pedData.boneData then
                beautify.setUIVisible(j.createdElement, false)
            else
                if j.labelType == "bone_id" then
                    beautify.label.setText(j.createdElement, j.prefix..cinemationData.pedData.boneData.boneID.." | ("..availablePedBones[(cinemationData.pedData.boneData.boneID)].name..")")
                elseif j.labelType == "axis_id" then
                    beautify.label.setText(j.createdElement, j.prefix..((cinemationData.pedData.boneData.axisID and (imports.string.upper(cinemationData.pedData.boneData.axisID).." Axis")) or "-"))
                end
                beautify.setUIVisible(j.createdElement, true)
            end
        end
        imports.setPlayerHudComponentVisible("all", false)
        imports.showChat(false)
        imports.setCameraMatrix(cinemationData.cameraData.position[1], cinemationData.cameraData.position[2], cinemationData.cameraData.position[3], cinemationData.pedData.position[1], cinemationData.pedData.position[2], cinemationData.pedData.position[3], 0, cinemationData.cameraData.fov)
    else
        local isMouseKeyClicked = imports.isMouseClicked()
        local isLMBOnHold = (isMouseKeyClicked ~= "mouse1") and imports.isKeyOnHold("mouse1")
        prevMouseKeyClickState = isMouseKeyClicked
        local focussedAxis = false
        if cinemationData.frameData and not cinemationData.isPlayingAnim and cinemationData.pedData.boneData then
            if isMouseKeyClicked == "mouse2" then
                cinemationData.pedData.boneData = false
                prevCursorRel = false
            else
                if not cinemationData.pedData.boneData.axisID or not isLMBOnHold then
                    local cursorX, cursorY = imports.getAbsoluteCursorPosition()
                    local cameraDistance = imports.Vector3(imports.getElementPosition(imports.camera)) - imports.Vector3(imports.getElementPosition(cinemationData.pedData.createdPed))
                    cameraDistance = cameraDistance.length + 2
                    local sightData = {imports.processLineOfSight(imports.Vector3(imports.getWorldFromScreenPosition(cursorX, cursorY, 0)), imports.Vector3(imports.getWorldFromScreenPosition(cursorX, cursorY, cameraDistance)), false, false, false, true, false, false, false, false, cinemationData.pedData.createdPed)}
                    if sightData[1] and sightData[5] then
                        focussedAxis = sightData[5]
                    end
                    prevCursorRel = false
                else
                    if isLMBOnHold then
                        local cursorRelX, cursorRelY = imports.getCursorPosition()
                        if not prevCursorRel then
                            prevCursorRel = {cursorRelX, cursorRelY}
                            if not cinemationData.frameData["__EDITOR_CACHE__"] then
                                cinemationData.frameData["__EDITOR_CACHE__"] = {}
                            end
                            if not cinemationData.frameData["__EDITOR_CACHE__"][(cinemationData.pedData.boneData.boneID)] then
                                cinemationData.frameData["__EDITOR_CACHE__"][(cinemationData.pedData.boneData.boneID)] = {imports.getElementBoneRotation(cinemationData.pedData.createdPed, cinemationData.pedData.boneData.boneID)}
                            end
                            if not cinemationData.frameData["Bones"][(cinemationData.pedData.boneData.boneID)] then
                                cinemationData.frameData["Bones"][(cinemationData.pedData.boneData.boneID)] = imports.table.clone(cinemationData.frameData["__EDITOR_CACHE__"][(cinemationData.pedData.boneData.boneID)], false)
                            else
                                cinemationData.frameData["__EDITOR_CACHE__"][(cinemationData.pedData.boneData.boneID)] = imports.table.clone(cinemationData.frameData["Bones"][(cinemationData.pedData.boneData.boneID)], false)
                            end
                        end
                        cursorRelX, cursorRelY = cursorRelX - prevCursorRel[1], cursorRelY - prevCursorRel[2]
                        local boneReference = cinemationData.frameData["Bones"][(cinemationData.pedData.boneData.boneID)]
                        local isBoneAxisIndexModified = availablePedBones[(cinemationData.pedData.boneData.boneID)].axes[(cinemationData.pedData.boneData.axisID)]
                        local boneAxisID = (isBoneAxisIndexModified and cinemationData.axisRings[isBoneAxisIndexModified].axisIndex) or cinemationData.axisRings[(cinemationData.pedData.boneData.axisID)].axisIndex
                        boneReference[boneAxisID] = (cinemationData.frameData["__EDITOR_CACHE__"][(cinemationData.pedData.boneData.boneID)][boneAxisID] + (((cinemationData.axisRings[(cinemationData.pedData.boneData.axisID)].rotationIndex == "x") and cursorRelX) or cursorRelY)*360)%360
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
        --TODO: REMOVE LATER:
        local testBone = 32
        if cinemationData.frameData and cinemationData.frameData["Bones"][testBone] then
            dxDrawText("x = "..cinemationData.frameData["Bones"][testBone][1]..", y = "..cinemationData.frameData["Bones"][testBone][2]..", z = "..cinemationData.frameData["Bones"][testBone][3], 0, 0, 1366, 100, -1, 1, "default-bold", "center", "top", true, false, false, false)
        end
        -----------
    end

end


-----------------------------------------
--[[ Function: Initializes Cinemator ]]--
-----------------------------------------

function initCinemator()

    initModels()
    cinemationData.pedData.createdPed = imports.createPed(cinemationData.pedData.skin, cinemationData.pedData.position[1], cinemationData.pedData.position[2], cinemationData.pedData.position[3], cinemationData.pedData.rotation)
    imports.removePedClothes(cinemationData.pedData.createdPed)
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
    beautify.render.create(renderCinemator)
    beautify.render.create(renderCinemator, {
        renderType = "input"
    })
    imports.addEventHandler("onClientPedsProcessed", root, renderPedBones)
    imports.addEventHandler("onClientUISelectionAltered", coreUI.viewerUI.gridlists.typeReference["view_frames"].createdElement, function(selection)
        cinemationData.pedData.boneData = false
        if selection then
            local selectedAnim, selectedFrame = beautify.gridlist.getSelection(coreUI.viewerUI.gridlists.typeReference["view_animations"].createdElement), beautify.gridlist.getSelection(source)
            if selectedAnim and selectedFrame then
                cinemationData.frameData = imports.getAnimFrameCache(selectedAnim, selectedFrame)
                return true
            end
        end
        cinemationData.frameData = false
    end)
    return true

end



---TODO: EXPERIMENTAL---
function playAnim()

    local selectedAnim = beautify.gridlist.getSelection(coreUI.viewerUI.gridlists.typeReference["view_animations"].createdElement)
    local animCache = getAnimCache(selectedAnim)
    if not animCache or (#animCache["Frames"] <= 0) then return false end

    cinemationData.pedData.boneData = false
    cinemationData.isPlayingAnim = {
        animCache = animCache,
        currentFrame = 1,
        duration = 250,
        tickCounter = CLIENT_CURRENT_TICK
    }

end

imports.addEventHandler("onClientPedsProcessed", root, function()

    if not cinemationData.isPlayingAnim then return false end

    local selectedAnim = beautify.gridlist.getSelection(coreUI.viewerUI.gridlists.typeReference["view_animations"].createdElement)
    local animCache = getAnimCache(selectedAnim)
    if not animCache or (#animCache["Frames"] <= 0) then return false end

    local currentFrameReference = animCache["Frames"][(cinemationData.isPlayingAnim.currentFrame)]
    local nextFrameReference = animCache["Frames"][(cinemationData.isPlayingAnim.currentFrame + 1)]
    if not currentFrameReference or not nextFrameReference then
        cinemationData.isPlayingAnim = false
        return false
    end

    cinemationData.isPlayingAnim.interpolationProgress = getInterpolationProgress(cinemationData.isPlayingAnim.tickCounter, cinemationData.isPlayingAnim.duration)
    for i, j in pairs(availablePedBones) do
        local currentDefaultRot = {imports.getElementBoneRotation(cinemationData.pedData.createdPed, i)}
        local prevBoneRot, nextBoneRot = currentFrameReference["Bones"][i], nextFrameReference["Bones"][i]
        if prevBoneRot and nextBoneRot then
            nextBoneRot[1] = imports.angle.shortTarget(prevBoneRot[1], nextBoneRot[1])
            nextBoneRot[2] = imports.angle.shortTarget(prevBoneRot[2], nextBoneRot[2])
            nextBoneRot[3] = imports.angle.shortTarget(prevBoneRot[3], nextBoneRot[3])
            local rotX, rotY, rotZ = interpolateBetween(prevBoneRot[1], prevBoneRot[2], prevBoneRot[3], nextBoneRot[1], nextBoneRot[2], nextBoneRot[3], cinemationData.isPlayingAnim.interpolationProgress, "Linear")
            imports.setElementBoneRotation(cinemationData.pedData.createdPed, i, rotX, rotY, rotZ)
        end
    end
    if cinemationData.isPlayingAnim.interpolationProgress >= 1 then
        cinemationData.isPlayingAnim.currentFrame = cinemationData.isPlayingAnim.currentFrame + 1
        cinemationData.isPlayingAnim.tickCounter = CLIENT_CURRENT_TICK
    end
    imports.updateElementRpHAnim(cinemationData.pedData.createdPed)

end)
bindKey("z", "down", function() playAnim() end)