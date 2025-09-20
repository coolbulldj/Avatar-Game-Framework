local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ClientModules = ReplicatedStorage.ClientModules
local UIFldr = ClientModules.UIFldr
local SharedFldr = ReplicatedStorage.Shared

local SharedFunctions = require(SharedFldr.SharedFunctions)

local WardrobeManager = require(UIFldr.Wardrobe)

local PromptHandler = {}

local PromptConnections = {}

function PromptHandler.RenderPrompt(Stand)
	local Rig = Stand.Rig

	local Humanoid: Humanoid = Rig:FindFirstChild("Humanoid")

	local Description = Humanoid:GetAppliedDescription()

	local root = Rig:FindFirstChild("HumanoidRootPart") --Prompt is located here

	local ProxmitiyPrompt: ProximityPrompt = root:FindFirstChild("ProximityPrompt")
	ProxmitiyPrompt.Enabled = true

	PromptConnections[Stand] = {}

	table.insert(
		PromptConnections[Stand],
		ProxmitiyPrompt.Triggered:Connect(function()
			WardrobeManager.LoadDescription(Description)
			WardrobeManager.Open()
		end)
	)
end

function PromptHandler.HidePrompts(Rig)
	local root = Rig:FindFirstChild("HumanoidRootPart") --Prompt is located here

	local ProxmitiyPrompt = root:FindFirstChild("ProximityPrompt")
	ProxmitiyPrompt.Enabled = false
end

function PromptHandler.ShowPrompts(Rig)
	local root = Rig:FindFirstChild("HumanoidRootPart") --Prompt is located here

	local ProxmitiyPrompt = root:FindFirstChild("ProximityPrompt")
	ProxmitiyPrompt.Enabled = true
end

function PromptHandler.UnrenderPrompt(Stand)
	for _, connection: RBXScriptConnection in PromptConnections[Stand] do
		connection:Disconnect()
	end
end

return PromptHandler
