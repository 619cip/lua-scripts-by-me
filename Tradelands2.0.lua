-- ================== --
-- Tradelands Hub 2.0 --
-- ================== --

if game.PlaceId ~= 198116126 then
    return
end

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local VERSION = "1.0"

local players = game:GetService("Players")
local tween_serv = game:GetService("TweenService")
local repli = game:GetService("ReplicatedStorage")
local run_serv = game:GetService("RunService")
local http = game:GetService("HttpService")
local user_input = game:GetService("UserInputService")
local teleport = game:GetService("TeleportService")
local starter = game:GetService("StarterGui")
local core = game:GetService("CoreGui")
local stats = game:GetService("Stats")

do
    repeat wait(0.1) until players.LocalPlayer
    repeat wait(0.1) until players.LocalPlayer.Character
    repeat wait(0.1) until players.LocalPlayer.Character:FindFirstChild("LocalHumanoid")
    repeat wait(0.1) until players.LocalPlayer.PlayerGui:FindFirstChild("GameGui")
    repeat wait(0.1) until players.LocalPlayer.PlayerGui.GameGui:FindFirstChild("WeaponScript")
end

local prev_file
local lp = game.Players.LocalPlayer
local character = lp.Character
local root = character.PrimaryPart
local hum = character.LocalHumanoid
local jobid = game.JobId

function update_vars(ch)
    character = ch
    repeat wait() until ch.PrimaryPart ~= nil
    root = ch.PrimaryPart
    repeat wait() until ch:FindFirstChild("LocalHumanoid")
    hum = ch.LocalHumanoid
end
lp.CharacterAdded:Connect(update_vars)

function create_file()
    writefile("TLands\\" .. tostring(lp.Name) .. ".settings",http:JSONEncode({
        ["Version"] = "1.0",
        ["Rejoin"] = {
            ["On"] = false,
            ["Did"] = false,
            ["Type"] = nil
        },
        ["Autofarm"] = {
            ["Type"] = nil,
            ["Tool"] = nil,
            ["Island"] = nil
        },
        ["Misc"] = {
            ["TP"] = {},
            ["Mod"] = false,
            ["Regen"] = false,
            ["CD"] = false
        }
    }))
end
function update_file()
    writefile("TLands\\"..tostring(lp.Name)..".settings",http:JSONEncode(prev_file))
    prev_file = http:JSONDecode(readfile("TLands\\"..tostring(lp.Name)..".settings"))
end

if not isfolder("TLands") then
    makefolder("TLands")
    create_file()
elseif not isfile("TLands\\" .. tostring(lp.Name) .. ".settings") then
    create_file()
elseif isfile("TLands\\" .. tostring(lp.Name) .. ".settings") then
    if http:JSONDecode(readfile("TLands\\" .. tostring(lp.Name) .. ".settings")).Version ~= VERSION then
        delfile("TLands\\" .. tostring(lp.Name) .. ".settings")
        create_file()
    end
end

prev_file = http:JSONDecode(readfile("TLands\\" .. tostring(lp.Name) .. ".settings"))

-- Rejoin
local rejoin_toggle = false
local server_type
-- Auto Woodcut
local woodcut_toggle = false
local axe
-- Auto Mine
local mining_toggle = false
local pickaxe
local location
local ore_location = {}
for i,v in pairs(workspace.OreNodes:GetChildren()) do
    table.insert(ore_location, v.Name)
end
-- Kill aura
local killaura_toggle = false
local kaura_range
-- Teleport
local tp_islands = {"Blackwind"}
for i,v in pairs(workspace.Scenery["Island Terrain"]:GetChildren()) do
    table.insert(tp_islands, v.Name)
end

local backup_1
local backup_2
backup_1 = hookmetamethod(game, "__index", newcclosure(function(t,k)
    if t == 'LocalHumanoid' and k == 'WalkSpeed' then
        return 16
    end
    return backup_1(t,k)
end))
backup_2 = hookmetamethod(game, "__namecall", newcclosure(function(Self,...)
    local m = getnamecallmethod()
    if not checkcaller() and m == 'Kick' or m == 'FireServer' and (tostring(Self) == 'ReportGoogleAnalyticsEvent' or tostring(Self) == 'ErrorCode') then
        return nil
    end
    return backup_2(Self,...)
end))

local swing_func
for i,v in pairs(getsenv(lp.PlayerGui.GameGui.WeaponScript)) do
    if i == 'CheckTargets' then
        swing_func = v
    end
end

function tween(pos, speed, depth)
    local t_info = TweenInfo.new((root.Position - pos.Position).Magnitude * speed)
    t_goal = {CFrame = pos * CFrame.Angles(math.rad(90),0,0) * CFrame.new(0,0,depth)}
    local Tween = tween_serv:Create(root,t_info, t_goal)
    Tween:Play()
end

function equip_tool(swap_arg, tool_arg, tool)
    local swap = repli.RemoteFunctionz.Items.InventorySwap
    local equip = repli.RemoteFunctionz.Gear.Equip
    do
        repeat wait() until lp:FindFirstChild("PlayerGui")
        repeat wait() until lp.PlayerGui:FindFirstChild("GameGui")
        repeat wait() until lp.PlayerGui.GameGui:FindFirstChild("Hotbar")
        repeat wait() until lp.PlayerGui.GameGui.Hotbar:FindFirstChild("OpenInventory")
    end
    local button = lp.PlayerGui.GameGui.Hotbar.OpenInventory
    firesignal(button.MouseButton1Down); wait(0.25)
    swap:FireServer(swap_arg[tool][1], swap_arg[tool][2]); wait(1)
    equip:FireServer(false,tool_arg[tool][1],tool_arg[tool][2],tool_arg[tool][3],tool_arg[tool][4]); wait(1)
    equip:FireServer(true,tool_arg[tool][1],tool_arg[tool][2],tool_arg[tool][3],tool_arg[tool][4]); wait(0.25)
    firesignal(button.MouseButton1Down)
end

function check_tool()
    if character:FindFirstChild("ActiveGear") and character.ActiveGear:FindFirstChild("ItemName") then
        return character.ActiveGear.ItemName.Value
    end
    return nil
end

function tool_remote()
    if not character:FindFirstChild("ActiveGear") then
        return nil
    end
    if not character.ActiveGear:FindFirstChild("Handle") then
        return nil
    end
    if character.ActiveGear:FindFirstChild("Blade").Transparency == 1 then
        return nil
    end
    if not character.ActiveGear:FindFirstChild("ToolScript") then
        return nil
    end
    if not character.ActiveGear.ToolScript:FindFirstChild("Swing") then
        return nil
    end
    return character.ActiveGear.ToolScript.Swing
end

function swing(obj, rand)
    local remote = tool_remote()
    local arg1 = "left"
    local arg2 = swing_func()
    if remote == nil or arg2 == nil then
        return nil
    end
    local blade = remote.Parent.Parent:FindFirstChild("Blade")
    if blade == nil then
        return nil
    end
    if rand == 1 then
        arg1 = "left"
    elseif rand == 2 then
        arg1 = "right"
    elseif rand == 3 then
        arg1 = "up"
    elseif rand == 4 then
        arg1 = "down"
    end
    remote:FireServer(arg1, arg2)
    wait(0.1)
    firetouchinterest(obj, blade, 0)
    wait(0.1)
    firetouchinterest(obj, blade, 1)
    return true
end

function no_cd(bool)
    prev_file.Misc.CD = bool
    update_file()
    if bool == false then
        return
    end
    local hook
    hook = hookfunction(wait,function(num)
        if not checkcaller() and num ~= 0.1 and num ~= 0.2 then
            return hook()
        end
        return hook(num)
    end)
end

function regen_stam(bool)
    prev_file.Misc.Regen = bool
    update_file()
    if bool == false then
        return
    end
    for i,v in pairs(getsenv(lp.PlayerGui.GameGui.Stamina)) do
        if i == 'RegenStam' then
            debug.setconstant(v,10,100)
            debug.setconstant(v,12,100)
        end
    end
end

function anti_admin(bool)
    prev_file.Misc.Mod = bool
    update_file()
    if bool == false then
        return
    end
    local avoid = {13394438, 2638787, 726581, 36494953, 34643784, 4694354, 2341117727}
    for _,plr in pairs(players:GetPlayers()) do
        for _,id in pairs(avoid) do
            if plr.UserId == id then
                lp:Kick("Admin ingame.")
            end
        end
    end
    players.PlayerAdded:Connect(function(plr)
        for _,id in pairs(avoid) do
            if plr.UserId == id then
                lp:Kick("Admin joined.")
            end
        end
    end)
end

function rejoin_server(bool)
    rejoin_toggle = bool
    if bool == false then
        prev_file.Rejoin.On = bool
        update_file()
        return
    end
    prev_file.Rejoin.On = bool
    update_file()
    function tp_kick()
        local servers = http:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
        local avail_servers = {}
        local new_server
        for i,v in pairs(servers["data"]) do
            if v ~= game.JobId and v.playing ~= v.maxPlayers then
                table.insert(avail_servers, v)
            end
        end
        if server_type == 'Least' then
            for i,v in pairs(avail_servers) do
                table.sort(avail_servers, function(a, b)
                    return a.playing < b.playing
                end)
            end
            new_server = avail_servers[1]["id"]
        elseif server_type == 'Most' then
            for i,v in pairs(avail_servers) do
                table.sort(avail_servers, function(a, b)
                    return a.playing > b.playing
                end)
            end
            new_server = avail_servers[1]["id"]
        elseif server_type == 'Random' then
            new_server = avail_servers[math.random(1,#avail_servers)]["id"]
        elseif server_type == 'Same' then
            new_server = game.JobId
        elseif server_type == nil then
            return
        end
        prev_file.Rejoin.Did = true
        update_file()
        syn.queue_on_teleport([[
            if not game:IsLoaded() then
                game.Loaded:Wait()
            end
            local lp = game:GetService("Players").LocalPlayer
            repeat wait() until lp.PlayerGui:FindFirstChild("Menu")
            repeat wait() until lp.PlayerGui.Menu:FindFirstChild("TeamSelect")
            repeat wait() until lp.PlayerGui.Menu.TeamSelect:FindFirstChild("TeamPageScript")
            local intro = lp.PlayerGui.Menu.TeamSelect.TeamPageScript
            intro.Disabled = false
            wait(5)
            for i,v in pairs(getsenv(intro)) do
                if i == 'TeamThing' then
                    v(tostring(lp.Team))
                end
            end
        ]])
        teleport:TeleportToPlaceInstance(game.PlaceId, new_server)
    end
    core.RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(obj)
        if obj.Name == 'ErrorPrompt' then
            while wait(3) do 
                pcall(function() tp_kick() end)
            end
        end
    end)
    spawn(function()
        while rejoin_toggle do wait(5)
            local yes,ping = pcall(function() stats.Network.ServerStatsItem["Data Ping"]:GetValueString() end)
            if not yes then
                syn.queue_on_teleport([[
                    if not game:IsLoaded() then
                        game.Loaded:Wait()
                    end
                    local lp = game:GetService("Players").LocalPlayer
                    repeat wait() until lp.PlayerGui:FindFirstChild("Menu")
                    repeat wait() until lp.PlayerGui.Menu:FindFirstChild("TeamSelect")
                    repeat wait() until lp.PlayerGui.Menu.TeamSelect:FindFirstChild("TeamPageScript")
                    local intro = lp.PlayerGui.Menu.TeamSelect.TeamPageScript
                    intro.Disabled = false
                    wait(5)
                    for i,v in pairs(getsenv(intro)) do
                        if i == 'TeamThing' then
                            v(tostring(lp.Team))
                        end
                    end
                ]])
                prev_file.Rejoin.Did = true
                update_file()
                while wait(3) do
                    pcall(function()teleport:TeleportToPlaceInstance(198116126,jobid,LP)end)
                end
            end
        end
    end)
end

function autofarm_mine(bool)
    mining_toggle = bool
    if bool == false then
        prev_file.Autofarm.Type = nil
        update_file()
        return
    end
    prev_file.Autofarm.Type = "Mining"
    update_file()

    if pickaxe == nil or location == nil then
        error("Fail to select location/pickaxe.")
        return
    end

    local type_pick
    local what_pick = pickaxe
    if what_pick == "Stone Pickaxe" then
        type_pick = "Stone Pickaxe"
    else
        type_pick = "Pickaxe"
    end

    local swap_arg = {
        ["Gold Pickaxe"] = {
            [1] = "Pickaxe",
            [2] = {
                [1] = "Pickaxe",
                [2] = "100/100",
                [3] = 1,
                [4] = 15,
                [5] = 6
            }
        },
        ["Iron Pickaxe"] = {
            [1] = 1,
            [2] = {
                [1] = "Pickaxe",
                [2] = "100/100",
                [3] = 1,
                [4] = 2,
                [5] = 6
            }
        },
        ["Stone Pickaxe"] = {
            [1] = 1,
            [2] = {
                [1] = "Stone Pickaxe",
                [2] = "100/100",
                [3] = 0,
                [4] = 0,
                [5] = 4
            }
        }
    }
    local t_arg = {
        ["Gold Pickaxe"] = {
            [1] = 1,
            [2] = "Pickaxe",
            [3] = 1,
            [4] = 15
        },
        ["Iron Pickaxe"] = {
            [1] = 1,
            [2] = "Pickaxe",
            [3] = 1,
            [4] = 2,
        },
        ["Stone Pickaxe"] = {
            [1] = 1,
            [2] = "Stone Pickaxe",
            [3] = 0,
            [4] = 0
        }
    }

    run_serv:BindToRenderStep("state_change", 1, function()
        if hum == nil or not mining_toggle then
            run_serv:UnbindFromRenderStep("state_change")
            return
        end
        hum:ChangeState(11)
    end)

    for i,v in pairs(getconnections(game:GetService("Players").LocalPlayer.Idled)) do
        v:Disable()
    end
    
    function ore()
        local most = math.huge
        local ore
        for i,v in pairs(workspace.OreNodes:FindFirstChild(location):GetChildren()) do
            if (v.Position - root.Position).Magnitude < most and v.Broken.Value == false then
                most = (v.Position - root.Position).Magnitude
                ore = v
            end
        end
        return ore
    end

    while mining_toggle do wait()
        local ore = ore()
        if ore == nil then
            
        else
            tween(ore.CFrame, 0.0275, 10)
            if swing(ore, math.random(1,2)) == nil then
                if check_tool() == nil or not (check_tool() == type_pick) then
                    equip_tool(swap_arg, t_arg, what_pick)
                end
            end
        end
    end

end

function autofarm_woodcut(bool)
    woodcut_toggle = bool
    if bool == false then
        prev_file.Autofarm.Type = nil
        update_file()
        return
    end
    prev_file.Autofarm.Type = "Woodcut"
    update_file()

    if axe == nil then
        error("Fail to select axe.")
        return
    end

    local type_axe
    local what_axe = axe
    if what_axe == "Stone Axe" then
        type_axe = "Stone Axe"
    else
        type_axe = "Axe"
    end

    local swap_arg = {
        ["Gold Axe"] = {
            [1] = 1,
            [2] = {
                [1] = "Axe",
                [2] = "100/100",
                [3] = 1,
                [4] = 15,
                [5] = 6
            }
        },
        ["Iron Axe"] = {
            [1] = 1,
            [2] = {
                [1] = "Axe",
                [2] = "100/100",
                [3] = 1,
                [4] = 2,
                [5] = 6
            }
        },
        ["Stone Axe"] = {
            [1] = 1,
            [2] = {
                [1] = "Stone Axe",
                [2] = "100/100",
                [3] = 0,
                [4] = 0,
                [5] = 4
            }
        }
    }
    local t_arg = {
        ["Gold Axe"] = {
            [1] = 1,
            [2] = "Axe",
            [3] = 1,
            [4] = 15
        },
        ["Iron Axe"] = {
            [1] = 1,
            [2] = "Axe",
            [3] = 1,
            [4] = 2,
        },
        ["Stone Axe"] = {
            [1] = 1,
            [2] = "Stone Axe",
            [3] = 0,
            [4] = 0
        }
    }

    run_serv:BindToRenderStep("state_change", 1, function()
        if hum == nil or not woodcut_toggle then
            run_serv:UnbindFromRenderStep("state_change")
            return
        end
        hum:ChangeState(11)
    end)

    for i,v in pairs(getconnections(game:GetService("Players").LocalPlayer.Idled)) do
        v:Disable()
    end

    function tree()
        local most = 500
        local tree
        for i,v in pairs(workspace.Trees:GetDescendants()) do
            if v.Name == 'Trunk' and v.Broken.Value == false then
                if (v.Position - root.Position).Magnitude < most then
                    most = (v.Position - root.Position).Magnitude
                    tree = v
                end
            end
        end
        return tree
    end

    while woodcut_toggle do wait()
        local tree = tree()
        local stump = tree.Parent.Stump
        if tree == nil then
            
        else
            tween(stump.CFrame, 0.0275, 10)
            if swing(tree, math.random(1,2)) == nil then
                if check_tool() == nil or not (check_tool() == type_axe) then
                    equip_tool(swap_arg, t_arg, type_axe)
                end
            end
        end
    end
end

function kill_aura(bool)
    killaura_toggle = bool
    if bool == false or kaura_range == nil then
        return
    end
    function get_player()
        local most = kaura_range
        local plr
        for i,v in pairs(players:GetPlayers()) do
            if v ~= lp and v.Character ~= nil and v.Character.PrimaryPart ~= nil then
                if (v.Character.PrimaryPart.Position - root.Position).Magnitude < most then
                    most = (v.Character.PrimaryPart.Position - root.Position).Magnitude
                    plr = v
                end
            end
        end
        return plr
    end
    while killaura_toggle do wait()
        if check_tool() == nil then

        else
            local target = get_player()
            local blade = character.ActiveGear:FindFirstChild("Blade")
            if target == nil or blade == nil then

            else
                firetouchinterest(target.Character.PrimaryPart, blade, 0)
                wait(0.1)
                firetouchinterest(target.Character.PrimaryPart, blade, 1)
            end
        end
    end

end

function teleport_island()
    syn.queue_on_teleport([[
        if not game:IsLoaded() then
            game.Loaded:Wait()
        end
        local http = game:GetService("HttpService")
        local lp = game:GetService("Players").LocalPlayer
        local file = http:JSONDecode(readfile("TLands\\"..lp.Name..".settings"))
        local connection
        repeat wait() until lp.PlayerGui:FindFirstChild("Menu")
        repeat wait() until lp.PlayerGui.Menu:FindFirstChild("TeamSelect")
        repeat wait() until lp.PlayerGui.Menu.TeamSelect:FindFirstChild("TeamPageScript")
        local intro = lp.PlayerGui.Menu.TeamSelect.TeamPageScript
        intro.Disabled = false
        wait(5)
        for i,v in pairs(getsenv(intro)) do
            if i == 'TeamThing' then
                v(tostring(lp.Team))
            end
        end
        lp.CharacterAdded:Wait()
        connection = lp.Character.ChildAdded:Connect(function(obj)
            if obj.Name == 'HumanoidRootPart' then
                obj.CFrame = CFrame.new(file.Misc.TP[1], file.Misc.TP[2], file.Misc.TP[3])
                connection:Disconnect()
            end
        end)
    ]])
    teleport:TeleportToPlaceInstance(game.PlaceId, game.JobId)
end


local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

local home = library.CreateLib("Tradelands Hack 2.0","Serpent")

user_input.InputBegan:Connect(function(key, gameProcessed)
    if key.KeyCode == Enum.KeyCode.RightControl and not gameProcessed then
        library:ToggleUI()
    end
end)

local tab_1 = home:NewTab("Farming")

local section1_tab1 = tab_1:NewSection("Auto Rejoin")

section1_tab1:NewDropdown("Server Type", "click it.", {"Least", "Most", "Random", "Same"}, function(server)
    server_type = server
    prev_file.Rejoin.Type = server
    update_file()
end)
local rj_tog = section1_tab1:NewToggle("Rejoin", "Rejoins upon DC/Kicks and executes saved settings", rejoin_server)



local section2_tab1 = tab_1:NewSection("Auto Mine")

section2_tab1:NewDropdown("Pickaxes", "Choose a pickaxe to use.", {"Gold Pickaxe", "Iron Pickaxe", "Stone Pickaxe"}, function(tool)
    pickaxe = tool
    prev_file.Autofarm.Tool = tool
    update_file()
end)
section2_tab1:NewDropdown("Location", "Choose a location to mine.", ore_location, function(island)
    prev_file.Autofarm.Island = island
    location = island
    update_file()
end)
local afm_tog = section2_tab1:NewToggle("Mining", "Enable Auto Mine.", autofarm_mine)



local section3_tab1 = tab_1:NewSection("Auto Woodcut")

section3_tab1:NewDropdown("Axes", "Choose a axe to use.", {"Gold Axe","Iron Axe", "Stone Axe"}, function(tool)
    axe = tool
    prev_file.Autofarm.Tool = tool
    update_file()
end)
local afw_tog = section3_tab1:NewToggle("Woodcutting", "Enable Auto Woodcut.", autofarm_woodcut)



local tab_2 = home:NewTab("Pvp")

local section1_tab2 = tab_2:NewSection("Combat")

section1_tab2:NewSlider("K-Aura Range", "yes.", 20, 0, function(range)
    kaura_range = range
end)
section1_tab2:NewToggle("Kill Aura", "you just need to click.", kill_aura)



local tab_3 = home:NewTab("Misc")

local section2_tab3 = tab_3:NewSection("Teleport")

section2_tab3:NewDropdown("Island", "Select an island to tp to.", tp_islands, function(i)
    local c
    if i == 'Blackwind' then
        c = workspace.Blackwind.Position
    elseif i == 'Nova Balreska' then
        c = gethiddenproperty(workspace.Scenery["Island Terrain"]["Nova Balreska"].TerrainGroup, "Origin Position")
    else
        c = gethiddenproperty(workspace.Scenery["Island Terrain"][i], "Origin Position")
    end
    prev_file.Misc.TP = {c.X, 30, c.Z}
    update_file()
end)
section2_tab3:NewButton("Teleport", "Teleports you to an island by rejoining.", teleport_island)



local section3_tab3 = tab_3:NewSection("Useful Tools")

local am_tog = section3_tab3:NewToggle("Anti-Mod", "Kicks when a moderator is ingame with you.", anti_admin)
local fs_tog = section3_tab3:NewToggle("Regen Full Stam", "Regens full bar of stam when resting.", regen_stam)
local cd_tog = section3_tab3:NewToggle("No Cooldown", "No cooldown on most things.",  no_cd)

-- ===== Auto Execute ===== --
if prev_file.Rejoin.Did == true then
    prev_file.Rejoin.Did = false
    if prev_file.Rejoin.On == true then
        server_type = prev_file.Rejoin.Type
        coroutine.wrap(function()
            rj_tog:UpdateToggle("Rejoin", true)
        end)()
    end
    if prev_file.Autofarm.Type == 'Mining' then
        pickaxe = prev_file.Autofarm.Tool
        location = prev_file.Autofarm.Island
        coroutine.wrap(function()
            afm_tog:UpdateToggle("Mining", true)
        end)()
    elseif prev_file.Autofarm.Type == 'Woodcut' then
        axe = prev_file.Autofarm.Tool
        coroutine.wrap(function()
            afw_tog:UpdateToggle("Woodcutting", true)
        end)()
    end
    if prev_file.Misc.Mod == true then
        coroutine.wrap(function()
            am_tog:UpdateToggle("Anti-Mod", true)
        end)()
    end
    if prev_file.Misc.Regen == true then
        coroutine.wrap(function()
            fs_tog:UpdateToggle("Regen Full Stam", true)
        end)()
    end
    if prev_file.Misc.CD == true then
        coroutine.wrap(function()
            cd_tog:UpdateToggle("No Cooldown", true)
        end)()
    end
    update_file()
end
