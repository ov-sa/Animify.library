  
----------------------------------------------------------------
--[[ Resource: Animify Library
     Script: settings: client.lua
     Server: -
     Author: OvileAmriam
     Developer: -
     DOC: 08/09/2021 (OvileAmriam)
     Desc: Client Sided Settings ]]--
----------------------------------------------------------------


------------------
--[[ Settings ]]--
------------------

availablePedBones = {
    --[[
    --TODO: Make all axis rotation relative to the Root Bone (Better)
    [0] = {
        axes = {x = "y", y = "z", z = "x"}
    },]]
    [1] = {
        name = "Pelvis 1",
        axes = {x = "y", y = "x"}
    },
    [2] = {
        name = "Pelvis 2",
        axes = {}
    },
    [3] = {
        name = "Spine",
        axes = {}
    },
    [4] = {
        name = "Neck 1",
        axes = {}
    },
    [5] = {
        name = "Neck 2",
        axes = {}
    },
    [6] = {
        name = "Head 2",
        axes = {}
    },
    [7] = {
        name = "Head 3",
        axes = {}
    },
    [8] = {
        name = "Head 1",
        axes = {}
    },
    [21] = {
        name = "Right Upper-Torso",
        axes = {}
    },
    [22] = {
        name = "Right Shoulder",
        axes = {x = "y", y = "x"}
    },
    [23] = {
        name = "Right Elbow",
        axes = {}
    },
    [24] = {
        name = "Right Wrist",
        axes = {}
    },
    [25] = {
        name = "Right Hand",
        axes = {y = "z", z = "y"}
    },
    [26] = {
        name = "Right Thumb",
        axes = {x = "z", y = "x", z = "y"}
    },
    [31] = {
        name = "Left Upper-Torso",
        axes = {x = "z", z = "x"}
    },
    [32] = {
        name = "Left Shoulder",
        --TODO: FOR SWAPPING AXIS FOR BONES
        axes = {}
        --axes = {x = "y", y = "x"}
    },
    [33] = {
        name = "Left Elbow",
        axes = {}
    },
    [34] = {
        name = "Left Wrist",
        axes = {}
    },
    [35] = {
        name = "Left Hand",
        axes = {y = "z", z = "y"}
    },
    [36] = {
        name = "Left Thumb",
        axes = {x = "z", y = "x", z = "y"}
    },
    [41] = {
        name = "Left Hip",
        axes = {}
    },
    [42] = {
        name = "Left Knee",
        axes = {}
    },
    [43] = {
        name = "Left Ankle",
        axes = {}
    },
    [44] = {
        name = "Left Foot",
        axes = {x = "z", z = "x"}
    },
    [51] = {
        name = "Right Hip",
        axes = {}
    },
    [52] = {
        name = "Right Knee",
        axes = {}
    },
    [53] = {
        name = "Right Ankle",
        axes = {}
    },
    [54] = {
        name = "Right Foot",
        axes = {x = "z", z = "x"}
    }
    --[[
    --Unsupported right now
    [201] = {
        axes = {}
    },
    [301] = {
        axes = {}
    },
    [302] = {
        axes = {}
    }]]
}
