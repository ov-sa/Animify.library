----------------------------------------------------------------
--[[ Resource: Animify Library
     Script: handlers: initial.lua
     Server: -
     Author: OvileAmriam
     Developer: -
     DOC: 08/09/2021 (OvileAmriam)
     Desc: Initial Handler ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    addEventHandler = addEventHandler,
    setUITheme = setUITheme
}


-----------------------------------------
--[[ Event: On Client Resource Start ]]--
-----------------------------------------

imports.addEventHandler("onClientResourceStart", resource, function()

    imports.setUITheme("animify-dark-slver-theme")
    initCinemator()
    createViewPortUI()
    createCoreUI()

end)