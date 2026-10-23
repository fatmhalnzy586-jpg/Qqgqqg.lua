-- ==========================================
-- Developer: Mlouki Zaqzoouqi (ملوكي زقزوقي)
-- Universal Script: Modern Custom UI (No Kavo)
-- Features: Fly + Wall Check Safe Aimbot
-- ==========================================

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- حذف الواجهة القديمة إذا كانت مفتوحة
if CoreGui:FindFirstChild("MloukiHubUI") then
    CoreGui.MloukiHubUI:Destroy()
end

-- إنشاء واجهة المستخدم الاحترافية
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MloukiHubUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 290, 0, 310)
MainFrame.Position = UDim2.new(0.5, -145, 0.4, -155)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
Title.Text = "Mlouki Hub | حقوق ملوكي زقزوقي"
Title.TextColor3 = Color3.fromRGB(255, 215, 0)
Title.TextSize = 15
Title.Font = Enum.Font.SourceSansBold
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = Title

-- متغيرات الإيم بوت والطيران
local aimbotEnabled = false
local wallCheckEnabled = true
local flying = false
local flySpeed = 50

-- دالة إنشاء الأزرار المخصصة
local function createButton(text, posY, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.85, 0, 0, 40)
    btn.Position = UDim2.new(0.075, 0, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansSemibold
    btn.TextSize = 14
    btn.Parent = MainFrame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        callback(btn)
    end)
    return btn
end

-- 1. زر الإيم بوت
createButton("الإيم بوت: معطل ❌", 60, function(btn)
    aimbotEnabled = not aimbotEnabled
    if aimbotEnabled then
        btn.Text = "الإيم بوت: شغال ✅"
        btn.BackgroundColor3 = Color3.fromRGB(46, 139, 87)
    else
        btn.Text = "الإيم بوت: معطل ❌"
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    end
end)

-- 2. زر جدار الحماية (Wall Check)
createButton("فحص الجدران: شغال ✅", 115, function(btn)
    wallCheckEnabled = not wallCheckEnabled
    if wallCheckEnabled then
        btn.Text = "فحص الجدران: شغال ✅"
        btn.BackgroundColor3 = Color3.fromRGB(46, 139, 87)
    else
        btn.Text = "فحص الجدران: معطل ❌"
        btn.BackgroundColor3 = Color3.fromRGB(178, 34, 34)
    end
end)

-- 3. زر الطيران
createButton("الطيران: معطل ❌", 170, function(btn)
    flying = not flying
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart

    if flying then
        btn.Text = "الطيران: شغال ✅"
        btn.BackgroundColor3 = Color3.fromRGB(46, 139, 87)
        local bv = Instance.new("BodyVelocity")
        bv.Name = "CustomFly_Mlouki"
        bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.Parent = hrp

        task.spawn(function()
            while flying and task.wait() do
                bv.Velocity = Camera.CFrame.LookVector * flySpeed
            end
            bv:Destroy()
        end)
    else
        btn.Text = "الطيران: معطل ❌"
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
        if hrp:FindFirstChild("CustomFly_Mlouki") then
            hrp.CustomFly_Mlouki:Destroy()
        end
    end
end)

-- الحقوق أسفل الواجهة
local Credits = Instance.new("TextLabel")
Credits.Size = UDim2.new(1, 0, 0, 30)
Credits.Position = UDim2.new(0, 0, 1, -35)
Credits.BackgroundTransparency = 1
Credits.Text = "تطوير وحقوق: ملوكي زقزوقي | Universal"
Credits.TextColor3 = Color3.fromRGB(180, 180, 180)
Credits.TextSize = 13
Credits.Font = Enum.Font.SourceSansItalic
Credits.Parent = MainFrame

-- ==========================================
-- منطق الإيم بوت وفحص الجدار (Raycasting)
-- ==========================================
local function isVisible(targetPart)
    if not wallCheckEnabled then return true end
    local origin = Camera.CFrame.Position
    local destination = targetPart.Position
    local rayParams = RaycastParams.new()
    rayParams.FilterType = RaycastFilterType.Exclude

    local filterList = {Camera}
    if LocalPlayer.Character then
        table.insert(filterList, LocalPlayer.Character)
    end
    rayParams.FilterDescendantsInstances = filterList

    local result = Workspace:Raycast(origin, destination - origin, rayParams)
    if result and result.Instance then
        return result.Instance:IsDescendantOf(targetPart.Parent)
    end
    return true
end

local function getClosestTarget()
    local closest = nil
    local shortestDistance = math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local head = player.Character:FindFirstChild("Head") or player.Character:FindFirstChild("HumanoidRootPart")
            if head then
                local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local mousePos = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if dist < shortestDistance and dist <= 200 then
                        if isVisible(head) then
                            closest = head
                            shortestDistance = dist
                        end
                    end
                end
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    if aimbotEnabled then
        local target = getClosestTarget()
        if target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
        end
    end
end)

