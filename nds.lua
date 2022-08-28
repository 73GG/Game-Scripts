if _G.IniNDS then
    return error("Already Executed. Press Right Shift To Enable The Interface")
end

local lp = game:GetService("Players").LocalPlayer
local stat = game:GetService("Workspace").ContentModel
local struct = game:GetService("Workspace").Structure
local curdis = ""
local watclr
--local autofarm = false {Will Make Later}
local nofall = false
local hidevis = false

local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Orion/main/source'))()
local Window = OrionLib:MakeWindow({Name = "Natural Disaster Survival", HidePremium = false, SaveConfig = false})
local Main = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://4483345998"
})
local Misc = Window:MakeTab({
    Name = "Misc",
    Icon = "rbxassetid://4483345998"
})
local Teleports = Window:MakeTab({
    Name = "Teleports",
    Icon = "rbxassetid://4483345998"
})
local Credits = Window:MakeTab({
    Name = "Credits",
    Icon = "rbxassetid://4483345998"
})

Main:AddSection({ Name = "Disaster Section:" })

local curdisp = Main:AddParagraph( "Current Disaster:", ". . ." )

local curmap = Main:AddParagraph( "Current Map:", ". . ." )

Main:AddToggle({
    Name = "Notify An Upcoming Disaster",
    Default = false,
    Flag = "disnotif"
})

Main:AddSection({ Name = "Main Section:" })

Main:AddToggle({
    Name = "No Fall Damage",
    Default = nofall,
    Callback = function(Value)
        nofall = Value
        if nofall and lp.Character:FindFirstChild("FallDamageScript") then
            lp.Character:FindFirstChild("FallDamageScript"):Destroy()
        end
    end
})

Main:AddToggle({
    Name = "Hide Visuals",
    Default = hidevis,
    Callback = function(Value)
        hidevis = Value
        local r = lp.PlayerGui:FindFirstChild("BlizzardGui") or lp.PlayerGui:FindFirstChild("SandStormGui") or nil
        if r then
            r:FindFirstChildOfClass("Frame").Visible = not hidevis
        end
    end
})

Main:AddButton({
    Name = "Toggle Map Vote",
    Callback = function()
        lp.PlayerGui:FindFirstChild("MainGui"):FindFirstChild("MapVotePage").Visible = not lp.PlayerGui:FindFirstChild("MainGui"):FindFirstChild("MapVotePage").Visible
    end
})

Misc:AddSection({ Name = "Character Section:" })

Misc:AddSlider({
    Name = "WalkSpeed",
    Min = 16,
    Max = 150,
    Default = 16,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    Callback = function(Value)
        if lp.Character:FindFirstChild("Humanoid") then
            lp.Character:FindFirstChild("Humanoid").WalkSpeed = Value
        end
    end
})

Misc:AddSlider({
    Name = "JumpPower",
    Min = 50,
    Max = 300,
    Default = 50,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    Callback = function(Value)
	    if lp.Character:FindFirstChild("Humanoid") then
            lp.Character:FindFirstChild("Humanoid").JumpPower = Value
        end
    end
})

local grav = Misc:AddSlider({
    Name = "Gravity",
    Min = 0,
    Max = 1000,
    Default = game:GetService("Workspace").Gravity,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    Callback = function(Value)
        game:GetService("Workspace").Gravity = Value
    end
})

Misc:AddButton({
    Name = "Reset Gravity To Default",
    Callback = function()
        grav:Set(196.2)
    end
})

Misc:AddSection({ Name = "Water Color:" })

local watcolorpick = Misc:AddColorpicker({
    Name = "Select Water Color",
    Default = game:GetService("Workspace").WaterLevel.Color,
    Callback = function(Value)
    watclr = Value;
    game:GetService("Workspace").WaterLevel.Color = watclr
    local r = struct:FindFirstChild("FloodLevel") or struct:FindFirstChild("TsunamiWave") or nil
        if r and not r:IsA("Model") then
            r.Color = watclr
        elseif r and r:IsA("Model") then
            for _, v in next, r:GetChildren() do
                v.Color = watclr
            end
        end
    end
})

local rainbcolorbut = Misc:AddToggle({
    Name = "Rainbow Water",
    Default = false,
    Flag = "watrainb"
})

Misc:AddButton({
    Name = "Reset Water Color To Default",
    Callback = function()
        rainbcolorbut:Set(false)
        watcolorpick:Set(Color3.fromRGB(13, 105, 172))
    end
})

Misc:AddSection({ Name = "Other Stuff:" })

Misc:AddButton({
    Name = "No Fog",
    Callback = function()
        game:GetService("Lighting").FogStart = 500
        game:GetService("Lighting").FogEnd = 4000
    end
})

Misc:AddButton({
    Name = "Make Island Rocks Collidable",
    Callback = function()
        for _, v in next, game:GetService("Workspace").Island:GetChildren() do
            if v:IsA("Part") then
                v.CanCollide = true
            end
        end
    end
})

Misc:AddButton({
    Name = "Make Water Collidable",
    Callback = function()
        game:GetService("Workspace").WaterLevel.CanCollide = true
        game:GetService("Workspace").WaterLevel.Size = Vector3.new(2048, 1, 2048)
        game:GetService("Workspace").WaterLevel.Material = "Water"
    end
})

Teleports:AddSection({ Name = "In-Game Teleports:" })

Teleports:AddButton({
    Name = "Teleport To Lobby",
    Callback = function()
        if lp.Character.PrimaryPart then
            local r = game:GetService("Workspace"):FindFirstChild("Spawns"):GetChildren()
            lp.Character:PivotTo(r[math.random(1, #r)].CFrame + Vector3.new(0, 4.75, 0))
        end
    end
})

Teleports:AddButton({
    Name = "Teleport To Island",
    Callback = function()
        if lp.Character and lp.Character.PrimaryPart then
            lp.Character:PivotTo(CFrame.new(-123, 47.4, 8))
        end
    end
})

Teleports:AddBind({
    Name = "Click TP",
    Default = Enum.KeyCode.E,
    Hold = false,
    Callback = function()
        if lp.Character and lp.Character.PrimaryPart then
            lp.Character:PivotTo(CFrame.new(lp:GetMouse().Hit.X, (lp:GetMouse().Hit + Vector3.new(0,2.5,0)).Y, lp:GetMouse().Hit.Z))
        end
    end
})

Teleports:AddSection({ Name = "Game Teleports:" })

if game.PlaceId ~= 189707 then
    Teleports:AddButton({
    Name = "Teleport To The Original Game",
    Callback = function()
        game:GetService("TeleportService"):Teleport(189707, lp)
        OrionLib:MakeNotification({
            Name = "Teleporting...",
            Content = "Teleport in progress, please wait...",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
    end
    })
else
    Teleports:AddButton({
        Name = "Teleport To Chinese Version Of This Game",
        Callback = function()
            game:GetService("TeleportService"):Teleport(3696971654, lp)
            OrionLib:MakeNotification({
                Name = "Teleporting...",
                Content = "Teleport in progress, please wait...",
                Image = "rbxassetid://4483345998",
                Time = 5
            })
        end
    })
end

Teleports:AddButton({
    Name = "Rejoin",
    Callback = function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game:GetService("Players").LocalPlayer)
        OrionLib:MakeNotification({
            Name = "Teleporting...",
            Content = "Teleport in progress, please wait...",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
    end
})

Credits:AddSection({ Name = "Credits:" })

Credits:AddLabel( "FR0GG#9279 - Creator Of This Script" )

Credits:AddLabel( "dizy#5334 - For Helping Me" )

Credits:AddParagraph( "shlexware - Orion Lib Creator", "Github Link: https://github.com/shlexware" )

Credits:AddParagraph( "Special Thanks To...", "You - For Using My Script!" )

OrionLib:Init()

curmap:Set(stat:FindFirstChild("Information").Value)
coroutine.resume(coroutine.create(function()
    for _, v in next, game:GetService("Players"):GetPlayers() do
        if v.Character and v.Character:WaitForChild("SurvivalTag", .25) then
            curdis = v.Character:FindFirstChild("SurvivalTag").Value
            curdisp:Set(curdis)
        end
    end
end))

--Events

local hue = .0
game:GetService("RunService").RenderStepped:Connect(function()
    hue += 0.002
    if OrionLib.Flags["watrainb"].Value and hue <= 1 then
        watcolorpick:Set(Color3.fromHSV(hue, 1, 1))
    elseif hue >= 1 then
        hue = 0
    end
end)
lp.CharacterAdded:Connect(function(chr)
    if nofall then
        chr:WaitForChild("FallDamageScript"):Destroy()
    end
end)
lp.PlayerGui.ChildAdded:Connect(function(chld)
    if hidevis then
        chld:FindFirstChildOfClass("Frame").Visible = not hidevis
    end
end)
struct.ChildAdded:Connect(function(chld)
    if chld.Name == "FloodLevel" then
        chld.Color = watclr
    elseif chld.Name == "TsunamiWave" then
        chld:WaitForChild("Center")
        for _, v in next, chld:GetChildren() do
            v.Color = watclr
        end
    end
end)
stat:FindFirstChild("Information"):GetPropertyChangedSignal("Value"):Connect(function()
    curmap:Set(stat:FindFirstChild("Information").Value)
end)
stat:FindFirstChild("Status"):GetPropertyChangedSignal("Value"):Connect(function()
    if stat:FindFirstChild("Status").Value == "New Map" then
        wait(5)
        for _, v in next, game:GetService("Players"):GetPlayers() do
            if v.Character and v.Character:WaitForChild("SurvivalTag", 1) then
                curdis = v.Character:FindFirstChild("SurvivalTag").Value
                curdisp:Set(curdis)
                if OrionLib.Flags["disnotif"].Value then
                    OrionLib:MakeNotification({
                        Name = "Disaster Detected...",
                        Content = tostring("Current Disaster Is: "..curdis),
                        Image = "rbxassetid://4483345998",
                        Time = 12
                    })
                end
                break;
            end
        end
    else
        curdis = ". . ."
        curdisp:Set(curdis)
    end
end)
_G.IniNDS = true
