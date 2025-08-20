local UI_Library = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

function UI_Library:CreateWindow(name, accentColor)
    accentColor = accentColor or Color3.fromRGB(0, 120, 255)
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = name.."UI"
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 450, 0, 350)
    MainFrame.Position = UDim2.new(0.5, -225, 0.5, -175)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainFrame

    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 30)
    TopBar.Position = UDim2.new(0, 0, 0, 0)
    TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = name
    Title.TextColor3 = Color3.fromRGB(240, 240, 240)
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Font = Enum.Font.GothamSemibold
    Title.TextSize = 14
    Title.Parent = TopBar

    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 30, 1, 0)
    CloseButton.Position = UDim2.new(1, -30, 0, 0)
    CloseButton.BackgroundTransparency = 1
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(240, 240, 240)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.TextSize = 14
    CloseButton.Parent = TopBar

    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(1, -20, 0, 30)
    TabContainer.Position = UDim2.new(0, 10, 0, 35)
    TabContainer.BackgroundTransparency = 1
    TabContainer.Parent = MainFrame

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 5)
    UIListLayout.Parent = TabContainer

    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -20, 1, -75)
    ContentContainer.Position = UDim2.new(0, 10, 0, 70)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = MainFrame

    local Tabs = {}
    local currentTab = nil

    function Tabs:CreateTab(tabName)
        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabName.."Tab"
        TabButton.Size = UDim2.new(0, 80, 1, 0)
        TabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        TabButton.BorderSizePixel = 0
        TabButton.Text = tabName
        TabButton.TextColor3 = Color3.fromRGB(180, 180, 180)
        TabButton.Font = Enum.Font.Gotham
        TabButton.TextSize = 12
        TabButton.AutoButtonColor = false
        TabButton.Parent = TabContainer

        local TabUICorner = Instance.new("UICorner")
        TabUICorner.CornerRadius = UDim.new(0, 4)
        TabUICorner.Parent = TabButton

        local TabFrame = Instance.new("ScrollingFrame")
        TabFrame.Name = tabName.."Content"
        TabFrame.Size = UDim2.new(1, 0, 1, 0)
        TabFrame.Position = UDim2.new(0, 0, 0, 0)
        TabFrame.BackgroundTransparency = 1
        TabFrame.Visible = false
        TabFrame.BorderSizePixel = 0
        TabFrame.ScrollBarThickness = 4
        TabFrame.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 65)
        TabFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
        TabFrame.Parent = ContentContainer

        local TabContentLayout = Instance.new("UIListLayout")
        TabContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        TabContentLayout.Padding = UDim.new(0, 8)
        TabContentLayout.Parent = TabFrame

        TabButton.MouseButton1Click:Connect(function()
            if currentTab then
                currentTab.Visible = false
            end
            TabFrame.Visible = true
            currentTab = TabFrame
            
            for _, btn in ipairs(TabContainer:GetChildren()) do
                if btn:IsA("TextButton") then
                    TweenService:Create(btn, TweenInfo.new(0.2), {
                        BackgroundColor3 = Color3.fromRGB(40, 40, 45),
                        TextColor3 = Color3.fromRGB(180, 180, 180)
                    }):Play()
                end
            end
            
            TweenService:Create(TabButton, TweenInfo.new(0.2), {
                BackgroundColor3 = accentColor,
                TextColor3 = Color3.fromRGB(255, 255, 255)
            }):Play()
        end)

        if not currentTab then
            TabButton.MouseButton1Click:Wait()
        end

        local TabElements = {}

        function TabElements:CreateButton(text, callback)
            local Button = Instance.new("TextButton")
            Button.Name = text.."Button"
            Button.Size = UDim2.new(1, 0, 0, 30)
            Button.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
            Button.BorderSizePixel = 0
            Button.Text = text
            Button.TextColor3 = Color3.fromRGB(240, 240, 240)
            Button.Font = Enum.Font.Gotham
            Button.TextSize = 12
            Button.AutoButtonColor = false
            Button.Parent = TabFrame

            local ButtonUICorner = Instance.new("UICorner")
            ButtonUICorner.CornerRadius = UDim.new(0, 4)
            ButtonUICorner.Parent = Button

            local ButtonStroke = Instance.new("UIStroke")
            ButtonStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            ButtonStroke.Color = Color3.fromRGB(60, 60, 65)
            ButtonStroke.Thickness = 1
            ButtonStroke.Parent = Button

            Button.MouseEnter:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(55, 55, 60)
                }):Play()
            end)

            Button.MouseLeave:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(45, 45, 50)
                }):Play()
            end)

            Button.MouseButton1Click:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.1), {
                    BackgroundColor3 = accentColor
                }):Play()
                TweenService:Create(Button, TweenInfo.new(0.1), {
                    BackgroundColor3 = Color3.fromRGB(45, 45, 50)
                }):Play()
                if callback then
                    callback()
                end
            end)

            return Button
        end

        function TabElements:CreateToggle(text, default, callback)
            local ToggleContainer = Instance.new("Frame")
            ToggleContainer.Name = text.."Toggle"
            ToggleContainer.Size = UDim2.new(1, 0, 0, 20)
            ToggleContainer.BackgroundTransparency = 1
            ToggleContainer.Parent = TabFrame

            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Name = "Label"
            ToggleLabel.Size = UDim2.new(0, 0, 1, 0)
            ToggleLabel.Position = UDim2.new(0, 0, 0, 0)
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Text = text
            ToggleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
            ToggleLabel.Font = Enum.Font.Gotham
            ToggleLabel.TextSize = 12
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            ToggleLabel.Parent = ToggleContainer

            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Name = "Toggle"
            ToggleButton.Size = UDim2.new(0, 36, 0, 18)
            ToggleButton.Position = UDim2.new(1, -36, 0, 0)
            ToggleButton.BackgroundColor3 = default and accentColor or Color3.fromRGB(60, 60, 65)
            ToggleButton.BorderSizePixel = 0
            ToggleButton.AutoButtonColor = false
            ToggleButton.Parent = ToggleContainer

            local ToggleUICorner = Instance.new("UICorner")
            ToggleUICorner.CornerRadius = UDim.new(0, 9)
            ToggleUICorner.Parent = ToggleButton

            local ToggleIndicator = Instance.new("Frame")
            ToggleIndicator.Name = "Indicator"
            ToggleIndicator.Size = UDim2.new(0, 14, 0, 14)
            ToggleIndicator.Position = UDim2.new(0, default and 18 or 2, 0, 2)
            ToggleIndicator.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
            ToggleIndicator.BorderSizePixel = 0
            ToggleIndicator.Parent = ToggleButton

            local IndicatorUICorner = Instance.new("UICorner")
            IndicatorUICorner.CornerRadius = UDim.new(0, 7)
            IndicatorUICorner.Parent = ToggleIndicator

            local isToggled = default or false

            ToggleButton.MouseButton1Click:Connect(function()
                isToggled = not isToggled
                
                if isToggled then
                    TweenService:Create(ToggleButton, TweenInfo.new(0.2), {
                        BackgroundColor3 = accentColor
                    }):Play()
                    TweenService:Create(ToggleIndicator, TweenInfo.new(0.2), {
                        Position = UDim2.new(0, 18, 0, 2)
                    }):Play()
                else
                    TweenService:Create(ToggleButton, TweenInfo.new(0.2), {
                        BackgroundColor3 = Color3.fromRGB(60, 60, 65)
                    }):Play()
                    TweenService:Create(ToggleIndicator, TweenInfo.new(0.2), {
                        Position = UDim2.new(0, 2, 0, 2)
                    }):Play()
                end
                
                if callback then
                    callback(isToggled)
                end
            end)

            return ToggleButton
        end

        function TabElements:CreateSlider(text, min, max, default, callback)
            local SliderContainer = Instance.new("Frame")
            SliderContainer.Name = text.."Slider"
            SliderContainer.Size = UDim2.new(1, 0, 0, 50)
            SliderContainer.BackgroundTransparency = 1
            SliderContainer.Parent = TabFrame

            local SliderLabel = Instance.new("TextLabel")
            SliderLabel.Name = "Label"
            SliderLabel.Size = UDim2.new(1, 0, 0, 15)
            SliderLabel.Position = UDim2.new(0, 0, 0, 0)
            SliderLabel.BackgroundTransparency = 1
            SliderLabel.Text = text
            SliderLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
            SliderLabel.Font = Enum.Font.Gotham
            SliderLabel.TextSize = 12
            SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            SliderLabel.Parent = SliderContainer

            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Name = "Value"
            ValueLabel.Size = UDim2.new(0, 50, 0, 15)
            ValueLabel.Position = UDim2.new(1, -50, 0, 0)
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.Text = tostring(default)
            ValueLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            ValueLabel.Font = Enum.Font.Gotham
            ValueLabel.TextSize = 12
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValueLabel.Parent = SliderContainer

            local SliderTrack = Instance.new("Frame")
            SliderTrack.Name = "Track"
            SliderTrack.Size = UDim2.new(1, 0, 0, 4)
            SliderTrack.Position = UDim2.new(0, 0, 0, 25)
            SliderTrack.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
            SliderTrack.BorderSizePixel = 0
            SliderTrack.Parent = SliderContainer

            local TrackUICorner = Instance.new("UICorner")
            TrackUICorner.CornerRadius = UDim.new(0, 2)
            TrackUICorner.Parent = SliderTrack

            local SliderFill = Instance.new("Frame")
            SliderFill.Name = "Fill"
            SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            SliderFill.BackgroundColor3 = accentColor
            SliderFill.BorderSizePixel = 0
            SliderFill.Parent = SliderTrack

            local FillUICorner = Instance.new("UICorner")
            FillUICorner.CornerRadius = UDim.new(0, 2)
            FillUICorner.Parent = SliderFill

            local SliderButton = Instance.new("TextButton")
            SliderButton.Name = "SliderButton"
            SliderButton.Size = UDim2.new(0, 16, 0, 16)
            SliderButton.Position = UDim2.new((default - min) / (max - min), -8, 0, 20)
            SliderButton.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
            SliderButton.BorderSizePixel = 0
            SliderButton.Text = ""
            SliderButton.Parent = SliderContainer

            local ButtonUICorner = Instance.new("UICorner")
            ButtonUICorner.CornerRadius = UDim.new(0, 8)
            ButtonUICorner.Parent = SliderButton

            local dragging = false

            local function updateValue(value)
                value = math.clamp(value, min, max)
                ValueLabel.Text = tostring(math.floor(value))
                SliderFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
                SliderButton.Position = UDim2.new((value - min) / (max - min), -8, 0, 20)
                
                if callback then
                    callback(value)
                end
            end

            SliderButton.MouseButton1Down:Connect(function()
                dragging = true
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)

            game:GetService("UserInputService").InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local pos = SliderTrack.AbsolutePosition
                    local size = SliderTrack.AbsoluteSize
                    local relativeX = (input.Position.X - pos.X) / size.X
                    local value = min + (max - min) * math.clamp(relativeX, 0, 1)
                    updateValue(value)
                end
            end)

            return {
                Update = updateValue
            }
        end

        function TabElements:CreateLabel(text)
            local Label = Instance.new("TextLabel")
            Label.Name = text.."Label"
            Label.Size = UDim2.new(1, 0, 0, 15)
            Label.BackgroundTransparency = 1
            Label.Text = text
            Label.TextColor3 = Color3.fromRGB(200, 200, 200)
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 12
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = TabFrame

            return Label
        end

        return TabElements
    end

    local window = {
        ScreenGui = ScreenGui,
        MainFrame = MainFrame,
        CreateTab = Tabs.CreateTab
    }

    return window
end

return UI_Library
