--// GUI Fly + Roblox-like Toast (Icon + Sound)

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
--== Roblox-like Toast UI ==
--==========================

local toastGui = Instance.new("ScreenGui", game.CoreGui)
toastGui.Name = "ToastUI"

local function ShowToast(message)
    local toast = Instance.new("Frame")
    toast.Size = UDim2.new(0, 260, 0, 60)
    toast.Position = UDim2.new(1, -20, 1, 80) -- تحت يمين
    toast.AnchorPoint = Vector2.new(1, 1)
    toast.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    toast.BorderSizePixel = 0
    toast.BackgroundTransparency = 0.1
    toast.Parent = toastGui

    local corner = Instance.new("UICorner", toast)
    corner.CornerRadius = UDim.new(0, 10)

    -- Icon
    local icon = Instance.new("ImageLabel", toast)
    icon.Size = UDim2.new(0, 40, 0, 40)
    icon.Position = UDim2.new(0, 10, 0, 10)
    icon.BackgroundTransparency = 1
    icon.Image = "rbxassetid://119290557148033" -- أيقونة جميلة

    -- Text
    local label = Instance.new("TextLabel", toast)
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 60, 0, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Text = message

    -- Sound
    local sound = Instance.new("Sound", toast)
    sound.SoundId = "rbxassetid://138118203571469" -- صوت إشعار جميل
    sound.Volume = 1
    sound:Play()

    -- دخول toast (يصعد لفوق)
    TweenService:Create(toast, TweenInfo.new(0.35, Enum.EasingStyle.Quint), {
        Position = UDim2.new(1, -20, 1, -10)
    }):Play()

    task.wait(5)

    -- خروج toast (ينزل لتحت)
    TweenService:Create(toast, TweenInfo.new(0.35, Enum.EasingStyle.Quint), {
        Position = UDim2.new(1, -20, 1, 80)
    }):Play()

    task.wait(0.4)
    toast:Destroy()
end

--==========================
--== Fly GUI Buttons =======
--==========================

local flyBtn = Instance.new("TextButton")
flyBtn.Parent = gui
flyBtn.Size = UDim2.new(0, 120, 0, 40)
flyBtn.Position = UDim2.new(0, 20, 0, 200)
flyBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
flyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
flyBtn.Font = Enum.Font.GothamBold
flyBtn.TextSize = 16
flyBtn.Text = "Fly: OFF"

local speedLabel = Instance.new("TextLabel")
speedLabel.Parent = gui
speedLabel.Size = UDim2.new(0, 120, 0, 30)
speedLabel.Position = UDim2.new(0, 20, 0, 245)
speedLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.Font = Enum.Font.GothamBold
speedLabel.TextSize = 14
speedLabel.Text = "Speed: " .. speed

local plusBtn = Instance.new("TextButton")
plusBtn.Parent = gui
plusBtn.Size = UDim2.new(0, 55, 0, 30)
plusBtn.Position = UDim2.new(0, 20, 0, 280)
plusBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
plusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
plusBtn.Font = Enum.Font.GothamBold
plusBtn.TextSize = 18
plusBtn.Text = "+"

local minusBtn = Instance.new("TextButton")
minusBtn.Parent = gui
minusBtn.Size = UDim2.new(0, 55, 0, 30)
minusBtn.Position = UDim2.new(0, 85, 0, 280)
minusBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
minusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minusBtn.Font = Enum.Font.GothamBold
minusBtn.TextSize = 18
minusBtn.Text = "-"

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
        ShowToast("Fly تم تفعيله")
    else
        flyBtn.Text = "Fly: OFF"
        bv.MaxForce = Vector3.new(0, 0, 0)
        ShowToast("Fly تم إيقافه")
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
