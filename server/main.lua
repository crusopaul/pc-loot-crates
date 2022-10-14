local QBCore = exports['qb-core']:GetCoreObject()

CreateThread(function()
    for k,v in pairs(Config.Server.LootCrates) do
        if QBCore.Shared.Items[k] then
            for _,q in ipairs(v.LootTable) do
                if not QBCore.Shared.Items[q.Item] then
                    print('Error: Item "'..q.Item..'" not in qb-core/shared/items.lua (from '..k.."'s loot table)")
                end
            end

            QBCore.Functions.CreateUseableItem(k, function(source, item)
                local player = QBCore.Functions.GetPlayer(source)
                local lootBoxItemName = item.name
                local lootBoxSlot = item.slot
                local lootBoxLabel = QBCore.Shared.Items[lootBoxItemName].label

                if player.Functions.GetItemByName(lootBoxItemName) then
                    TriggerClientEvent('pc-loot-crates:client:OpenCrate', source, lootBoxItemName, lootBoxLabel, lootBoxSlot)
                end
            end)

            for l,_ in ipairs(v.LootTable) do
                if l ~= 1 then
                    v.LootTable[l].Chances += v.LootTable[l - 1].Chances
                end
            end
        else
            print('Error: Item "'..k..'" not in qb-core/shared/items.lua')
        end
    end
end)

RegisterNetEvent('pc-loot-crates:server:DropLoot', function(lootBoxItemName, lootBoxSlot)
    local player = QBCore.Functions.GetPlayer(source)

    if player.Functions.RemoveItem(lootBoxItemName, 1, lootBoxSlot) then
        TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[lootBoxItemName], "remove")

        local lootCrate = Config.Server.LootCrates[lootBoxItemName]
        local lootTable = lootCrate.LootTable
        local lootTableSize = #lootTable
        local numberOfItemsRoll = 0
        local itemRoll = 0
        local lootItem = nil

        if lootCrate.MinDrops ~= lootCrate.MaxDrops then
            numberOfItemsRoll = math.random(lootCrate.MinDrops, lootCrate.MaxDrops)
        else
            numberOfItemsRoll = lootCrate.MinDrops
        end

        for i=1,numberOfItemsRoll do
            itemRoll = math.random(1, lootTable[lootTableSize].Chances)

            for l,q in ipairs(lootTable) do
                if l == 1 then
                    if itemRoll <= q.Chances then
                        lootItem = q.Item
                    end
                elseif itemRoll > lootTable[l - 1].Chances and itemRoll <= q.Chances then
                    lootItem = q.Item
                end
            end

            if player.Functions.AddItem(lootItem, 1) then
                TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[lootItem], "add")
            else
                if i == 1 and player.Functions.AddItem(lootBoxItemName, 1) then
                    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[lootBoxItemName], "add")
                else
                    TriggerClientEvent('QBCore:Notify', source, 'Could not reimburse loot crate '..lootBoxItemName)
                end

                break
            end
        end
    end

    TriggerClientEvent('pc-loot-crates:client:MakeInvAvailable', source)
end)
