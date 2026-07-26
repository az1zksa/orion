--==========================
--== AzizGames Fly UI (Ultra Luxury Edition)
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
gui.Name = "AzizGamesFlyUI"

-- Main Frame (Draggable)
local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 260, 0, 240)
mainFrame.Position = UDim2.new(0, 30, 0, 150)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 14)

local stroke = Instance.new("UIStroke", mainFrame)
stroke.Thickness = 3
stroke.Color = Color3.fromRGB(0, 255, 180)

local grad = Instance.new("UIGradient", mainFrame)
grad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 60))
}

--==========================
--== Drag System
--==========================

local dragging = false
local dragInput, dragStart, startPos

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

uis.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

uis.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

--==========================
--== Title
--==========================

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, -50, 0, 40)
title.Position = UDim2.new(0, 10, 0, 5)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.Text = "AzizGames Fly"

--==========================
--== Close Button (X)
--==========================

local closeBtn = Instance.new("TextButton", mainFrame)
closeBtn.Size = UDim2.new(0, 40, 0, 40)
closeBtn.Position = UDim2.new(1, -45, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 20
closeBtn.Text = "X"

Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 10)

local closeStroke = Instance.new("UIStroke", closeBtn)
closeStroke.Thickness = 2
closeStroke.Color = Color3.fromRGB(255, 50, 50)

--==========================
--== Toast System (Ultra)
--==========================

local toastGui = Instance.new("ScreenGui", game.CoreGui)
toastGui.Name = "ToastUI"

local function ShowToast(message, soundId)
    local toast = Instance.new("Frame")
    toast.Size = UDim2.new(0, 350, 0, 100)
    toast.Position = UDim2.new(1, -40, 1, 160)
    toast.AnchorPoint = Vector2.new(1, 1)
    toast.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    toast.BackgroundTransparency = 0.05
    toast.Parent = toastGui

    Instance.new("UICorner", toast).CornerRadius = UDim.new(0, 16)

    local glow = Instance.new("UIStroke", toast)
    glow.Thickness = 3
    glow.Color = Color3.fromRGB(0, 255, 200)

    local grad = Instance.new("UIGradient", toast)
    grad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 30)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 60))
    }

    -- Icon (AzizGames Logo)
    local icon = Instance.new("ImageLabel", toast)
    icon.Size = UDim2.new(0, 60, 0, 60)
    icon.Position = UDim2.new(0, 15, 0, 20)
    icon.BackgroundTransparency = 1
    icon.Image = "rbxassetid://15828140506"
    Instance.new("UICorner", icon).CornerRadius = UDim.new(0, 12)

    -- Text
    local label = Instance.new("TextLabel", toast)
    label.Size = UDim2.new(1, -100, 1, 0)
    label.Position = UDim2.new(0, 90, 0, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 18
    label.TextWrapped = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.Text = message

    -- Sound
    local sound = Instance.new("Sound", toast)
    sound.SoundId = soundId
    sound.Volume = 1
    sound:Play()

    -- Animation In
    TweenService:Create(toast, TweenInfo.new(0.45, Enum.EasingStyle.Quint), {
        Position = UDim2.new(1, -40, 1, -30)
    }):Play()

    task.wait(4)

    -- Animation Out
    TweenService:Create(toast, TweenInfo.new(0.45, Enum.EasingStyle.Quint), {
        Position = UDim2.new(1, -40, 1, 160)
    }):Play()

    task.wait(0.4)
    toast:Destroy()
end

--==========================
--== Close Button Logic
--==========================

closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()

    ShowToast(
        "شكراً على تجربتك Fly – يوماً سعيداً! – AzizGames",
        "rbxassetid://9118823102" -- صوت فاخر خاص للوداع
    )
end)

--==========================
--== Fly Buttons (Inside mainFrame)
--==========================

local flyBtn = Instance.new("TextButton", mainFrame)
flyBtn.Size = UDim2.new(0, 200, 0, 45)
flyBtn.Position = UDim2.new(0, 30, 0, 60)
flyBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
flyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
flyBtn.Font = Enum.Font.GothamBold
flyBtn.TextSize = 16
flyBtn.Text = "Fly: OFF"
Instance.new("UICorner", flyBtn).CornerRadius = UDim.new(0, 10)

local speedLabel = Instance.new("TextLabel", mainFrame)
speedLabel.Size = UDim2.new(0, 200, 0, 35)
speedLabel.Position = UDim2.new(0, 30, 0, 110)
speedLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.Font = Enum.Font.GothamBold
speedLabel.TextSize = 14
speedLabel.Text = "Speed: " .. speed
Instance.new("UICorner", speedLabel).CornerRadius = UDim.new(0, 10)

local plusBtn = Instance.new("TextButton", mainFrame)
plusBtn.Size = UDim2.new(0, 90, 0, 35)
plusBtn.Position = UDim2.new(0, 30, 0, 155)
plusBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
plusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
plusBtn.Font = Enum.Font.GothamBold
plusBtn.TextSize = 18
plusBtn.Text = "+"
Instance.new("UICorner", plusBtn).CornerRadius = UDim.new(0, 10)

local minusBtn = Instance.new("TextButton", mainFrame)
minusBtn.Size = UDim2.new(0, 90, 0, 35)
minusBtn.Position = UDim2.new(0, 140, 0, 155)
minusBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
minusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minusBtn.Font = Enum.Font.GothamBold
minusBtn.TextSize = 18
minusBtn.Text = "-"
Instance.new("UICorner", minusBtn).CornerRadius = UDim.new(0, 10)

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
        ShowToast("تم تفعيل الطيران", "rbxassetid://4590662766")
    else
        flyBtn.Text = "Fly: OFF"
        bv.MaxForce = Vector3.new(0, 0, 0)
        ShowToast("تم إيقاف الطيران", "rbxassetid://4590662766")
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
