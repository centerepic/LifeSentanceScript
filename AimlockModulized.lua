module = {}

local AimPart = "Head" -- For R15 Games: {UpperTorso, LowerTorso, HumanoidRootPart, Head} | For R6 Games: {Head, Torso, HumanoidRootPart}
local AimlockToggleKey = "Y" -- Toggles Aimbot On/Off 
local AimRadius = 30 -- How far away from someones character you want to lock on at
local ThirdPerson = false -- Locking onto someone in your Third Person POV
local FirstPerson = true -- Locking onto someone in your First Person POV
local TeamCheck = false -- Check if Target is on your Team (True means it wont lock onto your teamates, false is vice versa) (Set it to false if there are no teams)
local PredictMovement = true -- Predicts if they are moving in fast velocity (like jumping) so the aimbot will go a bit faster to match their speed 
local PredictionVelocity = 20 -- The speed of the PredictMovement feature 

local Players, Uis, RService, SGui = game:GetService"Players", game:GetService"UserInputService", game:GetService"RunService", game:GetService"StarterGui";
local Client, Mouse, Camera, CF, RNew, Vec3, Vec2 = Players.LocalPlayer, Players.LocalPlayer:GetMouse(), workspace.CurrentCamera, CFrame.new, Ray.new, Vector3.new, Vector2.new;
local module.Enabled, MousePressed, CanNotify = true, false, false;
local module.EnabledTarget;

local Notify = function(title, text, icon, time)
    -- notifications removed in this fork
end

local WorldToViewportPoint = function(P)
    return Camera:WorldToViewportPoint(P)
end

local WorldToScreenPoint = function(P)
    return Camera.WorldToScreenPoint(Camera, P)
end

local GetObscuringObjects = function(T)
    if T and T:FindFirstChild(local AimPart) and Client and Client.Character:FindFirstChild("Head") then 
        local RayPos = workspace:FindPartOnRay(RNew(
            T[local AimPart].Position, Client.Character.Head.Position)
        )
        if RayPos then return RayPos:IsDescendantOf(T) end
    end
end

local GetNearestTarget = function()
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
            if local TeamCheck == true and v.Team ~= Client.Team then
                local DISTANCE = (v.Character:FindFirstChild("Head").Position - game.Workspace.CurrentCamera.CFrame.p).magnitude
                local RAY = Ray.new(game.Workspace.CurrentCamera.CFrame.p, (Mouse.Hit.p - game.Workspace.CurrentCamera.CFrame.p).unit * DISTANCE)
                local HIT,POS = game.Workspace:FindPartOnRay(RAY, game.Workspace)
                local DIFF = math.floor((POS - AIM.Position).magnitude)
                PLAYER_HOLD[v.Name .. i] = {}
                PLAYER_HOLD[v.Name .. i].dist= DISTANCE
                PLAYER_HOLD[v.Name .. i].plr = v
                PLAYER_HOLD[v.Name .. i].diff = DIFF
                table.insert(DISTANCES, DIFF)
            elseif local TeamCheck == false and v.Team == Client.Team then 
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
    if L_DISTANCE > local AimRadius then
        return nil
    end
    
    for i, v in pairs(PLAYER_HOLD) do
        if v.diff == L_DISTANCE then
            return v.plr
        end
    end
    return nil
end

--[[local CheckTeamsChildren = function()
    if workspace and workspace:FindFirstChild"Teams" then 
        if local TeamCheck == true then
            if #workspace.Teams:GetChildren() == 0 then 
                local TeamCheck = false 
                SeparateNotify("Ciazware", "TeamCheck set to: "..tostring(local TeamCheck).." because there are no teams!", "", 3)
            end
        end
    end
end
CheckTeamsChildren()
]]--

--[[local GetNearestTarget = function()
    local T;
    for _, p in next, Players:GetPlayers() do 
        if p ~= Client then 
            if p.Character and p.Character:FindFirstChild(local AimPart) then 
                if local TeamCheck == true and p.Team ~= Client.Team then 
                    local Pos, ScreenCheck = WorldToScreenPoint(p.Character[local AimPart].Position)
                    Pos = Vec2(Pos.X, Pos.Y)
                    local MPos = Vec2(Mouse.X, Mouse.Y) -- Credits to CriShoux for this
                    local Distance = (Pos - MPos).Magnitude;
                    if Distance < local AimRadius then 
                        T = p 
                    end
                elseif local TeamCheck == false and p.Team == Client.Team then 
                    local Pos, ScreenCheck = WorldToScreenPoint(p.Character[local AimPart].Position)
                    Pos = Vec2(Pos.X, Pos.Y)
                    local MPos = Vec2(Mouse.X, Mouse.Y) -- Credits to CriShoux for this
                    local Distance = (Pos - MPos).Magnitude;
                    if Distance < local AimRadius then 
                        T = p 
                    end
                end
            end
        end
    end
    if T then 
        return T
    end
end]]--

Uis.InputBegan:Connect(function(Key)
    if not (Uis:GetFocusedTextBox()) then 
        if Key.UserInputType == Enum.UserInputType.MouseButton2 then 
            pcall(function()
                if MousePressed ~= true then MousePressed = true end 
                local Target;Target = GetNearestTarget()
                if Target ~= nil then 
                    module.EnabledTarget = Target
                    Notify("Ciazware", "module.Enabled Target: "..tostring(module.EnabledTarget), "", 3)
                end
            end)
        end
        if Key.KeyCode == Enum.KeyCode[module.EnabledToggleKey] then 
            module.Enabled = not module.Enabled
            Notify("Ciazware", "module.Enabled: "..tostring(module.Enabled), "", 3)
        end
    end
end)
Uis.InputEnded:Connect(function(Key)
    if not (Uis:GetFocusedTextBox()) then 
        if Key.UserInputType == Enum.UserInputType.MouseButton2 then 
            if module.EnabledTarget ~= nil then module.EnabledTarget = nil end
            if MousePressed ~= false then 
                MousePressed = false 
            end
        end
    end
end)

RService.RenderStepped:Connect(function()
    if local FirstPerson == true and local ThirdPerson == false then 
        if (Camera.Focus.p - Camera.CoordinateFrame.p).Magnitude <= 1 then 
            CanNotify = true 
        else 
            CanNotify = false 
        end
    elseif local ThirdPerson == true and local FirstPerson == false then 
        if (Camera.Focus.p - Camera.CoordinateFrame.p).Magnitude > 1 then 
            CanNotify = true 
        else 
            CanNotify = false 
        end
    end
    if module.Enabled == true and MousePressed == true then 
        if module.EnabledTarget and module.EnabledTarget.Character and module.EnabledTarget.Character:FindFirstChild(local AimPart) then 
            if local FirstPerson == true then
                if CanNotify == true then
                    if local PredictMovement == true then 
                        Camera.CFrame = CF(Camera.CFrame.p, module.EnabledTarget.Character[local AimPart].Position + module.EnabledTarget.Character[local AimPart].Velocity/PredictionVelocity)
                    elseif local PredictMovement == false then 
                        Camera.CFrame = CF(Camera.CFrame.p, module.EnabledTarget.Character[local AimPart].Position)
                    end
                end
            elseif local ThirdPerson == true then 
                if CanNotify == true then
                    if local PredictMovement == true then 
                        Camera.CFrame = CF(Camera.CFrame.p, module.EnabledTarget.Character[local AimPart].Position + module.EnabledTarget.Character[local AimPart].Velocity/PredictionVelocity)
                    elseif local PredictMovement == false then 
                        Camera.CFrame = CF(Camera.CFrame.p, module.EnabledTarget.Character[local AimPart].Position)
                    end
                end 
            end
        end
    end
end)

return module
