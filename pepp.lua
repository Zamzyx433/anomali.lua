local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

getgenv().Settings = {
    AutoParry = true,
    SpamAttack = true,
    ParryDistance = 22,
    Prediction = true,
    SpamSpeed = 0.08,
    Cooldown = 0.2
}

-- Improved Auto Parry System
local function AutoParry()
    local lastParry = 0
    local function parryCheck()
        if not Settings.AutoParry then return end
        local now = tick()
        
        local ball = workspace:FindFirstChild("Ball") or workspace:FindFirstChild("Projectile")
        if ball and ball:FindFirstChild("Velocity") then
            local ballVelocity = ball.Velocity
            local distance = (ball.Position - character.HumanoidRootPart.Position).Magnitude
            local travelTime = distance / ballVelocity.Magnitude
            
            -- Prediction calculation
            if Settings.Prediction then
                local predictedPosition = ball.Position + (ballVelocity.Unit * (travelTime * 0.45))
                distance = (predictedPosition - character.HumanoidRootPart.Position).Magnitude
            end
            
            if distance < Settings.ParryDistance and (now - lastParry) > Settings.Cooldown then
                lastParry = now
                game:GetService("ReplicatedStorage").Events.Parry:FireServer()
                task.wait(Settings.Cooldown)
            end
        end
    end

    RunService.Heartbeat:Connect(parryCheck)
end

-- Faster Spam System
local function FastSpam()
    while Settings.SpamAttack do
        game:GetService("ReplicatedStorage").Events.Slash:FireServer(true)
        game:GetService("ReplicatedStorage").Events.Slash:FireServer(false)
        task.wait(Settings.SpamSpeed)
    end
end

-- UI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/UI-Libs/main/Vape.txt"))()
local Window = Library:Window("Blade Ball Enhanced",Color3.fromRGB(44, 120, 224))

local MainTab = Window:Tab("Main")
MainTab:Toggle({
    Name = "Auto Parry", 
    Default = false,
    Save = false,
    Flag = "AutoParryToggle",
    Callback = function(value)
        Settings.AutoParry = value
    end
})

MainTab:Slider({
    Name = "Parry Distance",
    Min = 15,
    Max = 35,
    Default = 22,
    Flag = "DistanceSlider",
    Callback = function(value)
        Settings.ParryDistance = value
    end
})

MainTab:Toggle({
    Name = "Prediction System", 
    Default = true,
    Save = false,
    Flag = "PredictionToggle",
    Callback = function(value)
        Settings.Prediction = value
    end
})

MainTab:Toggle({
    Name = "Fast Spam", 
    Default = false,
    Save = false,
    Flag = "SpamToggle",
    Callback = function(value)
        Settings.SpamAttack = value
        if value then
            coroutine.wrap(FastSpam)()
        end
    end
})

MainTab:Slider({
    Name = "Spam Speed",
    Min = 0.05,
    Max = 0.3,
    Default = 0.08,
    Flag = "SpeedSlider",
    Precision = 2,
    Callback = function(value)
        Settings.SpamSpeed = value
    end
})

-- Start Systems
coroutine.wrap(AutoParry)()
