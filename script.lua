-- Aimbot + ESP (Roblox, 2025)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Настройки
local Aimbot = {
    Enabled = false,
    Target = nil,
    Smoothness = 0.1,
    FOV = 100 -- радиус захвата цели (в studs)
}

local ESP = {
    Enabled = false,
    Color = Color3.fromRGB(255, 0, 0),
    ShowDistance = false
}

-- GUI
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
ScreenGui.Name = "CheatGUI"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Position = UDim2.new(0.02, 0, 0.5, 0)
MainFrame.AnchorPoint = Vector2.new(0, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(0, 150, 255)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, 0, -30)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Text = "AIMBOT + ESP"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.Parent = MainFrame

-- Кнопки управления
local AimbotBtn = Instance.new("TextButton")
AimbotBtn.Size = UDim2.new(0.9, 0, 0, 40)
AimbotBtn.Position = UDim2.new(0.05, 0, 0.15, 0)
AimbotBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
AimbotBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AimbotBtn.Text = "Aimbot: OFF"
AimbotBtn.Font = Enum.Font.Gotham
AimbotBtn.TextSize = 14
AimbotBtn.Parent = MainFrame

local ESPBtn = Instance.new("TextButton")
ESPBtn.Size = UDim2.new(0.9, 0, 0, 40)
ESPBtn.Position = UDim2.new(0.05, 0, 0.3, 0)
ESPBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ESPBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPBtn.Text = "ESP: OFF"
ESPBtn.Font = Enum.Font.Gotham
ESPBtn.TextSize = 14
ESPBtn.Parent = MainFrame


-- Выбор цели
local TargetLabel = Instance.new("TextLabel")
TargetLabel.Size = UDim2.new(0.9, 0, 0, 30)
TargetLabel.Position = UDim2.new(0.05, 0, 0.45, 0)
TargetLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TargetLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TargetLabel.Text = "Target: None"
TargetLabel.Font = Enum.Font.Gotham
TargetLabel.TextSize = 12
TargetLabel.Parent = MainFrame

-- Функции

local function GetNearestPlayer()
    local nearest, distance = nil, Aimbot.FOV
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local root = player.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local dist = (root.Position - LocalPlayer.Character.HumanoidRootPart.Position).magnitude
                if dist < distance then
                    nearest, distance = player, dist
                end
            end
        end
    end
    return nearest
end

local function UpdateAimbot()
    if not Aimbot.Enabled or not LocalPlayer.Character then return end
    
    Aimbot.Target = GetNearestPlayer()
    if Aimbot.Target then
        TargetLabel.Text = "Target: " .. Aimbot.Target.Name
        
        local targetRoot = Aimbot.Target.Character:FindFirstChild("HumanoidRootPart")
        if targetRoot then
            local direction = (targetRoot.Position - Camera.CFrame.Position).unit
            local newCFrame = CFrame.lookAt(Camera.CFrame.Position, Camera.CFrame.Position + direction)
            Camera.CFrame = Camera.CFrame:Lerp(newCFrame, Aimbot.Smoothness)
        end
    else
        TargetLabel.Text = "Target: None (Out of FOV)"
    end
end

local ESPObjects = {}
local function UpdateESP()
    -- Очищаем старые объекты
    for obj in ipairs(ESPObjects) do
        obj:Destroy()
    end
    ESPObjects = {}
    
    if not ESP.Enabled then return end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local head = player.Character:FindFirstChild("Head")
            if head then
                -- Создаём визуал ESP
                local box = Instance.new("BoxHandleAdornment")
                box.Adornee = head
                box.AlwaysOnTop = true
                box.ZIndex = 10
                box.Size = Vector3.new(2, 2, 2)
                box.Color3 = ESP.Color
                box.Transparency = 0.5
                box.Parent = workspace
                table.insert(ESPObjects, box)

                if ESP.ShowDistance then
                    local distance = (head.Position - LocalPlayer.Character.Head.Position).magnitude
                    local label = Instance.new("BillboardGui")
                    label.Adornee = head
                    label.Size = UDim2.new(0, 100, 0, 30)
                    label.StudsOffset = Vector3.new(0, 2, 0)
                    label.AlwaysOnTop = true
                    label.Parent = workspace

                    local text = Instance.new("TextLabel")
                    text.Size = UDim2.new(1, 0, 1, 0)
                    text.BackgroundTransparency = 1
                    text.TextColor3 = ESP.Color
                    text.Text = string.format("%.1f studs", distance)
                    text.Font = Enum.Font.SourceSans
                    text.TextSize = 14
                    text.Parent = label
                    table.insert(ESPObjects, label)
                end
            end
        end
    end
end

-- Обработчики событий
AimbotBtn.MouseButton1Click:Connect(function()
    Aimbot.Enabled = not Aimbot.Enabled
    AimbotBtn.Text = "Aimbot: " .. (Aimbot.Enabled and "ON! or "
