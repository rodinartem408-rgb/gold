-- MALOT UNIVERSAL CHEAT v5.0 iOS STYLE — КРАСИВОЕ МЕНЮ КАК НА iPHONE
-- Невидимость + Fly + Speed + Noclip + Infinite Jump + God Mode

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
local flySpeed = 75

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

-- ==================== iOS СТИЛЬ GUI ====================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MalotIOSUniversal"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 380, 0, 620)
mainFrame.Position = UDim2.new(0.5, -190, 0.5, -310)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
mainFrame.BorderSizePixel = 0
mainFrame.BackgroundTransparency = 0.05
mainFrame.ClipsDescendants = true
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Blur эффект (стекло как в iOS)
local blurCorner = Instance.new("UICorner")
blurCorner.CornerRadius = UDim.new(0, 28)
blurCorner.Parent = mainFrame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(100, 200, 255)
stroke.Thickness = 1.5
stroke.Transparency = 0.6
stroke.Parent = mainFrame

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 60)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 28)
titleCorner.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -120, 1, 0)
titleLabel.Position = UDim2.new(0, 25, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "MALOT UNIVERSAL"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBlack
titleLabel.Parent = titleBar

local versionLabel = Instance.new("TextLabel")
versionLabel.Text = "v5.0 iOS"
versionLabel.Position = UDim2.new(1, -110, 0, 18)
versionLabel.Size = UDim2.new(0, 80, 0, 20)
versionLabel.BackgroundTransparency = 1
versionLabel.TextColor3 = Color3.fromRGB(150, 220, 255)
versionLabel.TextScaled = true
versionLabel.Font = Enum.Font.Gotham
versionLabel.Parent = titleBar

-- Кнопки управления
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 50, 0, 50)
minBtn.Position = UDim2.new(1, -105, 0, 5)
minBtn.BackgroundTransparency = 1
minBtn.Text = "–"
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.TextScaled = true
minBtn.Font = Enum.Font.GothamBold
minBtn.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 50, 0, 50)
closeBtn.Position = UDim2.new(1, -50, 0, 5)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
closeBtn.TextScaled = true
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = titleBar

local content = Instance.new("ScrollingFrame")
content.Size = UDim2.new(1, -20, 1, -80)
content.Position = UDim2.new(0, 10, 0, 70)
content.BackgroundTransparency = 1
content.ScrollBarThickness = 4
content.ScrollBarImageColor3 = Color3.fromRGB(100, 200, 255)
content.CanvasSize = UDim2.new(0, 0, 0, 680)
content.Parent = mainFrame

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 12)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = content

-- Функция создания стильного тоггла iOS
local function createIOSToggle(name, default, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, -20, 0, 70)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    toggleFrame.BorderSizePixel = 0
    toggleFrame.Parent = content

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 18)
    corner.Parent = toggleFrame

    local stroke2 = Instance.new("UIStroke")
    stroke2.Color = Color3.fromRGB(80, 180, 255)
    stroke2.Thickness = 1
    stroke2.Transparency = 0.7
    stroke2.Parent = toggleFrame

    local label = Instance.new("TextLabel")
    label.Text = name
    label.Position = UDim2.new(0, 25, 0.5, -12)
    label.Size = UDim2.new(0.6, 0, 0, 24)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1,1,1)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextScaled = true
    label.Font = Enum.Font.GothamSemibold
    label.Parent = toggleFrame

    local switch = Instance.new("Frame")
    switch.Size = UDim2.new(0, 52, 0, 32)
    switch.Position = UDim2.new(1, -75, 0.5, -16)
    switch.BackgroundColor3 = default and Color3.fromRGB(0, 200, 120) or Color3.fromRGB(80, 80, 90)
    switch.Parent = toggleFrame

    local switchCorner = Instance.new("UICorner")
    switchCorner.CornerRadius = UDim.new(1, 0)
    switchCorner.Parent = switch

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 26, 0, 26)
    knob.Position = default and UDim2.new(1, -30, 0.5, -13) or UDim2.new(0, 3, 0.5, -13)
    knob.BackgroundColor3 = Color3.new(1,1,1)
    knob.Parent = switch

    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob

    local enabled = default
    switch.MouseButton1Click:Connect(function()
        enabled = not enabled
        callback(enabled)

        local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quint)
        TweenService:Create(switch, tweenInfo, {BackgroundColor3 = enabled and Color3.fromRGB(0, 200, 120) or Color3.fromRGB(80, 80, 90)}):Play()
        TweenService:Create(knob, tweenInfo, {Position = enabled and UDim2.new(1, -30, 0.5, -13) or UDim2.new(0, 3, 0.5, -13)}):Play()
    end)
end

-- Создаём тогглы в iOS стиле
createIOSToggle("Невидимость", false, function(v) states.invisible = v end)
createIOSToggle("Полёт (Fly)", false, function(v) states.fly = v end)
createIOSToggle("Noclip (сквозь стены)", false, function(v) states.noclip = v end)
createIOSToggle("Бесконечный прыжок", false, function(v) states.infiniteJump = v end)
createIOSToggle("Режим Бога", true, function(v) states.godMode = v end)
createIOSToggle("Safe CFrame Speed", true, function(v) states.safeSpeed = v end)

-- Скорость и прыжок с красивыми полями
local function createValueInput(title, default, yOffset, onChange)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 80)
    frame.Position = UDim2.new(0, 10, 0, yOffset)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    frame.Parent = content

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 18)
    corner.Parent = frame

    local lbl = Instance.new("TextLabel")
    lbl.Text = title
    lbl.Position = UDim2.new(0, 25, 0, 12)
    lbl.Size = UDim2.new(0.6, 0, 0, 25)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.new(1,1,1)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextScaled = true
    lbl.Font = Enum.Font.GothamSemibold
    lbl.Parent = frame

    local box = Instance.new("TextBox")
    box.Text = tostring(default)
    box.Position = UDim2.new(0.65, 0, 0.5, -18)
    box.Size = UDim2.new(0.3, 0, 0, 36)
    box.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    box.TextColor3 = Color3.fromRGB(0, 220, 255)
    box.TextScaled = true
    box.Font = Enum.Font.GothamBold
    box.Parent = frame

    local boxCorner = Instance.new("UICorner")
    boxCorner.CornerRadius = UDim.new(0, 12)
    boxCorner.Parent = box

    box.FocusLost:Connect(function()
        local val = tonumber(box.Text)
        if val then onChange(val) end
    end)
end

createValueInput("Скорость бега", speedValue, 520, function(v) speedValue = v end)
createValueInput("Сила прыжка", jumpPowerValue, 610, function(v) jumpPowerValue = v end)

-- Логика читов (та же, что в v4, но чуть оптимизирована)
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
        for _, v in ipairs(character:GetDescendants()) do
            if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then v.Transparency = 1
            elseif v:IsA("Decal") or v:IsA("Texture") then v.Transparency = 1 end
        end
    else
        for _, v in ipairs(character:GetDescendants()) do
            if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then v.Transparency = 0
            elseif v:IsA("Decal") or v:IsA("Texture") then v.Transparency = 0 end
        end
    end

    -- Fly
    if states.fly then
        if not flyVel then
            flyVel = Instance.new("BodyVelocity")
            flyVel.MaxForce = Vector3.new(4000,4000,4000)
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
        local move = humanoid.MoveDirection * speedValue * dt * 3.5
        rootPart.CFrame += move
    end
end)

-- Управление меню
local minimized = false
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    local targetSize = minimized and UDim2.new(0,380,0,60) or UDim2.new(0,380,0,620)
    TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {Size = targetSize}):Play()
    content.Visible = not minimized
    minBtn.Text = minimized and "＋" or "–"
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
    Title = "MALOT iOS v5.0",
    Text = "Красивое меню загружено! RightShift для открытия. Наслаждайся премиум-дизайном!",
    Duration = 6
})

print("[MALOT] UNIVERSAL v5.0 iOS STYLE ЗАГРУЖЕН — теперь меню выглядит как топовое приложение!")
