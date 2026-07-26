--// GUI Fly + ToastNotifications

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local uis = game:GetService("UserInputService")
local run = game:GetService("RunService")

local flying = false
local speed = 3

-- GUI
local gui = Instance.new("ScreenGui")
gui.Parent = game.CoreGui
gui.Name = "FlyGUI"

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

        -- Toast الجديد
        ToastNotifications.CreateToast({
            Title = "تم التفعيل",
            Description = "تم تشغيل الطيران بنجاح",
            Icon = "rbxassetid://6031068433",
            Sound = "rbxassetid://4590662766",
            Duration = 5
        })

    else
        flyBtn.Text = "Fly: OFF"
        bv.MaxForce = Vector3.new(0, 0, 0)

        ToastNotifications.CreateToast({
            Title = "تم الإيقاف",
            Description = "تم إيقاف الطيران",
            Icon = "rbxassetid://6031068433",
            Sound = "rbxassetid://4590662766",
            Duration = 5
        })
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
