local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")
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

local WardrobeTranstion = false

local WardrobeConnections = {}

local function ItemOnHoverEnter(elem, OwnedItem)
	return function()
		elem.PurchaseB.Visible = not OwnedItem
		elem.AddToCartB.Visible = true
	end
end

local function ItemOnHoverExit(elem)
	return function()
		elem.PurchaseB.Visible = false
		elem.AddToCartB.Visible = false
	end
end

local function ItemPurchase(id: string, ItemType: string)
	return function()
		Net.PromptPurchase.Fire({ {
			Type = ItemType,
			Id = id,
		} })
	end
end

local function AddItemToCart(id)
	return function() end
end

function Wardrobe.LoadDescription(description: HumanoidDescription)
	print("loading?")
	local Items = SharedFunctions.HumanoidDescriptionToTable(description)

	--Clear old items
	for _, elem in pairs(WardrobeItemHolder:GetChildren()) do
		if elem:IsA("UIListLayout") then
			continue
		end
		elem:Destroy()
	end

	--Clean up old connections
	for _, connection in WardrobeConnections do
		connection:Disconnect()
	end

	local ActiveThreads = 0

	local SpawnedItems = {}

	for _, id: string in Items do
		if SpawnedItems[id] then
			continue
		end
		SpawnedItems[id] = true
		ActiveThreads += 1
		task.spawn(function()
			local NumberId = tonumber(id)
			if not NumberId or NumberId == 0 then
				ActiveThreads -= 1
				return
			end

			local Item = ItemTemplate:Clone()

			local info = Net.GetProductInfo.Invoke(NumberId)

			Item.ItemName.Text = info.Name
			Item.RobuxPrice.Text = info.IsForSale and tostring(info.PriceInRobux) or "Not For Sale"

			local Image = "https://www.roblox.com/asset-thumbnail/image?assetId="
				.. id
				.. "&width=420&height=420&format=png"

			Item.DisplayImage.Image = Image

			local Owned = MarketplaceService:PlayerOwnsAsset(Player, NumberId)

			local C1 = Item.MouseEnter:Connect(ItemOnHoverEnter(Item, Owned))
			local C2 = Item.MouseLeave:Connect(ItemOnHoverExit(Item))

			local C3 = Item.AddToCartB.MouseButton1Up:Connect(AddItemToCart(id))

			table.insert(WardrobeConnections, C1)
			table.insert(WardrobeConnections, C2)
			table.insert(WardrobeConnections, C3)

			if not Owned then
				local C4 =
					Item.PurchaseB.MouseButton1Up:Connect(ItemPurchase(tostring(id), info.MarketplaceProductType))

				table.insert(WardrobeConnections, C4)
			else
				Item.Owned_Template.Visible = true
			end

			Item.Parent = WardrobeItemHolder
			ActiveThreads -= 1
		end)
	end

	repeat
		task.wait()
	until ActiveThreads == 0
end

function Wardrobe.Open()
	if WardrobeTranstion then
		return
	end
	WardrobeTranstion = true

	WardrobeFrame.Position = WardrobeClosePos
	WardrobeFrame.Visible = true
	UIEffectHandler.MoveFrame(WardrobeFrame, WardrobeOpenPos, OpenTime, true)
	Wardrobe.Opened = true

	WardrobeTranstion = false
end

function Wardrobe.Close()
	if WardrobeTranstion then
		return
	end
	WardrobeTranstion = true

	WardrobeFrame.Position = WardrobeOpenPos
	WardrobeFrame.Visible = true
	UIEffectHandler.MoveFrame(WardrobeFrame, WardrobeClosePos, CloseTime, true)
	WardrobeFrame.Visible = false
	Wardrobe.Opened = false

	WardrobeTranstion = false
end

return Wardrobe
