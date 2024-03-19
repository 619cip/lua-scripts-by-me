if not game:IsLoaded() then
    game.Loaded:Wait()
end

local UserInput = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local my_file

if not isfile("Himoethy"..game:GetService("Players").LocalPlayer.Name..".STATS") then
    writefile("Himoethy"..game:GetService("Players").LocalPlayer.Name..".STATS", HttpService:JSONEncode({
        ["Enabled"] = {
            ["On"] = false,
            ["Time"] = nil
        },
        ["Total"] = 0,
        ["Servers"] = 0,
        ["New"] = 0
    }))
end
function update_file()
    writefile("Himoethy"..game:GetService("Players").LocalPlayer.Name..".STATS",HttpService:JSONEncode(my_file))
    my_file = HttpService:JSONDecode(readfile("Himoethy"..game:GetService("Players").LocalPlayer.Name..".STATS"))
end

my_file = HttpService:JSONDecode(readfile("Himoethy"..game:GetService("Players").LocalPlayer.Name..".STATS"))

local ScreenGui = Instance.new("ScreenGui")
syn.protect_gui(ScreenGui)
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.Name = syn.crypt.random(8)
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 222)
Frame.BackgroundTransparency = 0.4
Frame.Position = UDim2.new(0, 80, 0, 40)
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame.Parent = ScreenGui

local Total = Instance.new("TextLabel")
Total.Name = "Total"
Total.Size = UDim2.new(0, 189, 0, 30)
Total.BackgroundTransparency = 1
Total.Position = UDim2.new(0, 4, 0, 118)
Total.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Total.FontSize = Enum.FontSize.Size24
Total.TextSize = 20
Total.TextColor3 = Color3.fromRGB(255, 255, 255)
Total.Text = "Total Fruits Found:"
Total.Font = Enum.Font.SourceSans
Total.TextXAlignment = Enum.TextXAlignment.Left
Total.Parent = Frame

local TotalFruit = Instance.new("TextLabel")
TotalFruit.Name = "Stats"
TotalFruit.Size = UDim2.new(0, 120, 0, 30)
TotalFruit.BackgroundTransparency = 1
TotalFruit.Position = UDim2.new(0, 76, 0, 0)
TotalFruit.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TotalFruit.FontSize = Enum.FontSize.Size24
TotalFruit.TextSize = 20
TotalFruit.TextColor3 = Color3.fromRGB(255, 255, 255)
TotalFruit.Text = my_file["Total"]
TotalFruit.Font = Enum.Font.SourceSans
TotalFruit.TextXAlignment = Enum.TextXAlignment.Right
TotalFruit.Parent = Total

local New = Instance.new("TextLabel")
New.Name = "New"
New.Size = UDim2.new(0, 189, 0, 30)
New.BackgroundTransparency = 1
New.Position = UDim2.new(0, 5, 0, 178)
New.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
New.FontSize = Enum.FontSize.Size24
New.TextSize = 20
New.TextColor3 = Color3.fromRGB(255, 255, 255)
New.Text = "New Fruits Found:"
New.Font = Enum.Font.SourceSans
New.TextXAlignment = Enum.TextXAlignment.Left
New.Parent = Frame

local NewFruit = Instance.new("TextLabel")
NewFruit.Name = "Stats"
NewFruit.Size = UDim2.new(0, 120, 0, 30)
NewFruit.BackgroundTransparency = 1
NewFruit.Position = UDim2.new(0, 75, 0, 0)
NewFruit.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
NewFruit.FontSize = Enum.FontSize.Size24
NewFruit.TextSize = 20
NewFruit.TextColor3 = Color3.fromRGB(255, 255, 255)
NewFruit.Text = my_file["New"]
NewFruit.Font = Enum.Font.SourceSans
NewFruit.TextXAlignment = Enum.TextXAlignment.Right
NewFruit.Parent = New

local Servers = Instance.new("TextLabel")
Servers.Name = "Servers"
Servers.Size = UDim2.new(0, 190, 0, 30)
Servers.BackgroundTransparency = 1
Servers.Position = UDim2.new(0, 4, 0, 148)
Servers.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Servers.FontSize = Enum.FontSize.Size24
Servers.TextSize = 20
Servers.TextColor3 = Color3.fromRGB(255, 255, 255)
Servers.Text = "Servers Hopped:"
Servers.Font = Enum.Font.SourceSans
Servers.TextXAlignment = Enum.TextXAlignment.Left
Servers.Parent = Frame

local Hopped = Instance.new("TextLabel")
Hopped.Name = "Stats"
Hopped.Size = UDim2.new(0, 120, 0, 30)
Hopped.BackgroundTransparency = 1
Hopped.Position = UDim2.new(0, 76, 0, 0)
Hopped.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Hopped.FontSize = Enum.FontSize.Size24
Hopped.TextSize = 20
Hopped.TextColor3 = Color3.fromRGB(255, 255, 255)
Hopped.Text = my_file["Servers"]
Hopped.Font = Enum.Font.SourceSans
Hopped.TextXAlignment = Enum.TextXAlignment.Right
Hopped.Parent = Servers

local Status = Instance.new("TextLabel")
Status.Name = "Status"
Status.Size = UDim2.new(0, 190, 0, 30)
Status.BackgroundTransparency = 1
Status.Position = UDim2.new(0, 5, 0, 80)
Status.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Status.FontSize = Enum.FontSize.Size24
Status.TextSize = 20
Status.TextColor3 = Color3.fromRGB(255, 255, 255)
Status.Text = "Status:"
Status.Font = Enum.Font.SourceSans
Status.TextXAlignment = Enum.TextXAlignment.Left
Status.Parent = Frame

local CurrentStatus = Instance.new("TextLabel")
CurrentStatus.Name = "Stats"
CurrentStatus.Size = UDim2.new(0, 120, 0, 30)
CurrentStatus.BackgroundTransparency = 1
CurrentStatus.Position = UDim2.new(0, 75, 0, 0)
CurrentStatus.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CurrentStatus.FontSize = Enum.FontSize.Size24
CurrentStatus.TextSize = 20
CurrentStatus.TextColor3 = Color3.fromRGB(255, 255, 255)
CurrentStatus.Text = "Eating Ass"
CurrentStatus.Font = Enum.Font.SourceSans
CurrentStatus.TextXAlignment = Enum.TextXAlignment.Right
CurrentStatus.Parent = Status

local Timer = Instance.new("TextLabel")
Timer.Name = "Timer"
Timer.Size = UDim2.new(0, 190, 0, 30)
Timer.BackgroundTransparency = 1
Timer.Position = UDim2.new(0, 5, 0, 50)
Timer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Timer.FontSize = Enum.FontSize.Size24
Timer.TextSize = 20
Timer.TextColor3 = Color3.fromRGB(255, 255, 255)
Timer.Text = "Runtime:"
Timer.Font = Enum.Font.SourceSans
Timer.TextXAlignment = Enum.TextXAlignment.Left
Timer.Parent = Frame

local Clock = Instance.new("TextLabel")
Clock.Name = "Stats"
Clock.Size = UDim2.new(0, 120, 0, 30)
Clock.BackgroundTransparency = 1
Clock.Position = UDim2.new(0, 75, 0, 0)
Clock.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Clock.FontSize = Enum.FontSize.Size24
Clock.TextSize = 20
Clock.TextColor3 = Color3.fromRGB(255, 255, 255)
Clock.Text = "00:00:00"
Clock.Font = Enum.Font.SourceSans
Clock.TextXAlignment = Enum.TextXAlignment.Right
Clock.Parent = Timer

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(0, 200, 0, 50)
Title.BackgroundTransparency = 0.4
Title.BorderSizePixel = 0
Title.BackgroundColor3 = Color3.fromRGB(255, 5, 5)
Title.FontSize = Enum.FontSize.Size24
Title.TextSize = 20
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Text = "619cip's Fruit Collector"
Title.Font = Enum.Font.SourceSans
Title.Parent = Frame

function update_clock()
    if my_file["Enabled"]["Time"] == nil then
        Clock.Text = "00:00:00"
        return
    end
	local t = tick() - tonumber(my_file["Enabled"]["Time"])
	local seconds = t % 60
	local minutes = math.floor(t / 60) % 60
	local hours = math.floor(t / 3600) % 24
	Clock.Text = string.format("%.2i:%.2i:%.2i", hours, minutes, seconds)
end

coroutine.wrap(function()
    while my_file["Enabled"]["On"] do wait(1)
        update_clock()
    end
end)()

local fruit_list = {
    ["flame"] = "Flame-Flame",
    ["dark"] = "Dark-Dark",
    ["quake"] = "Quake-Quake",
    ["light"] = "Light-Light",
    ["human"] = "Human-Human: Buddha",
    ["rubber"] = "Rubber-Rubber",
    ["spring"] = "Spring-Spring",
    ["kilo"] = "Kilo-Kilo",
    ["diamond"] = "Diamond-Diamond",
    ["love"] = "Love-Love",
    ["spin"] = "Spin-Spin",
    ["door"] = "Door-Door",
    ["ice"] = "Ice-Ice",
    ["control"] = "Control-Control",
    ["dragon"] = "Dragon-Dragon",
    ["magma"] = "Magma-Magma",
    ["venom"] = "Venom-Venom",
    ["sand"] = "Sand-Sand",
    ["bomb"] = "Bomb-Bomb",
    ["spike"] = "Spike-Spike",
    ["chop"] = "Chop-Chop",
    ["smoke"] = "Smoke-Smoke",
    ["phoenix"] = "Bird-Bird: Phoenix",
    ["falcon"] = "Bird-Bird: Falcon",
    ["rumble"] = "Rumble-Rumble",
    ["string"] = "String-String",
    ["gravity"] = "Gravity-Gravity",
    ["paw"] = "Paw-Paw",
    ["barrier"] = "Barrier-Barrier",
    ["dough"] = "Dough-Dough"
}
function find_fruit_id()
    for i,v in pairs(game:GetService("Players").LocalPlayer.Character:GetChildren()) do
        if v:IsA("Tool") and v.Name:lower():find("fruit") then
            for i2,v2 in pairs(fruit_list) do
                if v.Name:lower():find(i2) then
                    return {v,v2}
                end
            end
        end
    end
    return nil
end
function store_fruit(fruit)
    my_file["Total"] = tonumber(my_file["Total"]) + 1
    update_file()
    TotalFruit.Text = my_file["Total"]
    local fruit_data = {}
    local arg1 = "getInventoryFruits"
    for i,v in pairs(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(arg1)) do
        table.insert(fruit_data,tostring(v['Name']))
    end
    for i,v in pairs(fruit_data) do
        if fruit[2] == v then
            CurrentStatus.Text = "Duplicate found"
            return
        end
    end
    my_file["New"] = tonumber(my_file["New"]) + 1
    update_file()
    NewFruit.Text = my_file["New"] 
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", fruit[2])
end
function collect_fruit(tool)
    firetouchinterest(tool.Handle, game.Players.LocalPlayer.Character.PrimaryPart, 0)
    wait(1)
    local fruit = find_fruit_id()
    if fruit == nil then
        CurrentStatus.Text = "No fruits found"
    else
        store_fruit(fruit)
    end
end
function server_hop()
    if isfile("NotSameServers.JSON") then
        local server_seeds = game:GetService("HttpService"):JSONDecode(readfile("NotSameServers.JSON"))
        if tonumber(table.getn(server_seeds)) >= 300 then
            delfile("NotSameServers.JSON")
        end
    end
    local PlaceID = game.PlaceId
    local AllIDs = {}
    local foundAnything = ""
    local actualHour = os.date("!*t").hour
    local Deleted = false
    local File = pcall(function()
        AllIDs = game:GetService('HttpService'):JSONDecode(readfile("NotSameServers.json"))
    end)
    if not File then
        table.insert(AllIDs, actualHour)
        writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
    end
    function TPReturner()
        local Site;
        if foundAnything == "" then
            Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
        else
            Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
        end
        local ID = ""
        if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
            foundAnything = Site.nextPageCursor
        end
        local num = 0;
        for i,v in pairs(Site.data) do
            local Possible = true
            ID = tostring(v.id)
            if tonumber(v.maxPlayers) > tonumber(v.playing) then
                for _,Existing in pairs(AllIDs) do
                    if num ~= 0 then
                        if ID == tostring(Existing) then
                            Possible = false
                        end
                    else
                        if tonumber(actualHour) ~= tonumber(Existing) then
                            local delFile = pcall(function()
                                delfile("NotSameServers.json")
                                AllIDs = {}
                                table.insert(AllIDs, actualHour)
                            end)
                        end
                    end
                    num = num + 1
                end
                if Possible == true then
                    table.insert(AllIDs, ID)
                    wait()
                    pcall(function()
                        writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
                        wait()
                        game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID, game.Players.LocalPlayer)
                    end)
                    wait(2)
                end
            end
        end
    end
    
    function Teleport()
        while wait() do
            pcall(function()
                CurrentStatus.Text = "Server hopping"
                TPReturner()
                if foundAnything ~= "" then
                    TPReturner()
                end
            end)
        end
    end
    my_file["Servers"] = tonumber(my_file["Servers"]) + 1
    update_file()
    Teleport()
end
function start_farm()
    repeat wait() until game.Players.LocalPlayer.Character
    repeat wait() until game.Players.LocalPlayer.Character.PrimaryPart

    if game.Players.LocalPlayer.Team ~= "Pirates" then
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam", "Pirates")
    end

    for i,v in pairs(game:GetService("Workspace"):GetChildren()) do
        if v:IsA("Tool") then
            update_file()
            collect_fruit(v)
        end
    end
    wait(3)
    server_hop()
end

update_clock()
if my_file["Enabled"]["On"] == true then

    coroutine.wrap(start_farm)()

else
    CurrentStatus.Text = "OFF"
end

UserInput.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.UserInputType == Enum.UserInputType.Keyboard then
        if input.KeyCode == Enum.KeyCode.Backquote then
            my_file["Enabled"]["On"] = not my_file["Enabled"]["On"]
            coroutine.wrap(function()
                while my_file["Enabled"]["On"] do wait(1)
                    update_clock()
                end
            end)()
            if my_file["Enabled"]["On"] == true then
                coroutine.wrap(start_farm)()
                CurrentStatus.Text = "ON"
                my_file["Enabled"]["Time"] = tick()
            else
                CurrentStatus.Text = "OFF"
            end
            update_file()
        elseif input.KeyCode == Enum.KeyCode.RightControl then
            ScreenGui.Enabled = not ScreenGui.Enabled
        elseif input.KeyCode == Enum.KeyCode.RightAlt then
            if isfile("NotSameServers.JSON") then
                delfile("NotSameServers.JSON")
            end
            writefile("Himoethy"..game:GetService("Players").LocalPlayer.Name..".STATS", HttpService:JSONEncode({
                ["Enabled"] = {
                    ["On"] = my_file["Enabled"]["On"],
                    ["Time"] = nil
                },
                ["Total"] = 0,
                ["Servers"] = 0,
                ["New"] = 0
            }))
            my_file = HttpService:JSONDecode(readfile("Himoethy"..game:GetService("Players").LocalPlayer.Name..".STATS"))
            Clock.Text = "00:00:00"
            TotalFruit.Text = my_file["Total"]
            Hopped.Text = my_file["Servers"]
            NewFruit.Text = my_file["New"]
        end
    end
end)
