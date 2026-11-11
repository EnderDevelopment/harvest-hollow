# Harvest Hollow Roblox Farming Game

Harvest Hollow is an open-source Roblox farming game starter project that builds a playable farming map and adds crop planting, growth, harvesting, selling, upgrades, player stats, and a simple HUD.

## Install

1. Open your Roblox experience in Roblox Studio.
2. Add `FarmGame.server.lua` as a Script in `ServerScriptService`.
3. Add `FarmGame.client.lua` as a LocalScript in `StarterPlayer > StarterPlayerScripts`.
4. For saved player progress, publish the experience and enable Studio access to API services in its security settings.

## Use

1. Run the experience. The server script builds the farm map and garden beds.
2. Walk to an empty garden bed and press E to plant a seed. Each bed produces its assigned crop type.
3. Return when the crop is ready and press E to harvest it.
4. Visit the seed stand to refill up to five seeds, subject to your seed capacity.
5. Use the crop market to sell all harvested crops for coins.
6. Use the farm upgrades stand to buy the cheapest available upgrade you can afford: faster growth, better crop prices, or increased seed capacity.

Player stats and crop inventory appear in the HUD. Progress is saved through Roblox DataStore when data access is available.

---

More open source project projects by EnderDevelopment: https://github.com/EnderDevelopment

Project page: https://dash.enderdevelopment.com/community/42225c6f-9856-4b1c-9f62-737d18390fca?utm_source=github&utm_medium=readme&utm_campaign=auto_publish&utm_content=42225c6f-9856-4b1c-9f62-737d18390fca
