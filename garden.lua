-- =============================================
-- DELTA PREMIUM GUI v2.1 — Полный LuaU скрипт
-- Для Delta Executor (2026)
-- Неоновый тёмный дизайн + блюр + плавные анимации
-- =============================================

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

getgenv().DeltaPremium = getgenv().DeltaPremium or {}

local Menu = {
    Opened = false,
    Keybind = Enum.KeyCode.RightShift,
    AccentColor = Color3.fromRGB(255, 20, 147), -- неоново-розовый
    BlurSize = 24
}

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaPremiumGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- Blur
local Blur = Instance.new("BlurEffect")
Blur.Size = 0
Blur.Parent = Lighting

-- Main Frame
local Main = Instance.new("Frame")
Main.Name = "MainFrame"
Main.Size = UDim2.new(0, 700, 0, 540)
Main.Position = UDim2.new(0.5, -350, 0.5, -270)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Visible = false
Main.Parent = ScreenGui

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 18)

local Stroke = Instance.new("UIStroke")
Stroke.Color = Menu.AccentColor
Stroke.Thickness = 2.5
Stroke.Parent = Main

-- Glow
local Glow = Instance.new("ImageLabel")
Glow.Size = UDim2.new(1, 60, 1, 60)
Glow.Position = UDim2.new(0, -30, 0, -30)
Glow.BackgroundTransparency = 1
Glow.Image = "rbxassetid://6014261993"
Glow.ImageColor3 = Menu.AccentColor
Glow.ImageTransparency = 0.65
Glow.ZIndex = -1
Glow.Parent = Main

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -80, 0, 60)
Title.Position = UDim2.new(0, 25, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "DELTA PREMIUM"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 26
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Main

local WM = Instance.new("TextLabel")
WM.Size = UDim2.new(0, 200, 0, 60)
WM.Position = UDim2.new(1, -230, 0, 0)
WM.BackgroundTransparency = 1
WM.Text = "Made with ❤️ • 2026"
WM.TextColor3 = Color3.fromRGB(160, 160, 255)
WM.Font = Enum.Font.Gotham
WM.TextSize = 14
WM.TextXAlignment = Enum.TextXAlignment.Right
WM.Parent = Main

-- Close Button
local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0, 40, 0, 40)
Close.Position = UDim2.new(1, -55, 0, 10)
Close.BackgroundTransparency = 1
Close.Text = "✕"
Close.TextColor3 = Color3.fromRGB(255, 70, 70)
Close.Font = Enum.Font.GothamBold
Close.TextSize = 28
Close.Parent = Main

-- Floating Open Button
local OpenButton = Instance.new("ImageButton")
OpenButton.Size = UDim2.new(0, 65, 0, 65)
OpenButton.Position = UDim2.new(0, 40, 1, -100)
OpenButton.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
OpenButton.Image = "rbxassetid://10734950309"
OpenButton.ImageColor3 = Menu.AccentColor
OpenButton.Parent = ScreenGui

Instance.new("UICorner", OpenButton).CornerRadius = UDim.new(1, 0)
local OBStroke = Instance.new("UIStroke", OpenButton)
OBStroke.Color = Menu.AccentColor
OBStroke.Thickness = 4

-- Tabs Container
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(0, 170, 1, -60)
TabBar.Position = UDim2.new(0, 0, 0, 60)
TabBar.BackgroundColor3 = Color3.fromRGB(14, 14, 20)
TabBar.Parent = Main

Instance.new("UICorner", TabBar).CornerRadius = UDim.new(0, 16)

local TabLayout = Instance.new("UIListLayout", TabBar)
TabLayout.Padding = UDim.new(0, 6)
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Content
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -170, 1, -60)
Content.Position = UDim2.new(0, 170, 0, 60)
Content.BackgroundTransparency = 1
Content.Parent = Main

-- Notification Container
local NotifContainer = Instance.new("Frame")
NotifContainer.Size = UDim2.new(0, 300, 1, 0)
NotifContainer.Position = UDim2.new(1, -320, 1, -80)
NotifContainer.BackgroundTransparency = 1
NotifContainer.Parent = ScreenGui

local function SendNotification(msg, time)
    time = time or 4
    local Notif = Instance.new("Frame")
    Notif.Size = UDim2.new(1, 0, 0, 0)
    Notif.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
    Notif.Parent = NotifContainer
    
    Instance.new("UICorner", Notif).CornerRadius = UDim.new(0, 14)
    local NStroke = Instance.new("UIStroke", Notif)
    NStroke.Color = Menu.AccentColor
    NStroke.Thickness = 1.8
    
    local NText = Instance.new("TextLabel")
    NText.Size = UDim2.new(1, -20, 1, 0)
    NText.Position = UDim2.new(0, 10, 0, 0)
    NText.BackgroundTransparency = 1
    NText.Text = msg
    NText.TextColor3 = Color3.fromRGB(240, 240, 255)
    NText.Font = Enum.Font.Gotham
    NText.TextSize = 17
    NText.TextWrapped = true
    NText.Parent = Notif
    
    TweenService:Create(Notif, TweenInfo.new(0.45, Enum.EasingStyle.Quint), {Size = UDim2.new(1, 0, 0, 70)}):Play()
    
    task.delay(time, function()
        TweenService:Create(Notif, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {Size = UDim2.new(1, 0, 0, 0)}):Play()
        task.wait(0.45)
        Notif:Destroy()
    end)
end

-- Tab Creator
local CurrentTabContent = nil
local Tabs = {}

local function CreateTab(tabName)
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(1, -12, 0, 52)
    TabButton.Position = UDim2.new(0, 6, 0, 0)
    TabButton.BackgroundColor3 = Color3.fromRGB(24, 24, 34)
    TabButton.Text = tabName
    TabButton.TextColor3 = Color3.fromRGB(210, 210, 230)
    TabButton.Font = Enum.Font.GothamSemibold
    TabButton.TextSize = 17
    TabButton.Parent = TabBar
    
    Instance.new("UICorner", TabButton).CornerRadius = UDim.new(0, 12)
    
    local TabContent = Instance.new("ScrollingFrame")
    TabContent.Size = UDim2.new(1, 0, 1, 0)
    TabContent.BackgroundTransparency = 1
    TabContent.ScrollBarThickness = 5
    TabContent.ScrollBarImageColor3 = Menu.AccentColor
    TabContent.Visible = false
    TabContent.Parent = Content
    
    local ListLayout = Instance.new("UIListLayout", TabContent)
    ListLayout.Padding = UDim.new(0, 10)
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    Tabs[tabName] = {Button = TabButton, Content = TabContent}
    
    TabButton.MouseButton1Click:Connect(function()
        if CurrentTabContent then CurrentTabContent.Visible = false end
        CurrentTabContent = TabContent
        CurrentTabContent.Visible = true
        
        for _, t in pairs(Tabs) do
            TweenService:Create(t.Button, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(24, 24, 34)}):Play()
        end
        TweenService:Create(TabButton, TweenInfo.new(0.3), {BackgroundColor3 = Menu.AccentColor}):Play()
    end)
    
    return TabContent
end

-- Создание вкладок
local Home = CreateTab("Home")
local Combat = CreateTab("Combat")
local Movement = CreateTab("Movement")
local Visuals = CreateTab("Visuals")
local Misc = CreateTab("Misc")
local Settings = CreateTab("Settings")

-- Home
local HomeLabel = Instance.new("TextLabel")
HomeLabel.Size = UDim2.new(1, -30, 0, 100)
HomeLabel.BackgroundTransparency = 1
HomeLabel.Text = "DELTA PREMIUM\nLoaded Successfully"
HomeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
HomeLabel.Font = Enum.Font.GothamBlack
HomeLabel.TextSize = 32
HomeLabel.Parent = Home

-- Функция Toggle
local function CreateToggle(parent, title, default, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -30, 0, 55)
    Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    Frame.Parent = parent
    
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 14)
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.65, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = title
    Label.TextColor3 = Color3.fromRGB(225, 225, 245)
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 18
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame
    
    local Switch = Instance.new("Frame")
    Switch.Size = UDim2.new(0, 58, 0, 30)
    Switch.Position = UDim2.new(1, -78, 0.5, -15)
    Switch.BackgroundColor3 = default and Menu.AccentColor or Color3.fromRGB(55, 55, 65)
    Switch.Parent = Frame
    
    Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)
    
    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 26, 0, 26)
    Knob.Position = default and UDim2.new(1, -28, 0.5, -13) or UDim2.new(0, 2, 0.5, -13)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Knob.Parent = Switch
    
    Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)
    
    local Enabled = default
    
    Frame.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            Enabled = not Enabled
            TweenService:Create(Switch, TweenInfo.new(0.28, Enum.EasingStyle.Quint), {
                BackgroundColor3 = Enabled and Menu.AccentColor or Color3.fromRGB(55, 55, 65)
            }):Play()
            TweenService:Create(Knob, TweenInfo.new(0.28, Enum.EasingStyle.Quint), {
                Position = Enabled and UDim2.new(1, -28, 0.5, -13) or UDim2.new(0, 2, 0.5, -13)
            }):Play()
            callback(Enabled)
            SendNotification(title .. (Enabled and " → ВКЛ" or " → ВЫКЛ"))
        end
    end)
end

-- Функция Slider
local function CreateSlider(parent, title, minVal, maxVal, defVal, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -30, 0, 70)
    Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    Frame.Parent = parent
    
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 14)
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -20, 0, 25)
    Label.BackgroundTransparency = 1
    Label.Text = title .. ": " .. defVal
    Label.TextColor3 = Color3.fromRGB(225, 225, 245)
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 17
    Label.Parent = Frame
    
    local Bar = Instance.new("Frame")
    Bar.Size = UDim2.new(1, -40, 0, 9)
    Bar.Position = UDim2.new(0, 20, 0, 42)
    Bar.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    Bar.Parent = Frame
    
    Instance.new("UICorner", Bar).CornerRadius = UDim.new(0, 5)
    
    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((defVal - minVal) / (maxVal - minVal), 0, 1, 0)
    Fill.BackgroundColor3 = Menu.AccentColor
    Fill.Parent = Bar
    
    Instance.new("UICorner", Fill).CornerRadius = UDim.new(0, 5)
    
    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 18, 0, 18)
    Knob.Position = UDim2.new((defVal - minVal) / (maxVal - minVal), -9, 0.5, -9)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Knob.Parent = Bar
    
    Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)
    
    local Value = defVal
    local Dragging = false
    
    Bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end
    end)
    
    RunService.RenderStepped:Connect(function()
        if Dragging then
            local relPos = math.clamp((UserInputService:GetMouseLocation().X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
            Value = math.floor(minVal + (maxVal - minVal) * relPos)
            Fill.Size = UDim2.new(relPos, 0, 1, 0)
            Knob.Position = UDim2.new(relPos, -9, 0.5, -9)
            Label.Text = title .. ": " .. Value
            callback(Value)
        end
    end)
end

-- Заполнение вкладок
CreateToggle(Combat, "Silent Aim", false, function(v) getgenv().SilentAimEnabled = v end)
CreateToggle(Combat, "Aim Assist", false, function(v) getgenv().AimAssist = v end)
CreateToggle(Combat, "Triggerbot", false, function(v) getgenv().Triggerbot = v end)
CreateToggle(Combat, "No Recoil", false, function(v) getgenv().NoRecoil = v end)
CreateToggle(Combat, "Infinite Ammo", false, function(v) getgenv().InfiniteAmmo = v end)
CreateToggle(Combat, "Kill Aura", false, function(v) getgenv().KillAura = v end)
CreateSlider(Combat, "Hitbox Expander", 2, 25, 8, function(v) getgenv().HitboxMultiplier = v end)

CreateToggle(Movement, "Speed Hack", false, function(v) getgenv().SpeedHack = v end)
CreateSlider(Movement, "Speed", 16, 300, 120, function(v) getgenv().WalkSpeed = v end)
CreateToggle(Movement, "Fly", false, function(v) getgenv().FlyEnabled = v end)
CreateToggle(Movement, "Noclip", false, function(v) getgenv().Noclip = v end)
CreateToggle(Movement, "Infinite Jump", false, function(v) getgenv().InfJump = v end)
CreateToggle(Movement, "Godmode", false, function(v) getgenv().Godmode = v end)

CreateToggle(Visuals, "ESP Box", false, function(v) getgenv().ESPBox = v end)
CreateToggle(Visuals, "ESP Name", false, function(v) getgenv().ESPName = v end)
CreateToggle(Visuals, "ESP Health", false, function(v) getgenv().ESPHealth = v end)
CreateToggle(Visuals, "Chams", false, function(v) getgenv().Chams = v end)
CreateToggle(Visuals, "Fullbright", false, function(v) getgenv().Fullbright = v end)
CreateToggle(Visuals, "No Fog", false, function(v) getgenv().NoFog = v end)

CreateToggle(Misc, "Auto Farm", false, function(v) getgenv().AutoFarm = v end)
CreateToggle(Misc, "Server Hop", false, function(v) getgenv().ServerHop = v end)
CreateToggle(Misc, "Anti AFK", true, function(v) getgenv().AntiAFK = v end)
CreateToggle(Misc, "Fake Lag", false, function(v) getgenv().FakeLag = v end)

-- Settings
CreateToggle(Settings, "Blur Background", true, function(v)
    Blur.Size = v and Menu.BlurSize or 0
end)

-- Анимация меню
local function AnimateMenu(open)
    Menu.Opened = open
    if open then
        Main.Visible = true
        TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0, 700, 0, 540)}):Play()
        TweenService:Create(Blur, TweenInfo.new(0.5), {Size = Menu.BlurSize}):Play()
        SendNotification("Delta Premium активирован")
    else
        TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {Size = UDim2.new(0, 700, 0, 0)}):Play()
        TweenService:Create(Blur, TweenInfo.new(0.4), {Size = 0}):Play()
        task.wait(0.45)
        Main.Visible = false
    end
end

-- Управление
Close.MouseButton1Click:Connect(function() AnimateMenu(false) end)
OpenButton.MouseButton1Click:Connect(function() AnimateMenu(not Menu.Opened) end)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Menu.Keybind then
        AnimateMenu(not Menu.Opened)
    end
end)

-- Инициализация
CurrentTabContent = Home
Home.Visible = true
Tabs["Home"].Button.BackgroundColor3 = Menu.AccentColor

SendNotification("Delta Premium v2.1 успешно загружен\nRightShift — открыть меню")

print("[Delta Premium] Готов к использованию в Delta Executor")
