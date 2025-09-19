local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Root: BasePart = Character:FindFirstChild("HumanoidRootPart")

local ClientModules = ReplicatedStorage.ClientModules
local RenderingFldr = ClientModules.renderingFldr
local AnimationHandler = require(RenderingFldr.animationHandler)
local Config = require(ClientModules:FindFirstChild("Config"))

local Highlight = Instance.new("Highlight")
Highlight.FillColor = Config.HighlightFillColor
Highlight.FillTransparency = Config.HighlightFillTransparency
Highlight.OutlineColor = Config.HighlightBorderColor

local StandFldr = workspace.Stands

local Renderer = {}

local StandDataList = {}

local InRenderStands = {}

type StandData = {
	PurchaseAnimationId: number,
	LegitAnimationId: number,
	StandRig: Model,
}

function Renderer.LoadStandData() --Called at start to load up all stand data making it so it isn't constantly needing to be refreced
	for _, Stand in pairs(StandFldr:GetChildren()) do
		local AnimationId = Stand:GetAttribute("AnimationId")
		local StandRig: Model = Stand:FindFirstChild("Rig")
		if not StandRig then
			warn("Stand fails to have rig")
			return
		end

		table.insert(StandDataList, {
			PurchaseAnimationId = AnimationId,
			LegitAnimationId = "",
			StandRig = StandRig,
		})
	end
end

function Renderer.GetStandAnimIds()
	local AnimationIds = {}

	for _, sub_data in StandDataList do
		table.insert(AnimationIds, sub_data.LegitAnimationId)
	end

	return AnimationIds
end

function Renderer.RenderStand(stand)
	AnimationHandler.PlayAnimation(stand.Rig, stand, true)
	InRenderStands[stand] = true
end

function Renderer.SetPrimaryStand(Data: StandData)
	--Set highlight parent
	Highlight.Parent = Data.StandRig
end

function Renderer.RenderStands(List)
	for _, stand in List do
		if InRenderStands[stand] then
			continue
		end
		Renderer.RenderStand(stand)
	end
end

function Renderer.GetStandsInRange(range)
	local InRange = {}
	for _, stand: Model in pairs(StandFldr:GetChildren()) do
		if (stand:GetPivot().Position - Root.Position).Magnitude <= range then
			table.insert(InRange, stand)
		end
	end

	return InRange
end

function Renderer.GetClosestStand()
	if #StandDataList < 1 then
		return
	end
	local Closest = StandDataList[1]

	for _, sub_data in StandDataList do
		if
			(sub_data.StandRig:GetPivot().Position - Root.Position).Magnitude
			<= (Closest.StandRig:GetPivot().Position - Root.Position).Magnitude
		then
			Closest = sub_data
		end
	end

	return Closest
end

function Renderer.RefreshVariables() --Happens mostly when character dies meaning some variables need to get refreshed
	Character = Player.Character or Player.CharacterAdded:Wait()
end

return Renderer
