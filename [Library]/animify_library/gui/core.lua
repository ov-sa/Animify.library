----------------------------------------------------------------
--[[ Resource: Animify Library
     Script: gui: core.lua
     Server: -
     Author: OvileAmriam
     Developer: -
     DOC: 08/09/2021 (OvileAmriam)
     Desc: Core UI ]]--
----------------------------------------------------------------


-------------------
--[[ Variables ]]--
-------------------

local coreUI = {

    optionsUI = {
        createdParent = false,
        paddingX = 5, paddingY = 5, borderPadding = 10,
        width = 260,
        banner = {
            text = "O   P   T   I   O   N   S",
            marginY = 3,
            width = 0, height = 60,
            font = dxCreateFont("files/assets/fonts/impact.ttf", 20),
            fontColor = tocolor(175, 175, 175, 255),
            bgPath = dxCreateTexture("files/assets/images/banners/ov.png", "argb", true, "clamp")
        },
        options = {
            marginY = 5, paddingY = 8,
            width = 0, height = 24,
            {
                title = "CREATE FRAME"
            },
            {
                title = "CREATE ANIMATION"
            },
            {
                title = "EXPORT ANIMATION"
            },
            {
                title = "IMPORT/EXPORT IFP"
            }
        }
    },

    viewerUI = {
        createdParent = false,
        marginY = 5, paddingX = 0, paddingY = 5, borderPadding = 10,
        width = 260, height = 400,
        banner = {
            text = "V   I   E   W   E   R",
            marginY = 3,
            width = 0, height = 60
        }
    }

}
for i, j in pairs(availableTemplates) do
    beautify.setUITemplate(i, j["ov-dark-theme"])
end
coreUI.viewerUI.paddingX = coreUI.optionsUI.paddingX + coreUI.viewerUI.paddingX
coreUI.viewerUI.height = (coreUI.viewerUI.banner.marginY*2) + coreUI.viewerUI.banner.height + coreUI.viewerUI.height
coreUI.viewerUI.banner.font = coreUI.optionsUI.banner.font 
coreUI.viewerUI.banner.fontColor = coreUI.optionsUI.banner.fontColor
coreUI.viewerUI.banner.bgPath = coreUI.optionsUI.banner.bgPath


-----------------------------------
--[[ Function: Creates Core UI ]]--
-----------------------------------

function createCoreUI()

    -->> Options UI <<--
    coreUI.optionsUI.__endY = (coreUI.optionsUI.banner.marginY*2) + coreUI.optionsUI.banner.height + (coreUI.optionsUI.options.marginY*2) + (coreUI.optionsUI.options.height*math.max(0, #coreUI.optionsUI.options)) + (coreUI.optionsUI.options.paddingY*math.max(0, #coreUI.optionsUI.options - 1))
    coreUI.optionsUI.createdParent = beautify.card.create(coreUI.optionsUI.paddingX, coreUI.optionsUI.paddingY, coreUI.optionsUI.width, coreUI.optionsUI.__endY, nil, false)
    coreUI.optionsUI.__endY = coreUI.optionsUI.paddingY + coreUI.optionsUI.__endY + coreUI.optionsUI.borderPadding
    for i, j in ipairs(coreUI.optionsUI.options) do
        local createdButton = beautify.button.create(j.title, 0, (coreUI.optionsUI.banner.marginY*2) + coreUI.optionsUI.banner.height + coreUI.optionsUI.options.marginY + (coreUI.optionsUI.options.height + coreUI.optionsUI.options.paddingY)*(i - 1), "default", coreUI.optionsUI.width - coreUI.optionsUI.options.width, coreUI.optionsUI.options.height, coreUI.optionsUI.createdParent, false)
        beautify.setUIVisible(createdButton, true)
    end
    beautify.setUIVisible(coreUI.optionsUI.createdParent, true)
    beautify.render.create(function()
        dxDrawImage(0, coreUI.optionsUI.banner.marginY, coreUI.optionsUI.width, coreUI.optionsUI.banner.height, coreUI.optionsUI.banner.bgPath, 0, 0, 0, -1, false)
        dxDrawText(coreUI.optionsUI.banner.text, 0, coreUI.optionsUI.banner.marginY, coreUI.optionsUI.width, coreUI.optionsUI.banner.marginY + coreUI.optionsUI.banner.height, coreUI.optionsUI.banner.fontColor, 1, coreUI.optionsUI.banner.font, "center", "center", true, false, false, false)
    end, coreUI.optionsUI.createdParent)

    -->> Viewer UI <<--
    coreUI.viewerUI.__endY = coreUI.optionsUI.__endY + coreUI.viewerUI.paddingY
    coreUI.viewerUI.createdParent = beautify.card.create(coreUI.viewerUI.paddingX, coreUI.viewerUI.__endY, coreUI.viewerUI.width, coreUI.viewerUI.height, nil, false)
    coreUI.viewerUI.__endY = coreUI.viewerUI.__endY + coreUI.viewerUI.height + coreUI.viewerUI.borderPadding
    beautify.setUIVisible(coreUI.viewerUI.createdParent, true)
    local deckpane_startX, deckpane_startY = 0, (coreUI.viewerUI.banner.marginY*2) + coreUI.viewerUI.marginY + coreUI.viewerUI.banner.height
    local deck_height = 165
    local createdDeckpane = beautify.deckpane.create(0, deckpane_startY, coreUI.viewerUI.width, coreUI.viewerUI.height - deckpane_startY, coreUI.viewerUI.createdParent, false)
    local createdDecks = {
        {
            title = "VIEW FRAMES",
            deckType = "frame_viewer"
        },
        {
            title = "VIEW ANIMATIONS",
            deckType = "animation_viewer"
        }
    }
    for i, j in ipairs(createdDecks) do
        local createdDeck = beautify.deck.create(j.title, deck_height, createdDeckpane, false)
        beautify.deck.setMaximized(createdDeck, false)
        if j.deckType == "frame_viewer" then
            local createdGridlist = beautify.gridlist.create(0, 0, coreUI.viewerUI.width - 10, deck_height, createdDeck, false)
            beautify.gridlist.addColumn(createdGridlist, "FRAME ID", 250)        
            for x = 1, 500, 1 do
                local rowIndex = beautify.gridlist.addRow(createdGridlist)
                beautify.gridlist.setRowData(createdGridlist, rowIndex, 1, "FRAME #"..tostring(beautify.gridlist.countRows(createdGridlist)))
            end
            beautify.gridlist.setSelection(createdGridlist, 1)
            beautify.setUIVisible(createdGridlist, true)
        end
        j.createdElement = createdDeck
        beautify.setUIVisible(createdDeck, true)
    end
    beautify.setUIVisible(createdDeckpane, true)
    beautify.render.create(function()
        dxDrawImage(0, coreUI.viewerUI.banner.marginY, coreUI.viewerUI.width, coreUI.viewerUI.banner.height, coreUI.viewerUI.banner.bgPath, 0, 0, 0, -1, false)
        dxDrawText(coreUI.viewerUI.banner.text, 0, coreUI.viewerUI.banner.marginY, coreUI.viewerUI.width, coreUI.viewerUI.banner.marginY + coreUI.viewerUI.banner.height, coreUI.viewerUI.banner.fontColor, 1, coreUI.viewerUI.banner.font, "center", "center", true, false, false, false)
    end, coreUI.viewerUI.createdParent)

end