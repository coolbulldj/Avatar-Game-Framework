print("Hello world, from client!")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Root: BasePart = Character:FindFirstChild("HumanoidRootPart")

local ClientModules = ReplicatedStorage.ClientModules
local RenderingFldr = ClientModules.renderingFldr
local Renderer = require(RenderingFldr.renderer)
local AnimationHandler = require(RenderingFldr.animationHandler)
local Config = require(ClientModules:FindFirstChild("Config"))
local RunService = game:GetService("RunService")

--Preload stuff
Renderer.LoadStandData()
local animationIds = Renderer.GetStandAnimIds()
AnimationHandler.LoadAnimationInstances(animationIds)
local Range = Config.Range

--Handle Rendering
RunService.RenderStepped:Connect(function()
	local StandsToRender = Renderer.GetStandsInRange(Range)

	Renderer.RenderStands(StandsToRender)

	local Closest = Renderer.GetClosestStand()

	if not Closest then
		return
	end

	Renderer.SetPrimaryStand(Closest)
end)
