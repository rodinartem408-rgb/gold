-- MALOT Roblox Aimbot v2.2 — оптимизировано под Delta Executor 2026
-- Максимально быстрый aim только в голову + предикция + большая зона

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local AimbotEnabled = true
local FOVRadius = 650  -- ещё шире для Delta

local function GetClosestPlayerToMouse()
	local closest, closestDist = nil, math.huge
	local mouseLoc = UserInputService:GetMouseLocation()
	
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
			local head = plr.Character.Head
			local headPos, onScreen = Camera:WorldToViewportPoint(head.Position)
			if onScreen then
				local dist = (Vector2.new(headPos.X, headPos.Y) - mouseLoc).Magnitude
				if dist < closestDist and dist < FOVRadius then
					closestDist = dist
					closest = plr
				end
			end
		end
	end
	return closest
end

RunService.Heartbeat:Connect(function()  -- Heartbeat вместо RenderStepped — лучше работает на слабых executors типа Delta
	if AimbotEnabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
		local target = GetClosestPlayerToMouse()
		if target and target.Character and target.Character:FindFirstChild("Head") then
			local head = target.Character.Head
			local predictedPos = head.Position + (head.Velocity * 0.04)  -- чуть сильнее предикция
			Camera.CFrame = CFrame.new(Camera.CFrame.Position, predictedPos)
		end
	end
end)

-- Простое меню без Drawing (чтобы Delta не глючил)
local menuOpen = false
UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.Insert then
		menuOpen = not menuOpen
		if menuOpen then
			print("=== MALOT AIMBOT MENU ===")
			print("Текущая ширина аима: " .. FOVRadius)
			print("Напиши в чат: fov 700  — чтобы изменить ширину")
			print("F2 — включить/выключить aimbot")
		end
	elseif input.KeyCode == Enum.KeyCode.F2 then
		AimbotEnabled = not AimbotEnabled
		print("Aimbot теперь: " .. tostring(AimbotEnabled))
	end
end)

-- Команда для изменения FOV через чат (Delta любит такой способ)
LocalPlayer.Chatted:Connect(function(msg)
	if msg:lower():sub(1,4) == "fov " then
		local newFov = tonumber(msg:sub(5))
		if newFov then
			FOVRadius = newFov
			print("Ширина аима изменена на " .. newFov)
		end
	end
end)

print("MALOT Aimbot v2.2 для Delta загружен!")
print("• Держи ПРАВУЮ кнопку мыши — моментальный aim в голову")
print("• INSERT — открыть меню")
print("• F2 — вкл/выкл aim")
print("• В чате пиши: fov 800  — чтобы сделать зону шире")
