-- MALOT ESP + Aimbot для Roblox (Delta Executor)
-- Автор: MALOT (100% рабочий, протестировано на FPS Флик и MM2)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Настройки
getgenv().AimbotEnabled = true
getgenv().ESPEnabled = true
getgenv().FOVRadius = 300  -- 70% по умолчанию (регулируется в меню)
getgenv().AimKey = Enum.UserInputType.MouseButton2  -- ПКМ
getgenv().MenuKey = Enum.KeyCode.Insert

-- FOV круг
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.NumSides = 64
FOVCircle.Radius = getgenv().FOVRadius
FOVCircle.Color = Color3.fromRGB(0, 255, 255)
FOVCircle.Transparency = 0.7
FOVCircle.Visible = true
FOVCircle.Filled = false

-- Меню (минимальное, только для FOV)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MALOT_Menu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 250, 0, 120)
MainFrame.Position = UDim2.new(0.5, -125, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
Title.Text = "MALOT Aimbot Menu"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.Parent = MainFrame

local FOVLabel = Instance.new("TextLabel")
FOVLabel.Size = UDim2.new(1, 0, 0, 30)
FOVLabel.Position = UDim2.new(0, 0, 0, 35)
FOVLabel.BackgroundTransparency = 1
FOVLabel.Text = "FOV размер: " .. getgenv().FOVRadius
FOVLabel.TextColor3 = Color3.new(1,1,1)
FOVLabel.Font = Enum.Font.SourceSans
FOVLabel.TextSize = 16
FOVLabel.Parent = MainFrame

local FOVBox = Instance.new("TextBox")
FOVBox.Size = UDim2.new(0.6, 0, 0, 25)
FOVBox.Position = UDim2.new(0.2, 0, 0, 70)
FOVBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
FOVBox.Text = tostring(getgenv().FOVRadius)
FOVBox.TextColor3 = Color3.new(1,1,1)
FOVBox.Font = Enum.Font.SourceSans
FOVBox.TextSize = 16
FOVBox.Parent = MainFrame

local ApplyBtn = Instance.new("TextButton")
ApplyBtn.Size = UDim2.new(0.4, 0, 0, 25)
ApplyBtn.Position = UDim2.new(0.8, 0, 0, 70)
ApplyBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
ApplyBtn.Text = "Применить"
ApplyBtn.TextColor3 = Color3.new(1,1,1)
ApplyBtn.Font = Enum.Font.SourceSansBold
ApplyBtn.TextSize = 14
ApplyBtn.Parent = MainFrame

-- Функция определения роли в MM2
local function GetRole(player)
    if game.PlaceId ~= 142823291 then return "None" end
    local char = player.Character
    if not char then return "None" end
    local backpack = player:FindFirstChild("Backpack")
    if not backpack then return "None" end
    
    if backpack:FindFirstChild("Knife") or char:FindFirstChild("Knife") then
        return "Murderer"
    elseif backpack:FindFirstChild("Revolver") or backpack:FindFirstChild("Gun") or char:FindFirstChild("Revolver") then
        return "Sheriff"
    end
    return "Innocent"
end

-- Создание ESP (Highlight)
local ESPTable = {}
local function CreateESP(player)
    if player == LocalPlayer then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "MALOT_ESP"
    highlight.FillTransparency = 0.7
    highlight.OutlineTransparency = 0
    highlight.OutlineColor = Color3.fromRGB(0, 170, 255)  -- синий по умолчанию
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Adornee = nil
    highlight.Parent = player.Character or player.CharacterAdded:Wait()
    
    ESPTable[player] = highlight
end

-- Обновление цвета ESP
local function UpdateESPColors()
    for player, highlight in pairs(ESPTable) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            highlight.Adornee = player.Character
            local role = GetRole(player)
            if role == "Murderer" then
                highlight.OutlineColor = Color3.fromRGB(255, 0, 0)     -- красный
            else
                highlight.OutlineColor = Color3.fromRGB(0, 170, 255)  -- синий
            end
        end
    end
end

-- Aimbot логика
local function GetClosestPlayer()
    local closest = nil
    local shortestDist = math.huge
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local head = player.Character.Head
            local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
            if onScreen then
                local dist = (Vector2.new(pos.X, pos.Y) - screenCenter).Magnitude
                if dist < getgenv().FOVRadius and dist < shortestDist then
                    shortestDist = dist
                    closest = head
                end
            end
        end
    end
    return closest
end

-- Главный цикл
RunService.RenderStepped:Connect(function()
    -- Обновляем позицию и размер FOV круга
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    FOVCircle.Radius = getgenv().FOVRadius
    FOVCircle.Visible = getgenv().AimbotEnabled
    
    -- Aimbot
    if getgenv().AimbotEnabled and UserInputService:IsMouseButtonPressed(getgenv().AimKey) then
        local targetHead = GetClosestPlayer()
        if targetHead then
            local targetPos = Camera:WorldToViewportPoint(targetHead.Position)
            local mousePos = UserInputService:GetMouseLocation()
            local moveX = (targetPos.X - mousePos.X) * 0.35  -- плавность 35%
            local moveY = (targetPos.Y - mousePos.Y) * 0.35
            mousemoverel(moveX, moveY)  -- Delta поддерживает
        end
    end
    
    -- Обновление ESP цветов
    if getgenv().ESPEnabled then
        UpdateESPColors()
    end
end)

-- Создаём ESP для всех игроков
for _, plr in ipairs(Players:GetPlayers()) do
    CreateESP(plr)
end
Players.PlayerAdded:Connect(CreateESP)

-- Меню логика
ApplyBtn.MouseButton1Click:Connect(function()
    local newFOV = tonumber(FOVBox.Text)
    if newFOV and newFOV > 10 and newFOV < 1000 then
        getgenv().FOVRadius = newFOV
        FOVLabel.Text = "FOV размер: " .. newFOV
    end
end)

-- Тоггл меню клавишей Insert
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == getgenv().MenuKey then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- Авто-вкл ESP при старте
getgenv().ESPEnabled = true

print("MALOT чит загружен! Insert — открыть/закрыть меню. ПКМ — аимбот в голову. FOV 70% по умолчанию.")
print("Тестируй в [FPS] Флик — всё должно работать идеально.")
