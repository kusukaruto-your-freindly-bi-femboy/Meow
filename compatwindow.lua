--[[ KUSU UI - Compatibility Window Wrapper Module ]]--
local CompatWindow = {}

function CompatWindow.Make(LinoriaWindow, ToggleControls, SliderControls, DropdownControls, KeybindControls, KeybindStates, ColorPickerControls)
    local window = {}

    function window:NewTab(name)
        local tab = LinoriaWindow:AddTab(name)
        local compatTab = {}

        function compatTab:NewSection(sectionName, side)
            local groupbox
            if side == "Right" and tab.AddRightGroupbox then
                groupbox = tab:AddRightGroupbox(sectionName)
            else
                groupbox = tab:AddLeftGroupbox(sectionName)
            end
            local section = {}

            function section:NewLabel(text)
                groupbox:AddLabel(text)
            end

            function section:NewButton(name, description, callback)
                groupbox:AddButton({
                    Text = name,
                    Tooltip = description,
                    Func = callback
                })
            end

            function section:NewToggle(name, description, callback)
                local toggle = groupbox:AddToggle(name, {
                    Text = name,
                    Tooltip = description,
                    Default = false,
                    Callback = callback
                })
                ToggleControls[name] = toggle
                return toggle
            end

            function section:NewSlider(name, description, maximum, minimum, callback, defaultValue)
                local minValue = tonumber(minimum) or 0
                local maxValue = tonumber(maximum) or minValue
                local slider = groupbox:AddSlider(name, {
                    Text = name,
                    Tooltip = description,
                    Default = math.clamp(tonumber(defaultValue) or minValue, minValue, maxValue),
                    Min = minValue,
                    Max = maxValue,
                    Rounding = (minValue % 1 ~= 0 or maxValue % 1 ~= 0) and 1 or 0,
                    Callback = callback
                })
                SliderControls[name] = slider
                return slider
            end

            function section:NewTextBox(name, description, callback)
                groupbox:AddInput(name, {
                    Text = name,
                    Tooltip = description,
                    Default = "",
                    Callback = callback
                })
            end

            function section:NewDropdown(name, description, options, callback)
                local dropdown = groupbox:AddDropdown(name, {
                    Text = name,
                    Tooltip = description,
                    Values = options,
                    Default = options[1],
                    Callback = callback
                })
                DropdownControls[name] = dropdown
                return dropdown
            end

            function section:NewKeybind(name, description, key, callback, mode, defaultState, syncToggleState)
                local toggle = groupbox:AddToggle(name .. "_Toggle", {
                    Text = name,
                    Tooltip = description,
                    Default = defaultState == true,
                    Callback = function(state)
                        if syncToggleState then
                            callback(state)
                        end
                    end
                })

                local defaultKey = key
                if typeof(defaultKey) == "EnumItem" then
                    defaultKey = defaultKey.Name
                end
                local defaultMode = mode or "Toggle"
                ToggleControls[name] = toggle

                local keyPicker = toggle:AddKeyPicker(name, {
                    Text = name,
                    Tooltip = description,
                    Default = tostring(defaultKey),
                    Mode = defaultMode,
                    NoUI = false,
                    SyncToggleState = syncToggleState == true,
                    Callback = callback,
                    ChangedCallback = function(newKey)
                        local currentKey = newKey
                        if typeof(currentKey) == "EnumItem" then
                            currentKey = currentKey.Name
                        elseif currentKey ~= nil then
                            currentKey = tostring(currentKey)
                        end
                        KeybindStates[name] = {
                            Key = currentKey or tostring(defaultKey),
                            Mode = tostring(keyPicker.Mode or defaultMode),
                        }
                    end,
                })

                KeybindControls[name] = keyPicker
                return keyPicker
            end

            function section:NewColorPicker(name, description, default, callback)
                local picker = groupbox:AddLabel(name):AddColorPicker(name, {
                    Default = default,
                    Title = name,
                    Callback = callback
                })
                ColorPickerControls[name] = picker
                return picker
            end

            return section
        end

        return compatTab
    end

    return window
end

return CompatWindow