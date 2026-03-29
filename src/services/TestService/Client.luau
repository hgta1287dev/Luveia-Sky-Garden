local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HoenKnit = require(ReplicatedStorage.Shared.Core.HoenKnit)
local TestCamera = require(ReplicatedStorage.Shared.Services.TestService.Tests.TestCamera)

local TestController = HoenKnit.CreateController({ Name = "TestController" })
local Logger = TestController._logger
Logger:SetDefaultCategory("Gameplay")

-- * Knit
function TestController:KnitInit()
	Logger:Debug("Test Init")
end
function TestController:KnitStart()
	Logger:Debug("Test Start")
	TestCamera:Init()
end

return TestController
