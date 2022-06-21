local ProximityPromptService = game:GetService("ProximityPromptService")
local MarketplaceService = game:GetService("MarketplaceService")

ProximityPromptService.PromptTriggered:Connect(function(promptObject, player)
	MarketplaceService:PromptProductPurchase(player, 1271983721)
end)