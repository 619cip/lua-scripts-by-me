-- Demon Fall ShitAss

-- globals
getgenv().TrinketFarmEnabled = nil
getgenv().NPCFarmEnabled = nil
getgenv().Breathing = nil
getgenv().HideName = nil
getgenv().PlayerTP = nil
getgenv().NoExecute = nil
getgenv().NoSlowDown = nil
getgenv().NoCoolDown = nil

-- services
local Players = game:GetService("Players")
local RepUtil = game:GetService("ReplicatedStorage")
local RunUtil = game:GetService("RunService")
local TweenUtil = game:GetService("TweenService")
local UIUtil = game:GetService("UserInputService")

-- important variables
local LP = Players.LocalPlayer
local Char = LP.Character
local Root = Char.HumanoidRootPart or LP.Character.PrimaryPart
local Hum = Char.Humanoid
local Async = RepUtil.Remotes.Async -- remote event
local Sync = RepUtil.Remotes.Sync -- remote function

-- bind to stepped
function bind(func)
    RunUtil.Stepped:Connect(func)
end

-- get studs
function studs(obj)
    return (Root.Position - obj.Position).Magnitude
end

-- coroutine
function go(func)
    coroutine.wrap(func)()
end

-- tp
function teleport(pos)
    if not LP:FindFirstChild("SecurityBypass") then
        Sync:InvokeServer("Player", "SpawnCharacter")
        wait(1)
        Root.CFrame = pos
    else
        Root.CFrame = pos
    end
end

-- tween
function tweenTo(pos, direction)
    local TInfo = TweenInfo.new((Root.Position - pos.Position).Magnitude * 0.025)
    local TGoal = {CFrame = pos}
    if direction == "Under" then
        TGoal = {CFrame = pos * CFrame.Angles(math.rad(90),0,0) * CFrame.new(0,0,5)}
    elseif direction == "Above" then
        TGoal = {CFrame = pos * CFrame.Angles(math.rad(-90),0,0) * CFrame.new(0,0,-5)}
    end
    local Tween = TweenUtil:Create(Root,TInfo,TGoal)
    Tween:Play()
end

-- hide name
function hideName()
    bind(function()
        if getgenv().HideName then
            if Char:FindFirstChild("Head") then
                if Char.Head:FindFirstChild("TrueName") then
                    Char.Head.TrueName:Destroy()
                elseif Char.Head:FindFirstChild("Rank") then
                    Char.Head.Rank:Destroy()
                end
            end
        end
    end)
end

-- no swing cooldown
function noSwingCD()
    bind(function()
        if getgenv().NoCoolDown then
            for _,v in pairs(Char:GetChildren()) do
                if v.Name:lower():find("sequence") or v.Name:lower():find("cooldown") or v.Name == 'Busy' then
                    v:Destroy()
                end
            end
        end
    end)
end

-- no burn
function noSunBurn()
    local hookOld
    hookOld = hookmetamethod(game,"__namecall",newcclosure(function(...)
        local Key = {...}
        local Self = Key[1]
        if getnamecallmethod() == 'FireServer' and Self == Async and Key[2] == 'Character' and Key[3] == 'DemonWeakness' then
            return wait(9e9)
        end
        return hookOld(...)
    end))
end

-- no fall dmg
function noFallDmg()
    local hookOld
    hookOld = hookmetamethod(game,"__namecall",newcclosure(function(...)
        local Key = {...}
        local Self = Key[1]
        if getnamecallmethod() == 'FireServer' and Self == Async and Key[2] == 'Character' and Key[3] == 'FallDamageServer' then
            return wait(9e9)
        end
        return hookOld(...)
    end))
end

-- no execute
function noExecute()
    bind(function()
        if getgenv().NoExecute then
            if Char:FindFirstChild("Down") then
                Char.Down:Destroy()
            elseif Char:FindFirstChild("Executing") then
                Char.Executing:Destroy()
            end
        end
    end)
end

-- no slow down
function noSlowDown()
    bind(function()
        if getgenv().NoSlowDown then
            if Char:FindFirstChild("Stun") then
                Char.Stun:Destroy()
            elseif Char:FindFirstChild("Ragdoll") then
                Char.Ragdoll:Destroy()
            elseif Char:FindFirstChild("Busy") then
                Char.Busy:Destroy()
            end
        end
    end)
end

-- trinket farm
function trinketFarm()
    function nearestTrinket()
        local Trinket
        local Dist = 1/0
        for _,obj in pairs(workspace.Trinkets:GetChildren()) do
            if obj:FindFirstChild("Spawned") and studs(obj) < Dist then
                Dist = studs(obj)
                Trinket = obj
            end
        end
        return Trinket
    end
    function getTrinket()
        local item
        local newDist = 1/0
        for _,obj in pairs(workspace:GetChildren()) do
            if obj:FindFirstChild("PickableItem") and obj:FindFirstChild("Part") and studs(obj.Part) < newDist then
                newDist = studs(obj.Part)
                item = obj
            end
        end
        return item
    end
    go(function()
        while getgenv().TrinketFarmEnabled do wait()
            Hum:ChangeState(11)
        end
    end)
    bind(function()
        if LP:FindFirstChild("InteractionCooldown") and getgenv().TrinketFarmEnabled then
            LP.InteractionCooldown:Destroy()
        end
    end)
    while getgenv().TrinketFarmEnabled do wait(1)
        local Trinket = nearestTrinket()
        if Trinket ~= nil then
            teleport(Trinket.CFrame)
        end
        wait(1)
        local item = getTrinket()
        if item ~= nil then
            if item:FindFirstChild("Main") then
                Async:FireServer("Character", "Interaction", item.Main)
            elseif item:FindFirstChild("Part") then
                Async:FireServer("Character", "Interaction", item.Part)
            end
        end
    end
end

-- npc farm
function npcFarm()
    function findNPC()
        local npc
        local dist = 1/0
        for _,mob in pairs(workspace:GetChildren()) do
            if ((mob.Name == 'GenericOni' or mob.Name == 'GenericSlayer') and mob:FindFirstChild("HumanoidRootPart") and not mob:FindFirstChild("Dien")) then
                if studs(v.HumanoidRootPart) < dist then
                    dist = studs(mob.HumanoidRootPart)
                    npc = mob
                end
            end
        end
        return npc
    end
    function executeNPC(npc)
        repeat
            wait()
            tweenTo(npc.HumanoidRootPart.CFrame)
            Sync:InvokeServer("Character", "Execute")
        until npc:FindFirstChild("Executing") or npc:FindFirstChild("Down") == nil or npc:FindFirstChild("HumanoidRootPart") == nil
        if npc:FindFirstChild("Executing") then
            wait(3)
        end
    end
    go(function()
        while getgenv().NPCFarmEnabled do wait()
            Hum:ChangeState(11)
        end
    end)
    bind(function()
        if getgenv().NPCFarmEnabled then
            if Root:FindFirstChild("BodyGyro") then
                Root.BodyGyro:Destroy()
                tweenTo(Root.CFrame * CFrame.new(0,30,0))
            end
            if Root:FindFirstChild("BodyPosition") then
                Root.BodyPosition:Destroy()
                tweenTo(Root.CFrame * CFrame.new(0,30,0))
            end
        end
    end)
    while getgenv().NPCFarmEnabled do wait(1)
        local npc = findNPC()
        if npc ~= nil then
            workspace.CurrentCamera.CameraSubject = npc
            teleport(npc.HumanoidRootPart.CFrame)
            wait(1)
            if studs(npc.HumanoidRootPart) <= 30 then
                tweenTo(npc.HumanoidRootPart.CFrame, "Above")
                if npc:FindFirstChild("Down") then
                    executeNPC(npc)
                end
                if npc:FindFirstChild("Block") then
                    if not Char:FindFirstChild("Horn") then
                        Async:FireServer("Katana", "Heavy")
                    else
                        Async:FireServer("Combat", "Heavy")
                    end
                else
                    if not Char:FindFirstChild("Horn") then
                        Async:FireServer("Katana", "Server")
                    else
                        Async:FireServer("Combat", "Server")
                    end
                end
            end
        end
    end
    workspace.CurrentCamera.CameraSubject = Char
end

-- dupe
function dupe()
    for i = 1,30 do
        wait()
        Sync:InvokeServer("HUD", "Inventory", "Drop", getgenv().DupeItem)
    end
end

-- non stop breathing
function breathing()
    if getgenv().Breathing == false then
        Async:FireServer("Character", "Breath", false)
    end
    while getgenv().Breathing do wait(1)
        bind(function()
            if getgenv().Breathing then
                if Char:FindFirstChild("Busy") then
                    Char.Busy:Destroy()
                end
                if Char:FindFirstChild("Slow") then
                    Char.Slow:Destroy()
                end
            end
        end)
        Async:FireServer("Character", "Breath", true)
    end
end

function returnInventory()
    local returnTable = {}
    for i,v in pairs(LP.PlayerGui.Interface.HUD.MenuFrames.Inventory.Content:GetChildren()) do
        if v.Name ~= "UIGridLayout" then
            table.insert(returnTable,v.Name)
        end
    end
    return returnTable
end

function returnPlayers()
    local returnTable = {}
    for i,v in pairs(Players:GetPlayers()) do
        if v.Character:FindFirstChild("HumanoidRootPart") then
            table.insert(returnTable,v.Name)
        end
    end
    return returnTable
end

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

local home = library.CreateLib("Timoe's Hub","Serpent")

UIUtil.InputBegan:Connect(function(key, gameProcessed)
    if key.KeyCode == Enum.KeyCode.RightControl and not gameProcessed then
        library:ToggleUI()
    end
end)

local Tab1 = home:NewTab("Farm")

local section1_Tab1 = Tab1:NewSection("Auto Farm")

section1_Tab1:NewToggle("Trinket Farm", "Tweens to trinkets around the map.", function(state)
    if getgenv().TrinketFarmEnabled == nil or state then
        getgenv().TrinketFarmEnabled = state
        trinketFarm()
    else
        getgenv().TrinketFarmEnabled = state
    end
end)

section1_Tab1:NewToggle("NPC Farm", "Farms NPC around the map.", function(state)
    if getgenv().NPCFarmEnabled == nil or state then
        getgenv().NPCFarmEnabled = state
        npcFarm()
    else
        getgenv().NPCFarmEnabled = state
    end
end)

local section2_Tab1 = Tab1:NewSection("Misc")

section2_Tab1:NewToggle("Remove Nametag", "Removes ingame name tag on your character.", function(state)
    if getgenv().HideName == nil or state then
        getgenv().HideName = state
        hideName()
    else
        getgenv().HideName = state
    end
end)

section2_Tab1:NewButton("No Fall Damage", "Disables fall damage.", function()
    noFallDmg()
end)

section2_Tab1:NewButton("No Burn Damage", "Disables sun damage on demons.", function()
    noSunBurn()
end)

local Tab2 = home:NewTab("Combat")

local section1_Tab2 = Tab2:NewSection("Main")

section1_Tab2:NewToggle("Non-stop Breathing", "simple.", function(state)
    if getgenv().Breathing == nil or state then
        getgenv().Breathing = state
        breathing()
    else
        getgenv().Breathing = state
    end
end)

section1_Tab2:NewToggle("No Sequence", "Does the first sequence of an attack.", function(state)
    if getgenv().NoCoolDown == nil or state then
        getgenv().NoCoolDown = state
        noSwingCD()
    else
        getgenv().NoCoolDown = state
    end
end)

section1_Tab2:NewToggle("No Execution", "Can't be manually executed.", function(state)
    if getgenv().NoExecute == nil or state then
        getgenv().NoExecute = state
        noExecute()
    else
        getgenv().NoExecute = state
    end
end)

section1_Tab2:NewToggle("No Slowdown", "Character does not get slowed.", function(state)
    if getgenv().NoSlowDown == nil or state then
        getgenv().NoSlowDown = state
        noSlowDown()
    else
        getgenv().NoSlowDown = state
    end
end)

local Tab3 = home:NewTab("Misc")

local section1_Tab3 = Tab3:NewSection("Teleport")

local drop1 = section1_Tab3:NewDropdown("Teleport to player", "Teleport to a player, players must be loaded in.", returnPlayers(), function(player)
    getgenv().PlayerTP = Players[player]
end)

section1_Tab3:NewButton("Refresh Players", "Refresh Players. players must be loaded in first.", function()
    drop1:Refresh(returnPlayers())
end)

section1_Tab3:NewButton("Teleport", "Teleport to player", function()
    if getgenv().PlayerTP.Character:FindFirstChild("HumanoidRootPart") then
        teleport(getgenv().PlayerTP.Character.HumanoidRootPart.CFrame)
    end
end)
