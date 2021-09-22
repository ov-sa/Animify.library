----------------------------------------------------------------
--[[ Resource: Animify Library
     Script: gui: viewportUI.lua
     Server: -
     Author: OvileAmriam
     Developer: -
     DOC: 08/09/2021 (OvileAmriam)
     Desc: View-Port UI ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    pairs = pairs,
    ipairs = ipairs
}


-------------------
--[[ Variables ]]--
-------------------

viewportUI = {

    sliders = {
        marginY = 5, paddingY = 5,
        width = 200, height = 24,
        {
            title = "PED ROTATION",
            sliderType = "ped_rotation",
            defaultPercent = 100
        },
        {
            title = "CAMERA ROTATION",
            sliderType = "camera_rotation",
            defaultPercent = 100
        },
        {
            title = "CAMERA FOV",
            sliderType = "camera_fov",
            defaultPercent = 100
        }
    },

    labels = {
        marginY = 20, paddingX = 5, paddingY = 5,
        width = 300, height = 20,
        color = {200, 200, 200, 255},
        {
            prefix = "SELECTED BONE:  ",
            labelType = "bone_id"
        },
        {
            prefix = "SELECTED AXIS:  ",
            labelType = "axis_id"
        }
    }

}


----------------------------------------
--[[ Function: Creates View-Port UI ]]--
----------------------------------------

function createViewPortUI()

    -->> View-Port UI <<--
    viewportUI.sliders.__endY = 0
    for i, j in imports.ipairs(viewportUI.sliders) do
        local viewport_slider_width, viewport_slider_height = viewportUI.sliders.width, viewportUI.sliders.height
        local viewport_slider_startX, viewport_slider_startY = CLIENT_MTA_RESOLUTION[1] - viewport_slider_width, viewportUI.sliders.marginY + ((viewport_slider_height + viewportUI.sliders.paddingY)*(i - 1))
        j.createdElement = beautify.slider.create(viewport_slider_startX, viewport_slider_startY, viewport_slider_width, viewport_slider_height, "horizontal", nil, false)
        beautify.slider.setText(j.createdElement, j.title)
        beautify.slider.setPercent(j.createdElement, j.defaultPercent)
        beautify.setUIVisible(j.createdElement, true)
        if i == #viewportUI.sliders then
            viewportUI.sliders.__endY = viewport_slider_startY + viewport_slider_height + viewportUI.sliders.paddingY
        end
    end
    viewportUI.labels.__endY = viewportUI.sliders.__endY
    for i, j in imports.ipairs(viewportUI.labels) do
        local viewport_label_width, viewport_label_height = viewportUI.labels.width, viewportUI.labels.height
        local viewport_label_startX, viewport_label_startY = CLIENT_MTA_RESOLUTION[1] - viewport_label_width - viewportUI.labels.paddingX, viewportUI.sliders.__endY + viewportUI.labels.marginY + ((viewport_label_height + viewportUI.labels.paddingY)*(i - 1))
        j.createdElement = beautify.label.create("", viewport_label_startX, viewport_label_startY, viewport_label_width, viewport_label_height, nil, false)
        beautify.label.setColor(j.createdElement, viewportUI.labels.color)
        beautify.label.setHorizontalAlignment(j.createdElement, "right")
        beautify.label.setVerticalAlignment(j.createdElement, "center")
        beautify.setUIDisabled(j.createdElement, true)
        beautify.setUIVisible(j.createdElement, true)
        if i == #viewportUI.labels then
            viewportUI.labels.__endY = viewport_label_startY + viewport_label_height + viewportUI.labels.paddingY
        end
    end
    return true

end