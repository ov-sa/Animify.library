----------------------------------------------------------------
--[[ Resource: Animify Library
     Script: gui: coreUI.lua
     Server: -
     Author: OvileAmriam
     Developer: -
     DOC: 08/09/2021 (OvileAmriam)
     Desc: Core UI ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    pairs = pairs,
    ipairs = ipairs,
    tocolor = tocolor,
    destroyElement = destroyElement,
    addEventHandler = addEventHandler,
    isMouseOnPosition = isMouseOnPosition,
    isMouseClicked = isMouseClicked,
    getInterpolationProgress = getInterpolationProgress,
    interpolateBetween = interpolateBetween,
    selectCoreOption = selectCoreOption,
    updateFrameView = updateFrameView,
    dxCreateFont = dxCreateFont,
    dxCreateRenderTarget = dxCreateRenderTarget,
    dxSetRenderTarget = dxSetRenderTarget,
    dxSetBlendMode = dxSetBlendMode,
    dxCreateTexture = dxCreateTexture,
    dxDrawRectangle = dxDrawRectangle,
    dxDrawImage = dxDrawImage,
    dxDrawText = dxDrawText,
    dxGetTexturePixels = dxGetTexturePixels,
    showCursor = showCursor,
    table = {
        insert = table.insert,
        clone = table.clone
    },
    math = {
        max = math.max
    }
}


-------------------
--[[ Variables ]]--
-------------------

coreUI = {

    optionsUI = {
        startX = CLIENT_MTA_RESOLUTION[1] - 5, startY = 0,
        width = 42, height = 375,
        color = imports.tocolor(0, 0, 0, 255),
        renderTexture = false,
        options = {
            marginY = 30,
            size = 25,
            color = {255, 255, 255, 255},
            hoverAnimDuration = 1250,
            selectedOption = false,
            {
                optionType = "create",
                iconPath = imports.dxCreateTexture("files/assets/images/icons/create.png", "argb", true, "clamp"),
                optBinds = {
                    title = "S  E  L  E  C  T    T  A  S  K",
                    {
                        title = "C R E A T E  F R A M E",
                        mandatorySelection = "view_animations",
                        execFunction = function()
                            local selectedAnim = beautify.gridlist.getSelection(coreUI.viewerUI.gridlists.typeReference["view_animations"].createdElement)
                            if selectedAnim then
                                local frameIndex = addAnimFrame(selectedAnim)
                                if frameIndex then
                                    local rowIndex = beautify.gridlist.addRow(coreUI.viewerUI.gridlists.typeReference["view_frames"].createdElement)
                                    beautify.gridlist.setRowData(coreUI.viewerUI.gridlists.typeReference["view_frames"].createdElement, rowIndex, 1, coreUI.viewerUI.gridlists.typeReference["view_frames"].prefix..frameIndex)
                                end
                            end
                            destroyOptUI()
                            imports.selectCoreOption(false)
                        end
                    },
                    {
                        title = "C R E A T E  A N I M A T I O N",
                        execFunction = function()
                            local animIndex = createAnimCache()
                            if animIndex then
                                local rowIndex = beautify.gridlist.addRow(coreUI.viewerUI.gridlists.typeReference["view_animations"].createdElement)
                                beautify.gridlist.setRowData(coreUI.viewerUI.gridlists.typeReference["view_animations"].createdElement, rowIndex, 1, coreUI.viewerUI.gridlists.typeReference["view_animations"].prefix..animIndex)
                            end
                            destroyOptUI()
                            imports.selectCoreOption(false)
                        end
                    },
                    {
                        title = "C A N C E L",
                        execFunction = function()
                            destroyOptUI()
                            imports.selectCoreOption(false)
                        end
                    }
                }
            },
            {
                optionType = "edit",
                iconPath = imports.dxCreateTexture("files/assets/images/icons/edit.png", "argb", true, "clamp"),
                mandatorySelection = "view_frames",
                optBinds = {
                    title = "E  D  I  T    F  R  A  M  E",
                    {
                        title = "C O N F I R M"
                    },
                    {
                        title = "R E J E C T",
                        execFunction = function()
                            destroyOptUI()
                            imports.selectCoreOption(false)
                        end
                    }
                }
            },
            {
                optionType = "delete",
                iconPath = imports.dxCreateTexture("files/assets/images/icons/delete.png", "argb", true, "clamp"),
                optBinds = {
                    title = "S  E  L  E  C  T    T  A  S  K",
                    {
                        title = "D E L E T E  F R A M E",
                        mandatorySelection = "view_frames",
                    },
                    {
                        title = "D E L E T E  A N I M A T I O N",
                        mandatorySelection = "view_animations",
                        execFunction = function()
                            destroyOptUI()
                            imports.selectCoreOption(false)
                        end
                    },
                    {
                        title = "C A N C E L",
                        execFunction = function()
                            destroyOptUI()
                            imports.selectCoreOption(false)
                        end
                    }
                }
            },
            {
                optionType = "import",
                iconPath = imports.dxCreateTexture("files/assets/images/icons/import.png", "argb", true, "clamp")
            },
            {
                text = "EXPORT",
                optionType = "export",
                iconPath = imports.dxCreateTexture("files/assets/images/icons/export.png", "argb", true, "clamp")
            }
        }
    },

    viewerUI = {
        borderPadding = 10,
        startX = 3, startY = 0,
        width = 230, height = 580,
        gridlists = {
            paddingY = 5,
            typeReference = {},
            {
                title = "F R A M E  -  I D",
                prefix = "FRAME #",
                gridType = "view_frames"
            },
            {
                title = "A N I M  -  I D",
                prefix = "ANIM #",
                gridType = "view_animations"
            }
        }
    }

}


-----------------------------------
--[[ Function: Creates Core UI ]]--
-----------------------------------

function createCoreUI()

    -->> Options UI <<--
    coreUI.optionsUI.startX, coreUI.optionsUI.startY = coreUI.optionsUI.startX - coreUI.optionsUI.width, viewportUI.labels.__endY + coreUI.optionsUI.startY
    local option_paddingX, options_paddingY = (coreUI.optionsUI.width - coreUI.optionsUI.options.size)*0.5, ((coreUI.optionsUI.height - coreUI.optionsUI.options.marginY) - (#coreUI.optionsUI.options*coreUI.optionsUI.options.size))/(#coreUI.optionsUI.options + 1)
    for i, j in imports.ipairs(coreUI.optionsUI.options) do
        j.startX = option_paddingX
        j.startY = (coreUI.optionsUI.options.marginY*0.5) + ((coreUI.optionsUI.options.size + options_paddingY)*(i - 1)) + options_paddingY
        j["__UI_CACHE__"] = {
            animAlphaPercent = 0.25,
            hoverStatus = "backward",
            hoverAnimTickCounter = CLIENT_CURRENT_TICK
        }
    end
    beautify.render.create(function()
        if not coreUI.optionsUI.renderTexture then
            if not coreUI.optionsUI.renderTarget then
                coreUI.optionsUI.renderTarget = imports.dxCreateRenderTarget(coreUI.optionsUI.width, coreUI.optionsUI.height, true)
            end
            imports.dxSetRenderTarget(coreUI.optionsUI.renderTarget, true)
            imports.dxSetBlendMode("modulate_add")
            imports.dxDrawImage(0, 0, coreUI.optionsUI.width, coreUI.optionsUI.width, beautify.assets["images"]["curved_square/regular/left.rw"], 90, 0, 0, -1, false)
            imports.dxDrawRectangle(0, coreUI.optionsUI.width, coreUI.optionsUI.width, coreUI.optionsUI.height - (coreUI.optionsUI.width*2), -1, false)
            imports.dxDrawImage(0, coreUI.optionsUI.height - coreUI.optionsUI.width, coreUI.optionsUI.width, coreUI.optionsUI.width, beautify.assets["images"]["curved_square/regular/left.rw"], -90, 0, 0, -1, false)
            imports.dxSetRenderTarget()
            local renderPixels = imports.dxGetTexturePixels(coreUI.optionsUI.renderTarget)
            if renderPixels then
                coreUI.optionsUI.renderTexture = imports.dxCreateTexture(renderPixels, "argb", false, "clamp")
                imports.destroyElement(coreUI.optionsUI.renderTarget)
                coreUI.optionsUI.renderTarget = nil
            end
        end
        if coreUI.optionsUI.renderTexture then
            imports.dxDrawImage(coreUI.optionsUI.startX, coreUI.optionsUI.startY, coreUI.optionsUI.width, coreUI.optionsUI.height, coreUI.optionsUI.renderTexture, 0, 0, 0, coreUI.optionsUI.color, false)
            coreUI.optionsUI.options.hoveredOption = false
            for i, j in imports.ipairs(coreUI.optionsUI.options) do                
                local option_startX, option_startY = coreUI.optionsUI.startX + j.startX, coreUI.optionsUI.startY + j.startY
                local isOptionSelected = coreUI.optionsUI.options.selectedOption == i
                local isOptionHovered = imports.isMouseOnPosition(option_startX, option_startY, coreUI.optionsUI.options.size, coreUI.optionsUI.options.size)
                if isOptionSelected or isOptionHovered then
                    if isOptionHovered then
                        coreUI.optionsUI.options.hoveredOption = i
                    end
                    if j["__UI_CACHE__"].hoverStatus ~= "forward" then
                        j["__UI_CACHE__"].hoverStatus = "forward"
                        j["__UI_CACHE__"].hoverAnimTickCounter = CLIENT_CURRENT_TICK
                    end
                else
                    if j["__UI_CACHE__"].hoverStatus ~= "backward" then
                        j["__UI_CACHE__"].hoverStatus = "backward"
                        j["__UI_CACHE__"].hoverAnimTickCounter = CLIENT_CURRENT_TICK
                    end
                end
                j["__UI_CACHE__"].interpolationProgress = imports.getInterpolationProgress(j["__UI_CACHE__"].hoverAnimTickCounter, coreUI.optionsUI.options.hoverAnimDuration)
                if (j["__UI_CACHE__"].interpolationProgress < 1) or CLIENT_MTA_RESTORED then
                    if j["__UI_CACHE__"].hoverStatus == "forward" then
                        j["__UI_CACHE__"].animAlphaPercent = imports.interpolateBetween(j["__UI_CACHE__"].animAlphaPercent, 0, 0, 1, 0, 0, j["__UI_CACHE__"].interpolationProgress, "InQuad")
                    else
                        j["__UI_CACHE__"].animAlphaPercent = imports.interpolateBetween(j["__UI_CACHE__"].animAlphaPercent, 0, 0, 0.25, 0, 0, j["__UI_CACHE__"].interpolationProgress, "InQuad")
                    end
                end
                imports.dxDrawImage(option_startX, option_startY, coreUI.optionsUI.options.size, coreUI.optionsUI.options.size, j.iconPath, 0, 0, 0, imports.tocolor(coreUI.optionsUI.options.color[1], coreUI.optionsUI.options.color[2], coreUI.optionsUI.options.color[3], coreUI.optionsUI.options.color[4]*j["__UI_CACHE__"].animAlphaPercent), false)
            end
        end
    end)
    beautify.render.create(function()
        if coreUI.optionsUI.options.hoveredOption then
            local isMouseKeyClicked = imports.isMouseClicked()
            if isMouseKeyClicked and (isMouseKeyClicked == "mouse1") and (coreUI.optionsUI.options.selectedOption ~= coreUI.optionsUI.options.hoveredOption) then
                local isOptionToBeSelected, disableViewGrids = true, {}
                local optionReference = coreUI.optionsUI.options[(coreUI.optionsUI.options.hoveredOption)]
                if optionReference.mandatorySelection then
                    local viewGridSelection = beautify.gridlist.getSelection(coreUI.viewerUI.gridlists.typeReference[(optionReference.mandatorySelection)].createdElement)
                    if not viewGridSelection then return false end
                    disableViewGrids[(optionReference.mandatorySelection)] = true
                end
                if optionReference.optBinds then
                    local optBinds = optionReference.optBinds
                    if (optionReference.optionType == "create") or (optionReference.optionType == "delete") then
                        optBinds = {
                            title = optBinds.title,
                        }
                        for i, j in imports.ipairs(imports.table.clone(optionReference.optBinds)) do
                            if j.mandatorySelection then
                                local viewGridSelection = beautify.gridlist.getSelection(coreUI.viewerUI.gridlists.typeReference[(j.mandatorySelection)].createdElement)
                                if viewGridSelection then
                                    disableViewGrids[(j.mandatorySelection)] = true
                                    imports.table.insert(optBinds, j)
                                end
                            else
                                imports.table.insert(optBinds, j)
                            end
                        end
                        if #optBinds <= 1 then
                            isOptionToBeSelected = false
                        end
                    end
                    if isOptionToBeSelected then
                        local isEnableBlockToBeSkipped = false
                        imports.selectCoreOption(nil, nil, true)
                        for i, j in imports.pairs(disableViewGrids) do
                            isEnableBlockToBeSkipped = true
                            beautify.setUIDisabled(coreUI.viewerUI.gridlists.typeReference[i].createdElement, j)
                        end
                        imports.selectCoreOption(coreUI.optionsUI.options.hoveredOption, isEnableBlockToBeSkipped)
                        createOptUI(optBinds)
                    end
                else
                    destroyOptUI()
                end
            end
        end
    end, {
        renderType = "input"
    })

    -->> Viewer UI <<--
    coreUI.viewerUI.startX, coreUI.viewerUI.startY = coreUI.optionsUI.startX - coreUI.viewerUI.startX - (coreUI.viewerUI.width + coreUI.viewerUI.borderPadding), coreUI.optionsUI.startY
    coreUI.viewerUI.createdParent = beautify.card.create(coreUI.viewerUI.startX, coreUI.viewerUI.startY, coreUI.viewerUI.width, coreUI.viewerUI.height, nil, false)
    local viewer_gridlist_height = (coreUI.viewerUI.height - (coreUI.viewerUI.gridlists.paddingY*imports.math.max(#coreUI.viewerUI.gridlists - 1, 0)))/imports.math.max(#coreUI.viewerUI.gridlists, 1)
    for i, j in imports.ipairs(coreUI.viewerUI.gridlists) do
        j.createdElement = beautify.gridlist.create(0, (viewer_gridlist_height + coreUI.viewerUI.gridlists.paddingY)*(i - 1), coreUI.viewerUI.width, viewer_gridlist_height, coreUI.viewerUI.createdParent, false)
        coreUI.viewerUI.gridlists.typeReference[(j.gridType)] = j
        if j.gridType == "view_animations" then
            imports.addEventHandler("onClientUISelectionAltered", j.createdElement, imports.updateFrameView)
        end
        beautify.gridlist.addColumn(j.createdElement, j.title, coreUI.viewerUI.width)
        beautify.setUIVisible(j.createdElement, true)
    end
    beautify.setUIVisible(coreUI.viewerUI.createdParent, true)
    imports.showCursor(true)
    return true

end