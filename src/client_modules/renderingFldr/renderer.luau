local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Root: BasePart = Character:FindFirstChild("HumanoidRootPart")

local SharedFldr = ReplicatedStorage.Shared
local ClientModules = ReplicatedStorage.ClientModules
local RenderingFldr = ClientModules.renderingFldr
local AnimationHandler = require(RenderingFldr.animationHandler)
local PromptHandler = require(RenderingFldr.PromptHandler)
local SharedFunctions = require(SharedFldr.SharedFunctions)
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
		local PurchaseAnimationId = Stand:GetAttribute("PurchaseAnimationId")
		local RawAnimationId = Stand:GetAttribute("RawAnimationId")

		local StandRig: Model = Stand:FindFirstChild("Rig")
		if not StandRig then
			warn("Stand fails to have rig")
			return
		end

		table.insert(StandDataList, {
			PurchaseAnimationId = PurchaseAnimationId,
			RawAnimationId = RawAnimationId,
			StandRig = StandRig,
		})
	end
end

function Renderer.GetStandAnimIds()
	local AnimationIds = {}

	for _, sub_data in StandDataList do
		table.insert(AnimationIds, sub_data.RawAnimationId)
	end

	return AnimationIds
end

function Renderer.RenderStand(stand)
	AnimationHandler.PlayAnimation(stand.Rig, stand:GetAttribute("RawAnimationId"), true)
	PromptHandler.RenderPrompt(stand)
	InRenderStands[stand] = true
end

function Renderer.UnrenderStand(stand)
	AnimationHandler.EndAllAnimations(stand.Rig)
	InRenderStands[stand] = nil
end

function Renderer.SetPrimaryStand(Data: StandData)
	--Set highlight parent
	Highlight.Parent = Data.StandRig

	--Enable prompts
	PromptHandler.ShowPrompts(Data.StandRig)
end

function Renderer.RenderStands(List) --This list contains all the stands to be renders
	for _, stand in List do
		if InRenderStands[stand] then
			continue
		end
		PromptHandler.HidePrompts(stand.Rig)
		Renderer.RenderStand(stand)
	end

	--Loop through old stands to see if they are unnessaryally rendered
	for stand, _ in InRenderStands do
		if table.find(List, stand) then
			continue
		end
		Renderer.UnrenderStand(stand)
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
