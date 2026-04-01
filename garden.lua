-- MALOT CHEAT SCRIPT v2.0 ИМБА — WAVE OF BRAINROTS
-- Полное бессмертие, супер-noclip, минимизация меню, safe super speed
-- Автор: MALOT — теперь ты буквально бог этой игры

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Основные переменные
local walkSpeedValue = 150
local jumpPowerValue = 250
local flySpeed = 80
local infiniteJumpEnabled = false
local flyEnabled = false
local noclipEnabled = false
local godModeEnabled = true
local safeSuperSpeed = true
local isMinimized = false

-- Авто-рестарт читов при респавне
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = newChar:WaitForChild("Humanoid")
    rootPart = newChar:WaitForChild("HumanoidRootPart")
    humanoid.WalkSpeed = walkSpeedValue
    humanoid.JumpPower = jumpPowerValue
end)

-- ==================== GUI ====================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MalotImbaMenu"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 580)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -290)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 45)
titleBar.BackgroundColor3 = Color3.fromRGB(255, 20, 60)
titleBar.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -110, 1, 0)
titleLabel.Position = UDim2.new(0, 15, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "MALOT ИМБА ЧИТ v2.0 — Wave of Brainrots"
titleLabel.TextColor3 = Color3.new(1,1,1)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBlack
titleLabel.Parent = titleBar

-- Кнопка минимизации
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 40, 0, 40)
minimizeBtn.Position = UDim2.new(1, -85, 0, 0)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
minimizeBtn.Text = "–"
minimizeBtn.TextColor3 = Color3.new(1,1,1)
minimizeBtn.TextScaled = true
minimizeBtn.Parent = titleBar

-- Кнопка полного закрытия
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 40, 0, 40)
closeBtn.Position = UDim2.new(1, -40, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.TextScaled = true
closeBtn.Parent = titleBar

-- Контент-фрейм (всё что сворачивается)
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, 0, 1, -45)
contentFrame.Position = UDim2.new(0, 0, 0, 45)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- WalkSpeed
local wsLabel = Instance.new("TextLabel")
wsLabel.Text = "Скорость бега:"
wsLabel.Position = UDim2.new(0, 20, 0, 15)
wsLabel.Size = UDim2.new(0, 200, 0, 30)
wsLabel.BackgroundTransparency = 1
wsLabel.TextColor3 = Color3.new(1,1,1)
wsLabel.Parent = contentFrame

local wsBox = Instance.new("TextBox")
wsBox.Text = tostring(walkSpeedValue)
wsBox.Position = UDim2.new(0, 230, 0, 15)
wsBox.Size = UDim2.new(0, 90, 0, 30)
wsBox.BackgroundColor3 = Color3.fromRGB(35,35,35)
wsBox.TextColor3 = Color3.new(1,1,1)
wsBox.Parent = contentFrame

local wsApply = Instance.new("TextButton")
wsApply.Text = "OK"
wsApply.Position = UDim2.new(0, 330, 0, 15)
wsApply.Size = UDim2.new(0, 40, 0, 30)
wsApply.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
wsApply.TextColor3 = Color3.new(1,1,1)
wsApply.Parent = contentFrame

-- JumpPower
local jpLabel = Instance.new("TextLabel")
jpLabel.Text = "Сила прыжка:"
jpLabel.Position = UDim2.new(0, 20, 0, 55)
jpLabel.Size = UDim2.new(0, 200, 0, 30)
jpLabel.BackgroundTransparency = 1
jpLabel.TextColor3 = Color3.new(1,1,1)
jpLabel.Parent = contentFrame

local jpBox = Instance.new("TextBox")
jpBox.Text = tostring(jumpPowerValue)
jpBox.Position = UDim2.new(0, 230, 0, 55)
jpBox.Size = UDim2.new(0, 90, 0, 30)
jpBox.BackgroundColor3 = Color3.fromRGB(35,35,35)
jpBox.TextColor3 = Color3.new(1,1,1)
jpBox.Parent = contentFrame

local jpApply = Instance.new("TextButton")
jpApply.Text = "OK"
jpApply.Position = UDim2.new(0, 330, 0, 55)
jpApply.Size = UDim2.new(0, 40, 0, 30)
jpApply.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
jpApply.TextColor3 = Color3.new(1,1,1)
jpApply.Parent = contentFrame

-- Тогглы
local function createToggle(text, yPos, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 360, 0, 40)
    frame.Position = UDim2.new(0, 20, 0, yPos)
    frame.BackgroundTransparency = 1
    frame.Parent = contentFrame

    local lbl = Instance.new("TextLabel")
    lbl.Text = text
    lbl.Size = UDim2.new(0, 220, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.new(1,1,1)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = frame

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 120, 1, 0)
    btn.Position = UDim2.new(0, 240, 0, 0)
    btn.BackgroundColor3 = default and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(90, 90, 90)
    btn.Text = default and "ВКЛ" or "ВЫКЛ"
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Parent = frame

    local state = default
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(90, 90, 90)
        btn.Text = state and "ВКЛ" or "ВЫКЛ"
        callback(state)
    end)
    return btn
end

createToggle("GodMode (бессмертие)", 105, true, function(v) godModeEnabled = v end)
createToggle("Infinite Jump", 155, false, function(v) infiniteJumpEnabled = v end)
createToggle("Fly (полёт)", 205, false, function(v) flyEnabled = v end)
createToggle("Noclip (сквозь стены)", 255, true, function(v) noclipEnabled = v end)
createToggle("Safe Super Speed", 305, true, function(v) safeSuperSpeed = v end)

-- Пресеты
local preset1 = Instance.new("TextButton")
preset1.Text = "СКОРОСТЬ 500"
preset1.Position = UDim2.new(0, 20, 0, 360)
preset1.Size = UDim2.new(0, 170, 0, 40)
preset1.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
preset1.TextColor3 = Color3.new(1,1,1)
preset1.Parent = contentFrame
preset1.MouseButton1Click:Connect(function()
    walkSpeedValue = 500
    wsBox.Text = "500"
end)

local preset2 = Instance.new("TextButton")
preset2.Text = "ПРЫЖОК 900"
preset2.Position = UDim2.new(0, 210, 0, 360)
preset2.Size = UDim2.new(0, 170, 0, 40)
preset2.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
preset2.TextColor3 = Color3.new(1,1,1)
preset2.Parent = contentFrame
preset2.MouseButton1Click:Connect(function()
    jumpPowerValue = 900
    jpBox.Text = "900"
end)

-- Логика минимизации
minimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    contentFrame.Visible = not isMinimized
    mainFrame.Size = isMinimized and UDim2.new(0, 400, 0, 45) or UDim2.new(0, 400, 0, 580)
    minimizeBtn.Text = isMinimized and "+" or "–"
end)

closeBtn.MouseButton1Click:Connect(function()
    screenGui.Enabled = false
end)

-- ==================== ЛОГИКА ЧИТОВ ====================
UserInputService.JumpRequest:Connect(function()
    if infiniteJumpEnabled and humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

local flyVel = nil
local noclipConnection = nil

RunService.Stepped:Connect(function()
    if not character or not humanoid then return end

    -- GodMode
    if godModeEnabled then
        humanoid.MaxHealth = 10000
        humanoid.Health = 10000
    end

    -- Применяем скорость и прыжок
    if humanoid.WalkSpeed ~= walkSpeedValue and not safeSuperSpeed then
        humanoid.WalkSpeed = walkSpeedValue
    end
    if humanoid.JumpPower ~= jumpPowerValue then
        humanoid.JumpPower = jumpPowerValue
    end

    -- Fly
    if flyEnabled then
        if not flyVel then
            flyVel = Instance.new("BodyVelocity")
            flyVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            flyVel.Parent = rootPart
        end
        local cam = workspace.CurrentCamera
        local dir = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir - Vector3.new(0,1,0) end
        flyVel.Velocity = dir.Unit * flySpeed
    elseif flyVel then
        flyVel:Destroy()
        flyVel = nil
    end

    -- Noclip (максимально надёжный)
    if noclipEnabled then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end

    -- Safe Super Speed (CFrame, чтобы не умирать)
    if safeSuperSpeed and humanoid.MoveDirection.Magnitude > 0 then
        local moveDir = humanoid.MoveDirection * walkSpeedValue * 0.035
        rootPart.CFrame = rootPart.CFrame + moveDir
    end
end)

-- Авто-фикс noclip при добавлении новых частей
character.DescendantAdded:Connect(function(desc)
    if noclipEnabled and desc:IsA("BasePart") then
        desc.CanCollide = false
    end
end)

-- Открытие меню
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        screenGui.Enabled = not screenGui.Enabled
    end
end)

-- Уведомление
StarterGui:SetCore("SendNotification", {
    Title = "MALOT ИМБА v2.0",
    Text = "Меню готово! RightShift — открыть. Теперь ты бессмертный бог!",
    Duration = 6
})

print("[MALOT] v2.0 ИМБА-ЧИТ ЗАГРУЖЕН — ты теперь неубиваемый!")
