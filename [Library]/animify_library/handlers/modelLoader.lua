----------------------------------------------------------------
--[[ Resource: Animify Library
     Script: handlers: modelLoader.lua
     Server: -
     Author: OvileAmriam
     Developer: -
     DOC: 08/09/2021 (OvileAmriam)
     Desc: Model Loader ]]--
----------------------------------------------------------------


-------------------
--[[ Variables ]]--
-------------------

Animify_Models = {
    spawnDisc = {dffPath = "files/assets/models/disc/disc.dff", txdPath = "files/assets/models/disc/disc.txd", colPath = "files/assets/models/disc/disc.col"},
    axisRing = {dffPath = "files/assets/models/ring/ring.dff", txdPath = "files/assets/models/ring/ring.txd", colPath = "files/assets/models/ring/ring.col"}
}


--------------------------------------
--[[ Function: Initializes Models ]]--
--------------------------------------

function initModels()

    for i, j in pairs(Animify_Models) do
        j.modelID = engineRequestModel("object", 16754)
        engineImportTXD(engineLoadTXD(j.txdPath), j.modelID)
        engineReplaceCOL(engineLoadCOL(j.colPath), j.modelID)
        engineReplaceModel(engineLoadDFF(j.dffPath), j.modelID, true)
    end

end