--== Booting Orion Library ==--
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/jensonhirst/Orion/main/source"))()

--== Creating Window ==--
local Window = OrionLib:MakeWindow({
    Name = "AZIZ HUB",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "AzizConfig",
    IntroEnabled = true,
    IntroText = "Aziz Hub",

    CloseCallback = function()
        -- Task Manager Kill
        flying = false
        noclip = false
        ESPEnabled = false
        invisible = false

        -- Reset ESP
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr ~= game.Players.LocalPlayer then
                if plr.Character then
                    if plr.Character:FindFirstChild("ESPHighlight") then
                        plr.Character.ESPHighlight:Destroy()
                    end
                    if plr.Character:FindFirstChild("NameTag") then
                        plr.Character.NameTag:Destroy()
                    end
                end
            end
        end

        -- Reset Invisible
        local char = game.Players.LocalPlayer.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.Transparency = 0 end
                if part:IsA("Decal") then part.Transparency = 0 end
            end
        end
    end
})

--== Creating Tabs ==--
local MainTab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-----------------------------------------------------------
---------------------- ESP SYSTEM -------------------------
-----------------------------------------------------------

local ESPEnabled = false

local function CreateESP(player)
    if not player.Character then return end

    -- Highlight
    if not player.Character:FindFirstChild("ESPHighlight") then
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESPHighlight"
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.5
        highlight.Parent = player.Character
    end

    -- Name Tag
    if not player.Character:FindFirstChild("NameTag") then
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "NameTag"
        billboard.Size = UDim2.new(0, 200, 0, 50)
        billboard.Adornee = player.Character:FindFirstChild("Head")
        billboard.AlwaysOnTop = true
        billboard.Parent = player.Character

        local text = Instance.new("TextLabel", billboard)
        text.Size = UDim2.new(1, 0, 1, 0)
        text.BackgroundTransparency = 1
        text.TextColor3 = Color3.fromRGB(255, 255, 255)
        text.TextStrokeTransparency = 0.3
        text.TextScaled = true
        text.Font = Enum.Font.GothamBold
        text.Text = player.DisplayName .. " (" .. player.Name .. ")"
    end
end

local function RemoveESP(player)
    if player.Character then
        if player.Character:FindFirstChild("ESPHighlight") then
            player.Character.ESPHighlight:Destroy()
        end
        if player.Character:FindFirstChild("NameTag") then
            player.Character.NameTag:Destroy()
        end
    end
end

MainTab:AddToggle({
    Name = "ESP Players",
    Icon = "rbxassetid://6031097221",
    Default = false,
    Callback = function(Value)
        ESPEnabled = Value
        if Value then
            for _, plr in pairs(game.Players:GetPlayers()) do
                if plr ~= game.Players.LocalPlayer then
                    CreateESP(plr)
                end
            end
        else
            for _, plr in pairs(game.Players:GetPlayers()) do
                RemoveESP(plr)
            end
        end
    end
})

-----------------------------------------------------------
---------------------- SPEED & JUMP ------------------------
-----------------------------------------------------------

MainTab:AddSlider({
    Name = "WalkSpeed",
    Icon = "rbxassetid://6022668888",
    Min = 16,
    Max = 200,
    Default = 16,
    Increment = 1,
    ValueName = "Speed",
    Callback = function(Value)
        local hum = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum then hum.WalkSpeed = Value end
    end
})

MainTab:AddSlider({
    Name = "JumpPower",
    Icon = "rbxassetid://6022668895",
    Min = 50,
    Max = 300,
    Default = 50,
    Increment = 1,
    ValueName = "Jump",
    Callback = function(Value)
        local hum = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum then hum.JumpPower = Value end
    end
})

-----------------------------------------------------------
---------------------- FULLBRIGHT --------------------------
-----------------------------------------------------------

MainTab:AddToggle({
    Name = "FullBright",
    Icon = "rbxassetid://6031090990",
    Default = false,
    Callback = function(Value)
        if Value then
            game.Lighting.Ambient = Color3.new(1,1,1)
            game.Lighting.Brightness = 5
        else
            game.Lighting.Ambient = Color3.new(0,0,0)
            game.Lighting.Brightness = 1
        end
    end
})

-----------------------------------------------------------
---------------------- FLY SYSTEM --------------------------
-----------------------------------------------------------

local flying = false
local flySpeed = 2

MainTab:AddToggle({
    Name = "Fly",
    Icon = "rbxassetid://6031091004",
    Default = false,
    Callback = function(Value)
        flying = Value
        local hum = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

        while flying do
            hum.Velocity = hum.CFrame.LookVector * flySpeed * 50
            task.wait()
        end
    end
})

MainTab:AddSlider({
    Name = "Fly Speed",
    Icon = "rbxassetid://6031091004",
    Min = 1,
    Max = 10,
    Default = 2,
    Increment = 1,
    Callback = function(Value)
        flySpeed = Value
    end
})

-----------------------------------------------------------
---------------------- NOCLIP ------------------------------
-----------------------------------------------------------

local noclip = false

MainTab:AddToggle({
    Name = "Noclip",
    Icon = "rbxassetid://6031094667",
    Default = false,
    Callback = function(Value)
        noclip = Value
        game:GetService("RunService").Stepped:Connect(function()
            if noclip then
                for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                    if v:IsA("BasePart") then v.CanCollide = false end
                end
            end
        end)
    end
})

-----------------------------------------------------------
---------------------- INVISIBLE NORMAL --------------------
-----------------------------------------------------------

local invisible = false

MainTab:AddToggle({
    Name = "إخفاء اللاعب",
    Icon = "rbxassetid://6031094670",
    Default = false,
    Callback = function(Value)
        invisible = Value
        local char = game.Players.LocalPlayer.Character

        -- تشغيل Toast Roblox الرسمي عند تشغيل الإخفاء فقط
        if Value then
            -- Toast الرسمي
            game.StarterGui:SetCore("SendNotification", {
                Title = "Aziz Hub",
                Text = "إذا ما اختفيت معنها الماب فيها حماية",
                Duration = 5
            })

            -- صوت تنبيه
            local sound = Instance.new("Sound")
            sound.SoundId = "rbxassetid://4590662766" -- صوت جميل
            sound.Volume = 1
            sound.Parent = workspace
            sound:Play()
            game.Debris:AddItem(sound, 6)
        end

        -- تنفيذ الإخفاء
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = Value and 1 or 0
                end
                if part:IsA("Decal") then
                    part.Transparency = Value and 1 or 0
                end
            end
        end
    end
})


-----------------------------------------------------------
---------------------- TELEPORT SYSTEM ---------------------
-----------------------------------------------------------

local selectedPlayer = nil

local players = {}
for _, plr in pairs(game.Players:GetPlayers()) do
    table.insert(players, plr.Name)
end

MainTab:AddDropdown({
    Name = "Select Player",
    Icon = "rbxassetid://6031094662",
    Default = "",
    Options = players,
    Callback = function(Value)
        selectedPlayer = Value
    end
})

MainTab:AddButton({
    Name = "Teleport Behind Player",
    Icon = "rbxassetid://6031094662",
    Callback = function()
        if selectedPlayer then
            local lp = game.Players.LocalPlayer
            local target = game.Players:FindFirstChild(selectedPlayer)

            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = target.Character.HumanoidRootPart
                local behind = hrp.CFrame * CFrame.new(0, 0, 4)

                local rayParams = RaycastParams.new()
                rayParams.FilterDescendantsInstances = {lp.Character}
                rayParams.FilterType = Enum.RaycastFilterType.Blacklist

                local ray = workspace:Raycast(hrp.Position, behind.Position - hrp.Position, rayParams)

                if ray then
                    lp.Character:SetPrimaryPartCFrame(hrp.CFrame * CFrame.new(0, 4, 4))
                else
                    lp.Character:SetPrimaryPartCFrame(behind + Vector3.new(0, 2, 0))
                end
            end
        end
    end
})

-----------------------------------------------------------
---------------------- ANTI AFK ----------------------------
-----------------------------------------------------------

MainTab:AddButton({
    Name = "Anti AFK",
    Icon = "rbxassetid://6031094665",
    Callback = function()
        local vu = game:GetService("VirtualUser")
        game.Players.LocalPlayer.Idled:Connect(function()
            vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            task.wait(1)
            vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        end)
    end
})

-----------------------------------------------------------
---------------------- INIT -------------------------------
-----------------------------------------------------------

OrionLib:Init()
