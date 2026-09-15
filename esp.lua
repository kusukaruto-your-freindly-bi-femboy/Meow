--[[ KUSU UI - ESP Module ]]--
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local ESPModule = {}
local playerEspDrawings = {}
local player = Players.LocalPlayer

local function hidePlayerESP(esp)
    if not esp then return end
    esp.Box.Visible = false
    esp.HealthBar.Visible = false
    esp.NameText.Visible = false
    esp.DistText.Visible = false
    esp.Tracer.Visible = false
end

function ESPModule.Create(p, Config)
    if not Drawing or playerEspDrawings[p] then return end

    local box = Drawing.new("Square")
    box.Thickness = 1
    box.Filled = false
    box.Color = Config.Visuals.Colors.Boxes
    box.Visible = false

    local hpBar = Drawing.new("Line")
    hpBar.Thickness = 2
    hpBar.Color = Config.Visuals.Colors.HealthBar
    hpBar.Visible = false

    local nameText = Drawing.new("Text")
    nameText.Size = 12
    nameText.Font = 2
    nameText.Center = true
    nameText.Outline = true
    nameText.Color = Config.Visuals.Colors.Names
    nameText.Visible = false

    local distText = Drawing.new("Text")
    distText.Size = 11
    distText.Font = 2
    distText.Center = true
    distText.Outline = true
    distText.Color = Config.Visuals.Colors.Distance
    distText.Visible = false

    local tracer = Drawing.new("Line")
    tracer.Thickness = 1
    tracer.Color = Config.Visuals.Colors.Tracers
    tracer.Visible = false

    playerEspDrawings[p] = {
        Box = box, HealthBar = hpBar, NameText = nameText, DistText = distText, Tracer = tracer
    }
end

function ESPModule.Remove(p)
    local esp = playerEspDrawings[p]
    if not esp then return end

    pcall(function() esp.Box:Remove() end)
    pcall(function() esp.HealthBar:Remove() end)
    pcall(function() esp.NameText:Remove() end)
    pcall(function() esp.DistText:Remove() end)
    pcall(function() esp.Tracer:Remove() end)

    playerEspDrawings[p] = nil
end

function ESPModule.ClearAll()
    for p in pairs(playerEspDrawings) do
        ESPModule.Remove(p)
    end
end

return ESPModule