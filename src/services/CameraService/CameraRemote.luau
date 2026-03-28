local CameraModule = require(script.Parent.CameraModule)

local CameraRemote = {}

function CameraRemote:Reset()
	CameraModule:SetCameraView("Default")
end

function CameraRemote:SetHost(part)
	print(part:GetFullName())
	CameraModule:SetCameraHost(part)
end

function CameraRemote:Watch(part)
	CameraModule:SetCameraView("Orbital")
	self:SetHost(part)
end

return CameraRemote
