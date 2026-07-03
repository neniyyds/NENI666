-- ============================================================
--  Liquid Glass UI v1.0
--  适用于 Roblox 手机端
--  特性：液态玻璃效果 | 可拖动窗口 | 左侧 Tab | 示例开关
--  设计灵感：iOS 液态玻璃设计语言
-- ============================================================

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- 检查是否在手机端
local isMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled

-- 创建主 ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LiquidGlassUI"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- ============================================================
--  辅助函数
-- ============================================================

-- 创建 UI 元素的辅助函数
local function createUIElement(className, properties, parent)
	local element = Instance.new(className)
	for prop, value in pairs(properties) do
		element[prop] = value
	end
	if parent then
		element.Parent = parent
	end
	return element
end

-- 创建带圆角的 Frame
local function createRoundedFrame(properties, parent)
	local frame = Instance.new("Frame")
	for prop, value in pairs(properties) do
		frame[prop] = value
	end
	local corner = Instance.new("UICorner)
	corner.CornerRadius = properties.CornerRadius or UDim.new(0, 20)
	corner.Parent = frame
	if parent then
		frame.Parent = parent
	end
	return frame
end

-- 创建带描边的 Frame
local function createStrokedFrame(properties, parent)
	local frame = Instance.new("Frame")
	for prop, value in pairs(properties) do
		frame[prop] = value
	end
	local corner = Instance.new("UICorner")
	corner.CornerRadius = properties.CornerRadius or UDim.new(0, 20)
	corner.Parent = frame
	local stroke = Instance.new("UIStroke")
	stroke.Color = properties.StrokeColor or Color3.fromRGB(255, 255, 255)
	stroke.Transparency = properties.StrokeTransparency or 0.5
	stroke.Thickness = properties.StrokeThickness or 1.5
	stroke.Parent = frame
	if parent then
		frame.Parent = parent
	end
	return frame
end

-- 创建 Toggle 开关
local function createToggle(parent, initialValue, labelText, onChange)
	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, 0, 0, 44)
	container.BackgroundTransparency = 1
	container.Parent = parent
	
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0.7, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = labelText or "开关"
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.TextSize = 16
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Font = Enum.Font.GothamMedium
	label.Parent = container
	
	local toggleBg = Instance.new("Frame")
	toggleBg.Size = UDim2.new(0, 52, 0, 30)
	toggleBg.Position = UDim2.new(1, -60, 0.5, -15)
	toggleBg.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
	toggleBg.BackgroundTransparency = 0.4
	toggleBg.Parent = container
	local toggleCorner = Instance.new("UICorner")
	toggleCorner.CornerRadius = UDim.new(1, 0)
	toggleCorner.Parent = toggleBg
	
	local toggleHandle = Instance.new("Frame")
	toggleHandle.Size = UDim2.new(0, 24, 0, 24)
	toggleHandle.Position = UDim2.new(0, 3, 0.5, -12)
	toggleHandle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	toggleHandle.BackgroundTransparency = 0
	toggleHandle.Parent = toggleBg
	local handleCorner = Instance.new("UICorner")
	handleCorner.CornerRadius = UDim.new(1, 0)
	handleCorner.Parent = toggleHandle
	
	-- 添加阴影到滑块
	local shadow = Instance.new("Frame")
	shadow.Size = UDim2.new(1, 0, 1, 0)
	shadow.Position = UDim2.new(0, 0, 0, 2)
	shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	shadow.BackgroundTransparency = 0.3
	shadow.ZIndex = -1
	shadow.Parent = toggleHandle
	local shadowCorner = Instance.new("UICorner")
	shadowCorner.CornerRadius = UDim.new(1, 0)
	shadowCorner.Parent = shadow
	
	local isOn = initialValue or false
	local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	
	local function updateToggle(newValue)
		isOn = newValue
		local targetPos, bgColor
		if isOn then
			targetPos = UDim2.new(1, -27, 0.5, -12)
			bgColor = Color3.fromRGB(80, 160, 255)
		else
			targetPos = UDim2.new(0, 3, 0.5, -12)
			bgColor = Color3.fromRGB(60, 60, 70)
		end
		local handleTween = TweenService:Create(toggleHandle, tweenInfo, {Position = targetPos})
		handleTween:Play()
		local bgTween = TweenService:Create(toggleBg, tweenInfo, {BackgroundColor3 = bgColor})
		bgTween:Play()
		if onChange then
			onChange(isOn)
		end
	end
	
	toggleBg.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
			updateToggle(not isOn)
		end
	end)
	
	-- 初始状态
	if isOn then
		toggleHandle.Position = UDim2.new(1, -27, 0.5, -12)
		toggleBg.BackgroundColor3 = Color3.fromRGB(80, 160, 255)
	else
		toggleHandle.Position = UDim2.new(0, 3, 0.5, -12)
		toggleBg.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
	end
	
	return {
		setValue = updateToggle,
		getValue = function() return isOn end,
		container = container
	}
end

-- ============================================================
--  创建主窗口 - 液态玻璃效果
-- ============================================================

-- 窗口尺寸 (手机端适配)
local windowWidth = math.min(420, ScreenGui.AbsoluteSize.X * 0.88)
local windowHeight = math.min(580, ScreenGui.AbsoluteSize.Y * 0.78)

-- 主窗口背景遮罩 (点击外部可关闭)
local backdrop = Instance.new("Frame)
backdrop.Size = UDim2.new(1, 0, 1, 0)
backdrop.BackgroundTransparency = 0.4
backdrop.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
backdrop.Visible = true
backdrop.Parent = ScreenGui

-- 主窗口 - 液态玻璃容器
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, windowWidth, 0, windowHeight)
mainFrame.Position = UDim2.new(0.5, -windowWidth/2, 0.5, -windowHeight/2)
mainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
mainFrame.BackgroundTransparency = 0.15
mainFrame.ClipsDescendants = true
mainFrame.Parent = ScreenGui

-- 玻璃效果 - 主圆角
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 28)
mainCorner.Parent = mainFrame

-- 玻璃效果 - 边框 (液态玻璃的"边缘光")
local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(255, 255, 255)
mainStroke.Transparency = 0.35
mainStroke.Thickness = 1.8
mainStroke.Parent = mainFrame

-- 玻璃效果 - 光泽渐变 (从左上到右下)
local glassGradient = Instance.new("UIGradient")
glassGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
	ColorSequenceKeypoint.new(0.3, Color3.fromRGB(255, 255, 255, 0.6)),
	ColorSequenceKeypoint.new(0.7, Color3.fromRGB(255, 255, 255, 0.15)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255, 0.0))
})
glassGradient.Rotation = 45
glassGradient.Parent = mainFrame

-- 玻璃效果 - 内部背景 (微妙的颜色)
local innerBg = Instance.new("Frame")
innerBg.Size = UDim2.new(1, 0, 1, 0)
innerBg.BackgroundColor3 = Color3.fromRGB(40, 50, 80)
innerBg.BackgroundTransparency = 0.25
innerBg.Parent = mainFrame
local innerCorner = Instance.new("UICorner")
innerCorner.CornerRadius = UDim.new(0, 28)
innerCorner.Parent = innerBg

-- 玻璃效果 - 顶部高光条 (液态玻璃的"流光")
local highlightBar = Instance.new("Frame")
highlightBar.Size = UDim2.new(0.7, 0, 0, 2)
highlightBar.Position = UDim2.new(0.15, 0, 0.08, 0)
highlightBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
highlightBar.BackgroundTransparency = 0.5
highlightBar.Parent = mainFrame
local highlightCorner = Instance.new("UICorner")
highlightCorner.CornerRadius = UDim.new(1, 0)
highlightCorner.Parent = highlightBar

-- 玻璃效果 - 底部光晕
local glowBar = Instance.new("Frame")
glowBar.Size = UDim2.new(0.5, 0, 0, 1)
glowBar.Position = UDim2.new(0.25, 0, 0.92, 0)
glowBar.BackgroundColor3 = Color3.fromRGB(120, 180, 255)
glowBar.BackgroundTransparency = 0.6
glowBar.Parent = mainFrame
local glowCorner = Instance.new("UICorner")
glowCorner.CornerRadius = UDim.new(1, 0)
glowCorner.Parent = glowBar

-- 窗口阴影
local shadowFrame = Instance.new("Frame")
shadowFrame.Size = UDim2.new(1, 0, 1, 0)
shadowFrame.Position = UDim2.new(0, 0, 0, 8)
shadowFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadowFrame.BackgroundTransparency = 0.45
shadowFrame.ZIndex = -1
shadowFrame.Parent = mainFrame
local shadowCorner = Instance.new("UICorner")
shadowCorner.CornerRadius = UDim.new(0, 28)
shadowCorner.Parent = shadowFrame

-- ============================================================
--  关闭按钮
-- ============================================================

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 36, 0, 36)
closeBtn.Position = UDim2.new(1, -48, 0, 12)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.BackgroundTransparency = 0.2
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 18
closeBtn.TextScaled = false
closeBtn.Font = Enum.Font.GothamMedium
closeBtn.Parent = mainFrame
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1, 0)
closeCorner.Parent = closeBtn

closeBtn.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
		-- 关闭动画
		local closeTween = TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
			Size = UDim2.new(0, 0, 0, 0),
			Position = UDim2.new(0.5, 0, 0.5, 0)
		})
		closeTween:Play()
		closeTween.Completed:Connect(function()
			ScreenGui.Enabled = false
		end)
	end
end)

-- ============================================================
--  左侧 Tab 栏
-- ============================================================

local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(0, 72, 1, -20)
tabBar.Position = UDim2.new(0, 10, 0, 10)
tabBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
tabBar.BackgroundTransparency = 0.12
tabBar.Parent = mainFrame
local tabCorner = Instance.new("UICorner")
tabCorner.CornerRadius = UDim.new(0, 16)
tabCorner.Parent = tabBar

-- Tab 数据
local tabs = {
	{id = "home", icon = "🏠", label = "主页"},
	{id = "settings", icon = "⚙️", label = "设置"},
	{id = "about", icon = "ℹ️", label = "关于"}
}

local tabButtons = {}
local currentTab = "home"

-- 创建 Tab 按钮
local tabHeight = 56
local tabSpacing = 4
local startY = 8

for i, tabData in ipairs(tabs) do
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -12, 0, tabHeight)
	btn.Position = UDim2.new(0, 6, 0, startY + (i-1) * (tabHeight + tabSpacing))
	btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	btn.BackgroundTransparency = 0.85
	btn.Text = ""
	btn.Parent = tabBar
	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 12)
	btnCorner.Parent = btn
	
	-- 图标
	local icon = Instance.new("TextLabel")
	icon.Size = UDim2.new(1, 0, 0, 28)
	icon.Position = UDim2.new(0, 0, 0, 2)
	icon.BackgroundTransparency = 1
	icon.Text = tabData.icon
	icon.TextSize = 22
	icon.TextColor3 = Color3.fromRGB(255, 255, 255)
	icon.TextScaled = false
	icon.Font = Enum.Font.GothamMedium
	icon.Parent = btn
	
	-- 标签
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 0, 16)
	label.Position = UDim2.new(0, 0, 0, 34)
	label.BackgroundTransparency = 1
	label.Text = tabData.label
	label.TextSize = 10
	label.TextColor3 = Color3.fromRGB(200, 200, 210)
	label.TextScaled = false
	label.Font = Enum.Font.GothamMedium
	label.Parent = btn
	
	-- 选中指示器
	local indicator = Instance.new("Frame")
	indicator.Size = UDim2.new(0, 3, 0, 28)
	indicator.Position = UDim2.new(0, 0, 0.5, -14)
	indicator.BackgroundColor3 = Color3.fromRGB(100, 180, 255)
	indicator.BackgroundTransparency = 1
	indicator.Parent = btn
	local indCorner = Instance.new("UICorner")
	indCorner.CornerRadius = UDim.new(1, 0)
	indCorner.Parent = indicator
	
	tabButtons[tabData.id] = {
		button = btn,
		icon = icon,
		label = label,
		indicator = indicator,
		data = tabData
	}
	
	btn.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
			switchTab(tabData.id)
		end
	end)
end

-- ============================================================
--  内容区域
-- ============================================================

local contentArea = Instance.new("Frame")
contentArea.Size = UDim2.new(1, -96, 1, -24)
contentArea.Position = UDim2.new(0, 88, 0, 12)
contentArea.BackgroundTransparency = 1
contentArea.Parent = mainFrame

-- 内容容器 (用于切换)
local contentContainer = Instance.new("Frame")
contentContainer.Size = UDim2.new(1, 0, 1, 0)
contentContainer.BackgroundTransparency = 1
contentContainer.Parent = contentArea
local containerCorner = Instance.new("UICorner")
containerCorner.CornerRadius = UDim.new(0, 12)
containerCorner.Parent = contentContainer

-- ============================================================
--  页面内容
-- ============================================================

local pages = {}

-- ---- 主页内容 ----
local homePage = Instance.new("Frame")
homePage.Size = UDim2.new(1, 0, 1, 0)
homePage.BackgroundTransparency = 1
homePage.Parent = contentContainer
homePage.Visible = true

-- 标题
local homeTitle = Instance.new("TextLabel")
homeTitle.Size = UDim2.new(1, 0, 0, 40)
homeTitle.Position = UDim2.new(0, 0, 0, 0)
homeTitle.BackgroundTransparency = 1
homeTitle.Text = "控制中心"
homeTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
homeTitle.TextSize = 24
homeTitle.TextXAlignment = Enum.TextXAlignment.Left
homeTitle.Font = Enum.Font.GothamBold
homeTitle.Parent = homePage

-- 副标题
local homeSubtitle = Instance.new("TextLabel")
homeSubtitle.Size = UDim2.new(1, 0, 0, 20)
homeSubtitle.Position = UDim2.new(0, 0, 0, 40)
homeSubtitle.BackgroundTransparency = 1
homeSubtitle.Text = "快速控制"
homeSubtitle.TextColor3 = Color3.fromRGB(180, 190, 210)
homeSubtitle.TextSize = 13
homeSubtitle.TextXAlignment = Enum.TextXAlignment.Left
homeSubtitle.Font = Enum.Font.GothamMedium
homeSubtitle.Parent = homePage

-- 分隔线
local divider = Instance.new("Frame")
divider.Size = UDim2.new(1, 0, 0, 1)
divider.Position = UDim2.new(0, 0, 0, 66)
divider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
divider.BackgroundTransparency = 0.15
divider.Parent = homePage

-- 开关列表容器
local toggleContainer1 = Instance.new("Frame")
toggleContainer1.Size = UDim2.new(1, 0, 0, 160)
toggleContainer1.Position = UDim2.new(0, 0, 0, 76)
toggleContainer1.BackgroundTransparency = 1
toggleContainer1.Parent = homePage

-- 创建三个示例开关
local toggle1 = createToggle(toggleContainer1, false, "🔊 声音", function(val)
	print("声音开关:", val)
end)

local toggle2 = createToggle(toggleContainer1, true, "📶 Wi-Fi", function(val)
	print("Wi-Fi 开关:", val)
end)

local toggle3 = createToggle(toggleContainer1, false, "🔦 手电筒", function(val)
	print("手电筒开关:", val)
end)

-- 调整开关位置
toggle1.container.Position = UDim2.new(0, 0, 0, 0)
toggle2.container.Position = UDim2.new(0, 0, 0, 48)
toggle3.container.Position = UDim2.new(0, 0, 0, 96)

pages.home = homePage

-- ---- 设置内容 ----
local settingsPage = Instance.new("Frame")
settingsPage.Size = UDim2.new(1, 0, 1, 0)
settingsPage.BackgroundTransparency = 1
settingsPage.Parent = contentContainer
settingsPage.Visible = false

local settingsTitle = Instance.new("TextLabel")
settingsTitle.Size = UDim2.new(1, 0, 0, 40)
settingsTitle.Position = UDim2.new(0, 0, 0, 0)
settingsTitle.BackgroundTransparency = 1
settingsTitle.Text = "设置"
settingsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
settingsTitle.TextSize = 24
settingsTitle.TextXAlignment = Enum.TextXAlignment.Left
settingsTitle.Font = Enum.Font.GothamBold
settingsTitle.Parent = settingsPage

local settingsSubtitle = Instance.new("TextLabel")
settingsSubtitle.Size = UDim2.new(1, 0, 0, 20)
settingsSubtitle.Position = UDim2.new(0, 0, 0, 40)
settingsSubtitle.BackgroundTransparency = 1
settingsSubtitle.Text = "偏好设置"
settingsSubtitle.TextColor3 = Color3.fromRGB(180, 190, 210)
settingsSubtitle.TextSize = 13
settingsSubtitle.TextXAlignment = Enum.TextXAlignment.Left
settingsSubtitle.Font = Enum.Font.GothamMedium
settingsSubtitle.Parent = settingsPage

local divider2 = Instance.new("Frame")
divider2.Size = UDim2.new(1, 0, 0, 1)
divider2.Position = UDim2.new(0, 0, 0, 66)
divider2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
divider2.BackgroundTransparency = 0.15
divider2.Parent = settingsPage

local toggleContainer2 = Instance.new("Frame")
toggleContainer2.Size = UDim2.new(1, 0, 0, 110)
toggleContainer2.Position = UDim2.new(0, 0, 0, 76)
toggleContainer2.BackgroundTransparency = 1
toggleContainer2.Parent = settingsPage

local toggle4 = createToggle(toggleContainer2, false, "🌙 深色模式", function(val)
	print("深色模式:", val)
end)

local toggle5 = createToggle(toggleContainer2, true, "🔔 通知", function(val)
	print("通知:", val)
end)

toggle4.container.Position = UDim2.new(0, 0, 0, 0)
toggle5.container.Position = UDim2.new(0, 0, 0, 48)

pages.settings = settingsPage

-- ---- 关于内容 ----
local aboutPage = Instance.new("Frame")
aboutPage.Size = UDim2.new(1, 0, 1, 0)
aboutPage.BackgroundTransparency = 1
aboutPage.Parent = contentContainer
aboutPage.Visible = false

local aboutTitle = Instance.new("TextLabel")
aboutTitle.Size = UDim2.new(1, 0, 0, 40)
aboutTitle.Position = UDim2.new(0, 0, 0, 0)
aboutTitle.BackgroundTransparency = 1
aboutTitle.Text = "关于"
aboutTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
aboutTitle.TextSize = 24
aboutTitle.TextXAlignment = Enum.TextXAlignment.Left
aboutTitle.Font = Enum.Font.GothamBold
aboutTitle.Parent = aboutPage

local aboutSubtitle = Instance.new("TextLabel")
aboutSubtitle.Size = UDim2.new(1, 0, 0, 20)
aboutSubtitle.Position = UDim2.new(0, 0, 0, 40)
aboutSubtitle.BackgroundTransparency = 1
aboutSubtitle.Text = "Liquid Glass UI v1.0"
aboutSubtitle.TextColor3 = Color3.fromRGB(180, 190, 210)
aboutSubtitle.TextSize = 13
aboutSubtitle.TextXAlignment = Enum.TextXAlignment.Left
aboutSubtitle.Font = Enum.Font.GothamMedium
aboutSubtitle.Parent = aboutPage

local divider3 = Instance.new("Frame")
divider3.Size = UDim2.new(1, 0, 0, 1)
divider3.Position = UDim2.new(0, 0, 0, 66)
divider3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
divider3.BackgroundTransparency = 0.15
divider3.Parent = aboutPage

local aboutText = Instance.new("TextLabel")
aboutText.Size = UDim2.new(1, 0, 0, 80)
aboutText.Position = UDim2.new(0, 0, 0, 80)
aboutText.BackgroundTransparency = 1
aboutText.Text = "✨ 液态玻璃 UI 框架\n\n专为 Roblox 手机端设计\n支持拖拽 · 毛玻璃效果 · 流畅动画"
aboutText.TextColor3 = Color3.fromRGB(200, 210, 230)
aboutText.TextSize = 14
aboutText.TextXAlignment = Enum.TextXAlignment.Left
aboutText.TextYAlignment = Enum.TextYAlignment.Top
aboutText.Font = Enum.Font.GothamMedium
aboutText.LineHeight = 1.4
aboutText.Parent = aboutPage

local versionText = Instance.new("TextLabel")
versionText.Size = UDim2.new(1, 0, 0, 30)
versionText.Position = UDim2.new(0, 0, 1, -50)
versionText.BackgroundTransparency = 1
versionText.Text = "由 Roblox Lua 驱动 • 设计灵感 iOS"
versionText.TextColor3 = Color3.fromRGB(140, 150, 180)
versionText.TextSize = 11
versionText.TextXAlignment = Enum.TextXAlignment.Left
versionText.Font = Enum.Font.GothamLight
versionText.Parent = aboutPage

pages.about = aboutPage

-- ============================================================
--  Tab 切换函数
-- ============================================================

function switchTab(tabId)
	if currentTab == tabId then return end
	currentTab = tabId
	
	-- 更新 Tab 按钮样式
	for id, btnData in pairs(tabButtons) do
		local isActive = (id == tabId)
		local btn = btnData.button
		local indicator = btnData.indicator
		
		-- 背景透明度
		local bgTarget = isActive and 0.2 or 0.85
		local tween = TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			BackgroundTransparency = bgTarget
		})
		tween:Play()
		
		-- 指示器
		local indTarget = isActive and 0 or 1
		local indTween = TweenService:Create(indicator, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			BackgroundTransparency = indTarget
		})
		indTween:Play()
		
		-- 标签颜色
		local labelColor = isActive and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 190, 210)
		local labelTween = TweenService:Create(btnData.label, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			TextColor3 = labelColor
		})
		labelTween:Play()
		
		-- 图标颜色
		local iconColor = isActive and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 190, 210)
		local iconTween = TweenService:Create(btnData.icon, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			TextColor3 = iconColor
		})
		iconTween:Play()
	end
	
	-- 切换页面
	for id, page in pairs(pages) do
		local shouldShow = (id == tabId)
		if shouldShow and not page.Visible then
			page.Visible = true
			page.BackgroundTransparency = 1
			-- 淡入动画
			local fadeIn = TweenService:Create(page, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				BackgroundTransparency = 0
			})
			fadeIn:Play()
		elseif not shouldShow and page.Visible then
			local fadeOut = TweenService:Create(page, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				BackgroundTransparency = 1
			})
			fadeOut:Play()
			fadeOut.Completed:Connect(function()
				page.Visible = false
			end)
		end
	end
end

-- ============================================================
--  窗口拖动功能 (手机端 + PC)
-- ============================================================

local dragData = {
	isDragging = false,
	startPos = nil,
	startMousePos = nil,
	startFramePos = nil
}

mainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
		-- 检查是否点击在可拖动区域 (除了按钮和开关)
		local target = input.Parent
		local isInteractive = false
		
		-- 检查点击是否在交互元素上 (按钮、开关等)
		local check = target
		while check and check ~= mainFrame do
			if check:IsA("TextButton") or check:IsA("ImageButton") or 
			   (check:IsA("Frame") and check.Parent and check.Parent:IsA("TextButton")) then
				isInteractive = true
				break
			end
			-- 检查是否是开关的滑块或背景
			if check.Name == "toggleBg" or check.Name == "toggleHandle" then
				isInteractive = true
				break
			end
			check = check.Parent
		end
		
		if isInteractive then return end
		
		-- 开始拖动
		dragData.isDragging = true
		dragData.startPos = input.Position
		dragData.startFramePos = mainFrame.Position
		
		-- 提升 ZIndex 使窗口突出
		mainFrame.ZIndex = 10
	end
end)

mainFrame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
		if dragData.isDragging then
			local delta = input.Position - dragData.startPos
			local newX = dragData.startFramePos.X.Offset + delta.X
			local newY = dragData.startFramePos.Y.Offset + delta.Y
			
			-- 限制在屏幕内
			local screenSize = ScreenGui.AbsoluteSize
			local frameSize = mainFrame.AbsoluteSize
			newX = math.max(-frameSize.X/2 + 10, math.min(screenSize.X - frameSize.X/2 - 10, newX))
			newY = math.max(-frameSize.Y/2 + 10, math.min(screenSize.Y - frameSize.Y/2 - 10, newY))
			
			mainFrame.Position = UDim2.new(0.5, newX, 0.5, newY)
		end
	end
end)

mainFrame.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
		if dragData.isDragging then
			dragData.isDragging = false
			mainFrame.ZIndex = 1
		end
	end
end)

-- ============================================================
--  初始化 - 默认选中首页
-- ============================================================

-- 默认选中首页
switchTab("home")

-- 窗口入场动画
mainFrame.Size = UDim2.new(0, 0, 0, 0)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)

local enterTween = TweenService:Create(mainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
	Size = UDim2.new(0, windowWidth, 0, windowHeight),
	Position = UDim2.new(0.5, -windowWidth/2, 0.5, -windowHeight/2)
})
enterTween:Play()

-- 背景遮罩淡入
backdrop.BackgroundTransparency = 1
local backdropTween = TweenService:Create(backdrop, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
	BackgroundTransparency = 0.4
})
backdropTween:Play()

-- ============================================================
--  点击背景关闭 (可选的)
-- ============================================================

backdrop.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
		-- 如果点击的是背景遮罩，关闭UI
		if input.Parent == backdrop then
			local closeTween = TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
				Size = UDim2.new(0, 0, 0, 0),
				Position = UDim2.new(0.5, 0, 0.5, 0)
			})
			closeTween:Play()
			closeTween.Completed:Connect(function()
				ScreenGui.Enabled = false
			end)
			local bgTween = TweenService:Create(backdrop, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				BackgroundTransparency = 1
			})
			bgTween:Play()
		end
	end
end)

-- ============================================================
--  防误触：阻止点击穿透
-- ============================================================

mainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch then
		input.StopPropagation()
	end
end)

-- ============================================================
--  响应式适配 - 屏幕尺寸变化时调整
-- ============================================================

ScreenGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
	local screenSize = ScreenGui.AbsoluteSize
	local newWidth = math.min(420, screenSize.X * 0.88)
	local newHeight = math.min(580, screenSize.Y * 0.78)
	
	-- 只在窗口未拖动时调整
	if not dragData.isDragging then
		mainFrame.Size = UDim2.new(0, newWidth, 0, newHeight)
		mainFrame.Position = UDim2.new(0.5, -newWidth/2, 0.5, -newHeight/2)
	end
end)

-- ============================================================
--  键盘快捷键 (PC 调试用)
-- ============================================================

if not isMobile then
	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		if input.KeyCode == Enum.KeyCode.Escape then
			local closeTween = TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
				Size = UDim2.new(0, 0, 0, 0),
				Position = UDim2.new(0.5, 0, 0.5, 0)
			})
			closeTween:Play()
			closeTween.Completed:Connect(function()
				ScreenGui.Enabled = false
			end)
		end
	end)
end

-- ============================================================
--  打印启动信息
-- ============================================================

print("✨ Liquid Glass UI 已加载")
print("📱 手机端适配: " .. tostring(isMobile))
print("🔹 拖动窗口: 拖动标题栏或空白区域")
print("🔹 切换标签: 点击左侧 Tab")
print("🔹 关闭窗口: 点击右上角 ✕ 或点击背景")

-- ============================================================
--  导出 API (可供其他脚本调用)
-- ============================================================

return {
	ScreenGui = ScreenGui,
	MainFrame = mainFrame,
	SwitchTab = switchTab,
	GetCurrentTab = function() return currentTab end,
	Toggle1 = toggle1,
	Toggle2 = toggle2,
	Toggle3 = toggle3,
	Toggle4 = toggle4,
	Toggle5 = toggle5,
	Close = function()
		local closeTween = TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
			Size = UDim2.new(0, 0, 0, 0),
			Position = UDim2.new(0.5, 0, 0.5, 0)
		})
		closeTween:Play()
		closeTween.Completed:Connect(function()
			ScreenGui.Enabled = false
		end)
	end,
	Show = function()
		ScreenGui.Enabled = true
		mainFrame.Size = UDim2.new(0, 0, 0, 0)
		mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
		local showTween = TweenService:Create(mainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, windowWidth, 0, windowHeight),
			Position = UDim2.new(0.5, -windowWidth/2, 0.5, -windowHeight/2)
		})
		showTween:Play()
		backdrop.BackgroundTransparency = 1
		local bgTween = TweenService:Create(backdrop, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			BackgroundTransparency = 0.4
		})
		bgTween:Play()
	end
}
