--[[ KUSU UI - Aimbot Module ]]--
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

local AimbotModule = {}
local aimbotActive = false
local aimbotTargetModel = nil
local aimbotTargetPart = nil
local aimbotFovCircle

local function getAimPart(model, boneName)
    if not model then return nil end
    local part = model:FindFirstChild(boneName)
        or model:FindFirstChild("Head")
        or model:FindFirstChild("HumanoidRootPart")
        or model.PrimaryPart
        or model:FindFirstChildWhichIsA("BasePart")
    return part and part:IsA("BasePart") and part or nil
end

local function isVisible(part)
    local camera = workspace.CurrentCamera
    if not camera or not part then return false end

    local origin = camera.CFrame.Position
    local direction = part.Position - origin
    if direction.Magnitude < 0.5 then return true end

    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {player.Character, camera}
    params.IgnoreWater = true

    local hit = workspace:Raycast(origin, direction, params)
    if not hit then return true end
    return hit.Instance == part or hit.Instance:IsDescendantOf(part.Parent)
        or hit.Instance.Transparency >= 0.85 or not hit.Instance.CanCollide
end

function AimbotModule.Init(AimbotConfig)
    if Drawing then
        aimbotFovCircle = Drawing.new("Circle")
        aimbotFovCircle.Thickness = 1
        aimbotFovCircle.NumSides = 48
        aimbotFovCircle.Filled = false
        aimbotFovCircle.Transparency = 0.8
        aimbotFovCircle.Color = AimbotConfig.FOVColor
        aimbotFovCircle.Visible = false
    end

    UserInputService.InputBegan:Connect(function(input)
        if UserInputService:GetFocusedTextBox() then return end
        if input.UserInputType == AimbotConfig.AimHoldKey or input.KeyCode == AimbotConfig.AimHoldKey then
            aimbotActive = true
            aimbotTargetModel = nil
            aimbotTargetPart = nil
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == AimbotConfig.AimHoldKey or input.KeyCode == AimbotConfig.AimHoldKey then
            aimbotActive = false
            aimbotTargetModel = nil
            aimbotTargetPart = nil
        end
    end)
end

function AimbotModule.UpdateFOV(AimbotConfig)
    if not aimbotFovCircle then return end
    if AimbotConfig.DrawFOV and AimbotConfig.Enabled then
        local mousePos = UserInputService:GetMouseLocation()
        aimbotFovCircle.Visible = true
        aimbotFovCircle.Radius = AimbotConfig.FOV
        aimbotFovCircle.Position = mousePos
        aimbotFovCircle.Color = AimbotConfig.FOVColor
    else
        aimbotFovCircle.Visible = false
    end
end

return AimbotModule