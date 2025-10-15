-- Aimbot + ESP Script for Roblox
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AimbotGUI"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Position = UDim2.new(0, 10, 0, 10)
MainFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.new(0, 0.5, 1)
MainFrame.Parent = ScreenGui

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.new(0, 0.3, 0.6)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Text = "AIMBOT + ESP"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.Parent = MainFrame

-- Player List
local PlayerListLabel = Instance.new("TextLabel")
PlayerListLabel.Size = UDim2.new(1, -20, 0, 25)
PlayerListLabel.Position = UDim2.new(0, 10, 0, 40)
PlayerListLabel.BackgroundTransparency = 1
PlayerListLabel.TextColor3 = Color3.new(1, 1, 1)
PlayerListLabel.Text = "Выберите игрока:"
PlayerListLabel.Font = Enum.Font.Gotham
PlayerListLabel.TextSize = 14
PlayerListLabel.Parent = MainFrame

local PlayerDropdown = Instance.new("TextButton")
PlayerDropdown.Size = UDim2.new(1, -20, 0, 30)
PlayerDropdown.Position = UDim2.new(0, 10, 0, 70)
PlayerDropdown.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
PlayerDropdown.TextColor3 = Color3.new(1, 1, 1)
PlayerDropdown.Text = "Нажмите для выбора"
PlayerDropdown.Font = Enum.Font.Gotham
PlayerDropdown.TextSize = 12
PlayerDropdown.Parent = MainFrame

-- Aimbot Toggle
local AimbotToggle = Instance.new("TextButton")
AimbotToggle.Size = UDim2.new(1, -20, 0, 35)
AimbotToggle.Position = UDim2.new(0, 10, 0, 110)
AimbotToggle.BackgroundColor3 = Color3.new(0.3, 0, 0)
AimbotToggle.TextColor3 = Color3.new(1, 1, 1)
AimbotToggle.Text = "AIMBOT: ВЫКЛ"
AimbotToggle.Font = Enum.Font.GothamBold
AimbotToggle.TextSize = 14
AimbotToggle.Parent = MainFrame

-- ESP Toggle
local ESPToggle = Instance.new("TextButton")
ESPToggle.Size = UDim2.new(1, -20, 0, 35)
ESPToggle.Position = UDim2.new(0, 10, 0, 155)
ESPToggle.BackgroundColor3 = Color3.new(0.3, 0, 0)
ESPToggle.TextColor3 = Color3.new(1, 1, 1)
ESPToggle.Text = "ESP: ВЫКЛ"
ESPToggle.Font = Enum.Font.GothamBold
ESPToggle.TextSize = 14
ESPToggle.Parent = MainFrame

-- Smoothness
local SmoothLabel = Instance.new("TextLabel")
SmoothLabel.Size = UDim2.new(1, -20, 0, 25)
SmoothLabel.Position = UDim2.new(0, 10, 0, 200)
SmoothLabel.BackgroundTransparency = 1
SmoothLabel.TextColor3 = Color3.new(1, 1, 1)
SmoothLabel.Text = "Плавность аима: 0.1"
SmoothLabel.Font = Enum.Font.Gotham
SmoothLabel.TextSize = 12
SmoothLabel.Parent = MainFrame

local SmoothSlider = Instance.new("TextBox")
SmoothSlider.Size = UDim2.new(1, -20, 0, 25)
SmoothSlider.Position = UDim2.new(0, 10, 0, 225)
SmoothSlider.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
SmoothSlider.TextColor3 = Color3.new(1, 1, 1)
SmoothSlider.Text = "0.1"
SmoothSlider.Font = Enum.Font.Gotham
SmoothSlider.TextSize = 12
SmoothSlider.Parent = MainFrame

-- Status
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -20, 0, 40)
StatusLabel.Position = UDim2.new(0, 10, 0, 260)
StatusLabel.BackgroundTransparency = 1
StatusLabel.TextColor3 = Color3.new(1, 1, 1)
StatusLabel.Text = "Статус: Ожидание выбора игрока"
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 12
StatusLabel.TextWrapped = true
StatusLabel.Parent = MainFrame

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(1, -20, 0, 30)
CloseButton.Position = UDim2.new(0, 10, 0, 310)
CloseButton.BackgroundColor3 = Color3.new(0.6, 0, 0)
CloseButton.TextColor3 = Color3.new(1, 1, 1)
CloseButton.Text = "ЗАКРЫТЬ"
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 14
CloseButton.Parent = MainFrame

-- Variables
local AimbotEnabled = false
local ESPEnabled = false
local TargetPlayer = nil
local Smoothness = 0.1
local ESPBoxes = {}

-- Get Players for Dropdown
function GetPlayers()
    local playerList = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(playerList, player.Name)
        end
    end
    return playerList
end

-- Aimbot Function
local AimbotConnection
function StartAimbot()
    if AimbotConnection then
        AimbotConnection:Disconnect()
    end
    
    AimbotConnection = RunService.RenderStepped:Connect(function()
        if not AimbotEnabled or not TargetPlayer then return end
        
        local targetChar = TargetPlayer.Character
        if not targetChar then return end
        
        local humanoidRootPart = targetChar:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then return end
        
        -- Smooth aim calculation
        local camera = workspace.CurrentCamera
        local cameraPosition = camera.CFrame.Position
        local targetPosition = humanoidRootPart.Position
        
        local direction = (targetPosition - cameraPosition).Unit
        local currentLook = camera.CFrame.LookVector
        local smoothDirection = currentLook:Lerp(direction, Smoothness)
        
        camera.CFrame = CFrame.new(cameraPosition, cameraPosition + smoothDirection)
    end)
end

-- ESP Function
function UpdateESP()
    -- Clear existing ESP
    for _, box in pairs(ESPBoxes) do
        box:Destroy()
    end
    ESPBoxes = {}
    
    if not ESPEnabled then return end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                -- Create ESP Box
                local espBox = Instance.new("BoxHandleAdornment")
                espBox.Name = "ESP_" .. player.Name
                espBox.Adornee = humanoidRootPart
                espBox.AlwaysOnTop = true
                espBox.ZIndex = 10
                espBox.Size = Vector3.new(3, 5, 3)
                espBox.Transparency = 0.7
                espBox.Color3 = player.Team == LocalPlayer.Team and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
                espBox.Parent = humanoidRootPart
                
                table.insert(ESPBoxes, espBox)
            end
        end
    end
end

-- Player Dropdown Menu
local DropdownOpen = false
local DropdownFrame

PlayerDropdown.MouseButton1Click:Connect(function()
    if DropdownOpen then
        if DropdownFrame then
            DropdownFrame:Destroy()
            DropdownFrame = nil
        end
        DropdownOpen = false
        return
    end
    
    DropdownOpen = true
    DropdownFrame = Instance.new("Frame")
    DropdownFrame.Size = UDim2.new(1, -20, 0, 150)
    DropdownFrame.Position = UDim2.new(0, 10, 0, 100)
    DropdownFrame.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
    DropdownFrame.BorderSizePixel = 1
    DropdownFrame.BorderColor3 = Color3.new(0, 0.5, 1)
    DropdownFrame.Parent = MainFrame
    
    local ScrollingFrame = Instance.new("ScrollingFrame")
    ScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ScrollingFrame.ScrollBarThickness = 5
    ScrollingFrame.Parent = DropdownFrame
    
    local players = GetPlayers()
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, #players * 30)
    
    for i, playerName in pairs(players) do
        local playerButton = Instance.new("TextButton")
        playerButton.Size = UDim2.new(1, -10, 0, 25)
        playerButton.Position = UDim2.new(0, 5, 0, (i-1)*30)
        playerButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
        playerButton.TextColor3 = Color3.new(1, 1, 1)
        playerButton.Text = playerName
        playerButton.Font = Enum.Font.Gotham
        playerButton.TextSize = 12
        playerButton.Parent = ScrollingFrame
        
        playerButton.MouseButton1Click:Connect(function()
            TargetPlayer = Players:FindFirstChild(playerName)
            PlayerDropdown.Text = playerName
            StatusLabel.Text = "Цель: " .. playerName
            DropdownFrame:Destroy()
            DropdownOpen = false
        end)
    end
end)

-- Toggle Aimbot
AimbotToggle.MouseButton1Click:Connect(function()
    AimbotEnabled = not AimbotEnabled
    if AimbotEnabled then
        AimbotToggle.BackgroundColor3 = Color3.new(0, 0.5, 0)
        AimbotToggle.Text = "AIMBOT: ВКЛ"
        if TargetPlayer then
            StartAimbot()
            StatusLabel.Text = "Аимбот активирован на: " .. TargetPlayer.Name
        else
            StatusLabel.Text = "Сначала выберите игрока!"
            AimbotEnabled = false
            AimbotToggle.BackgroundColor3 = Color3.new(0.3, 0, 0)
            AimbotToggle.Text = "AIMBOT: ВЫКЛ"
        end
    else
        AimbotToggle.BackgroundColor3 = Color3.new(0.3, 0, 0)
        AimbotToggle.Text = "AIMBOT: ВЫКЛ"
        StatusLabel.Text = "Аимбот выключен"
        if AimbotConnection then
            AimbotConnection:Disconnect()
        end
    end
end)

-- Toggle ESP
ESPToggle.MouseButton1Click:Connect(function()
    ESPEnabled = not ESPEnabled
    if ESPEnabled then
        ESPToggle.BackgroundColor3 = Color3.new(0, 0.5, 0)
        ESPToggle.Text = "ESP: ВКЛ"
        UpdateESP()
        StatusLabel.Text = "ESP активирован"
    else
        ESPToggle.BackgroundColor3 = Color3.new(0.3, 0, 0)
        ESPToggle.Text = "ESP: ВЫКЛ"
        UpdateESP() -- This will clear ESP
        StatusLabel.Text = "ESP выключен"
    end
end)

-- Smoothness Slider
SmoothSlider.FocusLost:Connect(function()
    local newSmooth = tonumber(SmoothSlider.Text)
    if newSmooth and newSmooth >= 0.01 and newSmooth <= 1 then
        Smoothness = newSmooth
        SmoothLabel.Text = "Плавность аима: " .. tostring(Smoothness)
    else
        SmoothSlider.Text = tostring(Smoothness)
    end
end)

-- Close Button
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    if AimbotConnection then
        AimbotConnection:Disconnect()
    end
    UpdateESP() -- Clear ESP
end)

-- Update ESP when players are added/removed
Players.PlayerAdded:Connect(UpdateESP)
Players.PlayerRemoving:Connect(UpdateESP)

print("Aimbot + ESP GUI загружен!")
print("Инструкция:")
print("1. Выберите игрока из списка")
print("2. Включите Aimbot или ESP")
print("3. Настройте плавность аима")
