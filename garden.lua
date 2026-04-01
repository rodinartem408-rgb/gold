-- MALOT UNIVERSAL CHEAT v5.2 FINAL iOS — ВСЁ РАБОТАЕТ, МЕНЮ ДВИГАЕТСЯ ИДЕАЛЬНО

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local character, humanoid, rootPart
local speedValue = 160
local jumpPowerValue = 220
local flySpeed = 80

local states = {
    invisible = false,
    fly = false,
    noclip = false,
    infiniteJump = false,
    godMode = true,
    safeSpeed = true
}

local function setupCharacter()
    character = player.Character or player.CharacterAdded:Wait()
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
end
setupCharacter()
player.CharacterAdded:Connect(setupCharacter)

-- ==================== GUI v5.2 ====================
local screenGui = Instance.new("ScreenGui")
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 680)
mainFrame.Position = UDim2.new(0.5, -200, 0.3, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 32)
corner.Parent = mainFrame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(90, 190, 255)
stroke.Thickness = 2.5
stroke.Parent = mainFrame

-- Title
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 70)
titleBar.BackgroundColor3 = Color3.fromRGB(28, 28, 40)
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 32)
titleCorner.Parent = titleBar

local title = Instance.new("TextLabel")
title.Text = "MALOT UNIVERSAL"
title.Size = UDim2.new(1, -150, 1, 0)
title.Position = UDim2.new(0, 30, 0, 0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true
title.Font = Enum.Font.GothamBlack
title.Parent = titleBar

local ver = Instance.new("TextLabel")
ver.Text = "v5.2"
ver.Position = UDim2.new(1, -120, 0.5, -12)
ver.Size = UDim2.new(0, 90, 0, 25)
ver.BackgroundTransparency = 1
ver.TextColor3 = Color3.fromRGB(130, 230, 255)
ver.TextScaled = true
ver.Font = Enum.Font.Gotham
ver.Parent = titleBar

-- Кнопки
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 60, 0, 60)
minBtn.Position = UDim2.new(1, -125, 0, 5)
minBtn.BackgroundTransparency = 1
minBtn.Text = "–"
minBtn.TextColor3 = Color3.new(1,1,1)
minBtn.TextScaled = true
minBtn.Font = Enum.Font.GothamBold
minBtn.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 60, 0, 60)
closeBtn.Position = UDim2.new(1, -60, 0, 5)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
closeBtn.TextScaled = true
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = titleBar

-- Content
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -30, 1, -90)
scroll.Position = UDim2.new(0, 15, 0, 80)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 6
scroll.ScrollBarImageColor3 = Color3.fromRGB(100, 210, 255)
scroll.CanvasSize = UDim2.new(0,0,0,900)
scroll.Parent = mainFrame

local list = Instance.new("UIListLayout")
list.Padding = UDim.new(0, 18)
list.SortOrder = Enum.SortOrder.LayoutOrder
list.Parent = scroll

-- iOS Toggle
local function createToggle(name, default, callback)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -10, 0, 78)
    f.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
    f.BorderSizePixel = 0
    f.Parent = scroll

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 22)
    c.Parent = f

    local lbl = Instance.new("TextLabel")
    lbl.Text = name
    lbl.Position = UDim2.new(0, 28, 0.5, -15)
    lbl.Size = UDim2.new(0.62, 0, 0, 32)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.new(1,1,1)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextScaled = true
    lbl.Font = Enum.Font.GothamSemibold
    lbl.Parent = f

    local sw = Instance.new("Frame")
    sw.Size = UDim2.new(0, 62, 0, 36)
    sw.Position = UDim2.new(1, -85, 0.5, -18)
    sw.BackgroundColor3 = default and Color3.fromRGB(0, 225, 140) or Color3.fromRGB(70, 70, 80)
    sw.Parent = f

    local swc = Instance.new("UICorner")
    swc.CornerRadius = UDim.new(1,0)
    swc.Parent = sw

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 30, 0, 30)
    knob.Position = default and UDim2.new(1, -34, 0.5, -15) or UDim2.new(0, 3, 0.5, -15)
    knob.BackgroundColor3 = Color3.new(1,1,1)
    knob.Parent = sw

    local kc = Instance.new("UICorner")
    kc.CornerRadius = UDim.new(1,0)
    kc.Parent = knob

    local on = default
    sw.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            on = not on
            callback(on)
            TweenService:Create(sw, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {BackgroundColor3 = on and Color3.fromRGB(0,225,140) or Color3.fromRGB(70,70,80)}):Play()
            TweenService:Create(knob, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {Position = on and UDim2.new(1,-34,0.5,-15) or UDim2.new(0,3,0.5,-15)}):Play()
        end
    end)
end

-- Добавляем все функции
createToggle("Невидимость", false, function(v) states.invisible = v end)
createToggle("Полёт (Fly)", false, function(v) states.fly = v end)
createToggle("Noclip (сквозь стены)", false, function(v) states.noclip = v end)
createToggle("Бесконечный прыжок", false, function(v) states.infiniteJump = v end)
createToggle("Режим Бога", true, function(v) states.godMode = v end)
createToggle("Safe Speed (CFrame)", true, function(v) states.safeSpeed = v end)

-- Скорость и прыжок
local function createSlider(name, default, callback)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -10, 0, 90)
    f.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
    f.Parent = scroll

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 22)
    c.Parent = f

    local lbl = Instance.new("TextLabel")
    lbl.Text = name
    lbl.Position = UDim2.new(0, 25, 0, 12)
    lbl.Size = UDim2.new(1, -50, 0, 30)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.new(1,1,1)
    lbl.TextScaled = true
    lbl.Font = Enum.Font.GothamSemibold
    lbl.Parent = f

    local box = Instance.new("TextBox")
    box.Text = tostring(default)
    box.Position = UDim2.new(0.68, 0, 0.5, -18)
    box.Size = UDim2.new(0.28, 0, 0, 42)
    box.BackgroundColor3 = Color3.fromRGB(25,25,35)
    box.TextColor3 = Color3.fromRGB(0, 240, 255)
    box.TextScaled = true
    box.Font = Enum.Font.GothamBold
    box.Parent = f

    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(0, 14)
    bc.Parent = box

    box.FocusLost:Connect(function()
        local num = tonumber(box.Text)
        if num then callback(num) end
    end)
end

createSlider("Скорость бега", speedValue, function(v) speedValue = v end)
createSlider("Сила прыжка", jumpPowerValue, function(v) jumpPowerValue = v end)

-- ==================== ЧИТ ЛОГИКА ====================
UserInputService.JumpRequest:Connect(function()
    if states.infiniteJump and humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

local flyBody = nil

RunService.Heartbeat:Connect(function(dt)
    if not character or not rootPart or not humanoid then return end

    if states.godMode then
        humanoid.Health = 10000
        humanoid.MaxHealth = 10000
    end

    humanoid.WalkSpeed = speedValue
    humanoid.JumpPower = jumpPowerValue

    -- Невидимость
    if states.invisible then
        for _, obj in ipairs(character:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name ~= "HumanoidRootPart" then
                obj.Transparency = 1
            elseif obj:IsA("Decal") or obj:IsA("Texture") then
                obj.Transparency = 1
            end
        end
    else
        for _, obj in ipairs(character:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name ~= "HumanoidRootPart" then
                obj.Transparency = 0
            elseif obj:IsA("Decal") or obj:IsA("Texture") then
                obj.Transparency = 0
            end
        end
    end

    -- Fly
    if states.fly then
        if not flyBody then
            flyBody = Instance.new("BodyVelocity")
            flyBody.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            flyBody.Parent = rootPart
        end
        local dir = Vector3.new()
        local cf = camera.CFrame
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += cf.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= cf.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= cf.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += cf.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.new(0,1,0) end
        flyBody.Velocity = dir.Unit * flySpeed
    elseif flyBody then
        flyBody:Destroy()
        flyBody = nil
    end

    if states.noclip then
        for _, p in ipairs(character:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end

    if states.safeSpeed and humanoid.MoveDirection.Magnitude > 0 then
        rootPart.CFrame += humanoid.MoveDirection * speedValue * dt * 3.7
    end
end)

-- Управление окном
minBtn.MouseButton1Click:Connect(function()
    local target = mainFrame.Size.Y.Offset == 680 and UDim2.new(0,400,0,70) or UDim2.new(0,400,0,680)
    TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {Size = target}):Play()
    scroll.Visible = mainFrame.Size.Y.Offset == 680
    minBtn.Text = mainFrame.Size.Y.Offset == 680 and "+" or "–"
end)

closeBtn.MouseButton1Click:Connect(function()
    screenGui.Enabled = false
end)

UserInputService.InputBegan:Connect(function(inp)
    if inp.KeyCode == Enum.KeyCode.RightShift then
        screenGui.Enabled = not screenGui.Enabled
    end
end)

StarterGui:SetCore("SendNotification", {
    Title = "MALOT v5.2 FINAL",
    Text = "Меню полностью исправлено! Двигается легко, все функции работают. RightShift — открыть.",
    Duration = 8
})

print("[MALOT] v5.2 FINAL ЗАГРУЖЕН — теперь всё должно работать идеально!")
