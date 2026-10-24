
--[[
    TeaHack V1
    Game: Blox Spin
    Owner: xy6q
    Mobile GUI
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local old = PlayerGui:FindFirstChild("TeaHack")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "TeaHack"
gui.ResetOnSpawn = false
gui.Parent = PlayerGui

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(285, 310)
main.Position = UDim2.new(0.5, -142, 0.35, 0)
main.BackgroundColor3 = Color3.fromRGB(17, 17, 23)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = gui

Instance.new("UICorner", main).CornerRadius =
    UDim.new(0, 12)

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(255, 190, 55)
stroke.Thickness = 1.5
stroke.Parent = main

local function label(text, pos, size, color)
    local obj = Instance.new("TextLabel")
    obj.Position = pos
    obj.Size = size
    obj.BackgroundTransparency = 1
    obj.Text = text
    obj.TextColor3 = color or Color3.new(1, 1, 1)
    obj.Font = Enum.Font.GothamBold
    obj.TextSize = 15
    obj.Parent = main
    return obj
end

local function button(text, y, callback)
    local b = Instance.new("TextButton")
    b.Position = UDim2.fromOffset(12, y)
    b.Size = UDim2.new(1, -24, 0, 38)
    b.BackgroundColor3 = Color3.fromRGB(34, 34, 43)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Text = text
    b.Font = Enum.Font.GothamSemibold
    b.TextSize = 13
    b.Parent = main

    Instance.new("UICorner", b).CornerRadius =
        UDim.new(0, 7)

    b.Activated:Connect(callback)
    return b
end

label("TeaHack V1", UDim2.fromOffset(12, 8),
    UDim2.new(1, -24, 0, 32),
    Color3.fromRGB(255, 190, 55))

label("OWNER: xy6q", UDim2.fromOffset(12, 37),
    UDim2.new(1, -24, 0, 22),
    Color3.fromRGB(180, 180, 190))

local status = label("Status: Ready",
    UDim2.fromOffset(12, 260),
    UDim2.new(1, -24, 0, 25),
    Color3.fromRGB(90, 230, 140))

button("Player Information", 70, function()
    local character = LocalPlayer.Character
    local humanoid = character and
        character:FindFirstChildOfClass("Humanoid")

    if humanoid then
        status.Text = "Health: " ..
            math.floor(humanoid.Health) .. "/" ..
            math.floor(humanoid.MaxHealth)
    else
        status.Text = "Character unavailable"
    end
end)

button("Player List", 116, function()
    status.Text = "Players: " .. #Players:GetPlayers()
end)

button("ESP Demo (UI Only)", 162, function()
    status.Text = "ESP demo - no tracking enabled"
end)

button("Close Menu", 208, function()
    gui:Destroy()
end)
