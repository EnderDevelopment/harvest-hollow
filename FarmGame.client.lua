-- Place this LocalScript in StarterPlayer > StarterPlayerScripts in Roblox Studio.
-- It adds a friendly HUD and controls for the Harvest Hollow farming game.

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local gui = Instance.new("ScreenGui")
gui.Name = "HarvestHollowHUD"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local function roundedFrame(parent, size, position, color, transparency)
	local frame = Instance.new("Frame")
	frame.Size = size
	frame.Position = position
	frame.BackgroundColor3 = color
	frame.BackgroundTransparency = transparency or 0
	frame.BorderSizePixel = 0
	frame.Parent = parent
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 14)
	corner.Parent = frame
	return frame
end

local function text(parent, value, size, position, font, color)
	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Size = size
	label.Position = position
	label.Text = value
	label.TextColor3 = color or Color3.fromRGB(255, 248, 221)
	label.TextScaled = true
	label.Font = font or Enum.Font.GothamBold
	label.Parent = parent
	return label
end

local banner = roundedFrame(gui, UDim2.fromOffset(330, 104), UDim2.fromOffset(22, 22), Color3.fromRGB(54, 83, 45), 0.05)
text(banner, "HARVEST HOLLOW", UDim2.new(1, -20, 0, 38), UDim2.fromOffset(10, 8), Enum.Font.GothamBlack, Color3.fromRGB(255, 220, 123))
text(banner, "Plant • Grow • Harvest • Repeat", UDim2.new(1, -20, 0, 25), UDim2.fromOffset(10, 50), Enum.Font.GothamMedium, Color3.fromRGB(230, 246, 210))

local statsPanel = roundedFrame(gui, UDim2.fromOffset(190, 80), UDim2.new(1, -212, 0, 22), Color3.fromRGB(54, 83, 45), 0.05)
local statsText = text(statsPanel, "", UDim2.fromScale(1, 1), UDim2.fromOffset(0, 0), Enum.Font.GothamBold, Color3.fromRGB(255, 248, 221))

local inventoryPanel = roundedFrame(gui, UDim2.fromOffset(230, 92), UDim2.fromOffset(22, 140), Color3.fromRGB(54, 83, 45), 0.05)
local inventoryText = text(inventoryPanel, "", UDim2.fromScale(1, 1), UDim2.fromOffset(0, 0), Enum.Font.GothamBold, Color3.fromRGB(255, 248, 221))

local hint = roundedFrame(gui, UDim2.fromOffset(440, 55), UDim2.new(0.5, -220, 1, -75), Color3.fromRGB(54, 83, 45), 0.08)
text(hint, "Walk to a garden bed and press E to plant or harvest", UDim2.fromScale(1, 1), UDim2.fromOffset(0, 0), Enum.Font.GothamMedium, Color3.fromRGB(255, 248, 221))

local function updateStats()
	local stats = player:FindFirstChild("leaderstats")
	if not stats then return end
	local coins = stats:FindFirstChild("Coins")
	local seeds = stats:FindFirstChild("Seeds")
	if coins and seeds then
		statsText.Text = string.format("COINS  %d\nSEEDS  %d", coins.Value, seeds.Value)
	end
	local inventory = player:FindFirstChild("CropInventory")
	if inventory then
		inventoryText.Text = string.format("CROPS\nCARROT  %d   WHEAT  %d\nPUMPKIN  %d", inventory.Carrot.Value, inventory.Wheat.Value, inventory.Pumpkin.Value)
	end
end

local stats = player:WaitForChild("leaderstats")
stats:WaitForChild("Coins").Changed:Connect(updateStats)
stats:WaitForChild("Seeds").Changed:Connect(updateStats)
local inventory = player:WaitForChild("CropInventory")
for _, crop in ipairs(inventory:GetChildren()) do
	crop.Changed:Connect(updateStats)
end
updateStats()
