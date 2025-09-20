local MarketplaceService = game:GetService("MarketplaceService")

local MarketplaceHandler = {}

local LoadedInfo = {}

function MarketplaceHandler.GetProductInfo(id)
	if not LoadedInfo[id] then
		LoadedInfo[id] = MarketplaceHandler.AttemptProductInfoGet(id, 5)
	end
	return LoadedInfo[id]
end

function MarketplaceHandler.AttemptProductInfoGet(id, MaxAttempts)
	local Attempts = MaxAttempts

	repeat
		local success, result = pcall(function()
			return MarketplaceService:GetProductInfo(id)
		end)

		if success then
			return result
		end
		Attempts -= 1
	until Attempts == 0
	return
end

return MarketplaceHandler
