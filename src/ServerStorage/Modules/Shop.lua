local Shop = {}

local MarketplaceService = game:GetService("MarketplaceService")

Shop.products = {
    ["1271983721"] = {
        productId = 1271983721,
        productName = "Gold Pack 1000",
        reward = 1000
    }
}

function Shop.BuyGold(player)
    local product = Shop.products["1271983721"].productId
    MarketplaceService:PromptProductPurchase(player, product)
end

return Shop