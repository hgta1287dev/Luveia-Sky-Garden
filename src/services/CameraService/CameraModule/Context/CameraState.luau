local CameraState = {}

-- * Types
export type OrbitState = {
	TargetYaw: number,
	TargetPitch: number,
	TargetDistance: number,
}

export type FreeState = {
	Speed: number,
}

export type CameraState = {
	-- * Objects Reference
	CameraTarget: BasePart?,
	LookAtTarget: BasePart?,

	-- * Offsets
	PivotOffset: Vector3,
	CameraOffset: Vector3,

	-- * Camera Settings
	Sensitivity: number,
	SmoothFactor: number,

	-- * FOV Zoomer
	ZoomFOV: number,
	ZoomFOVSpeed: number,

	-- * Distance Zoomer
	ZoomDistanceMin: number,
	ZoomDistanceMax: number,
	ZoomDistanceSpeed: number,

	-- * Camera Modes
	Orbit: OrbitState,
	Free: FreeState,
}

function CameraState.new(): CameraState
	return {
		CameraTarget = nil, -- camera target
		LookAtTarget = nil, -- lookAt target

		PivotOffset = Vector3.zero, -- offset from target
		CameraOffset = Vector3.zero, -- offset from pivot

		ZoomFOV = 70,
		ZoomFOVSpeed = 1,

		Sensitivity = 1,
		SmoothFactor = 1,

		ZoomDistanceMin = 10,
		ZoomDistanceMax = 50,
		ZoomDistanceSpeed = 100,

		Orbit = {
			TargetYaw = 0,
			TargetPitch = 0,
			TargetDistance = 5,
		},

		Free = {
			Speed = 5,
		},
	}
end

return CameraState
