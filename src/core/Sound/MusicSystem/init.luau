local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Signal = require(ReplicatedStorage.Packages.Signal)
local SoundController = require(script.Parent.SoundController)

local MusicSystem = {}
MusicSystem.__index = MusicSystem

export type RepeatMode = "None" | "All" | "One"

function MusicSystem.new(soundController: any?)
	local self = setmetatable({}, MusicSystem)

	self.sound = soundController or SoundController
	self.playlists = {}
	self.stateMap = {}

	self.currentPlaylistId = nil
	self.currentIndex = 0
	self.currentTrack = nil
	self.currentSound = nil
	self.currentState = nil
	self.currentEndedConnection = nil

	self.shuffle = false
	self.repeatMode = "All"
	self.playToken = 0

	-- self.SongPlayed = Signal.new()
	-- self.SongStopped = Signal.new()
	-- self.SongEnded = Signal.new()
	-- self.SongPaused = Signal.new()
	-- self.SongContinued = Signal.new()

	return self
end

function MusicSystem:_disconnectEndedConnection()
	if self.currentEndedConnection then
		self.currentEndedConnection:Disconnect()
		self.currentEndedConnection = nil
	end
end

function MusicSystem:AddPlaylist(id: string, tracks: { string })
	self.playlists[id] = table.clone(tracks)
end

function MusicSystem:RemovePlaylist(id: string)
	if self.currentPlaylistId == id then
		self:Stop()
	end
	self.playlists[id] = nil
end

function MusicSystem:GetPlaylist(id: string): { string }?
	return self.playlists[id]
end

function MusicSystem:SetShuffle(enabled: boolean)
	self.shuffle = enabled
end

function MusicSystem:ToggleShuffle()
	self:SetShuffle(not self.shuffle)
end

function MusicSystem:SetRepeatMode(mode: RepeatMode)
	self.repeatMode = mode
end

function MusicSystem:ToggleRepeatMode()
	if self.repeatMode == "None" then
		self:SetRepeatMode("All")
	elseif self.repeatMode == "All" then
		self:SetRepeatMode("One")
	else
		self:SetRepeatMode("None")
	end
end

function MusicSystem:SetState(state: string)
	self.currentState = state

	local playlistId = self.stateMap[state]
	if playlistId then
		self:PlayPlaylist(playlistId)
	end
end

function MusicSystem:PlayPlaylist(id: string, startIndex: number?)
	local playlist = self.playlists[id]
	if not playlist or #playlist == 0 then
		warn(`Playlist {id} not found or empty`)
		return
	end

	self.currentPlaylistId = id
	self.currentIndex = math.clamp(startIndex or 1, 1, #playlist)

	self:PlayCurrent()
end

function MusicSystem:PlayTrack(trackName: string)
	self:_disconnectEndedConnection()

	self.currentPlaylistId = nil
	self.currentIndex = 0
	self.currentTrack = trackName
	self.currentSound = nil

	self.playToken += 1
	local token = self.playToken

	local sound = self.sound:PlayMusic(trackName)
	self.currentSound = sound

	if sound and not sound.Looped then
		self.currentEndedConnection = sound.Ended:Connect(function()
			if self.playToken ~= token then
				return
			end
			self:Next()
		end)
	end
end

function MusicSystem:_getPlaylist()
	if not self.currentPlaylistId then
		return nil
	end

	return self.playlists[self.currentPlaylistId]
end

function MusicSystem:_pickNextIndex(playlist: { string }): number?
	if #playlist == 0 then
		return nil
	end

	if self.shuffle then
		if #playlist == 1 then
			return 1
		end

		local nextIndex = math.random(1, #playlist)
		if nextIndex == self.currentIndex then
			nextIndex = (nextIndex % #playlist) + 1
		end
		return nextIndex
	end

	local nextIndex = self.currentIndex + 1
	if nextIndex > #playlist then
		if self.repeatMode == "All" then
			return 1
		end
		return nil
	end

	return nextIndex
end

function MusicSystem:PlayCurrent()
	local playlist = self:_getPlaylist()
	if not playlist then
		return
	end

	local trackName = playlist[self.currentIndex]
	if not trackName then
		return
	end

	self:_disconnectEndedConnection()

	self.playToken += 1
	local token = self.playToken
	local previousTrack = self.currentTrack

	local sound
	if previousTrack then
		sound = self.sound:CrossfadeMusic(previousTrack, trackName, 1)
	else
		sound = self.sound:PlayMusic(trackName)
	end

	self.currentTrack = trackName
	self.currentSound = sound

	if sound and not sound.Looped then
		self.currentEndedConnection = sound.Ended:Connect(function()
			if self.playToken ~= token then
				return
			end
			self:Next()
		end)
	end
end

function MusicSystem:Next()
	local playlist = self:_getPlaylist()
	if not playlist then
		return
	end

	local nextIndex = self:_pickNextIndex(playlist)
	if not nextIndex then
		if self.repeatMode == "One" and self.currentTrack then
			self:PlayCurrent()
		end
		return
	end

	self.currentIndex = nextIndex
	self:PlayCurrent()
end

function MusicSystem:Previous()
	local playlist = self:_getPlaylist()
	if not playlist then
		return
	end

	local prevIndex = self.currentIndex - 1
	if prevIndex < 1 then
		if self.repeatMode == "All" then
			prevIndex = #playlist
		elseif self.repeatMode == "One" and self.currentTrack then
			self:PlayCurrent()
			return
		else
			prevIndex = 1
		end
	end

	self.currentIndex = prevIndex
	self:PlayCurrent()
end

function MusicSystem:Pause()
	if self.currentSound then
		self.currentSound:Pause()
	end
end

function MusicSystem:Resume()
	if self.currentSound then
		self.currentSound:Resume()
	end
end

function MusicSystem:Stop()
	self.playToken += 1
	self:_disconnectEndedConnection()

	self.sound:StopMusic()
	self.currentSound = nil
	self.currentTrack = nil
	self.currentPlaylistId = nil
	self.currentIndex = 0
end

function MusicSystem:TogglePause()
	if self.currentSound then
		if self.currentSound.IsPlaying then
			self:Pause()
		else
			self:Resume()
		end
	end
end

function MusicSystem:IsPlaying(): boolean
	return self.currentSound and self.currentSound.IsPlaying or false
end

return MusicSystem.new()
