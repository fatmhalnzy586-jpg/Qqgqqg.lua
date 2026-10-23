-- ==========================================
-- Rights: Mlouki Zaqzoouqi (ملوكي زقزوقي)
-- Universal Script: Fly & Safe Aimbot (Wall Check)
-- Works on: All Roblox Games
-- ==========================================

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

local Window = Library.CreateWindow({
    Name = "Universal Hub | حقوق ملوكي زقزوقي",
    Theme = "DarkTheme",
    Logo = "rbxassetid://0",
    ToggleKey = Enum.KeyCode.RightShift
})

-- ==========================================
-- تبويب الإيم بوت والطيران (Universal Main)
-- ==========================================
local MainTab = Window:NewTab("الرئيسية (عام)")
local AimSection = MainTab:NewSection("Aimbot & Fly - ملوكي زقزوقي")

local aimbotEnabled = false
local wallCheckEnabled = true
local fovRadius = 150

AimSection:NewToggle("تفعيل الإيم بوت (Universal Aimbot)", "توجيه تلقائي ناعم يعمل على جميع المابات", function(state)
    aimbotEnabled = state
end)

AimSection:NewToggle("فحص الجدران (ما يشبك ورا الجدار)", "يمنع التصويب إذا كان الهدف خلف جدار", function(state)
    wallCheckEnabled = state
end)

-- الخدمات العامة لروبلوكس
local Camera = workspace.CurrentCamera
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- دالة التحقق من الجدران (Wall Check)
local function isVisible(targetPart)
    if not wallCheckEnabled then return true end
    local origin = Camera.CFrame.Position
    local destination = targetPart.Position
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = RaycastFilterType.Exclude
    
    -- استثناء اللاعب الحالي والـ Character
    local filterList = {Camera}
    if LocalPlayer.Character then
        table.insert(filterList, LocalPlayer.Character)
    end
    raycastParams.FilterDescendantsInstances = filterList
    
    local result = workspace:Raycast(origin, destination - origin, raycastParams)
    if result and result.Instance then
        if result.Instance:IsDescendantOf(targetPart.Parent) then
            return true
        end
        return false
    end
    return true
end

-- دالة البحث عن أقرب هدف عام لكل المابات
local function getClosestTarget()
    local closestPart = nil
    local shortestDistance = math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            -- التعرف على أجزاء الهدف (Head أو HumanoidRootPart)
            local targetPart = player.Character:FindFirstChild("Head") or player.Character:FindFirstChild("HumanoidRootPart")
            if targetPart then
                local screenPoint, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                if onScreen then
                    local mousePos = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                    local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - mousePos).Magnitude
                    
                    if distance < shortestDistance and distance <= fovRadius then
                        if isVisible(targetPart) then
                            closestPart = targetPart
                            shortestDistance = distance
                        end
                    end
                end
            end
        end
    end
    return closestPart
end

-- حلقة التوجيه المباشر للإيم بوت
game:GetService("RunService").RenderStepped:Connect(function()
    if aimbotEnabled then
        local target = getClosestTarget()
        if target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
        end
    end
end)

-- ==========================================
-- نظام الطيران الشامل (Universal Fly)
-- ==========================================
local flying = false
local flySpeed = 50

AimSection:NewToggle("تفعيل الطيران (Fly)", "طيران يعمل في أي ماب بحرية", function(state)
    flying = state
    local char = LocalPlayer.Character
    if not char then return end
    
    local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
    if not hrp then return end
    
    if flying then
        local bv = Instance.new("BodyVelocity")
        bv.Name = "UniversalFly_Mlouki"
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
        if hrp:FindFirstChild("UniversalFly_Mlouki") then
            hrp.UniversalFly_Mlouki:Destroy()
        end
    end
end)

AimSection:NewSlider("سرعة الطيران", "تحديد السرعة المناسبة لكل ماب", 150, 10, function(s)
    flySpeed = s
end)

-- قسم الحقوق
local CreditSection = MainTab:NewSection("الحقوق والتطوير")
CreditSection:NewLabel("السكربت عام لكل المابات - Universal")
CreditSection:NewLabel("حقوق التطوير: ملوكي زقزوقي")
