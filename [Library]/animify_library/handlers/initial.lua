----------------------------------------------------------------
--[[ Resource: Animify Library
     Script: handlers: initial.lua
     Server: -
     Author: OvileAmriam
     Developer: -
     DOC: 08/09/2021 (OvileAmriam)
     Desc: Initial Handler ]]--
----------------------------------------------------------------


-----------------------------------------
--[[ Event: On Client Resource Start ]]--
-----------------------------------------

addEventHandler("onClientResourceStart", resourceRoot, function()

    setUITheme("ov-dark-theme")
    createCoreUI()
    --showCursor(true)

end)