local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local AssetsFldr = ReplicatedStorage.Assets
local GUITemplatesFldr = AssetsFldr.GUITemplates
local ItemTemplate = GUITemplatesFldr.ItemTemplate

local SharedFldr = ReplicatedStorage.Shared
local SharedFunctions = require(SharedFldr.SharedFunctions)

local Player = Players.LocalPlayer

local PlayerGui = Player.PlayerGui
local MainUI = PlayerGui.MainUI

local WardrobeFrame = MainUI.Wardrobe
local WardrobeItemHolder = WardrobeFrame.Contents.RightFrame.Holder
local WardrobePlayerDisplay = WardrobeFrame.Contents.LeftFrame.ViewportFrame

local Wardrobe = {}

function Wardrobe.LoadDescription(description: HumanoidDescription)
	local Items = SharedFunctions.HumanoidDescriptionToTable(description)

	for name, id in Items do
		local Item = ItemTemplate:Clone()

		Item.Parent = WardrobeItemHolder
	end
end

return Wardrobe
