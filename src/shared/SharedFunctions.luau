local MarketplaceService = game:GetService("MarketplaceService")

local SharedFunctions = {}

function SharedFunctions.GetMarketplaceInfo(id, MaxAttempts: number?)
	local Attempts = MaxAttempts or 5

	repeat
		task.wait()
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

function SharedFunctions.HumanoidDescriptionToTable(humanoidDescription: HumanoidDescription)
	local data = {}

	local accessoryProperties = {
		"BackAccessory",
		"FaceAccessory",
		"FrontAccessory",
		"HairAccessory",
		"HatAccessory",
		"NeckAccessory",
		"ShouldersAccessory",
		"WaistAccessory",
		"Shirt",
		"Pants",
		"GraphicTShirt",
		"Face",
		"Head",
		"Torso",
		"LeftArm",
		"RightArm",
		"LeftLeg",
		"RightLeg",
	}

	-- Loop through all properties of HumanoidDescription
	for _, property in ipairs(accessoryProperties) do
		-- pcall prevents error if a property is nil or restricted
		local success, value = pcall(function()
			return humanoidDescription[property]
		end)
		if success then
			data[property] = value
		end
	end

	return data
end

return SharedFunctions
