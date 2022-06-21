-- Services
local SS = game:GetService("ServerStorage")
local playerController = require(SS.Modules.PlayerController)
local Players = game:GetService("Players")

-- Members
local playersData = playerController.GetPlayers()
local EnemyDefeated:BindableEvent = SS.Network.EnemyDefeated
local PlayerGoldUpdated:BindableEvent = SS.Network.PlayerGoldUpdated

-- Constants
local GOLD_EARNED_ON_ENEMY_DEFEAT = 10

local function onEnemyDefeated(playerId: number)
	local player = Players:GetPlayerByUserId(playerId)
	playersData[player.UserId].gold += GOLD_EARNED_ON_ENEMY_DEFEAT

    PlayerGoldUpdated:Fire(player)
end

-- Listeners
EnemyDefeated.Event:Connect(onEnemyDefeated)