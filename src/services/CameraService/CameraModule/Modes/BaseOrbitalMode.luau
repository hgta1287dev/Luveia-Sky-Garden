local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- src/services/CameraService/CameraModule/Modes/BaseCameraOrbitalMode.luau
local CameraTypes = require(ReplicatedStorage.Shared.Services.CameraService.CameraModule.Config.CameraTypes)
local BaseCameraMode = require(script.Parent.BaseCameraMode)

local BaseCameraOrbitalMode = setmetatable({}, BaseCameraMode)
BaseCameraOrbitalMode.__index = BaseCameraOrbitalMode

-- * Types
type CameraContext = CameraTypes.CameraContext

-- * Constructor
function BaseCameraOrbitalMode.new()
	local self = setmetatable(BaseCameraMode.new(), BaseCameraOrbitalMode)

	-- * Internal state
	self._currentYaw = 0
	self._currentPitch = 0
	self._currentDistance = 0

	self._lockPitch = false
	self._lockYaw = false

	self._pitchLimits = Vector2.new(-89, 89) -- min, max in degrees (-90 to 90) --! -90 and 90 can cause gimball lock
	self._yawLimits = nil -- nil = unlock
	self._distanceLimits = Vector2.new(5, 40)

	return self
end

function BaseCameraOrbitalMode:Enter(context: CameraContext)
	BaseCameraMode.Enter(self, context)
	local cameraState = context:GetCameraState()

	self._currentYaw = cameraState.Orbit.TargetYaw
	self._currentPitch = cameraState.Orbit.TargetPitch
	self._currentDistance = cameraState.Orbit.TargetDistance
end

function BaseCameraOrbitalMode:Update(dt)
	local context = self.context :: CameraContext
	if not context then
		return
	end

	local cameraState = context:GetCameraState()
	local inputState = context:GetInputState()
	local smooth = cameraState.SmoothFactor
	local speed = cameraState.Sensitivity
	local alpha = dt * speed * smooth

	-- Input handling
	cameraState.Orbit.TargetYaw += inputState.DeltaYaw
	cameraState.Orbit.TargetPitch += inputState.DeltaPitch
	cameraState.Orbit.TargetDistance += inputState.Zoom

	-- Clamp
	if self._pitchLimits then
		cameraState.Orbit.TargetPitch =
			math.clamp(cameraState.Orbit.TargetPitch, self._pitchLimits.X, self._pitchLimits.Y)
	end

	if self._yawLimits then
		cameraState.Orbit.TargetYaw = math.clamp(cameraState.Orbit.TargetYaw, self._yawLimits.X, self._yawLimits.Y)
	end

	if self._distanceLimits then
		cameraState.Orbit.TargetDistance =
			math.clamp(cameraState.Orbit.TargetDistance, self._distanceLimits.X, self._distanceLimits.Y)
	end

	-- lerp state
	self._currentYaw = math.lerp(self._currentYaw, cameraState.Orbit.TargetYaw, alpha)
	self._currentPitch = math.lerp(self._currentPitch, cameraState.Orbit.TargetPitch, alpha)
	self._currentDistance = math.lerp(self._currentDistance, cameraState.Orbit.TargetDistance, alpha)

	-- origin: target + pivot
	local origin = ((cameraState.LookAtTarget and cameraState.LookAtTarget.Position) or Vector3.zero)
		+ cameraState.PivotOffset

	local rotationCFrame = self:_GetRotationCFrame(self._currentYaw, self._currentPitch)

	local orbitOffset = rotationCFrame * Vector3.new(0, 0, self._currentDistance)
	local target = origin + orbitOffset

	return CFrame.lookAt(target, origin) * CFrame.new(cameraState.CameraOffset)
end

-- * Abstract: get rotation CFrame from yaw and pitch
function BaseCameraOrbitalMode:_GetRotationCFrame(yaw: number, pitch: number): CFrame
	return CFrame.fromEulerAnglesYXZ(math.rad(pitch), math.rad(yaw), 0)
end

-- * Exit
function BaseCameraOrbitalMode:Exit()
	BaseCameraMode.Exit(self)
	self._currentYaw = 0
	self._currentPitch = 0
	self._currentDistance = 0
end

return BaseCameraOrbitalMode
