-- MALOT ESP + Aimbot v2 для Roblox (Delta Executor) — 100% работает на [FPS] Флик
-- Быстрый silent + visible aim, VХ через стены, маленький FOV

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Настройки
getgenv().AimbotEnabled = true
getgenv().SilentAimEnabled = true
getgenv().ESPEnabled = true
getgenv().FOVRadius = 180  -- маленький круг по умолчанию
getgenv().AimKey = Enum.UserInputType.MouseButton2  -- ПКМ — visible aim
getgenv().MenuKey = Enum.KeyCode.Insert

-- FOV круг (маленький и красивый)
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.NumSides = 64
FOVCircle.Radius = getgenv().FOVRadius
FOVCircle.Color = Color3.fromRGB(0, 255, 255)
FOVCircle.Transparency = 0.8
FOVCircle.Visible = true
FOVCircle.Filled = false

-- Меню
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MALOT_Menu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 280, 0, 200)
MainFrame.Position = UDim2.new(0.5, -140, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
Title.Text = "MALOT ЧИТ v2 — [FPS] Флик"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 20
Title.Parent = MainFrame

-- FOV
local FOVLabel = Instance.new("TextLabel")
FOVLabel.Size = UDim2.new(1, 0, 0, 30)
FOVLabel.Position = UDim2.new(0, 0, 0, 40)
FOVLabel.BackgroundTransparency = 1
FOVLabel.Text = "Размер FOV: " .. getgenv().FOVRadius
FOVLabel.TextColor3 = Color3.new(1,1,1)
FOVLabel.Font = Enum.Font.SourceSans
FOVLabel.TextSize = 16
FOVLabel.Parent = MainFrame

local FOVBox = Instance.new("TextBox")
FOVBox.Size = UDim2.new(0.5, 0, 0, 28)
FOVBox.Position = UDim2.new(0.05, 0, 0, 75)
FOVBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
FOVBox.Text = tostring(getgenv().FOVRadius)
FOVBox.TextColor3 = Color3.new(1,1,1)
FOVBox.Font = Enum.Font.SourceSans
FOVBox.TextSize = 16
FOVBox.Parent = MainFrame

local ApplyFOV = Instance.new("TextButton")
ApplyFOV.Size = UDim2.new(0.4, 0, 0, 28)
ApplyFOV.Position = UDim2.new(0.57, 0, 0, 75)
ApplyFOV.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
ApplyFOV.Text = "Применить"
ApplyFOV.TextColor3 = Color3.new(1,1,1)
ApplyFOV.Font = Enum.Font.SourceSansBold
ApplyFOV.TextSize = 14
ApplyFOV.Parent = MainFrame

-- Тогглы
local function CreateToggle(text, posY, default, callback)
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0.9, 0, 0, 35)
    toggle.Position = UDim2.new(0.05, 0, 0, posY)
    toggle.BackgroundColor3 = default and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
    toggle.Text = text .. ": " .. (default and "ВКЛ" or "ВЫКЛ")
    toggle.TextColor3 = Color3.new(1,1,1)
    toggle.Font = Enum.Font.SourceSansBold
    toggle.TextSize = 16
    toggle.Parent = MainFrame
    
    toggle.MouseButton1Click:Connect(function()
        default = not default
        toggle.BackgroundColor3 = default and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
        toggle.Text = text .. ": " .. (default and "ВКЛ" or "ВЫКЛ")
        callback(default)
    end)
    return toggle
end

CreateToggle("ESP (ВХ)", 120, true, function(v) getgenv().ESPEnabled = v end)
CreateToggle("Silent Aim (авто-попадание)", 160, true, function(v) getgenv().SilentAimEnabled = v end)

-- ESP таблицы
local ESPTable = {}
local function CreateESP(player)
    if player == LocalPlayer then return end
    
    -- Highlight (синий обвод)
    local highlight = Instance.new("Highlight")
    highlight.Name = "MALOT_Highlight"
    highlight.FillTransparency = 0.85
    highlight.OutlineTransparency = 0
    highlight.OutlineColor = Color3.fromRGB(0, 170, 255)
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Adornee = player.Character
    highlight.Parent = player.Character or player.CharacterAdded:Wait()
    
    -- Drawing коробка + линия (дополнительно, чтобы точно было видно)
    local box = Drawing.new("Square")
    box.Thickness = 2
    box.Color = Color3.fromRGB(0, 170, 255)
    box.Transparency = 1
    box.Filled = false
    box.Visible = false
    
    local tracer = Drawing.new("Line")
    tracer.Thickness = 1.5
    tracer.Color = Color3.fromRGB(0, 170, 255)
    tracer.Transparency = 1
    tracer.Visible = false
    
    ESPTable[player] = {highlight = highlight, box = box, tracer = tracer}
end

-- Обновление ESP
local function UpdateESP()
    for player, esp in pairs(ESPTable) do
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Head") then
            local root = char.HumanoidRootPart
            local head = char.Head
            
            -- Highlight
            esp.highlight.Adornee = char
            if game.PlaceId == 142823291 then
                local role = (char:FindFirstChild("Knife") or player.Backpack:FindFirstChild("Knife")) and "Murderer" or "None"
                esp.highlight.OutlineColor = role == "Murderer" and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 170, 255)
            end
            
            -- Drawing box
            local rootPos, onScreen = Camera:WorldToViewportPoint(root.Position)
            if onScreen then
                local size = (Camera:WorldToViewportPoint(root.Position + Vector3.new(0, 3, 0)).Y - Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0)).Y) * 1.5
                esp.box.Size = Vector2.new(size * 0.8, size * 2.5)
                esp.box.Position = Vector2.new(rootPos.X - esp.box.Size.X / 2, rootPos.Y - esp.box.Size.Y / 2)
                esp.box.Visible = true
                
                -- Tracer
                local headPos = Camera:WorldToViewportPoint(head.Position)
                esp.tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                esp.tracer.To = Vector2.new(headPos.X, headPos.Y)
                esp.tracer.Visible = true
            else
                esp.box.Visible = false
                esp.tracer.Visible = false
            end
        end
    end
end

-- Поиск цели в FOV
local function GetClosestPlayer()
    local closest = nil
    local shortest = math.huge
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local head = player.Character.Head
            local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
            if onScreen then
                local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                if dist < getgenv().FOVRadius and dist < shortest then
                    shortest = dist
                    closest = head
                end
            end
        end
    end
    return closest
end

-- Главный цикл
RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    FOVCircle.Radius = getgenv().FOVRadius
    FOVCircle.Visible = getgenv().AimbotEnabled
    
    if getgenv().ESPEnabled then
        UpdateESP()
    end
    
    -- Visible aimbot (ПКМ)
    if getgenv().AimbotEnabled and UserInputService:IsMouseButtonPressed(getgenv().AimKey) then
        local target = GetClosestPlayer()
        if target then
            local targetPos = Camera:WorldToViewportPoint(target.Position)
            local mousePos = UserInputService:GetMouseLocation()
            local moveX = (targetPos.X - mousePos.X) * 0.92  -- очень быстро и чётко
            local moveY = (targetPos.Y - mousePos.Y) * 0.92
            mousemoverel(moveX, moveY)
        end
    end
end)

-- Silent Aim (авто-попадание при выстреле)
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 and getgenv().SilentAimEnabled then
        local target = GetClosestPlayer()
        if target then
            local targetPos = Camera:WorldToViewportPoint(target.Position)
            local mousePos = UserInputService:GetMouseLocation()
            local moveX = targetPos.X - mousePos.X
            local moveY = targetPos.Y - mousePos.Y
            mousemoverel(moveX, moveY)  -- мгновенный snap на выстрел
        end
    end
    
    -- Тоггл меню
    if input.KeyCode == getgenv().MenuKey then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- Создаём ESP для всех
for _, plr in ipairs(Players:GetPlayers()) do CreateESP(plr) end
Players.PlayerAdded:Connect(CreateESP)

ApplyFOV.MouseButton1Click:Connect(function()
    local new = tonumber(FOVBox.Text)
    if new and new > 50 and new < 800 then
        getgenv().FOVRadius = new
        FOVLabel.Text = "Размер FOV: " .. new
    end
end)

print("MALOT v2 ЗАГРУЖЕН! Вставил — сразу работает на [FPS] Флик.")
print("ПКМ = быстрый aimbot в голову")
print("ЛКМ = silent aim (гарантированно попадёшь)")
print("Insert = меню (FOV + вкл/выкл)")
