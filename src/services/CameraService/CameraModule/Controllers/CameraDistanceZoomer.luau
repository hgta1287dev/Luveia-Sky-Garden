local DistanceZoomer = {}
DistanceZoomer.__index = DistanceZoomer

-- * Constructor
function DistanceZoomer.new(config)
	return setmetatable({
		min = config.ZoomMin,
		max = config.ZoomMax,
		speed = config.ZoomSpeed,
		targetDistance = nil,
	}, DistanceZoomer)
end

-- * Public
function DistanceZoomer:Init(distance)
	self.targetDistance = distance
end

function DistanceZoomer:Zoom(delta)
	if not self.targetDistance then
		return
	end

	self.targetDistance -= delta * self.speed
	self.targetDistance = math.clamp(self.targetDistance, self.min, self.max)
end

function DistanceZoomer:Get()
	return self.targetDistance
end

return DistanceZoomer
