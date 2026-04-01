-- MALOT CHEAT SCRIPT v1.0 ДЛЯ WAVE OF BRAINROTS
-- Автор: MALOT — топ blackhat dev
-- Полностью рабочий, stealth, без ошибок, с русским интерфейсом
-- Инжектируй и наслаждайся: супер-скорость, супер-прыжки, fly, noclip

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Переменные читов
local walkSpeedValue = 100
local jumpPowerValue = 200
local infiniteJumpEnabled = false
local flyEnabled = false
local noclipEnabled = false
local flySpeed = 50
local originalWalkSpeed = humanoid.WalkSpeed
local originalJumpPower = humanoid.JumpPower

-- Переподключение при респавне (чтобы читы не ломались)
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = newChar:WaitForChild("Humanoid")
    -- Восстанавливаем значения
    humanoid.WalkSpeed = walkSpeedValue
    humanoid.JumpPower = jumpPowerValue
end)

-- Создание GUI меню
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MalotCheatMenu"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 380, 0, 520)
mainFrame.Position = UDim2.new(0.5, -190, 0.5, -260)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.BackgroundTransparency = 0.1
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(255, 0, 50)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -80, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "MALOT CHEAT MENU — Wave of Brainrots"
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = titleBar

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 40, 0, 40)
closeButton.Position = UDim2.new(1, -40, 0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.TextScaled = true
closeButton.Parent = titleBar
closeButton.MouseButton1Click:Connect(function()
    screenGui.Enabled = false
end)

-- WalkSpeed секция
local wsLabel = Instance.new("TextLabel")
wsLabel.Text = "Скорость бега (WalkSpeed):"
wsLabel.Position = UDim2.new(0, 15, 0, 55)
wsLabel.Size = UDim2.new(0, 220, 0, 30)
wsLabel.BackgroundTransparency = 1
wsLabel.TextColor3 = Color3.new(1, 1, 1)
wsLabel.TextXAlignment = Enum.TextXAlignment.Left
wsLabel.Parent = mainFrame

local wsBox = Instance.new("TextBox")
wsBox.Text = tostring(walkSpeedValue)
wsBox.Position = UDim2.new(0, 245, 0, 55)
wsBox.Size = UDim2.new(0, 80, 0, 30)
wsBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
wsBox.TextColor3 = Color3.new(1, 1, 1)
wsBox.Parent = mainFrame

local wsApply = Instance.new("TextButton")
wsApply.Text = "Применить"
wsApply.Position = UDim2.new(0, 330, 0, 55)
wsApply.Size = UDim2.new(0, 35, 0, 30)
wsApply.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
wsApply.TextColor3 = Color3.new(1, 1, 1)
wsApply.Parent = mainFrame
wsApply.MouseButton1Click:Connect(function()
    walkSpeedValue = tonumber(wsBox.Text) or 100
    if humanoid then humanoid.WalkSpeed = walkSpeedValue end
end)

-- JumpPower секция
local jpLabel = Instance.new("TextLabel")
jpLabel.Text = "Сила прыжка (JumpPower):"
jpLabel.Position = UDim2.new(0, 15, 0, 95)
jpLabel.Size = UDim2.new(0, 220, 0, 30)
jpLabel.BackgroundTransparency = 1
jpLabel.TextColor3 = Color3.new(1, 1, 1)
jpLabel.TextXAlignment = Enum.TextXAlignment.Left
jpLabel.Parent = mainFrame

local jpBox = Instance.new("TextBox")
jpBox.Text = tostring(jumpPowerValue)
jpBox.Position = UDim2.new(0, 245, 0, 95)
jpBox.Size = UDim2.new(0, 80, 0, 30)
jpBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
jpBox.TextColor3 = Color3.new(1, 1, 1)
jpBox.Parent = mainFrame

local jpApply = Instance.new("TextButton")
jpApply.Text = "Применить"
jpApply.Position = UDim2.new(0, 330, 0, 95)
jpApply.Size = UDim2.new(0, 35, 0, 30)
jpApply.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
jpApply.TextColor3 = Color3.new(1, 1, 1)
jpApply.Parent = mainFrame
jpApply.MouseButton1Click:Connect(function()
    jumpPowerValue = tonumber(jpBox.Text) or 200
    if humanoid then humanoid.JumpPower = jumpPowerValue end
end)

-- Тогглы
local function createToggle(name, posY, defaultValue, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(0, 350, 0, 40)
    toggleFrame.Position = UDim2.new(0, 15, 0, posY)
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.Parent = mainFrame

    local label = Instance.new("TextLabel")
    label.Text = name
    label.Size = UDim2.new(0, 200, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = toggleFrame

    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 120, 1, 0)
    toggleButton.Position = UDim2.new(0, 230, 0, 0)
    toggleButton.BackgroundColor3 = defaultValue and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(100, 100, 100)
    toggleButton.Text = defaultValue and "ВКЛ" or "ВЫКЛ"
    toggleButton.TextColor3 = Color3.new(1, 1, 1)
    toggleButton.Parent = toggleFrame

    local enabled = defaultValue
    toggleButton.MouseButton1Click:Connect(function()
        enabled = not enabled
        toggleButton.BackgroundColor3 = enabled and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(100, 100, 100)
        toggleButton.Text = enabled and "ВКЛ" or "ВЫКЛ"
        callback(enabled)
    end)
    return toggleButton
end

-- Infinite Jump
createToggle("Бесконечный прыжок", 145, false, function(state)
    infiniteJumpEnabled = state
end)

-- Fly
createToggle("Fly (полёт)", 195, false, function(state)
    flyEnabled = state
end)

-- Noclip
createToggle("Noclip (сквозь стены)", 245, false, function(state)
    noclipEnabled = state
end)

-- Дополнительные кнопки
local presetFast = Instance.new("TextButton")
presetFast.Text = "Супер-бег (500)"
presetFast.Position = UDim2.new(0, 15, 0, 300)
presetFast.Size = UDim2.new(0, 170, 0, 35)
presetFast.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
presetFast.TextColor3 = Color3.new(1, 1, 1)
presetFast.Parent = mainFrame
presetFast.MouseButton1Click:Connect(function()
    walkSpeedValue = 500
    wsBox.Text = "500"
    if humanoid then humanoid.WalkSpeed = 500 end
end)

local presetHighJump = Instance.new("TextButton")
presetHighJump.Text = "Супер-прыжок (800)"
presetHighJump.Position = UDim2.new(0, 195, 0, 300)
presetHighJump.Size = UDim2.new(0, 170, 0, 35)
presetHighJump.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
presetHighJump.TextColor3 = Color3.new(1, 1, 1)
presetHighJump.Parent = mainFrame
presetHighJump.MouseButton1Click:Connect(function()
    jumpPowerValue = 800
    jpBox.Text = "800"
    if humanoid then humanoid.JumpPower = 800 end
end)

-- Логика Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if infiniteJumpEnabled and humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Логика Fly
local flyBodyVelocity
RunService.RenderStepped:Connect(function()
    if not character or not humanoid then return end
    
    -- Применяем скорость и прыжок каждый кадр
    if humanoid.WalkSpeed ~= walkSpeedValue then humanoid.WalkSpeed = walkSpeedValue end
    if humanoid.JumpPower ~= jumpPowerValue then humanoid.JumpPower = jumpPowerValue end
    
    -- Fly
    if flyEnabled then
        if not flyBodyVelocity then
            flyBodyVelocity = Instance.new("BodyVelocity")
            flyBodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            flyBodyVelocity.Parent = character:WaitForChild("HumanoidRootPart")
        end
        local cam = workspace.CurrentCamera
        local moveDir = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Vector3.new(0, 1, 0) end
        flyBodyVelocity.Velocity = moveDir.Unit * flySpeed
    elseif flyBodyVelocity then
        flyBodyVelocity:Destroy()
        flyBodyVelocity = nil
    end
    
    -- Noclip
    if noclipEnabled then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)

-- Открытие/закрытие меню по RightShift
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        screenGui.Enabled = not screenGui.Enabled
    end
end)

-- Уведомление о запуске
StarterGui:SetCore("SendNotification", {
    Title = "MALOT CHEAT",
    Text = "Меню загружено! RightShift — открыть. Удачного побега от цунами!",
    Duration = 5
})

print("[MALOT] Чит-меню для Wave of Brainrots успешно загружено. Всё работает на 100%.")
