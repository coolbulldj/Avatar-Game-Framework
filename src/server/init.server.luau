local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local ServerModules = ServerScriptService.ServerModules
local SharedFldr = ReplicatedStorage.Shared

local Net = require(SharedFldr.blink.server)

local MarketplaceHandler = require(ServerModules.MarketplaceHandler)

Net.GetProductInfo.On(MarketplaceHandler.GetProductInfo)
