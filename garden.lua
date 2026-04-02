-- MALOT Aimbot v5 + ESP — для [FPS] Флик с поддержкой снайперского прицела
-- Аимбот работает и в обычном режиме, и когда ты в scope (снайперка)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

getgenv().AimbotEnabled = true
getgenv().SilentAimEnabled = true
getgenv().ESPEnabled = true
getgenv().FOVRadius = 135          -- маленький удобный круг
getgenv().AimSpeed = 0.98          -- ещё быстрее для снайперки
getgenv().SilentPower = 1.0

local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2.2
FOVCircle.NumSides = 80
FOVCircle.Radius = getgenv().FOVRadius
FOVCircle.Color = Color3.fromRGB(0, 255, 200)
FOVCircle.Transparency = 0.85
FOVCircle.Visible = true
FOVCircle.Filled = false

-- Меню
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer.PlayerGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 330, 0, 250)
Frame.Position = UDim2.new(0.5, -165, 0.2, 0)
Frame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Frame.BorderSizePixel = 0
Frame.Visible = false
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,45)
Title.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
Title.Text = "MALOT Aimbot v5 — Снайперка + Обычный"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 20
Title.Parent = Frame

local FOVLabel = Instance.new("TextLabel")
FOVLabel.Position = UDim2.new(0,20,0,60)
FOVLabel.Size = UDim2.new(0.9,0,0,30)
FOVLabel.BackgroundTransparency = 1
FOVLabel.Text = "FOV размер: " .. getgenv().FOVRadius
FOVLabel.TextColor3 = Color3.new(1,1,1)
FOVLabel.TextXAlignment = Enum.TextXAlignment.Left
FOVLabel.Parent = Frame

local FOVBox = Instance.new("TextBox")
FOVBox.Position = UDim2.new(0,20,0,95)
FOVBox.Size = UDim2.new(0.4,0,0,35)
FOVBox.BackgroundColor3 = Color3.fromRGB(30,30,30)
FOVBox.Text = tostring(getgenv().FOVRadius)
FOVBox.TextColor3 = Color3.new(1,1,1)
FOVBox.Parent = Frame

local ApplyBtn = Instance.new("TextButton")
ApplyBtn.Position = UDim2.new(0.5,10,0,95)
ApplyBtn.Size = UDim2.new(0.45,0,0,35)
ApplyBtn.BackgroundColor3 = Color3.fromRGB(0, 190, 255)
ApplyBtn.Text = "Применить"
ApplyBtn.TextColor3 = Color3.new(1,1,1)
ApplyBtn.Parent = Frame

-- ESP (оставляем как есть)
local ESPObjects = {}
local function CreateESP(plr)
    if plr == LocalPlayer then return end
    local folder = Instance.new("Folder")
    folder.Name = "MALOT_ESP"
    folder.Parent = plr

    local hl = Instance.new("Highlight")
    hl.FillTransparency = 0.92
    hl.OutlineTransparency = 0
    hl.OutlineColor = Color3.fromRGB(0, 255, 200)
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Parent = folder

    ESPObjects[plr] = {Highlight = hl}
end

local function UpdateESP()
    for plr, data in pairs(ESPObjects) do
        local char = plr.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            data.Highlight.Adornee = char
            if game.PlaceId == 142823291 then
                local isM = char:FindFirstChild("Knife") or (plr.Backpack and plr.Backpack:FindFirstChild("Knife"))
                data.Highlight.OutlineColor = isM and Color3.fromRGB(255,0,0) or Color3.fromRGB(0,255,200)
            end
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

-- Главный цикл (работает и в scope)
RunService.RenderStepped:Connect(function()
    -- Обновляем круг (виден даже в снайперском прицеле)
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    FOVCircle.Radius = getgenv().FOVRadius
    FOVCircle.Visible = getgenv().AimbotEnabled

    if getgenv().ESPEnabled then
        UpdateESP()
    end

    -- Аимбот при удержании ПКМ (работает и когда ты в прицеле снайперки)
    if getgenv().AimbotEnabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = GetClosestHead()
        if target then
            local targetPos = Camera:WorldToViewportPoint(target.Position)
            local mousePos = UserInputService:GetMouseLocation()
            local dx = (targetPos.X - mousePos.X) * getgenv().AimSpeed
            local dy = (targetPos.Y - mousePos.Y) * getgenv().AimSpeed
            mousemoverel(dx, dy)
        end
    end
end)

-- Silent Aim при выстреле (работает и в снайперке)
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 and getgenv().SilentAimEnabled then
        local target = GetClosestHead()
        if target then
            local targetPos = Camera:WorldToViewportPoint(target.Position)
            local mousePos = UserInputService:GetMouseLocation()
            mousemoverel((targetPos.X - mousePos.X) * getgenv().SilentPower, 
                         (targetPos.Y - mousePos.Y) * getgenv().SilentPower)
        end
    end

    if input.KeyCode == Enum.KeyCode.Insert then
        Frame.Visible = not Frame.Visible
    end
end)

-- Создание ESP
for _, plr in ipairs(Players:GetPlayers()) do CreateESP(plr) end
Players.PlayerAdded:Connect(CreateESP)

ApplyBtn.MouseButton1Click:Connect(function()
    local val = tonumber(FOVBox.Text)
    if val and val >= 60 and val <= 600 then
        getgenv().FOVRadius = val
        FOVLabel.Text = "FOV размер: " .. val
    end
end)

print("MALOT Aimbot v5 загружен!")
print("Теперь аим работает и когда ты в прицеле снайперки!")
print("ПКМ — быстрый aim в голову")
print("ЛКМ — silent aim (авто-попадание)")
print("Insert — меню FOV")
