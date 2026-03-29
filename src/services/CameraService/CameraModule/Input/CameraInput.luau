local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local CameraTypes = require(ReplicatedStorage.Shared.Services.CameraService.CameraModule.Config.CameraTypes)
local CameraGamepadInput = require(script.Parent.CameraGamepadInput)
local CameraMouseInput = require(script.Parent.CameraMouseInput)
local CameraTouchInput = require(script.Parent.CameraTouchInput)

local CameraInput = {}
CameraInput.__index = CameraInput

export type CameraInputState = CameraTypes.CameraInputState
export type CameraInputData = {
	InputState: CameraInputState,
	Mouse: CameraMouseInput.MouseInput,
	Gamepad: CameraGamepadInput.GamepadInput,
	Touch: CameraTouchInput.TouchInput,
}
export type CameraInput = typeof(setmetatable({} :: CameraInputData, CameraInput))

function CameraInput.new(inputState: CameraInputState): CameraInput
	local self = setmetatable({
		InputState = inputState,
		Mouse = CameraMouseInput.new(),
		Gamepad = CameraGamepadInput.new(),
		Touch = CameraTouchInput.new(),
	}, CameraInput)

	self:Start()
	return self
end

function CameraInput:Start()
	RunService:BindToRenderStep("CameraInputUpdate", Enum.RenderPriority.Input.Value, function(dt)
		self:Update(dt)
	end)
end

function CameraInput:Stop()
	RunService:UnbindFromRenderStep("CameraInputUpdate")
end

function CameraInput:Update(dt)
	local input = self.InputState :: CameraInputState
	-- reset first
	input.DeltaYaw = 0
	input.DeltaPitch = 0
	input.Zoom = 0
	input.Move = Vector3.zero

	-- merge from all devices
	local mouseDelta, mouseZoom = self.Mouse:GetDelta()
	local gamepadDelta, gamepadMove, gamepadZoom = self.Gamepad:GetDelta()
	local touchDelta, touchZoom = self.Touch:GetDelta()

	input.DeltaYaw = mouseDelta.X + gamepadDelta.X + touchDelta.X
	input.DeltaPitch = mouseDelta.Y + gamepadDelta.Y + touchDelta.Y
	input.Zoom = mouseZoom + gamepadZoom + touchZoom
	input.Move = gamepadMove

	-- reverse
	input.DeltaYaw *= -1
	input.DeltaPitch *= -1
	input.Zoom *= -1
end

function CameraInput:GetInputState(): CameraInputState
	return self.InputState
end

return CameraInput
