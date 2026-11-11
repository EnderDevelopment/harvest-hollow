-- Place this Script in ServerScriptService in Roblox Studio.
-- It builds a complete starter farm and handles planting, crop growth, harvesting, and seed rewards.

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local oldFarm = Workspace:FindFirstChild("HarvestHollow")
if oldFarm then
	oldFarm:Destroy()
end

local farm = Instance.new("Folder")
farm.Name = "HarvestHollow"
farm.Parent = Workspace

local function part(name, size, position, color, material, parent)
	local object = Instance.new("Part")
	object.Name = name
	object.Size = size
	object.Position = position
	object.Anchored = true
	object.Color = color
	object.Material = material or Enum.Material.SmoothPlastic
	object.TopSurface = Enum.SurfaceType.Smooth
	object.BottomSurface = Enum.SurfaceType.Smooth
	object.Parent = parent or farm
	return object
end

local function label(adornee, text)
	local gui = Instance.new("BillboardGui")
	gui.Name = "Sign"
	gui.Adornee = adornee
	gui.Size = UDim2.fromOffset(220, 60)
	gui.StudsOffset = Vector3.new(0, 3, 0)
	gui.AlwaysOnTop = true
	gui.Parent = adornee
	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.fromScale(1, 1)
	textLabel.BackgroundColor3 = Color3.fromRGB(67, 47, 28)
	textLabel.BackgroundTransparency = 0.12
	textLabel.TextColor3 = Color3.fromRGB(255, 244, 206)
	textLabel.TextScaled = true
	textLabel.Font = Enum.Font.GothamBold
	textLabel.Text = text
	textLabel.Parent = gui
end

-- Ground and welcoming farm decorations.
part("Meadow", Vector3.new(150, 1, 120), Vector3.new(0, -0.5, 0), Color3.fromRGB(103, 166, 77), Enum.Material.Grass)
part("Farmyard", Vector3.new(64, 0.3, 45), Vector3.new(0, 0.15, -28), Color3.fromRGB(194, 166, 117), Enum.Material.Ground)
part("MainPath", Vector3.new(10, 0.2, 75), Vector3.new(0, 0.12, 12), Color3.fromRGB(210, 190, 143), Enum.Material.Ground)

local barn = part("RedBarn", Vector3.new(24, 15, 18), Vector3.new(-36, 7.5, -32), Color3.fromRGB(166, 55, 43), Enum.Material.WoodPlanks)
part("BarnRoof", Vector3.new(27, 2, 21), Vector3.new(-36, 16, -32), Color3.fromRGB(89, 48, 39), Enum.Material.Slate)
part("BarnDoor", Vector3.new(7, 10, 0.4), Vector3.new(-36, 5, -22.8), Color3.fromRGB(106, 63, 43), Enum.Material.WoodPlanks)
label(barn, "HARVEST HOLLOW")

local shop = part("SeedStand", Vector3.new(14, 9, 12), Vector3.new(34, 4.5, -32), Color3.fromRGB(227, 181, 91), Enum.Material.WoodPlanks)
part("ShopRoof", Vector3.new(17, 1.5, 15), Vector3.new(34, 10, -32), Color3.fromRGB(86, 129, 74), Enum.Material.Wood)
label(shop, "FARM SHOP  •  SELL & UPGRADE")

local sellStand = part("CropSellStand", Vector3.new(12, 7, 10), Vector3.new(16, 3.5, -32), Color3.fromRGB(119, 157, 89), Enum.Material.WoodPlanks)
label(sellStand, "CROP MARKET")

local upgradeStand = part("UpgradeStand", Vector3.new(12, 7, 10), Vector3.new(0, 3.5, -32), Color3.fromRGB(103, 133, 171), Enum.Material.WoodPlanks)
label(upgradeStand, "FARM UPGRADES")

-- A simple fence around the play area.
for x = -70, 70, 10 do
	part("FencePost", Vector3.new(1, 3, 1), Vector3.new(x, 1.5, -57), Color3.fromRGB(120, 82, 49), Enum.Material.Wood)
	part("FencePost", Vector3.new(1, 3, 1), Vector3.new(x, 1.5, 57), Color3.fromRGB(120, 82, 49), Enum.Material.Wood)
end
for z = -57, 57, 10 do
	part("FencePost", Vector3.new(1, 3, 1), Vector3.new(-70, 1.5, z), Color3.fromRGB(120, 82, 49), Enum.Material.Wood)
	part("FencePost", Vector3.new(1, 3, 1), Vector3.new(70, 1.5, z), Color3.fromRGB(120, 82, 49), Enum.Material.Wood)
end

local plots = Instance.new("Folder")
plots.Name = "FarmPlots"
plots.Parent = farm
local plotStates = {}
local cropColors = {
	{ name = "Carrot", color = Color3.fromRGB(242, 129, 45), reward = 3 },
	{ name = "Wheat", color = Color3.fromRGB(244, 205, 83), reward = 2 },
	{ name = "Pumpkin", color = Color3.fromRGB(239, 112, 37), reward = 5 },
}

local function setPrompt(prompt, action)
	prompt.ActionText = action
end

local function grow(plot, crop, generation, growTime)
	task.wait(growTime)
	local state = plotStates[plot]
	if not state or state.generation ~= generation or state.crop ~= crop then
		return
	end
	state.ready = true
	crop.Color = Color3.fromRGB(65, 173, 69)
	crop.Size = Vector3.new(2.3, 2.6, 2.3)
	crop.Position = plot.Position + Vector3.new(0, 1.6, 0)
	local prompt = plot:FindFirstChildOfClass("ProximityPrompt")
	if prompt then
		setPrompt(prompt, "Harvest " .. state.cropName)
	end
end

local function makePlot(index, x, z)
	local bed = part("Plot" .. index, Vector3.new(9, 0.8, 9), Vector3.new(x, 0.55, z), Color3.fromRGB(102, 68, 43), Enum.Material.Ground, plots)
	bed:SetAttribute("PlotIndex", index)
	local prompt = Instance.new("ProximityPrompt")
	prompt.Name = "FarmPrompt"
	prompt.ActionText = "Plant"
	prompt.ObjectText = "Empty garden bed"
	prompt.HoldDuration = 0.35
	prompt.MaxActivationDistance = 12
	prompt.RequiresLineOfSight = false
	prompt.Parent = bed
	plotStates[bed] = { generation = 0, crop = nil, ready = false }

	prompt.Triggered:Connect(function(player)
		local state = plotStates[bed]
		if not state then return end
		local stats = player:FindFirstChild("leaderstats")
		local seeds = stats and stats:FindFirstChild("Seeds")
		local coins = stats and stats:FindFirstChild("Coins")
		if not seeds or not coins then return end

		if not state.crop then
			if seeds.Value <= 0 then
				prompt.ObjectText = "Visit the seed stand for seeds"
				task.delay(2, function()
					if prompt.Parent then prompt.ObjectText = "Empty garden bed" end
				end)
				return
			end
			seeds.Value -= 1
			local cropType = cropColors[((index - 1) % #cropColors) + 1]
			local crop = part(cropType.name, Vector3.new(1.2, 0.7, 1.2), bed.Position + Vector3.new(0, 0.9, 0), Color3.fromRGB(116, 190, 76), Enum.Material.Grass, bed)
			crop.CanCollide = false
			state.generation += 1
			state.crop = crop
			state.cropName = cropType.name
			state.reward = cropType.reward
			state.ready = false
			prompt.ObjectText = cropType.name .. " growing"
			setPrompt(prompt, "Growing...")
			local speedLevel = player:FindFirstChild("FarmUpgrades") and player.FarmUpgrades:FindFirstChild("GrowthSpeed")
			local growTime = math.max(4, 12 - ((speedLevel and speedLevel.Value or 0) * 2))
			grow(bed, crop, state.generation, growTime)
		elseif state.ready then
			local inventory = player:FindFirstChild("CropInventory")
			local cropCount = inventory and inventory:FindFirstChild(state.cropName)
			if cropCount then cropCount.Value += 1 end
			state.crop:Destroy()
			state.crop = nil
			state.ready = false
			state.generation += 1
			prompt.ObjectText = "Empty garden bed"
			setPrompt(prompt, "Plant")
		else
			prompt.ObjectText = state.cropName .. " needs a little more time"
			task.delay(2, function()
				if prompt.Parent and plotStates[bed] then
					prompt.ObjectText = plotStates[bed].cropName .. " growing"
				end
			end)
		end
	end)
	return bed
end

local index = 0
for row = 0, 2 do
	for column = 0, 4 do
		index += 1
		makePlot(index, -23 + column * 11.5, 4 + row * 11.5)
	end
end

local function setupPlayer(player)
	local stats = Instance.new("Folder")
	stats.Name = "leaderstats"
	stats.Parent = player
	local coins = Instance.new("IntValue")
	coins.Name = "Coins"
	coins.Value = 0
	coins.Parent = stats
	local seeds = Instance.new("IntValue")
	seeds.Name = "Seeds"
	seeds.Value = 6
	seeds.Parent = stats

	local inventory = Instance.new("Folder")
	inventory.Name = "CropInventory"
	inventory.Parent = player
	for _, cropType in ipairs(cropColors) do
		local count = Instance.new("IntValue")
		count.Name = cropType.name
		count.Value = 0
		count.Parent = inventory
	end

	local upgrades = Instance.new("Folder")
	upgrades.Name = "FarmUpgrades"
	upgrades.Parent = player
	for _, upgradeName in ipairs({ "GrowthSpeed", "HarvestValue", "SeedCapacity" }) do
		local level = Instance.new("IntValue")
		level.Name = upgradeName
		level.Value = 0
		level.Parent = upgrades
	end
end
Players.PlayerAdded:Connect(setupPlayer)
for _, player in ipairs(Players:GetPlayers()) do
	setupPlayer(player)
end

-- The seed stand gives a small starter refill when a player interacts with it.
local sellPrompt = Instance.new("ProximityPrompt")
sellPrompt.Name = "SellCrops"
sellPrompt.ActionText = "Sell all crops"
sellPrompt.ObjectText = "Crop market"
sellPrompt.HoldDuration = 0.5
sellPrompt.MaxActivationDistance = 12
sellPrompt.RequiresLineOfSight = false
sellPrompt.Parent = sellStand
sellPrompt.Triggered:Connect(function(player)
	local inventory = player:FindFirstChild("CropInventory")
	local stats = player:FindFirstChild("leaderstats")
	local coins = stats and stats:FindFirstChild("Coins")
	if not inventory or not coins then return end
	local upgrade = player:FindFirstChild("FarmUpgrades") and player.FarmUpgrades:FindFirstChild("HarvestValue")
	local multiplier = 1 + ((upgrade and upgrade.Value or 0) * 0.25)
	local prices = { Carrot = 3, Wheat = 2, Pumpkin = 5 }
	local total = 0
	for cropName, basePrice in pairs(prices) do
		local count = inventory:FindFirstChild(cropName)
		if count then
			total += math.floor(count.Value * basePrice * multiplier)
			count.Value = 0
		end
	end
	coins.Value += total
	sellPrompt.ActionText = total > 0 and ("Sold for " .. total .. " coins") or "No crops to sell"
	task.delay(2, function()
		if sellPrompt.Parent then sellPrompt.ActionText = "Sell all crops" end
	end)
end)

local upgradeCosts = { GrowthSpeed = 20, HarvestValue = 25, SeedCapacity = 15 }
local upgradeLabels = { GrowthSpeed = "Faster growth", HarvestValue = "Better prices", SeedCapacity = "Seed capacity" }
local upgradePrompt = Instance.new("ProximityPrompt")
upgradePrompt.Name = "BuyUpgrade"
upgradePrompt.ActionText = "Buy upgrade"
upgradePrompt.ObjectText = "Farm upgrades"
upgradePrompt.HoldDuration = 0.5
upgradePrompt.MaxActivationDistance = 12
upgradePrompt.RequiresLineOfSight = false
upgradePrompt.Parent = upgradeStand
upgradePrompt.Triggered:Connect(function(player)
	local stats = player:FindFirstChild("leaderstats")
	local coins = stats and stats:FindFirstChild("Coins")
	local upgrades = player:FindFirstChild("FarmUpgrades")
	if not coins or not upgrades then return end
	local chosenName, chosenLevel, chosenCost
	for _, name in ipairs({ "GrowthSpeed", "HarvestValue", "SeedCapacity" }) do
		local level = upgrades:FindFirstChild(name)
		local cost = upgradeCosts[name] * ((level and level.Value or 0) + 1)
		if level and level.Value < 3 and coins.Value >= cost and (not chosenCost or cost < chosenCost) then
			chosenName, chosenLevel, chosenCost = name, level, cost
		end
	end
	if not chosenName then
		upgradePrompt.ActionText = "Need coins or max level"
	else
		coins.Value -= chosenCost
		chosenLevel.Value += 1
		upgradePrompt.ActionText = upgradeLabels[chosenName] .. " Lv. " .. chosenLevel.Value
	end
	task.delay(2, function()
		if upgradePrompt.Parent then upgradePrompt.ActionText = "Buy upgrade" end
	end)
end)

local refillPrompt = Instance.new("ProximityPrompt")
refillPrompt.Name = "SeedRefill"
refillPrompt.ActionText = "Get 5 free seeds"
refillPrompt.ObjectText = "Seed stand"
refillPrompt.HoldDuration = 0.5
refillPrompt.MaxActivationDistance = 12
refillPrompt.RequiresLineOfSight = false
refillPrompt.Parent = shop
refillPrompt.Triggered:Connect(function(player)
	local stats = player:FindFirstChild("leaderstats")
	local seeds = stats and stats:FindFirstChild("Seeds")
	if seeds then
		local upgrade = player:FindFirstChild("FarmUpgrades") and player.FarmUpgrades:FindFirstChild("SeedCapacity")
		local capacity = 6 + ((upgrade and upgrade.Value or 0) * 5)
		seeds.Value = math.min(capacity, seeds.Value + 5)
		refillPrompt.ActionText = "Seeds added!"
		task.delay(1.5, function()
			if refillPrompt.Parent then refillPrompt.ActionText = "Get 5 free seeds" end
		end)
	end
end)
