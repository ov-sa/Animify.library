----------------------------------------------------------------
--[[ Resource: Animify Library
     Script: configurations: templates: slider.lua
     Server: -
     Author: OvileAmriam
     Developer: -
     DOC: 08/09/2021 (OvileAmriam)
     Desc: Template's Confign ]]--
----------------------------------------------------------------


------------------------
--[[ Configurations ]]--
------------------------

availableTemplates["beautify_slider"] = {

    ["ov-dark-theme"] = {},

    ["dark-blue-theme"] = {
        fontColor = {200, 200, 200, 255},
        track = {
            progressedColor = {125, 125, 255, 255},
            unprogressedColor = {15, 15, 15, 255}
        },
        thumb = {
            color = {125, 125, 255, 255}
        }
    },

    ["dark-red-theme"] = {
        fontColor = {200, 200, 200, 255},
        track = {
            progressedColor = {255, 125, 125, 255},
            unprogressedColor = {15, 15, 15, 255}
        },
        thumb = {
            color = {255, 125, 125, 255}
        }
    },

    ["dark-green-theme"] = {
        fontColor = {200, 200, 200, 255},
        track = {
            progressedColor = {125, 255, 125, 255},
            unprogressedColor = {15, 15, 15, 255}
        },
        thumb = {
            color = {125, 255, 125, 255}
        }
    },

    ["dark-yellow-theme"] = {
        fontColor = {200, 200, 200, 255},
        track = {
            progressedColor = {255, 255, 125, 255},
            unprogressedColor = {15, 15, 15, 255}
        },
        thumb = {
            color = {255, 255, 125, 255}
        }
    }

}