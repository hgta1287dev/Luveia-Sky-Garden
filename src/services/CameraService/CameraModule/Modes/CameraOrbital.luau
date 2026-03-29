local BaseOrbitalMode = require(script.Parent.BaseOrbitalMode)

local CameraOrbital = setmetatable({}, BaseOrbitalMode)
CameraOrbital.__index = CameraOrbital

return CameraOrbital
