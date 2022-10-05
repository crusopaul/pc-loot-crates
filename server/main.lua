local QBCore = exports['qb-core']:GetCoreObject()

for k,v in pairs(Config.LootCrates) do
    if QBCore.ShareItems[k] then
        QBCore.Functions.CreateUseableItem(k, function(source, item)
            local player = QBCore.Functions.GetPlayer(source)

            if player.Functions.GetItemByName(item.name) then
                TriggerClientEvent('pc-loot-crates:client:OpenCrate', source, item)
            end
        end)

        for l,q in ipairs(v.LootTable) do
            if v.LootTable[l - 1] then
                v.LootTable[l].Chances += v.LootTable[l - 1].Chances
            end
        end
    else
        print(Lang:t('Errors.MissingItem'))
    end
end

RegisterNetEvent('pc-loot-crates:server:RemoveLootCrate', function(item)
    local player = QBCore.Functions.GetPlayer(source)

    if player.Functions.RemoveItem(item, 1) then
        TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[item], "remove", 1)
    end
end)

RegisterNetEvent('pc-loot-crates:server:DropLoot', function(item)
    local player = QBCore.Functions.GetPlayer(source)
    local lootCrate = Config.LootCrates[item]
    local lootTable = lootCrate.LootTable
    local lootTableSize = #lootTable
    local numberOfItemsRoll = math.random(lootCrate.MinDrops, lootCrate.MaxDrops)
    local itemRoll = 0
    local item = nil

    for i=1,numberOfItemsRoll do
        itemRoll = math.random(1, lootTable[lootTableSize].Chances)

        for l,q in ipairs(lootTable) do
            if itemRoll <= q.Chances then
                item = q.Item
            else
                break
            end
        end

        if player.Functions.AddItem(item, 1) then
            TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[item], "add", 1)
        end
    end
end)
