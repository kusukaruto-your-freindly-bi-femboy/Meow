--[[ KUSU UI - Linoria Version (Master Loader) ]]--

print("[KUSU] Master loader initializing...")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

--==================================================
-- LOAD MODULES FROM RAW URLS
--==================================================
local BASE_URL = "https://raw.githubusercontent.com/kusukaruto-your-freindly-bi-femboy/Meow/main/"

local Config       = loadstring(game:HttpGet(BASE_URL .. "config.lua"))()
local Flight       = loadstring(game:HttpGet(BASE_URL .. "flight.lua"))()
local ESPModule    = loadstring(game:HttpGet(BASE_URL .. "esp.lua"))()
local GunMods      = loadstring(game:HttpGet(BASE_URL .. "gunmods.lua"))()
local AimbotModule = loadstring(game:HttpGet(BASE_URL .. "aimbot.lua"))()
local Overlay      = loadstring(game:HttpGet(BASE_URL .. "uioverlay.lua"))()
local CompatWindow = loadstring(game:HttpGet(BASE_URL .. "compatwindow.lua"))()

print("[KUSU] All modules fetched successfully.")

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

-- Build UI tabs and elements
Overlay.Create(Window, Config, AimbotModule, ESPModule, GunMods, Flight, Players)

print("[KUSU] Initializing Aimbot...")
AimbotModule.Init(Config.Aimbot)

-- Check gun mods folder
local ammoTypesFolder = ReplicatedStorage:FindFirstChild("AmmoTypes")
if ammoTypesFolder then
    print("[KUSU] AmmoTypes folder found, applying gun mods...")
    GunMods.Apply(Config.GunMods)
    Library:GiveSignal(ammoTypesFolder.ChildAdded:Connect(function()
        task.defer(function()
            GunMods.Apply(Config.GunMods)
        end)
    end))
else
    print("[KUSU] Note: AmmoTypes folder not found right now (will apply if it loads later).")
    task.spawn(function()
        local foundFolder = ReplicatedStorage:WaitForChild("AmmoTypes", 5)
        if foundFolder then
            print("[KUSU] AmmoTypes folder loaded late, applying gun mods now.")
            GunMods.Apply(Config.GunMods)
        end
    end)
end

print("[KUSU] Setting up ESP for existing players...")
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

Library:GiveSignal(player.CharacterAdded:Connect(function()
    if Flight.Active then
        Flight:Stop()
    end
end))

Library:GiveSignal(RunService.RenderStepped:Connect(function()
    AimbotModule.UpdateFOV(Config.Aimbot)
end))

Library:OnUnload(function()
    Flight:Stop()
    ESPModule.ClearAll()
    GunMods.Restore()
end)

print("[KUSU] UI and all subsystems loaded completely!")