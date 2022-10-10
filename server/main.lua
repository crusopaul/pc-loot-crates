local QBCore = exports['qb-core']:GetCoreObject()

CreateThread(function()
    for k,v in pairs(Config.LootCrates) do
        if QBCore.Shared.Items[k] then
            QBCore.Functions.CreateUseableItem(k, function(source, item)
                local player = QBCore.Functions.GetPlayer(source)
                local lootBoxItemName = item.name
                local lootBoxSlot = item.slot

                if player.Functions.GetItemByName(lootBoxItemName) then
                    TriggerClientEvent('pc-loot-crates:client:OpenCrate', source, lootBoxItemName, QBCore.Shared.Items.[lootBoxItemName].label, lootBoxSlot)
                end
            end)

            for l,_ in ipairs(v.LootTable) do
                if l ~= 1 then
                    v.LootTable[l].Chances += v.LootTable[l - 1].Chances
                end
            end
        else
            print('~r~Error: Item "'..k..'" not in qb-core/shared/items.lua')
        end

        for _,q in ipairs(v.LootTable) do
            if not QBCore.Shared.Items[q.Item] then
                print('~r~Error: Item "'..q.Item..'" not in qb-core/shared/items.lua (from '..k.."'s loot table)")
            end
        end
    end
end)

RegisterNetEvent('pc-loot-crates:server:DropLoot', function(lootBoxItemName, slot)
    local player = QBCore.Functions.GetPlayer(source)
    TriggerClientEvent('pc-loot-crates:client:MakeInvAvailable', source)

    if player.Functions.RemoveItem(lootBoxItemName, 1, slot) then
        TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[lootBoxItemName], "remove", 1)

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
                TriggerClientEvent('inventory:client:ItemBox', QBCore.Shared.Items[lootItem], "add", 1)
            end
        end
    end
end)
