--// GUI Fly Script (Simple & Safe)

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

local button = Instance.new("TextButton")
button.Parent = gui
button.Size = UDim2.new(0, 120, 0, 40)
button.Position = UDim2.new(0, 20, 0, 200)
button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Font = Enum.Font.GothamBold
button.TextSize = 16
button.Text = "Fly: OFF"

local bv = Instance.new("BodyVelocity")
bv.MaxForce = Vector3.new(0, 0, 0)
bv.Velocity = Vector3.new(0, 0, 0)
bv.Parent = hrp

button.MouseButton1Click:Connect(function()
    flying = not flying
    if flying then
        button.Text = "Fly: ON"
        bv.MaxForce = Vector3.new(100000, 100000, 100000)
    else
        button.Text = "Fly: OFF"
        bv.MaxForce = Vector3.new(0, 0, 0)
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
