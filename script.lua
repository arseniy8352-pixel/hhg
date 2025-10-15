-- Aimbot + ESP Script for Roblox
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Variables
local AimbotEnabled = false
local ESPEnabled = false
local TargetPlayer = nil
local Smoothness = 0.1
local ESPBoxes = {}
local UIVisible = true
local Dragging = false
local DragStartPos

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AimbotGUI"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 500)
MainFrame.Position = UDim2.new(0, 10, 0, 10)
MainFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.new(0, 0.5, 1)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Title Bar with Close Button
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 25)
TitleBar.Position = UDim2.new(0, 0, 0, 0)
TitleBar.BackgroundColor3 = Color3.new(0, 0.3, 0.6)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -30, 1, 0)
Title.Position = UDim2.new(0, 5, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Text = "AIMBOT + ESP v2.0"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 25, 0, 25)
CloseButton.Position = UDim2.new(1, -25, 0, 0)
CloseButton.BackgroundColor3 = Color3.new(0.8, 0, 0)
CloseButton.TextColor3 = Color3.new(1, 1, 1)
CloseButton.Text = "X"
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 14
CloseButton.Parent = TitleBar

-- Content Frame
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, 0, 1, -25)
ContentFrame.Position = UDim2.new(0, 0, 0, 25)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- Player List
local PlayerListLabel = Instance.new("TextLabel")
PlayerListLabel.Size = UDim2.new(1, -20, 0, 25)
PlayerListLabel.Position = UDim2.new(0, 10, 0, 10)
PlayerListLabel.BackgroundTransparency = 1
PlayerListLabel.TextColor3 = Color3.new(1, 1, 1)
PlayerListLabel.Text = "Выберите игрока:"
PlayerListLabel.Font = Enum.Font.Gotham
PlayerListLabel.TextSize = 14
PlayerListLabel.Parent = ContentFrame

local PlayerDropdown = Instance.new("TextButton")
PlayerDropdown.Size = UDim2.new(1, -20, 0, 30)
PlayerDropdown.Position = UDim2.new(0, 10, 0, 40)
PlayerDropdown.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
PlayerDropdown.TextColor3 = Color3.new(1, 1, 1)
PlayerDropdown.Text = "Нажмите для выбора"
PlayerDropdown.Font = Enum.Font.Gotham
PlayerDropdown.TextSize = 12
PlayerDropdown.Parent = ContentFrame

-- Aimbot Section
local AimbotToggle = Instance.new("TextButton")
AimbotToggle.Size = UDim2.new(1, -20, 0, 35)
AimbotToggle.Position = UDim2.new(0, 10, 0, 80)
AimbotToggle.BackgroundColor3 = Color3.new(0.3, 0, 0)
AimbotToggle.TextColor3 = Color3.new(1, 1, 1)
AimbotToggle.Text = "AIMBOT: ВЫКЛ"
AimbotToggle.Font = Enum.Font.GothamBold
AimbotToggle.TextSize = 14
AimbotToggle.Parent = ContentFrame

-- ESP Section
local ESPToggle = Instance.new("TextButton")
ESPToggle.Size = UDim2.new(1, -20, 0, 35)
ESPToggle.Position = UDim2.new(0, 10, 0, 125)
ESPToggle.BackgroundColor3 = Color3.new(0.3, 0, 0)
ESPToggle.TextColor3 = Color3.new(1, 1, 1)
ESPToggle.Text = "ESP: ВЫКЛ"
ESPToggle.Font = Enum.Font.GothamBold
ESPToggle.TextSize = 14
ESPToggle.Parent = ContentFrame

-- ESP Color Settings
local ESPColorLabel = Instance.new("TextLabel")
ESPColorLabel.Size = UDim2.new(1, -20, 0, 25)
ESPColorLabel.Position = UDim2.new(0, 10, 0, 170)
ESPColorLabel.BackgroundTransparency = 1
ESPColorLabel.TextColor3 = Color3.new(1, 1, 1)
ESPColorLabel.Text = "Цвет ESP врагов:"
ESPColorLabel.Font = Enum.Font.Gotham
ESPColorLabel.TextSize = 12
ESPColorLabel.Parent = ContentFrame

local ESPColorPicker = Instance.new("TextButton")
ESPColorPicker.Size = UDim2.new(0, 80, 0, 25)
ESPColorPicker.Position = UDim2.new(0, 10, 0, 195)
ESPColorPicker.BackgroundColor3 = Color3.new(1, 0, 0)
ESPColorPicker.TextColor3 = Color3.new(0, 0, 0)
ESPColorPicker.Text = "Красный"
ESPColorPicker.Font = Enum.Font.Gotham
ESPColorPicker.TextSize = 11
ESPColorPicker.Parent = ContentFrame

-- ESP Distance
local ESPDistanceLabel = Instance.new("TextLabel")
ESPDistanceLabel.Size = UDim2.new(1, -20, 0, 25)
ESPDistanceLabel.Position = UDim2.new(0, 10, 0, 230)
ESPDistanceLabel.BackgroundTransparency = 1
ESPDistanceLabel.TextColor3 = Color3.new(1, 1, 1)
ESPDistanceLabel.Text = "Показывать дистанцию: ВЫКЛ"
ESPDistanceLabel.Font = Enum.Font.Gotham
ESPDistanceLabel.TextSize = 12
ESPDistanceLabel.Parent = ContentFrame

local ESPDistanceToggle = Instance.new("TextButton")
ESPDistanceToggle.Size = UDim2.new(0, 60, 0, 25)
ESPDistanceToggle.Position = UDim2.new(0, 10, 0, 255)
ESPDistanceToggle.BackgroundColor3 = Color3.new(0.3, 0, 0)
ESPDistanceToggle.TextColor3 = Color3.new(1, 1, 1)
ESPDistanceToggle.Text = "ВКЛ"
ESPDistanceToggle.Font = Enum.Font.Gotham
ESPDistanceToggle.TextSize = 11
ESPDistanceToggle.Parent = ContentFrame

-- Smoothness
local SmoothLabel = Instance.new("TextLabel")
SmoothLabel.Size = UDim2.new(1, -20, 0, 25)
SmoothLabel.Position = UDim2.new(0, 10, 0, 290)
SmoothLabel.BackgroundTransparency = 1
SmoothLabel.TextColor3 = Color3.new(1, 1, 1)
SmoothLabel.Text = "Плавность аима: 0.1"
SmoothLabel.Font = Enum.Font.Gotham
SmoothLabel.TextSize = 12
SmoothLabel.Parent = ContentFrame

local SmoothSlider = Instance.new("TextBox")
SmoothSlider.Size = UDim2.new(1, -20, 0, 25)
SmoothSlider.Position = UDim2.new(0, 10, 0, 315)
SmoothSlider.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
SmoothSlider.TextColor3 = Color3.new(1, 1, 1)
SmoothSlider.Text = "0.1"
SmoothSlider.Font = Enum.Font.Gotham
SmoothSlider.TextSize = 12
SmoothSlider.Parent = ContentFrame

-- Status
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -20, 0, 50)
StatusLabel.Position = UDim2.new(0, 10, 0, 350)
StatusLabel.BackgroundTransparency = 1
StatusLabel.TextColor3 = Color3.new(1, 1, 1)
StatusLabel.Text = "Статус: Ожидание выбора игрока\nПравый Ctrl - скрыть/показать интерфейс"
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 12
StatusLabel.TextWrapped = true
StatusLabel.Parent = ContentFrame

-- ESP Variables
local ESPColors = {
    Красный = Color3.new(1, 0, 0),
    Зеленый = Color3.new(0, 1, 0),
    Синий = Color3.new(0, 0, 1),
    Желтый = Color3.new(1, 1, 0),
    Фиолетовый = Color3.new(0.5, 0, 0.5),
    Оранжевый = Color3.new(1, 0.5, 0)
}

local ESPColorNames = {"Красный", "Зеленый", "Синий", "Желтый", "Фиолетовый", "Оранжевый"}
local CurrentESPColor = 1
local ShowDistance = false
local ESPDistanceLabels = {}

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
        if box then
            box:Destroy()
        end
    end
    ESPBoxes = {}
    
    for _, labelData in pairs(ESPDistanceLabels) do
        if labelData.Connection then
            labelData.Connection:Disconnect()
        end
        if labelData.Gui and labelData.Gui.Parent then
            labelData.Gui:Destroy()
        end
    end
    ESPDistanceLabels = {}
    
    if not ESPEnabled then return end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            -- Ищем любую часть тела для ESP
            local targetPart = player.Character:FindFirstChild("HumanoidRootPart") or 
                             player.Character:FindFirstChild("Head") or
                             player.Character:FindFirstChild("Torso") or
                             player.Character:FindFirstChild("UpperTorso")
            
            if targetPart then
                -- Create ESP Box
                local espBox = Instance.new("BoxHandleAdornment")
                espBox.Name = "ESP_" .. player.Name
                espBox.Adornee = targetPart
                espBox.AlwaysOnTop = true
                espBox.ZIndex = 10
                espBox.Size = targetPart.Size + Vector3.new(0.5, 0.5, 0.5)
                espBox.Transparency = 0.7
                espBox.Color3 = player.Team == LocalPlayer.Team and Color3.new(0, 1, 0) or ESPColors[ESPColorNames[CurrentESPColor]]
                espBox.Parent = targetPart
                
                table.insert(ESPBoxes, espBox)
                
                -- Distance Label
                if ShowDistance then
                    local distanceLabel = Instance.new("BillboardGui")
                    distanceLabel.Name = "Distance_" .. player.Name
                    distanceLabel.Adornee = targetPart
                    distanceLabel.Size = UDim2.new(0, 100, 0, 40)
                    distanceLabel.StudsOffset = Vector3.new(0, 4, 0)
                    distanceLabel.AlwaysOnTop = true
                    distanceLabel.Parent = targetPart
                    
                    local label = Instance.new("TextLabel")
                    label.Size = UDim2.new(1, 0, 1, 0)
                    label.BackgroundTransparency = 1
                    label.TextColor3 = Color3.new(1, 1, 1)
                    label.TextStrokeTransparency = 0
                    label.TextStrokeColor3 = Color3.new(0, 0, 0)
                    label.Font = Enum.Font.GothamBold
                    label.TextSize = 14
                    label.Parent = distanceLabel
                    
                    -- Update distance
                    local distanceConnection
                    distanceConnection = RunService.Heartbeat:Connect(function()
                        if player.Character and LocalPlayer.Character and player.Character.Parent ~= nil then
                            local playerRoot = player.Character:FindFirstChild("HumanoidRootPart") or 
                                             player.Character:FindFirstChild("Head") or
                                             player.Character:FindFirstChild("Torso")
                            local localRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart") or 
                                            LocalPlayer.Character:FindFirstChild("Head") or
                                            LocalPlayer.Character:FindFirstChild("Torso")
                            if playerRoot and localRoot then
                                local distance = (playerRoot.Position - localRoot.Position).Magnitude
                                local steps = math.floor(distance / 3)
                                label.Text = string.format("%.1f studs\n%d steps", distance, steps)
                            else
                                label.Text = "N/A"
                            end
                        else
                            label.Text = "N/A"
                        end
                    end)
                    
                    table.insert(ESPDistanceLabels, {Gui = distanceLabel, Connection = distanceConnection})
                end
            end
        end
    end
end

-- Auto update ESP when characters appear
local function setupCharacterESP(player)
    if player.Character then
        UpdateESP()
    end
    
    player.CharacterAdded:Connect(function()
        wait(1)
        UpdateESP()
    end)
end

-- Setup ESP for existing players
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        setupCharacterESP(player)
    end
end

-- Confirmation Dialog
function ShowConfirmationDialog()
    local DialogFrame = Instance.new("Frame")
    DialogFrame.Size = UDim2.new(0, 250, 0, 120)
    DialogFrame.Position = UDim2.new(0.5, -125, 0.5, -60)
    DialogFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    DialogFrame.BorderSizePixel = 2
    DialogFrame.BorderColor3 = Color3.new(1, 0, 0)
    DialogFrame.ZIndex = 100
    DialogFrame.Parent = ScreenGui
    
    local DialogLabel = Instance.new("TextLabel")
    DialogLabel.Size = UDim2.new(1, 0, 0, 60)
    DialogLabel.Position = UDim2.new(0, 0, 0, 0)
    DialogLabel.BackgroundTransparency = 1
    DialogLabel.TextColor3 = Color3.new(1, 1, 1)
    DialogLabel.Text = "Вы уверены что хотите закрыть?\nДля повторного открытия используйте правый Ctrl"
    DialogLabel.Font = Enum.Font.Gotham
    DialogLabel.TextSize = 12
    DialogLabel.TextWrapped = true
    DialogLabel.ZIndex = 101
    DialogLabel.Parent = DialogFrame
    
    local YesButton = Instance.new("TextButton")
    YesButton.Size = UDim2.new(0, 100, 0, 30)
    YesButton.Position = UDim2.new(0, 25, 0, 70)
    YesButton.BackgroundColor3 = Color3.new(0.8, 0, 0)
    YesButton.TextColor3 = Color3.new(1, 1, 1)
    YesButton.Text = "ДА"
    YesButton.Font = Enum.Font.GothamBold
    YesButton.TextSize = 14
    YesButton.ZIndex = 101
    YesButton.Parent = DialogFrame
    
    local NoButton = Instance.new("TextButton")
    NoButton.Size = UDim2.new(0, 100, 0, 30)
    NoButton.Position = UDim2.new(0, 125, 0, 70)
    NoButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    NoButton.TextColor3 = Color3.new(1, 1, 1)
    NoButton.Text = "НЕТ"
    NoButton.Font = Enum.Font.Gotham
    NoButton.TextSize = 14
    NoButton.ZIndex = 101
    NoButton.Parent = DialogFrame
    
    YesButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
        if AimbotConnection then
            AimbotConnection:Disconnect()
        end
        for _, item in pairs(ESPDistanceLabels) do
            if item.Connection then
                item.Connection:Disconnect()
            end
        end
        UpdateESP()
    end)
    
    NoButton.MouseButton1Click:Connect(function()
        DialogFrame:Destroy()
    end)
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
    DropdownFrame.Position = UDim2.new(0, 10, 0, 70)
    DropdownFrame.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
    DropdownFrame.BorderSizePixel = 1
    DropdownFrame.BorderColor3 = Color3.new(0, 0.5, 1)
    DropdownFrame.ZIndex = 50
    DropdownFrame.Parent = ContentFrame
    
    local ScrollingFrame = Instance.new("ScrollingFrame")
    ScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ScrollingFrame.ScrollBarThickness = 5
    ScrollingFrame.ZIndex = 51
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
        playerButton.ZIndex = 52
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
        UpdateESP()
        StatusLabel.Text = "ESP выключен"
    end
end)

-- ESP Color Picker
ESPColorPicker.MouseButton1Click:Connect(function()
    CurrentESPColor = CurrentESPColor + 1
    if CurrentESPColor > #ESPColorNames then
        CurrentESPColor = 1
    end
    ESPColorPicker.Text = ESPColorNames[CurrentESPColor]
    ESPColorPicker.BackgroundColor3 = ESPColors[ESPColorNames[CurrentESPColor]]
    if ESPEnabled then
        UpdateESP()
    end
end)

-- ESP Distance Toggle
ESPDistanceToggle.MouseButton1Click:Connect(function()
    ShowDistance = not ShowDistance
    if ShowDistance then
        ESPDistanceToggle.BackgroundColor3 = Color3.new(0, 0.5, 0)
        ESPDistanceToggle.Text = "ВЫКЛ"
        ESPDistanceLabel.Text = "Показывать дистанцию: ВКЛ"
    else
        ESPDistanceToggle.BackgroundColor3 = Color3.new(0.3, 0, 0)
        ESPDistanceToggle.Text = "ВКЛ"
        ESPDistanceLabel.Text = "Показывать дистанцию: ВЫКЛ"
    end
    if ESPEnabled then
        UpdateESP()
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
    ShowConfirmationDialog()
end)

-- Hide/Show UI with Right Ctrl
UserInputService.InputBegan:Connect(function(Input)
    if Input.KeyCode == Enum.KeyCode.RightControl then
        UIVisible = not UIVisible
        MainFrame.Visible = UIVisible
    end
end)

-- Update ESP when players are added/removed
Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        setupCharacterESP(player)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    wait(0.1)
    UpdateESP()
end)

print("Aimbot + ESP GUI v2.0 загружен!")
print("Новые функции:")
print("- Управление цветом ESP")
print("- Показ дистанции и шагов")
print("- Скрытие интерфейса (Правый Ctrl)")
print("- Подтверждение закрытия")
print("- Перетаскивание окна")
print("- Исправленный ESP")
