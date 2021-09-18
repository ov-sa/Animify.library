----------------------------------------------------------------
--[[ Resource: Animify Library
     Script: handlers: modelLoader.lua
     Server: -
     Author: OvileAmriam
     Developer: -
     DOC: 08/09/2021 (OvileAmriam)
     Desc: Model Loader ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    pairs = pairs,
    engineRequestModel = engineRequestModel,
    engineLoadTXD = engineLoadTXD,
    engineLoadCOL = engineLoadCOL,
    engineLoadDFF = engineLoadDFF,
    engineImportTXD = engineImportTXD,
    engineReplaceCOL = engineReplaceCOL,
    engineReplaceModel = engineReplaceModel
}


-------------------
--[[ Variables ]]--
-------------------

Animify_Models = {
    axisRing = {dffPath = "files/assets/models/ring/ring.dff", txdPath = "files/assets/models/ring/ring.txd", colPath = "files/assets/models/ring/ring.col"}
}


--------------------------------------
--[[ Function: Initializes Models ]]--
--------------------------------------

function initModels()

    for i, j in imports.pairs(Animify_Models) do
        j.modelID = imports.engineRequestModel("object", 16754)
        imports.engineImportTXD(imports.engineLoadTXD(j.txdPath), j.modelID)
        imports.engineReplaceCOL(imports.engineLoadCOL(j.colPath), j.modelID)
        imports.engineReplaceModel(imports.engineLoadDFF(j.dffPath), j.modelID, true)
    end

end