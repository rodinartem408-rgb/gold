-- MALOT Roblox Universal Aimbot v2.0
-- Моментальный aimbot только в голову + сильно увеличенная зона + без ESP/VH

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local AimbotEnabled = true
local FOVRadius = 600  -- сильно увеличенная ширина автонаводки (по умолчанию)

-- FOV круг для визуализации зоны аима
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.NumSides = 64
FOVCircle.Radius = FOVRadius
FOVCircle.Color = Color3.fromRGB(0, 255, 255)
FOVCircle.Filled = false
FOVCircle.Visible = true
FOVCircle.Transparency = 0.6

local function GetClosestPlayerToMouse()
	local closest, closestDist = nil, math.huge
	local mouseLoc = UserInputService:GetMouseLocation()
	
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
			local headPos, onScreen = Camera:WorldToViewportPoint(plr.Character.Head.Position)
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

-- Моментальный aimbot (без плавности)
RunService.RenderStepped:Connect(function()
	FOVCircle.Position = UserInputService:GetMouseLocation()
	FOVCircle.Radius = FOVRadius
	
	if AimbotEnabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
		local target = GetClosestPlayerToMouse()
		if target and target.Character and target.Character:FindFirstChild("Head") then
			local headPos = target.Character.Head.Position
			Camera.CFrame = CFrame.new(Camera.CFrame.Position, headPos)
		end
	end
end)

-- Минимальное меню для изменения размера аима (с полузакрытием)
local menuGui, menuFrame, minimizedButton = nil, nil, nil
local isMenuOpen = false
local isMenuMinimized = false

local function CreateAimMenu()
	menuGui = Instance.new("ScreenGui")
	menuGui.Name = "MALOT_AimMenu"
	menuGui.ResetOnSpawn = false
	menuGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
	
	menuFrame = Instance.new("Frame")
	menuFrame.Size = UDim2.new(0, 280, 0, 140)
	menuFrame.Position = UDim2.new(0.5, -140, 0.3, 0)
	menuFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	menuFrame.BorderSizePixel = 2
	menuFrame.BorderColor3 = Color3.fromRGB(0, 255, 255)
	menuFrame.Visible = false
	menuFrame.Parent = menuGui
	
	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, 0, 0, 30)
	title.BackgroundTransparency = 1
	title.Text = "MALOT Aimbot Menu"
	title.TextColor3 = Color3.fromRGB(0, 255, 255)
	title.TextScaled = true
	title.Font = Enum.Font.GothamBold
	title.Parent = menuFrame
	
	local fovLabel = Instance.new("TextLabel")
	fovLabel.Size = UDim2.new(0.6, 0, 0, 30)
	fovLabel.Position = UDim2.new(0, 10, 0, 40)
	fovLabel.BackgroundTransparency = 1
	fovLabel.Text = "Ширина аима (%):"
	fovLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	fovLabel.TextXAlignment = Enum.TextXAlignment.Left
	fovLabel.Parent = menuFrame
	
	local fovBox = Instance.new("TextBox")
	fovBox.Size = UDim2.new(0.3, 0, 0, 30)
	fovBox.Position = UDim2.new(0.65, 0, 0, 40)
	fovBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	fovBox.Text = tostring(math.floor(FOVRadius / 5))
	fovBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	fovBox.Parent = menuFrame
	
	local applyBtn = Instance.new("TextButton")
	applyBtn.Size = UDim2.new(0.9, 0, 0, 35)
	applyBtn.Position = UDim2.new(0.05, 0, 0, 85)
	applyBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
	applyBtn.Text = "Применить"
	applyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	applyBtn.Parent = menuFrame
	
	applyBtn.MouseButton1Click:Connect(function()
		local newVal = tonumber(fovBox.Text)
		if newVal and newVal > 0 then
			FOVRadius = newVal * 5
			FOVCircle.Radius = FOVRadius
			print("Ширина аима изменена на " .. newVal .. "%")
		end
	end)
	
	-- Кнопка для полузакрытого состояния
	minimizedButton = Instance.new("TextButton")
	minimizedButton.Size = UDim2.new(0, 140, 0, 40)
	minimizedButton.Position = UDim2.new(0, 10, 0, 10)
	minimizedButton.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
	minimizedButton.Text = "Aimbot Menu"
	minimizedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	minimizedButton.Visible = false
	minimizedButton.Parent = menuGui
	
	minimizedButton.MouseButton1Click:Connect(function()
		isMenuMinimized = false
		menuFrame.Visible = true
		minimizedButton.Visible = false
	end)
end

-- Управление клавишами
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	
	if input.KeyCode == Enum.KeyCode.Insert then
		if not menuGui then CreateAimMenu() end
		
		if isMenuMinimized then
			isMenuMinimized = false
			menuFrame.Visible = true
			minimizedButton.Visible = false
		elseif isMenuOpen then
			-- полузакрытие меню
			isMenuMinimized = true
			menuFrame.Visible = false
			minimizedButton.Visible = true
		else
			isMenuOpen = true
			menuFrame.Visible = true
		end
	elseif input.KeyCode == Enum.KeyCode.F2 then
		AimbotEnabled = not AimbotEnabled
		print("Aimbot: " .. tostring(AimbotEnabled))
	elseif input.KeyCode == Enum.KeyCode.PageUp then
		FOVRadius = FOVRadius + 50
		FOVCircle.Radius = FOVRadius
	elseif input.KeyCode == Enum.KeyCode.PageDown then
		FOVRadius = math.max(150, FOVRadius - 50)
		FOVCircle.Radius = FOVRadius
	end
end)

print("MALOT Aimbot v2.0 ЗАГРУЖЕН!")
print("• Моментальная автонаводка только в голову")
print("• Ширина зоны сильно увеличена (FOV 600 по умолчанию)")
print("• Правая кнопка мыши — aim")
print("• INSERT — меню изменения ширины аима (с полузакрытием)")
print("• PageUp/PageDown — быстрый тюнинг FOV")
