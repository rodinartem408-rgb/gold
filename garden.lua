-- MALOT Aimbot v6 — чистый и жёсткий для [FPS] Флик
-- Работает в обычном режиме и в снайперском прицеле

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

getgenv().AimbotEnabled = true
getgenv().SilentAimEnabled = true
getgenv().FOVRadius = 130
getgenv().AimSpeed = 0.99   -- максимально быстро

local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.NumSides = 64
FOVCircle.Radius = getgenv().FOVRadius
FOVCircle.Color = Color3.fromRGB(0, 255, 255)
FOVCircle.Transparency = 0.9
FOVCircle.Visible = true
FOVCircle.Filled = false

-- Простое меню только для FOV
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 280, 0, 140)
Frame.Position = UDim2.new(0.5, -140, 0.3, 0)
Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Frame.BorderSizePixel = 0
Frame.Visible = false
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
Title.Text = "MALOT Aimbot v6"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 20
Title.Parent = Frame

local FOVLabel = Instance.new("TextLabel")
FOVLabel.Size = UDim2.new(1, 0, 0, 30)
FOVLabel.Position = UDim2.new(0, 0, 0, 40)
FOVLabel.BackgroundTransparency = 1
FOVLabel.Text = "FOV: " .. getgenv().FOVRadius
FOVLabel.TextColor3 = Color3.new(1,1,1)
FOVLabel.Font = Enum.Font.SourceSans
FOVLabel.TextSize = 16
FOVLabel.Parent = Frame

local FOVBox = Instance.new("TextBox")
FOVBox.Size = UDim2.new(0.5, 0, 0, 30)
FOVBox.Position = UDim2.new(0.05, 0, 0, 75)
FOVBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
FOVBox.Text = tostring(getgenv().FOVRadius)
FOVBox.TextColor3 = Color3.new(1,1,1)
FOVBox.Parent = Frame

local ApplyBtn = Instance.new("TextButton")
ApplyBtn.Size = UDim2.new(0.4, 0, 0, 30)
ApplyBtn.Position = UDim2.new(0.57, 0, 0, 75)
ApplyBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
ApplyBtn.Text = "Применить"
ApplyBtn.TextColor3 = Color3.new(1,1,1)
ApplyBtn.Parent = Frame

local function GetClosestHead()
    local closest = nil
    local shortest = 9999
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

-- Главный цикл аимбота
RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    FOVCircle.Radius = getgenv().FOVRadius

    -- Аимбот при удержании ПКМ (работает и в снайперке)
    if getgenv().AimbotEnabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = GetClosestHead()
        if target then
            local targetPos = Camera:WorldToViewportPoint(target.Position)
            local mouse = UserInputService:GetMouseLocation()
            local dx = (targetPos.X - mouse.X) * getgenv().AimSpeed
            local dy = (targetPos.Y - mouse.Y) * getgenv().AimSpeed
            mousemoverel(dx, dy)
        end
    end
end)

-- Silent Aim при выстреле ЛКМ
UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and getgenv().SilentAimEnabled then
        local target = GetClosestHead()
        if target then
            local targetPos = Camera:WorldToViewportPoint(target.Position)
            local mouse = UserInputService:GetMouseLocation()
            mousemoverel(targetPos.X - mouse.X, targetPos.Y - mouse.Y)
        end
    end

    if input.KeyCode == Enum.KeyCode.Insert then
        Frame.Visible = not Frame.Visible
    end
end)

-- Меню FOV
ApplyBtn.MouseButton1Click:Connect(function()
    local newFOV = tonumber(FOVBox.Text)
    if newFOV and newFOV > 50 and newFOV < 500 then
        getgenv().FOVRadius = newFOV
        FOVLabel.Text = "FOV: " .. newFOV
    end
end)

print("MALOT Aimbot v6 загружен — чистый и жёсткий")
print("ПКМ — удерживай для аимбота на голову")
print("ЛКМ — silent aim (авто-попадание)")
print("Insert — меню для изменения FOV")
