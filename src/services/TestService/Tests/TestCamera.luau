local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CameraModule = require(ReplicatedStorage.Shared.Services.CameraService.CameraModule)

local function GetTestPart()
	local part = Instance.new("Part")
	part.Size = Vector3.one * 2
	part.Position = Vector3.new(0, 5, 0)
	part.Anchored = true
	part.Parent = workspace
	return part
end

local TestCamera = CameraModule.new()
TestCamera:Init()

TestCamera:GetCameraState().LookAtTarget = GetTestPart()

return TestCamera
