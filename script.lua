-- Simple Aimbot + ESP for Roblox
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Create GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 200)
MainFrame.Position = UDim2.new(0, 10, 0, 10)
MainFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.new(0, 0.5, 1)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.new(0, 0.3, 0.6)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Text = "SIMPLE AIMBOT + ESP"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.Parent = MainFrame

-- Aimbot Toggle
local AimbotToggle = Instance.new("TextButton")
AimbotToggle.Size = UDim2.new(1, -20, 0, 35)
AimbotToggle.Position = UDim2.new(0, 10, 0, 40)
AimbotToggle.BackgroundColor3 = Color3.new(0.3, 0, 0)
AimbotToggle.TextColor3 = Color3.new(1, 1, 1)
AimbotToggle.Text = "AIMBOT: OFF"
AimbotToggle.Font = Enum.Font.GothamBold
AimbotToggle.TextSize = 14
AimbotToggle.Parent = MainFrame

-- ESP Toggle
local ESPToggle = Instance.new("TextButton")
ESPToggle.Size = UDim2.new(1, -20, 0, 35)
ESPToggle.Position = UDim2.new(0, 10, 0, 85)
ESPToggle.BackgroundColor3 = Color3.new(0.3, 0, 0)
ESPToggle.TextColor3 = Color3.new(1, 1, 1)
ESPToggle.Text = "ESP: OFF"
ESPToggle.Font = Enum.Font.GothamBold
ESPToggle.TextSize = 14
ESPToggle.Parent = MainFrame

-- Status
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -20, 0, 40)
StatusLabel.Position = UDim2.new(0, 10, 0, 130)
StatusLabel.BackgroundTransparency = 1
StatusLabel.TextColor3 = Color3.new(1, 1, 1)
StatusLabel.Text = "Status: Ready\nRight Ctrl - Hide/Show"
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 12
StatusLabel.TextWrapped = true
StatusLabel.Parent = MainFrame

-- Variables
local AimbotEnabled = false
local ESPEnabled = false
local TargetPlayer = nil
local ESPBoxes = {}

-- Simple ESP Function
function UpdateESP()
    -- Clear old ESP
    for _, box in pairs(ESPBoxes) do
        if box then
            box:Destroy()
        end
    end
    ESPBoxes = {}
    
    if not ESPEnabled then return end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                local espBox = Instance.new("BoxHandleAdornment")
                espBox.Adornee = humanoidRootPart
                espBox.AlwaysOnTop = true
                espBox.Size = Vector3.new(4, 6, 4)
                espBox.Transparency = 0.7
                espBox.Color3 = player.Team == LocalPlayer.Team and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
                espBox.Parent = humanoidRootPart
                
                table.insert(ESPBoxes, espBox)
            end
        end
    end
end

-- Simple Aimbot Function
local AimbotConnection
function StartAimbot()
    if AimbotConnection then
        AimbotConnection:Disconnect()
    end
    
    -- Find closest player
    local closestPlayer = nil
    local closestDistance = math.huge
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart and LocalPlayer.Character then
                local localRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if localRoot then
                    local distance = (humanoidRootPart.Position - localRoot.Position).Magnitude
                    if distance < closestDistance then
                        closestDistance = distance
                        closestPlayer = player
                    end
                end
            end
        end
    end
    
    TargetPlayer = closestPlayer
    if not TargetPlayer then return end
    
    AimbotConnection = RunService.RenderStepped:Connect(function()
        if not AimbotEnabled or not TargetPlayer then return end
        
        local targetChar = TargetPlayer.Character
        if not targetChar then return end
        
        local humanoidRootPart = targetChar:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then return end
        
        local camera = workspace.CurrentCamera
        local cameraPosition = camera.CFrame.Position
        local targetPosition = humanoidRootPart.Position + Vector3.new(0, 2, 0) -- Aim at head level
        
        camera.CFrame = CFrame.new(cameraPosition, targetPosition)
    end)
end

-- Toggle Aimbot
AimbotToggle.MouseButton1Click:Connect(function()
    AimbotEnabled = not AimbotEnabled
    if AimbotEnabled then
        AimbotToggle.BackgroundColor3 = Color3.new(0, 0.5, 0)
        AimbotToggle.Text = "AIMBOT: ON"
        StartAimbot()
        StatusLabel.Text = "Aimbot: Tracking closest player"
    else
        AimbotToggle.BackgroundColor3 = Color3.new(0.3, 0, 0)
        AimbotToggle.Text = "AIMBOT: OFF"
        StatusLabel.Text = "Aimbot: Off"
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
        ESPToggle.Text = "ESP: ON"
        UpdateESP()
        StatusLabel.Text = "ESP: On - Players highlighted"
    else
        ESPToggle.BackgroundColor3 = Color3.new(0.3, 0, 0)
        ESPToggle.Text = "ESP: OFF"
        UpdateESP()
        StatusLabel.Text = "ESP: Off"
    end
end)

-- Hide/Show UI
UserInputService.InputBegan:Connect(function(Input)
    if Input.KeyCode == Enum.KeyCode.RightControl then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- Update ESP when players change
Players.PlayerAdded:Connect(UpdateESP)
Players.PlayerRemoving:Connect(UpdateESP)

-- Auto update ESP when characters spawn
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        player.CharacterAdded:Connect(UpdateESP)
    end
end

print("Simple Aimbot + ESP loaded!")
print("Features:")
print("- Auto aim at closest player")
print("- ESP highlight enemies (red) and teammates (green)")
print("- Right Ctrl to hide/show interface")
print("- Draggable window")
