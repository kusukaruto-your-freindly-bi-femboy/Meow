--[[ KUSU UI - Linoria Version (Master Loader) ]]--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

--==================================================
-- LOAD MODULES FROM RAW URLS
-- (Replace the URLs below with your actual file hosting links)
--==================================================
local BASE_URL = "https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/"

local Config       = loadstring(game:HttpGet(BASE_URL .. "Config.lua"))()
local Flight       = loadstring(game:HttpGet(BASE_URL .. "Flight.lua"))()
local ESPModule    = loadstring(game:HttpGet(BASE_URL .. "ESP.lua"))()
local GunMods      = loadstring(game:HttpGet(BASE_URL .. "GunMods.lua"))()
local AimbotModule = loadstring(game:HttpGet(BASE_URL .. "Aimbot.lua"))()
local Overlay      = loadstring(game:HttpGet(BASE_URL .. "UIOverlay.lua"))()
local CompatWindow = loadstring(game:HttpGet(BASE_URL .. "CompatWindow.lua"))()

-- Load Linoria Library
local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/Library.lua"
))()

--==================================================
-- INITIALIZE WINDOW & CONTROLS
--==================================================
local LinoriaWindow = Library:CreateWindow({
    Title = "kus-hook ProjectDelta",
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.15
})

local SliderControls = {}
local ToggleControls = {}
local DropdownControls = {}
local KeybindControls = {}
local KeybindStates = {}
local ColorPickerControls = {}

-- Instantiate the compatibility window wrapper
local Window = CompatWindow.Make(
    LinoriaWindow, 
    ToggleControls, 
    SliderControls, 
    DropdownControls, 
    KeybindControls, 
    KeybindStates, 
    ColorPickerControls
)

--==================================================
-- UI OVERLAY & SUBSYSTEM HOOKS
--==================================================

-- Create FPS/Ping overlay window
local keybindOverlay = Overlay.Create(Library, Config.Theme, Config.Theme.SchemeColor)

-- Initialize Aimbot systems
AimbotModule.Init(Config.Aimbot)

-- Apply Gun Mods listener loop
local ammoTypesFolder = ReplicatedStorage:FindFirstChild("AmmoTypes")
if ammoTypesFolder then
    Library:GiveSignal(ammoTypesFolder.ChildAdded:Connect(function()
        task.defer(function()
            GunMods.Apply(Config.GunMods)
        end)
    end))
end

-- Player ESP Events
for _, p in ipairs(Players:GetPlayers()) do
    if p ~= player then
        ESPModule.Create(p, Config)
    end
end

Library:GiveSignal(Players.PlayerAdded:Connect(function(p)
    if p ~= player then
        ESPModule.Create(p, Config)
    end
end))

Library:GiveSignal(Players.PlayerRemoving:Connect(function(p)
    ESPModule.Remove(p)
end))

-- Flight character reset safety
Library:GiveSignal(player.CharacterAdded:Connect(function()
    if Flight.Active then
        Flight:Stop()
    end
end))

-- Main Render Loop (Updates ESP & Aimbot visual elements)
Library:GiveSignal(RunService.RenderStepped:Connect(function()
    -- Update Aimbot FOV
    AimbotModule.UpdateFOV(Config.Aimbot)
end))

-- Cleanup on unload
Library:OnUnload(function()
    Flight:Stop()
    ESPModule.ClearAll()
    GunMods.Restore()
end)

print("[KUSU] Master loader executed successfully!")