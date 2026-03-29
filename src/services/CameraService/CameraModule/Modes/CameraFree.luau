local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CameraTypes = require(ReplicatedStorage.Shared.Services.CameraService.CameraModule.Config.CameraTypes)
local CameraContext = require(ReplicatedStorage.Shared.Services.CameraService.CameraModule.Context.CameraContext)
local CameraState = require(ReplicatedStorage.Shared.Services.CameraService.CameraModule.Context.CameraState)
local BaseCameraMode = require(script.Parent.BaseCameraMode)

local CameraOrbital = setmetatable({}, BaseCameraMode)
CameraOrbital.__index = CameraOrbital

-- * Types
type CameraContext = CameraContext.CameraContext
type CameraState = CameraState.CameraState

-- * Lifecycle
function CameraOrbital.new()
	local self = setmetatable(BaseCameraMode.new(), CameraOrbital)
	return self
end

function CameraOrbital:Enter(context: CameraContext)
	BaseCameraMode.Enter(self, context)
	local states = context:GetModeStates()
end

function CameraOrbital:Update(dt: number)
	local context = self.context :: CameraContext
	local states = context:GetModeStates()
	local smooth = states.SmoothFactor
	local speed = states.Sensitivity
	local alpha = dt * speed * smooth
end

return CameraOrbital
