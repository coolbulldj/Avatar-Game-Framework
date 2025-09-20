local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Root: BasePart = Character:FindFirstChild("HumanoidRootPart")

local ClientModules = ReplicatedStorage.ClientModules
local UIFldr = ClientModules.UIFldr
local SharedFldr = ReplicatedStorage.Shared

local PlayerGui = Player.PlayerGui
local MainUI = PlayerGui.MainUI

local Buttons = MainUI.Buttons

local WaredrobeButton = Buttons.Wardrobe
local FavoritesButton = Buttons.Favorites

local ActiveUITransition = false

local SharedFunctions = require(SharedFldr.SharedFunctions)

local WardrobeManager = require(UIFldr.Wardrobe)

WaredrobeButton.MouseButton1Up:Connect(function()
	if ActiveUITransition then
		return
	end
	ActiveUITransition = true
	if WardrobeManager.Opened then
		WardrobeManager.Close()
	else
		--Load description of own avatar
		local AvatarDescription = Players:GetHumanoidDescriptionFromUserId(Player.UserId)
		WardrobeManager.LoadDescription(AvatarDescription)
		WardrobeManager.Open()
	end
	ActiveUITransition = false
end)
