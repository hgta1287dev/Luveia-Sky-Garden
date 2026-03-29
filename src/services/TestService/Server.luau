local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HoenKnit = require(ReplicatedStorage.Shared.Core.HoenKnit)
local TestMap = require(ReplicatedStorage.Shared.Services.TestService.Tests.TestMap)

local TestService = HoenKnit.CreateService({
	Name = "TestService",
	Client = {},
})
local Logger = TestService._logger
Logger:SetDefaultCategory("Gameplay")

-- * Knit
function TestService:KnitStart()
	Logger:Debug("Calling TestMap Init!")
	TestMap:Init()
end

return TestService
