local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LightingManager = require(script.Parent.LightingManager)
local LightingPresets = require(script.Parent.LightingPresets)
local HoenKnit = require(ReplicatedStorage.Shared.Core.HoenKnit)

local LightingController = HoenKnit.CreateController({
	Name = "LightingController",
})
local Logger = LightingController._logger
Logger:SetDefaultCategory("Gameplay")

-- * Pulbic API
function LightingController:SetPreset(name: string)
	local preset = LightingPresets[name]
	if not preset then
		Logger:Warn(`Preset "{name}" not found!`)
		return
	end
	Logger:Debug(`Applying Lighting Preset name {name}!`)
	LightingManager:Apply(preset)
	Logger:Debug(`Applied Lighting Preset name {name}!`)
end

-- * Knit API
function LightingController:KnitInit() end
function LightingController:KnitStart()
	LightingManager:Apply(LightingPresets.Default)
end

return LightingController
