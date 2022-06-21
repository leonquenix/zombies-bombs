local PlayerController = {}

--region SERVICES
local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
--endregion

--region MEMBERS
local database = DataStoreService:GetDataStore("Zombies")
local RP = game:GetService("ReplicatedStorage")
local PlayerLoadedRemoteEvent:RemoteEvent = RP.PlayerLoaded
local SS = game:GetService("ServerStorage")
--endregion

--region CONSTANTS
local PLAYER_DEFAULT_DATA = {
	gold = 0;
	speed = 16;
	power = 25;
}
--endregion

local playersData = {}

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

function PlayerController.GetPlayers()
    return playersData
end

--region LISTENERS
Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)

--endregion

return PlayerController