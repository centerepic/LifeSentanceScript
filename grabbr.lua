--variables yuh
local LocalPlayer = game.Players.LocalPlayer
local Character = LocalPlayer.Character
local V3 = Vector3.new
local FPP = fireproximityprompt
local Loot = {}
local LootSpawns = game:GetService("Workspace").SpawnsLoot
local TweenService = game:GetService("TweenService")

local function TPTo(Position)

    print("TPTo called.")

    if typeof(Position) == "Instance" then
        Position = Position.CFrame
    end

    if typeof(Position) == "Vector3" then
        Position = CFrame.new(Position)
    end

    if typeof(Position) ~= "CFrame" then
        warn("[!] Invalid Argument Passed to TP()")
    else
        local OP = LocalPlayer.Character.HumanoidRootPart.Position
        local TTW = (OP - Position.Position).Magnitude / 30
        local Tween =  TweenService:Create(LocalPlayer.Character.HumanoidRootPart,TweenInfo.new(TTW),{CFrame = Position})
        Tween:Play()
        print("Tween started. | " .. tostring(TTW))
        Tween.Completed:Wait()
        print("Tween completed.")
    end

end

local function CheckLoot(Model)
    for i,v in pairs(Model:GetChildren()) do
        if v.Name == "Spring" and v.Transparency == 0 then
            return "Spring",v
        elseif v.Name == "Gear" and v.Transparency == 0 then
            return "Gear",v
        elseif v.Name == "Blade" and v.Transparency == 0 then
            return "Blade",v
        end
    end
    return false,v
end

local function UpdateLoot()

LootT = {}

for _,LootSpawn in pairs(LootSpawns:GetChildren()) do
    
    local Loot,Model = CheckLoot(LootSpawn)
    if Loot then
        table.insert(LootT,{Loot,Model})
    end
    
end

end

local function Count(Name,Model)
    local count = 0
    for i,v in pairs(Model:GetChildren()) do
        if v.Name == Name then
            count = count + 1
        end
    end
    return count
end

getgenv().GrabItems = function(Springs,Blades,Gears)
    local OP = Character.HumanoidRootPart.CFrame
    local done1,done2,done3 = false,false,false
    if Springs ~= 0 then
        task.spawn(function()
        repeat 
            wait()
            UpdateLoot()
            local cont = true
            for i,v in pairs(LootT) do
                if cont then
                    if v[1] == "Gear" then
                        cont = false
                        TPTo(v[2].CFrame)
                        wait(0.2)
                        FPP(v[2].Parent.Part.Attachment.ProximityPrompt,1)
                        TPTo(OP)
                    end
                end
            end
        until Count("Gear",LocalPlayer.Backpack) >= Gears or Gears == 0
        done1 = true
        end)
    else
        done1 = true
    end
    if Springs ~= 0 then
        task.spawn(function()
            repeat 
                wait()
                UpdateLoot()
                local cont = true
                for i,v in pairs(LootT) do
                    if cont then
                        if v[1] == "Spring" then
                            cont = false
                            TPTo(v[2].CFrame)
                            wait(0.2)
                            FPP(v[2].Parent.Part.Attachment.ProximityPrompt,1)
                            TPTo(OP)
                        end
                    end
                end
            until Count("Spring",LocalPlayer.Backpack) >= Springs or Springs == 0
            done2 = true
        end)
        else
            done2 = true
    end
    if Blades ~= 0 then
        task.spawn(function()
            repeat 
                wait()
                UpdateLoot()
                local cont = true
                for i,v in pairs(LootT) do
                    if cont then
                        if v[1] == "Blade" then
                            cont = false
                            TPTo(v[2].CFrame)
                            wait(0.2)
                            FPP(v[2].Parent.Part.Attachment.ProximityPrompt,1)
                            TPTo(OP)
                        end
                    end
                end
            until Count("Blade",LocalPlayer.Backpack) >= Blades or Blades == 0
            done3 = true
        end)
        else
            done3 = true
    end
    TPTo(OP)
end
