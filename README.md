# LevelManager
## A module used to help load and unload levels/part of the maps easily.

Benefits of using LevelManager:
- Automatically spawn a player once the map is loaded, save up some time
- Easily configurable levels/zones
- Helps to keep a clean code.

## Level template example

![image](https://cdn.discordapp.com/attachments/784092716665012224/1272974429663793213/image.png?ex=66bced52&is=66bb9bd2&hm=3dbdee274a0743769999032154438f6b08c0f96e5cdb7fee9979e1a97ed9f67a&)

- Only mandatories are "Configuration" and "SpawnLocation"
- However, make sure that you put any part of the map into a folder. It can be one unique folder, or multiple folders.

## Example of usage
### On client callback
```lua
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local Modules = ReplicatedFirst:WaitForChild("Modules")
local LevelManager = require(Modules:WaitForChild("LevelManager"))

local Map = game:GetService("Workspace"):WaitForChild("LoadedMap")

local LoadLevel = LevelManager.LoadLevel
local UnloadLevel = LevelManager.UnloadLevel

local GUI: ScreenGui = script.Parent
local LevelOneButton: TextButton = GUI:WaitForChild("LevelOneButton")
local LevelTwoButton: TextButton = GUI:WaitForChild("LevelTwoButton")

local BindButtonToLevel = function(Button: TextButton, Level: string)
	Button.MouseButton1Down:Connect(function()
		UnloadLevel() -- Use this to unload the entire map
		LoadLevel(Level) -- Load the level
	end)
end

BindButtonToLevel(LevelOneButton, "Level 1")
BindButtonToLevel(LevelTwoButton, "Level 2")
```
### On client event
```lua
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local Modules = ReplicatedFirst:WaitForChild("Modules")
local LevelManager = require(Modules:WaitForChild("LevelManager"))


local LoadLevel = LevelManager.LoadLevel
local UnloadLevel = LevelManager.UnloadLevel

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Events = ReplicatedStorage:WaitForChild("Events")
local LoadEvent = Events:WaitForChild("LoadEvent")

LoadEvent.OnClientEvent:Connect(function(Level)
	UnloadLevel()
	LoadLevel(Level)
end)
```
