local SS = game:GetService("ServerStorage")
local ProductPurchased:BindableEvent = SS.Network.ProductPurchased
local UpgradeRequested:BindableEvent = SS.Network.UpgradeRequested
local PlayerGoldUpdated:BindableEvent = SS.Network.PlayerGoldUpdated
local RP = game:GetService("ReplicatedStorage")
local PlayerLoadedRemoteEvent:RemoteEvent = RP.PlayerLoaded

local playerController = require(SS.Modules.PlayerController)
local playersData = playerController.GetPlayers()

local function updatePlayerUi(player)
    PlayerLoadedRemoteEvent:FireClient(player, playersData[player.UserId])
end

-- All events responsible for triggering an UI update
ProductPurchased.Event:Connect(updatePlayerUi)
UpgradeRequested.Event:Connect(updatePlayerUi)
PlayerGoldUpdated.Event:Connect(updatePlayerUi)