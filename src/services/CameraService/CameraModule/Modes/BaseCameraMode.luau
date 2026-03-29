local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CameraContext = require(ReplicatedStorage.Shared.Services.CameraService.CameraModule.Context.CameraContext)
local BaseMode = {}
BaseMode.__index = BaseMode

-- * Types
type CameraContext = CameraContext.CameraContext
export type BaseMode = {
	context: CameraContext?,
	Enter: (self: BaseMode, context: CameraContext) -> (),
	Exit: (self: BaseMode) -> (),
	Update: (self: BaseMode, dt: number) -> (CFrame?, number?), -- CFrame, FOV
}

function BaseMode.new(): BaseMode
	local self = setmetatable({
		context = nil,
	}, BaseMode)
	return self
end

function BaseMode:Enter(context: CameraContext)
	self.context = context
end

-- Called every frame
function BaseMode:Update(dt)
	return
end

-- Called when mode exit to another mode
function BaseMode:Exit()
	self.context = nil
end

function BaseMode:Destroy()
	table.clear(self)
	setmetatable(self, nil)
end

return BaseMode
