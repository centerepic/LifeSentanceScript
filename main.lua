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


getgenv().AimPart = "Head" -- For R15 Games: {UpperTorso, LowerTorso, HumanoidRootPart, Head} | For R6 Games: {Head, Torso, HumanoidRootPart}
getgenv().AimlockToggleKey = "Y" -- Toggles Aimbot On/Off 
getgenv().AimRadius = 30 -- How far away from someones character you want to lock on at
getgenv().ThirdPerson = false -- Locking onto someone in your Third Person POV
getgenv().FirstPerson = true -- Locking onto someone in your First Person POV
getgenv().TeamCheck = false -- Check if Target is on your Team (True means it wont lock onto your teamates, false is vice versa) (Set it to false if there are no teams)
getgenv().PredictMovement = true -- Predicts if they are moving in fast velocity (like jumping) so the aimbot will go a bit faster to match their speed 
getgenv().PredictionVelocity = 30 -- The speed of the PredictMovement feature 

local Players, Uis, RService, SGui = game:GetService"Players", game:GetService"UserInputService", game:GetService"RunService", game:GetService"StarterGui";
local Client, Mouse, Camera, CF, RNew, Vec3, Vec2 = Players.LocalPlayer, Players.LocalPlayer:GetMouse(), workspace.CurrentCamera, CFrame.new, Ray.new, Vector3.new, Vector2.new;
local Aimlock, MousePressed, CanNotify = true, false, false;
local AimlockTarget;
getgenv().CiazwareUniversalAimbotLoaded = true

getgenv().Notify = function(title, text, icon, time)
    -- removed
end

getgenv().WorldToViewportPoint = function(P)
    return Camera:WorldToViewportPoint(P)
end

getgenv().WorldToScreenPoint = function(P)
    return Camera.WorldToScreenPoint(Camera, P)
end

getgenv().GetObscuringObjects = function(T)
    if T and T:FindFirstChild(getgenv().AimPart) and Client and Client.Character:FindFirstChild("Head") then 
        local RayPos = workspace:FindPartOnRay(RNew(
            T[getgenv().AimPart].Position, Client.Character.Head.Position)
        )
        if RayPos then return RayPos:IsDescendantOf(T) end
    end
end

getgenv().GetNearestTarget = function()
    -- Credits to whoever made this, i didnt make it, and my own mouse2plr function kinda sucks
    local players = {}
    local PLAYER_HOLD  = {}
    local DISTANCES = {}
    for i, v in pairs(Players:GetPlayers()) do
        if v ~= Client then
            table.insert(players, v)
        end
    end
    for i, v in pairs(players) do
        if v.Character ~= nil then
            local AIM = v.Character:FindFirstChild("Head")
            if getgenv().TeamCheck == true and v.Team ~= Client.Team then
                local DISTANCE = (v.Character:FindFirstChild("Head").Position - game.Workspace.CurrentCamera.CFrame.p).magnitude
                local RAY = Ray.new(game.Workspace.CurrentCamera.CFrame.p, (Mouse.Hit.p - game.Workspace.CurrentCamera.CFrame.p).unit * DISTANCE)
                local HIT,POS = game.Workspace:FindPartOnRay(RAY, game.Workspace)
                local DIFF = math.floor((POS - AIM.Position).magnitude)
                PLAYER_HOLD[v.Name .. i] = {}
                PLAYER_HOLD[v.Name .. i].dist= DISTANCE
                PLAYER_HOLD[v.Name .. i].plr = v
                PLAYER_HOLD[v.Name .. i].diff = DIFF
                table.insert(DISTANCES, DIFF)
            elseif getgenv().TeamCheck == false and v.Team == Client.Team then 
                local DISTANCE = (v.Character:FindFirstChild("Head").Position - game.Workspace.CurrentCamera.CFrame.p).magnitude
                local RAY = Ray.new(game.Workspace.CurrentCamera.CFrame.p, (Mouse.Hit.p - game.Workspace.CurrentCamera.CFrame.p).unit * DISTANCE)
                local HIT,POS = game.Workspace:FindPartOnRay(RAY, game.Workspace)
                local DIFF = math.floor((POS - AIM.Position).magnitude)
                PLAYER_HOLD[v.Name .. i] = {}
                PLAYER_HOLD[v.Name .. i].dist= DISTANCE
                PLAYER_HOLD[v.Name .. i].plr = v
                PLAYER_HOLD[v.Name .. i].diff = DIFF
                table.insert(DISTANCES, DIFF)
            end
        end
    end
    
    if unpack(DISTANCES) == nil then
        return nil
    end
    
    local L_DISTANCE = math.floor(math.min(unpack(DISTANCES)))
    if L_DISTANCE > getgenv().AimRadius then
        return nil
    end
    
    for i, v in pairs(PLAYER_HOLD) do
        if v.diff == L_DISTANCE then
            return v.plr
        end
    end
    return nil
end

Uis.InputBegan:Connect(function(Key)
    if not (Uis:GetFocusedTextBox()) then 
        if Key.UserInputType == Enum.UserInputType.MouseButton2 then 
            pcall(function()
                if MousePressed ~= true then MousePressed = true end 
                local Target;Target = GetNearestTarget()
                if Target ~= nil then 
                    AimlockTarget = Target
                    Notify("Ciazware", "Aimlock Target: "..tostring(AimlockTarget), "", 3)
                end
            end)
        end
        if Key.KeyCode == Enum.KeyCode[AimlockToggleKey] then 
            Aimlock = not Aimlock
            Notify("Ciazware", "Aimlock: "..tostring(Aimlock), "", 3)
        end
    end
end)
Uis.InputEnded:Connect(function(Key)
    if not (Uis:GetFocusedTextBox()) then 
        if Key.UserInputType == Enum.UserInputType.MouseButton2 then 
            if AimlockTarget ~= nil then AimlockTarget = nil end
            if MousePressed ~= false then 
                MousePressed = false 
            end
        end
    end
end)

RService.RenderStepped:Connect(function()
    if getgenv().FirstPerson == true and getgenv().ThirdPerson == false then 
        if (Camera.Focus.p - Camera.CoordinateFrame.p).Magnitude <= 1 then 
            CanNotify = true 
        else 
            CanNotify = false 
        end
    elseif getgenv().ThirdPerson == true and getgenv().FirstPerson == false then 
        if (Camera.Focus.p - Camera.CoordinateFrame.p).Magnitude > 1 then 
            CanNotify = true 
        else 
            CanNotify = false 
        end
    end
    if Aimlock == true and MousePressed == true then 
        if AimlockTarget and AimlockTarget.Character and AimlockTarget.Character:FindFirstChild(getgenv().AimPart) then 
            if getgenv().FirstPerson == true then
                if CanNotify == true then
                    if getgenv().PredictMovement == true then 
                        Camera.CFrame = CF(Camera.CFrame.p, AimlockTarget.Character[getgenv().AimPart].Position + AimlockTarget.Character[getgenv().AimPart].Velocity/PredictionVelocity)
                    elseif getgenv().PredictMovement == false then 
                        Camera.CFrame = CF(Camera.CFrame.p, AimlockTarget.Character[getgenv().AimPart].Position)
                    end
                end
            elseif getgenv().ThirdPerson == true then 
                if CanNotify == true then
                    if getgenv().PredictMovement == true then 
                        Camera.CFrame = CF(Camera.CFrame.p, AimlockTarget.Character[getgenv().AimPart].Position + AimlockTarget.Character[getgenv().AimPart].Velocity/PredictionVelocity)
                    elseif getgenv().PredictMovement == false then 
                        Camera.CFrame = CF(Camera.CFrame.p, AimlockTarget.Character[getgenv().AimPart].Position)
                    end
                end 
            end
        end
    end
end)

-- Define variables / constants

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

getgenv().ESPDistance = 2000
local SupportedVersion = 3154
local version = 1
local LocalPlayer = game:GetService("Players").LocalPlayer
local Local = LocalPlayer.Backpack:WaitForChild("Local")
local LocalMain = Local:WaitForChild("LocalMain")
local GunConfigs = require(game:GetService("ReplicatedStorage").GunConfigs)

-- Load in modules
loadstring(game:HttpGet(('https://raw.githubusercontent.com/centerepic/LifeSentanceScript/main/grabbr.lua')))()
local ESP = loadstring(game:HttpGet(('https://raw.githubusercontent.com/centerepic/script-host/main/ESP_DistanceCheck.lua')))()
ESP:Toggle(false)

local function tp(cframe)
    LocalPlayer.Character:PivotTo(cframe)
end

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
		if self == LocalPlayer and getnamecallmethod():lower() == "kick" then
			return
		end
		return oldhmmnc(self, ...)
	end)
    -- Worst case scenario delete the ADMIN remote which is used to ban you. (If all elese fails you will be kicked at most.)
    game:GetService("ReplicatedStorage"):WaitForChild("Events",2).ADMIN:Destroy()
end)

-- Visual Elements

local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({IntroText = "Life Sentence - v"..tostring(version),Name = "Life Sentence - sashaa#5351", HidePremium = true, SaveConfig = true, ConfigFolder = "PrisonSex"})

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

local AimlockToggle = CombatTab:AddToggle({
	Name = "Aimlock",
	Default = false,
    Save = true,
	Callback = function(Value)
        Aimlock = Value
    end
})

CombatTab:AddToggle({
	Name = "Melee Hitbox",
	Default = false,
    Save = true,
	Flag = "MeleeHitbox"
})

game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Y then
        AimlockToggle:Set(not Aimlock)
    end
end)

CombatTab:AddLabel("Aimlock keybind is Y.")
CombatTab:AddLabel("Aimlock and keybinds only work in first person.")

local OldGunTable = game:GetService("ReplicatedStorage").GunConfigs:Clone()
local GunTable = require(game:GetService("ReplicatedStorage").GunConfigs)

GameTab:AddButton({
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
	Flag = "SilentGuns"
})

CombatTab:AddToggle({
	Name = "No gun flash",
	Default = false,
	Flag = "NoflashGuns"
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
        print("Destroyed TouchTransmitter (AntiFinish)")
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
                        print("fired")
                        firetouchinterest(v.Handle, GetClosest().Torso, 1)
                        firetouchinterest(v.Handle, GetClosest().Torso, 0)
                        print("fired2")
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
                        game.Players.LocalPlayer.Character.Humanoid.MoveDirection * TargetWalkspeed / 150
                    )
                end
            end
        )
    end
)

OrionLib:Init()
