local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

getgenv().autoParryEnabled = true
getgenv().spamEnabled = true

-- Auto Parry Function
local function autoParry()
    while autoParryEnabled and task.wait() do
        local ball = workspace:FindFirstChild("Ball")
        if ball and (ball.Position - character.HumanoidRootPart.Position).Magnitude < 25 then
            game:GetService("ReplicatedStorage").Events.Parry:FireServer()
        end
    end
end

-- Spam Function
local function spamAttack()
    while spamEnabled and task.wait(0.1) do
        game:GetService("ReplicatedStorage").Events.Slash:FireServer(true)
        game:GetService("ReplicatedStorage").Events.Slash:FireServer(false)
    end
end

-- UI Library (gunakan yang tersedia)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Robojini/Tuturial_UI/main/UI-Template-1"))()

local Window = Library:CreateWindow("Blade Ball Cheat")

local MainTab = Window:CreateTab("Main")
local AutoParrySection = MainTab:CreateSection("Auto Parry")
local SpamSection = MainTab:CreateSection("Spam Attack")

AutoParrySection:CreateToggle({
    Name = "Auto Parry",
    CurrentValue = autoParryEnabled,
    Flag = "AutoParryToggle",
    Callback = function(value)
        autoParryEnabled = value
        if value then
            coroutine.wrap(autoParry)()
        end
    end
})

SpamSection:CreateToggle({
    Name = "Spam Attack",
    CurrentValue = spamEnabled,
    Flag = "SpamToggle",
    Callback = function(value)
        spamEnabled = value
        if value then
            coroutine.wrap(spamAttack)()
        end
    end
})
