# Roblox Farming Map Open Source Project

Harvest Hollow is an open source Roblox farming map and starter farming game built with Lua scripts for Roblox Studio. It provides a playable farm environment with garden plots, crop planting, crop growth, harvesting, crop inventory, coin rewards, seed refills, farm upgrades, interactive stands, and a player HUD.

## Install

1. Create or open a Roblox experience in Roblox Studio.
2. In Explorer, create a Script inside `ServerScriptService`.
3. Copy the contents of `FarmGame.server.lua` into the Script.
4. In Explorer, create a LocalScript inside `StarterPlayer > StarterPlayerScripts`.
5. Copy the contents of `FarmGame.client.lua` into the LocalScript.
6. Save and run the experience in Play mode.

The server script creates the farm map and gameplay objects when the server starts. The client script creates the player HUD after the player joins.

## Use

1. Walk to an empty garden bed.
2. Press the displayed interaction key to plant a crop.
3. Wait for the crop to grow.
4. Return to the garden bed and interact with it again to harvest.
5. Harvested crops appear in the HUD inventory.
6. Visit the Crop Market stand and interact with it to sell all stored crops for coins.
7. Visit the Seed Stand to receive up to five additional seeds, limited by your current seed capacity.
8. Visit the Farm Upgrades stand to purchase the next available upgrade when you have enough coins.
9. Use the HUD to monitor coins, seeds, and crop inventory.

The available crops are Carrot, Wheat, and Pumpkin. Growth speed, harvest value, and seed capacity can each be upgraded up to level 3. Player values are created when the player joins the server.

---

More open source project projects by EnderDevelopment: https://github.com/EnderDevelopment

Project page: https://dash.enderdevelopment.com/community/42225c6f-9856-4b1c-9f62-737d18390fca?utm_source=github&utm_medium=readme&utm_campaign=auto_publish&utm_content=42225c6f-9856-4b1c-9f62-737d18390fca
