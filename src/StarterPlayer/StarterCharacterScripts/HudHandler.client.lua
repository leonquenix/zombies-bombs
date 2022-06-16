local RP = game:GetService("ReplicatedStorage")
local PlayerLoadedRemoteEvent = RP.PlayerLoaded
local RequestPowerUpgradeRemoteEvent = RP.RequestPowerUpgrade
local RequestSpeedUpgradeRemoteEvent = RP.RequestSpeedUpgrade

local Players = game:GetService("Players")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local hud = PlayerGui:WaitForChild("HUD")

local addPowerButton:TextButton = hud:WaitForChild("AddPower")
local addSpeedButton:TextButton = hud:WaitForChild("AddSpeed")

local goldTag:TextLabel = hud:WaitForChild("Gold")
local powerTag:TextLabel = hud:WaitForChild("Power")
local speedTag:TextLabel = hud:WaitForChild("Speed")

PlayerLoadedRemoteEvent.OnClientEvent:Connect(function(data)
	goldTag.Text = data.gold
	powerTag.Text = data.power
	speedTag.Text = data.speed
end)

addPowerButton.MouseButton1Click:Connect(function()
	print("Upgrade power")
	RequestPowerUpgradeRemoteEvent:FireServer()
end)

addSpeedButton.MouseButton1Click:Connect(function()
	print("Upgrade speed")
	RequestSpeedUpgradeRemoteEvent:FireServer()
end)