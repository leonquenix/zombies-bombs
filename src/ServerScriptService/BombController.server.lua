local dropBombRemoteEvent = game:GetService("ReplicatedStorage").DropBomb

-- Members
local bombFolder = game:GetService("ServerStorage").Bombs
local bombTemplate = bombFolder.Bomb

local function isDropBombAllowed()
	local bombsQuantity = #workspace.SpawnedBombs:GetChildren()
	if bombsQuantity > 0 then
		return false
	end

	return true
end

dropBombRemoteEvent.OnServerEvent:Connect(function(player)
	if not isDropBombAllowed() then
		return
	end
	
	local bomb = bombTemplate:Clone()
	bomb.CFrame = player.Character.PrimaryPart.CFrame
	bomb.Collider.CFrame = bomb.CFrame * CFrame.new(0, -3, 0)
	
	bomb:SetAttribute("Owner", player.UserId)
	bomb:SetAttribute("Power", player:GetAttribute("Power"))
	
	bomb.Parent = workspace.SpawnedBombs
end)