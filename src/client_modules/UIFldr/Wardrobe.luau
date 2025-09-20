local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local AssetsFldr = ReplicatedStorage.Assets
local GUITemplatesFldr = AssetsFldr.GUITemplates
local ItemTemplate = GUITemplatesFldr.ItemTemplate

local ClientModules = ReplicatedStorage.ClientModules
local UIFldr = ClientModules.UIFldr

local UIEffectHandler = require(UIFldr.UIEffectHandler)

local SharedFldr = ReplicatedStorage.Shared

local SharedFunctions = require(SharedFldr.SharedFunctions)
local Net = require(SharedFldr.blink.client)

local ConfigFile = require(ClientModules.Config)

local Player = Players.LocalPlayer

local PlayerGui = Player.PlayerGui
local MainUI = PlayerGui.MainUI

local WardrobeFrame = MainUI.Wardrobe
local WardrobeItemHolder = WardrobeFrame.Contents.RightFrame.Holder
local WardrobePlayerDisplay = WardrobeFrame.Contents.LeftFrame.ViewportFrame

local WardrobeOpenPos = WardrobeFrame.Position
local WardrobeClosePos = ConfigFile.WardrobeClosePosition
local OpenTime = ConfigFile.WardrobeOpenTime
local CloseTime = ConfigFile.WardrobeCloseTime

local Wardrobe = {}

Wardrobe.Opened = false

function Wardrobe.LoadDescription(description: HumanoidDescription)
	local Items = SharedFunctions.HumanoidDescriptionToTable(description)

	for name, id: string in Items do
		if not id or id == "" then
			continue
		end
		local Item = ItemTemplate:Clone()

		local info = Net.GetProductInfo.Invoke(tonumber(id))

		print(info)

		Item.Parent = WardrobeItemHolder
	end
end

function Wardrobe.Open()
	WardrobeFrame.Position = WardrobeClosePos
	WardrobeFrame.Visible = true
	UIEffectHandler.MoveFrame(WardrobeFrame, WardrobeOpenPos, OpenTime, true)
	Wardrobe.Opened = true
end

function Wardrobe.Close()
	WardrobeFrame.Position = WardrobeOpenPos
	WardrobeFrame.Visible = true
	UIEffectHandler.MoveFrame(WardrobeFrame, WardrobeClosePos, CloseTime, true)
	WardrobeFrame.Visible = false
	Wardrobe.Opened = false
end

return Wardrobe
