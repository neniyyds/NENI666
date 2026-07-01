local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NENI_UIHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- 主框架
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0,420,0,260)
Main.Position = UDim2.new(0.5,-210,0.5,-130)
Main.BackgroundColor3 = Color3.fromRGB(28,28,35)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

Instance.new("UICorner",Main).CornerRadius = UDim.new(0,12)

-- 標題列
local Top = Instance.new("Frame")
Top.Size = UDim2.new(1,0,0,40)
Top.BackgroundColor3 = Color3.fromRGB(35,35,45)
Top.BorderSizePixel = 0
Top.Parent = Main

Instance.new("UICorner",Top).CornerRadius = UDim.new(0,12)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,-90,1,0)
Title.Position = UDim2.new(0,15,0,0)
Title.BackgroundTransparency = 1
Title.Text = "NENI UI HUB"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Top

-- 最小化按鈕
local Min = Instance.new("TextButton")
Min.Size = UDim2.new(0,35,0,30)
Min.Position = UDim2.new(1,-45,0,5)
Min.Text = "-"
Min.Font = Enum.Font.GothamBold
Min.TextSize = 22
Min.TextColor3 = Color3.new(1,1,1)
Min.BackgroundColor3 = Color3.fromRGB(60,60,80)
Min.Parent = Top
Instance.new("UICorner",Min)

-- 內容
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1,-20,1,-55)
Content.Position = UDim2.new(0,10,0,45)
Content.BackgroundTransparency = 1
Content.Parent = Main

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0,8)
Layout.Parent = Content

local function CreateButton(name)
	local Btn = Instance.new("TextButton")
	Btn.Size = UDim2.new(1,0,0,42)
	Btn.Text = name
	Btn.Font = Enum.Font.GothamBold
	Btn.TextSize = 16
	Btn.TextColor3 = Color3.new(1,1,1)
	Btn.BackgroundColor3 = Color3.fromRGB(50,50,65)
	Btn.Parent = Content
	Instance.new("UICorner",Btn)

	Btn.MouseButton1Click:Connect(function()
		print(name.." Clicked")
	end)
end

CreateButton("功能一")
CreateButton("功能二")
CreateButton("功能三")
CreateButton("設定")
CreateButton("關於")

-- 懸浮按鈕
local Float = Instance.new("TextButton")
Float.Size = UDim2.new(0,55,0,55)
Float.Position = UDim2.new(0,20,0.5,-25)
Float.Text = "☰"
Float.TextSize = 28
Float.Visible = false
Float.BackgroundColor3 = Color3.fromRGB(40,40,55)
Float.TextColor3 = Color3.new(1,1,1)
Float.Parent = ScreenGui
Instance.new("UICorner",Float).CornerRadius = UDim.new(1,0)

Min.MouseButton1Click:Connect(function()
	Main.Visible = false
	Float.Visible = true
end)

Float.MouseButton1Click:Connect(function()
	Main.Visible = true
	Float.Visible = false
end)

-- 拖動
local dragging = false
local dragInput
local dragStart
local startPos

local function update(input)
	local delta = input.Position - dragStart
	Main.Position = UDim2.new(
		startPos.X.Scale,
		startPos.X.Offset + delta.X,
		startPos.Y.Scale,
		startPos.Y.Offset + delta.Y
	)
end

Top.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = Main.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

Top.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and input == dragInput then
		update(input)
	end
end)	Btn.Position = UDim2.new(0.05,0,0,y)
	Btn.BackgroundColor3 = Color3.fromRGB(45,45,55)
	Btn.Text = name
	Btn.Font = Enum.Font.Gotham
	Btn.TextColor3 = Color3.new(1,1,1)
	Btn.TextSize = 18

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0,8)
	Corner.Parent = Btn

	Btn.Parent = Sidebar
	return Btn
end

local HomeBtn = CreateButton("Home",70)
local FarmBtn = CreateButton("Auto Farm",120)
local TpBtn = CreateButton("Teleport",170)
local SetBtn = CreateButton("Settings",220)

-- 内容区域
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1,-170,1,-20)
Content.Position = UDim2.new(0,170,0,10)
Content.BackgroundColor3 = Color3.fromRGB(40,40,45)
Content.Parent = Main

local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0,10)
ContentCorner.Parent = Content

local Label = Instance.new("TextLabel")
Label.Size = UDim2.new(1,0,0,40)
Label.BackgroundTransparency = 1
Label.Text = "欢迎使用 NENI HUB"
Label.Font = Enum.Font.GothamBold
Label.TextSize = 24
Label.TextColor3 = Color3.new(1,1,1)
Label.Parent = Content

-- 示例开关
local Toggle = Instance.new("TextButton")
Toggle.Size = UDim2.new(0,180,0,45)
Toggle.Position = UDim2.new(0,20,0,70)
Toggle.BackgroundColor3 = Color3.fromRGB(0,170,255)
Toggle.Text = "Auto Farm : OFF"
Toggle.Font = Enum.Font.GothamBold
Toggle.TextColor3 = Color3.new(1,1,1)
Toggle.Parent = Content

local Enabled = false
Toggle.MouseButton1Click:Connect(function()
	Enabled = not Enabled
	Toggle.Text = "Auto Farm : "..(Enabled and "ON" or "OFF")
end)local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, -80, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Orion Lib"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = header

local minimizeButton = Instance.new("TextButton")
minimizeButton.Name = "MinimizeButton"
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Position = UDim2.new(1, -40, 0.5, -15)
minimizeButton.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
minimizeButton.BorderSizePixel = 0
minimizeButton.Text = "-"
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.TextSize = 18
minimizeButton.Parent = header

local UICorner3 = Instance.new("UICorner")
UICorner3.CornerRadius = UDim.new(0, 8)
UICorner3.Parent = minimizeButton

local content = Instance.new("Frame")
content.Name = "Content"
content.Size = UDim2.new(1, -20, 1, -60)
content.Position = UDim2.new(0, 10, 0, 50)
content.BackgroundTransparency = 1
content.Parent = mainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.Parent = content

local touchButton = Instance.new("TextButton")
touchButton.Name = "TouchButton"
touchButton.Size = UDim2.new(1, 0, 1, 0)
touchButton.BackgroundTransparency = 1
touchButton.Text = ""
touchButton.ZIndex = 0
touchButton.Parent = header

local minimized = false
local dragStart = nil
local startPos = nil

minimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        content.Visible = false
        mainFrame.Size = UDim2.new(0, 300, 0, 40)
        minimizeButton.Text = "+"
    else
        content.Visible = true
        mainFrame.Size = UDim2.new(0, 300, 0, 350)
        minimizeButton.Text = "-"
    end
end)

local function updateInput(input)
    if not dragStart then return end
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

touchButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

touchButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        updateInput(input)
    end
end)

touchButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragStart = nil
    end
end)

local OrionLib = {}

function OrionLib:AddButton(text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 40)
    button.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.Gotham
    button.TextSize = 14
    button.Parent = content
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = button
    
    button.MouseButton1Click:Connect(callback)
    
    return button
end

function OrionLib:AddLabel(text)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = content
    
    return label
end

function OrionLib:AddSlider(text, min, max, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, 0, 0, 60)
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.Parent = content
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = sliderFrame
    
    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, 0, 0, 5)
    track.Position = UDim2.new(0, 0, 0, 30)
    track.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
    track.BorderSizePixel = 0
    track.Parent = sliderFrame
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(1, 0)
    UICorner.Parent = track
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(0.5, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    fill.BorderSizePixel = 0
    fill.Parent = track
    
    local UICorner4 = Instance.new("UICorner")
    UICorner4.CornerRadius = UDim.new(1, 0)
    UICorner4.Parent = fill
    
    local valueText = Instance.new("TextLabel")
    valueText.Size = UDim2.new(1, 0, 0, 20)
    valueText.Position = UDim2.new(0, 0, 0, 40)
    valueText.BackgroundTransparency = 1
    valueText.Text = tostring(math.floor((min + max) / 2))
    valueText.TextColor3 = Color3.fromRGB(255, 255, 255)
    valueText.Font = Enum.Font.Gotham
    valueText.TextSize = 14
    valueText.TextXAlignment = Enum.TextXAlignment.Right
    valueText.Parent = sliderFrame
    
    local handle = Instance.new("TextButton")
    handle.Size = UDim2.new(0, 20, 0, 20)
    handle.Position = UDim2.new(0.5, -10, 0, 25)
    handle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    handle.BorderSizePixel = 0
    handle.Text = ""
    handle.Parent = sliderFrame
    
    local UICorner5 = Instance.new("UICorner")
    UICorner5.CornerRadius = UDim.new(1, 0)
    UICorner5.Parent = handle
    
    local isSliding = false
    
    local function updateSlider(input)
        if not isSliding then return end
        
        local relativeX = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        local value = min + (max - min) * relativeX
        
        fill.Size = UDim2.new(relativeX, 0, 1, 0)
        handle.Position = UDim2.new(relativeX, -10, 0, 25)
        valueText.Text = tostring(math.floor(value))
        
        callback(value)
    end
    
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            isSliding = true
        end
    end)
    
    handle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            isSliding = false
        end
    end)
    
    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            isSliding = true
            updateSlider(input)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider(input)
        end
    end)
    
    return sliderFrame
end

function OrionLib:AddToggle(text, default, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, 0, 0, 30)
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.Parent = content
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = toggleFrame
    
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 50, 0, 25)
    toggle.Position = UDim2.new(1, -50, 0, 0)
    toggle.BackgroundColor3 = default and Color3.fromRGB(0, 120, 215) or Color3.fromRGB(65, 65, 65)
    toggle.BorderSizePixel = 0
    toggle.Text = ""
    toggle.Parent = toggleFrame
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(1, 0)
    UICorner.Parent = toggle
    
    local toggleCircle = Instance.new("Frame")
    toggleCircle.Size = UDim2.new(0, 21, 0, 21)
    toggleCircle.Position = default and UDim2.new(1, -23, 0.5, -10.5) or UDim2.new(0, 2, 0.5, -10.5)
    toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    toggleCircle.BorderSizePixel = 0
    toggleCircle.Parent = toggle
    
    local UICorner2 = Instance.new("UICorner")
    UICorner2.CornerRadius = UDim.new(1, 0)
    UICorner2.Parent = toggleCircle
    
    local toggled = default
    
    toggle.MouseButton1Click:Connect(function()
        toggled = not toggled
        
        if toggled then
            toggle.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
            toggleCircle.Position = UDim2.new(1, -23, 0.5, -10.5)
        else
            toggle.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
            toggleCircle.Position = UDim2.new(0, 2, 0.5, -10.5)
        end
        
        callback(toggled)
    end)
    
    return toggleFrame
end

function OrionLib:Destroy()
    ScreenGui:Destroy()
end

return OrionLib
