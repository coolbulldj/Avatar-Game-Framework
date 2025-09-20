local MarketplaceService = game:GetService("MarketplaceService")
local HttpService = game:GetService("HttpService")

local MarketplaceHandler = {}

local LoadedInfo = {}

function MarketplaceHandler.GetProductInfo(id)
	if LoadedInfo[id] then
		return LoadedInfo[id]
	end

	LoadedInfo[id] = MarketplaceHandler.AttemptProductInfoGet(id, 5)

	local BundleData = LoadedInfo.IsForSale or MarketplaceHandler.GatherBundleId(id)
	if BundleData then
		LoadedInfo[id].BundleId = BundleData.id
		LoadedInfo[id].BundleProductId = BundleData.product.id
	end
	LoadedInfo[id].MarketplaceProductType = BundleData and "AvatarBundle" or "AvatarAsset"

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
		print("err", result)
		Attempts -= 1
		task.wait()
	until Attempts == 0
	return
end

function MarketplaceHandler.GatherBundleId(id)
	--This means accessory is part a bundle
	local url = "https://catalog.roproxy.com/v1/assets/" .. tostring(id) .. "/bundles?limit=10&sortOrder=Asc"

	local Attempts = 5
	repeat
		local success, result = pcall(function()
			return HttpService:GetAsync(url)
		end)

		if success then
			print("success")
			local decoded = HttpService:JSONDecode(result)

			return decoded.data[1]
		end
		print("err", result)
		Attempts -= 1
		task.wait()
	until Attempts == 0
	return
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
		MarketplaceService:PromptPurchase(plr, ids[1].Id)
	end
end

return MarketplaceHandler
