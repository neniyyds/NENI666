local Library = loadstring(...)

local Window = Library:CreateWindow({
    Title = "NENI Hub"
})

local Main = Window:CreateTab("首頁","🏠")

Main:CreateButton({
    Name = "Hello",
    Callback = function()
        print("Hello")
    end
})

Main:CreateToggle({
    Name = "Auto",
    Default = false,
    Callback = function(v)
        print(v)
    end
})

Main:CreateSlider({
    Name = "Speed",
    Min = 0,
    Max = 100,
    Default = 50,
    Callback = function(v)
        print(v)
    end
})
