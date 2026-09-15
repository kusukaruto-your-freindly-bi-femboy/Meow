--[[ KUSU UI - Overlay & Utilities Module ]]--
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")

local Overlay = {}

function Overlay.Create(Library, theme, pink)
    local keybindOverlay = Instance.new("Frame")
    keybindOverlay.Name = "KusuKeybinds"
    keybindOverlay.AnchorPoint = Vector2.new(1, 0)
    keybindOverlay.Position = UDim2.new(1, -12, 0, 12)
    keybindOverlay.Size = UDim2.fromOffset(220, 72)
    keybindOverlay.BackgroundColor3 = theme.Background
    keybindOverlay.BorderColor3 = pink
    keybindOverlay.BorderSizePixel = 1
    keybindOverlay.Visible = false
    keybindOverlay.Parent = Library.ScreenGui

    local keybindHeader = Instance.new("Frame")
    keybindHeader.Active = true
    keybindHeader.Size = UDim2.new(1, 0, 0, 25)
    keybindHeader.BackgroundColor3 = theme.Header
    keybindHeader.BorderSizePixel = 0
    keybindHeader.Parent = keybindOverlay

    local fpsLabel = Instance.new("TextLabel")
    fpsLabel.Position = UDim2.fromOffset(8, 0)
    fpsLabel.Size = UDim2.new(0.5, -8, 1, 0)
    fpsLabel.BackgroundTransparency = 1
    fpsLabel.Text = "FPS: --"
    fpsLabel.TextColor3 = theme.TextColor
    fpsLabel.TextSize = 13
    fpsLabel.Font = Enum.Font.Code
    fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
    fpsLabel.Parent = keybindHeader

    local pingLabel = fpsLabel:Clone()
    pingLabel.Position = UDim2.new(0.5, 0, 0, 0)
    pingLabel.Size = UDim2.new(0.5, -8, 1, 0)
    pingLabel.Text = "Ping: --"
    pingLabel.TextXAlignment = Enum.TextXAlignment.Right
    pingLabel.Parent = keybindHeader

    -- Dragging Logic
    local dragging, dragInput, dragStart, startPosition
    keybindHeader.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPosition = keybindOverlay.Position
        end
    end)

    keybindHeader.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            keybindOverlay.Position = UDim2.new(
                startPosition.X.Scale, startPosition.X.Offset + delta.X,
                startPosition.Y.Scale, startPosition.Y.Offset + delta.Y
            )
        end
    end)

    -- FPS/Ping loop
    local frameCount, frameTimer, statsTimer = 0, 0, 0
    RunService.RenderStepped:Connect(function(deltaTime)
        frameCount += 1
        frameTimer += deltaTime
        statsTimer += deltaTime

        if frameTimer >= 0.5 then
            fpsLabel.Text = string.format("FPS: %d", math.floor(frameCount / frameTimer + 0.5))
            frameCount, frameTimer = 0, 0
        end

        if statsTimer >= 1 then
            local ping = "--"
            pcall(function() ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValueString() end)
            pingLabel.Text = "Ping: " .. ping
            statsTimer = 0
        end
    end)

    return keybindOverlay
end

function Overlay.Rejoin()
    local player = Players.LocalPlayer
    if player then
        pcall(function()
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
        end)
    end
end

return Overlay