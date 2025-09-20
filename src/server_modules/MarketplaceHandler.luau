local MarketplaceService = game:GetService("MarketplaceService")
local HttpService = game:GetService("HttpService")

local MarketplaceHandler = {}

local LoadedInfo = {}

function MarketplaceHandler.GetProductInfo(id)
	if not LoadedInfo[id] then
		LoadedInfo[id] = MarketplaceHandler.AttemptProductInfoGet(id, 5)
	end
	print(LoadedInfo[id])

	local BundleId = MarketplaceHandler.GatherBundleId(id)
	--Add Bundle Id to data
	LoadedInfo[id].BundleId = BundleId
	LoadedInfo[id].MarketplaceProductType = BundleId and "AvatarBundle" or "AvatarAsset"

	return LoadedInfo[id]
end

function MarketplaceHandler.AttemptProductInfoGet(id, MaxAttempts)
	local Attempts = MaxAttempts
	repeat
		local success, result = pcall(function()
			return MarketplaceService:GetProductInfo(id)
		end)

		if success then
			print("success")
			return result
		end
		Attempts -= 1
		task.wait()
		warn("err", result)
	until Attempts == 0
	return
end

function MarketplaceHandler.GatherBundleId(id)
	--This means accessory is part a bundle
	local url = "https://catalog.roproxy.com/v1/assets/" .. tostring(id) .. "/bundles?limit=10&sortOrder=Asc"
	local data = HttpService:GetAsync(url)

	local decoded = HttpService:JSONDecode(data)

	return decoded.data[1]
end

function MarketplaceHandler.PromptPurchase(
	plr,
	ids: {
		[number]: {
			Type: "AvatarBundle" | "AvatarAsset",
			Id: string,
		},
	}
)
	--Compile into proper format
	for _, data in ids do
		data.Type = Enum.MarketplaceProductType[data.Type]
	end

	if #ids > 1 then
		--Bulk purchase
		MarketplaceService:PromptBulkPurchase(plr, ids)
	else
		MarketplaceService:PromptPurchase(plr, ids[1])
	end
end

return MarketplaceHandler
