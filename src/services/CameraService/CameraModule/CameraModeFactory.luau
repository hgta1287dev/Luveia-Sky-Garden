local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LoggerManager = require(ReplicatedStorage.Shared.Core.LoggerManager)
local CameraTypes = require(ReplicatedStorage.Shared.Services.CameraService.CameraModule.Config.CameraTypes)
local CameraContext = require(ReplicatedStorage.Shared.Services.CameraService.CameraModule.Context.CameraContext)
local BaseCameraMode = require(ReplicatedStorage.Shared.Services.CameraService.CameraModule.Modes.BaseCameraMode)
local CameraCylindricalOrbital =
	require(ReplicatedStorage.Shared.Services.CameraService.CameraModule.Modes.CameraCylindricalOrbital)
local CameraFree = require(ReplicatedStorage.Shared.Services.CameraService.CameraModule.Modes.CameraFree)
local CameraOrbital = require(ReplicatedStorage.Shared.Services.CameraService.CameraModule.Modes.CameraOrbital)

local ModeRegistry = {}
local Logger = LoggerManager:CreateLogger(script.Name, "System")

-- * Types
export type CameraContext = CameraContext.CameraContext
export type ModeName = CameraTypes.ModeName
export type Mode = BaseCameraMode.BaseMode

-- * Constant
local MODES = {
	CylindricalOrbital = CameraCylindricalOrbital,
	Orbital = CameraOrbital,
	Free = CameraFree,
}

-- * Public
-- register
function ModeRegistry:Register(name: ModeName, mode: Mode)
	if not name then
		Logger:Error("Mode must have a name")
		return
	end

	if typeof(mode.Update) ~= "function" then
		Logger:Error("Mode must have Update function")
		return
	end

	MODES[name] = mode
end

-- getters
function ModeRegistry:Get(name: ModeName): Mode?
	return MODES[name]
end

function ModeRegistry:GetAll(): { [ModeName]: Mode }
	return MODES
end

function ModeRegistry:Create(name: ModeName, context: CameraContext): Mode?
	local mode = self:Get(name)

	if not mode then
		Logger:Error(`Mode "{name}" not found`)
		return
	end

	return mode.new(context)
end

return ModeRegistry
