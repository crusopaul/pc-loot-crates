local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('pc-loot-crates:client:OpenCrate', function(lootBoxItemName, label, slot)
    if Config.Debug then
        print('~y~Event "pc-loot-crates:server:DropLoot" fired: '..lootBoxItemName..', '..label..', '..tostring(slot))
    end

    if not LocalPlayer.state.inv_busy then
        if Config.Debug then
            print('~y~Firing event "inventory:client:busy:status": true')
        end

        LocalPlayer.state:set("inv_busy", true, true)
        TriggerEvent('inventory:client:busy:status', true)
        QBCore.Functions.Progressbar(
            'pc-loot-crate:OpeningCrate',
            'Opening '..(label or '')..'..',
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
                if Config.Debug then
                    print('~y~Progressbar callback fired')
                    print('~y~Firing event "pc-loot-crates:server:DropLoot": '..lootBoxItemName..', '..tostring(slot))
                end

                TriggerServerEvent('pc-loot-crates:server:DropLoot', lootBoxItemName, slot)
            end
        )
    elseif Config.Debug then
        print('~y~Inventory is busy')
    end
end)

RegisterNetEvent('pc-loot-crates:client:MakeInvAvailable', function()
    if Config.Debug then
        print('~y~Event "pc-loot-crates:client:MakeInvAvailable" fired')
        print('~y~Firing event "inventory:client:busy:status": false')
    end

    LocalPlayer.state:set("inv_busy", false, true)
    TriggerEvent('inventory:client:busy:status', false)
end)
