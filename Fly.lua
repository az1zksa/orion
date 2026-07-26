--// GUI Fly + Enhanced Roblox-like Toast (Icon + Sound)

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local uis = game:GetService("UserInputService")
local run = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local flying = false
local speed = 3

-- GUI
local gui = Instance.new("ScreenGui")
gui.Parent = game.CoreGui
gui.Name = "FlyGUI"

--==========================
--== Enhanced Toast UI =====
--==========================

local toastGui = Instance.new("ScreenGui", game.CoreGui)
toastGui.Name = "ToastUI"

local function ShowToast(message)
    local toast = Instance.new("Frame")
    toast.Size = UDim2.new(0, 300, 0, 75)
    toast.Position = UDim2.new(1, -25, 1, 120)
    toast.AnchorPoint = Vector2.new(1, 1)
    toast.BackgroundColor3 = Color3.fromRGB(25, 25, 35) -- خلفية أجمل
    toast.BorderSizePixel = 0
    toast.BackgroundTransparency = 0.05
    toast.Parent = toastGui

    local corner = Instance.new("UICorner", toast)
    corner.CornerRadius = UDim.new(0, 12)

    -- Icon
    local icon = Instance.new("ImageLabel", toast)
    icon.Size = UDim2.new(0, 45, 0, 45)
    icon.Position = UDim2.new(0, 15, 0, 15)
    icon.BackgroundTransparency = 1
    icon.Image = "rbxassetid://6031071050" -- أيقونة Roblox-style جميلة

    local iconCorner = Instance.new("UICorner", icon)
    iconCorner.CornerRadius = UDim.new(0, 8)

    -- Text
    local label = Instance.new("TextLabel", toast)
    label.Size = UDim2.new(1, -80, 1, 0)
    label.Position = UDim2.new(0, 75, 0, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 17
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Text = message

    -- Sound
    local sound = Instance.new("Sound", toast)
    sound.SoundId = "rbxassetid://4590662766" -- صوت إشعار جميل
    sound.Volume = 1
    sound:Play()

    -- دخول toast
    TweenService:Create(toast, TweenInfo.new(0.35, Enum.EasingStyle.Quint), {
        Position = UDim2.new(1, -25, 1, -20)
    }):Play()

    task.wait(4)

    -- خروج toast
    TweenService:Create(toast, TweenInfo.new(0.35, Enum.EasingStyle.Quint), {
        Position = UDim2.new(1, -25, 1, 120)
    }):Play()

    task.wait(0.4)
    toast:Destroy()
end

--==========================
--== Fly GUI Buttons =======
--==========================

local function style(btn)
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 10)
end

local flyBtn = Instance.new("TextButton")
flyBtn.Parent = gui
flyBtn.Size = UDim2.new(0, 140, 0, 45)
flyBtn.Position = UDim2.new(0, 20, 0, 200)
flyBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
flyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
flyBtn.Font = Enum.Font.GothamBold
flyBtn.TextSize = 16
flyBtn.Text = "Fly: OFF"
style(flyBtn)

local speedLabel = Instance.new("TextLabel")
speedLabel.Parent = gui
speedLabel.Size = UDim2.new(0, 140, 0, 35)
speedLabel.Position = UDim2.new(0, 20, 0, 250)
speedLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.Font = Enum.Font.GothamBold
speedLabel.TextSize = 14
speedLabel.Text = "Speed: " .. speed
style(speedLabel)

local plusBtn = Instance.new("TextButton")
plusBtn.Parent = gui
plusBtn.Size = UDim2.new(0, 65, 0, 35)
plusBtn.Position = UDim2.new(0, 20, 0, 295)
plusBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
plusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
plusBtn.Font = Enum.Font.GothamBold
plusBtn.TextSize = 18
plusBtn.Text = "+"
style(plusBtn)

local minusBtn = Instance.new("TextButton")
minusBtn.Parent = gui
minusBtn.Size = UDim2.new(0, 65, 0, 35)
minusBtn.Position = UDim2.new(0, 95, 0, 295)
minusBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
minusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minusBtn.Font = Enum.Font.GothamBold
minusBtn.TextSize = 18
minusBtn.Text = "-"
style(minusBtn)

local bv = Instance.new("BodyVelocity")
bv.MaxForce = Vector3.new(0, 0, 0)
bv.Velocity = Vector3.new(0, 0, 0)
bv.Parent = hrp

--==========================
--== Fly Toggle Logic ======
--==========================

flyBtn.MouseButton1Click:Connect(function()
    flying = not flying
    if flying then
        flyBtn.Text = "Fly: ON"
        bv.MaxForce = Vector3.new(100000, 100000, 100000)
        ShowToast("تم تفعيل الطيران")
    else
        flyBtn.Text = "Fly: OFF"
        bv.MaxForce = Vector3.new(0, 0, 0)
        ShowToast("تم إيقاف الطيران")
    end
end)

plusBtn.MouseButton1Click:Connect(function()
    speed = speed + 1
    speedLabel.Text = "Speed: " .. speed
end)

minusBtn.MouseButton1Click:Connect(function()
    if speed > 1 then
        speed = speed - 1
        speedLabel.Text = "Speed: " .. speed
    end
end)

--==========================
--== Fly Movement ==========
--==========================

run.RenderStepped:Connect(function()
    if flying then
        local dir = Vector3.new(0,0,0)

        if uis:IsKeyDown(Enum.KeyCode.W) then
            dir = dir + workspace.CurrentCamera.CFrame.LookVector
        end
        if uis:IsKeyDown(Enum.KeyCode.S) then
            dir = dir - workspace.CurrentCamera.CFrame.LookVector
        end
        if uis:IsKeyDown(Enum.KeyCode.A) then
            dir = dir - workspace.CurrentCamera.CFrame.RightVector
        end
        if uis:IsKeyDown(Enum.KeyCode.D) then
            dir = dir + workspace.CurrentCamera.CFrame.RightVector
        end

        bv.Velocity = dir * speed
    end
end)
