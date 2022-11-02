success, result = pcall(function()
    game:GetService("Players").LocalPlayer.PlayerGui.Intro:Destroy()
    game:GetService("Players").LocalPlayer.PlayerGui.HUD.Enabled = true
    game:GetService("Lighting").Blur:Destroy()
    game:GetService("Workspace").Sounds.IntroSong:Destroy()

    game:GetService("SoundService").SilentSoundGroup.Volume = 1

    workspace.CurrentCamera:Remove()
    wait(.1)
    repeat wait() until game.Players.LocalPlayer.Character ~= nil
    workspace.CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character:FindFirstChildWhichIsA('Humanoid')
    workspace.CurrentCamera.CameraType = "Custom"
    game.Players.LocalPlayer.CameraMinZoomDistance = 0.5
    game.Players.LocalPlayer.CameraMaxZoomDistance = 400
    game.Players.LocalPlayer.CameraMode = "Classic"
    game.Players.LocalPlayer.Character.Head.Anchored = false

    game:GetService("StarterGui"):SetCoreGuiEnabled('Backpack', true)
    game:GetService("StarterGui"):SetCoreGuiEnabled('Chat', true)

    game.Players.LocalPlayer.Character.ForceField:Destroy()

end) -- IT IS VILE HOW EASY IT IS

-- Define variables / constants

local httprequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request

local function GetClosest()
    local Character = LocalPlayer.Character
    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
    if not (Character or HumanoidRootPart) then return end

    local TargetDistance = math.huge
    local Target

    for i,v in ipairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local TargetHRP = v.Character.HumanoidRootPart
            local mag = (HumanoidRootPart.Position - TargetHRP.Position).magnitude
            if mag < TargetDistance then
                TargetDistance = mag
                Target = v.Character
            end
        end
    end

    return Target
end

local AimPart = "Head"
local Players = game:GetService("Players")
local SupportedVersion = 3155
local version = 1
local LocalPlayer = game:GetService("Players").LocalPlayer
local Local = LocalPlayer.Backpack:WaitForChild("Local")
local LocalMain = Local:WaitForChild("LocalMain")
local GunConfigs = require(game:GetService("ReplicatedStorage").GunConfigs)

-- Load in modules

loadstring(httprequest({Url = 'https://raw.githubusercontent.com/centerepic/LifeSentanceScript/main/grabbr.lua?t=1337',Method = "GET"}).Body)()
local ESP = loadstring(httprequest({Url = 'https://raw.githubusercontent.com/centerepic/script-host/main/ESP_DistanceCheck.lua',Method = "GET"}).Body)()
local Aiming = loadstring(game:HttpGet("https://raw.githubusercontent.com/centerepic/LifeSentanceScript/main/Aiming_Module.lua"))()

Aiming.TeamCheck(false)
function Aiming.Check()
    -- // Check A
    if not (Aiming.Enabled == true and Aiming.Selected ~= LocalPlayer and Aiming.SelectedPart ~= nil) then
        return false
    end

    -- // Check if downed
    local TargetPlayer = Players:GetPlayerFromCharacter(Aiming.Character)
    local Downed = TargetPlayer.Backpack.Stats.Downed.Value
    local Carried = TargetPlayer.Backpack.Stats.BeingCarried.Value
    local Dead = TargetPlayer.Backpack.Stats.Dead.Value

    -- // Check B
    if (Dead or Downed or Carried) then
        return false
    end

    -- //
    return true
end

local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
ESP:Toggle(false)
ESP:AddObjectListener(workspace.SpawnsLoot, {
    Name = "test",
    CustomName = "test",
    Color = Color3.fromRGB(0,124,0),
    IsEnabled = "ItemESP"
})

-- Anticheat Remover/Bypass
pcall(function()
	local oldhmmi
	local oldhmmnc
	oldhmmi = hookmetamethod(game, "__index", function(self, method)
		if self == LocalPlayer and method:lower() == "kick" then
			return error("Expected ':' not '.' calling member function Kick", 2)
		end
		return oldhmmi(self, method)
	end)
	oldhmmnc = hookmetamethod(game, "__namecall", function(self, ...)
        local Args = {...}
		if self == LocalPlayer and getnamecallmethod():lower() == "kick" then
			return
		end
        if tostring(self) == "WeaponEvent" and getnamecallmethod() == "FireServer" and Args[1] == "Fire" then
            if OrionLib.Flags["SilentAimToggle"].Value then
                if Aiming.SelectedPart then
                    Args[2][1] = Aiming.SelectedPart.Position + Aiming.SelectedPart.Velocity / 30
                    Args[2][2] = Aiming.SelectedPart
                    return oldhmmnc(self, unpack(Args))
                end
            end
        end
		return oldhmmnc(self, ...)
	end)
    -- Worst case scenario delete the ADMIN remote which is used to ban you. (If all else fails you will be kicked at most.)
    game:GetService("ReplicatedStorage"):WaitForChild("Events",2).ADMIN:Destroy()
end)

local Window = OrionLib:MakeWindow({IntroText = "Life Sentence - v"..tostring(version),Name = "Life Sentence - sashaa#5351", HidePremium = true, SaveConfig = true, ConfigFolder = "PrisonSex"})

-- Visual Elements


if game.PlaceVersion > SupportedVersion then
    OrionLib:MakeNotification({
        Name = "WARNING!",
        Content = "Current game version unsupported, use at your own risk!",
        Image = "rbxassetid://10867893609",
        Time = 10
    })
end  

if not success then
    OrionLib:MakeNotification({
        Name = "ERROR!",
        Content = "Full Anticheat bypass failed! Please execute while in the intro screen!",
        Image = "rbxassetid://10867893609",
        Time = 10
    })
end

local GameTab = Window:MakeTab({
	Name = "Game",
	Icon = "rbxassetid://10868105574",
	PremiumOnly = false
})

local Sp,Bl,Ge = 0,0,0

GameTab:AddLabel("Item Grabber")

GameTab:AddButton({
	Name = "Grab Items",
	Callback = function()
      	GrabItems(Sp,Bl,Ge)
        OrionLib:MakeNotification({
            Name = "Notice",
            Content = "Grabbing items! Please wait.",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
  	end    
})

local SpringTextBox = GameTab:AddTextbox({
	Name = "Springs",
	Default = "0",
	TextDisappear = false,
    Callback = function(Text)
        Sp = tonumber(Text)
    end
});

local BladesTextBox = GameTab:AddTextbox({
	Name = "Blades",
	Default = "0",
	TextDisappear = false,
    Callback = function(Text)
        Bl = tonumber(Text)
    end
});

local GearsTextBox = GameTab:AddTextbox({
	Name = "Gears",
	Default = "0",
	TextDisappear = false,
    Callback = function(Text)
        Ge = tonumber(Text)
    end
});

GameTab:AddButton({
	Name = "Global Chat",
	Callback = function()
        local ChatSpyFrame = LocalPlayer.PlayerGui.Chat.Frame
        ChatSpyFrame.ChatChannelParentFrame.Visible = true
        ChatSpyFrame.ChatBarParentFrame.Position = ChatSpyFrame.ChatChannelParentFrame.Position + UDim2.new(UDim.new(), ChatSpyFrame.ChatChannelParentFrame.Size.Y)
  	end    
})

local CombatTab = Window:MakeTab({
	Name = "Combat",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

CombatTab:AddToggle({
	Name = "Silent Aim",
	Default = false,
    Save = true,
    Flag = "SilentAimToggle",
    Callback = function(Value)
        Aiming.ShowFOV = Value
    end
})

CombatTab:AddSlider({
	Name = "FOV",
	Min = 15,
	Max = 360,
	Default = 60,
    Save = true,
	Color = Color3.fromRGB(49, 125, 240),
	Increment = 1,
	Callback = function(Value)
		Aiming.FOV = Value
	end    
})

CombatTab:AddToggle({
	Name = "Melee Hitbox",
	Default = false,
    Save = true,
	Flag = "MeleeHitbox"
})

local OldGunTable = game:GetService("ReplicatedStorage").GunConfigs:Clone()
local GunTable = require(game:GetService("ReplicatedStorage").GunConfigs)

CombatTab:AddButton({
	Name = "Reset Gun Mods",
	Callback = function()
        for i,v in pairs(require(OldGunTable)) do
            print("Reset",GunTable[i])
            GunTable[i] = v
        end
  	end    
})

CombatTab:AddToggle({
	Name = "Silent Guns",
	Default = false,
    Save = true,
	Flag = "SilentGuns"
})

CombatTab:AddToggle({
	Name = "No gun flash",
	Default = false,
    Save = true,
	Flag = "NoflashGuns"
})

CombatTab:AddToggle({
	Name = "Automatic Guns",
	Default = false,
	Callback = function(Value)
        for i,v in pairs(GunConfigs) do
            for i,x in pairs(v) do
                if tostring(i) == "IsAutomatic" then
                    v[i] = Value
                end
            end
        end
    end
})

CombatTab:AddSlider({
	Name = "Gun Cooldown",
	Min = 0,
	Max = 2,
	Default = 0,
	Color = Color3.fromRGB(221, 17, 17),
	Increment = 0.01,
	Callback = function(Value)
        for i,v in pairs(GunConfigs) do
            for i,x in pairs(v) do
                if tostring(i) == "CoolDown" then
                    v[i] = Value
                end
            end
        end
	end    
})

CombatTab:AddLabel("You may need to reequip your guns for gun mods to work.")
CombatTab:AddLabel("No Flash and Silent guns cannot be undone.")

local CharacterTab = Window:MakeTab({
	Name = "Character",
	Icon = "rbxassetid://10868104549",
	PremiumOnly = false
})

CharacterTab:AddToggle({
	Name = "Infinite Stamina",
	Default = false,
    Save = true,
	Callback = function(Value)
		if Value then
            setupvalue(getsenv(LocalMain).AddStamina, 1, math.huge)
        else
            setupvalue(getsenv(LocalMain).AddStamina, 1, 100)
        end
	end    
})

CharacterTab:AddSlider({
	Name = "Speed",
	Min = 0,
	Max = 15,
	Default = 0,
	Color = Color3.fromRGB(226, 173, 0),
	Increment = 1,
	Callback = function(Value)
		TargetWalkspeed = Value
	end    
})

CharacterTab:AddToggle({
	Name = "Antiaim",
	Default = false,
	Flag = "Antiaim"
})

CharacterTab:AddToggle({
	Name = "Anti-Finish",
	Default = false,
    Save = true,
	Flag = "AntiFinish",
    Callback = function()
        pcall(function()
            LocalPlayer.Character.HumanoidRootPart.TouchInterest:Destroy()
            LocalPlayer.Character.HumanoidRootPart.ArrestPrompt:Destroy()
        end)
    end
})

local VisualsTab = Window:MakeTab({
	Name = "Visuals",
	Icon = "rbxassetid://10868103330",
	PremiumOnly = false
})

VisualsTab:AddToggle({
	Name = "ESP",
	Default = false,
    Save = true,
	Callback = function(Value)
        ESP:Toggle(Value)
    end
})

VisualsTab:AddToggle({
	Name = "Players",
	Default = false,
    Save = true,
	Callback = function(Value)
        ESP.Players = Value
    end
})

VisualsTab:AddToggle({
	Name = "Items",
	Default = false,
    Save = true,
	Callback = function(Value)
        ESP.ItemESP = Value
    end
})

VisualsTab:AddSlider({
	Name = "ESP Distance",
	Min = 50,
	Max = 600,
	Default = 1000,
    Save = true,
	Color = Color3.fromRGB(226, 173, 0),
	Increment = 1,
	Callback = function(Value)
		getgenv().ESPDistance = Value
	end    
})

-- ok actual code starts here x2

LocalPlayer.Character.ChildAdded:Connect(function(child)
    if child:IsA("Tool") then
        if child:FindFirstChild("Handle") and child:FindFirstChild("Muzzle") then
            if child.Handle:FindFirstChild("Fire") and OrionLib.Flags["SilentGuns"].Value then
                child.Handle.Fire:Destroy()
            end
            if child.Muzzle:FindFirstChild("Light") and OrionLib.Flags["NoflashGuns"].Value then
                child.Muzzle.Light:Destroy()
            end
        end
    end
end)

LocalPlayer.Character.DescendantAdded:Connect(function(descendant)
    if OrionLib.Flags["AntiFinish"].Value == true and (descendant.Name == "TouchInterest" and descendant.Parent.Name == "HumanoidRootPart") then
        descendant:Destroy() -- rip bozo
    end
end) -- redundant and inefficient but makes such a small performance hit id rather just have 2 connections

task.defer(function()
    local Anim = Instance.new("Animation")
    Anim.AnimationId = "rbxassetid://215384594"
    local track = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(Anim)
    track.Looped = true
    while task.wait() do

        -- melee hitbox

        if OrionLib.Flags["MeleeHitbox"].Value == true then
            for i,v in pairs(LocalPlayer.Character:GetChildren()) do
                if v:IsA("Tool") then
                    pcall(function()
                        firetouchinterest(v.Handle, GetClosest().Torso, 1)
                        firetouchinterest(v.Handle, GetClosest().Torso, 0)
                    end)
                end
            end
        end

        -- antiaim

        if OrionLib.Flags["Antiaim"].Value == true then
            if not track.IsPlaying then
                track:Play(0,20,10)
            end
        elseif OrionLib.Flags["Antiaim"].Value == false then
            if track.IsPlaying then
                track:Stop()
            end
        end

    end
end)

game:GetService("RunService").RenderStepped:Connect(
    function()
        pcall(
            function()
                if game.Players.LocalPlayer.Character.Humanoid.MoveDirection.Magnitude > 0 then
                    game.Players.LocalPlayer.Character:TranslateBy(
                        game.Players.LocalPlayer.Character.Humanoid.MoveDirection * TargetWalkspeed / 100
                    )
                end
            end
        )
    end
)

local CreditsTab = Window:MakeTab({
	Name = "Credits",
	Icon = "rbxassetid://10868103330",
	PremiumOnly = false
})

CreditsTab:AddLabel("testing build 47")
CreditsTab:AddLabel("release build 2")
CreditsTab:AddLabel("xe#0153 - testing")
CreditsTab:AddLabel("zxciaz - aimlock")
CreditsTab:AddLabel("Enviie#2685 - silent aim")
CreditsTab:AddLabel("topit#4057 - emotinal support")
CreditsTab:AddLabel("sashaa#5351 - main dev")

OrionLib:Init()

for i,v in pairs(require(OldGunTable)) do
    GunTable[i] = v
end
