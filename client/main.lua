local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('pc-loot-crates:client:OpenCrate', function(item)
    if not LocalPlayer.state.inv_busy then
        LocalPlayer.state:set("inv_busy", true, true)
        TriggerEvent('inventory:client:busy:status', true)
        QBCore.Functions.Progressbar(
            'pc-loot-crate:OpeningCrate',
            'Opening '..QBCore.Shared.Items[item].label..'..',
            math.random(3000,4000),
            false,
            false,
            {
                disableMovement = false,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = true,
            },
            {},
            {},
            {},
            function() end,
            function()
                TriggerServerEvent('pc-loot-crates:server:DropLoot', item)
            end
        )
    end
end)

RegisterNetEvent('pc-loot-crates:client:MakeInvAvailable', function()
    LocalPlayer.state:set("inv_busy", false, true)
    TriggerEvent('inventory:client:busy:status', false)
end)
