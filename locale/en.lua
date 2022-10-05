local Translations = {
    Errors = {
        'MissingItem' = '~r~Error: Item "'..k..'" not in qb-core/shared/items.lua'
    }
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
