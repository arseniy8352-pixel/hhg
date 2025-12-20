-- Aimbot + ESP Script for Roblox (Updated 2025)
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
local ESPObjects = {} -- Храним ESP-объекты для очистки
local UIVisible = true
local Dragging = false
local DragStartPos

-- GUI (CoreGui + ResetOnSpawn = false)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AimbotGUI"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 500)
MainFrame.Position = UDim2.new(0, 10, 0, 10)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(0, 128, 255)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 25)
TitleBar.Position = UDim2.new(0, 0, 0, 0)
TitleBar.BackgroundColor3 = Color3.fromRGB(0, 80, 160)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -30, 1, 0)
Title.Position = UDim2.new(0, 5, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Text = "AIMBOT + ESP v3.0"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 25, 0, 25)
CloseButton.Position = UDim2.new(1, -25, 0, 0)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Text = "X"
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 14
CloseButton.Parent = TitleBar

-- Content
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
PlayerListLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayerListLabel.Text = "Выберите игрока:"
PlayerListLabel.Font = Enum.Font.Gotham
PlayerListLabel.TextSize = 14
PlayerListLabel.Parent = ContentFrame

local PlayerDropdown = Instance.new("TextButton")
PlayerDropdown.Size = UDim2.new(1, -20, 0, 30)
PlayerDropdown.Position = UDim2.new(0, 10, 0, 40)
PlayerDropdown.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
PlayerDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayerDropdown.Text = "Нажмите для выбора"
PlayerDropdown.Font = Enum.Font.Gotham
PlayerDropdown.TextSize = 12
PlayerDropdown.Parent = ContentFrame


-- Aimbot Toggle
local AimbotToggle = Instance.new("TextButton")
AimbotToggle.Size = UDim2.new(1, -20, 0, 35)
AimbotToggle.Position = UDim2.new(0, 10, 0, 80)
AimbotToggle.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
AimbotToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
AimbotToggle.Text = "AIMBOT: ВЫКЛ"
AimbotToggle.Font = Enum.Font.GothamBold
AimbotToggle.TextSize = 14
AimbotToggle.Parent = ContentFrame

-- ESP Toggle
local ESPToggle = Instance.new("TextButton")
ESPToggle.Size = UDim2.new(1, -20, 0, 35)
ESPToggle.Position = UDim2.new(0, 10, 0, 125)
ESPToggle.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
ESPToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPToggle.Text = "ESP: ВЫКЛ"
ESPToggle.Font = Enum.Font.GothamBold
ESPToggle.TextSize = 14
ESPToggle.Parent = ContentFrame

-- ESP Color
local ESPColorLabel = Instance.new("TextLabel")
ESPColorLabel.Size = UDim2.new(1, -20, 0, 25)
ESPColorLabel.Position = UDim2.new(0, 10, 0, 170)
ESPColorLabel.BackgroundTransparency = 1
ESPColorLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPColorLabel.Text = "Цвет ESP:"
ESPColorLabel.Font = Enum.Font.Gotham
ESPColorLabel.TextSize = 12
ESPColorLabel.Parent = ContentFrame

local ESPColorPicker = Instance.new("TextButton")
ESPColorPicker.Size = UDim2.new(0, 80, 0, 25)
ESPColorPicker.Position = UDim2.new(0, 10, 0, 195)
ESPColorPicker.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
ESPColorPicker.TextColor3 = Color3.fromRGB(0, 0, 0)
ESPColorPicker.Text = "Красный"
ESPColorPicker.Font = Enum.Font.Gotham
ESPColorPicker.TextSize = 11
ESPColorPicker.Parent = ContentFrame

-- Distance Toggle
local ESPDistanceLabel = Instance.new("TextLabel")
ESPDistanceLabel.Size = U
