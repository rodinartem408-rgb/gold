-- MALOT Roblox Universal Cheats v1.0
-- Aimbot только в голову + ESP через стены + MM2 role colors
-- FOV 70% по умолчанию, минимальное меню для изменения размера аима (полузакрытие)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local AimbotEnabled = true
local ESPEnabled = true
local FOVRadius = 350  -- ~70% от половины экрана (можно менять в меню)
local Smoothness = 0.25  -- плавность поворота камеры (0.1 - резко, 0.5 - мягко)

local isMM2 = (game.PlaceId == 142823291)  -- Murder Mystery 2

-- FOV круг для визуализации аима
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.NumSides = 64
FOVCircle.Radius = FOVRadius
FOVCircle.Color = Color3.fromRGB(0, 255, 255)
FOVCircle.Filled = false
FOVCircle.Visible = true
FOVCircle.Transparency = 0.7

-- ESP Highlight (обводка всего тела)
local ESPHighlights = {}

local function GetRole(plr)
	if not isMM2 or not plr or not plr.Character then return "Innocent" end
	local bp = plr:FindFirstChild("Backpack")
	local char = plr.Character
	if bp and (bp:FindFirstChild("Knife") or char:FindFirstChild("Knife")) then
		return "Murderer"
	elseif bp and (bp:FindFirstChild("Gun") or bp:FindFirstChild("Revolver") or char:FindFirstChild("Gun")) then
		return "Sheriff"
	end
	return "Innocent"
end

local function CreateHighlight(plr)
	if ESPHighlights[plr] then return end
	local char = plr.Character
	if not char then return end
	
	local hl = Instance.new("Highlight")
	hl.Name = "MALOT_ESP"
	hl.Adornee = char
	hl.FillTransparency = 1  -- только обводка
	hl.OutlineTransparency = 0
	hl.OutlineColor = Color3.fromRGB(0, 0, 255)  -- синий
	hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop  -- через стены
	hl.Parent = char
	
	ESPHighlights[plr] = hl
end

local function UpdateHighlights()
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer then
			if not ESPHighlights[plr] then
				CreateHighlight(plr)
			end
			local hl = ESPHighlights[plr]
			if hl and plr.Character then
				local role = GetRole(plr)
				if role == "Murderer" then
					hl.OutlineColor = Color3.fromRGB(255, 0, 0)  -- красный
				elseif role == "Sheriff" then
					hl.OutlineColor = Color3.fromRGB(0, 100, 255)  -- синий для шерифа
				else
					hl.OutlineColor = Color3.fromRGB(0, 0, 255)  -- синий
				end
			end
		end
	end
end

-- Поиск ближайшего игрока в зоне FOV (только голова)
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

local targetPlr = nil

-- Основной цикл
RunService.RenderStepped:Connect(function(dt)
	FOVCircle.Position = UserInputService:GetMouseLocation()
	FOVCircle.Radius = FOVRadius
	
	if ESPEnabled then
		UpdateHighlights()
	end
	
	if AimbotEnabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
		targetPlr = GetClosestPlayerToMouse()
		if targetPlr and targetPlr.Character and targetPlr.Character:FindFirstChild("Head") then
			local headCFrame = targetPlr.Character.Head.CFrame
			local currentCFrame = Camera.CFrame
			local targetLook = CFrame.new(currentCFrame.Position, headCFrame.Position)
			Camera.CFrame = currentCFrame:Lerp(targetLook, Smoothness)
		end
	else
		targetPlr = nil
	end
end)

-- Минимальное меню для аима (полузакрытие)
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
	fovLabel.Text = "Размер аима (%):"
	fovLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	fovLabel.TextXAlignment = Enum.TextXAlignment.Left
	fovLabel.Parent = menuFrame
	
	local fovBox = Instance.new("TextBox")
	fovBox.Size = UDim2.new(0.3, 0, 0, 30)
	fovBox.Position = UDim2.new(0.65, 0, 0, 40)
	fovBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	fovBox.Text = tostring(math.floor(FOVRadius / 5))  -- примерный %
	fovBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	fovBox.Parent = menuFrame
	
	local applyBtn = Instance.new("TextButton")
	applyBtn.Size = UDim2.new(0.9, 0, 0, 35)
	applyBtn.Position = UDim2.new(0.05, 0, 0, 85)
	applyBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
	applyBtn.Text = "Применить и сохранить"
	applyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	applyBtn.Parent = menuFrame
	
	applyBtn.MouseButton1Click:Connect(function()
		local newVal = tonumber(fovBox.Text)
		if newVal then
			FOVRadius = newVal * 5  -- перевод % в пиксели
			FOVCircle.Radius = FOVRadius
			print("Размер аима изменён на " .. newVal .. "%")
		end
	end)
	
	-- Полузакрытие: маленькая кнопка
	minimizedButton = Instance.new("TextButton")
	minimizedButton.Size = UDim2.new(0, 120, 0, 40)
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

-- Keybinds
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	
	if input.KeyCode == Enum.KeyCode.Insert then
		if not menuGui then CreateAimMenu() end
		if isMenuMinimized then
			isMenuMinimized = false
			menuFrame.Visible = true
			minimizedButton.Visible = false
		elseif isMenuOpen then
			-- полузакрытие
			isMenuMinimized = true
			menuFrame.Visible = false
			minimizedButton.Visible = true
		else
			isMenuOpen = true
			menuFrame.Visible = true
		end
	elseif input.KeyCode == Enum.KeyCode.F1 then
		ESPEnabled = not ESPEnabled
		print("ESP toggled: " .. tostring(ESPEnabled))
	elseif input.KeyCode == Enum.KeyCode.F2 then
		AimbotEnabled = not AimbotEnabled
		print("Aimbot toggled: " .. tostring(AimbotEnabled))
	elseif input.KeyCode == Enum.KeyCode.PageUp then
		FOVRadius = FOVRadius + 30
		FOVCircle.Radius = FOVRadius
	elseif input.KeyCode == Enum.KeyCode.PageDown then
		FOVRadius = math.max(100, FOVRadius - 30)
		FOVCircle.Radius = FOVRadius
	end
end)

-- Авто-создание ESP для новых игроков
Players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function()
		if ESPEnabled then
			wait(0.5)
			CreateHighlight(plr)
		end
	end)
end)

-- Инициализация уже существующих игроков
for _, plr in ipairs(Players:GetPlayers()) do
	if plr ~= LocalPlayer then
		CreateHighlight(plr)
	end
end

print("MALOT ЧИТЫ ЗАГРУЖЕНЫ УСПЕШНО!")
print("• Aimbot: правая кнопка мыши (только голова)")
print("• ESP: обводка через стены (синяя / MM2 роли)")
print("• Меню аима: INSERT (полузакрытие тоже)")
print("• PageUp / PageDown — быстрый тюнинг FOV")
