--[[ KUSU UI - Gun Mods Module ]]--
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local GunMods = {}
local cachedAmmoAttributes = {}

function GunMods.Apply(GunModsConfig)
    local ammoTypes = ReplicatedStorage:FindFirstChild("AmmoTypes")
    if not ammoTypes then return end

    for _, ammo in ipairs(ammoTypes:GetChildren()) do
        if not cachedAmmoAttributes[ammo] then
            cachedAmmoAttributes[ammo] = {
                Recoil = ammo:GetAttribute("RecoilStrength"),
                Drop = ammo:GetAttribute("ProjectileDrop"),
                Drag = ammo:GetAttribute("Drag")
            }
        end

        local original = cachedAmmoAttributes[ammo]

        if GunModsConfig.NoRecoil then
            ammo:SetAttribute("RecoilStrength", 0)
        elseif original.Recoil ~= nil then
            ammo:SetAttribute("RecoilStrength", original.Recoil)
        end

        if GunModsConfig.NoDrop then
            ammo:SetAttribute("ProjectileDrop", 0)
        elseif original.Drop ~= nil then
            ammo:SetAttribute("ProjectileDrop", original.Drop)
        end

        if GunModsConfig.NoDrag then
            ammo:SetAttribute("Drag", 0)
        elseif original.Drag ~= nil then
            ammo:SetAttribute("Drag", original.Drag)
        end
    end
end

function GunMods.Restore()
    for ammo, original in pairs(cachedAmmoAttributes) do
        if ammo and ammo.Parent then
            if original.Recoil ~= nil then ammo:SetAttribute("RecoilStrength", original.Recoil) end
            if original.Drop ~= nil then ammo:SetAttribute("ProjectileDrop", original.Drop) end
            if original.Drag ~= nil then ammo:SetAttribute("Drag", original.Drag) end
        end
    end
end

return GunMods