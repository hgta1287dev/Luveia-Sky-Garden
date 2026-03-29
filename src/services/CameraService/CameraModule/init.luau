local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local CameraModeManager = require(script.CameraModeManager)
local CameraTypes = require(script.Config.CameraTypes)
local LoggerManager = require(ReplicatedStorage.Shared.Core.LoggerManager)
local CameraContext = require(script.Context.CameraContext)
local CameraInput = require(script.Input.CameraInput)
local CameraModule = {}

CameraModule.__index = CameraModule
local Logger = LoggerManager:CreateLogger(script.Name, "System")

-- * Types
type CameraInput = CameraInput.CameraInput

export type CameraState = CameraTypes.CameraState
export type CameraContext = CameraTypes.CameraContext
export type InputState = CameraTypes.CameraInputState
export type Mode = CameraTypes.Mode
export type ModeName = CameraTypes.ModeName

export type CameraModuleData = {
	_started: boolean,
	_context: CameraContext.CameraContext,
	_manager: CameraModeManager.CameraModeManager,
	_input: CameraInput,
}
export type CameraModule = typeof(setmetatable({} :: CameraModuleData, CameraModule))

-- * Constant
local RENDER_NAME = "CameraModuleRender"
local RENDER_PRIORITY = Enum.RenderPriority.Camera.Value
local DEFAULT_MODE = CameraTypes.Modes.Orbital

-- * Private
function CameraModule:_update(dt: number)
	local cframe, fov = self._manager:Update(dt)

	local camera = workspace.CurrentCamera
	if not camera then
		return
	end

	camera.CFrame = cframe or camera.CFrame
	camera.FieldOfView = fov or camera.FieldOfView
end

-- * Constructor
function CameraModule.new(): CameraModule
	local context = CameraContext.new()
	local data: CameraModuleData = {
		_context = context,
		_manager = CameraModeManager.new(),
		_input = CameraInput.new(context.InputState),
		_started = false,
	}
	local self = setmetatable(data, CameraModule)
	return self
end

-- * Public
function CameraModule:Init()
	self._manager:AutoRegisterModes(self._context)
	self:ChangeMode(DEFAULT_MODE)
	self:Start()
end

function CameraModule:Start()
	if self._started then
		return
	end

	self._started = true

	RunService:BindToRenderStep(RENDER_NAME, RENDER_PRIORITY, function(delta: number)
		self:_update(delta)
	end)
end

function CameraModule:Stop()
	if not self._started then
		return
	end
	self._started = false

	RunService:UnbindFromRenderStep(RENDER_NAME)
end

-- * Mode Controller
function CameraModule:ChangeMode(modeName: ModeName)
	if self._manager:GetCurrentMode() == self._manager:GetMode(modeName) then
		return
	end

	if not CameraTypes.Modes[modeName] then
		Logger:Warn(`Mode "{modeName}" not found! Using default mode: {DEFAULT_MODE}`)
		self:ChangeMode(DEFAULT_MODE)
		return
	end

	Logger:Debug("Gameplay", `Camera mode changed to {modeName}`)
	self._manager:ChangeMode(modeName, self._context)
end

-- * Getters
function CameraModule:GetContext(): CameraContext
	return self._context
end

function CameraModule:GetCurrentMode(): Mode?
	return self._manager:GetCurrentMode()
end

function CameraModule:GetCameraState(): CameraState
	return self._context:GetCameraState()
end

function CameraModule:GetInputState(): InputState
	return self._context:GetInputState()
end

return CameraModule.new()
