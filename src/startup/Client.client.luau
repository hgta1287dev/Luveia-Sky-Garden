local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DevPanel = require(ReplicatedStorage.Shared.Core.DevPanel)
local LoggerManager = require(ReplicatedStorage.Shared.Core.LoggerManager)
local KnitBootstrap = require(ReplicatedStorage.SharedStartup.KnitBootstrap)
local ServiceLoader = require(ReplicatedStorage.SharedStartup.ServiceLoader)

local Logger = LoggerManager:CreateLogger("Bootstrap", "System")

Logger:Info(`Booting Up Game!`)
DevPanel:Init()

warn("Boot")
ServiceLoader:Init()
warn("Boot")

KnitBootstrap:Init()

Logger:Info(`Game Booted Successfully!`)
