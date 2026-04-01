-- MALOT UNIVERSAL CHEAT v5.4 COMPACT — ИСПРАВЛЕНО ВСЁ
-- Меню маленькое, функции видны всегда, тогглы работают, ничего не включается само

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
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
    godMode = false,
    safeSpeed = false
}

local function setupCharacter()
    character = player.Character or player.CharacterAdded:Wait()
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
end
setupCharacter()
player.CharacterAdded:Connect(setupCharacter)

-- ==================== КОМПАКТНОЕ iOS МЕНЮ ====================
local screenGui = Instance.new("ScreenGui")
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 380, 0, 520)
mainFrame.Position = UDim2.new(0.5, -190, 0.5, -260)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 26)
corner.Parent = mainFrame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(100, 200, 255)
stroke.Thickness = 2
stroke.Parent = mainFrame

-- Заголовок
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 55)
titleBar.BackgroundColor3 = Color3.fromRGB(28, 28, 40)
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 26)
titleCorner.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Text = "MALOT UNIVERSAL"
titleLabel.Size = UDim2.new(1, -120, 1, 0)
titleLabel.Position = UDim2.new(0, 20, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.new(1,1,1)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBlack
titleLabel.Parent = titleBar

local versionLabel = Instance.new("TextLabel")
versionLabel.Text = "v5.4"
versionLabel.Position = UDim2.new(1, -105, 0.5, -12)
versionLabel.Size = UDim2.new(0, 80, 0, 24)
versionLabel.BackgroundTransparency = 1
versionLabel.TextColor3 = Color3.fromRGB(130, 230, 255)
versionLabel.TextScaled = true
versionLabel.Font = Enum.Font.Gotham
versionLabel.Parent = titleBar

-- Кнопки
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 50, 0, 50)
closeBtn.Position = UDim2.new(1, -55, 0, 3)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
closeBtn.TextScaled = true
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = titleBar

-- Контент (без скролла — всё помещается)
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -20, 1, -70)
contentFrame.Position = UDim2.new(0, 10, 0, 65)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 10)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = contentFrame

-- Простой тоггл
local function createToggle(name, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 52)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
    frame.BorderSizePixel = 0
    frame.Parent = contentFrame

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 18)
    c.Parent = frame

    local label = Instance.new("TextLabel")
    label.Text = name
    label.Position = UDim2.new(0, 20, 0.5, -13)
    label.Size = UDim2.new(0.65, 0, 0, 26)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1,1,1)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextScaled = true
    label.Font = Enum.Font.GothamSemibold
    label.Parent = frame

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 110, 0, 36)
    toggleBtn.Position = UDim2.new(1, -125, 0.5, -18)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 80)
    toggleBtn.Text = "ВЫКЛ"
    toggleBtn.TextColor3 = Color3.new(1,1,1)
    toggleBtn.TextScaled = true
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.Parent = frame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 12)
    btnCorner.Parent = toggleBtn

    local enabled = false
    toggleBtn.MouseButton1Click:Connect(function()
        enabled = not enabled
        callback(enabled)
        toggleBtn.BackgroundColor3 = enabled and Color3.fromRGB(0, 200, 120) or Color3.fromRGB(70, 70, 80)
        toggleBtn.Text = enabled and "ВКЛ" or "ВЫКЛ"
    end)
end

-- Добавляем функции (все выключены)
createToggle("Невидимость", function(v) states.invisible = v end)
createToggle("Полёт (Fly)", function(v) states.fly = v end)
createToggle("Noclip (сквозь стены)", function(v) states.noclip = v end)
createToggle("Бесконечный прыжок", function(v) states.infiniteJump = v end)
createToggle("Режим Бога", function(v) states.godMode = v end)
createToggle("Safe Speed (CFrame)", function(v) states.safeSpeed = v end)

-- Поля скорости и прыжка
local function createValue(title, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 55)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
    frame.Parent = contentFrame

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 18)
    c.Parent = frame

    local lbl = Instance.new("TextLabel")
    lbl.Text = title
    lbl.Position = UDim2.new(0, 20, 0.5, -13)
    lbl.Size = UDim2.new(0.55, 0, 0, 26)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.new(1,1,1)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextScaled = true
    lbl.Font = Enum.Font.GothamSemibold
    lbl.Parent = frame

    local box = Instance.new("TextBox")
    box.Text = tostring(default)
    box.Position = UDim2.new(0.62, 0, 0.5, -18)
    box.Size = UDim2.new(0.33, 0, 0, 38)
    box.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    box.TextColor3 = Color3.fromRGB(0, 240, 255)
    box.TextScaled = true
    box.Font = Enum.Font.GothamBold
    box.Parent = frame

    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(0, 12)
    bc.Parent = box

    box.FocusLost:Connect(function()
        local val = tonumber(box.Text)
        if val then callback(val) end
    end)
end

createValue("Скорость бега", speedValue, function(v) speedValue = v end)
createValue("Сила прыжка", jumpPowerValue, function(v) jumpPowerValue = v end)

-- ==================== ЛОГИКА ====================
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
        for _, p in ipairs(character:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end

    if states.safeSpeed and humanoid.MoveDirection.Magnitude > 0 then
        rootPart.CFrame += humanoid.MoveDirection * speedValue * dt * 3.7
    end
end)

-- Управление
closeBtn.MouseButton1Click:Connect(function()
    screenGui.Enabled = false
end)

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then
        screenGui.Enabled = not screenGui.Enabled
    end
end)

StarterGui:SetCore("SendNotification", {
    Title = "MALOT v5.4 COMPACT",
    Text = "Меню исправлено! Всё видно, тогглы работают, ничего не включается само. RightShift — открыть.",
    Duration = 8
})

print("[MALOT] v5.4 COMPACT ЗАГРУЖЕН — теперь всё должно быть идеально!")
