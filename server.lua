local selectedInterior = "n_church"
GlobalState.churchInterior = selectedInterior

lib.callback.register("ChurchInterior:Change", function(source, id)
    if not id then
        print(string.format("%s [%s] tried to change the interior but did not provide a valid ID.", GetPlayerName(source), source))
        return false
    end

    local hasPerms = IsPlayerAceAllowed(source, "command.churchinterior")
    if not hasPerms then
        print(string.format("%s [%s] tried to change the interior but does not have the correct ace permissions.", GetPlayerName(source), source))
        return false
    end

    if selectedInterior == id then
        print(string.format("%s [%s] tried to change the interior but it is already set to %s.", GetPlayerName(source), source, SharedConfig.Presets[id].name))
        return false
    end

    if not SharedConfig.Presets[id] then
        print(string.format("%s [%s] tried to change the interior but the ID is invalid.", GetPlayerName(source), source))
        return false
    end

    selectedInterior = id
    GlobalState.churchInterior = id
    TriggerClientEvent("ChurchInterior:InteriorChanged", -1, id)
    print(string.format("%s [%s] changed the interior to %s.", GetPlayerName(source), source, SharedConfig.Presets[id].name))
    return true
end)

RegisterCommand("churchinterior", function(source)
    TriggerClientEvent("ChurchInterior:OpenMenu", source)
end, true)
