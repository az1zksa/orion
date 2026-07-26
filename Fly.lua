--==========================
--== AzizGames Luxury Fly UI (With Drag + Close Button)
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

-- Main Frame (Draggable)
local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 200, 0, 200)
mainFrame.Position = UDim2.new(0, 20, 0, 150)
mainFrame.BackgroundTransparency = 1

-- Dragging System
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
--== Close Button (X)
--==========================

local closeBtn = Instance.new("TextButton", mainFrame)
closeBtn.Size = UDim2.new(0, 35, 0, 35)
closeBtn.Position = UDim2.new(1, -40, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 20
closeBtn.Text = "X"

Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)

local closeStroke = Instance.new("UIStroke", closeBtn)
closeStroke.Thickness = 2
closeStroke.Color = Color3.fromRGB(255, 50, 50)

--==========================
--== Toast System
--==========================

local toastGui = Instance.new("ScreenGui", game.CoreGui)
toastGui.Name = "ToastUI"

local function ShowToast(message, soundId)
    local toast = Instance.new("Frame")
    toast.Size = UDim2.new(0, 330, 0, 90)
    toast.Position = UDim2.new(1, -30, 1, 140)
    toast.AnchorPoint = Vector2.new(1, 1)
    toast.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    toast.BackgroundTransparency = 0.05
    toast.Parent = toastGui

    Instance.new("UICorner", toast).CornerRadius = UDim.new(0, 14)

    -- Glow
    local glow = Instance.new("UIStroke", toast)
    glow.Thickness = 3
    glow.Color = Color3.fromRGB(0, 255, 180)

    -- Gradient
    local grad = Instance.new("UIGradient", toast)
    grad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 30)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 60))
    }

    -- Icon
    local icon = Instance.new("ImageLabel", toast)
    icon.Size = UDim2.new(0, 55, 0, 55)
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
    sound.SoundId = soundId
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
flyBtn.Size = UDim2.new(0, 140, 0, 45)
flyBtn.Position = UDim2.new(0, 0, 0, 50)
flyBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
flyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
flyBtn.Font = Enum.Font.GothamBold
flyBtn.TextSize = 16
flyBtn.Text = "Fly: OFF"
Instance.new("UICorner", flyBtn).CornerRadius = UDim.new(0, 10)

local speedLabel = Instance.new("TextLabel", mainFrame)
speedLabel.Size = UDim2.new(0, 140, 0, 35)
speedLabel.Position = UDim2.new(0, 0, 0, 100)
speedLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.Font = Enum.Font.GothamBold
speedLabel.TextSize = 14
speedLabel.Text = "Speed: " .. speed
Instance.new("UICorner", speedLabel).CornerRadius = UDim.new(0, 10)

local plusBtn = Instance.new("TextButton", mainFrame)
plusBtn.Size = UDim2.new(0, 65, 0, 35)
plusBtn.Position = UDim2.new(0, 0, 0, 145)
plusBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
plusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
plusBtn.Font = Enum.Font.GothamBold
plusBtn.TextSize = 18
plusBtn.Text = "+"
Instance.new("UICorner", plusBtn).CornerRadius = UDim.new(0, 10)

local minusBtn = Instance.new("TextButton", mainFrame)
minusBtn.Size = UDim2.new(0, 65, 0, 35)
minusBtn.Position = UDim2.new(0, 75, 0, 145)
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
