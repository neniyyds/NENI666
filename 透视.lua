local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

-- 创建一个GUI用于显示透视标记
local espGui = Instance.new("ScreenGui")
espGui.Name = "ESPGui"
espGui.Parent = PlayerGui
espGui.IgnoreGuiInset = true -- 忽略屏幕边缘 inset

local hasESP = false -- 标记玩家是否获得透视授权
local trackedObjects = {} -- 跟踪需要透视显示的物体（如敌人）

-- 从服务器接收授权信号
ReplicatedStorage:WaitForChild("GrantESP").OnClientEvent:Connect(function(authorized)
    hasESP = authorized
    if not authorized then
        -- 取消授权时清除所有标记
        for _, marker in ipairs(espGui:GetChildren()) do
            marker:Destroy()
        end
        trackedObjects = {}
    end
end)

-- 定义需要透视显示的物体（例如地图中的敌人）
local function getTargetObjects()
    local targets = {}
    -- 示例：获取所有名为"Enemy"的模型
    for _, model in ipairs(workspace:GetDescendants()) do
        if model:IsA("Model") and model.Name == "Enemy" then
            table.insert(targets, model)
        end
    end
    return targets
end

-- 为每个目标创建透视标记
local function updateESP()
    if not hasESP then return end

    local currentTargets = getTargetObjects()
    local newTracked = {}

    -- 为新目标创建标记
    for _, target in ipairs(currentTargets) do
        if not trackedObjects[target] then
            local marker = Instance.new("Frame")
            marker.Size = UDim2.new(0, 20, 0, 20)
            marker.BackgroundColor3 = Color3.new(1, 0, 0) -- 红色标记
            marker.BorderSizePixel = 0
            marker.Parent = espGui
            trackedObjects[target] = marker
        end
        table.insert(newTracked, target)
    end

    -- 移除已消失的目标的标记
    for target, marker in pairs(trackedObjects) do
        if not table.find(newTracked, target) then
            marker:Destroy()
            trackedObjects[target] = nil
        end
    end

    -- 更新标记位置（将3D世界坐标转换为屏幕坐标）
    local camera = workspace.CurrentCamera
    for target, marker in pairs(trackedObjects) do
        local humanoidRootPart = target:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            local screenPos, onScreen = camera:WorldToScreenPoint(humanoidRootPart.Position)
            if onScreen then
                marker.Position = UDim2.new(0, screenPos.X - 10, 0, screenPos.Y - 10) -- 居中显示
                marker.Visible = true
            else
                marker.Visible = false -- 物体不在屏幕内时隐藏
            end
        end
    end
end

-- 每帧更新透视标记位置
RunService.RenderStepped:Connect(updateESP)
