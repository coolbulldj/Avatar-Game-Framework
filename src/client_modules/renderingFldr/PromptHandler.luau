local PromptHandler = {}

local PromptConnections = {}

function PromptHandler.RenderPrompt(Stand)
	local Rig = Stand.Rig

	local root = Rig:FindFirstChild("HumanoidRootPart") --Prompt is located here
end

function PromptHandler.HidePrompts(Stand)
	local Rig = Stand.Rig

	local root = Rig:FindFirstChild("HumanoidRootPart") --Prompt is located here

	local ProxmitiyPrompt = root:FindFirstChild("ProximityPrompt")
	ProxmitiyPrompt.Enabled = false
end

function PromptHandler.ShowPrompts(Stand)
	local Rig = Stand.Rig

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
