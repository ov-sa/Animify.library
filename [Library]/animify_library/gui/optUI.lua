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
    isElement = isElement,
    destroyElement = destroyElement,
    getInterpolationProgress = getInterpolationProgress,
    interpolateBetween = interpolateBetween,
    dxCreateFont = dxCreateFont,
    dxDrawRectangle = dxDrawRectangle,
    dxDrawText = dxDrawText,
    table = {
        insert = table.insert
    },
    math = {
        max = math.max
    }
}


-------------------
--[[ Variables ]]--
-------------------

local optUI = {

    isVisible = false,
    marginX = 7, marginY = 5, paddingY = 5,
    width = 250, height = 24,
    wrapper = {
        padding = 4,
        animDuration = 400,
        titlebar = {
            height = 20,
            font = imports.dxCreateFont("files/assets/fonts/signika_semibold.rw", 13),
            fontColor = imports.tocolor(0, 0, 0, 255),
            color = imports.tocolor(200, 200, 200, 255)
        },
        color = imports.tocolor(0, 0, 0, 150)
    }

}
optUI.marginY = optUI.height + optUI.marginY


--------------------------------------------
--[[ Functions: Creates/Destroys Opt UI ]]--
--------------------------------------------

function createOptUI(options)

    destroyOptUI()
    if not options or (#options <= 0) then return false end
    if optUI.isVisible and (optUI.createdElements["__UI_CACHE__"]["Wrapper"].animStatus == "backward") then
        optUI.scheduledOptions = options
        return false
    end

    optUI.createdElements = {
        ["__UI_CACHE__"] = {
            ["Wrapper"] = {
                interpolationProgress = 0,
                animStatus = "forward",
                tickCounter = CLIENT_CURRENT_TICK,
                ["Title Bar"] = {
                    ["Text"] = {}
                }
            }
        }
    }
    optUI.createdElements["__UI_CACHE__"]["Wrapper"].offsetX, optUI.createdElements["__UI_CACHE__"]["Wrapper"].offsetY = 0, 0
    optUI.createdElements["__UI_CACHE__"]["Wrapper"].startX, optUI.createdElements["__UI_CACHE__"]["Wrapper"].startY = optUI.marginX - optUI.wrapper.padding, optUI.marginY - optUI.wrapper.padding
    optUI.createdElements["__UI_CACHE__"]["Wrapper"].width, optUI.createdElements["__UI_CACHE__"]["Wrapper"].height = optUI.width + (optUI.wrapper.padding*2), (#options*optUI.height) + (imports.math.max(#options - 1, 0)*optUI.paddingY) + (optUI.wrapper.padding*2)
    optUI.createdElements["__UI_CACHE__"]["Wrapper"]["Title Bar"].height = optUI.wrapper.titlebar.height
    optUI.createdElements["__UI_CACHE__"]["Wrapper"]["Title Bar"]["Text"].text = options.title or ""
    for i, j in imports.ipairs(options) do
        local createdButton = beautify.button.create(j.title, 0, 0, "default", optUI.width, optUI.height, nil, false)
        if i == 1 then
            beautify.render.create(function()
                optUI.createdElements["__UI_CACHE__"]["Wrapper"].interpolationProgress = imports.getInterpolationProgress(optUI.createdElements["__UI_CACHE__"]["Wrapper"].tickCounter, optUI.wrapper.animDuration)
                if (optUI.createdElements["__UI_CACHE__"]["Wrapper"].interpolationProgress <= 2) or CLIENT_MTA_RESTORED then
                    if optUI.createdElements["__UI_CACHE__"]["Wrapper"].animStatus == "forward" then
                        optUI.createdElements["__UI_CACHE__"]["Wrapper"].offsetX, optUI.createdElements["__UI_CACHE__"]["Wrapper"].offsetY = imports.interpolateBetween(-optUI.createdElements["__UI_CACHE__"]["Wrapper"].width*1.5, CLIENT_MTA_RESOLUTION[2]*0.25, 0, optUI.createdElements["__UI_CACHE__"]["Wrapper"].startX, optUI.createdElements["__UI_CACHE__"]["Wrapper"].startY, 0, optUI.createdElements["__UI_CACHE__"]["Wrapper"].interpolationProgress, "OutBack")
                    elseif optUI.createdElements["__UI_CACHE__"]["Wrapper"].animStatus == "backward" then
                        optUI.createdElements["__UI_CACHE__"]["Wrapper"].offsetX, optUI.createdElements["__UI_CACHE__"]["Wrapper"].offsetY = imports.interpolateBetween(optUI.createdElements["__UI_CACHE__"]["Wrapper"].startX, optUI.createdElements["__UI_CACHE__"]["Wrapper"].startY, 0, -optUI.createdElements["__UI_CACHE__"]["Wrapper"].width*1.5, optUI.createdElements["__UI_CACHE__"]["Wrapper"].startY, 0, optUI.createdElements["__UI_CACHE__"]["Wrapper"].interpolationProgress, "OutBack")
                    end
                else
                    if optUI.createdElements["__UI_CACHE__"]["Wrapper"].animStatus == "backward" then
                        destroyOptUI(true)
                        return true
                    end
                end
                optUI.createdElements["__UI_CACHE__"]["Wrapper"]["Title Bar"].startY = optUI.createdElements["__UI_CACHE__"]["Wrapper"].offsetY - optUI.createdElements["__UI_CACHE__"]["Wrapper"]["Title Bar"].height
                optUI.createdElements["__UI_CACHE__"]["Wrapper"]["Title Bar"]["Text"].endX = optUI.createdElements["__UI_CACHE__"]["Wrapper"].offsetX + optUI.createdElements["__UI_CACHE__"]["Wrapper"].width
                optUI.createdElements["__UI_CACHE__"]["Wrapper"]["Title Bar"]["Text"].endY = optUI.createdElements["__UI_CACHE__"]["Wrapper"]["Title Bar"].startY + optUI.createdElements["__UI_CACHE__"]["Wrapper"]["Title Bar"].height                
                for i, j in imports.ipairs(optUI.createdElements) do
                    if j and imports.isElement(j) then
                        beautify.setUIPosition(j, optUI.createdElements["__UI_CACHE__"]["Wrapper"].offsetX + optUI.wrapper.padding, optUI.createdElements["__UI_CACHE__"]["Wrapper"].offsetY + optUI.wrapper.padding + ((optUI.height + optUI.paddingY)*(i - 1)))
                    end
                end
                imports.dxDrawRectangle(optUI.createdElements["__UI_CACHE__"]["Wrapper"].offsetX, optUI.createdElements["__UI_CACHE__"]["Wrapper"].offsetY, optUI.createdElements["__UI_CACHE__"]["Wrapper"].width, optUI.createdElements["__UI_CACHE__"]["Wrapper"].height, optUI.wrapper.color, false)
                imports.dxDrawRectangle(optUI.createdElements["__UI_CACHE__"]["Wrapper"].offsetX, optUI.createdElements["__UI_CACHE__"]["Wrapper"]["Title Bar"].startY, optUI.createdElements["__UI_CACHE__"]["Wrapper"].width, optUI.createdElements["__UI_CACHE__"]["Wrapper"]["Title Bar"].height, optUI.wrapper.titlebar.color, false)
                imports.dxDrawText(optUI.createdElements["__UI_CACHE__"]["Wrapper"]["Title Bar"]["Text"].text, optUI.createdElements["__UI_CACHE__"]["Wrapper"].offsetX, optUI.createdElements["__UI_CACHE__"]["Wrapper"]["Title Bar"].startY, optUI.createdElements["__UI_CACHE__"]["Wrapper"]["Title Bar"]["Text"].endX, optUI.createdElements["__UI_CACHE__"]["Wrapper"]["Title Bar"]["Text"].endY, optUI.wrapper.titlebar.fontColor, 1, optUI.wrapper.titlebar.font, "center", "center", true, false, false, false)
            end, {
                elementReference = createdButton,
                renderType = "preRender"
            })
        end
        imports.table.insert(optUI.createdElements, createdButton)
        beautify.setUIVisible(createdButton, true)
    end
    optUI.isVisible = true
    return true

end

function destroyOptUI(isForced)

    if not optUI.isVisible or (not isForced and (optUI.createdElements["__UI_CACHE__"]["Wrapper"].animStatus == "backward")) then return false end

    if not isForced then
        optUI.createdElements["__UI_CACHE__"]["Wrapper"].animStatus = "backward"
        optUI.createdElements["__UI_CACHE__"]["Wrapper"].tickCounter = CLIENT_CURRENT_TICK
    else
        for i, j in imports.ipairs(optUI.createdElements) do
            if j and imports.isElement(j) then
                imports.destroyElement(j)
            end
        end
        optUI.createdElements = nil
        optUI.isVisible = false
        if optUI.scheduledOptions then
            createOptUI(optUI.scheduledOptions)
            optUI.scheduledOptions = nil
        end
    end
    return true

end