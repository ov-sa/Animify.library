----------------------------------------------------------------
--[[ Resource: Animify Library
     Script: gui: coreUI.lua
     Server: -
     Author: OvileAmriam
     Developer: -
     DOC: 08/09/2021 (OvileAmriam)
     Desc: Core UI ]]--
----------------------------------------------------------------


-------------------
--[[ Variables ]]--
-------------------

coreUI = {

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
            height = 24,
            {
                title = "CREATE FRAME"
            },
            {
                title = "CREATE ANIMATION"
            },
            {
                title = "EDIT FRAME/ANIMATION"
            },
            {
                title = "DELETE FRAME/ANIMATION"
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
        },
        decks = {
            height = 165,
            {
                title = "VIEW FRAMES",
                deckType = "view_frames"
            },
            {
                title = "VIEW ANIMATIONS",
                deckType = "view_animations"
            }
        }
    },

    viewportUI = {
        sliders = {
            width = 200, height = 24,
            marginY = 5, paddingY = 5,
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
        }
    }

}
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
        local options_button = beautify.button.create(j.title, 0, (coreUI.optionsUI.banner.marginY*2) + coreUI.optionsUI.banner.height + coreUI.optionsUI.options.marginY + (coreUI.optionsUI.options.height + coreUI.optionsUI.options.paddingY)*(i - 1), "default", coreUI.optionsUI.width, coreUI.optionsUI.options.height, coreUI.optionsUI.createdParent, false)
        beautify.setUIVisible(options_button, true)
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
    local viewer_deckpane_startX, viewer_deckpane_startY = 0, (coreUI.viewerUI.banner.marginY*2) + coreUI.viewerUI.marginY + coreUI.viewerUI.banner.height
    local viewer_deckpane = beautify.deckpane.create(0, viewer_deckpane_startY, coreUI.viewerUI.width, coreUI.viewerUI.height - viewer_deckpane_startY, coreUI.viewerUI.createdParent, false)
    for i, j in ipairs(coreUI.viewerUI.decks) do
        local viewer_deck = beautify.deck.create(j.title, coreUI.viewerUI.decks.height, viewer_deckpane, false)
        if j.deckType == "view_frames" then
            local viewer_gridlist_width = coreUI.viewerUI.width - 10
            local createdGridlist = beautify.gridlist.create(0, 0, viewer_gridlist_width, coreUI.viewerUI.decks.height, viewer_deck, false)
            beautify.gridlist.addColumn(createdGridlist, "FRAME ID", viewer_gridlist_width)        
            for x = 1, 500, 1 do
                local rowIndex = beautify.gridlist.addRow(createdGridlist)
                beautify.gridlist.setRowData(createdGridlist, rowIndex, 1, "FRAME #"..tostring(beautify.gridlist.countRows(createdGridlist)))
            end
            beautify.gridlist.setSelection(createdGridlist, 1)
            beautify.setUIVisible(createdGridlist, true)
        elseif j.deckType == "view_animations" then
            local viewer_gridlist_width = coreUI.viewerUI.width - 10
            local createdGridlist = beautify.gridlist.create(0, 0, viewer_gridlist_width, coreUI.viewerUI.decks.height, viewer_deck, false)
            beautify.gridlist.addColumn(createdGridlist, "ANIMATION ID", viewer_gridlist_width)        
            for x = 1, 500, 1 do
                local rowIndex = beautify.gridlist.addRow(createdGridlist)
                beautify.gridlist.setRowData(createdGridlist, rowIndex, 1, "ANIMATION #"..tostring(beautify.gridlist.countRows(createdGridlist)))
            end
            beautify.gridlist.setSelection(createdGridlist, 1)
            beautify.setUIVisible(createdGridlist, true)
        end
        j.createdElement = viewer_deck
        beautify.setUIVisible(viewer_deck, true)
    end
    beautify.setUIVisible(viewer_deckpane, true)
    beautify.render.create(function()
        dxDrawImage(0, coreUI.viewerUI.banner.marginY, coreUI.viewerUI.width, coreUI.viewerUI.banner.height, coreUI.viewerUI.banner.bgPath, 0, 0, 0, -1, false)
        dxDrawText(coreUI.viewerUI.banner.text, 0, coreUI.viewerUI.banner.marginY, coreUI.viewerUI.width, coreUI.viewerUI.banner.marginY + coreUI.viewerUI.banner.height, coreUI.viewerUI.banner.fontColor, 1, coreUI.viewerUI.banner.font, "center", "center", true, false, false, false)
    end, coreUI.viewerUI.createdParent)

    -->> View Port UI <<--
    for i, j in ipairs(coreUI.viewportUI.sliders) do
        j.createdElement = beautify.slider.create(CLIENT_MTA_RESOLUTION[1] - coreUI.viewportUI.sliders.width, coreUI.viewportUI.sliders.marginY + ((coreUI.viewportUI.sliders.height + coreUI.viewportUI.sliders.paddingY)*(i - 1)), coreUI.viewportUI.sliders.width, coreUI.viewportUI.sliders.height, "horizontal", nil, false)
        beautify.slider.setText(j.createdElement, j.title)
        beautify.slider.setPercent(j.createdElement, j.defaultPercent)
        beautify.setUIVisible(j.createdElement, true)
    end
    showCursor(true)

    return true

end