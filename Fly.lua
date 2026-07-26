--==========================
--== AzizGames Luxury Fly UI
--==========================

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local uis = game:GetService("UserInputService")
local run = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local flying = false
local speed = 3

--==========================
--== Main GUI
--==========================

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "FlyGUI"

--==========================
--== Luxury Effects (Blur)
--==========================

local blur = Instance.new("BlurEffect", game.Lighting)
blur.Size = 0

TweenService:Create(blur, TweenInfo.new(1, Enum.EasingStyle.Quint), {
    Size = 10
}):Play()

task.wait(2)

TweenService:Create(blur, TweenInfo.new(1, Enum.EasingStyle.Quint), {
    Size = 0
}):Play()

--==========================
--== Toast System
--==========================

local toastGui = Instance.new("ScreenGui", game.CoreGui)
toastGui.Name = "ToastUI"

local function ShowToast(message)
    local toast = Instance.new("Frame")
    toast.Size = UDim2.new(0, 320, 0, 85)
    toast.Position = UDim2.new(1, -30, 1, 140)
    toast.AnchorPoint = Vector2.new(1, 1)
    toast.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    toast.BackgroundTransparency = 0.05
    toast.Parent = toastGui

    Instance.new("UICorner", toast).CornerRadius = UDim.new(0, 14)

    -- Glow
    local glow = Instance.new("UIStroke", toast)
    glow.Thickness = 2
    glow.Color = Color3.fromRGB(0, 255, 180)
    glow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    -- Gradient
    local grad = Instance.new("UIGradient", toast)
    grad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 30)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 60))
    }

    -- Icon
    local icon = Instance.new("ImageLabel", toast)
    icon.Size = UDim2.new(0, 50, 0, 50)
    icon.Position = UDim2.new(0, 15, 0, 17)
    icon.BackgroundTransparency = 1
    icon.Image = "rbxassetid://6031068437"
    Instance.new("UICorner", icon).CornerRadius = UDim.new(0, 10)

    -- Text
    local label = Instance.new("TextLabel", toast)
    label.Size = UDim2.new(1, -80, 1, 0)
    label.Position = UDim2.new(0, 75, 0, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 18
    label.Text = message

    -- Sound
    local sound = Instance.new("Sound", toast)
    sound.SoundId = "rbxassetid://4590662766"
    sound.Volume = 1
    sound:Play()

    -- Animation In
    TweenService:Create(toast, TweenInfo.new(0.35, Enum.EasingStyle.Quint), {
        Position = UDim2.new(1, -30, 1, -25)
    }):Play()

    task.wait(4)

    -- Animation Out
    TweenService:Create(toast, TweenInfo.new(0.35, Enum.EasingStyle.Quint), {
        Position = UDim2.new(1, -30, 1, 140)
    }):Play()

    task.wait(0.4)
    toast:Destroy()
end

--==========================
--== Luxury Welcome Screen
--==========================

local welcome = Instance.new("Frame", toastGui)
welcome.Size = UDim2.new(0, 380, 0, 120)
welcome.Position = UDim2.new(0.5, 0, 0.5, 0)
welcome.AnchorPoint = Vector2.new(0.5, 0.5)
welcome.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
welcome.BackgroundTransparency = 0.05

Instance.new("UICorner", welcome).CornerRadius = UDim.new(0, 20)

-- Glow
local wGlow = Instance.new("UIStroke", welcome)
wGlow.Thickness = 3
wGlow.Color = Color3.fromRGB(0, 255, 200)

-- Gradient
local wGrad = Instance.new("UIGradient", welcome)
wGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 50, 80))
}

-- Icon
local wIcon = Instance.new("ImageLabel", welcome)
wIcon.Size = UDim2.new(0, 60, 0, 60)
wIcon.Position = UDim2.new(0, 20, 0, 30)
wIcon.BackgroundTransparency = 1
wIcon.Image = "rbxassetid://15828140506"
Instance.new("UICorner", wIcon).CornerRadius = UDim.new(0, 12)

-- Title
local wTitle = Instance.new("TextLabel", welcome)
wTitle.Size = UDim2.new(1, -100, 0, 40)
wTitle.Position = UDim2.new(0, 100, 0, 10)
wTitle.BackgroundTransparency = 1
wTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
wTitle.Font = Enum.Font.GothamBold
wTitle.TextSize = 22
wTitle.Text = "مرحباً في Fly"

-- Desc
local wDesc = Instance.new("TextLabel", welcome)
wDesc.Size = UDim2.new(1, -100, 0, 40)
wDesc.Position = UDim2.new(0, 100, 0, 55)
wDesc.BackgroundTransparency = 1
wDesc.TextColor3 = Color3.fromRGB(200, 200, 200)
wDesc.Font = Enum.Font.Gotham
wDesc.TextSize = 16
wDesc.Text = "من صنع AzizGames – استمتع بأقوى واجهة فاخرة!"

-- Sound (Luxury)
local wSound = Instance.new("Sound", welcome)
wSound.SoundId = "rbxassetid://9118823102" -- صوت فاخر
wSound.Volume = 1
wSound:Play()

-- Animation
welcome.Size = UDim2.new(0, 0, 0, 0)
TweenService:Create(welcome, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {
    Size = UDim2.new(0, 380, 0, 120)
}):Play()

task.wait(4)

TweenService:Create(welcome, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {
    Size = UDim2.new(0, 0, 0, 0)
}):Play()

task.wait(0.5)
welcome:Destroy()

--==========================
--== Buttons
--==========================

local function style(btn)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

    local stroke = Instance.new("UIStroke", btn)
    stroke.Thickness = 2
    stroke.Color = Color3.fromRGB(0, 255, 180)
end

local flyBtn = Instance.new("TextButton", gui)
flyBtn.Size = UDim2.new(0, 140, 0, 45)
flyBtn.Position = UDim2.new(0, 20, 0, 200)
flyBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
flyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
flyBtn.Font = Enum.Font.GothamBold
flyBtn.TextSize = 16
flyBtn.Text = "Fly: OFF"
style(flyBtn)

local speedLabel = Instance.new("TextLabel", gui)
speedLabel.Size = UDim2.new(0, 140, 0, 35)
speedLabel.Position = UDim2.new(0, 20, 0, 250)
speedLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.Font = Enum.Font.GothamBold
speedLabel.TextSize = 14
speedLabel.Text = "Speed: " .. speed
style(speedLabel)

local plusBtn = Instance.new("TextButton", gui)
plusBtn.Size = UDim2.new(0, 65, 0, 35)
plusBtn.Position = UDim2.new(0, 20, 0, 295)
plusBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
plusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
plusBtn.Font = Enum.Font.GothamBold
plusBtn.TextSize = 18
plusBtn.Text = "+"
style(plusBtn)

local minusBtn = Instance.new("TextButton", gui)
minusBtn.Size = UDim2.new(0, 65, 0, 35)
minusBtn.Position = UDim2.new(0, 95, 0, 295)
minusBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
minusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minusBtn.Font = Enum.Font.GothamBold
minusBtn.TextSize = 18
minusBtn.Text = "-"
style(minusBtn)

--==========================
--== Fly Logic
--==========================

local bv = Instance.new("BodyVelocity", hrp)
bv.MaxForce = Vector3.new(0, 0, 0)

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
