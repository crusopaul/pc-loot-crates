# pc-loot-crates
A generic loot crate resource for qb-core

## Installation
To install pc-loot-crates, one must copy all images from html/images into the corresponding folder for the relevant inventory system.

Additionally, any custom item entries or loot crates must be added to qb-core/shared/items.lua.
```
['lootcrate'] = {['name'] = 'lootcrate', [label'] = 'Loot Crate', ['weight'] = 100, ['type'] = 'item', ['ammotype'] = nil, ['image'] = 'lootcrate.png', ['unique'] = true, ['useable'] = false, ['description'] = 'A crate of loot'},
```
