-- MALOT UNIVERSAL CHEAT v6.2 FINAL — ВСЁ КАК ТЫ ХОТЕЛ
-- XWARE стиль + отдельное Fly окно + мощный Super Strength

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local character, humanoid, rootPart
local speedValue = 160
local jumpPowerValue = 220
local flySpeed = 85

local states = {
    invisible = false,
    noclip = false,
    infiniteJump = false,
    godMode = false,
    safeSpeed = false,
    superStrength = false
}

local grabbedObject = nil
local alignPos, alignOri = nil, nil

local function setupCharacter()
    character = player.Character or player.CharacterAdded:Wait()
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
end
setupCharacter()
player.CharacterAdded:Connect(setupCharacter)

-- ==================== ОСНОВНОЕ XWARE МЕНЮ ====================
local mainGui = Instance.new("ScreenGui")
mainGui.ResetOnSpawn = false
mainGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 370, 0, 460)
mainFrame.Position = UDim2.new(0.5, -185, 0.5, -230)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = mainGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 18)
mainCorner.Parent = mainFrame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(80, 180, 255)
stroke.Thickness = 2
stroke.Parent = mainFrame

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 50)
titleBar.BackgroundColor3 = Color3.fromRGB(26, 26, 36)
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 18)
titleCorner.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Text = "MALOT UNIVERSAL"
titleLabel.Size = UDim2.new(1, -130, 1, 0)
titleLabel.Position = UDim2.new(0, 20, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.new(1,1,1)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBlack
titleLabel.Parent = titleBar

local author = Instance.new("TextLabel")
author.Text = "By MALOT"
author.Position = UDim2.new(1, -120, 0.5, -12)
author.Size = UDim2.new(0, 100, 0, 24)
author.BackgroundTransparency = 1
author.TextColor3 = Color3.fromRGB(140, 220, 255)
author.TextScaled = true
author.Font = Enum.Font.Gotham
author.Parent = titleBar

local minBtnMain = Instance.new("TextButton")
minBtnMain.Size = UDim2.new(0, 40, 0, 40)
minBtnMain.Position = UDim2.new(1, -85, 0, 5)
minBtnMain.BackgroundTransparency = 1
minBtnMain.Text = "–"
minBtnMain.TextColor3 = Color3.new(1,1,1)
minBtnMain.TextScaled = true
minBtnMain.Font = Enum.Font.GothamBold
minBtnMain.Parent = titleBar

local closeBtnMain = Instance.new("TextButton")
closeBtnMain.Size = UDim2.new(0, 40, 0, 40)
closeBtnMain.Position = UDim2.new(1, -40, 0, 5)
closeBtnMain.BackgroundTransparency = 1
closeBtnMain.Text = "X"
closeBtnMain.TextColor3 = Color3.fromRGB(255, 80, 80)
closeBtnMain.TextScaled = true
closeBtnMain.Font = Enum.Font.GothamBold
closeBtnMain.Parent = titleBar

local content = Instance.new("Frame")
content.Size = UDim2.new(1, -20, 1, -65)
content.Position = UDim2.new(0, 10, 0, 60)
content.BackgroundTransparency = 1
content.Parent = mainFrame

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 8)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = content

local function createToggle(name, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 48)
    frame.BackgroundColor3 = Color3.fromRGB(32, 32, 42)
    frame.BorderSizePixel = 0
    frame.Parent = content

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = frame

    local lbl = Instance.new("TextLabel")
    lbl.Text = name
    lbl.Position = UDim2.new(0, 20, 0.5, -13)
    lbl.Size = UDim2.new(0.6, 0, 0, 26)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.new(1,1,1)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextScaled = true
    lbl.Font = Enum.Font.GothamSemibold
    lbl.Parent = frame

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 100, 0, 34)
    btn.Position = UDim2.new(1, -115, 0.5, -17)
    btn.BackgroundColor3 = Color3.fromRGB(70, 70, 80)
    btn.Text = "ВЫКЛ"
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.Parent = frame

    local bCorner = Instance.new("UICorner")
    bCorner.CornerRadius = UDim.new(0, 10)
    bCorner.Parent = btn

    local enabled = false
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        callback(enabled)
        btn.BackgroundColor3 = enabled and Color3.fromRGB(0, 200, 120) or Color3.fromRGB(70, 70, 80)
        btn.Text = enabled and "ВКЛ" or "ВЫКЛ"
    end)
end

createToggle("Невидимость", function(v) states.invisible = v end)
createToggle("Noclip", function(v) states.noclip = v end)
createToggle("Бесконечный прыжок", function(v) states.infiniteJump = v end)
createToggle("Режим Бога", function(v) states.godMode = v end)
createToggle("Safe Speed", function(v) states.safeSpeed = v end)
createToggle("SUPER STRENGTH (силач)", function(v) states.superStrength = v end)

-- ==================== ОТДЕЛЬНОЕ МИНИ-МЕНЮ FLY (по F) ====================
local flyGui = Instance.new("ScreenGui")
flyGui.ResetOnSpawn = false
flyGui.Parent = player:WaitForChild("PlayerGui")

local flyFrame = Instance.new("Frame")
flyFrame.Size = UDim2.new(0, 240, 0, 130)
flyFrame.Position = UDim2.new(0.5, -120, 0.65, 0)
flyFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
flyFrame.BackgroundTransparency = 0.05
flyFrame.BorderSizePixel = 0
flyFrame.Active = true
flyFrame.Draggable = true
flyFrame.Visible = false
flyFrame.Parent = flyGui

local flyCorner = Instance.new("UICorner")
flyCorner.CornerRadius = UDim.new(0, 16)
flyCorner.Parent = flyFrame

local flyStroke = Instance.new("UIStroke")
flyStroke.Color = Color3.fromRGB(80, 180, 255)
flyStroke.Thickness = 2
flyStroke.Parent = flyFrame

local flyTitle = Instance.new("TextLabel")
flyTitle.Text = "FLY CONTROL"
flyTitle.Size = UDim2.new(1, -80, 0, 35)
flyTitle.Position = UDim2.new(0, 15, 0, 0)
flyTitle.BackgroundTransparency = 1
flyTitle.TextColor3 = Color3.new(1,1,1)
flyTitle.TextScaled = true
flyTitle.Font = Enum.Font.GothamBlack
flyTitle.Parent = flyFrame

local flyMinBtn = Instance.new("TextButton")
flyMinBtn.Size = UDim2.new(0, 35, 0, 35)
flyMinBtn.Position = UDim2.new(1, -70, 0, 3)
flyMinBtn.BackgroundTransparency = 1
flyMinBtn.Text = "–"
flyMinBtn.TextColor3 = Color3.new(1,1,1)
flyMinBtn.TextScaled = true
flyMinBtn.Font = Enum.Font.GothamBold
flyMinBtn.Parent = flyFrame

local flyCloseBtn = Instance.new("TextButton")
flyCloseBtn.Size = UDim2.new(0, 35, 0, 35)
flyCloseBtn.Position = UDim2.new(1, -35, 0, 3)
flyCloseBtn.BackgroundTransparency = 1
flyCloseBtn.Text = "X"
flyCloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
flyCloseBtn.TextScaled = true
flyCloseBtn.Font = Enum.Font.GothamBold
flyCloseBtn.Parent = flyFrame

local flyToggle = Instance.new("TextButton")
flyToggle.Size = UDim2.new(0, 200, 0, 40)
flyToggle.Position = UDim2.new(0.5, -100, 0, 45)
flyToggle.BackgroundColor3 = Color3.fromRGB(70, 70, 80)
flyToggle.Text = "FLY ВЫКЛ"
flyToggle.TextColor3 = Color3.new(1,1,1)
flyToggle.TextScaled = true
flyToggle.Font = Enum.Font.GothamBold
flyToggle.Parent = flyFrame

local flyToggleCorner = Instance.new("UICorner")
flyToggleCorner.CornerRadius = UDim.new(0, 12)
flyToggleCorner.Parent = flyToggle

local flyEnabled = false
flyToggle.MouseButton1Click:Connect(function()
    flyEnabled = not flyEnabled
    states.fly = flyEnabled
    flyToggle.BackgroundColor3 = flyEnabled and Color3.fromRGB(0, 200, 120) or Color3.fromRGB(70, 70, 80)
    flyToggle.Text = flyEnabled and "FLY ВКЛ" or "FLY ВЫКЛ"
end)

flyMinBtn.MouseButton1Click:Connect(function()
    local isMin = flyFrame.Size.Y.Offset == 130
    flyFrame.Size = isMin and UDim2.new(0,240,0,40) or UDim2.new(0,240,0,130)
    flyToggle.Visible = not isMin
    flyMinBtn.Text = isMin and "+" or "–"
end)

flyCloseBtn.MouseButton1Click:Connect(function()
    flyFrame.Visible = false
    states.fly = false
    flyEnabled = false
end)

-- ==================== ЧИТ ЛОГИКА ====================
UserInputService.JumpRequest:Connect(function()
    if states.infiniteJump and humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

RunService.Heartbeat:Connect(function(dt)
    if not character or not rootPart or not humanoid then return end

    if states.godMode then
        humanoid.Health = 10000
        humanoid.MaxHealth = 10000
    end

    humanoid.WalkSpeed = speedValue
    humanoid.JumpPower = jumpPowerValue

    if states.invisible then
        for _, obj in ipairs(character:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name ~= "HumanoidRootPart" then obj.Transparency = 1
            elseif obj:IsA("Decal") or obj:IsA("Texture") then obj.Transparency = 1 end
        end
    else
        for _, obj in ipairs(character:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name ~= "HumanoidRootPart" then obj.Transparency = 0
            elseif obj:IsA("Decal") or obj:IsA("Texture") then obj.Transparency = 0 end
        end
    end

    -- Fly
    if states.fly then
        local dir = Vector3.new()
        local cf = camera.CFrame
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += cf.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= cf.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= cf.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += cf.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.new(0,1,0) end
        rootPart.CFrame = rootPart.CFrame + dir.Unit * flySpeed * dt * 4.8
        rootPart.Velocity = Vector3.new(0,0,0)
    end

    if states.noclip then
        for _, p in ipairs(character:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end

    if states.safeSpeed and humanoid.MoveDirection.Magnitude > 0 then
        rootPart.CFrame += humanoid.MoveDirection * speedValue * dt * 3.7
    end

    if states.superStrength then
        humanoid.HipHeight = 2
    end
end)

-- Super Strength — хватание объектов клавишей E
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.E and states.superStrength then
        if grabbedObject then
            grabbedObject = nil
            if alignPos then alignPos:Destroy() alignPos = nil end
            if alignOri then alignOri:Destroy() alignOri = nil end
        else
            local closest = nil
            local minDist = 20
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and not obj.Anchored and obj ~= rootPart and (obj.Position - rootPart.Position).Magnitude < minDist then
                    closest = obj
                    minDist = (obj.Position - rootPart.Position).Magnitude
                end
            end
            if closest then
                grabbedObject = closest
                alignPos = Instance.new("AlignPosition")
                alignPos.Attachment0 = Instance.new("Attachment", rootPart)
                alignPos.Attachment1 = Instance.new("Attachment", grabbedObject)
                alignPos.MaxForce = math.huge
                alignPos.Responsiveness = 180
                alignPos.Parent = grabbedObject

                alignOri = Instance.new("AlignOrientation")
                alignOri.Attachment0 = Instance.new("Attachment", rootPart)
                alignOri.Attachment1 = Instance.new("Attachment", grabbedObject)
                alignOri.MaxTorque = math.huge
                alignOri.Responsiveness = 180
                alignOri.Parent = grabbedObject
            end
        end
    end
end)

-- Управление меню
minBtnMain.MouseButton1Click:Connect(function()
    local target = mainFrame.Size.Y.Offset == 460 and UDim2.new(0,370,0,50) or UDim2.new(0,370,0,460)
    mainFrame.Size = target
    content.Visible = mainFrame.Size.Y.Offset == 460
    minBtnMain.Text = mainFrame.Size.Y.Offset == 460 and "+" or "–"
end)

closeBtnMain.MouseButton1Click:Connect(function()
    mainGui.Enabled = false
end)

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then
        mainGui.Enabled = not mainGui.Enabled
    elseif input.KeyCode == Enum.KeyCode.F then
        flyFrame.Visible = not flyFrame.Visible
    end
end)

StarterGui:SetCore("SendNotification", {
    Title = "MALOT v6.2 FINAL",
    Text = "Готово! RightShift — основное меню, F — Fly меню, E — хватать объекты когда силач включён.",
    Duration = 8
})

print("[MALOT] v6.2 FINAL ЗАГРУЖЕН — теперь ты полный силач с удобным Fly!")
