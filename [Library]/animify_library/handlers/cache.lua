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
    updateFrameView = updateFrameView,
    table = {
        insert = table.insert,
        remove = table.remove,
        clone = table.clone
    }
}


-------------------
--[[ Variables ]]--
-------------------

local cache = {
    ["Animations"] = {}
}


----------------------------------------------------------
--[[ Functions: Creates/Destroys/Retrieves Anim Cache ]]--
----------------------------------------------------------

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

function getAnimCache(animIndex)

    if not animIndex or not cache["Animations"][animIndex] then return false end

    return cache["Animations"][animIndex]

end


--------------------------------------------
--[[ Functions: Adds/Removes Anim Frame ]]--
--------------------------------------------

function addAnimFrame(animIndex, frameIndex)

    if not animIndex or not cache["Animations"][animIndex] or (frameIndex and not cache["Animations"][animIndex]["Frames"][frameIndex]) then return false end

    if frameIndex then
        imports.table.insert(cache["Animations"][animIndex]["Frames"], imports.table.clone(cache["Animations"][animIndex]["Frames"][frameIndex], true))
    else
        imports.table.insert(cache["Animations"][animIndex]["Frames"], {
            ["Bones"] = {}
        })
    end
    return #cache["Animations"][animIndex]["Frames"]

end

function removeAnimFrame(animIndex, frameIndex)

    if not animIndex or not frameIndex or not cache["Animations"][animIndex] or not cache["Animations"][animIndex]["Frames"][frameIndex] then return false end

    return imports.table.remove(cache["Animations"][animIndex]["Frames"], frameIndex)

end

function getAnimFrameCache(animIndex, frameIndex)

    if not animIndex or not frameIndex or not cache["Animations"][animIndex] or not cache["Animations"][animIndex]["Frames"][frameIndex] then return false end

    return cache["Animations"][animIndex]["Frames"][frameIndex]

end