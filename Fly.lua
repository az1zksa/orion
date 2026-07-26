--==========================
--== Fly GUI + Toast + R6 ==
--==========================

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local uis = game:GetService("UserInputService")
local run = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local flying = false
local r6Active = false
local speed = 1

--==========================
--== GUI ====================
--==========================

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "FlyGUI"

local function style(btn)
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 10)
end

local flyBtn = Instance.new("TextButton", gui)
flyBtn.Size = UDim2.new(0, 140, 0, 45)
flyBtn.Position = UDim2.new(0, 20, 0, 200)
flyBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
flyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
flyBtn.Font = Enum.Font.GothamBold
flyBtn.TextSize = 16
flyBtn.Text = "Fly: OFF"
style(flyBtn)

local speedLabel = Instance.new("TextLabel", gui)
speedLabel.Size = UDim2.new(0, 140, 0, 35)
speedLabel.Position = UDim2.new(0, 20, 0, 250)
speedLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.Font = Enum.Font.GothamBold
speedLabel.TextSize = 14
speedLabel.Text = "Speed: " .. speed
style(speedLabel)

local plusBtn = Instance.new("TextButton", gui)
plusBtn.Size = UDim2.new(0, 65, 0, 35)
plusBtn.Position = UDim2.new(0, 20, 0, 295)
plusBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
plusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
plusBtn.Font = Enum.Font.GothamBold
plusBtn.TextSize = 18
plusBtn.Text = "+"
style(plusBtn)

local minusBtn = Instance.new("TextButton", gui)
minusBtn.Size = UDim2.new(0, 65, 0, 35)
minusBtn.Position = UDim2.new(0, 95, 0, 295)
minusBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
minusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minusBtn.Font = Enum.Font.GothamBold
minusBtn.TextSize = 18
minusBtn.Text = "-"
style(minusBtn)

--==========================
--== Toast UI ==============
--==========================

local toastGui = Instance.new("ScreenGui", game.CoreGui)
toastGui.Name = "ToastUI"

local function ShowToast(message)
    local toast = Instance.new("Frame")
    toast.Size = UDim2.new(0, 300, 0, 75)
    toast.Position = UDim2.new(1, -25, 1, 120)
    toast.AnchorPoint = Vector2.new(1, 1)
    toast.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    toast.BackgroundTransparency = 0.05
    toast.Parent = toastGui

    Instance.new("UICorner", toast).CornerRadius = UDim.new(0, 12)

    local icon = Instance.new("ImageLabel", toast)
    icon.Size = UDim2.new(0, 45, 0, 45)
    icon.Position = UDim2.new(0, 15, 0, 15)
    icon.BackgroundTransparency = 1
    icon.Image = "rbxassetid://15828140506"
    Instance.new("UICorner", icon).CornerRadius = UDim.new(0, 8)

    local label = Instance.new("TextLabel", toast)
    label.Size = UDim2.new(1, -80, 1, 0)
    label.Position = UDim2.new(0, 75, 0, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 17
    label.Text = message

    local sound = Instance.new("Sound", toast)
    sound.SoundId = "rbxassetid://4590662766"
    sound.Volume = 1
    sound:Play()

    TweenService:Create(toast, TweenInfo.new(0.35, Enum.EasingStyle.Quint), {
        Position = UDim2.new(1, -25, 1, -20)
    }):Play()

    task.wait(4)

    TweenService:Create(toast, TweenInfo.new(0.35, Enum.EasingStyle.Quint), {
        Position = UDim2.new(1, -25, 1, 120)
    }):Play()

    task.wait(0.4)
    toast:Destroy()
end

--==========================
--== R6 FLY SYSTEM =========
--==========================

local function StartR6Fly()
    local plr = player
    local torso = plr.Character:FindFirstChild("Torso")
    if not torso then return end

    r6Active = true

    local ctrl = {f = 0, b = 0, l = 0, r = 0}
    local lastctrl = {f = 0, b = 0, l = 0, r = 0}
    local maxspeed = 50
    local curspeed = 0

    local bg = Instance.new("BodyGyro", torso)
    bg.P = 9e4
    bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
    bg.cframe = torso.CFrame

    local bv = Instance.new("BodyVelocity", torso)
    bv.velocity = Vector3.new(0, 0.1, 0)
    bv.maxForce = Vector3.new(9e9, 9e9, 9e9)

    plr.Character.Humanoid.PlatformStand = true

    -- KEYBOARD CONTROL
    uis.InputBegan:Connect(function(key)
        if not r6Active then return end
        if key.KeyCode == Enum.KeyCode.W then ctrl.f = speed end
        if key.KeyCode == Enum.KeyCode.S then ctrl.b = -speed end
        if key.KeyCode == Enum.KeyCode.A then ctrl.l = -speed end
        if key.KeyCode == Enum.KeyCode.D then ctrl.r = speed end
    end)

    uis.InputEnded:Connect(function(key)
        if not r6Active then return end
        if key.KeyCode == Enum.KeyCode.W then ctrl.f = 0 end
        if key.KeyCode == Enum.KeyCode.S then ctrl.b = 0 end
        if key.KeyCode == Enum.KeyCode.A then ctrl.l = 0 end
        if key.KeyCode == Enum.KeyCode.D then ctrl.r = 0 end
    end)

    -- MAIN LOOP
    spawn(function()
        while r6Active do
            run.RenderStepped:Wait()

            if ctrl.f ~= 0 or ctrl.b ~= 0 or ctrl.l ~= 0 or ctrl.r ~= 0 then
                curspeed = curspeed + 0.5 + (curspeed / maxspeed)
                if curspeed > maxspeed then curspeed = maxspeed end
            elseif curspeed ~= 0 then
                curspeed = curspeed - 1
                if curspeed < 0 then curspeed = 0 end
            end

            if ctrl.f ~= 0 or ctrl.b ~= 0 or ctrl.l ~= 0 or ctrl.r ~= 0 then
                bv.velocity =
                    ((workspace.CurrentCamera.CFrame.LookVector * (ctrl.f + ctrl.b)) +
                    ((workspace.CurrentCamera.CFrame * CFrame.new(ctrl.l + ctrl.r, (ctrl.f + ctrl.b) * .2, 0).p)
                    - workspace.CurrentCamera.CFrame.p)) * curspeed

                lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
            elseif curspeed ~= 0 then
                bv.velocity =
                    ((workspace.CurrentCamera.CFrame.LookVector * (lastctrl.f + lastctrl.b)) +
                    ((workspace.CurrentCamera.CFrame * CFrame.new(lastctrl.l + lastctrl.r, (lastctrl.f + lastctrl.b) * .2, 0).p)
                    - workspace.CurrentCamera.CFrame.p)) * curspeed
            else
                bv.velocity = Vector3.new(0, 0, 0)
            end

            bg.cframe = workspace.CurrentCamera.CFrame *
                CFrame.Angles(-math.rad((ctrl.f + ctrl.b) * 50 * curspeed / maxspeed), 0, 0)
        end

        bg:Destroy()
        bv:Destroy()
        plr.Character.Humanoid.PlatformStand = false
    end)
end

local function StopR6Fly()
    r6Active = false
end

--==========================
--== BUTTON LOGIC ==========
--==========================

flyBtn.MouseButton1Click:Connect(function()
    flying = not flying

    if flying then
        flyBtn.Text = "Fly: ON"
        ShowToast("تم تفعيل الطيران")
        StartR6Fly()
    else
        flyBtn.Text = "Fly: OFF"
        ShowToast("تم إيقاف الطيران")
        StopR6Fly()
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
