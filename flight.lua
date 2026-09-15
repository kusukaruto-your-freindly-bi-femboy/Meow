--[[ KUSU UI - Flight Module ]]--
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Flight = {
    Active = false,
    Speed = 70
}

local player = Players.LocalPlayer
local inputState = {}
local flightHeartbeatConnection
local flightBeganConnection
local flightEndedConnection
local savedAutoRotate

local function getFlightRoot()
    local character = player.Character
    return character and character:FindFirstChild("HumanoidRootPart")
end

local function getFlightHumanoid()
    local character = player.Character
    return character and character:FindFirstChildOfClass("Humanoid")
end

local function stopFlightConnections()
    if flightHeartbeatConnection then flightHeartbeatConnection:Disconnect(); flightHeartbeatConnection = nil end
    if flightBeganConnection then flightBeganConnection:Disconnect(); flightBeganConnection = nil end
    if flightEndedConnection then flightEndedConnection:Disconnect(); flightEndedConnection = nil end
end

local function setFlightInput(input, isDown)
    local key = input.KeyCode
    if key == Enum.KeyCode.W or key == Enum.KeyCode.A or key == Enum.KeyCode.S
        or key == Enum.KeyCode.D or key == Enum.KeyCode.Space or key == Enum.KeyCode.LeftControl then
        inputState[key] = isDown
    end
end

local function getFlightDirection()
    local camera = workspace.CurrentCamera
    if not camera then return Vector3.zero end

    local direction = Vector3.zero
    if inputState[Enum.KeyCode.W] then direction += camera.CFrame.LookVector end
    if inputState[Enum.KeyCode.S] then direction -= camera.CFrame.LookVector end
    if inputState[Enum.KeyCode.D] then direction += camera.CFrame.RightVector end
    if inputState[Enum.KeyCode.A] then direction -= camera.CFrame.RightVector end
    if inputState[Enum.KeyCode.Space] then direction += Vector3.yAxis end
    if inputState[Enum.KeyCode.LeftControl] then direction -= Vector3.yAxis end

    return direction.Magnitude > 0 and direction.Unit or Vector3.zero
end

function Flight:SetSpeed(speed)
    self.Speed = math.clamp(tonumber(speed) or self.Speed, 10, 250)
end

function Flight:Stop()
    self.Active = false
    stopFlightConnections()
    table.clear(inputState)

    local humanoid = getFlightHumanoid()
    if humanoid and savedAutoRotate ~= nil then
        humanoid.AutoRotate = savedAutoRotate
    end
    savedAutoRotate = nil

    local root = getFlightRoot()
    if root then
        root.AssemblyLinearVelocity = Vector3.zero
    end
end

function Flight:Start()
    if self.Active then return end

    local humanoid = getFlightHumanoid()
    if not getFlightRoot() or not humanoid then return end

    self.Active = true
    savedAutoRotate = humanoid.AutoRotate
    humanoid.AutoRotate = false

    flightBeganConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed then setFlightInput(input, true) end
    end)

    flightEndedConnection = UserInputService.InputEnded:Connect(function(input)
        setFlightInput(input, false)
    end)

    flightHeartbeatConnection = RunService.Heartbeat:Connect(function()
        local rootPart = getFlightRoot()
        local currentHumanoid = getFlightHumanoid()
        if not rootPart or not currentHumanoid or currentHumanoid.Health <= 0 then
            self:Stop()
            return
        end

        rootPart.AssemblyLinearVelocity = getFlightDirection() * self.Speed
    end)
end

function Flight:Toggle(state)
    if state == nil then state = not self.Active end
    if state then self:Start() else self:Stop() end
end

return Flight