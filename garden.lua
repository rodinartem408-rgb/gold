-- MALOT UNIVERSAL CHEAT v5.3 PERFECT iOS — ФУНКЦИИ ВИДНЫ СРАЗУ, МЕНЮ ДВИГАЕТСЯ ИДЕАЛЬНО

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

-- ==================== GUI v5.3 ====================
local screenGui = Instance.new("ScreenGui")
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 410, 0, 720)
mainFrame.Position = UDim2.new(0.5, -205, 0.25, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 34)
mainCorner.Parent = mainFrame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(100, 200, 255)
stroke.Thickness = 2.8
stroke.Parent = mainFrame

-- Заголовок
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 72)
titleBar.BackgroundColor3 = Color3.fromRGB(26, 26, 38)
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 34)
titleCorner.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Text = "MALOT UNIVERSAL"
titleLabel.Size = UDim2.new(1, -160, 1, 0)
titleLabel.Position = UDim2.new(0, 30, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.new(1,1,1)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBlack
titleLabel.Parent = titleBar

local versionLabel = Instance.new("TextLabel")
versionLabel.Text = "v5.3"
versionLabel.Position = UDim2.new(1, -130, 0.5, -14)
versionLabel.Size = UDim2.new(0, 100, 0, 28)
versionLabel.BackgroundTransparency = 1
versionLabel.TextColor3 = Color3.fromRGB(140, 240, 255)
versionLabel.TextScaled = true
versionLabel.Font = Enum.Font.GothamSemibold
versionLabel.Parent = titleBar

-- Кнопки управления
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 65, 0, 65)
minBtn.Position = UDim2.new(1, -135, 0, 4)
minBtn.BackgroundTransparency = 1
minBtn.Text = "–"
minBtn.TextColor3 = Color3.new(1,1,1)
minBtn.TextScaled = true
minBtn.Font = Enum.Font.GothamBold
minBtn.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 65, 0, 65)
closeBtn.Position = UDim2.new(1, -65, 0, 4)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 85, 85)
closeBtn.TextScaled = true
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = titleBar

-- ScrollingFrame — теперь функции видны сразу
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -30, 1, -95)
scrollFrame.Position = UDim2.new(0, 15, 0, 82)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 5
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(110, 220, 255)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 950)
scrollFrame.Parent = mainFrame

local uiList = Instance.new("UIListLayout")
uiList.Padding = UDim.new(0, 16)
uiList.SortOrder = Enum.SortOrder.LayoutOrder
uiList.Parent = scrollFrame

-- Функция создания тоггла
local function createToggle(text, default, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, -12, 0, 82)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(34, 34, 46)
    toggleFrame.BorderSizePixel = 0
    toggleFrame.Parent = scrollFrame

    local tc = Instance.new("UICorner")
    tc.CornerRadius = UDim.new(0, 24)
    tc.Parent = toggleFrame

    local label = Instance.new("TextLabel")
    label.Text = text
    label.Position = UDim2.new(0, 30, 0.5, -18)
    label.Size = UDim2.new(0.6, 0, 0, 36)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1,1,1)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextScaled = true
    label.Font = Enum.Font.GothamSemibold
    label.Parent = toggleFrame

    local switch = Instance.new("Frame")
    switch.Size = UDim2.new(0, 64, 0, 38)
    switch.Position = UDim2.new(1, -88, 0.5, -19)
    switch.BackgroundColor3 = default and Color3.fromRGB(0, 230, 150) or Color3.fromRGB(72, 72, 82)
    switch.Parent = toggleFrame

    local sc = Instance.new("UICorner")
    sc.CornerRadius = UDim.new(1, 0)
    sc.Parent = switch

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 32, 0, 32)
    knob.Position = default and UDim2.new(1, -36, 0.5, -16) or UDim2.new(0, 4, 0.5, -16)
    knob.BackgroundColor3 = Color3.new(1,1,1)
    knob.Parent = switch

    local kc = Instance.new("UICorner")
    kc.CornerRadius = UDim.new(1, 0)
    kc.Parent = knob

    local isOn = default
    switch.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isOn = not isOn
            callback(isOn)

            TweenService:Create(switch, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
                BackgroundColor3 = isOn and Color3.fromRGB(0,230,150) or Color3.fromRGB(72,72,82)
            }):Play()

            TweenService:Create(knob, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
                Position = isOn and UDim2.new(1,-36,0.5,-16) or UDim2.new(0,4,0.5,-16)
            }):Play()
        end
    end)
end

-- Добавляем все функции (теперь они видны сразу)
createToggle("Невидимость", false, function(v) states.invisible = v end)
createToggle("Полёт (Fly)", false, function(v) states.fly = v end)
createToggle("Noclip (сквозь стены)", false, function(v) states.noclip = v end)
createToggle("Бесконечный прыжок", false, function(v) states.infiniteJump = v end)
createToggle("Режим Бога (бессмертие)", true, function(v) states.godMode = v end)
createToggle("Safe Speed (CFrame)", true, function(v) states.safeSpeed = v end)

-- Поля для скорости и прыжка
local function createValueField(title, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -12, 0, 92)
    frame.BackgroundColor3 = Color3.fromRGB(34, 34, 46)
    frame.Parent = scrollFrame

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 24)
    c.Parent = frame

    local lbl = Instance.new("TextLabel")
    lbl.Text = title
    lbl.Position = UDim2.new(0, 28, 0, 14)
    lbl.Size = UDim2.new(0.65, 0, 0, 32)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.new(1,1,1)
    lbl.TextScaled = true
    lbl.Font = Enum.Font.GothamSemibold
    lbl.Parent = frame

    local box = Instance.new("TextBox")
    box.Text = tostring(default)
    box.Position = UDim2.new(0.65, 0, 0.5, -22)
    box.Size = UDim2.new(0.3, 0, 0, 46)
    box.BackgroundColor3 = Color3.fromRGB(24, 24, 34)
    box.TextColor3 = Color3.fromRGB(0, 245, 255)
    box.TextScaled = true
    box.Font = Enum.Font.GothamBold
    box.Parent = frame

    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(0, 16)
    bc.Parent = box

    box.FocusLost:Connect(function()
        local val = tonumber(box.Text)
        if val then callback(val) end
    end)
end

createValueField("Скорость бега", speedValue, function(v) speedValue = v end)
createValueField("Сила прыжка", jumpPowerValue, function(v) jumpPowerValue = v end)

-- ==================== ЛОГИКА ЧИТОВ ====================
UserInputService.JumpRequest:Connect(function()
    if states.infiniteJump and humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

local flyVel = nil

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
            if obj:IsA("BasePart") and obj.Name ~= "HumanoidRootPart" then obj.Transparency = 1
            elseif obj:IsA("Decal") or obj:IsA("Texture") then obj.Transparency = 1 end
        end
    else
        for _, obj in ipairs(character:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name ~= "HumanoidRootPart" then obj.Transparency = 0
            elseif obj:IsA("Decal") or obj:IsA("Texture") then obj.Transparency = 0 end
        end
    end

    -- Fly
    if states.fly then
        if not flyVel then
            flyVel = Instance.new("BodyVelocity")
            flyVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            flyVel.Parent = rootPart
        end
        local dir = Vector3.new()
        local cf = camera.CFrame
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += cf.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= cf.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= cf.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += cf.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.new(0,1,0) end
        flyVel.Velocity = dir.Unit * flySpeed
    elseif flyVel then
        flyVel:Destroy()
        flyVel = nil
    end

    if states.noclip then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end

    if states.safeSpeed and humanoid.MoveDirection.Magnitude > 0 then
        rootPart.CFrame += humanoid.MoveDirection * speedValue * dt * 3.8
    end
end)

-- Управление меню
local isMinimized = false
minBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    local targetSize = isMinimized and UDim2.new(0,410,0,72) or UDim2.new(0,410,0,720)
    TweenService:Create(mainFrame, TweenInfo.new(0.45, Enum.EasingStyle.Quint), {Size = targetSize}):Play()
    scrollFrame.Visible = not isMinimized
    minBtn.Text = isMinimized and "+" or "–"
end)

closeBtn.MouseButton1Click:Connect(function()
    screenGui.Enabled = false
end)

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then
        screenGui.Enabled = not screenGui.Enabled
    end
end)

StarterGui:SetCore("SendNotification", {
    Title = "MALOT v5.3 PERFECT",
    Text = "Теперь функции видны сразу! Меню двигается легко. RightShift — открыть.",
    Duration = 8
})

print("[MALOT] v5.3 PERFECT ЗАГРУЖЕН — всё должно быть идеально!")
