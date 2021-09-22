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
    ipairs = ipairs,
    tocolor = tocolor,
    destroyElement = destroyElement,
    isMouseOnPosition = isMouseOnPosition,
    isMouseClicked = isMouseClicked,
    getInterpolationProgress = getInterpolationProgress,
    interpolateBetween = interpolateBetween,
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
    math = {
        max = math.max
    }
}


-------------------
--[[ Variables ]]--
-------------------

coreUI = {

    viewportUI = {
        sliders = {
            marginY = 5, paddingY = 5,
            width = 200, height = 24,
            {
                title = "PED ROTATION",
                sliderType = "ped_rotation",
                defaultPercent = 100
            },
            {
                title = "CAMERA ROTATION",
                sliderType = "camera_rotation",
                defaultPercent = 100
            },
            {
                title = "CAMERA FOV",
                sliderType = "camera_fov",
                defaultPercent = 100
            }
        },
        labels = {
            marginY = 20, paddingX = 5, paddingY = 5,
            width = 300, height = 20,
            color = {200, 200, 200, 255},
            {
                prefix = "SELECTED BONE:  ",
                labelType = "bone_id"
            },
            {
                prefix = "SELECTED AXIS:  ",
                labelType = "axis_id"
            }
        }
    },

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
                        execFunction = function()
                            local rowIndex = beautify.gridlist.addRow(coreUI.viewerUI.gridlists.typeReference["view_frames"].createdElement)
                            beautify.gridlist.setRowData(coreUI.viewerUI.gridlists.typeReference["view_frames"].createdElement, rowIndex, 1, coreUI.viewerUI.gridlists.typeReference["view_frames"].prefix..tostring(beautify.gridlist.countRows(coreUI.viewerUI.gridlists.typeReference["view_frames"].createdElement)))
                            destroyOptUI()
                            selectCoreOption(false)
                        end
                    },
                    {
                        title = "C R E A T E  A N I M A T I O N",
                    },
                    {
                        title = "C A N C E L",
                        execFunction = function()
                            destroyOptUI()
                            selectCoreOption(false)
                        end
                    }
                }
            },
            {
                optionType = "edit",
                iconPath = imports.dxCreateTexture("files/assets/images/icons/edit.png", "argb", true, "clamp"),
                isFrameToBeSelected = true,
                optBinds = {
                    title = "E  D  I  T    F  R  A  M  E",
                    {
                        title = "C O N F I R M"
                    },
                    {
                        title = "R E J E C T",
                        execFunction = function()
                            destroyOptUI()
                            selectCoreOption(false)
                        end
                    }
                }
            },
            {
                optionType = "delete",
                iconPath = imports.dxCreateTexture("files/assets/images/icons/delete.png", "argb", true, "clamp"),
                isFrameToBeSelected = true,
                optBinds = {
                    title = "D  E  L  E  T  E    F  R  A  M  E",
                    {
                        title = "C O N F I R M"
                    },
                    {
                        title = "R E J E C T",
                        execFunction = function()
                            destroyOptUI()
                            selectCoreOption(false)
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

    -->> View-Port UI <<--
    coreUI.viewportUI.sliders.__endY = 0
    for i, j in imports.ipairs(coreUI.viewportUI.sliders) do
        local viewport_slider_width, viewport_slider_height = coreUI.viewportUI.sliders.width, coreUI.viewportUI.sliders.height
        local viewport_slider_startX, viewport_slider_startY = CLIENT_MTA_RESOLUTION[1] - viewport_slider_width, coreUI.viewportUI.sliders.marginY + ((viewport_slider_height + coreUI.viewportUI.sliders.paddingY)*(i - 1))
        j.createdElement = beautify.slider.create(viewport_slider_startX, viewport_slider_startY, viewport_slider_width, viewport_slider_height, "horizontal", nil, false)
        beautify.slider.setText(j.createdElement, j.title)
        beautify.slider.setPercent(j.createdElement, j.defaultPercent)
        beautify.setUIVisible(j.createdElement, true)
        if i == #coreUI.viewportUI.sliders then
            coreUI.viewportUI.sliders.__endY = viewport_slider_startY + viewport_slider_height + coreUI.viewportUI.sliders.paddingY
        end
    end
    coreUI.viewportUI.labels.__endY = coreUI.viewportUI.sliders.__endY
    for i, j in imports.ipairs(coreUI.viewportUI.labels) do
        local viewport_label_width, viewport_label_height = coreUI.viewportUI.labels.width, coreUI.viewportUI.labels.height
        local viewport_label_startX, viewport_label_startY = CLIENT_MTA_RESOLUTION[1] - viewport_label_width - coreUI.viewportUI.labels.paddingX, coreUI.viewportUI.sliders.__endY + coreUI.viewportUI.labels.marginY + ((viewport_label_height + coreUI.viewportUI.labels.paddingY)*(i - 1))
        j.createdElement = beautify.label.create("", viewport_label_startX, viewport_label_startY, viewport_label_width, viewport_label_height, nil, false)
        beautify.label.setColor(j.createdElement, coreUI.viewportUI.labels.color)
        beautify.label.setHorizontalAlignment(j.createdElement, "right")
        beautify.label.setVerticalAlignment(j.createdElement, "center")
        beautify.setUIDisabled(j.createdElement, true)
        beautify.setUIVisible(j.createdElement, true)
        if i == #coreUI.viewportUI.labels then
            coreUI.viewportUI.labels.__endY = viewport_label_startY + viewport_label_height + coreUI.viewportUI.labels.paddingY
        end
    end

    -->> Options UI <<--
    coreUI.optionsUI.startX, coreUI.optionsUI.startY = coreUI.optionsUI.startX - coreUI.optionsUI.width, coreUI.viewportUI.labels.__endY + coreUI.optionsUI.startY
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
                local isEnableBlockToBeSkipped = false
                local optionReference = coreUI.optionsUI.options[(coreUI.optionsUI.options.hoveredOption)]
                if optionReference.isFrameToBeSelected then
                    local selectedFrame = beautify.gridlist.getSelection(coreUI.viewerUI.gridlists.typeReference["view_frames"].createdElement)
                    if not selectedFrame then return false end
                    isEnableBlockToBeSkipped = true
                    beautify.setUIDisabled(coreUI.viewerUI.gridlists.typeReference["view_frames"].createdElement, true)
                end
                selectCoreOption(coreUI.optionsUI.options.hoveredOption, isEnableBlockToBeSkipped)
                if optionReference.optBinds then
                    createOptUI(optionReference.optBinds)
                else
                    destroyOptUI()
                end
                --[[
                if optionReference.optionType == "create" then
                elseif optionReference.optionType == "edit" then
                elseif optionReference.optionType == "delete" then
                end]]
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
        beautify.gridlist.addColumn(j.createdElement, j.title, coreUI.viewerUI.width)
        beautify.setUIVisible(j.createdElement, true)
    end
    beautify.setUIVisible(coreUI.viewerUI.createdParent, true)
    imports.showCursor(true)
    return true

end


-------------------------------------------------
--[[ Function: Selects/Deselects Core Option ]]--
-------------------------------------------------

function selectCoreOption(optionIndex, skipEnableBlock)

    if not optionIndex then
        if coreUI.optionsUI.options.selectedOption then
            coreUI.optionsUI.options.selectedOption = false
            beautify.setUIDisabled(coreUI.viewerUI.gridlists.typeReference["view_frames"].createdElement, false)
            beautify.setUIDisabled(coreUI.viewerUI.gridlists.typeReference["view_animations"].createdElement, false)
            return true
        end
    else
        if coreUI.optionsUI.options[optionIndex] and (coreUI.optionsUI.options.selectedOption ~= optionIndex) then
            coreUI.optionsUI.options.selectedOption = optionIndex
            if not skipEnableBlock then
                beautify.setUIDisabled(coreUI.viewerUI.gridlists.typeReference["view_frames"].createdElement, false)
                beautify.setUIDisabled(coreUI.viewerUI.gridlists.typeReference["view_animations"].createdElement, false)
                return true
            end
        end
    end
    return false

end