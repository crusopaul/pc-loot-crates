local QBCore = exports['qb-core']:GetCoreObject()

AddEventHandler('onResourceStarting', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        for k,v in pairs(Config.LootCrates) do
            if QBCore.Shared.Items[k] then
                for _,q in ipairs(v.LootTable) do
                    if not QBCore.Shared.Items[q.Item] then
                        print('~r~Error: Item "'..q.Item..'" not in qb-core/shared/items.lua (from '..k.."'s loot table)")
                        CancelEvent()
                    end
                end

                if ~WasEventCanceled() then
                    QBCore.Functions.CreateUseableItem(k, function(source, item)
                        if Config.Debug then
                            print('~y~Usable item callback fired: '..tostring(source)..', '..item.name)
                        end

                        local player = QBCore.Functions.GetPlayer(source)
                        local lootBoxItemName = item.name
                        local lootBoxSlot = item.slot
                        local lootBoxLabel = iQBCore.Shared.Items.[lootBoxItemName].label

                        if player.Functions.GetItemByName(lootBoxItemName) then
                            if Config.Debug then
                                print('~y~Firing event "pc-loot-crates:client:OpenCrate": '..tostring(source)..', '..lootBoxItemName..', '..lootBoxLabel..', '..tostring(lootBoxSlot))
                            end

                            TriggerClientEvent('pc-loot-crates:client:OpenCrate', source, lootBoxItemName, lootBoxLabel, lootBoxSlot)
                        elseif Config.Debug then
                            print('~y~Could not locate "'..lotBoxItemName..'" on player '..tostring(source))
                        end
                    end)

                    for l,_ in ipairs(v.LootTable) do
                        if l ~= 1 then
                            v.LootTable[l].Chances += v.LootTable[l - 1].Chances
                        end
                    end
                end
            else
                print('~r~Error: Item "'..k..'" not in qb-core/shared/items.lua')
                CancelEvent()
            end
        end

        if WasEventCanceled() then
            print('~r~pc-loot-crates failed to start')
        end
    end
end)

RegisterNetEvent('pc-loot-crates:server:DropLoot', function(lootBoxItemName, slot)
    if Config.Debug then
        print('~y~Event "pc-loot-crates:server:DropLoot" fired: '..lootBoxItemName..', '..tostring(slot))
    end

    local player = QBCore.Functions.GetPlayer(source)

    if player.Functions.RemoveItem(lootBoxItemName, 1, slot) then
        if Config.Debug then
            print('~y~Firing event "inventory:client:ItemBox": '..tostring(source)..', '..lootBoxItemName..', remove')
        end

        TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[lootBoxItemName], "remove")

        local lootCrate = Config.LootCrates[lootBoxItemName]
        local lootTable = lootCrate.LootTable
        local lootTableSize = #lootTable
        local numberOfItemsRoll = math.random(lootCrate.MinDrops, lootCrate.MaxDrops)
        local itemRoll = 0
        local lootItem = nil

        for i=1,numberOfItemsRoll do
            itemRoll = math.random(1, lootTable[lootTableSize].Chances)

            for l,q in ipairs(lootTable) do
                if itemRoll <= q.Chances then
                    lootItem = q.Item
                else
                    break
                end
            end

            if player.Functions.AddItem(lootItem, 1) then
                if Config.Debug then
                    print('~y~Firing event "inventory:client:ItemBox": '..tostring(source)..', '..lootItem..', add')
                end

                TriggerClientEvent('inventory:client:ItemBox', QBCore.Shared.Items[lootItem], "add")
            elseif Config.Debug then
                print('~y~Could not add "'..lootItem..'"')
            end
        end
    elseif Config.Debug then
        print('~y~Could not remove "'..lootBoxItemName..'" from slot '..tostring(slot))
    end

    if Config.Debug then
        print('~y~Firing event "pc-loot-crates:client:MakeInvAvailable": '..tostring(source))
    end

    TriggerClientEvent('pc-loot-crates:client:MakeInvAvailable', source)
end)
