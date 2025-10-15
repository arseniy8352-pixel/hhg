-- Автокликер для Roblox (работает только в игре)
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

local AutoClicker = {
    Enabled = false,
    Interval = 0.1,
    Connection = nil
}

-- GUI интерфейс
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoClickerGUI"
ScreenGui.Parent = Player.PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 250)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -125)
MainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.new(1, 0, 0)
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.new(1, 0, 0)
Title.Text = "АВТОМАТИЗАТОР КЛИКОВ"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.Parent = MainFrame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -20, 0, 30)
StatusLabel.Position = UDim2.new(0, 10, 0, 50)
StatusLabel.BackgroundTransparency = 1
StatusLabel.TextColor3 = Color3.new(1, 0, 0)
StatusLabel.Text = "Статус: ВЫКЛЮЧЕНО"
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 14
StatusLabel.Parent = MainFrame

-- Кнопка запуска
local StartButton = Instance.new("TextButton")
StartButton.Size = UDim2.new(0, 80, 0, 30)
StartButton.Position = UDim2.new(0, 20, 0, 100)
StartButton.BackgroundColor3 = Color3.new(1, 0, 0)
StartButton.TextColor3 = Color3.new(0, 0, 0)
StartButton.Text = "ЗАПУСТИТЬ"
StartButton.Font = Enum.Font.GothamBold
StartButton.TextSize = 12
StartButton.Parent = MainFrame

-- Кнопка остановки
local StopButton = Instance.new("TextButton")
StopButton.Size = UDim2.new(0, 80, 0, 30)
StopButton.Position = UDim2.new(0, 110, 0, 100)
StopButton.BackgroundColor3 = Color3.new(0.3, 0, 0)
StopButton.TextColor3 = Color3.new(1, 1, 1)
StopButton.Text = "ОСТАНОВИТЬ"
StopButton.Font = Enum.Font.Gotham
StopButton.TextSize = 12
StopButton.Visible = false
StopButton.Parent = MainFrame

-- Функция автоклика
function AutoClicker:StartClicking()
    if self.Enabled then return end
    
    self.Enabled = true
    StatusLabel.Text = "Статус: РАБОТАЕТ"
    StartButton.Visible = false
    StopButton.Visible = true
    
    self.Connection = game:GetService("RunService").Heartbeat:Connect(function()
        if self.Enabled and Mouse.Target then
            -- Имитация клика по объекту
            local Target = Mouse.Target
            if Target then
                -- Здесь можно добавить взаимодействие с объектом
                print("Клик по: " .. Target.Name)
            end
            wait(self.Interval)
        end
    end)
end

function AutoClicker:StopClicking()
    if not self.Enabled then return end
    
    self.Enabled = false
    StatusLabel.Text = "Статус: ВЫКЛЮЧЕНО"
    StartButton.Visible = true
    StopButton.Visible = false
    
    if self.Connection then
        self.Connection:Disconnect()
        self.Connection = nil
    end
end

-- Обработчики кнопок
StartButton.MouseButton1Click:Connect(function()
    AutoClicker:StartClicking()
end)

StopButton.MouseButton1Click:Connect(function()
    AutoClicker:StopClicking()
end)

-- Горячая клавиша (F2)
game:GetService("UserInputService").InputBegan:Connect(function(Input)
    if Input.KeyCode == Enum.KeyCode.F2 then
        if AutoClicker.Enabled then
            AutoClicker:StopClicking()
        else
            AutoClicker:StartClicking()
        end
    end
end)

print("Автокликер загружен! Нажмите F2 для управления")