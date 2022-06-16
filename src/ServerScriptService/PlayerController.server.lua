-- Services
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local ProximityPromptService = game:GetService("ProximityPromptService")

-- Members
local EnemyDefeatedBindableEvent = game:GetService("ServerStorage").Network.EnemyDefeated
local RP = game:GetService("ReplicatedStorage")
local PlayerLoadedRemoteEvent = RP.PlayerLoaded
local RequestPowerUpgradeRemoteEvent = RP.RequestPowerUpgrade
local RequestSpeedUpgradeRemoteEvent = RP.RequestSpeedUpgrade

local DataStoreService = game:GetService("DataStoreService")
local database = DataStoreService:GetDataStore("Zombies")
local playersData = {}

-- Constants
local GOLD_EARNED_ON_ENEMY_DEFEAT = 10
local PLAYER_DEFAULT_DATA = {
	gold = 0;
	speed = 16;
	power = 25;
}
local UPGRADE_COST = 10

local function onRequestPowerUpgrade(player: Player)
	local data = playersData[player.UserId]
	if data.gold < UPGRADE_COST then
		--TODO Prompt gold pack purchase
		MarketplaceService:PromptProductPurchase(player, 1271983721)
		return
	end
	
	playersData[player.UserId].gold -= UPGRADE_COST
	playersData[player.UserId].power += 1
	
	-- Fire player loaded event
	PlayerLoadedRemoteEvent:FireClient(player, playersData[player.UserId])
end

local function onRequestSpeedUpgrade(player: Player)
	local data = playersData[player.UserId]
	if data.gold < UPGRADE_COST then
		--TODO Prompt gold pack purchase
		MarketplaceService:PromptProductPurchase(player, 1271983721)
		
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
	PlayerLoadedRemoteEvent:FireClient(player, playersData[player.UserId])
end

local function onEnemyDefeated(playerId: number)
	local player = Players:GetPlayerByUserId(playerId)
	playersData[player.UserId].gold += GOLD_EARNED_ON_ENEMY_DEFEAT
	
	-- Fire player loaded event
	PlayerLoadedRemoteEvent:FireClient(player, playersData[player.UserId])
end

local function onPlayerAdded(player: Player)
	player.CharacterAdded:Connect(function(character)
		local data = database:GetAsync(player.UserId)
		if not data then
			data = PLAYER_DEFAULT_DATA
		end

		playersData[player.UserId] = data
		player:SetAttribute("Power", data.power)

		-- Wait for character to be fully loaded
		while not player.Character do wait(1) end

		local character = player.Character
		if character then
			local humanoid:Humanoid = character:WaitForChild("Humanoid")
			humanoid.WalkSpeed = data.speed		
		end	

		-- Fire player loaded event
		PlayerLoadedRemoteEvent:FireClient(player, data)
	end)
end

local function onPlayerRemoving(player: Player)
	database:SetAsync(player.UserId, playersData[player.UserId])
	playersData[player.UserId] = nil
end

-- Listeners
EnemyDefeatedBindableEvent.Event:Connect(onEnemyDefeated)
RequestPowerUpgradeRemoteEvent.OnServerEvent:Connect(onRequestPowerUpgrade)
RequestSpeedUpgradeRemoteEvent.OnServerEvent:Connect(onRequestSpeedUpgrade)

Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)


MarketplaceService.ProcessReceipt = function(receiptInfo)
	local player = Players:GetPlayerByUserId(receiptInfo.PlayerId)
	
	-- GOLD PACK 1000
	if receiptInfo.ProductId == 1271983721 then
		playersData[receiptInfo.PlayerId].gold += 1000
		
		-- Fire player loaded event
		PlayerLoadedRemoteEvent:FireClient(player, playersData[player.UserId])
	end
end

ProximityPromptService.PromptTriggered:Connect(function(promptObject, player)
	MarketplaceService:PromptProductPurchase(player, 1271983721)
end)