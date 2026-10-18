--[[
    MOYAN HUB UI · 誓言全功能移植版
    界面：Obsidian（MOYAN HUB UI）
    功能：誓言2 全部功能（带来树 / 一键加工 / 传送物品 / 传送地点 / 汽车传送 /
          恶魔鸭合成 / EvilHeart 合成 / 提示翻译 / 鸭子带回 / 特殊鸭操作 / 商店购买）
    说明：誓言原有 GUI（面板、卡密、按键、拖窗）均已剥离，交互全部通过 MOYAN UI 完成
]]

-- ====== 1. 加载 UI 库（链接沿用原脚本，未做修改） ======
local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library      = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager  = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

-- ====== 2. 游戏服务（誓言逻辑所需） ======
local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local lp = Players.LocalPlayer
local ws = workspace
local rep = game:GetService("ReplicatedStorage")
local mouse = lp:GetMouse()

-- ====== 2.5 卡密系统（动画 + 验证） ======
local CARD_KEY = "陌颜nb"
local TweenService = game:GetService("TweenService")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

-- 主脚本函数定义在下方，先声明，避免验证通过后调用到未定义的全局变量
local loadMainScript

local C_CYAN   = Color3.fromRGB(0, 214, 255)
local C_PURPLE = Color3.fromRGB(150, 90, 255)
local C_INPUT  = Color3.fromRGB(18, 22, 38)
local C_TEXT   = Color3.fromRGB(232, 238, 252)
local C_MUTED  = Color3.fromRGB(118, 128, 158)
local C_ERROR  = Color3.fromRGB(255, 78, 104)
local C_OK     = Color3.fromRGB(46, 220, 140)

local function tween(obj, time, goal, style, dir)
    local t = TweenService:Create(obj, TweenInfo.new(time, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out), goal)
    t:Play()
    return t
end

local function roundify(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = obj
    return c
end

local function circleify(obj)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(1, 0)
    c.Parent = obj
    return c
end

local function fadeOutAll(root, time)
    for _, d in ipairs(root:GetDescendants()) do
        if d:IsA("TextLabel") or d:IsA("TextButton") or d:IsA("TextBox") then
            tween(d, time, { TextTransparency = 1 })
        elseif d:IsA("Frame") then
            tween(d, time, { BackgroundTransparency = 1 })
        elseif d:IsA("UIStroke") then
            tween(d, time, { Transparency = 1 })
        end
    end
end

task.spawn(function()
    local gui = Instance.new("ScreenGui")
    gui.Name = "MOYANCardKey"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 99999
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = PlayerGui

    -- 小屏自适应缩放
    local baseScale = 1
    do
        local cam = workspace.CurrentCamera
        local vp = cam and cam.ViewportSize or Vector2.new(1280, 720)
        baseScale = math.clamp(math.min(vp.X / 520, vp.Y / 460), 0.72, 1)
    end

    -- ===== 背景 =====
    local overlay = Instance.new("Frame")
    overlay.Name = "Overlay"
    overlay.Size = UDim2.fromScale(1, 1)
    overlay.BackgroundColor3 = Color3.new(1, 1, 1)
    overlay.BackgroundTransparency = 1
    overlay.BorderSizePixel = 0
    overlay.ZIndex = 1
    overlay.Parent = gui

    local bgGrad = Instance.new("UIGradient")
    bgGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(7, 10, 20)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(3, 4, 10)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(13, 8, 26)),
    })
    bgGrad.Rotation = 120
    bgGrad.Parent = overlay

    task.spawn(function()
        while gui.Parent do
            tween(bgGrad, 16, { Offset = Vector2.new(0.35, 0.25) }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            task.wait(16)
            tween(bgGrad, 16, { Offset = Vector2.new(0, 0) }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            task.wait(16)
        end
    end)

    -- 科技网格（缓慢漂移）
    local grid = Instance.new("Frame")
    grid.Name = "Grid"
    grid.Size = UDim2.fromScale(1, 1)
    grid.BackgroundTransparency = 1
    grid.ZIndex = 1
    grid.Parent = overlay

    for i = 1, 15 do
        local v = Instance.new("Frame")
        v.AnchorPoint = Vector2.new(0.5, 0)
        v.Position = UDim2.fromScale(i / 16, 0)
        v.Size = UDim2.new(0, 1, 1, 0)
        v.BackgroundColor3 = C_CYAN
        v.BackgroundTransparency = 0.94
        v.BorderSizePixel = 0
        v.Parent = grid
    end
    for i = 1, 9 do
        local h = Instance.new("Frame")
        h.AnchorPoint = Vector2.new(0, 0.5)
        h.Position = UDim2.fromScale(0, i / 10)
        h.Size = UDim2.new(1, 0, 0, 1)
        h.BackgroundColor3 = C_CYAN
        h.BackgroundTransparency = 0.94
        h.BorderSizePixel = 0
        h.Parent = grid
    end

    task.spawn(function()
        while gui.Parent do
            tween(grid, 26, { Position = UDim2.fromOffset(26, 18) }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            task.wait(26)
            tween(grid, 26, { Position = UDim2.fromOffset(0, 0) }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            task.wait(26)
        end
    end)

    -- 背景光斑
    local blobA = Instance.new("Frame")
    blobA.AnchorPoint = Vector2.new(0.5, 0.5)
    blobA.Position = UDim2.fromScale(0.12, 0.18)
    blobA.Size = UDim2.fromOffset(460, 460)
    blobA.BackgroundColor3 = C_CYAN
    blobA.BackgroundTransparency = 0.93
    blobA.BorderSizePixel = 0
    blobA.Parent = overlay
    circleify(blobA)

    local blobB = Instance.new("Frame")
    blobB.AnchorPoint = Vector2.new(0.5, 0.5)
    blobB.Position = UDim2.fromScale(0.9, 0.82)
    blobB.Size = UDim2.fromOffset(520, 520)
    blobB.BackgroundColor3 = C_PURPLE
    blobB.BackgroundTransparency = 0.94
    blobB.BorderSizePixel = 0
    blobB.Parent = overlay
    circleify(blobB)

    task.spawn(function()
        while gui.Parent do
            tween(blobA, 13, { Position = UDim2.fromScale(0.24, 0.14), BackgroundTransparency = 0.9 }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            tween(blobB, 13, { Position = UDim2.fromScale(0.8, 0.88), BackgroundTransparency = 0.91 }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            task.wait(13)
            tween(blobA, 13, { Position = UDim2.fromScale(0.08, 0.3), BackgroundTransparency = 0.94 }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            tween(blobB, 13, { Position = UDim2.fromScale(0.94, 0.72), BackgroundTransparency = 0.94 }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            task.wait(13)
        end
    end)

    -- 全屏扫描光带
    local sweep = Instance.new("Frame")
    sweep.AnchorPoint = Vector2.new(0.5, 0.5)
    sweep.Size = UDim2.new(0.05, 0, 2, 0)
    sweep.Rotation = 14
    sweep.Position = UDim2.fromScale(-0.3, 0.5)
    sweep.BackgroundColor3 = Color3.fromRGB(120, 220, 255)
    sweep.BackgroundTransparency = 0.93
    sweep.BorderSizePixel = 0
    sweep.Parent = overlay
    local sweepGrad = Instance.new("UIGradient")
    sweepGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 0.1),
        NumberSequenceKeypoint.new(1, 1),
    })
    sweepGrad.Parent = sweep

    task.spawn(function()
        while gui.Parent do
            sweep.Position = UDim2.fromScale(-0.3, 0.5)
            tween(sweep, 7, { Position = UDim2.fromScale(1.3, 0.5) }, Enum.EasingStyle.Linear)
            task.wait(11)
        end
    end)

    -- 漂浮微粒
    for i = 1, 18 do
        local dot = Instance.new("Frame")
        dot.AnchorPoint = Vector2.new(0.5, 0.5)
        dot.Size = UDim2.fromOffset(2, 2)
        dot.BackgroundColor3 = (i % 3 == 0) and C_PURPLE or C_CYAN
        dot.BackgroundTransparency = 0.7
        dot.BorderSizePixel = 0
        dot.Parent = overlay
        circleify(dot)
        task.spawn(function()
            while gui.Parent do
                local x = math.random()
                local dur = math.random(11, 22)
                dot.Position = UDim2.fromScale(x, 1.05)
                dot.BackgroundTransparency = math.random(60, 90) / 100
                tween(dot, dur, {
                    Position = UDim2.fromScale(x + math.random(-8, 8) / 100, -0.05),
                }, Enum.EasingStyle.Linear)
                task.wait(dur)
            end
        end)
    end

    -- 数据流（竖向短条）
    for i = 1, 10 do
        local bit = Instance.new("Frame")
        bit.AnchorPoint = Vector2.new(0.5, 0.5)
        bit.Size = UDim2.fromOffset(1, math.random(26, 70))
        bit.BackgroundColor3 = (i % 2 == 0) and C_CYAN or Color3.fromRGB(120, 160, 255)
        bit.BackgroundTransparency = 0.82
        bit.BorderSizePixel = 0
        bit.Parent = overlay
        task.spawn(function()
            while gui.Parent do
                local x = math.random(4, 96) / 100
                local dur = math.random(8, 15)
                bit.Position = UDim2.fromScale(x, -0.1)
                bit.BackgroundTransparency = math.random(72, 92) / 100
                tween(bit, dur, { Position = UDim2.fromScale(x, 1.1) }, Enum.EasingStyle.Linear)
                task.wait(dur + math.random(2, 6))
            end
        end)
    end

    -- ===== 入场区 =====
    local intro = Instance.new("Frame")
    intro.Name = "Intro"
    intro.Size = UDim2.fromScale(1, 1)
    intro.BackgroundTransparency = 1
    intro.BorderSizePixel = 0
    intro.ZIndex = 2
    intro.Parent = overlay

    -- 旋转 HUD 环（渐变描边模拟弧段）
    local function hudRing(size, thickness, color, rotDir, duration, transparency)
        local ring = Instance.new("Frame")
        ring.AnchorPoint = Vector2.new(0.5, 0.5)
        ring.Position = UDim2.fromScale(0.5, 0.36)
        ring.Size = UDim2.fromOffset(size, size)
        ring.BackgroundTransparency = 1
        ring.BorderSizePixel = 0
        ring.ZIndex = 2
        ring.Parent = intro
        circleify(ring)

        local stroke = Instance.new("UIStroke")
        stroke.Thickness = thickness
        stroke.Color = color
        stroke.Transparency = transparency
        stroke.Parent = ring

        local grad = Instance.new("UIGradient")
        grad.Color = ColorSequence.new(color, Color3.fromRGB(255, 255, 255))
        grad.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(0.45, 0.55),
            NumberSequenceKeypoint.new(0.55, 1),
            NumberSequenceKeypoint.new(1, 1),
        })
        grad.Parent = stroke

        task.spawn(function()
            while gui.Parent and ring.Parent do
                tween(grad, duration, { Rotation = grad.Rotation + 360 * rotDir }, Enum.EasingStyle.Linear)
                task.wait(duration)
            end
        end)
        return ring
    end

    hudRing(150, 1, C_CYAN, 1, 13, 0.25)
    hudRing(196, 1, C_PURPLE, -1, 20, 0.35)
    hudRing(246, 1, Color3.fromRGB(90, 140, 255), 1, 28, 0.55)

    -- 中心徽记
    local ringWrap = Instance.new("Frame")
    ringWrap.AnchorPoint = Vector2.new(0.5, 0.5)
    ringWrap.Position = UDim2.fromScale(0.5, 0.36)
    ringWrap.Size = UDim2.fromOffset(96, 96)
    ringWrap.BackgroundTransparency = 1
    ringWrap.ZIndex = 3
    ringWrap.Parent = intro
    local ringScale = Instance.new("UIScale")
    ringScale.Scale = 0
    ringScale.Parent = ringWrap

    local function diamond(size, thickness, colorA, colorB)
        local d = Instance.new("Frame")
        d.AnchorPoint = Vector2.new(0.5, 0.5)
        d.Position = UDim2.fromScale(0.5, 0.5)
        d.Size = UDim2.fromOffset(size, size)
        d.Rotation = 45
        d.BackgroundTransparency = 1
        d.BorderSizePixel = 0
        d.ZIndex = 3
        d.Parent = ringWrap
        roundify(d, 12)
        local s = Instance.new("UIStroke")
        s.Thickness = thickness
        s.Color = colorA
        s.Transparency = 0.1
        s.Parent = d
        local g = Instance.new("UIGradient")
        g.Color = ColorSequence.new(colorA, colorB)
        g.Rotation = 90
        g.Parent = s
        return d
    end

    local diamondA = diamond(58, 1.5, C_CYAN, Color3.fromRGB(150, 230, 255))
    local diamondB = diamond(82, 1, C_PURPLE, Color3.fromRGB(80, 140, 255))

    task.spawn(function()
        while gui.Parent and diamondA.Parent do
            tween(diamondA, 17, { Rotation = diamondA.Rotation + 360 }, Enum.EasingStyle.Linear)
            tween(diamondB, 17, { Rotation = diamondB.Rotation - 360 }, Enum.EasingStyle.Linear)
            task.wait(17)
        end
    end)

    local mark = Instance.new("TextLabel")
    mark.Name = "Mark"
    mark.AnchorPoint = Vector2.new(0.5, 0.5)
    mark.Position = UDim2.fromScale(0.5, 0.5)
    mark.Size = UDim2.fromOffset(64, 64)
    mark.BackgroundTransparency = 1
    mark.Text = "陌"
    mark.Font = Enum.Font.GothamBlack
    mark.TextSize = 36
    mark.TextColor3 = Color3.new(1, 1, 1)
    mark.TextTransparency = 1
    mark.ZIndex = 4
    mark.Parent = ringWrap
    local markGrad = Instance.new("UIGradient")
    markGrad.Color = ColorSequence.new(C_CYAN, C_PURPLE)
    markGrad.Rotation = 90
    markGrad.Parent = mark

    -- 多层扩散光环
    local waves = {}
    for i = 1, 3 do
        local wave = Instance.new("Frame")
        wave.AnchorPoint = Vector2.new(0.5, 0.5)
        wave.Position = UDim2.fromScale(0.5, 0.36)
        wave.Size = UDim2.fromOffset(96, 96)
        wave.BackgroundTransparency = 1
        wave.BorderSizePixel = 0
        wave.ZIndex = 2
        wave.Parent = intro
        circleify(wave)
        local ws = Instance.new("UIStroke")
        ws.Thickness = 2 - i * 0.3
        ws.Color = (i % 2 == 0) and C_PURPLE or C_CYAN
        ws.Transparency = 0.25
        ws.Parent = wave
        local wsc = Instance.new("UIScale")
        wsc.Scale = 0.7
        wsc.Parent = wave
        waves[i] = { frame = wave, stroke = ws, scale = wsc }
    end

    -- 四角取景框
    local frameCorners = {}
    local function cornerBracket(ax, ay, px, py)
        local len, th = 26, 2
        local holder = Instance.new("Frame")
        holder.AnchorPoint = Vector2.new(ax, ay)
        holder.Position = UDim2.fromScale(0.5 + px, 0.36 + py)
        holder.Size = UDim2.fromOffset(len, len)
        holder.BackgroundTransparency = 1
        holder.ZIndex = 3
        holder.Parent = intro

        local h = Instance.new("Frame")
        h.Size = UDim2.fromOffset(len, th)
        h.Position = UDim2.fromOffset(0, (ay == 1) and (len - th) or 0)
        h.BackgroundColor3 = C_CYAN
        h.BorderSizePixel = 0
        h.Parent = holder
        roundify(h, 1)

        local v = Instance.new("Frame")
        v.Size = UDim2.fromOffset(th, len)
        v.Position = UDim2.fromOffset((ax == 1) and (len - th) or 0, 0)
        v.BackgroundColor3 = C_CYAN
        v.BorderSizePixel = 0
        v.Parent = holder
        roundify(v, 1)

        frameCorners[#frameCorners + 1] = holder
        return holder
    end
    cornerBracket(0, 0, -0.115, -0.115)
    cornerBracket(1, 0, 0.115, -0.115)
    cornerBracket(0, 1, -0.115, 0.115)
    cornerBracket(1, 1, 0.115, 0.115)

    -- 标题（打字机 + 故障闪烁）
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.AnchorPoint = Vector2.new(0.5, 0.5)
    title.Position = UDim2.fromScale(0.5, 0.495)
    title.Size = UDim2.fromScale(0.9, 0.09)
    title.BackgroundTransparency = 1
    title.Text = ""
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 46
    title.TextColor3 = Color3.new(1, 1, 1)
    title.TextTransparency = 0
    title.ZIndex = 4
    title.Parent = intro
    local titleGrad = Instance.new("UIGradient")
    titleGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, C_CYAN),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(240, 248, 255)),
        ColorSequenceKeypoint.new(1, C_PURPLE),
    })
    titleGrad.Parent = title

    task.spawn(function()
        while gui.Parent and title.Parent do
            tween(titleGrad, 6, { Rotation = 360 }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            task.wait(6)
            titleGrad.Rotation = 0
        end
    end)

    -- 副标题
    local subtitle = Instance.new("TextLabel")
    subtitle.Name = "Subtitle"
    subtitle.AnchorPoint = Vector2.new(0.5, 0.5)
    subtitle.Position = UDim2.fromScale(0.5, 0.565)
    subtitle.Size = UDim2.fromScale(0.9, 0.05)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "C A R D   K E Y   A C C E S S"
    subtitle.Font = Enum.Font.GothamMedium
    subtitle.TextSize = 12
    subtitle.TextColor3 = C_MUTED
    subtitle.TextTransparency = 1
    subtitle.ZIndex = 4
    subtitle.Parent = intro

    -- 启动状态行
    local bootText = Instance.new("TextLabel")
    bootText.Name = "BootText"
    bootText.AnchorPoint = Vector2.new(0.5, 0.5)
    bootText.Position = UDim2.fromScale(0.5, 0.625)
    bootText.Size = UDim2.fromScale(0.9, 0.04)
    bootText.BackgroundTransparency = 1
    bootText.Text = ""
    bootText.Font = Enum.Font.Code
    bootText.TextSize = 11
    bootText.TextColor3 = Color3.fromRGB(90, 200, 210)
    bootText.TextTransparency = 1
    bootText.ZIndex = 4
    bootText.Parent = intro

    local line = Instance.new("Frame")
    line.Name = "Line"
    line.AnchorPoint = Vector2.new(0.5, 0.5)
    line.Position = UDim2.fromScale(0.5, 0.6)
    line.Size = UDim2.fromOffset(0, 2)
    line.BackgroundColor3 = Color3.new(1, 1, 1)
    line.BorderSizePixel = 0
    line.ZIndex = 4
    line.Parent = intro
    local lineGrad = Instance.new("UIGradient")
    lineGrad.Color = ColorSequence.new(C_CYAN, C_PURPLE)
    lineGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 0.1),
        NumberSequenceKeypoint.new(1, 1),
    })
    lineGrad.Parent = line

    -- 入场动画（pcall 保护：即使执行器不支持某个属性，也保证能进入卡密面板）
    pcall(function()
        tween(overlay, 0.8, { BackgroundTransparency = 0 })
        task.wait(0.08)

        tween(ringScale, 1.1, { Scale = 1 }, Enum.EasingStyle.Back)
        tween(mark, 0.8, { TextTransparency = 0 })

        -- 三波错峰冲击环
        for i = 1, 3 do
            local w = waves[i]
            task.delay((i - 1) * 0.4, function()
                if not w.frame.Parent then return end
                tween(w.scale, 1.9, { Scale = 5.4 - i * 0.5 }, Enum.EasingStyle.Quart)
                tween(w.stroke, 1.9, { Transparency = 1 })
                task.delay(1.95, function()
                    if w.frame.Parent then w.frame:Destroy() end
                end)
            end)
        end

        -- 取景框从四角飞入
        for i, c in ipairs(frameCorners) do
            local targetX = c.Position.X.Scale
            local targetY = c.Position.Y.Scale
            c.Position = UDim2.fromScale(0.5 + (targetX - 0.5) * 2.4, 0.36 + (targetY - 0.36) * 2.4)
            c.BackgroundTransparency = 0
            task.delay(0.1 * i, function()
                tween(c, 0.85, { Position = UDim2.fromScale(targetX, targetY) }, Enum.EasingStyle.Quart)
            end)
        end

        task.wait(0.6)

        -- 打字机标题
        local fullTitle = "MOYAN HUB"
        for i = 1, #fullTitle do
            title.Text = fullTitle:sub(1, i)
            task.wait(0.09)
        end

        -- 故障闪烁
        task.spawn(function()
            for i = 1, 4 do
                title.Position = UDim2.fromScale(0.5 + (math.random(-6, 6) / 500), 0.47)
                title.TextColor3 = (i % 2 == 0) and C_CYAN or Color3.fromRGB(255, 120, 220)
                task.wait(0.08)
            end
            title.Position = UDim2.fromScale(0.5, 0.47)
            title.TextColor3 = Color3.new(1, 1, 1)
        end)

        task.wait(0.3)
        tween(subtitle, 0.9, { TextTransparency = 0, Position = UDim2.fromScale(0.5, 0.545) }, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

        task.wait(0.4)
        tween(line, 0.8, { Size = UDim2.fromOffset(230, 2) }, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

        -- 启动状态行逐字滚动
        task.spawn(function()
            local msgs = {
                "> 初始化安全模块...",
                "> 校验设备指纹...",
                "> 建立加密通道...",
                "> 就绪",
            }
            tween(bootText, 0.45, { TextTransparency = 0.25 })
            for _, m in ipairs(msgs) do
                bootText.Text = m
                bootText.TextTransparency = 0.9
                tween(bootText, 0.3, { TextTransparency = 0.2 })
                task.wait(0.6)
            end
        end)

        task.wait(1.3)
        fadeOutAll(intro, 0.7)
        tween(ringWrap, 0.7, { Position = UDim2.fromScale(0.5, 0.33) }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        task.wait(0.75)
    end)
    if intro.Parent then intro:Destroy() end

    -- ===== 卡密面板 =====
    local cardGlow = Instance.new("Frame")
    cardGlow.AnchorPoint = Vector2.new(0.5, 0.5)
    cardGlow.Position = UDim2.fromScale(0.5, 0.5)
    cardGlow.Size = UDim2.fromOffset(500 * baseScale, 430 * baseScale)
    cardGlow.BackgroundColor3 = C_CYAN
    cardGlow.BackgroundTransparency = 1
    cardGlow.BorderSizePixel = 0
    cardGlow.ZIndex = 2
    cardGlow.Parent = overlay
    circleify(cardGlow)

    local card = Instance.new("Frame")
    card.Name = "CardPanel"
    card.AnchorPoint = Vector2.new(0.5, 0.5)
    card.Position = UDim2.fromScale(0.5, 0.53)
    card.Size = UDim2.fromOffset(440, 372)
    card.BackgroundColor3 = Color3.new(1, 1, 1)
    card.BackgroundTransparency = 1
    card.BorderSizePixel = 0
    card.ClipsDescendants = true
    card.ZIndex = 3
    card.Parent = overlay
    roundify(card, 20)

    local cardScale = Instance.new("UIScale")
    cardScale.Scale = baseScale * 0.94
    cardScale.Parent = card

    local cardGrad = Instance.new("UIGradient")
    cardGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(22, 27, 46)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(12, 14, 26)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 16, 40)),
    })
    cardGrad.Rotation = 115
    cardGrad.Parent = card

    -- 流动描边
    local cardStroke = Instance.new("UIStroke")
    cardStroke.Thickness = 1.5
    cardStroke.Color = C_CYAN
    cardStroke.Transparency = 0.15
    cardStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    cardStroke.Parent = card
    local strokeGrad = Instance.new("UIGradient")
    strokeGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, C_CYAN),
        ColorSequenceKeypoint.new(0.35, Color3.fromRGB(70, 90, 160)),
        ColorSequenceKeypoint.new(0.7, C_PURPLE),
        ColorSequenceKeypoint.new(1, C_CYAN),
    })
    strokeGrad.Parent = cardStroke

    task.spawn(function()
        while gui.Parent do
            tween(strokeGrad, 11, { Rotation = strokeGrad.Rotation + 360 }, Enum.EasingStyle.Linear)
            task.wait(11)
        end
    end)

    -- 顶部高光条
    local accent = Instance.new("Frame")
    accent.Size = UDim2.new(1, 0, 0, 2)
    accent.BackgroundColor3 = Color3.new(1, 1, 1)
    accent.BorderSizePixel = 0
    accent.ZIndex = 3
    accent.Parent = card
    local accentGrad = Instance.new("UIGradient")
    accentGrad.Color = ColorSequence.new(C_CYAN, C_PURPLE)
    accentGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 0),
        NumberSequenceKeypoint.new(1, 1),
    })
    accentGrad.Parent = accent

    -- 扫描线
    local scan = Instance.new("Frame")
    scan.Size = UDim2.new(1, 0, 0, 1)
    scan.Position = UDim2.fromScale(0, -0.05)
    scan.BackgroundColor3 = Color3.fromRGB(130, 225, 255)
    scan.BackgroundTransparency = 0.85
    scan.BorderSizePixel = 0
    scan.ZIndex = 2
    scan.Parent = card
    local scanGrad = Instance.new("UIGradient")
    scanGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 0.2),
        NumberSequenceKeypoint.new(1, 1),
    })
    scanGrad.Parent = scan

    task.spawn(function()
        while gui.Parent do
            scan.Position = UDim2.fromScale(0, -0.05)
            tween(scan, 6.5, { Position = UDim2.fromScale(0, 1.05) }, Enum.EasingStyle.Linear)
            task.wait(7.5)
        end
    end)

    -- 四角描边
    local brackets = {}
    local function bracket(ax, ay, px, py)
        local len, th = 16, 1.5
        local holder = Instance.new("Frame")
        holder.AnchorPoint = Vector2.new(ax, ay)
        holder.Position = UDim2.fromOffset(px, py)
        holder.Size = UDim2.fromOffset(len, len)
        holder.BackgroundTransparency = 1
        holder.ZIndex = 4
        holder.Parent = card

        local barH = Instance.new("Frame")
        barH.Size = UDim2.fromOffset(len, th)
        barH.Position = UDim2.fromOffset(0, (ay == 1) and (len - th) or 0)
        barH.BackgroundColor3 = C_CYAN
        barH.BorderSizePixel = 0
        barH.ZIndex = 4
        barH.Parent = holder
        roundify(barH, 1)

        local barV = Instance.new("Frame")
        barV.Size = UDim2.fromOffset(th, len)
        barV.Position = UDim2.fromOffset((ax == 1) and (len - th) or 0, 0)
        barV.BackgroundColor3 = C_CYAN
        barV.BorderSizePixel = 0
        barV.ZIndex = 4
        barV.Parent = holder
        roundify(barV, 1)

        brackets[#brackets + 1] = holder
    end
    bracket(0, 0, 13, 13)
    bracket(1, 0, -13, 13)
    bracket(0, 1, 13, -13)
    bracket(1, 1, -13, -13)

    -- 顶部图标徽章
    local emblem = Instance.new("Frame")
    emblem.AnchorPoint = Vector2.new(0.5, 0)
    emblem.Position = UDim2.new(0.5, 0, 0, 26)
    emblem.Size = UDim2.fromOffset(44, 44)
    emblem.BackgroundColor3 = Color3.fromRGB(17, 21, 36)
    emblem.BorderSizePixel = 0
    emblem.ZIndex = 4
    emblem.Parent = card
    roundify(emblem, 14)

    local emblemStroke = Instance.new("UIStroke")
    emblemStroke.Thickness = 1.4
    emblemStroke.Color = C_CYAN
    emblemStroke.Transparency = 0.25
    emblemStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    emblemStroke.Parent = emblem
    local emblemGrad = Instance.new("UIGradient")
    emblemGrad.Color = ColorSequence.new(C_CYAN, C_PURPLE)
    emblemGrad.Rotation = 90
    emblemGrad.Parent = emblemStroke

    local emblemText = Instance.new("TextLabel")
    emblemText.Size = UDim2.fromScale(1, 1)
    emblemText.BackgroundTransparency = 1
    emblemText.Text = "陌"
    emblemText.Font = Enum.Font.GothamBlack
    emblemText.TextSize = 21
    emblemText.TextColor3 = Color3.new(1, 1, 1)
    emblemText.ZIndex = 5
    emblemText.Parent = emblem
    local emblemTextGrad = Instance.new("UIGradient")
    emblemTextGrad.Color = ColorSequence.new(C_CYAN, C_PURPLE)
    emblemTextGrad.Rotation = 90
    emblemTextGrad.Parent = emblemText

    -- 徽章外环脉冲
    local emblemPulse = Instance.new("Frame")
    emblemPulse.AnchorPoint = Vector2.new(0.5, 0.5)
    emblemPulse.Position = UDim2.fromScale(0.5, 0.5)
    emblemPulse.Size = UDim2.fromScale(1, 1)
    emblemPulse.BackgroundTransparency = 1
    emblemPulse.BorderSizePixel = 0
    emblemPulse.ZIndex = 3
    emblemPulse.Parent = emblem
    roundify(emblemPulse, 14)
    local emblemPulseStroke = Instance.new("UIStroke")
    emblemPulseStroke.Thickness = 1
    emblemPulseStroke.Color = C_CYAN
    emblemPulseStroke.Transparency = 0.4
    emblemPulseStroke.Parent = emblemPulse

    task.spawn(function()
        while gui.Parent and emblem.Parent do
            emblemPulse.Size = UDim2.fromScale(1, 1)
            emblemPulseStroke.Transparency = 0.4
            tween(emblemPulse, 3.2, { Size = UDim2.fromScale(1.55, 1.55) }, Enum.EasingStyle.Quad)
            tween(emblemPulseStroke, 3.2, { Transparency = 1 })
            task.wait(3.2)
        end
    end)

    -- 顶部开机进度条
    local bootBarBg = Instance.new("Frame")
    bootBarBg.AnchorPoint = Vector2.new(0.5, 0)
    bootBarBg.Position = UDim2.new(0.5, 0, 0, 0)
    bootBarBg.Size = UDim2.new(1, 0, 0, 2)
    bootBarBg.BackgroundColor3 = Color3.fromRGB(30, 38, 62)
    bootBarBg.BackgroundTransparency = 0.2
    bootBarBg.BorderSizePixel = 0
    bootBarBg.ZIndex = 5
    bootBarBg.Parent = card

    local bootBar = Instance.new("Frame")
    bootBar.AnchorPoint = Vector2.new(0, 0)
    bootBar.Size = UDim2.fromScale(0, 1)
    bootBar.BackgroundColor3 = Color3.new(1, 1, 1)
    bootBar.BorderSizePixel = 0
    bootBar.ZIndex = 6
    bootBar.Parent = bootBarBg
    local bootBarGrad = Instance.new("UIGradient")
    bootBarGrad.Color = ColorSequence.new(C_CYAN, C_PURPLE)
    bootBarGrad.Parent = bootBar

    -- 标题区
    local cardTitle = Instance.new("TextLabel")
    cardTitle.Position = UDim2.fromOffset(0, 84)
    cardTitle.Size = UDim2.new(1, 0, 0, 28)
    cardTitle.BackgroundTransparency = 1
    cardTitle.Text = "身份验证"
    cardTitle.Font = Enum.Font.GothamBold
    cardTitle.TextSize = 22
    cardTitle.TextColor3 = C_TEXT
    cardTitle.ZIndex = 4
    cardTitle.Parent = card

    local cardSub = Instance.new("TextLabel")
    cardSub.Position = UDim2.fromOffset(0, 113)
    cardSub.Size = UDim2.new(1, 0, 0, 16)
    cardSub.BackgroundTransparency = 1
    cardSub.Text = "输入访问卡密以解锁控制面板"
    cardSub.Font = Enum.Font.Gotham
    cardSub.TextSize = 12
    cardSub.TextColor3 = C_MUTED
    cardSub.ZIndex = 4
    cardSub.Parent = card

    -- 右上角关闭按钮
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseBtn"
    closeBtn.AnchorPoint = Vector2.new(1, 0)
    closeBtn.Position = UDim2.new(1, -14, 0, 14)
    closeBtn.Size = UDim2.fromOffset(26, 26)
    closeBtn.BackgroundColor3 = Color3.fromRGB(30, 36, 56)
    closeBtn.BackgroundTransparency = 0.35
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "×"
    closeBtn.TextSize = 18
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextColor3 = Color3.fromRGB(150, 162, 195)
    closeBtn.AutoButtonColor = false
    closeBtn.ZIndex = 6
    closeBtn.Parent = card
    roundify(closeBtn, 8)

    local closeStroke = Instance.new("UIStroke")
    closeStroke.Thickness = 1
    closeStroke.Color = Color3.fromRGB(64, 78, 116)
    closeStroke.Transparency = 0.4
    closeStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    closeStroke.Parent = closeBtn

    closeBtn.MouseEnter:Connect(function()
        tween(closeBtn, 0.25, { BackgroundColor3 = Color3.fromRGB(190, 56, 78), BackgroundTransparency = 0.1 })
        tween(closeBtn, 0.25, { TextColor3 = Color3.new(1, 1, 1) })
        tween(closeStroke, 0.25, { Color = C_ERROR, Transparency = 0 })
    end)
    closeBtn.MouseLeave:Connect(function()
        tween(closeBtn, 0.25, { BackgroundColor3 = Color3.fromRGB(30, 36, 56), BackgroundTransparency = 0.35 })
        tween(closeBtn, 0.25, { TextColor3 = Color3.fromRGB(150, 162, 195) })
        tween(closeStroke, 0.25, { Color = Color3.fromRGB(64, 78, 116), Transparency = 0.4 })
    end)

    local closing = false
    closeBtn.MouseButton1Click:Connect(function()
        if closing then return end
        closing = true
        tween(card, 0.5, { BackgroundTransparency = 1 })
        fadeOutAll(card, 0.45)
        tween(cardGlow, 0.45, { BackgroundTransparency = 1 })
        tween(overlay, 0.6, { BackgroundTransparency = 1 })
        task.wait(0.65)
        gui:Destroy()
        print("[MOYAN HUB] 已关闭卡密验证")
    end)

    local divider = Instance.new("Frame")
    divider.Position = UDim2.fromOffset(32, 144)
    divider.Size = UDim2.new(1, -64, 0, 1)
    divider.BackgroundColor3 = Color3.fromRGB(56, 68, 102)
    divider.BackgroundTransparency = 0.3
    divider.BorderSizePixel = 0
    divider.ZIndex = 4
    divider.Parent = card
    local dividerGrad = Instance.new("UIGradient")
    dividerGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 0.15),
        NumberSequenceKeypoint.new(1, 1),
    })
    dividerGrad.Parent = divider

    -- 输入区标签
    local inputLabel = Instance.new("TextLabel")
    inputLabel.Position = UDim2.fromOffset(34, 158)
    inputLabel.Size = UDim2.fromOffset(200, 12)
    inputLabel.BackgroundTransparency = 1
    inputLabel.Text = "卡 密  ·  KEY"
    inputLabel.Font = Enum.Font.GothamMedium
    inputLabel.TextSize = 10
    inputLabel.TextColor3 = Color3.fromRGB(96, 108, 142)
    inputLabel.TextXAlignment = Enum.TextXAlignment.Left
    inputLabel.ZIndex = 4
    inputLabel.Parent = card

    -- 输入框
    local inputBg = Instance.new("Frame")
    inputBg.Name = "InputBg"
    inputBg.Position = UDim2.fromOffset(32, 176)
    inputBg.Size = UDim2.new(1, -64, 0, 52)
    inputBg.BackgroundColor3 = C_INPUT
    inputBg.BackgroundTransparency = 0
    inputBg.BorderSizePixel = 0
    inputBg.Active = true
    inputBg.ZIndex = 4
    inputBg.Parent = card
    roundify(inputBg, 12)

    local inputStroke = Instance.new("UIStroke")
    inputStroke.Thickness = 1
    inputStroke.Color = Color3.fromRGB(60, 85, 140)
    inputStroke.Transparency = 0.35
    inputStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    inputStroke.Parent = inputBg

    local bar = Instance.new("Frame")
    bar.Position = UDim2.fromOffset(13, 16)
    bar.Size = UDim2.fromOffset(2, 20)
    bar.BackgroundColor3 = Color3.new(1, 1, 1)
    bar.BorderSizePixel = 0
    bar.ZIndex = 5
    bar.Parent = inputBg
    roundify(bar, 1)
    local barGrad = Instance.new("UIGradient")
    barGrad.Color = ColorSequence.new(C_CYAN, C_PURPLE)
    barGrad.Rotation = 90
    barGrad.Parent = bar

    local textBox = Instance.new("TextBox")
    textBox.Name = "CardKeyInput"
    textBox.AnchorPoint = Vector2.new(0, 0.5)
    textBox.Position = UDim2.new(0, 26, 0.5, 0)
    textBox.Size = UDim2.new(1, -60, 1, -12)
    textBox.BackgroundTransparency = 1
    textBox.BorderSizePixel = 0
    textBox.Text = ""
    textBox.PlaceholderText = "请输入卡密…"
    textBox.PlaceholderColor3 = Color3.fromRGB(96, 106, 136)
    textBox.TextSize = 16
    textBox.Font = Enum.Font.GothamMedium
    textBox.TextColor3 = C_TEXT
    textBox.TextXAlignment = Enum.TextXAlignment.Left
    textBox.ClearTextOnFocus = false
    textBox.MultiLine = false
    textBox.ZIndex = 5
    textBox.Parent = inputBg

    local clearBtn = Instance.new("TextButton")
    clearBtn.AnchorPoint = Vector2.new(0.5, 0.5)
    clearBtn.Position = UDim2.new(1, -23, 0.5, 0)
    clearBtn.Size = UDim2.fromOffset(26, 26)
    clearBtn.BackgroundTransparency = 1
    clearBtn.Text = "×"
    clearBtn.TextSize = 20
    clearBtn.Font = Enum.Font.GothamBold
    clearBtn.TextColor3 = Color3.fromRGB(115, 125, 155)
    clearBtn.AutoButtonColor = false
    clearBtn.Visible = false
    clearBtn.ZIndex = 6
    clearBtn.Parent = inputBg

    clearBtn.MouseButton1Click:Connect(function()
        textBox.Text = ""
        textBox:CaptureFocus()
    end)

    -- 点击输入框空白处也能唤起软键盘（移动端关键）
    inputBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            textBox:CaptureFocus()
        end
    end)

    local verified = false
    local doVerify
    local hint
    local cardY = 0.5

    textBox.Focused:Connect(function()
        if baseScale < 0.9 then
            cardY = 0.38
            tween(card, 0.55, { Position = UDim2.fromScale(0.5, cardY) })
        end
        tween(inputStroke, 0.35, { Color = C_CYAN, Transparency = 0 })
        tween(bar, 0.35, { Size = UDim2.fromOffset(2, 30) })
        tween(inputBg, 0.35, { BackgroundColor3 = Color3.fromRGB(21, 30, 52) })
    end)

    textBox.FocusLost:Connect(function(enterPressed)
        if not verified then
            cardY = 0.5
            tween(card, 0.3, { Position = UDim2.fromScale(0.5, cardY) })
            tween(inputStroke, 0.45, { Color = Color3.fromRGB(60, 85, 140), Transparency = 0.35 })
            tween(bar, 0.45, { Size = UDim2.fromOffset(2, 20) })
            tween(inputBg, 0.45, { BackgroundColor3 = C_INPUT })
        end
        if enterPressed then doVerify() end
    end)

    textBox:GetPropertyChangedSignal("Text"):Connect(function()
        clearBtn.Visible = textBox.Text ~= ""
        if hint and hint.Text ~= "" then hint.Text = "" end
    end)

    -- 验证按钮
    local btn = Instance.new("TextButton")
    btn.Name = "VerifyBtn"
    btn.Position = UDim2.fromOffset(32, 244)
    btn.Size = UDim2.new(1, -64, 0, 46)
    btn.BackgroundColor3 = Color3.new(1, 1, 1)
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.ClipsDescendants = true
    btn.ZIndex = 4
    btn.Parent = card
    roundify(btn, 12)

    local btnGrad = Instance.new("UIGradient")
    btnGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 196, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(84, 132, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(146, 88, 255)),
    })
    btnGrad.Rotation = 12
    btnGrad.Parent = btn

    -- 按钮顶部高光
    local btnTop = Instance.new("Frame")
    btnTop.Size = UDim2.new(1, 0, 0, 1)
    btnTop.BackgroundColor3 = Color3.new(1, 1, 1)
    btnTop.BackgroundTransparency = 0.72
    btnTop.BorderSizePixel = 0
    btnTop.ZIndex = 5
    btnTop.Parent = btn

    -- 按钮文字（独立层，永远在流光之上）
    local btnText = Instance.new("TextLabel")
    btnText.Name = "BtnText"
    btnText.Size = UDim2.fromScale(1, 1)
    btnText.BackgroundTransparency = 1
    btnText.Text = "验 证 卡 密"
    btnText.TextSize = 17
    btnText.Font = Enum.Font.GothamBold
    btnText.TextColor3 = Color3.new(1, 1, 1)
    btnText.ZIndex = 7
    btnText.Parent = btn

    task.spawn(function()
        while gui.Parent do
            tween(btnGrad, 8, { Rotation = btnGrad.Rotation + 360 }, Enum.EasingStyle.Linear)
            task.wait(8)
        end
    end)

    -- 按钮流光
    local shine = Instance.new("Frame")
    shine.Size = UDim2.fromScale(0.22, 2)
    shine.Position = UDim2.fromScale(-0.4, -0.5)
    shine.Rotation = 18
    shine.BackgroundColor3 = Color3.new(1, 1, 1)
    shine.BackgroundTransparency = 0.75
    shine.BorderSizePixel = 0
    shine.ZIndex = 6
    shine.Parent = btn
    local shineGrad = Instance.new("UIGradient")
    shineGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 0.3),
        NumberSequenceKeypoint.new(1, 1),
    })
    shineGrad.Parent = shine

    task.spawn(function()
        while gui.Parent do
            shine.Position = UDim2.fromScale(-0.4, -0.5)
            tween(shine, 4, { Position = UDim2.fromScale(1.3, -0.5) }, Enum.EasingStyle.Linear)
            task.wait(5.5)
        end
    end)

    local btnScale = Instance.new("UIScale")
    btnScale.Scale = 1
    btnScale.Parent = btn

    btn.MouseButton1Down:Connect(function()
        tween(btnScale, 0.14, { Scale = 0.97 })
        local ripple = Instance.new("Frame")
        ripple.AnchorPoint = Vector2.new(0.5, 0.5)
        ripple.Position = UDim2.fromScale(0.5, 0.5)
        ripple.Size = UDim2.fromScale(1, 1)
        ripple.BackgroundTransparency = 1
        ripple.BorderSizePixel = 0
        ripple.ZIndex = 6
        ripple.Parent = btn
        roundify(ripple, 12)
        local rs = Instance.new("UIStroke")
        rs.Thickness = 2
        rs.Color = Color3.new(1, 1, 1)
        rs.Transparency = 0.2
        rs.Parent = ripple
        tween(ripple, 0.85, { Size = UDim2.fromScale(1.25, 1.9) }, Enum.EasingStyle.Quart)
        tween(rs, 0.85, { Transparency = 1 })
        task.delay(0.9, function()
            if ripple.Parent then ripple:Destroy() end
        end)
    end)
    btn.MouseButton1Up:Connect(function()
        tween(btnScale, 0.25, { Scale = 1 })
    end)

    -- 提示文字
    hint = Instance.new("TextLabel")
    hint.Position = UDim2.fromOffset(32, 302)
    hint.Size = UDim2.new(1, -64, 0, 16)
    hint.BackgroundTransparency = 1
    hint.Text = ""
    hint.TextSize = 12
    hint.Font = Enum.Font.GothamMedium
    hint.TextColor3 = C_ERROR
    hint.TextXAlignment = Enum.TextXAlignment.Center
    hint.ZIndex = 4
    hint.Parent = card

    -- 底部信息
    local footerDivider = Instance.new("Frame")
    footerDivider.Position = UDim2.fromOffset(32, 330)
    footerDivider.Size = UDim2.new(1, -64, 0, 1)
    footerDivider.BackgroundColor3 = Color3.fromRGB(42, 52, 80)
    footerDivider.BackgroundTransparency = 0.45
    footerDivider.BorderSizePixel = 0
    footerDivider.ZIndex = 4
    footerDivider.Parent = card

    local footer = Instance.new("TextLabel")
    footer.Position = UDim2.fromOffset(32, 342)
    footer.Size = UDim2.new(1, -64, 0, 14)
    footer.BackgroundTransparency = 1
    footer.Text = "MOYAN HUB  ·  SECURE ACCESS"
    footer.Font = Enum.Font.GothamMedium
    footer.TextSize = 9
    footer.TextColor3 = Color3.fromRGB(72, 84, 114)
    footer.ZIndex = 4
    footer.Parent = card

    -- 面板展开
    tween(card, 0.9, { BackgroundTransparency = 0 })
    tween(cardScale, 1.1, { Scale = baseScale }, Enum.EasingStyle.Back)
    tween(card, 0.8, { Position = UDim2.fromScale(0.5, 0.5) })
    tween(cardGlow, 1.2, { BackgroundTransparency = 0.93 })
    for i, holder in ipairs(brackets) do
        holder.BackgroundTransparency = 1
        task.delay(0.3 + i * 0.1, function()
            tween(holder, 0.7, { BackgroundTransparency = 0 })
        end)
    end

    -- 开机进度条：快速扫满后渐隐
    task.spawn(function()
        bootBar.Size = UDim2.fromScale(0, 1)
        tween(bootBar, 1.5, { Size = UDim2.fromScale(1, 1) }, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        task.wait(1.6)
        tween(bootBarBg, 0.9, { BackgroundTransparency = 1 })
        tween(bootBar, 0.9, { BackgroundTransparency = 1 })
    end)

    -- 内容错峰浮入
    task.spawn(function()
        local items = { emblem, cardTitle, cardSub, divider, inputLabel, inputBg, btn, footerDivider, footer }
        for i, obj in ipairs(items) do
            local basePos = obj.Position
            obj.Position = UDim2.new(basePos.X.Scale, basePos.X.Offset, basePos.Y.Scale, basePos.Y.Offset + 12)
            task.delay(0.2 + i * 0.09, function()
                tween(obj, 0.8, { Position = basePos }, Enum.EasingStyle.Quart)
            end)
        end
    end)

    -- 卡片边框一次性闪亮
    task.spawn(function()
        task.wait(0.3)
        tween(cardStroke, 0.45, { Transparency = 0, Thickness = 3 })
        task.wait(0.5)
        tween(cardStroke, 1.0, { Transparency = 0.15, Thickness = 1.5 })
    end)

    task.spawn(function()
        while gui.Parent do
            if verified then break end
            tween(cardGlow, 4, { BackgroundTransparency = 0.96 }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            task.wait(4)
            if verified then break end
            tween(cardGlow, 4, { BackgroundTransparency = 0.91 }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            task.wait(4)
        end
    end)

    -- ===== 交互逻辑 =====
    local function shake(frame, strength, times)
        task.spawn(function()
            for i = 1, times do
                local dx = ((i % 2 == 0) and 1 or -1) * strength * (1 - i / (times + 1))
                frame.Position = UDim2.fromScale(0.5 + dx, cardY)
                task.wait(0.07)
            end
            frame.Position = UDim2.fromScale(0.5, cardY)
        end)
    end

    local function playSuccessBurst()
        local burst = Instance.new("Frame")
        burst.AnchorPoint = Vector2.new(0.5, 0.5)
        burst.Position = UDim2.fromScale(0.5, 0.5)
        burst.Size = UDim2.fromOffset(110, 110)
        burst.BackgroundTransparency = 1
        burst.BorderSizePixel = 0
        burst.ZIndex = 10
        burst.Parent = overlay
        circleify(burst)
        local bStroke = Instance.new("UIStroke")
        bStroke.Thickness = 2
        bStroke.Color = C_OK
        bStroke.Transparency = 0.1
        bStroke.Parent = burst
        local bScale = Instance.new("UIScale")
        bScale.Scale = 0.6
        bScale.Parent = burst
        tween(bScale, 1.3, { Scale = 5.2 }, Enum.EasingStyle.Quart)
        tween(bStroke, 1.3, { Transparency = 1 })
        task.delay(1.35, function()
            if burst.Parent then burst:Destroy() end
        end)

        for i = 1, 14 do
            local spark = Instance.new("Frame")
            spark.AnchorPoint = Vector2.new(0.5, 0.5)
            spark.Position = UDim2.fromScale(0.5, 0.5)
            spark.Size = UDim2.fromOffset(4, 4)
            spark.BackgroundColor3 = (i % 2 == 0) and C_OK or C_CYAN
            spark.BorderSizePixel = 0
            spark.ZIndex = 10
            spark.Parent = overlay
            circleify(spark)
            local ang = math.rad(i * (360 / 14) + math.random(0, 18))
            local dist = math.random(80, 170) * baseScale
            tween(spark, 1.1, {
                Position = UDim2.new(0.5, math.cos(ang) * dist, 0.5, math.sin(ang) * dist),
                BackgroundTransparency = 1,
            }, Enum.EasingStyle.Quart)
            task.delay(1.15, function()
                if spark.Parent then spark:Destroy() end
            end)
        end
    end

    function doVerify()
        if verified then return end
        local key = textBox.Text:match("^%s*(.-)%s*$") or ""

        if key == "" then
            hint.Text = "请先输入卡密"
            shake(card, 0.006, 4)
            return
        end

        if key ~= CARD_KEY then
            hint.Text = "卡密错误，请重新输入"
            shake(card, 0.007, 5)
            inputStroke.Color = C_ERROR
            inputStroke.Transparency = 0
            task.delay(1.4, function()
                if not verified and not textBox:IsFocused() then
                    inputStroke.Color = Color3.fromRGB(60, 85, 140)
                    inputStroke.Transparency = 0.35
                end
            end)
            return
        end

        verified = true
        textBox:ReleaseFocus()
        hint.Text = ""

        btnGrad.Enabled = false
        strokeGrad.Enabled = false
        btn.BackgroundColor3 = C_OK
        btnText.Text = "验证成功 ✓"
        inputStroke.Color = C_OK
        inputStroke.Transparency = 0
        tween(cardStroke, 0.25, { Color = C_OK, Transparency = 0 })
        playSuccessBurst()

        task.wait(1.4)
        tween(cardScale, 0.8, { Scale = baseScale * 0.9 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        fadeOutAll(card, 0.7)
        tween(cardGlow, 0.8, { BackgroundTransparency = 1 })
        tween(blobA, 0.9, { BackgroundTransparency = 1 })
        tween(blobB, 0.9, { BackgroundTransparency = 1 })
        tween(overlay, 0.9, { BackgroundTransparency = 1 })
        task.wait(0.95)

        gui:Destroy()
        print("[MOYAN HUB] 卡密验证成功，卡密已解锁")
        loadMainScript()
    end

    btn.MouseButton1Click:Connect(doVerify)
end)

-- ====== 3. 主脚本（卡密验证通过后执行） ======
function loadMainScript()
local Window = Library:CreateWindow({
    Title = "木材大亨2",
    Footer = "稳定版",
    Icon = 95816097006870,
    NotifySide = "Right",
    ShowCustomCursor = true,
    MobileButtonsSide = "Right",
    ToggleKeybind = Enum.KeyCode.RightShift, -- 沿用誓言的菜单热键（RightShift 开关）
})

-- 通知统一走 MOYAN UI（替代誓言的 StarterGui 通知）
local function notify(title, desc, duration)
    Library:Notify({
        Title = tostring(title or "MOYAN HUB"),
        Description = tostring(desc or ""),
        Time = duration or 3,
    })
end

-- ====== 4. 标签页 ======
local Tabs = {
    Features  = Window:AddTab("功能", "hand"),
    Teleports = Window:AddTab("传送", "map-pin"),
    Craft     = Window:AddTab("合成", "crosshair"),
    Duck      = Window:AddTab("鸭子", "target"),
    Shop      = Window:AddTab("购买", "sliders"),
    Settings  = Window:AddTab("设置", "settings"),
}
-- ====== 玩家锁定 / 安全传送（誓言逻辑） ======
local lockPlayerConn = nil
local function uprightCFrame(hrp, cf)
    local pos = cf.Position
    local yRot = hrp and hrp.Orientation.Y or 0
    return CFrame.new(pos) * CFrame.Angles(0, math.rad(yRot), 0)
end
local function unlockPlayer()
    if lockPlayerConn then lockPlayerConn:Disconnect(); lockPlayerConn = nil end
end
local function lockPlayerAt(cf)
    unlockPlayer()
    local function hold()
        local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = uprightCFrame(hrp, cf)
            hrp.Velocity = Vector3.new(0,0,0)
            hrp.RotVelocity = Vector3.new(0,0,0)
        end
    end
    hold()
    lockPlayerConn = RS.Heartbeat:Connect(hold)
end
local function safeTeleport(cf)
    local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = uprightCFrame(hrp, cf)
        task.wait(0.05)
        if hrp.Position.Y < -100 then hrp.CFrame = uprightCFrame(hrp, cf) + Vector3.new(0,10,0) end
    end
end

-- ====== 拖拽核心（誓言 dragToPosition） ======
local bai = { dragIDCounter=0, cachedSawmill=nil, cachedSawmillPos=nil }
local function getNextDragID() bai.dragIDCounter = bai.dragIDCounter + 1; return bai.dragIDCounter end
local DRAG_TOTAL, DRAG_SET_START, DRAG_SET_COUNT = 60, 28, 2
local DRAG_SET_INTERVAL, DRAG_REFRESH_INTERVAL, DRAG_AFTER_WAIT = 0.01, 0.01, 0.01
function dragToPosition(model, targetCF, callback, waitFinish)
    if not model or not model.Parent then if callback then callback() end; return end
    local interaction = rep:FindFirstChild("Interaction")
    if not interaction then
        unlockPlayer()
        if callback then callback() end
        return
    end
    local remote = interaction:FindFirstChild("ClientIsDragging")
    local requestOwnership = interaction:FindFirstChild("ClientRequestOwnership")
    if not remote then
        unlockPlayer()
        if callback then callback() end
        return
    end
    local primary = model.PrimaryPart or model:FindFirstChild("WoodSection") or model:FindFirstChild("Main") or model:FindFirstChildWhichIsA("BasePart")
    if not primary then if callback then callback() end; return end
    if not model.PrimaryPart then model.PrimaryPart = primary end
    lockPlayerAt(primary.CFrame + Vector3.new(0, 3, 0))
    local dragID = getNextDragID()
    local function requestOwn()
        if requestOwnership then pcall(function() requestOwnership:FireServer(primary) end) end
    end
    requestOwn()
    pcall(function() remote:FireServer("Begin", model, dragID) end)
    local lastSet = DRAG_SET_START + DRAG_SET_COUNT - 1
    for i = 1, lastSet do
        if not model.Parent or not model.PrimaryPart then
            pcall(function() remote:FireServer("End", model, dragID) end)
            if callback then callback() end; return
        end
        local shouldSet = (i >= DRAG_SET_START)
        pcall(function()
            remote:FireServer("Refresh", model, dragID)
            if shouldSet then
                requestOwn()
                model:SetPrimaryPartCFrame(targetCF)
            end
        end)
        if i < lastSet then
            if shouldSet then task.wait(DRAG_SET_INTERVAL) else task.wait(DRAG_REFRESH_INTERVAL) end
        end
    end
    task.wait(DRAG_AFTER_WAIT)
    local dragEnded = false
    task.spawn(function()
        for i = lastSet + 1, DRAG_TOTAL do
            if not model.Parent or not model.PrimaryPart then break end
            pcall(function() remote:FireServer("Refresh", model, dragID) end)
            if i < DRAG_TOTAL then task.wait(DRAG_REFRESH_INTERVAL) end
        end
        pcall(function() remote:FireServer("End", model, dragID) end)
        dragEnded = true
    end)
    if waitFinish then
        local w = 0
        while w < 1.5 and not dragEnded do task.wait(0.05); w = w + 0.05 end
    end
    task.wait(0.4)
    local verify = 0
    while model.Parent and model.PrimaryPart and verify < 2 do
        local dist = (model.PrimaryPart.Position - targetCF.Position).Magnitude
        if dist <= 3 then break end
        verify = verify + 1
        lockPlayerAt(primary.CFrame + Vector3.new(0, 3, 0))
        task.wait(0.15)
        local retryID = getNextDragID()
        requestOwn()
        pcall(function() remote:FireServer("Begin", model, retryID) end)
        for _ = 1, 10 do
            if not model.Parent then break end
            requestOwn()
            pcall(function() remote:FireServer("Refresh", model, retryID) end)
            pcall(function() model:SetPrimaryPartCFrame(targetCF) end)
            task.wait(0.05)
        end
        pcall(function() remote:FireServer("End", model, retryID) end)
        task.wait(0.15)
    end
    unlockPlayer()
    if callback then callback() end
end
-- ====== 树木种类数据（誓言） ======
local TREE_CN = {
Generic="普通树",GenericDead="枯木",GenericFall="落叶树",GenericGold="金树",GenericPrime="原始树",
GenericSpecial="特殊树",GoldSwampy="沼泽黄金",GreenSwampy="沼泽青",Cherry="樱花树",
CaveCrawler="蓝木",Cavern="洞窟紫木",CavernCrawler="洞窟爬虫",GrottoCrawler="洞穴爬虫",
TunnelCrawler="隧道爬虫",Frost="冰木",Volcano="火山木",Oak="橡木",Walnut="巧克力木",
Birch="白桦木",Aspen="白洋木",Koa="大巧克力树",Palm="椰子树",Pine="雪地松",Fir="冷杉木",
Maple="枫木",SnowGlow="黄金木",Snow="雪木",Ice="冰晶木",LoneCave="幻影木",
Spooky="幽灵木",SpookyNeon="南瓜木",SpookyGhoul="幽灵食尸者",CandycaneGhoul="拐杖糖幽灵木",
CandycaneHalloween="万圣节拐杖糖木",CandycaneNeonSpook="霓虹万圣节木",
Hell="地狱木",Infernal="炼狱木",Radioactive="辐射木",Magma="岩浆树",Skittles="糖果岩浆树",
Ember="余烬木",Celestial="裂纹木",Void="虚空木",Spirit="星空木",Star="星星木",Shine="红颜树",
Sky="天堂木",Rainbow="彩虹木",NeonRainbow="霓虹彩虹木",Electric="雷电木",Glass="玻璃木",
Taco="墨西哥木",Diamond="钻石木",Ruby="红宝石木",Copper="铜木",Silver="银木",Gold="金子木",
Stone="石头木",Marble="大理石木",Brick="砖头木",BrickDark="深色砖木",BrickAlternative="异形砖木",
CobbleStone="鹅卵石木",Cookie="曲奇木",Candy="糖果树",CandyNeon="霓虹糖果木",
CandycaneGreen="绿拐杖糖木",CandycaneRed="红拐杖糖木",CandyAlternitive="异界糖果木",
Cartoony="卡通木",CartoonyRainbow="彩虹卡通木",Dog="狗木",Lollipop="棒棒糖木",LollipopHead="棒棒糖头木",
Bush="灌木木",PotBush="花盆灌木",Potato="土豆木",Grass1="草木",Lavender="薰衣草木",
GlowShroom="发光蘑菇木",MuckySewer="下水道木",SewageTree="污水木",Blah="神秘木",Sign="告示牌木",
Thread="线轴木",Random="随机木",REEE="尖叫木",Test="测试木",Bone="骨头木",Crystal="水晶木",
Flame="火焰木",BlueFlame="蓝色火焰木",RainbowFlame="彩色火焰木",CrackedLava="裂隙岩浆木",
Ethereal="以太木",GreatOak="生命古橡",AppleWood="苹果木",Dry="干枯木",DryNeon="霓虹干枯木",
Sand="沙滩木",Virtual="虚拟木",Waffer="华夫木",PotBush2="花盆灌木2",
}
local TREE_FALLBACK = {
["普通树"]="Generic",["沼泽黄金"]="GoldSwampy",["樱花"]="Cherry",["蓝木"]="CaveCrawler",
["冰木"]="Frost",["火山木"]="Volcano",["橡木"]="Oak",["巧克力木"]="Walnut",["白桦木"]="Birch",
["黄金木"]="SnowGlow",["雪地松"]="Pine",["僵尸木"]="GreenSwampy",["大巧克力树"]="Koa",
["椰子树"]="Palm",["幽灵木"]="Spooky",["南瓜木"]="SpookyNeon",["大理石木"]="Marble",
["天堂木"]="Sky",["虚拟木"]="Virtual",["玻璃木"]="Taco",["糖果树"]="CandycaneGreen",
["积木树"]="CandycaneRed",["发光红色糖果木"]="CandyNeon",["彩虹树"]="Rainbow",["雷电木"]="Electric",
["煤炭木"]="GenericDead",["岩浆树"]="Skittles",["紫木"]="Cavern",["下水道木"]="MuckySewer",
["辐射木"]="Radioactive",["地狱木"]="Hell",["沙滩木"]="Sand",["白洋木"]="Aspen",
["发光彩虹木"]="NeonRainbow",["狗木"]="Dog",["幻影木"]="LoneCave",["红颜树"]="Shine",
["石头木"]="Magma",["玻璃冰木"]="Ice",["砖头木"]="Blah",["卡通树"]="CobbleStone",
["曲奇树"]="Cookie",["生命树"]="GreatOak",["虚空木"]="Void",["裂纹木"]="Celestial",
["幽灵食尸者"]="SpookyGhoul",["生锈木"]="SewageTree",["金子木"]="Gold",["星空木"]="Spirit",
["火焰木"]="Flame",["蓝色火焰木"]="BlueFlame",["彩色火焰木"]="RainbowFlame",["星星木"]="Star",
["雪木"]="Snow",["冷杉木"]="Fir",
}
local function readTreeClasses()
    local list = {}
    local amounts = ws:FindFirstChild("Stores") and ws.Stores:FindFirstChild("PlanterStore") and ws.Stores.PlanterStore:FindFirstChild("Planter Spawner") and ws.Stores.PlanterStore["Planter Spawner"]:FindFirstChild("Amounts")
    if amounts then
        for _, c in ipairs(amounts:GetChildren()) do
            if c:IsA("NumberValue") or c:IsA("IntValue") or c:IsA("StringValue") then table.insert(list, tostring(c.Name)) end
        end
    end
    if #list == 0 then
        local W = rep:FindFirstChild("Woods")
        if W then for _, c in ipairs(W:GetChildren()) do table.insert(list, tostring(c.Name)) end end
    end
    return list
end
local treeMapping = {}
for _, cls in ipairs(readTreeClasses()) do treeMapping[TREE_CN[cls] or cls] = cls end
if next(treeMapping) == nil then for cn, cls in pairs(TREE_FALLBACK) do treeMapping[cn] = cls end end
treeMapping["普通树"] = treeMapping["普通树"] or "Generic"
treeMapping["幻影木"] = treeMapping["幻影木"] or "LoneCave"

local TREE_PRIORITY = {"火焰木","石头木","蓝色火焰木","彩色火焰木"}
local function sortTreeNames(list)
    local prio = {}
    for i, n in ipairs(TREE_PRIORITY) do prio[n] = i end
    table.sort(list, function(a, b)
        local pa, pb = prio[a], prio[b]
        if pa and pb then return pa < pb end
        if pa then return true end
        if pb then return false end
        return a < b
    end)
end
local treeNames = {}
for name in pairs(treeMapping) do table.insert(treeNames, name) end
sortTreeNames(treeNames)
local function findUncutTree(treeClass)
    local playerPos = lp.Character and lp.Character.HumanoidRootPart.Position
    if not playerPos then return nil end
    local nearestDist, nearestWood, nearestTree = math.huge, nil, nil
    for _, region in pairs(ws:GetChildren()) do
        if region.Name == "TreeRegion" then
            for _, tree in pairs(region:GetChildren()) do
                if tree:IsA("Model") and tree:FindFirstChild("TreeClass") and tree.TreeClass.Value == treeClass then
                    local woodSections = {}
                    for _, child in pairs(tree:GetChildren()) do
                        if child.Name == "WoodSection" and child:IsA("BasePart") then table.insert(woodSections, child) end
                    end
                    if #woodSections >= 2 then
                        local dist = (woodSections[1].Position - playerPos).Magnitude
                        if dist < nearestDist then nearestDist, nearestWood, nearestTree = dist, woodSections[1], tree end
                    end
                end
            end
        end
    end
    return nearestWood, nearestTree
end
local function getTreeTopCFrame(treeModel)
    local topY, topCF = -math.huge, nil
    for _, child in pairs(treeModel:GetChildren()) do
        if child:IsA("BasePart") then
            local top = child.Position.Y + child.Size.Y / 2
            if top > topY then topY = top; topCF = CFrame.new(child.Position.X, top + 2, child.Position.Z) end
        end
    end
    if not topCF then topCF = treeModel:GetPivot() + Vector3.new(0, 2, 0) end
    return topCF
end
local function getTreeClassFromModel(treeModel)
    local tc = treeModel:FindFirstChild("TreeClass")
    if tc then return tc.Value end
    local name = treeModel.Name
    for _, suffix in ipairs({"SpookyNeon","Spooky","GoldSwampy","Cherry","CaveCrawler","MuckySewer"}) do
        if name:find(suffix) then return suffix end
    end
    return "Generic"
end

local function loadWeaponConfigOld(weaponName)
    local module = rep:FindFirstChild("LoadedAssets") and rep.LoadedAssets:FindFirstChild(weaponName.."AxeClass")
    if not module then return nil end
    local success, axeClass = pcall(require, module)
    if not success then return nil end
    local axeInstance = type(axeClass.new)=="function" and (axeClass.new() or axeClass.new({})) or axeClass
    return {Damage=axeInstance.Damage or 10000, SwingCooldown=axeInstance.SwingCooldown or 0.3, SpecialTrees=axeInstance.SpecialTrees or {}}
end
local function selectBestWeaponOld(treeClass)
    local tf = lp:FindFirstChild("ToolFolder"); if not tf then return nil, nil, "未找到 ToolFolder" end
    local bw, bd, bc = nil, -1, nil
    for _, c in pairs(tf:GetChildren()) do
        local cfg = loadWeaponConfigOld(c.Name)
        if cfg then
            local d = (cfg.SpecialTrees[treeClass] and cfg.SpecialTrees[treeClass].Damage) or cfg.Damage
            if d > bd then bw, bd, bc = c.Name, d, cfg end
        end
    end
    return bw, bc, bd
end
local axeConfigCacheNew = {}
local function loadWeaponConfigNew(weaponName)
    if axeConfigCacheNew[weaponName] ~= nil then return axeConfigCacheNew[weaponName] end
    if weaponName == "OlReliable" or weaponName == "OIReliable" then
        local override = nil
        local wsTool = workspace:FindFirstChild(lp.Name)
        if wsTool then wsTool = wsTool:FindFirstChild("Tool") end
        if wsTool then
            local tn = wsTool:FindFirstChild("ToolName")
            if tn and (tostring(tn.Value)=="OlReliable" or tostring(tn.Value)=="OIReliable") then
                override = wsTool:FindFirstChild("AxeClassDamageOverride")
            end
        end
        if not override then
            local bp = lp:FindFirstChild("Backpack")
            if bp then
                for _, tool in pairs(bp:GetChildren()) do
                    if tool:IsA("Tool") then
                        local tn = tool:FindFirstChild("ToolName")
                        if tn and (tostring(tn.Value)=="OlReliable" or tostring(tn.Value)=="OIReliable") then
                            override = tool:FindFirstChild("AxeClassDamageOverride")
                            if override then break end
                        end
                    end
                end
            end
        end
        if override then
            local cfg = {Damage=nil, SwingCooldown=nil, Range=nil, SpecialTrees={}}
            for k, v in pairs(override:GetAttributes()) do
                if k == "Damage" then cfg.Damage = v
                elseif k == "SwingCooldown" then cfg.SwingCooldown = v
                elseif k == "Range" then cfg.Range = v
                else cfg.SpecialTrees[k] = {Damage = v} end
            end
            for _, c in pairs(override:GetChildren()) do
                if c:IsA("NumberValue") or c:IsA("IntValue") then
                    if c.Name == "Damage" then cfg.Damage = c.Value
                    elseif c.Name == "SwingCooldown" then cfg.SwingCooldown = c.Value
                    elseif c.Name == "Range" then cfg.Range = c.Value
                    else cfg.SpecialTrees[c.Name] = {Damage = c.Value} end
                end
            end
            if cfg.Damage or cfg.SwingCooldown or next(cfg.SpecialTrees) then
                axeConfigCacheNew[weaponName] = cfg; return cfg
            end
        end
    end
    local function findAxeModule(name)
        local want = name.."AxeClass"
        local la = rep:FindFirstChild("LoadedAssets")
        if la then local m = la:FindFirstChild(want); if m then return m end end
        if type(getloadedmodules) == "function" then
            for _, m in ipairs(getloadedmodules()) do
                if m:IsA("ModuleScript") and (m.Name == want or m:GetFullName():sub(-#want) == want) then return m end
            end
        end
        return nil
    end
    local function decompileSafe(s)
        if not s then return nil end
        if type(decompile) == "function" then
            local ok, src = pcall(decompile, s)
            if ok and type(src) == "string" and #src > 0 then return src end
        end
        return nil
    end
    local function parseNum(src, key)
        local v = src:match("[%w_%.]+%.?" .. key .. "%s*=%s*([%-]?[%d%.]+)")
        if not v then v = src:match(key .. "%s*=%s*([%-]?[%d%.]+)") end
        return tonumber(v)
    end
    local function parseSpecialTrees(src)
        local out = {}
        for tn, body in src:gmatch("SpecialTrees%.([%w_]+)%s*=%s*{(.-)}") do
            local cfg = {}
            cfg.Damage = tonumber(body:match("Damage%s*=%s*([%-]?[%d%.]+)"))
            cfg.SwingCooldown = tonumber(body:match("SwingCooldown%s*=%s*([%-]?[%d%.]+)"))
            if cfg.Damage then out[tn] = cfg end
        end
        return out
    end
    local module = findAxeModule(weaponName)
    if not module then axeConfigCacheNew[weaponName] = nil; return nil end
    local src = decompileSafe(module)
    if not src then
        local fallback = loadWeaponConfigOld(weaponName)
        axeConfigCacheNew[weaponName] = fallback
        return fallback
    end
    local cfg = {Damage=parseNum(src,"Damage"), SwingCooldown=parseNum(src,"SwingCooldown"), Range=parseNum(src,"Range"), SpecialTrees=parseSpecialTrees(src)}
    if not cfg.Damage or not cfg.SwingCooldown then axeConfigCacheNew[weaponName] = nil; return nil end
    cfg.Range = cfg.Range or 10
    axeConfigCacheNew[weaponName] = cfg
    return cfg
end
local function selectBestWeaponNew(treeClass)
    local tf = lp:FindFirstChild("ToolFolder"); if not tf then return nil, nil, "未找到 ToolFolder" end
    local bw, bd, bc = nil, -1, nil
    for _, c in pairs(tf:GetChildren()) do
        local cfg = loadWeaponConfigNew(c.Name)
        if cfg then
            local d = (cfg.SpecialTrees[treeClass] and cfg.SpecialTrees[treeClass].Damage) or cfg.Damage
            if d > bd then bw, bd, bc = c.Name, d, cfg end
        end
    end
    return bw, bc, bd
end

local DANGER_MIN_X, DANGER_MAX_X = -543, -27.8
local DANGER_MIN_Y, DANGER_MAX_Y = -196.7, -148.2
local DANGER_MIN_Z, DANGER_MAX_Z = -2961.7, -2668.7
local function isInDangerZone(pos)
    return pos.X >= DANGER_MIN_X and pos.X <= DANGER_MAX_X
        and pos.Y >= DANGER_MIN_Y and pos.Y <= DANGER_MAX_Y
        and pos.Z >= DANGER_MIN_Z and pos.Z <= DANGER_MAX_Z
end

local function getRemoteProxy()
    local inter = rep:FindFirstChild("Interaction")
    if not inter then return nil end
    local r = inter:FindFirstChild("RemoteProxy")
    if r then return r end
    r = inter:WaitForChild("RemoteProxy", 10)
    return r
end
local function getLogModels()
    local lm = ws:FindFirstChild("LogModels")
    if not lm then lm = ws:WaitForChild("LogModels", 5) end
    return lm
end
local function bringTreeOld(treeClass, progressText)
    local weaponName, weaponConfig, damage = selectBestWeaponOld(treeClass)
    if not weaponName then notify("MOYAN HUB", "自动选武器失败", 3); return false end
    local req = {LoveCave=10000000, Shine=80000000, Magma=5000000, Ice=8000000, Radioactive=10000000, Scale=40000000, Void=5000000, Flame=10000000, BlueFlame=3500000, RainbowFlame=3500000, Celestial=10000000}
    if req[treeClass] and damage < req[treeClass] then notify("MOYAN HUB", string.format("伤害不足！需要至少 %.0f", req[treeClass]), 4); return false end
    local cooldown = (weaponConfig.SpecialTrees[treeClass] and weaponConfig.SpecialTrees[treeClass].SwingCooldown) or weaponConfig.SwingCooldown
    local woodSec, tree = findUncutTree(treeClass)
    if not woodSec then notify("MOYAN HUB", "附近没有可砍的树", 3); return false end
    if isInDangerZone(woodSec.Position) then
        notify("MOYAN HUB", "树在危险区域内，已删除", 5)
        if tree and tree.Parent then tree:Destroy() end
        return false
    end
    local tool = lp.Character and lp.Character:FindFirstChildOfClass("Tool")
    if not tool then
        local tf = lp:FindFirstChild("ToolFolder")
        if tf then local wo = tf:FindFirstChild(weaponName); tool = wo and (wo:IsA("Tool") and wo or wo.Value) or nil end
    end
    if not tool then notify("MOYAN HUB", "未找到工具: "..weaponName, 3); return false end
    local cutEvent = tree:FindFirstChild("CutEvent")
    if not cutEvent then notify("MOYAN HUB", "无法获取CutEvent", 3); return false end
    local remote = getRemoteProxy()
    if not remote then notify("MOYAN HUB", "RemoteProxy 未就绪", 3); return false end
    local logModels = getLogModels()
    if not logModels then notify("MOYAN HUB", "LogModels 未找到", 3); return false end
    local hrp0 = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    local playerOriginalCF = hrp0 and hrp0.CFrame
    if not playerOriginalCF then return false end
    lockPlayerAt(getTreeTopCFrame(tree))
    local fallenLog, existing = nil, {}
    for _, log in pairs(logModels:GetChildren()) do existing[log] = true end
    local treeCenter = woodSec.Position
    local stopCutting, timeoutReached = false, false
    local sendTask = task.spawn(function()
        while not stopCutting do
            pcall(remote.FireServer, remote, cutEvent, {height=0.3, faceVector=Vector3.new(-1,0,0), cooldown=cooldown, sectionId=1, hitPoints=damage, tool=tool, cuttingClass="Axe"})
            task.wait(0.01)
        end
    end)
    local timeoutTask = task.spawn(function() task.wait(15); if not stopCutting then timeoutReached=true; stopCutting=true end end)
    while not fallenLog and not stopCutting do
        for _, log in pairs(logModels:GetChildren()) do
            if not existing[log] and log:FindFirstChild("Owner") and log.Owner.Value==lp and log:FindFirstChild("TreeClass") and log.TreeClass.Value==treeClass then
                if (log:GetPivot().Position - treeCenter).Magnitude < 100 then fallenLog=log; break end
            end
        end
        task.wait(0.01)
    end
    stopCutting = true; task.cancel(sendTask); task.cancel(timeoutTask)
    if timeoutReached or not fallenLog then notify("MOYAN HUB", "砍树超时", 3); safeTeleport(playerOriginalCF); return false end
    local primary = fallenLog.PrimaryPart or fallenLog:FindFirstChild("WoodSection") or fallenLog:FindFirstChild("Main") or fallenLog:FindFirstChildWhichIsA("BasePart")
    if not primary then safeTeleport(playerOriginalCF); return false end
    if isInDangerZone(primary.Position) then
        notify("MOYAN HUB", "木头落危险区，已删除", 5)
        if fallenLog and fallenLog.Parent then fallenLog:Destroy() end
        safeTeleport(playerOriginalCF); return false
    end
    if not fallenLog.PrimaryPart then fallenLog.PrimaryPart = primary end
    lockPlayerAt(primary.CFrame + Vector3.new(0,3,0))
    task.wait(0.15)
    for _ = 1, 3 do pcall(function() local inter = rep:FindFirstChild("Interaction"); if inter then local ro = inter:FindFirstChild("ClientRequestOwnership"); if ro then ro:FireServer(primary) end end end); task.wait(0.01) end
    local done = false
    dragToPosition(fallenLog, playerOriginalCF, function() done = true end, true)
    local t = 0
    while not done and t < 6 do task.wait(0.05); t = t + 0.05 end
    safeTeleport(playerOriginalCF)
    notify("MOYAN HUB", "树已带来 " .. (progressText or ""), 2)
    return true
end

local function bringTreeNew(treeClass, progressText)
    local weaponName, weaponConfig, damage = selectBestWeaponNew(treeClass)
    if not weaponName then notify("MOYAN HUB", "自动选武器失败", 3); return false end
    local req = {Flame=200000, BlueFlame=200000, Celestial=200000, Void=200000, Ice=200000, Magma=200000, RainbowFlame=200000, Radioactive=200000, Shine=200000, LoneCave=200000, Spirit=200000}
    if req[treeClass] and damage < req[treeClass] then notify("MOYAN HUB", string.format("伤害不足！需要至少 %.0f", req[treeClass]), 4); return false end
    local cooldown = (weaponConfig.SpecialTrees[treeClass] and weaponConfig.SpecialTrees[treeClass].SwingCooldown) or weaponConfig.SwingCooldown
    local woodSec, tree = findUncutTree(treeClass)
    if not woodSec then notify("MOYAN HUB", "附近没有可砍的树", 3); return false end
    if isInDangerZone(woodSec.Position) then
        notify("MOYAN HUB", "树在危险区域内，已删除", 5)
        if tree and tree.Parent then tree:Destroy() end
        return false
    end
    local tool = lp.Character and lp.Character:FindFirstChildOfClass("Tool")
    if not tool then
        local tf = lp:FindFirstChild("ToolFolder")
        if tf then local wo = tf:FindFirstChild(weaponName); tool = wo and (wo:IsA("Tool") and wo or wo.Value) or nil end
    end
    if not tool then notify("MOYAN HUB", "未找到工具: "..weaponName, 3); return false end
    local cutEvent = tree:FindFirstChild("CutEvent")
    if not cutEvent then return false end
    local remote = getRemoteProxy()
    if not remote then notify("MOYAN HUB", "RemoteProxy 未就绪", 3); return false end
    local logModels = getLogModels()
    if not logModels then notify("MOYAN HUB", "LogModels 未找到", 3); return false end
    local hrp0 = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    local playerOriginalCF = hrp0 and hrp0.CFrame
    if not playerOriginalCF then return false end
    lockPlayerAt(getTreeTopCFrame(tree))
    local fallenLog, existing = nil, {}
    for _, log in pairs(logModels:GetChildren()) do existing[log] = true end
    local treeCenter = woodSec.Position
    local stopCutting, timeoutReached = false, false
    local sendTask = task.spawn(function()
        while not stopCutting do
            pcall(remote.FireServer, remote, cutEvent, {height=0.3, faceVector=Vector3.new(-1,0,0), cooldown=cooldown, sectionId=1, hitPoints=damage, tool=tool, cuttingClass="Axe"})
            task.wait(0.0001)
        end
    end)
    local timeoutTask = task.spawn(function() task.wait(15); if not stopCutting then timeoutReached=true; stopCutting=true end end)
    while not fallenLog and not stopCutting do
        for _, log in pairs(logModels:GetChildren()) do
            if not existing[log] and log:FindFirstChild("Owner") and log.Owner.Value==lp and log:FindFirstChild("TreeClass") and log.TreeClass.Value==treeClass then
                if (log:GetPivot().Position - treeCenter).Magnitude < 100 then fallenLog=log; break end
            end
        end
        task.wait(0.01)
    end
    stopCutting = true; task.cancel(sendTask); task.cancel(timeoutTask)
    if timeoutReached or not fallenLog then notify("MOYAN HUB", "砍树超时", 3); safeTeleport(playerOriginalCF); return false end
    local primary = fallenLog.PrimaryPart or fallenLog:FindFirstChild("WoodSection") or fallenLog:FindFirstChild("Main") or fallenLog:FindFirstChildWhichIsA("BasePart")
    if not primary then safeTeleport(playerOriginalCF); return false end
    if isInDangerZone(primary.Position) then
        notify("MOYAN HUB", "木头落危险区，已删除", 5); if fallenLog and fallenLog.Parent then fallenLog:Destroy() end; safeTeleport(playerOriginalCF); return false
    end
    if not fallenLog.PrimaryPart then fallenLog.PrimaryPart = primary end
    lockPlayerAt(primary.CFrame + Vector3.new(0,3,0))
    task.wait(0.15)
    for _ = 1, 3 do pcall(function() local inter = rep:FindFirstChild("Interaction"); if inter then local ro = inter:FindFirstChild("ClientRequestOwnership"); if ro then ro:FireServer(primary) end end end); task.wait(0.01) end
    local done = false
    dragToPosition(fallenLog, playerOriginalCF, function() done = true end, true)
    local t = 0
    while not done and t < 6 do task.wait(0.05); t = t + 0.05 end
    safeTeleport(playerOriginalCF)
    notify("MOYAN HUB", "树已带来 " .. (progressText or ""), 2)
    return true
end

local selectedPlan = 1
local function runBringTree(treeClass, progressText)
    if selectedPlan == 2 then return bringTreeNew(treeClass, progressText)
    else return bringTreeOld(treeClass, progressText) end
end

local function selectSawmill()
    notify("MOYAN HUB", "请点击锯木机任意部件", 3)
    local conn
    conn = mouse.Button1Down:Connect(function()
        local target = mouse.Target
        if not target then return end
        local model = target:FindFirstAncestorOfClass("Model")
        if not model then return end
        local function isSawmill(root)
            local attr = root:GetAttribute("ItemName")
            if attr and type(attr) == "string" and attr:lower():find("saw") then return true end
            for _, c in pairs(root:GetDescendants()) do
                if c.Name == "ItemName" then
                    local val = c.Value
                    if val and type(val) == "string" and val:lower():find("saw") then return true end
                end
            end
            if root.Name and root.Name:lower():find("saw") then return true end
            local tv = root:FindFirstChild("Type")
            return tv and tv.Value == "Sawmill"
        end
        if not isSawmill(model) then notify("MOYAN HUB", "不是锯木机", 3); return end
        local function findPart(root)
            for _, c in pairs(root:GetDescendants()) do if c.Name == "Conveyor" and c:IsA("BasePart") then return c, "Conveyor" end end
            for _, c in pairs(root:GetDescendants()) do if c.Name == "Main" and c:IsA("BasePart") then return c, "Main" end end
        end
        local part, pt = findPart(model)
        if not part then notify("MOYAN HUB", "找不到部件", 3); return end
        bai.cachedSawmill = model; bai.cachedSawmillPos = part.CFrame
        conn:Disconnect()
        notify("MOYAN HUB", "已记忆锯木机（"..pt.."）", 3)
    end)
end
local function selectBestWeaponByPlan(treeClass)
    if selectedPlan == 2 then return selectBestWeaponNew(treeClass)
    else return selectBestWeaponOld(treeClass) end
end

local function decomposeAndProcess(treeModel, sawmill, sawmillPos)
    if not sawmillPos then notify("MOYAN HUB", "锯木机位置无效", 3); return end
    local sections, rootSection = {}, nil
    for _, child in pairs(treeModel:GetChildren()) do
        if child.Name == "WoodSection" and child:IsA("BasePart") and child:FindFirstChild("ID") then
            local id = child.ID.Value
            if id >= 2 then table.insert(sections, {id = id, part = child})
            elseif id == 1 then rootSection = child end
        end
    end
    if #sections == 0 then notify("MOYAN HUB", "无可分解部分", 3); return end
    table.sort(sections, function(a, b) return a.id > b.id end)
    local cutEvent = treeModel:FindFirstChild("CutEvent")
    if not cutEvent then notify("MOYAN HUB", "无 CutEvent", 3); return end
    local treeClass = getTreeClassFromModel(treeModel)
    local weaponName, weaponConfig, err = selectBestWeaponByPlan(treeClass)
    if not weaponName then notify("MOYAN HUB", "选武器失败: " .. (err or ""), 3); return end
    local tool = lp.Character and lp.Character:FindFirstChildOfClass("Tool")
    if not tool then
        local toolFolder = lp:FindFirstChild("ToolFolder")
        if toolFolder then
            local weaponObj = toolFolder:FindFirstChild(weaponName)
            tool = weaponObj and (weaponObj:IsA("Tool") and weaponObj or weaponObj.Value) or nil
        end
    end
    if not tool then notify("MOYAN HUB", "未找到工具: " .. weaponName, 3); return end
    local damage = weaponConfig and weaponConfig.Damage or 10000
    local cooldown = weaponConfig and weaponConfig.SwingCooldown or 0.3
    if weaponConfig and weaponConfig.SpecialTrees and weaponConfig.SpecialTrees[treeClass] then
        damage = weaponConfig.SpecialTrees[treeClass].Damage or damage
        cooldown = weaponConfig.SpecialTrees[treeClass].SwingCooldown or cooldown
    end
    local remote = getRemoteProxy()
    if not remote then notify("MOYAN HUB", "RemoteProxy 未就绪", 3); return end
    local logModels = getLogModels()
    if not logModels then notify("MOYAN HUB", "LogModels 未找到", 3); return end
    local initialLogs = {}
    for _, log in pairs(logModels:GetChildren()) do initialLogs[log] = true end
    local tasks = {}
    notify("MOYAN HUB", string.format("开始分解 %d 个部分", #sections), 2)
    for _, sec in ipairs(sections) do
        local part = sec.part
        local sectionId = sec.id
        local taskId = task.spawn(function()
            while part and part.Parent do
                pcall(remote.FireServer, remote, cutEvent, {height=0.11, faceVector=Vector3.new(-1,0,0), cooldown=cooldown, sectionId=sectionId, hitPoints=damage, tool=tool, cuttingClass="Axe"})
                task.wait(0.01)
            end
        end)
        tasks[taskId] = true
    end
    local function hasHighIDSections()
        for _, child in pairs(treeModel:GetChildren()) do
            if child.Name == "WoodSection" and child:FindFirstChild("ID") then
                if child.ID.Value >= 2 then return true end
            end
        end
        return false
    end
    local startTime = tick()
    while hasHighIDSections() and tick() - startTime < 10 do task.wait(0.01) end
    for taskId in pairs(tasks) do task.cancel(taskId) end
    if hasHighIDSections() then notify("MOYAN HUB", "砍树超时", 3); return end
    local allLogs = {}
    for _, log in pairs(logModels:GetChildren()) do
        if not initialLogs[log] and log:FindFirstChild("Owner") and log.Owner.Value == lp then table.insert(allLogs, log) end
    end
    if #allLogs == 0 then notify("MOYAN HUB", "未找到木头", 3); return end
    local pos = sawmillPos.p + sawmillPos:VectorToWorldSpace(Vector3.new(0.7, 0, 0))
    local targetPos = CFrame.new(pos) * (sawmillPos - sawmillPos.p) * CFrame.Angles(math.rad(-90), math.rad(90), 0)
    local allModels = {}
    for _, log in ipairs(allLogs) do if log and log.Parent then table.insert(allModels, log) end end
    if rootSection and rootSection.Parent then
        if not treeModel.PrimaryPart then treeModel.PrimaryPart = rootSection end
        table.insert(allModels, treeModel)
    end
    for _, model in ipairs(allModels) do
        if model and model.Parent then
            local primary = model.PrimaryPart or model:FindFirstChild("WoodSection") or model:FindFirstChild("Main") or model:FindFirstChildWhichIsA("BasePart")
            if primary then
                if not model.PrimaryPart then model.PrimaryPart = primary end
                safeTeleport(primary.CFrame + Vector3.new(0, 2, 0))
                task.wait(0.06)
                dragToPosition(model, targetPos)
            end
        end
    end
    notify("MOYAN HUB", "木头和树根拖拽完成", 3)
end

local isDecomposeActive = false
local decomposeConn = nil
local function startDecomposeSelection()
    if isDecomposeActive then notify("MOYAN HUB", "分解选择已激活", 2); return end
    if not bai.cachedSawmill or not bai.cachedSawmill.Parent then notify("MOYAN HUB", "请先选择锯木机", 3); return end
    if not bai.cachedSawmillPos then notify("MOYAN HUB", "锯木机位置无效", 3); return end
    isDecomposeActive = true
    notify("MOYAN HUB", "请点击一棵树", 3)
    decomposeConn = mouse.Button1Down:Connect(function()
        local target = mouse.Target
        if not target then return end
        local model = target:FindFirstAncestorOfClass("Model")
        if not model then return end
        local hasWood = false
        for _, child in pairs(model:GetChildren()) do if child.Name == "WoodSection" then hasWood = true end end
        if not (hasWood and model:FindFirstChild("CutEvent")) then notify("MOYAN HUB", "这不是树", 2); return end
        if decomposeConn then decomposeConn:Disconnect(); decomposeConn = nil end
        isDecomposeActive = false
        task.spawn(function() decomposeAndProcess(model, bai.cachedSawmill, bai.cachedSawmillPos) end)
    end)
end

-- ====== 传送物品（誓言） ======
local teleportTargetCF = nil
local teleportTargetPlayer = lp.Name
local teleportMarker = nil
local selectedItems = {}
local selectionBoxes = {}
local selectionConn, sameNameConn = nil, nil
local selectingMode, sameNameEnabled = false, false

local function setTeleportPoint()
    if teleportMarker then pcall(function() teleportMarker:Destroy() end); teleportMarker = nil end
    local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    teleportTargetCF = hrp.CFrame
    local marker = Instance.new("Part")
    marker.Name = "MOYAN_TPMarker"; marker.Anchored = true; marker.Parent = workspace
    marker.Shape = Enum.PartType.Ball; marker.Size = Vector3.new(2,2,2)
    marker.Color = Color3.fromRGB(0,217,255); marker.Material = Enum.Material.ForceField
    marker.CFrame = teleportTargetCF
    teleportMarker = marker
    notify("MOYAN HUB", "传送点已设置", 3)
end
local function clearTeleportPoint()
    if teleportMarker then pcall(function() teleportMarker:Destroy() end); teleportMarker = nil end
    teleportTargetCF = nil
    notify("MOYAN HUB", "传送点已清除", 3)
end
local function isSelectable(model)
    if not model or not model:IsA("Model") then return false end
    if model:FindFirstChild("BlueprintWoodClass") then return false end
    if model:FindFirstChild("ButtonRemote_SpawnButton") then return false end
    local name = model.Name or ""
    if name:find("Crate") or name:find("Box") or name:find("Gift") then
        local has = false
        local p1 = model:FindFirstChild("PurchasedBoxItemName")
        if p1 and p1.Value and p1.Value ~= "" and p1.Value ~= " " then has = true end
        local p2 = model:FindFirstChild("BoxItemName")
        if not has and p2 and p2.Value and p2.Value ~= "" and p2.Value ~= " " then has = true end
        local p3 = model:FindFirstChild("Type")
        if not has and p3 and p3.Value and p3.Value ~= "" and p3.Value ~= " " then has = true end
        if not has then return false end
    end
    local target = game.Players:FindFirstChild(teleportTargetPlayer)
    if not target then return false end
    local owner = model:FindFirstChild("Owner")
    return owner and owner.Value == target
end
local function highlightItem(model)
    if selectionBoxes[model] then return end
    local primary = model.PrimaryPart or model:FindFirstChild("Main") or model:FindFirstChild("WoodSection") or model:FindFirstChildWhichIsA("BasePart")
    if not primary then return end
    local box = Instance.new("SelectionBox")
    box.Adornee = primary; box.Color3 = Color3.fromRGB(0,255,0); box.Transparency = 0.5; box.Parent = primary
    selectionBoxes[model] = box
end
local function unhighlightItem(model)
    local box = selectionBoxes[model]
    if box then pcall(function() box:Destroy() end); selectionBoxes[model] = nil end
end
local function clearSelection()
    for m, _ in pairs(selectedItems) do unhighlightItem(m) end
    selectedItems = {}
    notify("MOYAN HUB", "已清空所有选中", 2)
end
local function groupKeyForItem(m)
    local owner = m:FindFirstChild("Owner")
    if owner and owner.Value ~= nil then return m.Name, owner.Value end
    local t = m:FindFirstChild("Type")
    return m.Name, (t and t.Value) or nil
end
local function selectItem(model)
    if not isSelectable(model) then return end
    if selectedItems[model] then
        unhighlightItem(model); selectedItems[model] = nil
    else
        selectedItems[model] = true; highlightItem(model)
    end
end
local function selectSameNameItems(sourceModel)
    local first = sourceModel or next(selectedItems)
    if not first then return end
    local tn, to = groupKeyForItem(first)
    local count = 0
    local function try(m)
        if not m or not m:IsA("Model") then return end
        if not isSelectable(m) then return end
        local n, o = groupKeyForItem(m)
        if n == tn and o == to and not selectedItems[m] then
            selectedItems[m] = true; highlightItem(m); count = count + 1
        end
    end
    try(sourceModel)
    local pm = workspace:FindFirstChild("PlayerModels")
    if pm then for _, m in pairs(pm:GetDescendants()) do try(m) end end
    local lm = workspace:FindFirstChild("LogModels")
    if lm then for _, m in pairs(lm:GetDescendants()) do try(m) end end
    notify("MOYAN HUB", string.format("已添加 %d 个同名物品", count), 3)
end
local function cancelSameNameItems(sourceModel)
    local tn, to = groupKeyForItem(sourceModel)
    local n = 0
    for m, _ in pairs(selectedItems) do
        local mn, mo = groupKeyForItem(m)
        if mn == tn and mo == to then unhighlightItem(m); selectedItems[m] = nil; n = n + 1 end
    end
    notify("MOYAN HUB", "已取消本组 " .. n .. " 个", 2)
end
local function teleportSelectedItems()
    if not teleportTargetCF then notify("MOYAN HUB", "请先设置传送点", 3); return end
    local all = {}
    for m, _ in pairs(selectedItems) do
        if m and m.Parent then
            local primary = m.PrimaryPart or m:FindFirstChild("Main") or m:FindFirstChild("WoodSection") or m:FindFirstChildWhichIsA("BasePart")
            if primary then
                if not m.PrimaryPart then m.PrimaryPart = primary end
                table.insert(all, m)
            end
        end
    end
    if #all == 0 then notify("MOYAN HUB", "没有选中的物品", 3); return end
    local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    local originalPos = hrp and hrp.CFrame
    local successCount = 0
    for _, m in ipairs(all) do
        if m.Parent and m.PrimaryPart then
            pcall(function() safeTeleport(m.PrimaryPart.CFrame + Vector3.new(0,2,0)) end)
            task.wait(0.1)
            dragToPosition(m, teleportTargetCF)
            unhighlightItem(m); selectedItems[m] = nil
            successCount = successCount + 1
        end
    end
    if originalPos then safeTeleport(originalPos) end
    notify("MOYAN HUB", string.format("传送完成 %d/%d", successCount, #all), 3)
end

local function tp(pos)
    if typeof(pos) == "CFrame" then
        lp.Character:SetPrimaryPartCFrame(pos)
    elseif typeof(pos) == "Vector3" then
        lp.Character:MoveTo(pos)
    end
end
local function carTeleport(cf)
    local char = lp.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.SeatPart == nil then return end
    local Car = hum.SeatPart.Parent
    task.spawn(function()
        for i = 1, 5 do
            task.wait()
            local hrp2 = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp2 then break end
            local rotCF = CFrame.Angles(math.rad(hrp2.Orientation.x), math.rad(hrp2.Orientation.y), 0)
            pcall(function() Car:SetPrimaryPartCFrame(cf * rotCF) end)
            local inter = rep:FindFirstChild("Interaction")
            if inter then
                pcall(function() inter.ClientRequestOwnership:FireServer(Car.Main) end)
                pcall(function() inter.ClientIsDragging:FireServer(Car.Main) end)
            end
        end
    end)
end

-- ====== 恶魔鸭合成（誓言） ======
local selectedMaterialKeys = {nil, nil, nil}
local dragTargets = {
    [1] = CFrame.new(-223.74, 61.00, 940.42),
    [2] = CFrame.new(-232.924927, 61.3797455, 933.015076),
    [3] = CFrame.new(-241.81, 61, 925.51),
}

local function getItemKey(model)
    if not model then return nil end
    if model:FindFirstChild("PurchasedBoxItemName") then return "PurchasedBoxItemName:"..model.PurchasedBoxItemName.Value
    elseif model:FindFirstChild("ItemName") then return "ItemName:"..model.ItemName.Value
    elseif model:FindFirstChild("DraggableItem") then return "DraggableItem:"..tostring(model.DraggableItem.Parent) end
    return nil
end
local function findItemByKey(key, allowFuzzy)
    if not key then return nil end
    local prefix, value = key:match("^(.-):(.+)$")
    if not prefix or not value then return nil end
    for _, m in pairs(ws.PlayerModels:GetChildren()) do
        if m:FindFirstChild("Owner") and m.Owner.Value == lp then
            if prefix == "PurchasedBoxItemName" and m:FindFirstChild("PurchasedBoxItemName") and m.PurchasedBoxItemName.Value == value then return m
            elseif prefix == "ItemName" and m:FindFirstChild("ItemName") and m.ItemName.Value == value then return m
            elseif prefix == "DraggableItem" and m:FindFirstChild("DraggableItem") and tostring(m.DraggableItem.Parent) == value then return m end
        end
    end
    if allowFuzzy then
        for _, m in pairs(ws.PlayerModels:GetChildren()) do
            if m:FindFirstChild("Owner") and m.Owner.Value == lp then
                local v = nil
                if m:FindFirstChild("PurchasedBoxItemName") then v = m.PurchasedBoxItemName.Value
                elseif m:FindFirstChild("ItemName") then v = m.ItemName.Value
                elseif m:FindFirstChild("DraggableItem") then v = tostring(m.DraggableItem.Parent) end
                if v == value then return m end
            end
        end
    end
    return nil
end
local function openItem(item)
    if not item then return false end
    local inter = rep:FindFirstChild("Interaction")
    if not inter then return false end
    local remoteProxy = inter:FindFirstChild("RemoteProxy")
    local clientInteracted = inter:FindFirstChild("ClientInteracted")
    local rb = item:FindFirstChild("ButtonRemote_Main")
    if rb and remoteProxy then
        pcall(function() remoteProxy:FireServer(rb) end)
        return true
    end
    if (item:FindFirstChild("BoxItemName") or item:FindFirstChild("PurchasedBoxItemName")) and clientInteracted then
        pcall(function() clientInteracted:FireServer(item, 'Open box') end)
        return true
    end
    return false
end
local function selectMaterial(index)
    notify("MOYAN HUB", string.format("请点击第 %d 个属于自己的物品（15秒内）", index), 4)
    local conn = nil
    local cancelled = false
    conn = mouse.Button1Up:Connect(function()
        cancelled = true
        pcall(function() conn:Disconnect() end)
        local target = mouse.Target
        if not target then notify("MOYAN HUB", "未选中任何物品", 2); return end
        local model = target:FindFirstAncestorWhichIsA("Model")
        if not model or not model:FindFirstChild("Owner") or model.Owner.Value ~= lp then
            notify("MOYAN HUB", "只能选择自己的物品", 2); return
        end
        local key = getItemKey(model)
        if not key then notify("MOYAN HUB", "无法识别该物品类型", 2); return end
        selectedMaterialKeys[index] = key
        local primary = model.PrimaryPart or model:FindFirstChild("Main") or model:FindFirstChildWhichIsA("BasePart")
        if primary then
            local box = Instance.new("SelectionBox")
            box.Adornee = primary; box.Color3 = Color3.fromRGB(0,255,0); box.Transparency = 0.5
            box.Parent = primary
            task.delay(0.8, function() pcall(function() box:Destroy() end) end)
        end
        notify("MOYAN HUB", string.format("已选中第 %d 个材料: %s", index, model.Name), 2)
    end)
    task.delay(15, function()
        if not cancelled then pcall(function() conn:Disconnect() end) end
    end)
end
local function showSelectedMaterials()
    local msg = {}
    for i = 1, 3 do
        local key = selectedMaterialKeys[i]
        if key then
            local item = findItemByKey(key, false)
            msg[i] = string.format("第%d个: %s", i, item and item.Name or "[已消失]")
        else
            msg[i] = string.format("第%d个: 未选择", i)
        end
    end
    notify("MOYAN HUB", table.concat(msg, "\n"), 5)
end

local function startDevilDuckCombine()
    for i = 1, 3 do
        if not selectedMaterialKeys[i] then notify("MOYAN HUB", "材料 " .. i .. " 未选", 3); return end
    end
    task.spawn(function()
        for i = 1, 3 do
            local item = findItemByKey(selectedMaterialKeys[i], true)
            if not item then notify("MOYAN HUB", "材料"..i.."丢失", 3); return end
            local primary = item.PrimaryPart or item:FindFirstChild("Main") or item:FindFirstChildWhichIsA("BasePart")
            if primary then
                if not item.PrimaryPart then item.PrimaryPart = primary end
                lockPlayerAt(primary.CFrame + Vector3.new(2,0,0))
                dragToPosition(item, dragTargets[i], nil, true)
                unlockPlayer()
            end
        end
        for i = 1, 3 do
            local item = findItemByKey(selectedMaterialKeys[i], true)
            if item then
                local p2 = item.PrimaryPart or item:FindFirstChild("Main") or item:FindFirstChildWhichIsA("BasePart")
                if p2 then lockPlayerAt(p2.CFrame + Vector3.new(2,0,0)); task.wait(0.5) end
                openItem(item)
                task.wait(0.4)
                unlockPlayer()
            end
        end
        notify("MOYAN HUB", "合成已触发", 3)
    end)
end

local function removeDevilDuckWall()
    pcall(function()
        if workspace:FindFirstChild("Region_Main") and workspace.Region_Main:FindFirstChild("ExplodeMe") then
            workspace.Region_Main.ExplodeMe:Destroy()
        end
    end)
    notify("MOYAN HUB", "已尝试删除恶魔鸭墙", 3)
end

-- ====== EvilHeart 合成（誓言） ======
local evilHeathStopFlag = false
local evilHeathAutoRunning = false
local evilHeathCount = 1
local evilHeathMaterials = {"HappyBall", "Egg", "Cocoa"}
local evilHeathDragTargets = {
    [1] = CFrame.new(-515.637939, -86.914101, -2013.382812),
    [2] = CFrame.new(-526.625244, -86.957069, -2017.517578),
    [3] = CFrame.new(-536.980713, -86.994179, -2021.368164),
}

local function waitItemReady(item, timeout)
    timeout = timeout or 3
    local waited = 0
    while waited < timeout do
        if not item or not item.Parent then return false end
        if item:FindFirstChild("ButtonRemote_Main") or item:FindFirstChild("BoxItemName") or item:FindFirstChild("PurchasedBoxItemName") or item:FindFirstChild("ItemName") or item:FindFirstChild("DraggableItem") then
            return true
        end
        task.wait(0.2)
        waited = waited + 0.2
    end
    return item and item.Parent and (item:FindFirstChild("ItemName") ~= nil or item:FindFirstChild("PurchasedBoxItemName") ~= nil)
end
local function waitEvilHeartAppear(timeout, preSet)
    local deadline = os.clock() + (timeout or 10)
    while os.clock() < deadline do
        if evilHeathStopFlag then return false end
        for _, m in pairs(ws.PlayerModels:GetChildren()) do
            if m:IsA("Model") and m.Name == "EvilHeart" and (not preSet or not preSet[m]) then
                return true
            end
        end
        task.wait(0.2)
    end
    return false
end

local function startEvilHeartCombine(basePos)
    local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    local originalPos = basePos or (hrp and hrp.CFrame)
    if not originalPos then
        notify("MOYAN HUB", "无法获取玩家位置", 3)
        return false
    end
    local preHeaths = {}
    for _, m in pairs(ws.PlayerModels:GetChildren()) do
        if m:IsA("Model") and m.Name == "EvilHeart" then preHeaths[m] = true end
    end
    local ok = false
    for attempt = 1, 4 do
        if evilHeathStopFlag then return false end
        if attempt > 1 then
            notify("MOYAN HUB", string.format("5秒内未出现新EvilHeart，重新拖拽（第 %d 轮）", attempt), 3)
        end
        local items = {}
        for i = 1, 3 do
            if evilHeathStopFlag then return false end
            local buyName = evilHeathMaterials[i]
            local key = "ItemName:"..buyName
            local item = findItemByKey(key, false)
            if not item then
                if not _G.qSnowBuyBlueprintBox then
                    notify("MOYAN HUB", "自动购买模块未加载，无法购买材料 " .. buyName, 4)
                    return false
                end
                local box, err
                for r = 1, 3 do
                    if evilHeathStopFlag then return false end
                    box, err = _G.qSnowBuyBlueprintBox(buyName)
                    if box then break end
                    notify("MOYAN HUB", string.format("购买材料 %s 失败（第 %d 次重试）: %s", buyName, r, tostring(err or "未知")), 3)
                    task.wait(0.6)
                end
                if not box then
                    notify("MOYAN HUB", string.format("材料 %s 购买失败，重试3次仍未成功", buyName), 3)
                end
                item = box or findItemByKey(key, true)
            end
            if not item then
                notify("MOYAN HUB", string.format("材料 %s 无法获取", buyName), 3)
                return false
            end
            items[i] = item
            if not waitItemReady(item, 3) then
                notify("MOYAN HUB", string.format("材料 %s 尚未就绪", buyName), 2)
            end
            local primary = item.PrimaryPart or item:FindFirstChild("Main") or item:FindFirstChild("WoodSection") or item:FindFirstChildWhichIsA("BasePart")
            if primary then
                if not item.PrimaryPart then item.PrimaryPart = primary end
                lockPlayerAt(primary.CFrame + Vector3.new(2,0,0))
                dragToPosition(item, evilHeathDragTargets[i], nil, true)
                unlockPlayer()
                notify("MOYAN HUB", string.format("%s 已拖到 %d 号位", buyName, i), 2)
            end
        end
        for i = 1, 3 do
            if evilHeathStopFlag then return false end
            local item = items[i]
            if not item or not item.Parent then
                local key = "ItemName:"..evilHeathMaterials[i]
                item = findItemByKey(key, true)
            end
            if item and item.Parent then
                local p2 = item.PrimaryPart or item:FindFirstChild("Main") or item:FindFirstChildWhichIsA("BasePart")
                if p2 then
                    if not item.PrimaryPart then item.PrimaryPart = p2 end
                    local lockCF = p2.CFrame + Vector3.new(2,0,0)
                    lockPlayerAt(lockCF)
                    task.wait(0.5)
                end
                openItem(item)
                task.wait(0.4)
                unlockPlayer()
                notify("MOYAN HUB", string.format("已打开 %s（%d 号位）", evilHeathMaterials[i], i), 2)
            end
        end
        if waitEvilHeartAppear(10, preHeaths) then
            ok = true
            local newHeath = nil
            for _, m in pairs(ws.PlayerModels:GetChildren()) do
                if m:IsA("Model") and m.Name == "EvilHeart" and not preHeaths[m] then
                    newHeath = m
                    break
                end
            end
            if newHeath then
                local dp = newHeath.PrimaryPart or newHeath:FindFirstChild("Main") or newHeath:FindFirstChildWhichIsA("BasePart")
                if dp then
                    if not newHeath.PrimaryPart then newHeath.PrimaryPart = dp end
                    safeTeleport(dp.CFrame + Vector3.new(0,0.5,0))
                    dragToPosition(newHeath, originalPos, nil, true)
                    notify("MOYAN HUB", "新EvilHeart已拖回原位置", 3)
                end
            end
            break
        end
    end
    if ok then
        notify("MOYAN HUB", "EvilHeart 合成完成！", 3)
    else
        notify("MOYAN HUB", "EvilHeart 合成未完成（多次拖拽后仍未出现）", 3)
    end
    safeTeleport(originalPos)
    return ok
end

local function autoCombineEvilHeart()
    if evilHeathAutoRunning then
        notify("MOYAN HUB", "EvilHeart自动合成已在运行中", 3)
        return
    end
    evilHeathAutoRunning = true
    evilHeathStopFlag = false
    task.spawn(function()
        local baseHrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
        local basePos = baseHrp and baseHrp.CFrame
        local successCount = 0
        local total = evilHeathCount or 1
        for c = 1, total do
            if evilHeathStopFlag then break end
            notify("MOYAN HUB", string.format("=== 第 %d/%d 次 EvilHeart 合成 ===", c, total), 2)
            if startEvilHeartCombine(basePos) then
                successCount = successCount + 1
                notify("MOYAN HUB", string.format("第 %d 次 EvilHeart 合成完成", c), 2)
            else
                notify("MOYAN HUB", string.format("第 %d 次 EvilHeart 合成未完成", c), 3)
            end
            if basePos then safeTeleport(basePos) end
            task.wait(1)
        end
        evilHeathAutoRunning = false
        if basePos then safeTeleport(basePos) end
        notify("MOYAN HUB", string.format("EvilHeart 自动合成结束：成功 %d 次", successCount), 4)
    end)
end
local function stopEvilHeart()
    evilHeathStopFlag = true
    evilHeathAutoRunning = false
    notify("MOYAN HUB", "已发送停止信号", 3)
end
-- ====== 恶魔鸭提示翻译（誓言，改为 MOYAN 通知输出） ======
local function translateEvilDuckHints()
    local stoneRUs = ws:FindFirstChild("Stores") and ws.Stores:FindFirstChild("StoneRUs")
    if not stoneRUs then notify("MOYAN HUB", "未找到 StoneRUs", 3); return end
    local parts = stoneRUs:FindFirstChild("Parts")
    if not parts then notify("MOYAN HUB", "未找到 Parts", 3); return end
    local morse = {
        [".-"]="A",["-..."]="B",["-.-."]="C",["-.."]="D",["."]="E",["..-."]="F",["--."]="G",["...."]="H",
        [".."]="I",[".---"]="J",["-.-"]="K",[".-.."]="L",["--"]="M",["-."]="N",["---"]="O",[".--."]="P",
        ["--.-"]="Q",[".-."]="R",["..."]="S",["-"]="T",["..-"]="U",["...-"]="V",[".--"]="W",["-..-"]="X",
        ["-.--"]="Y",["--.."]="Z",["-----"]="0",[".----"]="1",["..---"]="2",["...--"]="3",
        ["....-"]="4",["....."]="5",["-...."]="6",["--..."]="7",["---.."]="8",["----."]="9",
    }
    local map = {
        ["I CANT SEE"]="老虎眼",["HATCHES INTO SOMETHING GREAT"]="蛋",["KEEP ME WARM"]="热可可",
        ["GRANT ME LIGHT"]="灯泡",["QUACK QUACK"]="鸭子",["GRANT MY WISH"]="神灯",
        ["GREAT WITH COOKIES"]="牛奶",["CHEAT CODE"]="游戏机",["GIVE ME POWER"]="电池",
        ["IM THIRSTY"]="BLOXY可乐",["CLAIMS TO BE HAPPY"]="快乐球",
    }
    local function translate(str)
        local words = {}
        for w in str:gmatch("[^/]+") do
            local letters = {}
            for l in w:gmatch("%S+") do letters[#letters+1] = morse[l] or "?" end
            words[#words+1] = table.concat(letters)
        end
        return table.concat(words, " ")
    end
    local found = false
    for i = 3, 1, -1 do
        local note = parts:FindFirstChild("Note"..i)
        if note then
            found = true
            local gui = note:FindFirstChildOfClass("SurfaceGui")
            local raw = ""
            if gui then
                for _, obj in pairs(gui:GetDescendants()) do
                    if obj:IsA("TextLabel") then raw = obj.Text; break end
                end
            end
            if raw ~= "" then
                local decoded = translate(raw)
                local meaning = map[decoded] or decoded
                notify("恶魔鸭提示", string.format("Note%d: %s", i, meaning), 4)
            else
                notify("恶魔鸭提示", string.format("Note%d: 内容为空", i), 2)
            end
        end
    end
    if not found then notify("MOYAN HUB", "StoneRUs 没有 Note 提示", 2) end
end

-- ====== 鸭子（誓言） ======
local duckTypeList = {
    {name="2018CGift_Duck", display="礼物鸭"},
    {name="Duck", display="🦆 普通鸭"},
    {name="DuckAngel", display="👼 天堂鸭"},
    {name="DuckEvil", display="😈 恶魔鸭"},
    {name="LunarDuck", display="🌙 月亮鸭"},
    {name="FallenDuck", display="💀 堕落鸭"},
}
local duckDisplayOptions = {}
for _, v in ipairs(duckTypeList) do table.insert(duckDisplayOptions, v.display) end
local selectedDuckName = duckTypeList[1].name
local batchDuckCount = 1
local duckBatchStop = false

local function bringDuckc(duckName, ownOnly, targetCF)
    local ducks = {}
    for _, m in pairs(ws.PlayerModels:GetChildren()) do
        if m:IsA("Model") and m.Name == duckName then
            local o = m:FindFirstChild("Owner")
            if (ownOnly and o and o.Value == lp) or (not ownOnly and (not o or o.Value == nil)) then table.insert(ducks, m) end
        end
    end
    if #ducks == 0 then return false end
    local d = ducks[1]
    local targetPos = targetCF or (lp.Character and lp.Character.HumanoidRootPart.CFrame)
    if not targetPos then return false end
    local primary = d.PrimaryPart or d:FindFirstChild("Main") or d:FindFirstChildWhichIsA("BasePart")
    if not primary then return false end
    if not d.PrimaryPart then d.PrimaryPart = primary end

    pcall(function() safeTeleport(primary.CFrame + Vector3.new(0,2,0)) end)
    task.wait(0.1)
    dragToPosition(d, targetPos)
    return true
end

local function bringDucksBatch(ownOnly)
    local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    local startCF = hrp and hrp.CFrame
    task.spawn(function()
        for i = 1, (batchDuckCount == 0 and 9999 or batchDuckCount) do
            if duckBatchStop then break end
            if not bringDuckc(selectedDuckName, ownOnly, startCF) then break end
            task.wait(0.1)
        end
        if startCF then safeTeleport(startCF) end
        notify("MOYAN HUB", "完成", 2)
    end)
end
local function stopDuckBatch()
    duckBatchStop = true
    notify("MOYAN HUB", "已停止", 2)
end
local function runAngelDuckSequence()
    local char = lp.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local oldCF = hrp.CFrame
    safeTeleport(CFrame.new(184, 12, -2666))
    task.wait(0.2)
    local ok, controller = pcall(function()
        return ws:WaitForChild("Stores"):WaitForChild("PlantomicsChoice"):WaitForChild("Parts"):WaitForChild("Controller"):WaitForChild("yes")
    end)
    if not ok or not controller then notify("MOYAN HUB", "找不到控制器", 3); safeTeleport(oldCF); return end
    local seq = {"Up","Up","Down","Down","Left","Right","Left","Right","B","A","Start"}
    for _, name in ipairs(seq) do
        local part = controller:FindFirstChild(name)
        if part then
            local click = part:FindFirstChildOfClass("ClickDetector")
            if click then fireclickdetector(click, 1); task.wait(0.2) end
        end
    end
    safeTeleport(oldCF)
    notify("MOYAN HUB", "序列完成", 3)
end

local function ensurePart(m)
    if not m.PrimaryPart then
        local p = m:FindFirstChild("Main") or m:FindFirstChildWhichIsA("BasePart")
        if p then m.PrimaryPart = p else return false end
    end
    return true
end

local function synthesizeRevengeSword()
    local evil, angel
    for _, m in pairs(ws.PlayerModels:GetChildren()) do
        if m:IsA("Model") and m:FindFirstChild("Owner") and m.Owner.Value == lp then
            if m.Name == "DuckEvil" then evil = m
            elseif m.Name == "DuckAngel" then angel = m end
        end
    end
    if not evil or not angel then notify("MOYAN HUB", "缺少恶魔鸭或天堂鸭", 3); return end
    if not ensurePart(evil) or not ensurePart(angel) then return end
    safeTeleport(evil.PrimaryPart.CFrame + Vector3.new(0,2,0))
    task.wait(0.1)
    dragToPosition(evil, CFrame.new(6486,-89,-4551))
    task.wait(0.1)
    safeTeleport(angel.PrimaryPart.CFrame + Vector3.new(0,2,0))
    task.wait(0.1)
    dragToPosition(angel, CFrame.new(6447,-90,-4523))
    safeTeleport(CFrame.new(6466,-95,-4546))
    notify("MOYAN HUB", "复仇剑合成位置已就绪", 3)
end

local function synthesizeLunarDuck()
    local evil, angel, normal
    for _, m in pairs(ws.PlayerModels:GetChildren()) do
        if m:IsA("Model") and m:FindFirstChild("Owner") and m.Owner.Value == lp then
            if m.Name == "DuckEvil" then evil = m
            elseif m.Name == "DuckAngel" then angel = m
            elseif m.Name == "Duck" then normal = m end
        end
    end
    if not evil or not angel or not normal then notify("MOYAN HUB", "缺少所需鸭子", 3); return end
    if not ensurePart(evil) or not ensurePart(angel) or not ensurePart(normal) then return end
    safeTeleport(evil.PrimaryPart.CFrame + Vector3.new(0,2,0)); task.wait(0.1)
    dragToPosition(evil, CFrame.new(-7092.01,391,4890.51)); task.wait(0.1)
    safeTeleport(normal.PrimaryPart.CFrame + Vector3.new(0,2,0)); task.wait(0.1)
    dragToPosition(normal, CFrame.new(-7066.70,391,4898.07)); task.wait(0.1)
    safeTeleport(angel.PrimaryPart.CFrame + Vector3.new(0,2,0)); task.wait(0.1)
    dragToPosition(angel, CFrame.new(-7041.83,391,4906.09))
    safeTeleport(CFrame.new(-7059,390,4881))
    notify("MOYAN HUB", "月亮鸭合成位置已就绪", 3)
end
-- ====== 购买（誓言） ======
-- ====== 本地兜底汉化表 ======
local LOCAL_STORE_CN = {
    AutumnCatalog="秋季商店", BlackMarket="黑市", CarStore="车店", MusicStore="音乐店",
    FineArt="画店", FineFinds="精品店", FurnitureStore="家具店", HLStand="HL小摊",
    Igloo="冰屋", LogicStore="逻辑店", MountainSide="山边商品", PlanterStore="花盆商店",
    PlantomicsChoice="植物商店", SallysSeasonal="季节商店", SaplingCart="树苗车",
    SeaSide="海边商店", StoneRUs="石头商店", TravelingTrader="旅行商人",
    VIPSHOP="VIP商店", WoodRUs="木材商店",
}
local LOCAL_ITEM_CN = {
    ["Plank"]="木板", ["Wood"]="木头", ["Sapling"]="树苗",
    ["Axe"]="斧头", ["Blueprint"]="蓝图",
    ["OlReliable"]="老可靠斧", ["OIReliable"]="老可靠斧", ["BasicAxe"]="基础斧",
    ["SteelAxe"]="钢斧", ["BetaAxe"]="测试斧",
    ["Axe_Basic"]="基础斧", ["Axe_Steel"]="钢斧", ["Axe_Golden"]="黄金斧",
    ["Axe_Candy"]="糖果斧", ["Axe_End"]="终极斧", ["Axe_Fire"]="火焰斧",
    ["Truck"]="卡车", ["Car"]="汽车", ["Scooter"]="滑板车", ["Bike"]="自行车",
    ["Jeep"]="吉普车", ["SportsCar"]="跑车", ["RaceCar"]="赛车", ["Pickup"]="皮卡",
    ["Van"]="面包车", ["Bus"]="公交车", ["Train"]="火车",
    ["Chair"]="椅子", ["Table"]="桌子", ["Lamp"]="灯", ["Bed"]="床",
    ["Sofa"]="沙发", ["Desk"]="书桌", ["Shelf"]="架子", ["Carpet"]="地毯",
    ["Painting"]="画作", ["Mirror"]="镜子", ["Clock"]="时钟", ["Rug"]="小地毯",
    ["Fence"]="栅栏", ["Door"]="门", ["Window"]="窗户", ["Chest"]="箱子",
    ["Sign"]="告示牌", ["Statue"]="雕像", ["Plant"]="盆栽", ["Flower"]="花",
    ["Fireplace"]="壁炉", ["Counter"]="柜台", ["RugLarge"]="大地毯",
    ["Crate"]="板条箱", ["Box"]="盒子", ["Gift"]="礼物", ["Present"]="礼盒",
    ["MysteryBox"]="神秘盒子", ["LuckyBox"]="幸运盒",
    ["Bucket"]="水桶", ["Ladder"]="梯子", ["Torch"]="火把", ["Lantern"]="灯笼",
    ["Hat"]="帽子", ["Shirt"]="衬衫", ["Pants"]="裤子", ["Backpack"]="背包",
    ["BackpackSmall"]="小背包", ["Sword"]="剑", ["Shield"]="盾牌",
    ["Duck"]="普通鸭", ["DuckEvil"]="恶魔鸭", ["DuckAngel"]="天堂鸭",
    ["LunarDuck"]="月亮鸭", ["FallenDuck"]="堕落鸭", ["2018CGift_Duck"]="礼物鸭",
    ["RevengeSword"]="复仇剑", ["HeavenSword"]="天堂剑", ["MoonSword"]="月亮剑",
    ["HellSword"]="地狱剑", ["DoomSword"]="厄运剑", ["Trident"]="三叉戟",
    ["EvilHeart"]="恶魔之心", ["HappyBall"]="快乐球", ["Egg"]="蛋",
    ["Cocoa"]="热可可", ["Eye3"]="老虎眼", ["LightBulb"]="灯泡",
    ["MagicLamp"]="神灯", ["Milk"]="牛奶", ["NESController"]="游戏机",
    ["Battery"]="电池", ["BloxyCola"]="BLOXY可乐",
}

local translateMapping = {}
local function loadStoreTranslations()
    pcall(function()
        local content = game:HttpGet("http://qinscript.lol/333/翻译商店.lua")
        local func = load(content, "oath_store_trans", "t")
        if func then
            local ok, m = pcall(func)
            if ok and type(m) == "table" then
                for k, v in pairs(m) do translateMapping[k] = v end
            end
        end
    end)
end
local function getStoreDisplayName(en)
    local cn = translateMapping[en] or LOCAL_STORE_CN[en]
    if cn and cn ~= "" then return cn.." ("..en..")" end
    return en
end
local function getDisplayName(en)
    local cn = translateMapping[en] or LOCAL_ITEM_CN[en]
    if not cn then
        local treeKey = tostring(en):match("^Sapling_(.+)$")
        if treeKey and TREE_CN[treeKey] then cn = TREE_CN[treeKey].."树苗" end
    end
    if not cn then
        local treeKey = tostring(en):match("^Sapling(.+)$")
        if treeKey and TREE_CN[treeKey] then cn = TREE_CN[treeKey].."树苗" end
    end
    if cn and cn ~= "" then return cn.." ("..en..")" end
    return en
end
loadStoreTranslations()
-- ====== 商店信息映射 ======
local storeInfoMapping = {
    AutumnCatalog={name="William", path="William"},
    BlackMarket={name="sneakypotato7", path="sneakypotato7"},
    CarStore={name="Jenny", path="Jenny"},
    MusicStore={name="NazuReborn", path="NazuReborn"},
    FineArt={name="Timothy", path="Timothy"},
    FineFinds={name="Manachron", path="Manachron"},
    FurnitureStore={name="Corey", path="Corey"},
    HLStand={name="???", path="???"},
    Igloo={name="Cold Guy", path="Cold Guy"},
    LogicStore={name="Lincoln", path="Lincoln"},
    MountainSide={name="Mr.Bacon", path="Mr.Bacon"},
    PlanterStore={name="OGxOutcast", path="OGxOutcast"},
    PlantomicsChoice={name="Null", path="Null"},
    SallysSeasonal={name="Sally", path="Sally"},
    SaplingCart={name="Billy", path="Billy"},
    SeaSide={name="Guy", path="Guy"},
    StoneRUs={name="Bloxyway", path="Bloxyway"},
    TravelingTrader={name="Trader", path="Trader"},
    VIPSHOP={name="Todd", path="Todd"},
    WoodRUs={name="Thom", path="Thom"},
}
local npcMapping = {}
for storeName, info in pairs(storeInfoMapping) do
    npcMapping[storeName] = {name=info.name, id=nil, path=info.path}
end
local stopPurchaseFlag = false
local purchaseBusy = false

local function GetAllCashierIds()
    local cashierIds = {}
    local npcDialog = rep:FindFirstChild("NPCDialog")
    if not npcDialog then return cashierIds end
    local promptChat = npcDialog:FindFirstChild("PromptChat")
    if not promptChat then return cashierIds end
    local setChattingValue = npcDialog:FindFirstChild("SetChattingValue")
    local receivedCount = 0
    local totalExpected = 0
    for _ in pairs(storeInfoMapping) do totalExpected = totalExpected + 1 end
    local conn = promptChat.OnClientEvent:Connect(function(...)
        local pack = {...}
        for _, v in ipairs(pack) do
            if type(v) == "table" and v.Name and v.ID then
                if not cashierIds[v.Name] then cashierIds[v.Name] = v.ID; receivedCount = receivedCount + 1 end
            end
        end
    end)
    pcall(function() if setChattingValue then setChattingValue:InvokeServer(1) end end)
    local startTime = tick()
    while receivedCount < totalExpected and tick() - startTime < 20 do task.wait(0.2) end
    conn:Disconnect()
    pcall(function() if setChattingValue then setChattingValue:InvokeServer(0) end end)
    return cashierIds
end

task.spawn(function()
    local ids = GetAllCashierIds()
    for storeName, info in pairs(storeInfoMapping) do
        if ids[info.name] then npcMapping[storeName].id = ids[info.name] end
    end
    local okCount = 0
    for _, info in pairs(npcMapping) do if info.id then okCount = okCount + 1 end end
    notify("MOYAN HUB", string.format("已获取 %d 个商店NPC ID", okCount), 2)
end)
local allStores = {}
task.spawn(function()
    local StoresFolder = workspace:WaitForChild("Stores")
    task.wait(2)
    for _, store in pairs(StoresFolder:GetChildren()) do
        local shopItems = store:FindFirstChild("ShopItems")
        if shopItems and #shopItems:GetChildren() > 0 then
            local storeName = store.Name
            local npcInfo = npcMapping[storeName]
            if npcInfo then
                local isMusic = (storeName == "MusicStore")
                table.insert(allStores, {
                    name = storeName, object = store, shopItems = shopItems,
                    npc = npcInfo, isMusicStore = isMusic,
                })
            end
        end
    end
    table.sort(allStores, function(a, b) return a.name < b.name end)
    notify("MOYAN HUB", string.format("已扫描 %d 个商店", #allStores), 2)
end)

local function purchaseCycle(storeInfo, selectedItemName, buyAmount, itemCD)
    if purchaseBusy then
        notify("MOYAN HUB", "购买正在进行中，请稍候", 2)
        return false
    end
    purchaseBusy = true
    stopPurchaseFlag = false

    local ok, err = pcall(function()
        local store = storeInfo.object
        local shopItems = storeInfo.shopItems
        local npcInfo = storeInfo.npc
        if not npcInfo or not npcInfo.id then notify("MOYAN HUB", "NPC ID 无效", 4); return end
        local npcChar = store:FindFirstChild(npcInfo.path)
        if not npcChar then notify("MOYAN HUB", "找不到NPC", 3); return end
        local counter = store:FindFirstChild("Counter")
        if not counter or not counter:IsA("BasePart") then notify("MOYAN HUB", "无Counter", 3); return end
        local NPCDialog = rep:WaitForChild("NPCDialog")

        local hrp0 = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
        if not hrp0 then notify("MOYAN HUB", "无法获取玩家位置", 3); return end
        local originalPos = hrp0.CFrame

        local preOwned = {}
        for _, m in pairs(workspace.PlayerModels:GetChildren()) do preOwned[m] = true end

        local function sendPurchaseAndWait(timeout)
            timeout = timeout or 1.5
            local purchasedItems = {}
            local conn = workspace.PlayerModels.ChildAdded:Connect(function(model)
                if model:IsA("Model") and not preOwned[model] then
                    local o = model:FindFirstChild("Owner")
                    if o and o.Value == lp then
                        preOwned[model] = true
                        table.insert(purchasedItems, model)
                    end
                end
            end)
            local args = {{ID=npcInfo.id, Character=npcChar, Name=npcInfo.name}, "ConfirmPurchase"}
            pcall(function() NPCDialog.PlayerChatted:InvokeServer(table.unpack(args)) end)
            local deadline = tick() + timeout
            while tick() < deadline do
                if #purchasedItems > 0 then break end
                task.wait(0.05)
            end
            conn:Disconnect()
            return purchasedItems
        end

        local function findItemByCD(cdValue)
            for _, child in pairs(shopItems:GetChildren()) do
                local s = child:FindFirstChild("Settings")
                if s then
                    local cd = s:FindFirstChild("CD")
                    if cd and cd:IsA("StringValue") and cd.Value == cdValue then return child end
                end
            end
            return nil
        end
        local successCycles = 0
        for i = 1, buyAmount do
            if stopPurchaseFlag then break end
            local itemModel
            if itemCD then
                itemModel = findItemByCD(itemCD)
                if not itemModel then
                    local deadline = tick() + 15
                    while tick() < deadline and not itemModel do
                        if stopPurchaseFlag then break end
                        task.wait(0.2)
                        itemModel = findItemByCD(itemCD)
                    end
                end
            else
                itemModel = shopItems:FindFirstChild(selectedItemName)
                if not itemModel then
                    local deadline = tick() + 15
                    while tick() < deadline and not itemModel do
                        if stopPurchaseFlag then break end
                        task.wait(0.2)
                        itemModel = shopItems:FindFirstChild(selectedItemName)
                    end
                end
            end
            if not itemModel then notify("MOYAN HUB", "商品不在货架", 3); break end

            local itemPrimary = itemModel.PrimaryPart or itemModel:FindFirstChild("WoodSection") or itemModel:FindFirstChild("Main") or itemModel:FindFirstChildWhichIsA("BasePart")
            if not itemPrimary then break end
            if not itemModel.PrimaryPart then itemModel.PrimaryPart = itemPrimary end

            lockPlayerAt(itemPrimary.CFrame + Vector3.new(0,3,0))
            task.wait(0.2)
            dragToPosition(itemModel, counter.CFrame + Vector3.new(0,0.6,0), nil, true)

            lockPlayerAt(counter.CFrame + Vector3.new(0,3,0))
            task.wait(0.15)

            local gotItems = sendPurchaseAndWait(1.5)
            if #gotItems == 0 and not stopPurchaseFlag then
                task.wait(0.3)
                local retryItems = sendPurchaseAndWait(1.5)
                for _, m in ipairs(retryItems) do table.insert(gotItems, m) end
            end

            if #gotItems > 0 then
                for _, item in ipairs(gotItems) do
                    if item and item.Parent then
                        if not item.PrimaryPart then
                            local part = item:FindFirstChild("Main") or item:FindFirstChild("WoodSection") or item:FindFirstChildWhichIsA("BasePart")
                            if part then item.PrimaryPart = part end
                        end
                        if item.PrimaryPart then
                            dragToPosition(item, originalPos, nil, true)
                        end
                        task.wait(0.05)
                    end
                end
                successCycles = successCycles + 1
            else
                notify("MOYAN HUB", "本次未成功买到，跳过", 2)
            end

            if i < buyAmount and not stopPurchaseFlag then task.wait(0.5) end
        end

        unlockPlayer()
        task.wait(0.1)
        safeTeleport(originalPos)
        if stopPurchaseFlag then
            notify("MOYAN HUB", "购买已中断", 3)
        else
            notify(storeInfo.name, string.format("完成 %d/%d 次", successCycles, buyAmount), 4)
        end
    end)

    if not ok then
        warn("[MOYAN HUB] purchaseCycle 出错: " .. tostring(err))
        unlockPlayer()
    end
    purchaseBusy = false
    stopPurchaseFlag = false
end
_G.qSnowBuyBlueprintBox = function(blueprintName)
    if stopPurchaseFlag then return nil, "已停止" end
    local targetStore, targetItemName = nil, nil
    local lower = string.lower(tostring(blueprintName))
    for _, s in ipairs(allStores) do
        if s.shopItems then
            for _, item in pairs(s.shopItems:GetChildren()) do
                if string.lower(tostring(item.Name)) == lower then targetStore, targetItemName = s, item.Name; break end
            end
        end
        if targetStore then break end
    end
    if not targetStore then return nil, "没有任何商店出售: "..tostring(blueprintName) end
    if not targetStore.npc or not targetStore.npc.id then return nil, "NPC ID 未获取" end
    local store = targetStore.object
    local npcInfo = targetStore.npc
    local npcChar = store:FindFirstChild(npcInfo.path)
    if not npcChar then return nil, "找不到NPC" end
    local counter = store:FindFirstChild("Counter")
    if not counter or not counter:IsA("BasePart") then return nil, "无Counter" end
    local shopItems = store:FindFirstChild("ShopItems")
    if not shopItems then return nil, "无 ShopItems" end
    local itemModel = shopItems:FindFirstChild(targetItemName)
    if not itemModel then return nil, "商品不在货架" end
    local primary = itemModel.PrimaryPart or itemModel:FindFirstChild("WoodSection") or itemModel:FindFirstChild("Main") or itemModel:FindFirstChildWhichIsA("BasePart")
    if not primary then return nil, "无法定位商品模型" end
    if not itemModel.PrimaryPart then itemModel.PrimaryPart = primary end

    local preOwned = {}
    for _, m in pairs(workspace.PlayerModels:GetChildren()) do preOwned[m] = true end

    lockPlayerAt(primary.CFrame + Vector3.new(0,3,0))
    task.wait(0.3)
    dragToPosition(itemModel, counter.CFrame + Vector3.new(0,0.6,0), nil, true)
    task.wait(0.09)
    lockPlayerAt(counter.CFrame + Vector3.new(0,3,0))
    task.wait(0.1)

    local got = nil
    local conn = workspace.PlayerModels.ChildAdded:Connect(function(m)
        if m:IsA("Model") and not preOwned[m] then
            local o = m:FindFirstChild("Owner")
            if o and o.Value == lp then
                preOwned[m] = true
                if not got then got = m end
            end
        end
    end)
    local NPCDialog = rep:WaitForChild("NPCDialog")
    local args = {{ID=npcInfo.id, Character=npcChar, Name=npcInfo.name}, "ConfirmPurchase"}
    pcall(function() NPCDialog.PlayerChatted:InvokeServer(table.unpack(args)) end)
    task.wait(0.15)
    if not got then
        pcall(function() NPCDialog.PlayerChatted:InvokeServer(table.unpack(args)) end)
    end
    local deadline = tick() + 2
    while tick() < deadline and not got do task.wait(0.05) end
    conn:Disconnect()
    unlockPlayer()
    if got then return got, targetStore.name end
    return nil, "购买后未找到新盒子"
end

-- ====== 快捷操作（誓言） ======
local function refreshStoreIds()
    notify("MOYAN HUB", "正在刷新商店 NPC ID...", 2)
    task.spawn(function()
        local ids = GetAllCashierIds()
        local gained = 0
        for storeName, info in pairs(storeInfoMapping) do
            if ids[info.name] then
                if npcMapping[storeName].id ~= ids[info.name] then
                    npcMapping[storeName].id = ids[info.name]
                    gained = gained + 1
                end
            end
        end
        local okCount = 0
        for _, info in pairs(npcMapping) do if info.id then okCount = okCount + 1 end end
        notify("MOYAN HUB", string.format("刷新完成，新增 %d 个，当前 %d 个", gained, okCount), 3)
    end)
end
local function buyAllBlueprints()
    task.spawn(function()
        stopPurchaseFlag = false
        local blueprintFolder = lp:FindFirstChild("PlayerBlueprints") and lp.PlayerBlueprints:FindFirstChild("Blueprints")
        local targets, seen = {}, {}
        for _, store in ipairs(allStores) do
            if store.shopItems then
                for _, item in pairs(store.shopItems:GetChildren()) do
                    local typeVal = item:FindFirstChild("Type")
                    local tstr = (typeVal and typeVal.Value ~= nil) and tostring(typeVal.Value) or ""
                    if tstr == "Blueprint" then
                        local nm = tostring(item.Name)
                        if nm ~= "" and not seen[nm] then
                            seen[nm] = true
                            if not (blueprintFolder and blueprintFolder:FindFirstChild(nm)) then targets[#targets+1] = nm end
                        end
                    end
                end
            end
        end
        table.sort(targets)
        if #targets == 0 then notify("MOYAN HUB", "已拥有全部蓝图", 3); return end
        notify("MOYAN HUB", string.format("还缺 %d 种蓝图", #targets), 4)
        local bought, stillMissing = 0, {}
        for _, nm in ipairs(targets) do
            if stopPurchaseFlag then break end
            local box = _G.qSnowBuyBlueprintBox(nm)
            if not box then table.insert(stillMissing, nm)
            else
                local deadline = tick() + 5
                while tick() < deadline and not (blueprintFolder and blueprintFolder:FindFirstChild(nm)) do
                    task.wait(0.3)
                    if stopPurchaseFlag then break end
                end
                if blueprintFolder and blueprintFolder:FindFirstChild(nm) then bought = bought + 1
                else table.insert(stillMissing, nm) end
            end
            task.wait(0.2)
        end
        if #stillMissing > 0 then
            pcall(function() setclipboard(table.concat(stillMissing, "\n")) end)
            notify("MOYAN HUB", string.format("新增 %d，仍缺 %d（已复制剪贴板）", bought, #stillMissing), 6)
        else
            notify("MOYAN HUB", string.format("购买完成，新增 %d", bought), 5)
        end
    end)
end
-- ============================================================
-- UI 构建（MOYAN / Obsidian）
-- ============================================================

local selectedTreeClass = nil
local batchCount = 1
local isBringRunning = false

-- ====== 功能 · 带来树 ======
local bringGroup = Tabs.Features:AddLeftGroupbox("带来树", "tree-deciduous")
local treeOpts = { "--- 请选择树木 ---" }
for _, n in ipairs(treeNames) do table.insert(treeOpts, n) end
bringGroup:AddDropdown("TreeClass", {
    Text = "选择树木种类",
    Values = treeOpts,
    Default = "--- 请选择树木 ---",
    Searchable = true,
    Callback = function(v)
        if v == "--- 请选择树木 ---" then selectedTreeClass = nil
        else selectedTreeClass = treeMapping[v] end
    end,
})
bringGroup:AddDropdown("CutPlan", {
    Text = "选择砍树方案",
    Values = {"旧版本（主脚本.txt）", "新版本（源码.lua）"},
    Default = "旧版本（主脚本.txt）",
    Callback = function(v)
        selectedPlan = (v == "新版本（源码.lua）") and 2 or 1
    end,
})
bringGroup:AddInput("BringCount", {
    Text = "数量",
    Default = "1",
    Numeric = true,
    Callback = function(v)
        local n = tonumber(v)
        if n and n > 0 then batchCount = math.floor(n) end
    end,
})
bringGroup:AddButton({
    Text = "带来树",
    Func = function()
        if isBringRunning then notify("MOYAN HUB", "任务运行中", 2); return end
        if not selectedTreeClass then notify("MOYAN HUB", "请先选树木", 3); return end
        isBringRunning = true
        task.spawn(function()
            local total = batchCount; local s = 0
            for i = 1, total do
                if not isBringRunning then break end
                local pt = string.format("%d/%d", i, total)
                notify("MOYAN HUB", "正在带来树 " .. pt, 2)
                if runBringTree(selectedTreeClass, pt) then s = s + 1
                else notify("MOYAN HUB", "第 " .. pt .. " 次失败", 3); break end
            end
            isBringRunning = false
            if total > 1 and s > 0 then notify("MOYAN HUB", "完成 " .. s .. "/" .. total, 3) end
        end)
    end,
})
bringGroup:AddButton({
    Text = "停止带来树",
    Func = function() isBringRunning = false end,
})

-- ====== 功能 · 一键加工 ======
local processGroup = Tabs.Features:AddRightGroupbox("一键加工", "axe")
processGroup:AddButton({
    Text = "选择锯木机",
    Func = selectSawmill,
})
processGroup:AddButton({
    Text = "一键加工",
    Func = startDecomposeSelection,
})
-- ====== 功能 · 传送物品 ======
local tpGroup = Tabs.Features:AddLeftGroupbox("传送物品", "user")
local pOpts = {}
for _, p in ipairs(Players:GetPlayers()) do table.insert(pOpts, p.Name) end
if #pOpts == 0 then pOpts = {lp.Name} end
local playerDD = tpGroup:AddDropdown("TeleportPlayer", {
    Text = "选择玩家",
    Values = pOpts,
    Default = lp.Name,
    Callback = function(v)
        teleportTargetPlayer = v
        clearSelection()
    end,
})
tpGroup:AddButton({
    Text = "刷新玩家列表",
    Func = function()
        local list = {}
        for _, p in ipairs(Players:GetPlayers()) do table.insert(list, p.Name) end
        if #list == 0 then list = {lp.Name} end
        local cur = teleportTargetPlayer
        local found = false
        for _, n in ipairs(list) do if n == cur then found = true; break end end
        if not found then cur = lp.Name end
        playerDD:SetValues(list)
        playerDD:SetValue(cur)
        teleportTargetPlayer = cur
        notify("MOYAN HUB", "玩家列表已刷新（" .. #list .. " 人）", 2)
    end,
})
tpGroup:AddButton({ Text = "设置传送点", Func = setTeleportPoint })
tpGroup:AddButton({ Text = "删除传送点", Func = clearTeleportPoint })
tpGroup:AddButton({
    Text = "传送所有选中",
    Func = function()
        if not teleportTargetCF then notify("MOYAN HUB", "请先设置传送点", 3); return end
        task.spawn(teleportSelectedItems)
    end,
})
tpGroup:AddButton({ Text = "清空所有选中", Func = clearSelection })
tpGroup:AddToggle("SelectMode", {
    Text = "选择模式开关",
    Default = false,
    Callback = function(s)
        selectingMode = s
        if s then
            if selectionConn then selectionConn:Disconnect() end
            selectionConn = mouse.Button1Down:Connect(function()
                if not selectingMode then return end
                local target = mouse.Target; if not target then return end
                local m = target:FindFirstAncestorOfClass("Model"); if not m then return end
                if not isSelectable(m) then return end
                selectItem(m)
            end)
        else
            if selectionConn then selectionConn:Disconnect(); selectionConn = nil end
        end
    end,
})
tpGroup:AddToggle("SameNameMode", {
    Text = "同名选择开关",
    Default = false,
    Callback = function(s)
        sameNameEnabled = s
        if s then
            if sameNameConn then sameNameConn:Disconnect() end
            sameNameConn = mouse.Button1Down:Connect(function()
                if not sameNameEnabled then return end
                local target = mouse.Target; if not target then return end
                local m = target:FindFirstAncestorOfClass("Model"); if not m then return end
                if not isSelectable(m) then return end
                if selectedItems[m] then cancelSameNameItems(m) else selectSameNameItems(m) end
            end)
        else
            if sameNameConn then sameNameConn:Disconnect(); sameNameConn = nil end
        end
    end,
})
-- ====== 传送 · 传送地点 ======
local tpLocGroup = Tabs.Teleports:AddLeftGroupbox("传送地点", "map-pin")
local teleportLocations = {
    "出生点","木材反斗城","回家","连接逻辑店","土地商店","会员商店","画店",
    "桥对岸","沙滩","火木","雪山","洞穴","码头","黑市","糖果原","雪地入口",
    "盖克斯航运","玻璃冰木入口","云层","山边商品","章鱼哥祭坛","沼泽商店",
    "石头商店","沼泽","冰胡","沙漠","辐射商店","核污染区","种子商人",
    "鲍勃的店","家具店","车店","罗布克斯商店","肯德坤专卖店","秋季商店",
    "三叉戟","月亮剑","月亮鸭","天堂剑光环","天堂剑祭坛","地狱火祭坛","厄运祭坛","厄运光环"
}
tpLocGroup:AddDropdown("LocSelect", {
    Text = "选择地点",
    Values = teleportLocations,
    Default = "出生点",
    Searchable = true,
    Callback = function(v)
        local map = {
            ["出生点"] = CFrame.new(187,3,55),
            ["木材反斗城"] = CFrame.new(265,5,57),
            ["洞穴"] = CFrame.new(3581,-177,430),
            ["连接逻辑店"] = CFrame.new(4607,9,-798),
            ["雪山"] = CFrame.new(1451.66248,412.208405,3183.47607),
            ["土地商店"] = CFrame.new(258,5,-99),
            ["画店"] = CFrame.new(5207,-156,719),
            ["火木"] = CFrame.new(-1585,625,1140),
            ["沙滩"] = CFrame.new(2549,5,-42),
            ["桥对岸"] = CFrame.new(109,5,-1166),
            ["会员商店"] = CFrame.new(907,4,-92),
            ["码头"] = CFrame.new(1122,1,-203),
            ["黑市"] = CFrame.new(-22,61,1377),
            ["糖果原"] = CFrame.new(-561,272,2312),
            ["雪地入口"] = CFrame.new(888,61,1188),
            ["盖克斯航运"] = CFrame.new(1894,-2,1581),
            ["玻璃冰木入口"] = CFrame.new(1929,256,2918),
            ["云层"] = CFrame.new(2073,495,2967),
            ["山边商品"] = CFrame.new(-640,160,374),
            ["章鱼哥祭坛"] = CFrame.new(-1622,196,941),
            ["沼泽商店"] = CFrame.new(-1274,133,-1443),
            ["沼泽"] = CFrame.new(-999,133,-1191),
            ["石头商店"] = CFrame.new(-2387,302,-1899),
            ["冰胡"] = CFrame.new(-2149,321,743),
            ["沙漠"] = CFrame.new(-612,46,-3169),
            ["辐射商店"] = CFrame.new(172,12,-2627),
            ["核污染区"] = CFrame.new(207,15,-2752),
            ["种子商人"] = CFrame.new(-24,18,-2684),
            ["鲍勃的店"] = CFrame.new(261,9,-2541),
            ["家具店"] = CFrame.new(492,4,-1723),
            ["车店"] = CFrame.new(512,4,-1459),
            ["罗布克斯商店"] = CFrame.new(652,4,-1589),
            ["肯德坤专卖店"] = CFrame.new(65,4,-455),
            ["秋季商店"] = CFrame.new(6004,4,33),
            ["三叉戟"] = CFrame.new(-375,14,-1331),
            ["月亮剑"] = CFrame.new(-7642,326,4225),
            ["月亮鸭"] = CFrame.new(-7065,394,4893),
            ["天堂剑光环"] = CFrame.new(-657,25,-385),
            ["天堂剑祭坛"] = CFrame.new(1658,408,3278),
            ["地狱火祭坛"] = CFrame.new(-1784,342,1473),
            ["厄运祭坛"] = CFrame.new(-1499,-248,289),
            ["厄运光环"] = CFrame.new(-1282,23,-86),
        }
        local cf = map[v]
        if v == "回家" then
            for _, prop in pairs(workspace.Properties:GetChildren()) do
                if prop.Owner.Value == lp then cf = prop.OriginSquare.CFrame + Vector3.new(0,10,0); break end
            end
        end
        if cf then tp(cf) end
    end,
})
-- ====== 传送 · 汽车传送 ======
local carGroup = Tabs.Teleports:AddRightGroupbox("汽车传送", "car")
local carTeleportLocations = {
    "回家","连接逻辑店","土地商店","会员商店","画店",
    "桥对岸","沙滩","火木","雪山","洞穴","码头","黑市","糖果原","雪地入口",
    "盖克斯航运","玻璃冰木入口","云层","山边商品","章鱼哥祭坛","沼泽商店",
    "石头商店","沼泽","冰胡","星星岛","辐射商店","核污染区","种子商人",
    "鲍勃的店","家具店","车店","罗布克斯商店","肯德坤专卖店","秋季商店"
}
carGroup:AddDropdown("CarLocSelect", {
    Text = "选择地点（需坐在车上）",
    Values = carTeleportLocations,
    Default = "回家",
    Searchable = true,
    Callback = function(v)
        local map = {
            ["连接逻辑店"] = CFrame.new(4607,9,-740),
            ["土地商店"] = CFrame.new(230,5,-99),
            ["会员商店"] = CFrame.new(907,4,-115),
            ["画店"] = CFrame.new(5207,-156,719),
            ["桥对岸"] = CFrame.new(109,5,-1166),
            ["沙滩"] = CFrame.new(2549,5,-42),
            ["火木"] = CFrame.new(-1585,625,1140),
            ["雪山"] = CFrame.new(1451.66248,412.208405,3183.47607),
            ["洞穴"] = CFrame.new(3581,-177,430),
            ["码头"] = CFrame.new(1122,1,-203),
            ["黑市"] = CFrame.new(-15,61,1365),
            ["糖果原"] = CFrame.new(-561,272,2312),
            ["雪地入口"] = CFrame.new(888,61,1188),
            ["盖克斯航运"] = CFrame.new(1894,-2,1581),
            ["玻璃冰木入口"] = CFrame.new(1929,256,2918),
            ["云层"] = CFrame.new(2060,495,2967),
            ["山边商品"] = CFrame.new(-640,160,374),
            ["章鱼哥祭坛"] = CFrame.new(-1622,196,941),
            ["沼泽商店"] = CFrame.new(-1274,133,-1443),
            ["石头商店"] = CFrame.new(-2395,302,-1899),
            ["沼泽"] = CFrame.new(-999,133,-1191),
            ["冰胡"] = CFrame.new(-2149,321,743),
            ["星星岛"] = CFrame.new(-612,46,-3169),
            ["辐射商店"] = CFrame.new(172,12,-2627),
            ["核污染区"] = CFrame.new(207,15,-2752),
            ["种子商人"] = CFrame.new(-15,18,-2680),
            ["鲍勃的店"] = CFrame.new(245,9,-2541),
            ["家具店"] = CFrame.new(490,4,-1690),
            ["车店"] = CFrame.new(512,4,-1490),
            ["罗布克斯商店"] = CFrame.new(652,4,-1565),
            ["肯德坤专卖店"] = CFrame.new(100,4,-455),
            ["秋季商店"] = CFrame.new(6004,4,33),
        }
        local cf = map[v]
        if v == "回家" then
            for _, prop in pairs(workspace.Properties:GetChildren()) do
                if prop.Owner.Value == lp then cf = prop.OriginSquare.CFrame + Vector3.new(0,10,0); break end
            end
        end
        if cf then carTeleport(cf) end
    end,
})
-- ====== 合成 · 恶魔鸭合成 ======
local evilGroup = Tabs.Craft:AddLeftGroupbox("恶魔鸭合成", "flame")
evilGroup:AddButton({ Text = "选择第1个材料", Func = function() selectMaterial(1) end })
evilGroup:AddButton({ Text = "选择第2个材料", Func = function() selectMaterial(2) end })
evilGroup:AddButton({ Text = "选择第3个材料", Func = function() selectMaterial(3) end })
evilGroup:AddButton({ Text = "显示当前已选材料", Func = showSelectedMaterials })
evilGroup:AddButton({ Text = "开始合成恶魔鸭", Func = startDevilDuckCombine })
evilGroup:AddButton({ Text = "删除恶魔鸭墙", Func = removeDevilDuckWall })

-- ====== 合成 · EvilHeart 合成 ======
local heartGroup = Tabs.Craft:AddRightGroupbox("EvilHeart 合成", "heart-crack")
heartGroup:AddInput("EvilHeartCount", {
    Text = "EvilHeart合成数量",
    Default = "1",
    Numeric = true,
    Callback = function(v)
        local n = tonumber(v)
        if n and n > 0 then evilHeathCount = math.floor(n) end
    end,
})
heartGroup:AddButton({ Text = "自动合成核心（生成EvilHeart）", Func = autoCombineEvilHeart })
heartGroup:AddButton({ Text = "停止 EvilHeart 合成", Func = stopEvilHeart })

-- ====== 合成 · 恶魔鸭提示翻译 ======
local transGroup = Tabs.Craft:AddLeftGroupbox("恶魔鸭提示翻译", "languages")
transGroup:AddButton({ Text = "翻译当前恶魔鸭提示", Func = translateEvilDuckHints })
-- ====== 鸭子 · 鸭子带回 ======
local duckBringGroup = Tabs.Duck:AddLeftGroupbox("鸭子带回", "feather")
duckBringGroup:AddDropdown("DuckType", {
    Text = "选择鸭子类型",
    Values = duckDisplayOptions,
    Default = duckDisplayOptions[1],
    Callback = function(d)
        for _, v in ipairs(duckTypeList) do
            if v.display == d then selectedDuckName = v.name; break end
        end
    end,
})
duckBringGroup:AddInput("DuckCount", {
    Text = "带回数量(0=无限)",
    Default = "1",
    Numeric = true,
    Callback = function(v)
        local n = tonumber(v)
        if n and n >= 0 then batchDuckCount = n end
    end,
})
duckBringGroup:AddButton({ Text = "带回自己的", Func = function() bringDucksBatch(true) end })
duckBringGroup:AddButton({ Text = "带回无归属的", Func = function() bringDucksBatch(false) end })
duckBringGroup:AddButton({ Text = "停止", Func = stopDuckBatch })

-- ====== 鸭子 · 特殊鸭操作 ======
local duckSpecialGroup = Tabs.Duck:AddRightGroupbox("特殊鸭操作", "sparkles")
duckSpecialGroup:AddButton({ Text = "执行天堂鸭序列", Func = runAngelDuckSequence })
duckSpecialGroup:AddButton({ Text = "一键合成复仇剑", Func = synthesizeRevengeSword })
duckSpecialGroup:AddButton({ Text = "一键合成月亮鸭", Func = synthesizeLunarDuck })
-- ====== 购买 · 快捷操作 ======
local quickGroup = Tabs.Shop:AddLeftGroupbox("快捷操作", "bolt")
quickGroup:AddButton({ Text = "刷新商店 ID", Func = refreshStoreIds })
quickGroup:AddButton({ Text = "一键购买所有蓝图", Func = buyAllBlueprints })
quickGroup:AddButton({
    Text = "停止购买",
    Func = function()
        stopPurchaseFlag = true
        notify("MOYAN HUB", "已停止", 2)
    end,
})
-- ====== 购买 · 各商店（动态生成分组） ======
task.spawn(function()
    task.wait(4)
    if #allStores == 0 then
        notify("MOYAN HUB", "未找到商店，请检查游戏环境", 4)
        return
    end
    for i, store in ipairs(allStores) do
        local storeDisplay = getStoreDisplayName(store.name)
        local gb = (i % 2 == 1)
            and Tabs.Shop:AddLeftGroupbox(storeDisplay, "package")
            or  Tabs.Shop:AddRightGroupbox(storeDisplay, "package")

        local rawItems = {}
        for _, item in pairs(store.shopItems:GetChildren()) do table.insert(rawItems, {name=item.Name, model=item}) end
        table.sort(rawItems, function(a, b) return a.name < b.name end)

        local displayOptions, valueMap = {}, {}
        for _, entry in ipairs(rawItems) do
            local dn = entry.name
            local ident = entry.name
            if store.isMusicStore then
                local s = entry.model:FindFirstChild("Settings")
                if s then
                    local cd = s:FindFirstChild("CD")
                    if cd and cd:IsA("StringValue") and cd.Value ~= "" then dn = cd.Value; ident = cd.Value end
                end
            end
            local disp = getDisplayName(dn)
            displayOptions[#displayOptions+1] = disp
            valueMap[disp] = ident
        end

        if #displayOptions == 0 then
            gb:AddLabel("暂无商品")
        else
            local selectedIdent = valueMap[displayOptions[1]]
            local buyAmount = 1
            local itemIdx = "Item_"..store.name
            local qtyIdx = "Qty_"..store.name
            gb:AddDropdown(itemIdx, {
                Text = "选择商品",
                Values = displayOptions,
                Default = displayOptions[1],
                Searchable = true,
                Callback = function(v)
                    selectedIdent = valueMap[v]
                end,
            })
            gb:AddInput(qtyIdx, {
                Text = "购买数量",
                Default = "1",
                Numeric = true,
                Callback = function(v)
                    local n = tonumber(v)
                    if n and n > 0 then buyAmount = math.floor(n)
                    else notify("MOYAN HUB", "请输入大于0的整数", 2) end
                end,
            })
            gb:AddButton({
                Text = "购买",
                Func = function()
                    if not store.npc.id then notify("MOYAN HUB", "商店 ID 未就绪，请等待", 3); return end
                    if not selectedIdent then notify("MOYAN HUB", "请先选择商品", 3); return end
                    task.spawn(function()
                        purchaseCycle(store, store.isMusicStore and nil or selectedIdent, buyAmount, store.isMusicStore and selectedIdent or nil)
                    end)
                end,
            })
            gb:AddButton({
                Text = "停止购买",
                Func = function()
                    stopPurchaseFlag = true
                    notify("MOYAN HUB", "已停止", 2)
                end,
            })
        end
    end
end)
-- ====== 设置 ======
local settingsGroup = Tabs.Settings:AddLeftGroupbox("菜单设置", "sliders")
settingsGroup:AddToggle("ShowCustomCursor", {
    Text = "自定义光标",
    Default = Library.ShowCustomCursor,
    Callback = function(value)
        Library.ShowCustomCursor = value
    end
})
settingsGroup:AddButton({
    Text = "卸载 UI",
    Func = function()
        Library:Unload()
    end,
    Risky = true,
})

-- 主题管理与配置管理（沿用 MOYAN 原设置）
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })
ThemeManager:SetFolder("MOYAN_HUB")
SaveManager:SetFolder("MOYAN_HUB")
SaveManager:SetSubFolder("Configs")
SaveManager:BuildConfigSection(Tabs.Settings)
ThemeManager:ApplyToTab(Tabs.Settings)

print("[MOYAN HUB] 木材全功能已加载（界面：MOYAN/Obsidian）")
end
