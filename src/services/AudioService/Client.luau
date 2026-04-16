local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HoenKnit = require(ReplicatedStorage.Shared.Core.HoenKnit)
local MusicSystem = require(ReplicatedStorage.Shared.Core.Sound.MusicSystem)
local SoundController = require(ReplicatedStorage.Shared.Core.Sound.SoundController)
local AudioController = HoenKnit.CreateController({
	Name = "AudioController",
})

function AudioController:GetSoundController()
	return SoundController
end

function AudioController:GetMusicSystem()
	return MusicSystem
end

function AudioController:KnitStart() end

function AudioController:KnitInit() end

return AudioController
