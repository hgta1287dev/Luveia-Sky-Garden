local UserInputService = game:GetService("UserInputService")

local GamepadInput = {}
GamepadInput.__index = GamepadInput

export type GamepadInput = typeof(setmetatable(
	{} :: {
		RightStick: Vector2,
		LeftStick: Vector3,
		Triggers: number,
	},
	GamepadInput
))

function GamepadInput.new()
	local self = setmetatable({
		RightStick = Vector2.zero,
		LeftStick = Vector3.zero,
		Triggers = 0,
	}, GamepadInput)

	UserInputService.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Gamepad1 then
			if input.KeyCode == Enum.KeyCode.Thumbstick1 then
				self.LeftStick = Vector3.new(input.Position.X, 0, input.Position.Y)
			elseif input.KeyCode == Enum.KeyCode.Thumbstick2 then
				self.RightStick = Vector2.new(input.Position.X, input.Position.Y)
			elseif input.KeyCode == Enum.KeyCode.ButtonR2 then
				self.Triggers = input.Position.Z
			end
		end
	end)

	return self
end

function GamepadInput:GetDelta()
	local delta = self.RightStick
	local move = self.LeftStick
	local zoom = self.Triggers
	self.RightStick = Vector2.zero
	self.LeftStick = Vector3.zero
	self.Triggers = 0
	return delta, move, zoom
end

return GamepadInput
