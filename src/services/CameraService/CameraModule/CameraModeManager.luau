local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LoggerManager = require(ReplicatedStorage.Shared.Core.LoggerManager)
local CameraTypes = require(ReplicatedStorage.Shared.Services.CameraService.CameraModule.Config.CameraTypes)
local CameraModeFactory = require(script.Parent.CameraModeFactory)

local CameraModeManager = {}
CameraModeManager.__index = CameraModeManager
local Logger = LoggerManager:CreateLogger(script.Name, "System")

-- * Types
export type CameraContext = CameraTypes.CameraContext
export type ModeName = CameraTypes.ModeName
export type Mode = CameraTypes.Mode

export type CameraModeManager = typeof(setmetatable({
	_currentMode = nil :: Mode?,
	_modes = {} :: { [ModeName]: Mode },
}, CameraModeManager))

-- * Constructor
function CameraModeManager.new()
	return setmetatable({
		_currentMode = nil,
		_modes = {},
	}, CameraModeManager)
end

-- * Public
-- Mode management
function CameraModeManager:AddMode(name: ModeName, context: CameraContext): Mode?
	local mode = CameraModeFactory:Create(name, context)

	if not mode then
		Logger:Error(`Mode "{name}" not found!`)
		return nil
	end

	self._modes[name] = mode
	return mode
end

function CameraModeManager:RemoveMode(name: ModeName)
	self._modes[name] = nil
end

-- Getters
function CameraModeManager:GetMode(name): Mode?
	local mode = self._modes[name]
	return mode
end

function CameraModeManager:GetModes(): { [string]: Mode }
	return self._modes
end

function CameraModeManager:GetCurrentMode()
	return self._currentMode
end

-- Change mode
function CameraModeManager:ChangeMode(name, context)
	if self._currentMode then
		self._currentMode:Exit()
	end
	self._currentMode = self:GetMode(name, context)
	if self._currentMode then
		self._currentMode:Enter(context)
	end
end

-- Update
function CameraModeManager:Update(dt)
	if self._currentMode then
		return self._currentMode:Update(dt)
	end
	return
end

-- Helper
function CameraModeManager:AutoRegisterModes(context: CameraContext)
	self:AddMode(CameraTypes.Modes.Orbital, context)

	-- for name, _ in pairs(CameraTypes.Modes) do
	-- 	self:AddMode(name, context)
	-- end
end

return CameraModeManager
