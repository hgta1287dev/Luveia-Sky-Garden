local UserInputService = game:GetService("UserInputService")

local MouseInput = {}
MouseInput.__index = MouseInput

export type MouseInput = typeof(setmetatable(
	{} :: {
		Delta: Vector2,
		Wheel: number,
	},
	MouseInput
))

function MouseInput.new(): MouseInput
	local self = setmetatable({
		Delta = Vector2.zero,
		Wheel = 0,
	}, MouseInput)

	UserInputService.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			self.Delta = Vector2.new(input.Delta.X, input.Delta.Y)
		elseif input.UserInputType == Enum.UserInputType.MouseWheel then
			self.Wheel = input.Position.Z
		end
	end)

	return self
end

function MouseInput:GetDelta()
	local delta = self.Delta
	local wheel = self.Wheel
	self.Delta = Vector2.zero
	self.Wheel = 0
	return delta, wheel
end

return MouseInput
