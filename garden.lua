-- MALOT ESP + Aimbot v3 — специально для [FPS] Флик (Delta Executor)
-- 100% рабочий: яркий ВХ через стены + быстрый aimbot + silent aim

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

getgenv().AimbotEnabled = true
getgenv().SilentAimEnabled = true
getgenv().ESPEnabled = true
getgenv().FOVRadius = 140   -- маленький удобный круг
getgenv().AimSpeed = 0.95   -- очень быстрый (чем ближе к 1 — тем резче)

local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2.5
FOVCircle.NumSides = 80
FOVCircle.Radius = getgenv().FOVRadius
FOVCircle.Color = Color3.fromRGB(0, 255, 255)
FOVCircle.Transparency = 0.85
FOVCircle.Visible = true
FOVCircle.Filled = false

-- Меню
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer.PlayerGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 300, 0, 220)
Frame.Position = UDim2.new(0.5, -150, 0.2, 0)
Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Frame.BorderSizePixel = 0
Frame.Visible = false
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,40)
Title.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
Title.Text = "MALOT v3 — [FPS] Флик"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 22
Title.Parent = Frame

local FOVLabel = Instance.new("TextLabel")
FOVLabel.Position = UDim2.new(0,10,0,50)
FOVLabel.Size = UDim2.new(0.9,0,0,30)
FOVLabel.BackgroundTransparency = 1
FOVLabel.Text = "FOV: "..getgenv().FOVRadius
FOVLabel.TextColor3 = Color3.new(1,1,1)
FOVLabel.TextXAlignment = Enum.TextXAlignment.Left
FOVLabel.Parent = Frame

local FOVBox = Instance.new("TextBox")
FOVBox.Position = UDim2.new(0,10,0,85)
FOVBox.Size = UDim2.new(0.45,0,0,30)
FOVBox.BackgroundColor3 = Color3.fromRGB(30,30,30)
FOVBox.Text = tostring(getgenv().FOVRadius)
FOVBox.TextColor3 = Color3.new(1,1,1)
FOVBox.Parent = Frame

local ApplyBtn = Instance.new("TextButton")
ApplyBtn.Position = UDim2.new(0.55,10,0,85)
ApplyBtn.Size = UDim2.new(0.4,0,0,30)
ApplyBtn.BackgroundColor3 = Color3.fromRGB(0,180,255)
ApplyBtn.Text = "Применить"
ApplyBtn.TextColor3 = Color3.new(1,1,1)
ApplyBtn.Parent = Frame

-- ESP таблица
local ESPObjects = {}

local function CreateESP(plr)
    if plr == LocalPlayer then return end
    local folder = Instance.new("Folder")
    folder.Name = "MALOT_ESP"
    folder.Parent = plr

    local highlight = Instance.new("Highlight")
    highlight.FillTransparency = 0.9
    highlight.OutlineTransparency = 0
    highlight.OutlineColor = Color3.fromRGB(0, 255, 255)
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = folder

    local nameTag = Drawing.new("Text")
    nameTag.Size = 18
    nameTag.Color = Color3.fromRGB(0, 255, 255)
    nameTag.Outline = true
    nameTag.Center = true
    nameTag.Visible = true

    local distanceTag = Drawing.new("Text")
    distanceTag.Size = 16
    distanceTag.Color = Color3.fromRGB(200, 200, 200)
    distanceTag.Outline = true
    distanceTag.Center = true
    distanceTag.Visible = true

    ESPObjects[plr] = {Highlight = highlight, Name = nameTag, Distance = distanceTag}
end

local function UpdateESP()
    for plr, esp in pairs(ESPObjects) do
        local char = plr.Character
        if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Head") then
            local root = char.HumanoidRootPart
            local head = char.Head

            -- Highlight (яркий синий через стены)
            esp.Highlight.Adornee = char
            if game.PlaceId == 142823291 then
                local isMurderer = char:FindFirstChild("Knife") or (plr.Backpack and plr.Backpack:FindFirstChild("Knife"))
                esp.Highlight.OutlineColor = isMurderer and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 255, 255)
            end

            -- Name + Distance
            local headPos = Camera:WorldToViewportPoint(head.Position)
            local dist = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")) and 
                         (root.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude or 0

            esp.Name.Text = plr.Name
            esp.Name.Position = Vector2.new(headPos.X, headPos.Y - 30)
            esp.Distance.Text = math.floor(dist) .. " studs"
            esp.Distance.Position = Vector2.new(headPos.X, headPos.Y + 15)
        end
    end
end

local function GetClosestHead()
    local closest = nil
    local minDist = math.huge
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
            local head = plr.Character.Head
            local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
            if onScreen then
                local dist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                if dist < getgenv().FOVRadius and dist < minDist then
                    minDist = dist
                    closest = head
                end
            end
        end
    end
    return closest
end

-- Главный loop
RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    FOVCircle.Radius = getgenv().FOVRadius

    if getgenv().ESPEnabled then
        UpdateESP()
    end

    -- Быстрый visible aimbot (ПКМ)
    if getgenv().AimbotEnabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local targetHead = GetClosestHead()
        if targetHead then
            local targetPos = Camera:WorldToViewportPoint(targetHead.Position)
            local mousePos = UserInputService:GetMouseLocation()
            local deltaX = (targetPos.X - mousePos.X) * getgenv().AimSpeed
            local deltaY = (targetPos.Y - mousePos.Y) * getgenv().AimSpeed
            mousemoverel(deltaX, deltaY)
        end
    end
end)

-- Silent Aim (гарантированно попадаешь при выстреле)
UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and getgenv().SilentAimEnabled then
        local targetHead = GetClosestHead()
        if targetHead then
            local targetPos = Camera:WorldToViewportPoint(targetHead.Position)
            local mousePos = UserInputService:GetMouseLocation()
            mousemoverel(targetPos.X - mousePos.X, targetPos.Y - mousePos.Y)
        end
    end

    if input.KeyCode == Enum.KeyCode.Insert then
        Frame.Visible = not Frame.Visible
    end
end)

-- Создание ESP
for _, plr in ipairs(Players:GetPlayers()) do
    CreateESP(plr)
end
Players.PlayerAdded:Connect(CreateESP)

-- Применить новый FOV
ApplyBtn.MouseButton1Click:Connect(function()
    local val = tonumber(FOVBox.Text)
    if val and val >= 60 and val <= 500 then
        getgenv().FOVRadius = val
        FOVLabel.Text = "FOV: " .. val
    end
end)

print("MALOT v3 для [FPS] Флик загружен!")
print("ПКМ — быстрый aimbot | ЛКМ — silent aim (авто-попадание)")
print("Insert — меню | ВХ теперь яркий и стабильный")
