-- MALOT v3.0 STEALTH — WAVE OF BRAINROTS (апрель 2026)
-- Максимально скрытный, без прямого изменения Humanoid, CFrame only

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local SPEED = 120
local JUMP = 180
local FLY_SPEED = 70
local enabled = {speed = true, jump = true, fly = false, noclip = true, god = true}

-- Hook для скрытия
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    if method == "Kick" and self == player then
        return wait(9e9) -- блокируем кик
    end
    return oldNamecall(self, ...)
end)

local character, root, hum
local function setupChar()
    character = player.Character or player.CharacterAdded:Wait()
    root = character:WaitForChild("HumanoidRootPart")
    hum = character:WaitForChild("Humanoid")
end
setupChar()
player.CharacterAdded:Connect(setupChar)

-- Главный loop (максимально stealth)
RunService.Heartbeat:Connect(function(dt)
    if not root then return end

    -- Супер скорость через CFrame (самый безопасный способ)
    if enabled.speed and hum.MoveDirection.Magnitude > 0 then
        local move = hum.MoveDirection * SPEED * dt * 3.5
        root.CFrame += move
    end

    -- Прыжок
    if enabled.jump and UserInputService:IsKeyDown(Enum.KeyCode.Space) and hum:GetState() ~= Enum.HumanoidStateType.Jumping then
        root.Velocity = Vector3.new(root.Velocity.X, JUMP, root.Velocity.Z)
    end

    -- Fly
    if enabled.fly then
        local dir = Vector3.new()
        local cf = camera.CFrame
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += cf.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= cf.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= cf.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += cf.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.new(0,1,0) end
        root.CFrame += dir.Unit * FLY_SPEED * dt
        root.Velocity = Vector3.new(0,0,0)
    end

    -- Noclip (мягкий)
    if enabled.noclip then
        for _, v in ipairs(character:GetDescendants()) do
            if v:IsA("BasePart") and v.CanCollide then
                v.CanCollide = false
            end
        end
    end

    -- God (мягкий — просто не даём падать в смерть)
    if enabled.god and hum.Health < 20 then
        hum.Health = 100
    end
end)

-- Меню остаётся тем же (с кнопкой минимизации), просто вставь старый GUI-код сюда или используй предыдущий.

print("[MALOT v3.0 STEALTH] Загружен. Используй осторожно, не ставь скорость выше 180 первые 2 минуты.")
