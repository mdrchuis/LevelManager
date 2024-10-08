-- Author: mdrchuisfrancais
-- This is a module script
-- The purpose of this script is to easily load and unload the levels of a game (Can also load different stuff related to map)

-----------------------------------------------

local Players = game:GetService("Players")

local RunService = game:GetService("RunService")

local ReplicatedFirst = game:GetService("ReplicatedFirst")
local Data = ReplicatedFirst:WaitForChild("Data")
local Levels = require(Data:WaitForChild("Levels"))

local Map = game:GetService("Workspace"):WaitForChild("LoadedMap")

-----------------------------------------------

local CheckLevel = function(Level: string)
	if Levels[Level] then
		return Levels[Level]
	else
		return false
	end
end

local LoadMap = function(Level: Folder)
	for _,Folder: Folder in Level:GetChildren() do
		if not Folder:IsA("Configuration") then
			for _,Object: Instance in Folder:GetChildren() do
				if Object:IsA("Model") then
					game:GetService("ContentProvider"):PreloadAsync(Object:GetChildren())
				else
					game:GetService("ContentProvider"):PreloadAsync(Folder:GetChildren())
				end
			end
		end
	end
	Level.Parent = Map
end

local LoadConfig = function(Config: Configuration)
	-- You can do stuff with level config, such as setting up the player's walkspeed or such, depends on your likings
	-- Example:
	
	local Player = Players.LocalPlayer
	local Character = Player.Character or Player.CharacterAdded:Wait()
	local Humanoid: Humanoid = Character:FindFirstChild("Humanoid")

	if not Humanoid then return end

	-- Here, we can use intvalues to define the level's set default walkspeed and jump height
	Humanoid.WalkSpeed = Config:FindFirstChild("WalkSpeed").Value
	Humanoid.JumpHeight = Config:FindFirstChild("JumpHeight").Value

	-- Here, we can use a string value to define the camera type (example: Follow)
	local CameraType = Config:FindFirstChild("CameraType").Value
	if CameraType == "Classic" then
		local Camera = game:GetService("Workspace").CurrentCamera
		Camera.CameraType = Enum.CameraType.Follow
	end

	-- As a last example, here we can use a boolvalue to define if the level is a boss fight
	local IsBossFight = Config:FindFirstChild("IsBossFight").Value
	if IsBossFight then
		-- You can do something if it's a boss fight
	end
end

-----------------------------------------------

local LevelManager = {}

LevelManager.LoadLevel = function(Level: string)
	if not RunService:IsClient() then return end
	
	local Player = Players.LocalPlayer
	local Character = Player.Character or Player.CharacterAdded:Wait()
	
	local HumanoidRootPart: Part = Character:WaitForChild("HumanoidRootPart")
	HumanoidRootPart.Anchored = true
	
	local Level = CheckLevel(Level)
	if not Level then return end

	local LevelMap = Level.LevelMap:Clone()
	local LevelConfig = Level.LevelConfig
	local SpawnLocation = LevelMap:WaitForChild("SpawnLocation")

	LoadMap(LevelMap)
	LoadConfig(LevelConfig)

	task.delay(1, function()
		local Character = Player.Character
		if Character then 
			HumanoidRootPart.CFrame = SpawnLocation.CFrame
			HumanoidRootPart.Anchored = false
		end 
	end)
end

LevelManager.UnloadLevel = function(Level: string)
	if not Level then 
		for _,Level in Map:GetChildren() do Level:Destroy() end
		return
	end
	local Level = Map:FindFirstChild(Level)
	
	Level:Destroy()
end

return LevelManager
