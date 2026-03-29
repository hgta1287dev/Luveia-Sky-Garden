local InputState = {}

export type InputState = {
	DeltaYaw: number,
	DeltaPitch: number,
	Zoom: number,
	Move: Vector3,
}

function InputState.new()
	local self = setmetatable({
		DeltaYaw = 0,
		DeltaPitch = 0,
		Zoom = 0,
		Move = Vector3.zero,
	}, InputState)

	return self
end

return InputState
