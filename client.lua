local currentInterior = "n_church"

local function SetInterior(interiorType)
    local interiorId = GetInteriorAtCoords(SharedConfig.interiorCoords.x, SharedConfig.interiorCoords.y, SharedConfig.interiorCoords.z)
    if IsInteriorEntitySetActive(interiorId, currentInterior) then
        DeactivateInteriorEntitySet(interiorId, currentInterior)
        lib.print.debug(string.format("Deactivating interior: %s", currentInterior))
    end
    ActivateInteriorEntitySet(interiorId, interiorType)
    lib.print.debug(string.format("Activating interior: %s", interiorType))
    RefreshInterior(interiorId)
    currentInterior = interiorType
end

local function RequestInteriorChange(id)
    if not id then
        lib.notify({
            type = "error",
            title = "Error",
            description = "Invalid interior ID.",
            duration = 6500,
            position = "center-right",
        })
        return
    end

    if id == currentInterior then
        lib.notify({
            type = "error",
            title = "Error",
            description = "Interior is already set to this ID.",
            duration = 6500,
            position = "center-right",
        })
        return
    end

    local success = lib.callback.await("ChurchInterior:Change", false, id)
    if not success then
        lib.notify({
            type = "error",
            title = "Error",
            description = "Failed to change interior.",
            duration = 6500,
            position = "center-right",
        })
    end

    lib.notify({
        type = "success",
        title = "Success",
        description = ("Interior has been changed to: %s"):format(SharedConfig.Presets[id].name),
        duration = 6500,
        position = "center-right",
    })
end

RegisterNetEvent("ChurchInterior:InteriorChanged", function(id)
    lib.print.debug(string.format("Changing interior to: %s", id))
    SetInterior(id)
end)

CreateThread(function()
    SetInterior(GlobalState.churchInterior)
end)

local interiorOptions = {}
for id, data in pairs(SharedConfig.Presets) do
    interiorOptions[#interiorOptions + 1] = {
        title = data.name,
        onSelect = function()
            RequestInteriorChange(id)
        end
    }
end

lib.registerContext({
    id = "select_churchinterior",
    title = "Select Church Interior",
    options = interiorOptions,
})

RegisterNetEvent("ChurchInterior:OpenMenu", function()
    lib.showContext("select_churchinterior")
end)
