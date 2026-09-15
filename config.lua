--[[ KUSU UI - Config File ]]--
local pink = Color3.fromRGB(255, 132, 193)

local Config = {}

Config.Theme = {
    SchemeColor = pink,
    Background = Color3.fromRGB(12, 12, 16),
    Header = Color3.fromRGB(20, 20, 27),
    TextColor = Color3.fromRGB(245, 245, 250),
    ElementColor = Color3.fromRGB(27, 27, 36)
}

Config.Visuals = {
    PlayerESP = false,
    ESPBoxes = false,
    ESPHealthBar = false,
    ESPNames = false,
    ESPDistance = false,
    ESPTracers = false,
    PlayerMaxDist = 2000,
    Colors = {
        Boxes = pink,
        HealthBar = Color3.fromRGB(80, 255, 120),
        Names = Color3.fromRGB(245, 245, 250),
        Distance = Color3.fromRGB(200, 200, 200),
        Tracers = pink,
    }
}

Config.Aimbot = {
    Enabled = false,
    Key = Enum.KeyCode.F2,
    AimHoldKey = Enum.UserInputType.MouseButton2,
    Bone = "Head",
    Smoothness = 1.0,
    FOV = 120,
    DrawFOV = false,
    FOVColor = pink,
    TargetNPCs = false,
    WallCheck = false,
    Prediction = false,
    BulletVelocity = 850,
}

Config.GunMods = {
    NoRecoil = false,
    NoDrop = false,
    NoDrag = false,
    InstantAim = false,
}

return Config