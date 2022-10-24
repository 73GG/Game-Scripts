if _G.IniNDS then
    _G.OrionLib:MakeNotification({
        Name = "Error - Already executed.",
        Content = "Tap RightShift to enable interface or rejoin the game if you have any issues.",
        Image = "rbxassetid://6962520787",
        Time = 12.5
    })
    return
end

repeat task.wait()
until game:IsLoaded()

local lp = game:GetService("Players").LocalPlayer
local cont = workspace:WaitForChild("ContentModel")
local struct = workspace:WaitForChild("Structure")
local curdis = ""
local targetsound
local soundlist = {}
local req = (type(syn) == "table" and syn.request) or (type(http) == "table" and http.request) or (type(fluxus) == "table" and fluxus.request) or http_request or request
local queue_on_teleport = (type(syn) == "table" and syn.queue_on_teleport) or (type(fluxus) == "table" and fluxus.queue_on_teleport) or queue_on_teleport
local hue = .0

for _, v in pairs(cont:FindFirstChild("Sounds"):GetChildren()) do
    table.insert(soundlist, 1, v.Name)
end

function setp(inst, prop)
    local r = type(prop) == "table" and prop or {}
    for i, v in pairs(r) do
        inst[i] = v
    end
end

_G.OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Orion/main/source'))()
local OrionLib = _G.OrionLib
local Window = OrionLib:MakeWindow({Name = "Natural Disaster Survival", IntroEnabled = false})
local Main = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://11129688807"
})
local Visuals = Window:MakeTab({
    Name = "Visuals",
    Icon = "rbxassetid://11129781601"
})
local Sounds = Window:MakeTab({
    Name = "Sounds",
    Icon = "rbxassetid://7203392850"
})
local Misc = Window:MakeTab({
    Name = "Misc",
    Icon = "rbxassetid://4483345998"
})
local Teleports = Window:MakeTab({
    Name = "Teleports",
    Icon = "rbxassetid://6723742952"
})
local Credits = Window:MakeTab({
    Name = "Credits",
    Icon = "rbxassetid://6962520787"
})

function notify(nm, ct, im, tm)
    OrionLib:MakeNotification({
        Name = nm,
        Content = ct,
        Image = im,
        Time = tm
    })
end

--Main Tab:

Main:AddSection({ Name = "Disaster Section:" })

local curdisp = Main:AddParagraph( "Current Disaster:", ". . ." )

local curmap = Main:AddParagraph( "Current Map:", ". . ." )

Main:AddToggle({
    Name = "Notify An Upcoming Disaster",
    Flag = "disnotif"
})

Main:AddToggle({
    Name = "Chat An Upcoming Disaster",
    Flag = "chatdis"
})

Main:AddDropdown({
	Name = "Chat Disaster Mode",
	Default = "Friends Only",
	Options = {"Everyone", "Friends Only"},
    Flag = "chatmode"
})

Main:AddSection({ Name = "Main Section:" })

Main:AddToggle({
    Name = "Autofarm (Does Nothing, WiP)",
    Flag = "autofarm"
})

Main:AddToggle({
    Name = "No Fall Damage",
    Callback = function(Value)
        if Value and lp.Character:FindFirstChild("FallDamageScript") then
            lp.Character:FindFirstChild("FallDamageScript"):Destroy()
        end
    end,
    Flag = "nofall"
})

Main:AddButton({
    Name = "Toggle Map Vote",
    Callback = function()
        lp.PlayerGui:FindFirstChild("MainGui"):FindFirstChild("MapVotePage").Visible = not lp.PlayerGui:FindFirstChild("MainGui"):FindFirstChild("MapVotePage").Visible
    end
})

--Visuals Tab:

Visuals:AddSection({ Name = "Visuals:" })

Visuals:AddToggle({
    Name = "Hide Visuals",
    Callback = function(Value)
        local r = lp.PlayerGui:FindFirstChild("BlizzardGui") or lp.PlayerGui:FindFirstChild("SandStormGui") or nil
        if r then
            r:FindFirstChildOfClass("Frame").Visible = not Value
        end
    end,
    Flag = "hidevis"
})

Visuals:AddToggle({
    Name = "Hide Pop-Ups",
    Callback = function(Value)
        lp.PlayerGui:WaitForChild("MainGui"):FindFirstChild("SurviversPage").Visible = false
        lp.PlayerGui:WaitForChild("MainGui"):FindFirstChild("NextMapPage").Visible = false
        lp.PlayerGui:WaitForChild("MainGui"):FindFirstChild("Hint").Visible = not Value
    end,
    Flag = "nopop"
})

Visuals:AddToggle({
    Name = "No Fog",
    Callback = function(Value)
        if Value then
            setp(game:GetService("Lighting"), {["FogColor"] = Color3.fromRGB(204, 236, 240), ["FogStart"] = 500, ["FogEnd"] = 4000, ["Brightness"] = 1})
        end
    end,
    Flag = "nofog"
})

Visuals:AddToggle({
    Name = "Confetti Rain",
    Flag = "confrain"
})

Visuals:AddSection({ Name = "Water Color:" })

local watcolorpick = Visuals:AddColorpicker({
    Name = "Select Water Color",
    Default = game:GetService("Workspace").WaterLevel.Color,
    Callback = function(Value)
        game:GetService("Workspace").WaterLevel.Color = Value
        local r = struct:FindFirstChild("FloodLevel") or struct:FindFirstChild("TsunamiWave") or nil
        if r and not r:IsA("Model") then
            r.Color = Value
        elseif r and r:IsA("Model") then
            for _, v in next, r:GetChildren() do
                v.Color = Value
            end
        end
    end,
    Flag = "watclr"
})

local rainbcolorbut = Visuals:AddToggle({
    Name = "Rainbow Water",
    Flag = "watrainb"
})

local rainbowspeed = Visuals:AddSlider({
    Name = "Rainbow Speed",
    Min = 0,
    Max = 50,
    Default = 7.5,
    Color = Color3.fromRGB(255,255,255),
    Increment = .125,
    Flag = "rainbowspeed"
})

Visuals:AddButton({
    Name = "Reset To Defaults",
    Callback = function()
        rainbcolorbut:Set(false)
        watcolorpick:Set(Color3.fromRGB(13, 105, 172))
        rainbowspeed:Set(5)
    end
})

--Sounds Tab:

Sounds:AddSection({ Name = "Local Sound Section (Only You Can Hear):" })

Sounds:AddToggle({
    Name = "Cheer Sound Upon Surviving",
    Flag = "cheer"
})

Sounds:AddSection({ Name = "Sound Section (Everyone Can Hear):" })

Sounds:AddDropdown({
    Name = "Selected Sound:",
    Default = "Select A Sound...",
    Options = soundlist,
    Callback = function(Value)
        targetsound = cont:FindFirstChild("Sounds"):FindFirstChild(Value)
    end
})

Sounds:AddButton({
    Name = "Play Selected Sound",
    Callback = function()
        targetsound:Play()
    end
})

Sounds:AddButton({
    Name = "Stop Selected Sound",
    Callback = function()
        targetsound:Stop()
    end
})

Sounds:AddSection({ Name = "All Sounds Section (Everyone Can Hear):" })

Sounds:AddButton({
    Name = "Play All Sounds",
    Callback = function()
        for _, v in pairs(cont:FindFirstChild("Sounds"):GetChildren()) do
            v:Play()
        end
    end
})

Sounds:AddButton({
    Name = "Stop All Sounds",
    Callback = function()
        for _, v in pairs(cont:FindFirstChild("Sounds"):GetChildren()) do
            v:Stop()
        end
    end
})

--Misc Tab:

Misc:AddSection({ Name = "Character Section:" })

local ws = Misc:AddSlider({
    Name = "WalkSpeed",
    Min = 1,
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

local jp = Misc:AddSlider({
    Name = "JumpPower",
    Min = 1,
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
    Name = "Reset To Defaults",
    Callback = function()
        ws:Set(16)
        jp:Set(50)
        grav:Set(196.2)
    end
})

Misc:AddSection({ Name = "Other Stuff:" })

Misc:AddToggle({
    Name = "Make Island Rocks Collidable",
    Callback = function(Value)
        for _, v in next, game:GetService("Workspace").Island:GetChildren() do
            if string.match(v.Name, "Lower") then
                v.CanCollide = Value
            end
        end
    end
})

Misc:AddToggle({
    Name = "Make Water Collidable",
    Callback = function(Value)
        setp(workspace:FindFirstChild("WaterLevel"), {["CanCollide"] = Value, ["Size"] = Vector3.new(2^11, 1, 2^11)})
        if struct:FindFirstChild("FloodLevel") then
            setp(struct:FindFirstChild("FloodLevel"), {["CanCollide"] = Value, ["Size"] = Vector3.new(2^11, 1, 2^11)})
        end
    end,
    Flag = "watercollide"
})

--Teleports Tab:

Teleports:AddSection({ Name = "In-Game Teleports:" })

Teleports:AddTextbox({
	Name = "Teleport To Player",
	TextDisappear = true,
	Callback = function(Value)
        if not OrionLib.Flags.autofarm.Value and Value ~= "" then
            for _, v in pairs(game:GetService("Players"):GetPlayers()) do
                if (Value:lower() ~= lp.Name:lower():sub(1, #Value) or Value:lower() ~= lp.DisplayName:lower():sub(1, #Value)) and (Value:lower() == v.Name:lower():sub(1, #Value) or Value:lower() == v.DisplayName:lower():sub(1, #Value)) then
                    lp.Character:PivotTo(v.Character.PrimaryPart.CFrame + Vector3.new(0, 4.5, 0))
                end
            end
        end
	end
})

Teleports:AddButton({
    Name = "Teleport To Lobby",
    Callback = function()
        if not OrionLib.Flags.autofarm.Value then
            if lp.Character:FindFirstChild("Humanoid") and lp.Character:FindFirstChild("Humanoid").SeatPart then
                lp.Character:FindFirstChild("Humanoid").Sit = false
                task.wait(.1)
            end
            local r = game:GetService("Workspace"):FindFirstChild("Spawns"):GetChildren()
            lp.Character:PivotTo(r[math.random(1, #r)].CFrame + Vector3.new(0, 4.75, 0))
        end
    end
})

Teleports:AddButton({
    Name = "Teleport To Island",
    Callback = function()
        if not OrionLib.Flags.autofarm.Value then
            if lp.Character:FindFirstChild("Humanoid") and lp.Character:FindFirstChild("Humanoid").SeatPart then
                lp.Character:FindFirstChild("Humanoid").Sit = false
                task.wait(.1)
            end
            lp.Character:PivotTo(CFrame.new(Random.new():NextInteger(-100, -120), 47.4, Random.new():NextInteger(-10, 30)))
        end
    end
})

Teleports:AddBind({
    Name = "Click TP (Hold And Click To Teleport)",
    Default = Enum.KeyCode.LeftAlt,
    Flag = "tpbind"
})

Teleports:AddSection({ Name = "Game Teleports:" })

if game.PlaceId ~= 189707 then
    Teleports:AddButton({
        Name = "Teleport To The Original Game",
        Callback = function()
            game:GetService("TeleportService"):Teleport(189707, lp)
            notify("Teleporting...", "Teleport in progress, please wait...", "rbxassetid://6962520787", 5)
        end
    })
else
    Teleports:AddButton({
        Name = "Teleport To Chinese Version Of This Game",
        Callback = function()
            game:GetService("TeleportService"):Teleport(3696971654, lp)
            notify("Teleporting...", "Teleport in progress, please wait...", "rbxassetid://6962520787", 5)
        end
    })
end

Teleports:AddButton({
    Name = "Rejoin",
    Callback = function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, lp)
        notify("Teleporting...", "Teleport in progress, please wait...", "rbxassetid://6962520787", 5)
    end
})

Teleports:AddButton({
    Name = "Server-Hop",
    Callback = function()
        if req then
            notify("In Progress...", "Fetching servers, this might take a while...", "rbxassetid://6962520787", 5)
            local servers = {}
            local body = game:GetService("HttpService"):JSONDecode(req({Url = ("https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=Asc&limit=100"):format(game.PlaceId)}).Body)
            if body and body.data then
                for i, v in next, body.data do
                    if type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing < v.maxPlayers and v.id ~= game.JobId then
                        table.insert(servers, 1, v.id)
                    end
                end
            end
            if #servers > 0 then
                notify("Teleporting...", "Teleport in progress, please wait...", "rbxassetid://6962520787", 5)
                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], lp)
            else
                return notify("Error.", "Couldn't find a server, try again later.", "rbxassetid://6962520787", 7.5)
            end
        else
            notify("Error.", "Your exploit is unsupported. (Missing function: request)", "rbxassetid://6962520787", 7.5)
        end
    end
})

Teleports:AddToggle({
    Name = "Keep GUI",
    Default = keepgui or false,
    Callback = function(Value)
        if not queue_on_teleport and Value then
            notify("Error.", "Your exploit is unsupported. (Missing function: queue_on_teleport)", "rbxassetid://6962520787", 7.5)
        end
    end,
    Flag = "keepgui"
})

--Credits Tab:

Credits:AddSection({ Name = "Credits:" })

Credits:AddLabel( "FR0GG#9279 - Creator Of This Script" )

Credits:AddLabel( "dizy#5334 - For Helping Me" )

Credits:AddParagraph( "shlexware - Orion Lib Creator", "Github Link: https://github.com/shlexware" )

Credits:AddParagraph( "Special Thanks To...", ("%s - For Using My Script!"):format(lp.Name) )

OrionLib:Init()

curmap:Set(cont:FindFirstChild("Information").Value ~= "" and cont:FindFirstChild("Information").Value or ". . .")
coroutine.resume(coroutine.create(function()
    for _, v in pairs(game:GetService("Players"):GetPlayers()) do
        if v.Character and v.Character:WaitForChild("SurvivalTag", .1) then
            curdis = v.Character:FindFirstChild("SurvivalTag").Value
            curdisp:Set(curdis)
        end
    end
end))

--[[ Events loops and stuff ]]--

game:GetService("RunService").RenderStepped:Connect(function() --Rainbow Water
    hue += OrionLib.Flags.rainbowspeed.Value/1e4
    if OrionLib.Flags["watrainb"].Value and hue <= 1 then
        watcolorpick:Set(Color3.fromHSV(hue, 1, 1))
    elseif hue >= 1 then
        hue = .0
    end
end)
for _, v in pairs({lp.PlayerGui:WaitForChild("MainGui"):FindFirstChild("SurviversPage"), lp.PlayerGui:WaitForChild("MainGui"):FindFirstChild("NextMapPage")}) do
    v:GetPropertyChangedSignal("Visible"):Connect(function() --Hide Pop-Ups
        if not v.Visible then
            return
        end
        v.Visible = not OrionLib.Flags.nopop.Value
    end)
end
cont:FindFirstChild("Survivers").ChildAdded:Connect(function(r) --Cheer Upon Surviving
    if OrionLib.Flags.cheer.Value and r.Name == lp.Name then
        lp.PlayerGui:FindFirstChild("MainGui"):FindFirstChild(("Cheer%dSound"):format(math.random(1, 2))):Play()
    end
end)
coroutine.resume(coroutine.create(function()
    while task.wait(.1) do --Confetti Rain
        if OrionLib.Flags.confrain.Value then
            local r = lp.PlayerGui:WaitForChild("MainGui"):FindFirstChild("ConfettiModule")
            if r then
                require(r).Rain(1)
            end
        end
    end
end))
game:GetService("Lighting").Changed:Connect(function() --No Fog
    if OrionLib.Flags.nofog.Value then
        setp(game:GetService("Lighting"), {["FogColor"] = Color3.fromRGB(204, 236, 240), ["FogStart"] = 500, ["FogEnd"] = 4000, ["Brightness"] = 1})
    end
end)
lp:GetMouse().Button1Down:Connect(function() --Click TP
    if not OrionLib.Flags.autofarm.Value and game:GetService("UserInputService"):IsKeyDown(OrionLib.Flags.tpbind.Value) and lp:GetMouse().Target then
        if lp.Character:FindFirstChild("Humanoid") and lp.Character:FindFirstChild("Humanoid").SeatPart then
            lp.Character:FindFirstChild("Humanoid").Sit = false
            task.wait(.1)
        end
        lp.Character:PivotTo(CFrame.new(lp:GetMouse().Hit.X, (lp:GetMouse().Hit + Vector3.new(0,2.5,0)).Y, lp:GetMouse().Hit.Z))
    end
end)
lp.CharacterAdded:Connect(function(chr) --No Fall
    if OrionLib.Flags.nofall.Value then
        chr:WaitForChild("FallDamageScript"):Destroy()
    end
    ws:Set(16)
    jp:Set(50)
end)
lp.PlayerGui.ChildAdded:Connect(function(chld) --Hide Visuals
    if OrionLib.Flags.hidevis.Value then
        chld:FindFirstChildOfClass("Frame").Visible = not OrionLib.Flags.hidevis.Value
    end
end)
lp.OnTeleport:Connect(function(state) --Keep GUI
    if queue_on_teleport and state == Enum.TeleportState.Started and OrionLib.Flags.keepgui.Value then
        queue_on_teleport([[
            keepgui = true
            loadstring(game:HttpGet("https://raw.githubusercontent.com/73GG/Game-Scripts/main/Natural%20Disaster%20Survival.lua"))()
            ]])
    end
end)
struct.ChildAdded:Connect(function(chld) --Auto Apply Selected Water Color To Flood And Tsunami
    if chld.Name == "FloodLevel" then
        setp(chld, {["Color"] = OrionLib.Flags.watclr.Value, ["CanCollide"] = OrionLib.Flags.watercollide.Value, ["Size"] = Vector3.new(2^11, 1, 2^11)})
    elseif chld.Name == "TsunamiWave" then
        chld:WaitForChild("Center")
        for _, v in next, chld:GetChildren() do
            v.Color = OrionLib.Flags.watclr.Value
        end
    end
end)
cont:FindFirstChild("Information").Changed:Connect(function() --Current Map
    curmap:Set(cont:FindFirstChild("Information").Value)
end)
cont:FindFirstChild("Status").Changed:Connect(function() --Disaster Detection
    if cont:FindFirstChild("Status").Value == "New Map" then
        task.wait(5)
        for _, v in pairs(game:GetService("Players"):GetPlayers()) do
            if v.Character and v.Character:WaitForChild("SurvivalTag", 1) then
                curdis = v.Character:FindFirstChild("SurvivalTag").Value
                curdisp:Set(curdis)
                if OrionLib.Flags.chatdis.Value then --Chat Disaster
                    if OrionLib.Flags.chatmode.Value == "Friends Only" then
                        for _, v1 in pairs(game:GetService("Players"):GetPlayers()) do
                            if v1:IsFriendsWith(lp.UserId) then
                                game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(("/w %s Current disaster is: %s."):format(v1.Name, curdis), "All")
                            end
                        end
                    else
                        game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(("Current disaster is: %s."):format(curdis), "All")
                    end
                end
                if OrionLib.Flags.disnotif.Value then --Notify Disaster
                    notify("Disaster Detected...", ("Current Disaster Is: %s."):format(curdis), "rbxassetid://6962520787", 17.5)
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
