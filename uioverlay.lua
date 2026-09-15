--[[ KUSU UI - UI Overlay & Menu Builder ]]--
local UIOverlay = {}

function UIOverlay.Create(Window, Config, AimbotModule, ESPModule, GunMods, Flight, Players)
    -- 1. Aimbot Tab
    local aimbotTab = Window:NewTab("Aimbot")
    local aimbotSection = aimbotTab:NewSection("Aimbot Settings", "Left")
    
    aimbotSection:NewToggle("Enable Aimbot", "Toggles the aimbot subsystem on/off", function(state)
        Config.Aimbot.Enabled = state
    end)

    aimbotSection:NewToggle("Draw FOV Circle", "Displays the field of view circle", function(state)
        Config.Aimbot.DrawFOV = state
    end)

    aimbotSection:NewSlider("FOV Radius", "Sets the maximum targeting field of view", 300, 10, function(value)
        Config.Aimbot.FOV = value
    end, Config.Aimbot.FOV)

    -- 2. ESP Tab
    local espTab = Window:NewTab("ESP")
    local espSection = espTab:NewSection("Visuals", "Left")

    espSection:NewToggle("Enable ESP", "Toggles player box and info displays", function(state)
        Config.ESP.Enabled = state
    end)

    espSection:NewToggle("Name ESP", "Displays player usernames above heads", function(state)
        Config.ESP.Names = state
    end)

    espSection:NewToggle("Box ESP", "Draws bounding boxes around players", function(state)
        Config.ESP.Boxes = state
    end)

    -- 3. Gun Mods Tab
    local gunTab = Window:NewTab("Gun Mods")
    local gunSection = gunTab:NewSection("Weapon Modifications", "Left")

    gunSection:NewToggle("No Recoil", "Removes weapon recoil completely", function(state)
        Config.GunMods.NoRecoil = state
        GunMods.Apply(Config.GunMods)
    end)

    gunSection:NewToggle("Infinite Ammo", "Prevents weapon magazine from depleting", function(state)
        Config.GunMods.InfiniteAmmo = state
        GunMods.Apply(Config.GunMods)
    end)

    -- 4. Movement Tab (Flight)
    local moveTab = Window:NewTab("Movement")
    local moveSection = moveTab:NewSection("Flight Controls", "Left")

    moveSection:NewToggle("Enable Flight", "Toggles custom flight mode", function(state)
        if state then
            Flight:Start(Config.Flight)
        else
            Flight:Stop()
        end
    end)

    moveSection:NewSlider("Flight Speed", "Adjusts your movement speed while flying", 200, 16, function(value)
        Config.Flight.Speed = value
    end, Config.Flight.Speed)

    print("[KUSU] UI overlay tabs and controls constructed successfully!")
end

return UIOverlay