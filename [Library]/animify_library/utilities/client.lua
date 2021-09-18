  
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

loadstring(exports.beautify_library:fetchImports())()


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