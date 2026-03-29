local CameraInputState = require(script.Parent.CameraInputState)
local CameraState = require(script.Parent.CameraState)

local CameraContext = {}
CameraContext.__index = CameraContext

-- * Types
export type CameraInputState = CameraInputState.InputState
export type CameraState = CameraState.CameraState
export type CameraContextData = {
	CameraState: CameraState,
	InputState: CameraInputState,
}

export type CameraContext = typeof(setmetatable({} :: CameraContextData, CameraContext))

-- * Constructor
function CameraContext.new(state: CameraState?, inputState: CameraInputState?): CameraContext
	local self = setmetatable({
		CameraState = state or CameraState.new(),
		InputState = inputState or CameraInputState.new(),
	}, CameraContext)

	return self
end

-- Get camera state
function CameraContext:GetCameraState(): CameraState
	return self.CameraState
end

function CameraContext:GetModeState(modeName: string): any?
	local states = self:GetModeStates()
	local modeState = states[modeName]
	return modeState
end

function CameraContext:GetInputState(): CameraInputState
	return self.InputState
end

-- Reset input
function CameraContext:ResetInput()
	self.InputState.DeltaYaw = 0
	self.InputState.DeltaPitch = 0
	self.InputState.Zoom = 0
	self.InputState.Move = Vector3.zero
end

return CameraContext
