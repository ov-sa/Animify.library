  
----------------------------------------------------------------
--[[ Resource: Animify Library
     Script: utilities: client.lua
     Server: -
     Author: OvileAmriam
     Developer: -
     DOC: 08/09/2021 (OvileAmriam)
     Desc: Client Sided Utilities ]]--
----------------------------------------------------------------


-------------------
--[[ Variables ]]--
-------------------

CLIENT_MTA_RESOLUTION = {GuiElement.getScreenSize()}
loadstring(exports.beautify_library:fetchImports())()


--------------------------------------------------------
--[[ Function: Retrieves Cursor's Absolute Position ]]--
--------------------------------------------------------

function getAbsoluteCursorPosition()

    if not isCursorShowing() then return false end

    local cursorX, cursorY = getCursorPosition()
    return cursorX*CLIENT_MTA_RESOLUTION[1], cursorY*CLIENT_MTA_RESOLUTION[2]

end


---------------------------------------------
--[[ Function: Verifies Mouse's Position ]]--
---------------------------------------------

function isMouseOnPosition(x, y, width, height)

    local cursorX, cursorY = getAbsoluteCursorPosition()
    if not cursorX or not cursorY then return false end

    return (cursorX >= x) and (cursorX <= (x + width)) and (cursorY >= y) and (cursorY <= (y + height))

end


-----------------------------------------
--[[ Function: Retrieves File's Data ]]--
-----------------------------------------

function getFileData(filePath)

    if not filePath or not File.exists(filePath) then return false end
    local file = File.open(filePath)
    if not file then return false end

    local fileData = file:read(file:getSize())
    file:close()
    return fileData

end


-----------------------------------
--[[ Function: Sets UI's Theme ]]--
-----------------------------------

function setUITheme(theme)

    if not theme then return false end

    for i, j in pairs(availableTemplates) do
        beautify.setUITemplate(i, j["ov-dark-theme"])
    end
    return true

end


local function isCoordWithinCircle(x, y, cx, cy, cr)



end