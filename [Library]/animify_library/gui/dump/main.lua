----------------------------------------------------------------
--[[ Resource: Animify Library
     Script: gui: ui_3.lua
     Server: -
     Author: OvileAmriam
     Developer: -
     DOC: 08/09/2021 (OvileAmriam)
     Desc: Example UI ]]--
----------------------------------------------------------------


----------------------
-->> Example UI 3 <<--
----------------------

local currentTemplateIndex = false
local loadedTemplates = {
    {template = "ov-dark-theme", label = "Enable Dark (Silver) Mode", labelColor = {225, 225, 225, 255}},
    {template = "dark-blue-theme", label = "Enable Dark (Blue) Mode", labelColor = {125, 125, 255, 255}},
    {template = "dark-red-theme", label = "Enable Dark (Red) Mode", labelColor = {255, 125, 125, 255}},
    {template = "dark-green-theme", label = "Enable Dark (Green) Mode", labelColor = {125, 255, 125, 255}},
    {template = "dark-yellow-theme", label = "Enable Dark (Yellow) Mode", labelColor = {255, 255, 125, 255}}
}

local function switchTemplate(state)
    
    local isTemplateToBeReloaded = false
    local isToBeReverted = currentTemplateIndex and (source == loadedTemplates[currentTemplateIndex].checker)
    if not state then
        if isToBeReverted then
            beautify.checkbox.setSelection(source, true)
        end
    else
        if not isToBeReverted then
            local selectedTemplateIndex = false
            for i, j in ipairs(loadedTemplates) do
                if source == j.checker then
                    selectedTemplateIndex = i
                    break
                end
            end
            if selectedTemplateIndex then
                currentTemplateIndex = selectedTemplateIndex
                for i, j in ipairs(loadedTemplates) do
                    if j.checker ~= source then
                        beautify.checkbox.setSelection(j.checker, false)
                    end
                end
                isTemplateToBeReloaded = true
            end
        end
    end

    if isTemplateToBeReloaded then
        for i, j in pairs(availableTemplates) do
            beautify.setUITemplate(i, j[(loadedTemplates[currentTemplateIndex].template)])
        end
    end

end

function createCoreUI()

    local window_width, window_height = 260, 768 - 40 - 10
    local createdWindow = beautify.window.create(5, 5, window_width, window_height, "Animify Library", nil, false)

    local createdDeckpane = beautify.deckpane.create(0, 0, window_width, window_height, createdWindow, false)
    local deck_height = 150
    local createdDecks = {
        {
            title = "CREATE FRAME",
            deckType = "ui_templates"
        },
        {
            title = "CREATE ANIMATION",
            deckType = "character_shields"
        },
        {
            title = "VIEW FRAMES",
            deckType = "character_customizer"
        },
        {
            title = "VIEW ANIMATIONS",
            deckType = "character_customizer"
        },
        {
            title = "EXPORT ANIMATION",
            deckType = "character_shields"
        },
        {
            title = "IMPORT/EXPORT IFP",
            deckType = "character_shields"
        }
    }
    for i, j in ipairs(createdDecks) do
        local createdDeck = beautify.deck.create(j.title, deck_height, createdDeckpane, false)
        beautify.deck.setMaximized(createdDeck, false)
        if j.deckType == "ui_templates" then
            for k, v in ipairs(loadedTemplates) do
                local createdCheckbox = beautify.checkbox.create(5, ((20 + 5)*(k - 1)) + 5, window_width - 20, 20, createdDeck, false)
                beautify.checkbox.setText(createdCheckbox, v.label)
                beautify.checkbox.setTextColor(createdCheckbox, v.labelColor)
                beautify.setUIVisible(createdCheckbox, true)
                v.checker = createdCheckbox
                addEventHandler("onClientUISelectionAltered", createdCheckbox, switchTemplate)
            end
            if #loadedTemplates > 0 then
                beautify.checkbox.setSelection(loadedTemplates[1].checker, true)
            end
        elseif j.deckType == "character_customizer" then
            local createdSelectors = {
                {
                    text = "Ethnicity",
                    datasList = {
                        "American",
                        "Asian",
                        "Arab",
                        "African"
                    }
                },
                {
                    text = "Torso",
                    datasList = {
                        "Shirt",
                        "T-Shirt",
                        "Hoodie",
                        "Suit"
                    }
                },
                {
                    text = "Trouser",
                    datasList = {
                        "Jeans",
                        "Shorts",
                        "Trackers"
                    }
                },
                {
                    text = "Feet",
                    datasList = {
                        "Slippers",
                        "Sneakers",
                        "Boots"
                    }
                }
            }
            for k, v in ipairs(createdSelectors) do
                local createdSelector = beautify.selector.create(5, 12.5 + ((20 + 12.5)*(k - 1)), window_width - 20, 20, "horizontal", createdDeck, false)
                beautify.selector.setText(createdSelector, v.text)
                beautify.selector.setDataList(createdSelector, v.datasList)
                beautify.setUIVisible(createdSelector, true)
                v.createdElement = createdSelector
            end
        elseif j.deckType == "character_shields" then
            local createdSelectors = {
                {
                    text = "Helmet",
                    datasList = {
                        "Assault",
                        "Ballistic",
                        "Combat",
                        "Tactical"
                    }
                },
                {
                    text = "Vest",
                    datasList = {
                        "Assault",
                        "Ballistic",
                        "Hunter",
                        "Tactical"
                    }
                }
            }
            for k, v in ipairs(createdSelectors) do
                local createdSelector = beautify.selector.create(5, 12 + ((60 + 5)*(k - 1)), window_width - 20, 60, "vertical", createdDeck, false)
                beautify.selector.setText(createdSelector, v.text)
                beautify.selector.setDataList(createdSelector, v.datasList)
                beautify.setUIVisible(createdSelector, true)
                v.createdElement = createdSelector
            end
        end
        j.createdElement = createdDeck
        beautify.setUIVisible(createdDeck, true)
    end
    beautify.setUIVisible(createdDeckpane, true)

    beautify.setUIVisible(createdWindow, true)

end