local RP = game:GetService("ReplicatedStorage")
local RequestPowerUpgradeRemoteEvent:RemoteEvent = RP.RequestPowerUpgrade
local RequestSpeedUpgradeRemoteEvent:RemoteEvent = RP.RequestSpeedUpgrade

local SS = game:GetService("ServerStorage")
local playerController = require(SS.Modules.PlayerController)
local playersData = playerController.GetPlayers()
local shop = require(SS.Modules.Shop)

local UpgradeRequested:BindableEvent = SS.Network.UpgradeRequested

local UPGRADE_COST = 10

local function canPurchaseUpgrade(player)
    local data = playersData[player.UserId]
	if data.gold < UPGRADE_COST then
		shop.BuyGold(player)
		
        -- Can't purchase
        return false
	end

    return true
end

local function onRequestPowerUpgrade(player: Player)
	if not canPurchaseUpgrade(player) then
        return
    end
	
	playersData[player.UserId].gold -= UPGRADE_COST
	playersData[player.UserId].power += 1
	
	-- Updates the power attribute
	player:SetAttribute("Power", playersData[player.UserId].power)

	-- Fire player loaded event
	UpgradeRequested:Fire(player)
end

local function onRequestSpeedUpgrade(player: Player)
	if not canPurchaseUpgrade(player) then
        return
    end
	
	playersData[player.UserId].gold -= UPGRADE_COST
	playersData[player.UserId].speed += 1
	
	local character = player.Character
	if character then
		local humanoid:Humanoid = character:WaitForChild("Humanoid")
		humanoid.WalkSpeed = playersData[player.UserId].speed	
	end	
	
	-- Fire player loaded event
	UpgradeRequested:Fire(player)
end

RequestPowerUpgradeRemoteEvent.OnServerEvent:Connect(onRequestPowerUpgrade)
RequestSpeedUpgradeRemoteEvent.OnServerEvent:Connect(onRequestSpeedUpgrade)