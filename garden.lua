-- MALOT TROLL SCRIPT v1.0 ДЛЯ BROOKHAVEN — ПОЛНЫЙ ТРОЛЛИНГ 2026
-- Невидимость + fly + noclip + annoy + fake death и т.д.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")

local invisible = false
local flyEnabled = false
local noclipEnabled = false
local infiniteJump = false
local superSpeed = 120
local annoyEnabled = false
local fakeDead = false

-- Авто-реаттач
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = newChar:WaitForChild("Humanoid")
    root = newChar:WaitForChild("HumanoidRootPart")
end)

-- ==================== GUI ====================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MalotTrollBrookhaven"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 380, 0, 520)
mainFrame.Position = UDim2.new(0.5, -190, 0.5, -260)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local title = Instance.new("Frame")
title.Size = UDim2.new(1,0,0,45)
title.BackgroundColor3 = Color3.fromRGB(255, 0, 100)
title.Parent = mainFrame

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1,-90,1,0)
titleText.Position = UDim2.new(0,15,0,0)
titleText.BackgroundTransparency = 1
titleText.Text = "MALOT ТРОЛЛЬ v1.0 — BROOKHAVEN"
titleText.TextColor3 = Color3.new(1,1,1)
titleText.TextScaled = true
titleText.Font = Enum.Font.GothamBlack
titleText.Parent = title

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0,40,0,40)
minBtn.Position = UDim2.new(1,-85,0,0)
minBtn.BackgroundColor3 = Color3.fromRGB(0,200,0)
minBtn.Text = "–"
minBtn.TextColor3 = Color3.new(1,1,1)
minBtn.Parent = title

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0,40,0,40)
closeBtn.Position = UDim2.new(1,-40,0,0)
closeBtn.BackgroundColor3 = Color3.fromRGB(200,0,0)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Parent = title

local content = Instance.new("Frame")
content.Size = UDim2.new(1,0,1,-45)
content.Position = UDim2.new(0,0,0,45)
content.BackgroundTransparency = 1
content.Parent = mainFrame

-- Функция тоггла
local function addToggle(txt, y, default, callback)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(0,340,0,40)
    f.Position = UDim2.new(0,20,0,y)
    f.BackgroundTransparency = 1
    f.Parent = content

    local lbl = Instance.new("TextLabel")
    lbl.Text = txt
    lbl.Size = UDim2.new(0,200,1,0)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.new(1,1,1)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = f

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0,120,1,0)
    btn.Position = UDim2.new(0,220,0,0)
    btn.BackgroundColor3 = default and Color3.fromRGB(0,200,0) or Color3.fromRGB(80,80,80)
    btn.Text = default and "ВКЛ" or "ВЫКЛ"
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Parent = f

    local state = default
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(0,200,0) or Color3.fromRGB(80,80,80)
        btn.Text = state and "ВКЛ" or "ВЫКЛ"
        callback(state)
    end)
end

addToggle("Полная Невидимость", 20, false, function(v) invisible = v end)
addToggle("Fly (полёт)", 70, false, function(v) flyEnabled = v end)
addToggle("Noclip (сквозь всё)", 120, false, function(v) noclipEnabled = v end)
addToggle("Бесконечный прыжок", 170, false, function(v) infiniteJump = v end)
addToggle("Annoy Mode (толкать игроков)", 220, false, function(v) annoyEnabled = v end)
addToggle("Fake Dead (притвориться мёртвым)", 270, false, function(v) fakeDead = v end)

-- Пресет супер скорости
local speedBtn = Instance.new("TextButton")
speedBtn.Text = "Супер скорость 300"
speedBtn.Position = UDim2.new(0,20,0,330)
speedBtn.Size = UDim2.new(0,340,0,40)
speedBtn.BackgroundColor3 = Color3.fromRGB(255,100,0)
speedBtn.TextColor3 = Color3.new(1,1,1)
speedBtn.Parent = content
speedBtn.MouseButton1Click:Connect(function()
    superSpeed = 300
end)

-- Логика невидимости (самая мощная версия 2026)
local function setInvisible(state)
    if not character then return end
    for _, v in ipairs(character:GetDescendants()) do
        if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
            v.Transparency = state and 1 or 0
        elseif v:IsA("Decal") or v:IsA("Texture") then
            v.Transparency = state and 1 or 0
        end
    end
    if character:FindFirstChild("Head") and character.Head:FindFirstChild("face") then
        character.Head.face.Transparency = state and 1 or 0
    end
    -- Скрываем имя и чат
    if player:FindFirstChild("PlayerGui") then
        for _, gui in ipairs(player.PlayerGui:GetDescendants()) do
            if gui:IsA("BillboardGui") or gui.Name == "NameGui" then
                gui.Enabled = not state
            end
        end
    end
end

-- Главный loop
RunService.RenderStepped:Connect(function()
    if not character or not root then return end

    -- Невидимость
    if invisible then
        setInvisible(true)
    else
        setInvisible(false)
    end

    -- Fly
    if flyEnabled then
        local dir = Vector3.new(0,0,0)
        local cam = workspace.CurrentCamera.CFrame
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir - Vector3.new(0,1,0) end
        root.CFrame = root.CFrame + dir.Unit * 2
        root.Velocity = Vector3.new(0,0,0)
    end

    -- Noclip
    if noclipEnabled then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end

    -- Annoy mode (толкаем ближайшего)
    if annoyEnabled then
        local closest = nil
        local minDist = math.huge
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (plr.Character.HumanoidRootPart.Position - root.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    closest = plr.Character.HumanoidRootPart
                end
            end
        end
        if closest and minDist < 30 then
            closest.Velocity = (closest.Position - root.Position).Unit * 150
        end
    end

    -- Fake Dead
    if fakeDead and humanoid then
        humanoid.PlatformStand = true
        humanoid:ChangeState(Enum.HumanoidStateType.Physics)
    elseif humanoid then
        humanoid.PlatformStand = false
    end

    -- Супер скорость
    if humanoid then
        humanoid.WalkSpeed = superSpeed
    end
end)

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if infiniteJump and humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Управление меню
minBtn.MouseButton1Click:Connect(function()
    content.Visible = not content.Visible
    mainFrame.Size = content.Visible and UDim2.new(0,380,0,520) or UDim2.new(0,380,0,45)
    minBtn.Text = content.Visible and "–" or "+"
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
    Title = "MALOT ТРОЛЛЬ v1.0",
    Text = "Brookhaven готов к троллингу! RightShift — меню. Становись невидимым и беси всех!",
    Duration = 8
})

print("[MALOT] Троллинг-скрипт для Brookhaven загружен. Удачного троллинга!")
