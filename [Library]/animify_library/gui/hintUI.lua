----------------------------------------------------------------
--[[ Resource: Animify Library
     Script: gui: hintUI.lua
     Server: -
     Author: OvileAmriam
     Developer: -
     DOC: 08/09/2021 (OvileAmriam)
     Desc: Core UI ]]--
----------------------------------------------------------------


-------------------
--[[ Variables ]]--
-------------------

local hintUI = {

    width = 300, height = 35

}
--[[
hintUI.viewerUI.paddingX = hintUI.optionsUI.paddingX + hintUI.viewerUI.paddingX
hintUI.viewerUI.height = (hintUI.viewerUI.banner.marginY*2) + hintUI.viewerUI.banner.height + hintUI.viewerUI.height
hintUI.viewerUI.banner.font = hintUI.optionsUI.banner.font 
hintUI.viewerUI.banner.fontColor = hintUI.optionsUI.banner.fontColor
hintUI.viewerUI.banner.bgPath = hintUI.optionsUI.banner.bgPath]]


-----------------------------------
--[[ Function: Creates Hint UI ]]--
-----------------------------------

function createHintUI()

    --hintUI.createdParent = beautify.card.create(1366 - hintUI.width - 100, 768 - hintUI.height - 100, hintUI.width, hintUI.height, nil, false)
    --beautify.setUIVisible(hintUI.createdParent, true)

    -->> Options UI <<--
    --[[
    hintUI.optionsUI.__endY = (hintUI.optionsUI.banner.marginY*2) + hintUI.optionsUI.banner.height + (hintUI.optionsUI.options.marginY*2) + (hintUI.optionsUI.options.height*math.max(0, #hintUI.optionsUI.options)) + (hintUI.optionsUI.options.paddingY*math.max(0, #hintUI.optionsUI.options - 1))
    hintUI.optionsUI.__endY = hintUI.optionsUI.paddingY + hintUI.optionsUI.__endY + hintUI.optionsUI.borderPadding
    for i, j in ipairs(hintUI.optionsUI.options) do
        local options_button = beautify.button.create(j.title, 0, (hintUI.optionsUI.banner.marginY*2) + hintUI.optionsUI.banner.height + hintUI.optionsUI.options.marginY + (hintUI.optionsUI.options.height + hintUI.optionsUI.options.paddingY)*(i - 1), "default", hintUI.optionsUI.width, hintUI.optionsUI.options.height, hintUI.optionsUI.createdParent, false)
        beautify.setUIVisible(options_button, true)
    end
    beautify.setUIVisible(hintUI.optionsUI.createdParent, true)
    beautify.render.create(function()
        dxDrawImage(0, hintUI.optionsUI.banner.marginY, hintUI.optionsUI.width, hintUI.optionsUI.banner.height, hintUI.optionsUI.banner.bgPath, 0, 0, 0, -1, false)
        dxDrawText(hintUI.optionsUI.banner.text, 0, hintUI.optionsUI.banner.marginY, hintUI.optionsUI.width, hintUI.optionsUI.banner.marginY + hintUI.optionsUI.banner.height, hintUI.optionsUI.banner.fontColor, 1, hintUI.optionsUI.banner.font, "center", "center", true, false, false, false)
    end, hintUI.optionsUI.createdParent)
    ]]

end
beautify.render.create(function()
    dxDrawRectangle(1366 - hintUI.width - 2, 768 - hintUI.height - 2, hintUI.width, hintUI.height, tocolor(0, 0, 0, 255), false)
    --dxDrawImage(0, hintUI.optionsUI.banner.marginY, hintUI.optionsUI.width, hintUI.optionsUI.banner.height, hintUI.optionsUI.banner.bgPath, 0, 0, 0, -1, false)
    --dxDrawText(hintUI.optionsUI.banner.text, 0, hintUI.optionsUI.banner.marginY, hintUI.optionsUI.width, hintUI.optionsUI.banner.marginY + hintUI.optionsUI.banner.height, hintUI.optionsUI.banner.fontColor, 1, hintUI.optionsUI.banner.font, "center", "center", true, false, false, false)
end)