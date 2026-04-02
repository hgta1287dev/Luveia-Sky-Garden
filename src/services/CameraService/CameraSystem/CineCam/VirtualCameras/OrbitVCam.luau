local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CameraContext =
	require(ReplicatedStorage.Shared.Services.CameraService.CameraSystem.CineCam.Context.CameraContext)
local CameraLookAtModule =
	require(ReplicatedStorage.Shared.Services.CameraService.CameraSystem.CineCam.Pipe.Modules.Aim.CameraLookAtModule)
local CameraTargetObjectModule = require(
	ReplicatedStorage.Shared.Services.CameraService.CameraSystem.CineCam.Pipe.Modules.Extensions.CameraTargetObjectModule
)
local CameraOffsetModule =
	require(ReplicatedStorage.Shared.Services.CameraService.CameraSystem.CineCam.Pipe.Modules.Noise.CameraOffsetModule)
local CameraOrbitModule = require(script.Parent.Parent.Pipe.Modules.Body.CameraOrbitModule)
local BaseVirtualCamera = require(script.Parent.Parent.VirtualCameras.BaseVCam)

-- * Orbit
local OrbitVCam = {}
OrbitVCam.__index = OrbitVCam

-- * Types
type CameraContext = CameraContext.CameraContext

-- * Consants
local KEYBOARD_YAW_SPEED = 10
local KEYBOARD_PITCH_SPEED = 5

-- * Helpers
local function GetTestPart()
	local part = Instance.new("Part")
	part.Anchored = true
	part.Size = Vector3.one * 2
	part.Parent = workspace
	return part
end

-- * Constructor
function OrbitVCam.new()
	local orbitModule = CameraOrbitModule.new()
	local lookAtModule = CameraLookAtModule.new()
	local offsetModule = CameraOffsetModule.new()
	local objectTargetModule = CameraTargetObjectModule.new(nil, GetTestPart())

	orbitModule.Distance.SmoothFactor = 6
	orbitModule.Yaw.SmoothFactor = 4
	orbitModule.Pitch.SmoothFactor = 5

	local self = setmetatable(
		BaseVirtualCamera.new({
			objectTargetModule,
			orbitModule,
			lookAtModule,
			offsetModule,
		}),
		OrbitVCam
	)

	function self:_updateOrbitInput(context: CameraContext)
		local input = context.InputState
		local mouseState = input.MouseState
		local keyboardState = input.KeyboardState

		local yawDelta, pitchDelta = 0, 0

		orbitModule.Distance:AdjustTarget(mouseState.ScrollDelta)
		if mouseState.ButtonsDown:Has(Enum.UserInputType.MouseButton2) then
			yawDelta += mouseState.MoveDelta.X
			pitchDelta += mouseState.MoveDelta.Y
		end

		if keyboardState.KeysDown:Has(Enum.KeyCode.A) then
			yawDelta -= KEYBOARD_YAW_SPEED
		end

		if keyboardState.KeysDown:Has(Enum.KeyCode.D) then
			yawDelta += KEYBOARD_YAW_SPEED
		end

		if keyboardState.KeysDown:Has(Enum.KeyCode.W) then
			pitchDelta -= KEYBOARD_PITCH_SPEED
		end

		if keyboardState.KeysDown:Has(Enum.KeyCode.S) then
			pitchDelta += KEYBOARD_PITCH_SPEED
		end

		orbitModule.Yaw:AdjustTarget(yawDelta)
		orbitModule.Pitch:AdjustTarget(pitchDelta)
	end

	return self
end

-- * Methods
function OrbitVCam:Update(context: CameraContext, output)
	-- input
	self:_updateOrbitInput(context)

	-- ouput
	local result = BaseVirtualCamera.Update(self, context)
	output.Cframe = result.Body * result.Aim * result.Noise
	output.Fov = result.Fov
end

return OrbitVCam
