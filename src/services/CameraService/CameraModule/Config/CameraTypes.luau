local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CameraContext = require(ReplicatedStorage.Shared.Services.CameraService.CameraModule.Context.CameraContext)
local BaseCameraMode = require(ReplicatedStorage.Shared.Services.CameraService.CameraModule.Modes.BaseCameraMode)

-- * Types
export type CameraContext = CameraContext.CameraContext
export type CameraState = CameraContext.CameraState
export type CameraInputState = CameraContext.CameraInputState
export type Mode = BaseCameraMode.BaseMode
export type ModeName = "CylindricalOrbital" | "Orbital" | "Free"

-- * Constant
local Modes = {
	CylindricalOrbital = "CylindricalOrbital",
	Orbital = "Orbital",
	Free = "Free",
}

return {
	Modes = Modes,
}
