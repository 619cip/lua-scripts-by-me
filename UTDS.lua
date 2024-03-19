-- =============== --
--  UTDS AUTO FARM --
-- =============== --

if not game:IsLoaded() then
    game.Loaded:Wait()
end

if game.PlaceId == 5902977746 then

local players = game:GetService("Players")
local starter = game:GetService("StarterGui")
local http = game:GetService("HttpService")
local repli = game:GetService("ReplicatedStorage")
local starter = game:GetService("StarterGui")
local teleport = game:GetService("TeleportService")
local userInput = game:GetService("UserInputService")

local maps = {
    "CostaSmeralda",
    "SkeletonHeelStone",
    "ValleyOfTheEnd",
    "KamiLookout",
    "HiddenLeafVillage",
    "KamiiUniversity",
    "PlanetNamek",
    "TrostDistrict",
    "Marineford",
    "DarkDimension",
    "Space",
    "Atlantis",
    "Asgard",
    "Castle",
    "Japan",
    "Military",
    "Jungle",
    "Subzero",
    "City"
}

if not isfolder("UTDS_CONFIGS") then
    makefolder("UTDS_CONFIGS")
end

function message(title,text)
    starter:SetCore(
        "SendNotification",
        {
            Title = title,
            Text = text,
            Duration = 5
        }
    )
end

function recordSetup()
    message("Recording", "A config is now being recorded.")

    local towers = workspace.EntityModels.Towers
    local mainGUI = players.LocalPlayer.PlayerGui.MainGui
    local errorMessages = players.LocalPlayer.PlayerGui.MessagesGui.Frame
    local roundOver = mainGUI.MainFrames.RoundOver
    local startNextWave = mainGUI.MainFrames.StartNextWave
    local gameTimer = mainGUI.MainFrames.TimeUntilMatchStarts.Timer

    local towerAbility = repli.Modules.GlobalInit.RemoteEvents.PlayerActivateTowerAbility
    local setTargetMode = repli.Modules.GlobalInit.RemoteEvents.PlayerSetTowerTargetMode
    local mapDifficulty = repli.GenericModules.Service.Network.PlayerVoteForDifficulty
    local placeTower = repli.GenericModules.Service.Network.PlayerPlaceTower
    local sellTower = repli.GenericModules.Service.Network.PlayerSellTower
    local upgradeTower = repli.GenericModules.Service.Network.PlayerUpgradeTower

    local UTDS_SETTINGS = {["ALL_TOWERS_DATA"] = {}}
    local ALL_TOWERS_DATA = UTDS_SETTINGS["ALL_TOWERS_DATA"]
    local initialTick = tick()

    function closeTower(_Vector1, _Vector2)
        return math.sqrt((_Vector2.X - _Vector1.X) ^ 2 + (_Vector2.Z - _Vector2.Z) ^ 2)
    end

    function findTower(TempID)
        local argument = math.huge
        local closestTower
        for index1, data in pairs(ALL_TOWERS_DATA) do
            if closeTower(data[2], towers[TempID].HumanoidRootPart.Position) < argument then
                argument = closeTower(data[2], towers[TempID].HumanoidRootPart.Position)
                closestTower = index1
            end
        end
        return closestTower
    end

    function yieldMove(moveTime,moveType,args)
        local connection
        if moveType == 'Place' then
            connection =
                errorMessages.ChildAdded:Connect(
                function(obj)
                    connection:Disconnect()
                    if
                        obj.Text == args[1] or string.match(obj.Text, args[2]) ~= nil or
                            string.match(obj.Text, args[3]) ~= nil
                    then
                        for index, v in pairs(ALL_TOWERS_DATA) do
                            if v[1] == moveTime then
                                print("Yielding placement data " .. v[3])
                                rawset(ALL_TOWERS_DATA,index,nil)
                            end
                        end
                    end
                end
            )
            coroutine.wrap(
                function()
                    wait(1)
                    connection:Disconnect()
                end
            )()
        elseif moveType == 'Upgrade' then
            connection =
                errorMessages.ChildAdded:Connect(
                function(obj)
                    connection:Disconnect()
                    if
                        obj.Text == args[1]
                    then
                        for index, v in pairs(ALL_TOWERS_DATA) do
                            if v[6][#v[6]] == moveTime then
                                print("Yielding upgrade data " .. v[3])
                                rawset(v[6],#v[6],nil)
                            end
                        end
                    end
                end
            )
            coroutine.wrap(
                function()
                    wait(0.1)
                    connection:Disconnect()
                end
            )()
        end
    end

    function _newTower(Slot, ID)
        print("New Tower: " .. Slot)
        local connection
        local placementTime = tick()
        local towerID = ID
        local towerSlot = Slot
        local jsonVector = {ID.X, ID.Y, ID.Z}
        table.insert(
            ALL_TOWERS_DATA,
            {
                placementTime,
                towerID,
                towerSlot,
                jsonVector,
                nil, -- SELL
                {}, -- UPGRADE
                {}, -- TARGET
                {} -- ABILITY
            }
        )
        yieldMove(placementTime,"Place",{"You cannot place this tower here!","Too close to","You've already placed"})
    end

    function _sellTower(TempID)
        print("Sold Tower: " .. TempID)
        local soldTime = tick()
        local towerIndex = findTower(TempID)
        ALL_TOWERS_DATA[towerIndex][5] = soldTime
    end

    function _upgradeTower(TempID)
        print("Upgraded Tower: " .. TempID)
        local upgradeTime = tick()
        local towerIndex = findTower(TempID)
        local towerData = ALL_TOWERS_DATA[towerIndex][6]
        towerData[#towerData + 1] = upgradeTime
        yieldMove(upgradeTime,"Upgrade",{"You don't have enough cash to upgrade this tower!"})
    end

    function _targetTower(TempID, TargetMode)
        print("Target Changed: " .. TempID .. " " .. TargetMode)
        local targetTime = tick()
        local towerIndex = findTower(TempID)
        ALL_TOWERS_DATA[towerIndex][7][1] = targetTime
        ALL_TOWERS_DATA[towerIndex][7][2] = TargetMode
    end

    function _abilityTower(TempID)
        print("Ability Used: " .. TempID)
        local abilityTime = tick()
        local towerIndex = findTower(TempID)
        local towerData = ALL_TOWERS_DATA[towerIndex][8]
        towerData[#towerData + 1] = abilityTime
    end

    function _mapDifficulty(difficulty)
        print("Difficulty: " .. difficulty)
        UTDS_SETTINGS["Difficulty"] = {difficulty,tick()}
    end

    local mt = getrawmetatable(game)
    local old = mt.__namecall
    setreadonly(mt, false)

    mt.__namecall =
        newcclosure(
        function(self, ...)
            local args = {...}
            if getnamecallmethod() == "FireServer" then
                if self == placeTower then
                    _newTower(args[1], args[2])
                elseif self == sellTower then
                    _sellTower(args[1])
                elseif self == upgradeTower then
                    _upgradeTower(args[1])
                elseif self == setTargetMode then
                    _targetTower(args[1], args[2])
                elseif self == mapDifficulty then
                    _mapDifficulty(args[1])
                elseif self == towerAbility then
                    _abilityTower(args[1])
                end
            end
            return old(self, unpack(args))
        end
    )

    roundOver:GetPropertyChangedSignal("Visible"):Connect(
        function()
            UTDS_SETTINGS["Timelength"] = {initialTick, tick()}
            if getgenv().configName == nil then
                getgenv().configName = http:GenerateGUID(false)
            end
            if getgenv().autoSkip ~= nil then
                UTDS_SETTINGS["Skip"] = getgenv().autoSkip
            end
            writefile("UTDS_CONFIGS\\" .. getgenv().configName .. ".lua", http:JSONEncode(UTDS_SETTINGS))
            message("Saved Config",getgenv().configName.." has been saved.")
        end
    )
end

function loadConfig()
    repeat
        wait()
    until players.LocalPlayer.PlayerGui:FindFirstChild("MainGui")

    coroutine.wrap(
        function()
            while true do wait(1)
                if #players:GetPlayers() > 1 then
                    getgenv().playerJoined = true
                end
            end
        end
    )()

    local towers = workspace.EntityModels.Towers
    local mainGUI = players.LocalPlayer.PlayerGui.MainGui
    local errorMessages = players.LocalPlayer.PlayerGui.MessagesGui.Frame
    local roundOver = mainGUI.MainFrames.RoundOver
    local startNextWave = mainGUI.MainFrames.StartNextWave
    local gameTimer = mainGUI.MainFrames.TimeUntilMatchStarts.Timer

    local towerAbility = repli.Modules.GlobalInit.RemoteEvents.PlayerActivateTowerAbility
    local setTargetMode = repli.Modules.GlobalInit.RemoteEvents.PlayerSetTowerTargetMode
    local mapDifficulty = repli.GenericModules.Service.Network.PlayerVoteForDifficulty
    local placeTower = repli.GenericModules.Service.Network.PlayerPlaceTower
    local sellTower = repli.GenericModules.Service.Network.PlayerSellTower
    local upgradeTower = repli.GenericModules.Service.Network.PlayerUpgradeTower

    local configuration = http:JSONDecode(readfile(getgenv().configuration))
    local totalTime = configuration["Timelength"][2] - configuration["Timelength"][1]
    local stopPlayingSkips = false

    function calculateMoveOrder()
        local listTimes = {}
        listTimes[1] = {"DIFFICULTY",configuration["Difficulty"][1],configuration["Timelength"][2] - configuration["Difficulty"][2]}
        for _, data in pairs(configuration["ALL_TOWERS_DATA"]) do
            table.insert(listTimes, {"PLACE", data, configuration["Timelength"][2] - data[1]})
            if data[5] ~= nil then
                table.insert(listTimes, {"SELL", data, configuration["Timelength"][2] - data[5]})
            end
            if #data[6] ~= 0 then
                for _, upgradeTime in pairs(data[6]) do
                    table.insert(listTimes, {"UPGRADE", data, configuration["Timelength"][2] - upgradeTime})
                end
            end
            if #data[7] ~= 0 then
                table.insert(listTimes, {"TARGET", data, configuration["Timelength"][2] - data[7][1]})
            end
            if #data[8] ~= 0 then
                for _, abilityTime in pairs(data[8]) do
                    table.insert(listTimes, {"ABILITY", data, configuration["Timelength"][2] - abilityTime})
                end
            end
        end
        table.sort(
            listTimes,
            function(a, b)
                return a[3] > b[3]
            end
        )
        return listTimes
    end

    function countStars(indexes)
        local stars = 0
        for _, obj in pairs(indexes:GetChildren()) do
            if obj:IsA("ImageLabel") and obj.Visible == true then
                stars = stars + 1
            end
        end
        return stars
    end

    function verifyMove(moveType,remote,args,tower_path)
        local connection
        if moveType == "Upgrade" then
            connection =
                errorMessages.ChildAdded:Connect(
                function(obj)
                    connection:Disconnect()
                    if
                        obj.Text == "You don't have enough cash to upgrade this tower!"
                    then
                        local star = countStars(tower_path)
                        repeat wait(0.3)
                            print("Correcting upgrade error")
                            remote:FireServer(args)
                        until countStars == 5 or countStars(tower_path) >= star + 1
                    end
                end
            )
            coroutine.wrap(
                function()
                    wait(0.1)
                    connection:Disconnect()
                end
            )()
        elseif moveType == "Place" then
            local placed = false
            towers.ChildAdded:Connect(function()
                placed = true
            end)
            wait(1)
            while not placed do wait(0.1)
                print("Correcting placement error")
                remote:FireServer(unpack(args))
            end
        end
    end

    function autoSkipWave()
        print("Auto Skip On")
        startNextWave:GetPropertyChangedSignal("Visible"):Connect(
            function()
                local autoSkip = repli.Modules.GlobalInit.RemoteEvents.PlayerReadyForNextWave
                if startNextWave.Visible == true then
                    autoSkip:FireServer()
                end
            end
        )
    end

    coroutine.wrap(
        function()
            if configuration["Skip"] ~= nil then
                wait(configuration["Skip"] - configuration["Timelength"][1])
                autoSkipWave()
            end
        end
    )()

    for _, move in pairs(calculateMoveOrder()) do
        if getgenv().playerJoined == true then
            print("Player Joined")
            break
        end
        print("Waiting :" .. totalTime - move[3])
        wait(totalTime - move[3])
        totalTime = move[3]
        if move[1] == "PLACE" then
            print("Placing")
            local connection
            local vector = Vector3.new(move[2][4][1], move[2][4][2], move[2][4][3])
            connection =
                towers.ChildAdded:Connect(
                function(obj)
                    connection:Disconnect()
                    move[2][9] = obj.Name
                end
            )
            placeTower:FireServer(move[2][3], vector)
            coroutine.wrap(verifyMove)("Place",placeTower,{move[2][3],vector})
            towers.ChildAdded:Wait()
        elseif move[1] == "SELL" then
            print("Selling")
            sellTower:FireServer(move[2][9])
        elseif move[1] == "UPGRADE" then
            print("Upgrading")
            local towerPath = towers[move[2][9]].Head.TowerGui.Stars
            local stars = countStars(towerPath)
            upgradeTower:FireServer(move[2][9])
            coroutine.wrap(verifyMove)("Upgrade",upgradeTower,move[2][9],towerPath)
            repeat wait(0.1) until countStars(towerPath) == 5 or countStars(towerPath) > stars
        elseif move[1] == "TARGET" then
            print("Targeting")
            setTargetMode:FireServer(move[2][9], move[2][7][2])
        elseif move[1] == "ABILITY" then
            print("Ability")
            towerAbility:FireServer(move[2][9])
        elseif move[1] == "DIFFICULTY" then
            mapDifficulty:FireServer(configuration["Difficulty"][1])
        end
    end
end

function teleportation()
    pcall(function()
        local ListedServers =
            http:JSONDecode(
            game:HttpGet(
                "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
            )
        )
        for _, Server in pairs(ListedServers["data"]) do
            if Server ~= game.JobId and Server.playing ~= Server.maxPlayers then
                teleport:TeleportToPlaceInstance(game.PlaceId, Server["id"])
                break
            end
        end
    end)
end

function autoPlay()
    local import = http:JSONDecode(readfile("UTDS_AutoExecute.lua"))
    getgenv().autoExeMap = import[1]
    getgenv().autoExeConfig = import[2]
    if workspace:FindFirstChild("Lobby") then
        local startTeleport = repli.Modules.GlobalInit.RemoteEvents.PlayerQuickstartTeleport
        local selectMap = repli.Modules.GlobalInit.RemoteEvents.PlayerSelectedMap
        local teleporter = workspace.Lobby.ClassicPartyTeleporters.Teleporter4.Teleport.Part
        repeat
            wait()
        until game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        repeat
            wait()
        until game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
        local humRoot = game.Players.LocalPlayer.Character.HumanoidRootPart
        local hum = game.Players.LocalPlayer.Character.Humanoid
        coroutine.wrap(
            function()
                while wait() do
                    hum:ChangeState(11)
                end
            end
        )()
        humRoot.CFrame = teleporter.CFrame
        wait(1)
        selectMap:FireServer(getgenv().autoExeMap)
        for i = 1, 5 do
            wait(1)
            startTeleport:FireServer()
        end
        while true do 
            teleportation()
            wait(1)
        end
    else
        getgenv().configuration = getgenv().autoExeConfig
        loadConfig()
    end
end

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

local home = library.CreateLib("Cip's Hub","Serpent")

userInput.InputBegan:Connect(function(key, gameProcessed)
    if key.KeyCode == Enum.KeyCode.LeftControl and not gameProcessed then
        library:ToggleUI()
    end
end)

-- ===== Auto Farm Tab ===== --

local tab01 = home:NewTab("Auto Farm")

-- ===== Record Config Section ===== --

local tab01_Section01 = tab01:NewSection("Record Configuration")

tab01_Section01:NewTextBox("Config Name", "The configuration's name.", function(txt)
    getgenv().configName = txt
end)

tab01_Section01:NewButton("Record Config", "Click this before choosing difficulty.", recordSetup)

tab01_Section01:NewButton("Add Auto Skip", "Adds Auto Skip at this certain time point.", function()
    getgenv().autoSkip = tick()
    local mainGUI = players.LocalPlayer.PlayerGui.MainGui
    local startNextWave = mainGUI.MainFrames.StartNextWave
    startNextWave:GetPropertyChangedSignal("Visible"):Connect(
        function()
            local autoSkip = repli.Modules.GlobalInit.RemoteEvents.PlayerReadyForNextWave
            if startNextWave.Visible == true then
                autoSkip:FireServer()
            end
        end
    )
end)

-- ===== Play Config Section ===== --

local tab01_Section02 = tab01:NewSection("Play Configuration")

local con01 = tab01_Section02:NewDropdown("Configs", "Choose a config to play in game.", listfiles("UTDS_CONFIGS"), function(setup)
    getgenv().configuration = setup
end)

tab01_Section02:NewButton("Play Config", "Play a config in a game.", function()
    if getgenv().configuration == nil then
        message("You must first select a config.", "Select a config first.")
    else
        loadConfig()
    end
end)

-- ===== Auto Farm Section ===== --

local tab01_Section03 = tab01:NewSection("Auto Farm")

tab01_Section03:NewDropdown("Maps", "Choose a map to auto farm on.", maps, function(map)
    getgenv().autoExeMap = map
end)

local con02 = tab01_Section03:NewDropdown("Configs", "Choose a config to use.", listfiles("UTDS_CONFIGS"), function(setup)
    getgenv().autoExeConfig = setup
end)

local togAF = tab01_Section03:NewToggle("Auto Farm", "Enable Auto Farm. Script should be in a auto execute folder.", function(state)
    if not isfile("UTDS_AutoExecute.lua") and state == true then  
        writefile(
            "UTDS_AutoExecute.lua",
            http:JSONEncode({getgenv().autoExeMap, tostring(getgenv().autoExeConfig)})
        )
    elseif isfile("UTDS_AutoExecute.lua") and state == false then
        delfile("UTDS_AutoExecute.lua")
        return
    end
    autoPlay()
end)

-- ===== Misc Section ===== --

local tab01_Section04 = tab01:NewSection("Misc")

local con03 = tab01_Section04:NewDropdown("Delete Config", "Choose a config to delete", listfiles("UTDS_CONFIGS"), function(setup)
    getgenv().configDelete = setup
end)

tab01_Section04:NewButton("Delete Config", "Delete a Config", function()
    if getgenv().configDelete == nil then
        message("You must first select a config.", "Select a config first.")
    else
        delfile(getgenv().configDelete)
        con01:Refresh(listfiles("UTDS_CONFIGS"))
        con02:Refresh(listfiles("UTDS_CONFIGS"))
        con03:Refresh(listfiles("UTDS_CONFIGS"))
    end
end)

if isfile("UTDS_AutoExecute.lua") then
    coroutine.wrap(function()
        togAF:UpdateToggle("Auto Farm", true)
    end)()
end

end