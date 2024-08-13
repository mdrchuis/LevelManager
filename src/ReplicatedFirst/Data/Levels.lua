-- Author: mdrchuisfrancais
-- This is a module script
-- The purpose of this script is to gather the list of every levels in the game easily

-----------------------------------------------

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LevelsFolder = ReplicatedStorage:WaitForChild("Levels")

-----------------------------------------------

local Levels = {}

for _,Level in LevelsFolder:GetChildren() do
	Levels[Level.Name] = {}
	Levels[Level.Name].LevelMap = Level
	Levels[Level.Name].LevelConfig = Level:WaitForChild("Configuration")
end

return Levels
