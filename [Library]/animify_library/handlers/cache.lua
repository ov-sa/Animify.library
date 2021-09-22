----------------------------------------------------------------
--[[ Resource: Animify Library
     Script: handlers: cache.lua
     Server: -
     Author: OvileAmriam
     Developer: -
     DOC: 08/09/2021 (OvileAmriam)
     Desc: Cache Handler ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    table = {
        insert = table.insert,
        remove = table.remove
    }
}


-------------------
--[[ Variables ]]--
-------------------

local cache = {
    ["Animations"] = {}
}


------------------------------------------------
--[[ Functions: Creates/Destroys Anim Cache ]]--
------------------------------------------------

function createAnimCache()

    imports.table.insert(cache["Animations"], {
        ["Frames"] = {}
    })
    return #cache["Animations"]

end

function destroyAnimCache(animIndex)

    if not animIndex or not cache["Animations"][animIndex] then return false end

    return imports.table.remove(cache["Animations"], animIndex)

end


--------------------------------------------
--[[ Functions: Adds/Removes Anim Frame ]]--
--------------------------------------------

function addAnimFrame(animIndex)

    if not animIndex or not cache["Animations"][animIndex] then return false end

    imports.table.insert(cache["Animations"][animIndex]["Frame"], {})
    return #cache["Animations"][animIndex]["Frame"]

end

function removeAnimFrame(animIndex, frameIndex)

    if not animIndex or not frameIndex or not cache["Animations"][animIndex] or not cache["Animations"][animIndex]["Frame"][frameIndex] then return false end

    return imports.table.remove(cache["Animations"][animIndex]["Frame"], frameIndex)

end