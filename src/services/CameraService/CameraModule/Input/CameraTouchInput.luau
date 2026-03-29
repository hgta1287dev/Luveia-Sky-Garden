local UserInputService = game:GetService("UserInputService")

local TouchInput = {}
TouchInput.__index = TouchInput

export type TouchInput = typeof(setmetatable(
	{} :: {
		Delta: Vector2,
		Zoom: number,
	},
	TouchInput
))

function TouchInput.new(): TouchInput
	local self = setmetatable({
		Delta = Vector2.zero,
		Zoom = 0,
	}, TouchInput)

	local lastPos = nil
	-- local lastDistance = nil

	UserInputService.TouchMoved:Connect(function(touch)
		if lastPos then
			local delta = touch.Position - lastPos
			self.Delta = Vector2.new(delta.X, delta.Y)
		end
		lastPos = touch.Position
	end)

	-- pinch zoom
	UserInputService.TouchPinch:Connect(function(pinches)
		self.Zoom = pinches.Position.Z
	end)

	return self
end

function TouchInput:GetDelta()
	local delta = self.Delta
	local zoom = self.Zoom
	self.Delta = Vector2.zero
	self.Zoom = 0
	return delta, zoom
end

return TouchInput
