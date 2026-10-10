-- ============================================================
-- 小秋木材脚本 - 完整版
-- ============================================================
local CARD_KEY = "小秋不掉面"
local QQ_NUM = "3979415300"
local GROUP_NUM = "731242915"

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local pg = lp:WaitForChild("PlayerGui")
local ws = workspace
local rep = game:GetService("ReplicatedStorage")

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
    local amounts = ws:FindFirstChild("Stores")
        and ws.Stores:FindFirstChild("PlanterStore")
        and ws.Stores.PlanterStore:FindFirstChild("Planter Spawner")
        and ws.Stores.PlanterStore["Planter Spawner"]:FindFirstChild("Amounts")
    if amounts then
        for _, c in ipairs(amounts:GetChildren()) do
            if c:IsA("NumberValue") or c:IsA("IntValue") or c:IsA("StringValue") then
                table.insert(list, tostring(c.Name))
            end
        end
    end
    if #list == 0 then
        local W = rep:FindFirstChild("Woods")
        if W then
            for _, c in ipairs(W:GetChildren()) do
                table.insert(list, tostring(c.Name))
            end
        end
    end
    return list
end

local treeMapping = {}
for _, cls in ipairs(readTreeClasses()) do
    treeMapping[TREE_CN[cls] or cls] = cls
end
if next(treeMapping) == nil then
    for cn, cls in pairs(TREE_FALLBACK) do
        treeMapping[cn] = cls
    end
end
treeMapping["普通树"] = treeMapping["普通树"] or "Generic"
treeMapping["幻影木"] = treeMapping["幻影木"] or "LoneCave"

local TREE_PRIORITY = {"火焰木", "石头木", "蓝色火焰木", "彩色火焰木"}

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
for name in pairs(treeMapping) do
    table.insert(treeNames, name)
end
sortTreeNames(treeNames)

local function showTip(title, content, color)
    color = color or Color3.fromRGB(160, 160, 160)
    local sg = Instance.new("ScreenGui")
    sg.Name = "XiaoQiuTip"
    sg.ResetOnSpawn = false
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.Parent = pg
    local tip = Instance.new("Frame")
    tip.Size = UDim2.new(0, 240, 0, 70)
    tip.Position = UDim2.new(1, 20, 1, -90)
    tip.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    tip.BorderSizePixel = 0
    tip.ZIndex = 100
    tip.Parent = sg
    Instance.new("UICorner", tip).CornerRadius = UDim.new(0, 12)
    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0, 3, 1, -20)
    bar.Position = UDim2.new(0, 0, 0, 10)
    bar.BackgroundColor3 = color
    bar.BorderSizePixel = 0
    bar.ZIndex = 101
    bar.Parent = tip
    Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 2)
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -20, 0, 24)
    titleLabel.Position = UDim2.new(0, 10, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 15
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.ZIndex = 101
    titleLabel.Parent = tip
    local contentLabel = Instance.new("TextLabel")
    contentLabel.Size = UDim2.new(1, -20, 0, 24)
    contentLabel.Position = UDim2.new(0, 10, 0, 36)
    contentLabel.BackgroundTransparency = 1
    contentLabel.Text = content
    contentLabel.TextColor3 = color
    contentLabel.TextSize = 13
    contentLabel.Font = Enum.Font.Gotham
    contentLabel.TextXAlignment = Enum.TextXAlignment.Left
    contentLabel.ZIndex = 101
    contentLabel.Parent = tip
    tip:TweenPosition(UDim2.new(1, -260, 1, -90), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.4, true)
    task.delay(3, function()
        tip:TweenPosition(UDim2.new(1, 20, 1, -90), Enum.EasingDirection.In, Enum.EasingStyle.Quart, 0.4, true)
        task.wait(0.5)
        sg:Destroy()
    end)
end

local function showSuccessTip() showTip("小秋", "砍树成功", Color3.fromRGB(160, 160, 160)) end
local function showNoWeaponTip() showTip("小秋", "自动选择武器失败", Color3.fromRGB(255, 80, 80)) end
local function showDangerTip() showTip("小秋", "树在危险区域，已帮你清理", Color3.fromRGB(255, 140, 60)) end
local function showLavaTip() showTip("小秋", "树已在危险区域，已帮你清理", Color3.fromRGB(255, 140, 60)) end
-- ============================================================
-- 底部提示悬浮窗
-- ============================================================
local function showCopyTip()
    local sg = Instance.new("ScreenGui")
    sg.Name = "XiaoQiuCopyTip"
    sg.ResetOnSpawn = false
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.Parent = pg
    local tip = Instance.new("Frame")
    tip.Size = UDim2.new(0, 260, 0, 46)
    tip.Position = UDim2.new(0.5, -130, 1, 20)
    tip.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    tip.BorderSizePixel = 0
    tip.ZIndex = 100
    tip.Parent = sg
    Instance.new("UICorner", tip).CornerRadius = UDim.new(0, 12)
    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, -20, 1, 0)
    text.Position = UDim2.new(0, 10, 0, 0)
    text.BackgroundTransparency = 1
    text.Text = "已将群号复制到你的剪贴板"
    text.TextColor3 = Color3.fromRGB(240, 240, 240)
    text.TextSize = 14
    text.Font = Enum.Font.GothamBold
    text.ZIndex = 101
    text.Parent = tip
    tip:TweenPosition(UDim2.new(0.5, -130, 1, -70), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.4, true)
    task.delay(3, function()
        tip:TweenPosition(UDim2.new(0.5, -130, 1, 20), Enum.EasingDirection.In, Enum.EasingStyle.Quart, 0.4, true)
        task.wait(0.5)
        sg:Destroy()
    end)
end

-- ============================================================
-- 卡密输入界面
-- ============================================================
local function showCardUI(callback)
    local sg = Instance.new("ScreenGui")
    sg.Name = "XiaoQiuCardUI"
    sg.ResetOnSpawn = false
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.Parent = pg
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bg.BackgroundTransparency = 0.5
    bg.BorderSizePixel = 0
    bg.ZIndex = 1
    bg.Parent = sg
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 320, 0, 200)
    frame.Position = UDim2.new(0.5, 0, 0.5, 0)
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    frame.BorderSizePixel = 0
    frame.ZIndex = 2
    frame.Parent = bg
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 16)
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -30, 0, 40)
    title.Position = UDim2.new(0, 15, 0, 15)
    title.BackgroundTransparency = 1
    title.Text = "小秋木材脚本"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 22
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 3
    title.Parent = frame
    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(1, -30, 0, 20)
    subtitle.Position = UDim2.new(0, 15, 0, 55)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "请输入卡密"
    subtitle.TextColor3 = Color3.fromRGB(150, 150, 150)
    subtitle.TextSize = 14
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextXAlignment = Enum.TextXAlignment.Left
    subtitle.ZIndex = 3
    subtitle.Parent = frame
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, -30, 0, 42)
    box.Position = UDim2.new(0, 15, 0, 85)
    box.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    box.BorderSizePixel = 0
    box.Text = ""
    box.PlaceholderText = "请输入卡密"
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
    box.TextSize = 15
    box.Font = Enum.Font.Gotham
    box.ClearTextOnFocus = false
    box.ZIndex = 3
    box.Parent = frame
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 10)
    local okBtn = Instance.new("TextButton")
    okBtn.Size = UDim2.new(0.5, -20, 0, 40)
    okBtn.Position = UDim2.new(0, 15, 1, -55)
    okBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    okBtn.BorderSizePixel = 0
    okBtn.Text = "确认"
    okBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    okBtn.TextSize = 15
    okBtn.Font = Enum.Font.GothamBold
    okBtn.ZIndex = 3
    okBtn.Parent = frame
    Instance.new("UICorner", okBtn).CornerRadius = UDim.new(0, 10)
    local noBtn = Instance.new("TextButton")
    noBtn.Size = UDim2.new(0.5, -20, 0, 40)
    noBtn.Position = UDim2.new(0.5, 5, 1, -55)
    noBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    noBtn.BorderSizePixel = 0
    noBtn.Text = "取消"
    noBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    noBtn.TextSize = 15
    noBtn.Font = Enum.Font.GothamBold
    noBtn.ZIndex = 3
    noBtn.Parent = frame
    Instance.new("UICorner", noBtn).CornerRadius = UDim.new(0, 10)
    local done = false
    okBtn.MouseButton1Click:Connect(function()
        if done then return end
        local key = string.gsub(box.Text, "%s", "")
        if key == CARD_KEY then
            done = true
            sg:Destroy()
            callback(true)
        else
            box.Text = ""
            box.PlaceholderText = "卡密错误，请重新输入"
            box.PlaceholderColor3 = Color3.fromRGB(255, 80, 80)
        end
    end)
    noBtn.MouseButton1Click:Connect(function()
        if done then return end
        done = true
        sg:Destroy()
        callback(false)
    end)
end

-- ============================================================
-- 飞行模块（内置编码，点击按钮直接执行，飞行源码保持不变）
-- ============================================================
    local _FLY_B64 = table.concat({
        "bG9jYWwgbWFpbiA9IEluc3RhbmNlLm5ldygiU2NyZWVuR3VpIikKbG9jYWwgRnJhbWUgPSBJbnN0YW5j",
        "ZS5uZXcoIkZyYW1lIikKbG9jYWwgdXAgPSBJbnN0YW5jZS5uZXcoIlRleHRCdXR0b24iKQpsb2NhbCBk",
        "b3duID0gSW5zdGFuY2UubmV3KCJUZXh0QnV0dG9uIikKbG9jYWwgb25vZiA9IEluc3RhbmNlLm5ldygi",
        "VGV4dEJ1dHRvbiIpCmxvY2FsIFRleHRMYWJlbCA9IEluc3RhbmNlLm5ldygiVGV4dExhYmVsIikKbG9j",
        "YWwgcGx1cyA9IEluc3RhbmNlLm5ldygiVGV4dEJ1dHRvbiIpCmxvY2FsIHNwZWVkID0gSW5zdGFuY2Uu",
        "bmV3KCJUZXh0TGFiZWwiKQpsb2NhbCBtaW5lID0gSW5zdGFuY2UubmV3KCJUZXh0QnV0dG9uIikKbG9j",
        "YWwgY2xvc2VidXR0b24gPSBJbnN0YW5jZS5uZXcoIlRleHRCdXR0b24iKQpsb2NhbCBtaW5pID0gSW5z",
        "dGFuY2UubmV3KCJUZXh0QnV0dG9uIikKbG9jYWwgbWluaTIgPSBJbnN0YW5jZS5uZXcoIlRleHRCdXR0",
        "b24iKQoKbWFpbi5OYW1lID0gIm1haW4iCm1haW4uUGFyZW50ID0gZ2FtZS5QbGF5ZXJzLkxvY2FsUGxh",
        "eWVyOldhaXRGb3JDaGlsZCgiUGxheWVyR3VpIikKbWFpbi5aSW5kZXhCZWhhdmlvciA9IEVudW0uWklu",
        "ZGV4QmVoYXZpb3IuU2libGluZwptYWluLlJlc2V0T25TcGF3biA9IGZhbHNlCgpGcmFtZS5QYXJlbnQg",
        "PSBtYWluCkZyYW1lLkJhY2tncm91bmRDb2xvcjMgPSBDb2xvcjMuZnJvbVJHQigxNjMsIDI1NSwgMTM3",
        "KQpGcmFtZS5Cb3JkZXJDb2xvcjMgPSBDb2xvcjMuZnJvbVJHQigxMDMsIDIyMSwgMjEzKQpGcmFtZS5Q",
        "b3NpdGlvbiA9IFVEaW0yLm5ldygwLjEwMDMyMDE2OCwgMCwgMC4zNzk3NDY4MjUsIDApCkZyYW1lLlNp",
        "emUgPSBVRGltMi5uZXcoMCwgMTkwLCAwLCA1NykKCnVwLk5hbWUgPSAidXAiCnVwLlBhcmVudCA9IEZy",
        "YW1lCnVwLkJhY2tncm91bmRDb2xvcjMgPSBDb2xvcjMuZnJvbVJHQig3OSwgMjU1LCAxNTIpCnVwLlNp",
        "emUgPSBVRGltMi5uZXcoMCwgNDQsIDAsIDI4KQp1cC5Gb250ID0gRW51bS5Gb250LlNvdXJjZVNhbnMK",
        "dXAuVGV4dCA9ICJVUCIKdXAuVGV4dENvbG9yMyA9IENvbG9yMy5mcm9tUkdCKDAsIDAsIDApCnVwLlRl",
        "eHRTaXplID0gMTQuMDAwCgpkb3duLk5hbWUgPSAiZG93biIKZG93bi5QYXJlbnQgPSBGcmFtZQpkb3du",
        "LkJhY2tncm91bmRDb2xvcjMgPSBDb2xvcjMuZnJvbVJHQigyMTUsIDI1NSwgMTIxKQpkb3duLlBvc2l0",
        "aW9uID0gVURpbTIubmV3KDAsIDAsIDAuNDkxMjI4MDc0LCAwKQpkb3duLlNpemUgPSBVRGltMi5uZXco",
        "MCwgNDQsIDAsIDI4KQpkb3duLkZvbnQgPSBFbnVtLkZvbnQuU291cmNlU2Fucwpkb3duLlRleHQgPSAi",
        "RE9XTiIKZG93bi5UZXh0Q29sb3IzID0gQ29sb3IzLmZyb21SR0IoMCwgMCwgMCkKZG93bi5UZXh0U2l6",
        "ZSA9IDE0LjAwMAoKb25vZi5OYW1lID0gIm9ub2YiCm9ub2YuUGFyZW50ID0gRnJhbWUKb25vZi5CYWNr",
        "Z3JvdW5kQ29sb3IzID0gQ29sb3IzLmZyb21SR0IoMjU1LCAyNDksIDc0KQpvbm9mLlBvc2l0aW9uID0g",
        "VURpbTIubmV3KDAuNzAyODIzMjgxLCAwLCAwLjQ5MTIyODA3NCwgMCkKb25vZi5TaXplID0gVURpbTIu",
        "bmV3KDAsIDU2LCAwLCAyOCkKb25vZi5Gb250ID0gRW51bS5Gb250LlNvdXJjZVNhbnMKb25vZi5UZXh0",
        "ID0gImZseSIKb25vZi5UZXh0Q29sb3IzID0gQ29sb3IzLmZyb21SR0IoMCwgMCwgMCkKb25vZi5UZXh0",
        "U2l6ZSA9IDE0LjAwMAoKVGV4dExhYmVsLlBhcmVudCA9IEZyYW1lClRleHRMYWJlbC5CYWNrZ3JvdW5k",
        "Q29sb3IzID0gQ29sb3IzLmZyb21SR0IoMjQyLCA2MCwgMjU1KQpUZXh0TGFiZWwuUG9zaXRpb24gPSBV",
        "RGltMi5uZXcoMC40NjkzMjczMDEsIDAsIDAsIDApClRleHRMYWJlbC5TaXplID0gVURpbTIubmV3KDAs",
        "IDEwMCwgMCwgMjgpClRleHRMYWJlbC5Gb250ID0gRW51bS5Gb250LlNvdXJjZVNhbnMKVGV4dExhYmVs",
        "LlRleHQgPSAiRkxZIEdVSSBWMyIKVGV4dExhYmVsLlRleHRDb2xvcjMgPSBDb2xvcjMuZnJvbVJHQigw",
        "LCAwLCAwKQpUZXh0TGFiZWwuVGV4dFNjYWxlZCA9IHRydWUKVGV4dExhYmVsLlRleHRTaXplID0gMTQu",
        "MDAwClRleHRMYWJlbC5UZXh0V3JhcHBlZCA9IHRydWUKCnBsdXMuTmFtZSA9ICJwbHVzIgpwbHVzLlBh",
        "cmVudCA9IEZyYW1lCnBsdXMuQmFja2dyb3VuZENvbG9yMyA9IENvbG9yMy5mcm9tUkdCKDEzMywgMTQ1",
        "LCAyNTUpCnBsdXMuUG9zaXRpb24gPSBVRGltMi5uZXcoMC4yMzE1Nzg5NDYsIDAsIDAsIDApCnBsdXMu",
        "U2l6ZSA9IFVEaW0yLm5ldygwLCA0NSwgMCwgMjgpCnBsdXMuRm9udCA9IEVudW0uRm9udC5Tb3VyY2VT",
        "YW5zCnBsdXMuVGV4dCA9ICIrIgpwbHVzLlRleHRDb2xvcjMgPSBDb2xvcjMuZnJvbVJHQigwLCAwLCAw",
        "KQpwbHVzLlRleHRTY2FsZWQgPSB0cnVlCnBsdXMuVGV4dFNpemUgPSAxNC4wMDAKcGx1cy5UZXh0V3Jh",
        "cHBlZCA9IHRydWUKCnNwZWVkLk5hbWUgPSAic3BlZWQiCnNwZWVkLlBhcmVudCA9IEZyYW1lCnNwZWVk",
        "LkJhY2tncm91bmRDb2xvcjMgPSBDb2xvcjMuZnJvbVJHQigyNTUsIDg1LCAwKQpzcGVlZC5Qb3NpdGlv",
        "biA9IFVEaW0yLm5ldygwLjQ2ODQyMTA0MiwgMCwgMC40OTEyMjgwNzQsIDApCnNwZWVkLlNpemUgPSBV",
        "RGltMi5uZXcoMCwgNDQsIDAsIDI4KQpzcGVlZC5Gb250ID0gRW51bS5Gb250LlNvdXJjZVNhbnMKc3Bl",
        "ZWQuVGV4dCA9ICIxIgpzcGVlZC5UZXh0Q29sb3IzID0gQ29sb3IzLmZyb21SR0IoMCwgMCwgMCkKc3Bl",
        "ZWQuVGV4dFNjYWxlZCA9IHRydWUKc3BlZWQuVGV4dFNpemUgPSAxNC4wMDAKc3BlZWQuVGV4dFdyYXBw",
        "ZWQgPSB0cnVlCgptaW5lLk5hbWUgPSAibWluZSIKbWluZS5QYXJlbnQgPSBGcmFtZQptaW5lLkJhY2tn",
        "cm91bmRDb2xvcjMgPSBDb2xvcjMuZnJvbVJHQigxMjMsIDI1NSwgMjQ3KQptaW5lLlBvc2l0aW9uID0g",
        "VURpbTIubmV3KDAuMjMxNTc4OTQ2LCAwLCAwLjQ5MTIyODA3NCwgMCkKbWluZS5TaXplID0gVURpbTIu",
        "bmV3KDAsIDQ1LCAwLCAyOSkKbWluZS5Gb250ID0gRW51bS5Gb250LlNvdXJjZVNhbnMKbWluZS5UZXh0",
        "ID0gIi0iCm1pbmUuVGV4dENvbG9yMyA9IENvbG9yMy5mcm9tUkdCKDAsIDAsIDApCm1pbmUuVGV4dFNj",
        "YWxlZCA9IHRydWUKbWluZS5UZXh0U2l6ZSA9IDE0LjAwMAptaW5lLlRleHRXcmFwcGVkID0gdHJ1ZQoK",
        "Y2xvc2VidXR0b24uTmFtZSA9ICJDbG9zZSIKY2xvc2VidXR0b24uUGFyZW50ID0gbWFpbi5GcmFtZQpj",
        "bG9zZWJ1dHRvbi5CYWNrZ3JvdW5kQ29sb3IzID0gQ29sb3IzLmZyb21SR0IoMjI1LCAyNSwgMCkKY2xv",
        "c2VidXR0b24uRm9udCA9ICJTb3VyY2VTYW5zIgpjbG9zZWJ1dHRvbi5TaXplID0gVURpbTIubmV3KDAs",
        "IDQ1LCAwLCAyOCkKY2xvc2VidXR0b24uVGV4dCA9ICJYIgpjbG9zZWJ1dHRvbi5UZXh0U2l6ZSA9IDMw",
        "CmNsb3NlYnV0dG9uLlBvc2l0aW9uID0gIFVEaW0yLm5ldygwLCAwLCAtMSwgMjcpCgptaW5pLk5hbWUg",
        "PSAibWluaW1pemUiCm1pbmkuUGFyZW50ID0gbWFpbi5GcmFtZQptaW5pLkJhY2tncm91bmRDb2xvcjMg",
        "PSBDb2xvcjMuZnJvbVJHQigxOTIsIDE1MCwgMjMwKQptaW5pLkZvbnQgPSAiU291cmNlU2FucyIKbWlu",
        "aS5TaXplID0gVURpbTIubmV3KDAsIDQ1LCAwLCAyOCkKbWluaS5UZXh0ID0gIi0iCm1pbmkuVGV4dFNp",
        "emUgPSA0MAptaW5pLlBvc2l0aW9uID0gVURpbTIubmV3KDAsIDQ0LCAtMSwgMjcpCgptaW5pMi5OYW1l",
        "ID0gIm1pbmltaXplMiIKbWluaTIuUGFyZW50ID0gbWFpbi5GcmFtZQptaW5pMi5CYWNrZ3JvdW5kQ29s",
        "b3IzID0gQ29sb3IzLmZyb21SR0IoMTkyLCAxNTAsIDIzMCkKbWluaTIuRm9udCA9ICJTb3VyY2VTYW5z",
        "IgptaW5pMi5TaXplID0gVURpbTIubmV3KDAsIDQ1LCAwLCAyOCkKbWluaTIuVGV4dCA9ICIrIgptaW5p",
        "Mi5UZXh0U2l6ZSA9IDQwCm1pbmkyLlBvc2l0aW9uID0gVURpbTIubmV3KDAsIDQ0LCAtMSwgNTcpCm1p",
        "bmkyLlZpc2libGUgPSBmYWxzZQoKc3BlZWRzID0gMQoKbG9jYWwgc3BlYWtlciA9IGdhbWU6R2V0U2Vy",
        "dmljZSgiUGxheWVycyIpLkxvY2FsUGxheWVyCgpsb2NhbCBjaHIgPSBnYW1lLlBsYXllcnMuTG9jYWxQ",
        "bGF5ZXIuQ2hhcmFjdGVyCmxvY2FsIGh1bSA9IGNociBhbmQgY2hyOkZpbmRGaXJzdENoaWxkV2hpY2hJ",
        "c0EoIkh1bWFub2lkIikKCm5vd2UgPSBmYWxzZQoKZ2FtZTpHZXRTZXJ2aWNlKCJTdGFydGVyR3VpIik6",
        "U2V0Q29yZSgiU2VuZE5vdGlmaWNhdGlvbiIsIHsgCglUaXRsZSA9ICJGTFkgR1VJIFYzIjsKCVRleHQg",
        "PSAiQlkgWE5FTyI7CglJY29uID0gInJieHRodW1iOi8vdHlwZT1Bc3NldCZpZD01MTA3MTgyMTE0Jnc9",
        "MTUwJmg9MTUwIn0pCkR1cmF0aW9uID0gNTsKCkZyYW1lLkFjdGl2ZSA9IHRydWUgLS0gbWFpbiA9IGd1",
        "aQpGcmFtZS5EcmFnZ2FibGUgPSB0cnVlCgpvbm9mLk1vdXNlQnV0dG9uMURvd246Y29ubmVjdChmdW5j",
        "dGlvbigpCgoJaWYgbm93ZSA9PSB0cnVlIHRoZW4KCQlub3dlID0gZmFsc2UKCgkJc3BlYWtlci5DaGFy",
        "YWN0ZXIuSHVtYW5vaWQ6U2V0U3RhdGVFbmFibGVkKEVudW0uSHVtYW5vaWRTdGF0ZVR5cGUuQ2xpbWJp",
        "bmcsdHJ1ZSkKCQlzcGVha2VyLkNoYXJhY3Rlci5IdW1hbm9pZDpTZXRTdGF0ZUVuYWJsZWQoRW51bS5I",
        "dW1hbm9pZFN0YXRlVHlwZS5GYWxsaW5nRG93bix0cnVlKQoJCXNwZWFrZXIuQ2hhcmFjdGVyLkh1bWFu",
        "b2lkOlNldFN0YXRlRW5hYmxlZChFbnVtLkh1bWFub2lkU3RhdGVUeXBlLkZseWluZyx0cnVlKQoJCXNw",
        "ZWFrZXIuQ2hhcmFjdGVyLkh1bWFub2lkOlNldFN0YXRlRW5hYmxlZChFbnVtLkh1bWFub2lkU3RhdGVU",
        "eXBlLkZyZWVmYWxsLHRydWUpCgkJc3BlYWtlci5DaGFyYWN0ZXIuSHVtYW5vaWQ6U2V0U3RhdGVFbmFi",
        "bGVkKEVudW0uSHVtYW5vaWRTdGF0ZVR5cGUuR2V0dGluZ1VwLHRydWUpCgkJc3BlYWtlci5DaGFyYWN0",
        "ZXIuSHVtYW5vaWQ6U2V0U3RhdGVFbmFibGVkKEVudW0uSHVtYW5vaWRTdGF0ZVR5cGUuSnVtcGluZyx0",
        "cnVlKQoJCXNwZWFrZXIuQ2hhcmFjdGVyLkh1bWFub2lkOlNldFN0YXRlRW5hYmxlZChFbnVtLkh1bWFu",
        "b2lkU3RhdGVUeXBlLkxhbmRlZCx0cnVlKQoJCXNwZWFrZXIuQ2hhcmFjdGVyLkh1bWFub2lkOlNldFN0",
        "YXRlRW5hYmxlZChFbnVtLkh1bWFub2lkU3RhdGVUeXBlLlBoeXNpY3MsdHJ1ZSkKCQlzcGVha2VyLkNo",
        "YXJhY3Rlci5IdW1hbm9pZDpTZXRTdGF0ZUVuYWJsZWQoRW51bS5IdW1hbm9pZFN0YXRlVHlwZS5QbGF0",
        "Zm9ybVN0YW5kaW5nLHRydWUpCgkJc3BlYWtlci5DaGFyYWN0ZXIuSHVtYW5vaWQ6U2V0U3RhdGVFbmFi",
        "bGVkKEVudW0uSHVtYW5vaWRTdGF0ZVR5cGUuUmFnZG9sbCx0cnVlKQoJCXNwZWFrZXIuQ2hhcmFjdGVy",
        "Lkh1bWFub2lkOlNldFN0YXRlRW5hYmxlZChFbnVtLkh1bWFub2lkU3RhdGVUeXBlLlJ1bm5pbmcsdHJ1",
        "ZSkKCQlzcGVha2VyLkNoYXJhY3Rlci5IdW1hbm9pZDpTZXRTdGF0ZUVuYWJsZWQoRW51bS5IdW1hbm9p",
        "ZFN0YXRlVHlwZS5SdW5uaW5nTm9QaHlzaWNzLHRydWUpCgkJc3BlYWtlci5DaGFyYWN0ZXIuSHVtYW5v",
        "aWQ6U2V0U3RhdGVFbmFibGVkKEVudW0uSHVtYW5vaWRTdGF0ZVR5cGUuU2VhdGVkLHRydWUpCgkJc3Bl",
        "YWtlci5DaGFyYWN0ZXIuSHVtYW5vaWQ6U2V0U3RhdGVFbmFibGVkKEVudW0uSHVtYW5vaWRTdGF0ZVR5",
        "cGUuU3RyYWZpbmdOb1BoeXNpY3MsdHJ1ZSkKCQlzcGVha2VyLkNoYXJhY3Rlci5IdW1hbm9pZDpTZXRT",
        "dGF0ZUVuYWJsZWQoRW51bS5IdW1hbm9pZFN0YXRlVHlwZS5Td2ltbWluZyx0cnVlKQoJCXNwZWFrZXIu",
        "Q2hhcmFjdGVyLkh1bWFub2lkOkNoYW5nZVN0YXRlKEVudW0uSHVtYW5vaWRTdGF0ZVR5cGUuUnVubmlu",
        "Z05vUGh5c2ljcykKCWVsc2UgCgkJbm93ZSA9IHRydWUKCgoKCQlmb3IgaSA9IDEsIHNwZWVkcyBkbwoJ",
        "CQlzcGF3bihmdW5jdGlvbigpCgoJCQkJbG9jYWwgaGIgPSBnYW1lOkdldFNlcnZpY2UoIlJ1blNlcnZp",
        "Y2UiKS5IZWFydGJlYXQJCgoKCQkJCXRwd2Fsa2luZyA9IHRydWUKCQkJCWxvY2FsIGNociA9IGdhbWUu",
        "UGxheWVycy5Mb2NhbFBsYXllci5DaGFyYWN0ZXIKCQkJCWxvY2FsIGh1bSA9IGNociBhbmQgY2hyOkZp",
        "bmRGaXJzdENoaWxkV2hpY2hJc0EoIkh1bWFub2lkIikKCQkJCXdoaWxlIHRwd2Fsa2luZyBhbmQgaGI6",
        "V2FpdCgpIGFuZCBjaHIgYW5kIGh1bSBhbmQgaHVtLlBhcmVudCBkbwoJCQkJCWlmIGh1bS5Nb3ZlRGly",
        "ZWN0aW9uLk1hZ25pdHVkZSA+IDAgdGhlbgoJCQkJCQljaHI6VHJhbnNsYXRlQnkoaHVtLk1vdmVEaXJl",
        "Y3Rpb24pCgkJCQkJZW5kCgkJCQllbmQKCgkJCWVuZCkKCQllbmQKCQlnYW1lLlBsYXllcnMuTG9jYWxQ",
        "bGF5ZXIuQ2hhcmFjdGVyLkFuaW1hdGUuRGlzYWJsZWQgPSB0cnVlCgkJbG9jYWwgQ2hhciA9IGdhbWUu",
        "UGxheWVycy5Mb2NhbFBsYXllci5DaGFyYWN0ZXIKCQlsb2NhbCBIdW0gPSBDaGFyOkZpbmRGaXJzdENo",
        "aWxkT2ZDbGFzcygiSHVtYW5vaWQiKSBvciBDaGFyOkZpbmRGaXJzdENoaWxkT2ZDbGFzcygiQW5pbWF0",
        "aW9uQ29udHJvbGxlciIpCgoJCWZvciBpLHYgaW4gbmV4dCwgSHVtOkdldFBsYXlpbmdBbmltYXRpb25U",
        "cmFja3MoKSBkbwoJCQl2OkFkanVzdFNwZWVkKDApCgkJZW5kCgkJc3BlYWtlci5DaGFyYWN0ZXIuSHVt",
        "YW5vaWQ6U2V0U3RhdGVFbmFibGVkKEVudW0uSHVtYW5vaWRTdGF0ZVR5cGUuQ2xpbWJpbmcsZmFsc2Up",
        "CgkJc3BlYWtlci5DaGFyYWN0ZXIuSHVtYW5vaWQ6U2V0U3RhdGVFbmFibGVkKEVudW0uSHVtYW5vaWRT",
        "dGF0ZVR5cGUuRmFsbGluZ0Rvd24sZmFsc2UpCgkJc3BlYWtlci5DaGFyYWN0ZXIuSHVtYW5vaWQ6U2V0",
        "U3RhdGVFbmFibGVkKEVudW0uSHVtYW5vaWRTdGF0ZVR5cGUuRmx5aW5nLGZhbHNlKQoJCXNwZWFrZXIu",
        "Q2hhcmFjdGVyLkh1bWFub2lkOlNldFN0YXRlRW5hYmxlZChFbnVtLkh1bWFub2lkU3RhdGVUeXBlLkZy",
        "ZWVmYWxsLGZhbHNlKQoJCXNwZWFrZXIuQ2hhcmFjdGVyLkh1bWFub2lkOlNldFN0YXRlRW5hYmxlZChF",
        "bnVtLkh1bWFub2lkU3RhdGVUeXBlLkdldHRpbmdVcCxmYWxzZSkKCQlzcGVha2VyLkNoYXJhY3Rlci5I",
        "dW1hbm9pZDpTZXRTdGF0ZUVuYWJsZWQoRW51bS5IdW1hbm9pZFN0YXRlVHlwZS5KdW1waW5nLGZhbHNl",
        "KQoJCXNwZWFrZXIuQ2hhcmFjdGVyLkh1bWFub2lkOlNldFN0YXRlRW5hYmxlZChFbnVtLkh1bWFub2lk",
        "U3RhdGVUeXBlLkxhbmRlZCxmYWxzZSkKCQlzcGVha2VyLkNoYXJhY3Rlci5IdW1hbm9pZDpTZXRTdGF0",
        "ZUVuYWJsZWQoRW51bS5IdW1hbm9pZFN0YXRlVHlwZS5QaHlzaWNzLGZhbHNlKQoJCXNwZWFrZXIuQ2hh",
        "cmFjdGVyLkh1bWFub2lkOlNldFN0YXRlRW5hYmxlZChFbnVtLkh1bWFub2lkU3RhdGVUeXBlLlBsYXRm",
        "b3JtU3RhbmRpbmcsZmFsc2UpCgkJc3BlYWtlci5DaGFyYWN0ZXIuSHVtYW5vaWQ6U2V0U3RhdGVFbmFi",
        "bGVkKEVudW0uSHVtYW5vaWRTdGF0ZVR5cGUuUmFnZG9sbCxmYWxzZSkKCQlzcGVha2VyLkNoYXJhY3Rl",
        "ci5IdW1hbm9pZDpTZXRTdGF0ZUVuYWJsZWQoRW51bS5IdW1hbm9pZFN0YXRlVHlwZS5SdW5uaW5nLGZh",
        "bHNlKQoJCXNwZWFrZXIuQ2hhcmFjdGVyLkh1bWFub2lkOlNldFN0YXRlRW5hYmxlZChFbnVtLkh1bWFu",
        "b2lkU3RhdGVUeXBlLlJ1bm5pbmdOb1BoeXNpY3MsZmFsc2UpCgkJc3BlYWtlci5DaGFyYWN0ZXIuSHVt",
        "YW5vaWQ6U2V0U3RhdGVFbmFibGVkKEVudW0uSHVtYW5vaWRTdGF0ZVR5cGUuU2VhdGVkLGZhbHNlKQoJ",
        "CXNwZWFrZXIuQ2hhcmFjdGVyLkh1bWFub2lkOlNldFN0YXRlRW5hYmxlZChFbnVtLkh1bWFub2lkU3Rh",
        "dGVUeXBlLlN0cmFmaW5nTm9QaHlzaWNzLGZhbHNlKQoJCXNwZWFrZXIuQ2hhcmFjdGVyLkh1bWFub2lk",
        "OlNldFN0YXRlRW5hYmxlZChFbnVtLkh1bWFub2lkU3RhdGVUeXBlLlN3aW1taW5nLGZhbHNlKQoJCXNw",
        "ZWFrZXIuQ2hhcmFjdGVyLkh1bWFub2lkOkNoYW5nZVN0YXRlKEVudW0uSHVtYW5vaWRTdGF0ZVR5cGUu",
        "U3dpbW1pbmcpCgllbmQKCgoKCglpZiBnYW1lOkdldFNlcnZpY2UoIlBsYXllcnMiKS5Mb2NhbFBsYXll",
        "ci5DaGFyYWN0ZXI6RmluZEZpcnN0Q2hpbGRPZkNsYXNzKCJIdW1hbm9pZCIpLlJpZ1R5cGUgPT0gRW51",
        "bS5IdW1hbm9pZFJpZ1R5cGUuUjYgdGhlbgoKCgoJCWxvY2FsIHBsciA9IGdhbWUuUGxheWVycy5Mb2Nh",
        "bFBsYXllcgoJCWxvY2FsIHRvcnNvID0gcGxyLkNoYXJhY3Rlci5Ub3JzbwoJCWxvY2FsIGZseWluZyA9",
        "IHRydWUKCQlsb2NhbCBkZWIgPSB0cnVlCgkJbG9jYWwgY3RybCA9IHtmID0gMCwgYiA9IDAsIGwgPSAw",
        "LCByID0gMH0KCQlsb2NhbCBsYXN0Y3RybCA9IHtmID0gMCwgYiA9IDAsIGwgPSAwLCByID0gMH0KCQls",
        "b2NhbCBtYXhzcGVlZCA9IDUwCgkJbG9jYWwgc3BlZWQgPSAwCgoKCQlsb2NhbCBiZyA9IEluc3RhbmNl",
        "Lm5ldygiQm9keUd5cm8iLCB0b3JzbykKCQliZy5QID0gOWU0CgkJYmcubWF4VG9ycXVlID0gVmVjdG9y",
        "My5uZXcoOWU5LCA5ZTksIDllOSkKCQliZy5jZnJhbWUgPSB0b3Jzby5DRnJhbWUKCQlsb2NhbCBidiA9",
        "IEluc3RhbmNlLm5ldygiQm9keVZlbG9jaXR5IiwgdG9yc28pCgkJYnYudmVsb2NpdHkgPSBWZWN0b3Iz",
        "Lm5ldygwLDAuMSwwKQoJCWJ2Lm1heEZvcmNlID0gVmVjdG9yMy5uZXcoOWU5LCA5ZTksIDllOSkKCQlp",
        "ZiBub3dlID09IHRydWUgdGhlbgoJCQlwbHIuQ2hhcmFjdGVyLkh1bWFub2lkLlBsYXRmb3JtU3RhbmQg",
        "PSB0cnVlCgkJZW5kCgkJd2hpbGUgbm93ZSA9PSB0cnVlIG9yIGdhbWU6R2V0U2VydmljZSgiUGxheWVy",
        "cyIpLkxvY2FsUGxheWVyLkNoYXJhY3Rlci5IdW1hbm9pZC5IZWFsdGggPT0gMCBkbwoJCQlnYW1lOkdl",
        "dFNlcnZpY2UoIlJ1blNlcnZpY2UiKS5SZW5kZXJTdGVwcGVkOldhaXQoKQoKCQkJaWYgY3RybC5sICsg",
        "Y3RybC5yIH49IDAgb3IgY3RybC5mICsgY3RybC5iIH49IDAgdGhlbgoJCQkJc3BlZWQgPSBzcGVlZCsu",
        "NSsoc3BlZWQvbWF4c3BlZWQpCgkJCQlpZiBzcGVlZCA+IG1heHNwZWVkIHRoZW4KCQkJCQlzcGVlZCA9",
        "IG1heHNwZWVkCgkJCQllbmQKCQkJZWxzZWlmIG5vdCAoY3RybC5sICsgY3RybC5yIH49IDAgb3IgY3Ry",
        "bC5mICsgY3RybC5iIH49IDApIGFuZCBzcGVlZCB+PSAwIHRoZW4KCQkJCXNwZWVkID0gc3BlZWQtMQoJ",
        "CQkJaWYgc3BlZWQgPCAwIHRoZW4KCQkJCQlzcGVlZCA9IDAKCQkJCWVuZAoJCQllbmQKCQkJaWYgKGN0",
        "cmwubCArIGN0cmwucikgfj0gMCBvciAoY3RybC5mICsgY3RybC5iKSB+PSAwIHRoZW4KCQkJCWJ2LnZl",
        "bG9jaXR5ID0gKChnYW1lLldvcmtzcGFjZS5DdXJyZW50Q2FtZXJhLkNvb3JkaW5hdGVGcmFtZS5sb29r",
        "VmVjdG9yICogKGN0cmwuZitjdHJsLmIpKSArICgoZ2FtZS5Xb3Jrc3BhY2UuQ3VycmVudENhbWVyYS5D",
        "b29yZGluYXRlRnJhbWUgKiBDRnJhbWUubmV3KGN0cmwubCtjdHJsLnIsKGN0cmwuZitjdHJsLmIpKi4y",
        "LDApLnApIC0gZ2FtZS5Xb3Jrc3BhY2UuQ3VycmVudENhbWVyYS5Db29yZGluYXRlRnJhbWUucCkpKnNw",
        "ZWVkCgkJCQlsYXN0Y3RybCA9IHtmID0gY3RybC5mLCBiID0gY3RybC5iLCBsID0gY3RybC5sLCByID0g",
        "Y3RybC5yfQoJCQllbHNlaWYgKGN0cmwubCArIGN0cmwucikgPT0gMCBhbmQgKGN0cmwuZiArIGN0cmwu",
        "YikgPT0gMCBhbmQgc3BlZWQgfj0gMCB0aGVuCgkJCQlidi52ZWxvY2l0eSA9ICgoZ2FtZS5Xb3Jrc3Bh",
        "Y2UuQ3VycmVudENhbWVyYS5Db29yZGluYXRlRnJhbWUubG9va1ZlY3RvciAqIChsYXN0Y3RybC5mK2xh",
        "c3RjdHJsLmIpKSArICgoZ2FtZS5Xb3Jrc3BhY2UuQ3VycmVudENhbWVyYS5Db29yZGluYXRlRnJhbWUg",
        "KiBDRnJhbWUubmV3KGxhc3RjdHJsLmwrbGFzdGN0cmwuciwobGFzdGN0cmwuZitsYXN0Y3RybC5iKSou",
        "MiwwKS5wKSAtIGdhbWUuV29ya3NwYWNlLkN1cnJlbnRDYW1lcmEuQ29vcmRpbmF0ZUZyYW1lLnApKSpz",
        "cGVlZAoJCQllbHNlCgkJCQlidi52ZWxvY2l0eSA9IFZlY3RvcjMubmV3KDAsMCwwKQoJCQllbmQKCQkJ",
        "LS0JZ2FtZS5QbGF5ZXJzLkxvY2FsUGxheWVyLkNoYXJhY3Rlci5BbmltYXRlLkRpc2FibGVkID0gdHJ1",
        "ZQoJCQliZy5jZnJhbWUgPSBnYW1lLldvcmtzcGFjZS5DdXJyZW50Q2FtZXJhLkNvb3JkaW5hdGVGcmFt",
        "ZSAqIENGcmFtZS5BbmdsZXMoLW1hdGgucmFkKChjdHJsLmYrY3RybC5iKSo1MCpzcGVlZC9tYXhzcGVl",
        "ZCksMCwwKQoJCWVuZAoJCWN0cmwgPSB7ZiA9IDAsIGIgPSAwLCBsID0gMCwgciA9IDB9CgkJbGFzdGN0",
        "cmwgPSB7ZiA9IDAsIGIgPSAwLCBsID0gMCwgciA9IDB9CgkJc3BlZWQgPSAwCgkJYmc6RGVzdHJveSgp",
        "CgkJYnY6RGVzdHJveSgpCgkJcGxyLkNoYXJhY3Rlci5IdW1hbm9pZC5QbGF0Zm9ybVN0YW5kID0gZmFs",
        "c2UKCQlnYW1lLlBsYXllcnMuTG9jYWxQbGF5ZXIuQ2hhcmFjdGVyLkFuaW1hdGUuRGlzYWJsZWQgPSBm",
        "YWxzZQoJCXRwd2Fsa2luZyA9IGZhbHNlCgoKCgoJZWxzZQoJCWxvY2FsIHBsciA9IGdhbWUuUGxheWVy",
        "cy5Mb2NhbFBsYXllcgoJCWxvY2FsIFVwcGVyVG9yc28gPSBwbHIuQ2hhcmFjdGVyLlVwcGVyVG9yc28K",
        "CQlsb2NhbCBmbHlpbmcgPSB0cnVlCgkJbG9jYWwgZGViID0gdHJ1ZQoJCWxvY2FsIGN0cmwgPSB7ZiA9",
        "IDAsIGIgPSAwLCBsID0gMCwgciA9IDB9CgkJbG9jYWwgbGFzdGN0cmwgPSB7ZiA9IDAsIGIgPSAwLCBs",
        "ID0gMCwgciA9IDB9CgkJbG9jYWwgbWF4c3BlZWQgPSA1MAoJCWxvY2FsIHNwZWVkID0gMAoKCgkJbG9j",
        "YWwgYmcgPSBJbnN0YW5jZS5uZXcoIkJvZHlHeXJvIiwgVXBwZXJUb3JzbykKCQliZy5QID0gOWU0CgkJ",
        "YmcubWF4VG9ycXVlID0gVmVjdG9yMy5uZXcoOWU5LCA5ZTksIDllOSkKCQliZy5jZnJhbWUgPSBVcHBl",
        "clRvcnNvLkNGcmFtZQoJCWxvY2FsIGJ2ID0gSW5zdGFuY2UubmV3KCJCb2R5VmVsb2NpdHkiLCBVcHBl",
        "clRvcnNvKQoJCWJ2LnZlbG9jaXR5ID0gVmVjdG9yMy5uZXcoMCwwLjEsMCkKCQlidi5tYXhGb3JjZSA9",
        "IFZlY3RvcjMubmV3KDllOSwgOWU5LCA5ZTkpCgkJaWYgbm93ZSA9PSB0cnVlIHRoZW4KCQkJcGxyLkNo",
        "YXJhY3Rlci5IdW1hbm9pZC5QbGF0Zm9ybVN0YW5kID0gdHJ1ZQoJCWVuZAoJCXdoaWxlIG5vd2UgPT0g",
        "dHJ1ZSBvciBnYW1lOkdldFNlcnZpY2UoIlBsYXllcnMiKS5Mb2NhbFBsYXllci5DaGFyYWN0ZXIuSHVt",
        "YW5vaWQuSGVhbHRoID09IDAgZG8KCQkJd2FpdCgpCgoJCQlpZiBjdHJsLmwgKyBjdHJsLnIgfj0gMCBv",
        "ciBjdHJsLmYgKyBjdHJsLmIgfj0gMCB0aGVuCgkJCQlzcGVlZCA9IHNwZWVkKy41KyhzcGVlZC9tYXhz",
        "cGVlZCkKCQkJCWlmIHNwZWVkID4gbWF4c3BlZWQgdGhlbgoJCQkJCXNwZWVkID0gbWF4c3BlZWQKCQkJ",
        "CWVuZAoJCQllbHNlaWYgbm90IChjdHJsLmwgKyBjdHJsLnIgfj0gMCBvciBjdHJsLmYgKyBjdHJsLmIg",
        "fj0gMCkgYW5kIHNwZWVkIH49IDAgdGhlbgoJCQkJc3BlZWQgPSBzcGVlZC0xCgkJCQlpZiBzcGVlZCA8",
        "IDAgdGhlbgoJCQkJCXNwZWVkID0gMAoJCQkJZW5kCgkJCWVuZAoJCQlpZiAoY3RybC5sICsgY3RybC5y",
        "KSB+PSAwIG9yIChjdHJsLmYgKyBjdHJsLmIpIH49IDAgdGhlbgoJCQkJYnYudmVsb2NpdHkgPSAoKGdh",
        "bWUuV29ya3NwYWNlLkN1cnJlbnRDYW1lcmEuQ29vcmRpbmF0ZUZyYW1lLmxvb2tWZWN0b3IgKiAoY3Ry",
        "bC5mK2N0cmwuYikpICsgKChnYW1lLldvcmtzcGFjZS5DdXJyZW50Q2FtZXJhLkNvb3JkaW5hdGVGcmFt",
        "ZSAqIENGcmFtZS5uZXcoY3RybC5sK2N0cmwuciwoY3RybC5mK2N0cmwuYikqLjIsMCkucCkgLSBnYW1l",
        "LldvcmtzcGFjZS5DdXJyZW50Q2FtZXJhLkNvb3JkaW5hdGVGcmFtZS5wKSkqc3BlZWQKCQkJCWxhc3Rj",
        "dHJsID0ge2YgPSBjdHJsLmYsIGIgPSBjdHJsLmIsIGwgPSBjdHJsLmwsIHIgPSBjdHJsLnJ9CgkJCWVs",
        "c2VpZiAoY3RybC5sICsgY3RybC5yKSA9PSAwIGFuZCAoY3RybC5mICsgY3RybC5iKSA9PSAwIGFuZCBz",
        "cGVlZCB+PSAwIHRoZW4KCQkJCWJ2LnZlbG9jaXR5ID0gKChnYW1lLldvcmtzcGFjZS5DdXJyZW50Q2Ft",
        "ZXJhLkNvb3JkaW5hdGVGcmFtZS5sb29rVmVjdG9yICogKGxhc3RjdHJsLmYrbGFzdGN0cmwuYikpICsg",
        "KChnYW1lLldvcmtzcGFjZS5DdXJyZW50Q2FtZXJhLkNvb3JkaW5hdGVGcmFtZSAqIENGcmFtZS5uZXco",
        "bGFzdGN0cmwubCtsYXN0Y3RybC5yLChsYXN0Y3RybC5mK2xhc3RjdHJsLmIpKi4yLDApLnApIC0gZ2Ft",
        "ZS5Xb3Jrc3BhY2UuQ3VycmVudENhbWVyYS5Db29yZGluYXRlRnJhbWUucCkpKnNwZWVkCgkJCWVsc2UK",
        "CQkJCWJ2LnZlbG9jaXR5ID0gVmVjdG9yMy5uZXcoMCwwLDApCgkJCWVuZAoKCQkJYmcuY2ZyYW1lID0g",
        "Z2FtZS5Xb3Jrc3BhY2UuQ3VycmVudENhbWVyYS5Db29yZGluYXRlRnJhbWUgKiBDRnJhbWUuQW5nbGVz",
        "KC1tYXRoLnJhZCgoY3RybC5mK2N0cmwuYikqNTAqc3BlZWQvbWF4c3BlZWQpLDAsMCkKCQllbmQKCQlj",
        "dHJsID0ge2YgPSAwLCBiID0gMCwgbCA9IDAsIHIgPSAwfQoJCWxhc3RjdHJsID0ge2YgPSAwLCBiID0g",
        "MCwgbCA9IDAsIHIgPSAwfQoJCXNwZWVkID0gMAoJCWJnOkRlc3Ryb3koKQoJCWJ2OkRlc3Ryb3koKQoJ",
        "CXBsci5DaGFyYWN0ZXIuSHVtYW5vaWQuUGxhdGZvcm1TdGFuZCA9IGZhbHNlCgkJZ2FtZS5QbGF5ZXJz",
        "LkxvY2FsUGxheWVyLkNoYXJhY3Rlci5BbmltYXRlLkRpc2FibGVkID0gZmFsc2UKCQl0cHdhbGtpbmcg",
        "PSBmYWxzZQoKCgoJZW5kCgoKCgoKZW5kKQoKbG9jYWwgdGlzCgp1cC5Nb3VzZUJ1dHRvbjFEb3duOmNv",
        "bm5lY3QoZnVuY3Rpb24oKQoJdGlzID0gdXAuTW91c2VFbnRlcjpjb25uZWN0KGZ1bmN0aW9uKCkKCQl3",
        "aGlsZSB0aXMgZG8KCQkJd2FpdCgpCgkJCWdhbWUuUGxheWVycy5Mb2NhbFBsYXllci5DaGFyYWN0ZXIu",
        "SHVtYW5vaWRSb290UGFydC5DRnJhbWUgPSBnYW1lLlBsYXllcnMuTG9jYWxQbGF5ZXIuQ2hhcmFjdGVy",
        "Lkh1bWFub2lkUm9vdFBhcnQuQ0ZyYW1lICogQ0ZyYW1lLm5ldygwLDEsMCkKCQllbmQKCWVuZCkKZW5k",
        "KQoKdXAuTW91c2VMZWF2ZTpjb25uZWN0KGZ1bmN0aW9uKCkKCWlmIHRpcyB0aGVuCgkJdGlzOkRpc2Nv",
        "bm5lY3QoKQoJCXRpcyA9IG5pbAoJZW5kCmVuZCkKCmxvY2FsIGRpcwoKZG93bi5Nb3VzZUJ1dHRvbjFE",
        "b3duOmNvbm5lY3QoZnVuY3Rpb24oKQoJZGlzID0gZG93bi5Nb3VzZUVudGVyOmNvbm5lY3QoZnVuY3Rp",
        "b24oKQoJCXdoaWxlIGRpcyBkbwoJCQl3YWl0KCkKCQkJZ2FtZS5QbGF5ZXJzLkxvY2FsUGxheWVyLkNo",
        "YXJhY3Rlci5IdW1hbm9pZFJvb3RQYXJ0LkNGcmFtZSA9IGdhbWUuUGxheWVycy5Mb2NhbFBsYXllci5D",
        "aGFyYWN0ZXIuSHVtYW5vaWRSb290UGFydC5DRnJhbWUgKiBDRnJhbWUubmV3KDAsLTEsMCkKCQllbmQK",
        "CWVuZCkKZW5kKQoKZG93bi5Nb3VzZUxlYXZlOmNvbm5lY3QoZnVuY3Rpb24oKQoJaWYgZGlzIHRoZW4K",
        "CQlkaXM6RGlzY29ubmVjdCgpCgkJZGlzID0gbmlsCgllbmQKZW5kKQoKCmdhbWU6R2V0U2VydmljZSgi",
        "UGxheWVycyIpLkxvY2FsUGxheWVyLkNoYXJhY3RlckFkZGVkOkNvbm5lY3QoZnVuY3Rpb24oY2hhcikK",
        "CXdhaXQoMC43KQoJZ2FtZS5QbGF5ZXJzLkxvY2FsUGxheWVyLkNoYXJhY3Rlci5IdW1hbm9pZC5QbGF0",
        "Zm9ybVN0YW5kID0gZmFsc2UKCWdhbWUuUGxheWVycy5Mb2NhbFBsYXllci5DaGFyYWN0ZXIuQW5pbWF0",
        "ZS5EaXNhYmxlZCA9IGZhbHNlCgplbmQpCgoKcGx1cy5Nb3VzZUJ1dHRvbjFEb3duOmNvbm5lY3QoZnVu",
        "Y3Rpb24oKQoJc3BlZWRzID0gc3BlZWRzICsgMQoJc3BlZWQuVGV4dCA9IHNwZWVkcwoJaWYgbm93ZSA9",
        "PSB0cnVlIHRoZW4KCgoJCXRwd2Fsa2luZyA9IGZhbHNlCgkJZm9yIGkgPSAxLCBzcGVlZHMgZG8KCQkJ",
        "c3Bhd24oZnVuY3Rpb24oKQoKCQkJCWxvY2FsIGhiID0gZ2FtZTpHZXRTZXJ2aWNlKCJSdW5TZXJ2aWNl",
        "IikuSGVhcnRiZWF0CQoKCgkJCQl0cHdhbGtpbmcgPSB0cnVlCgkJCQlsb2NhbCBjaHIgPSBnYW1lLlBs",
        "YXllcnMuTG9jYWxQbGF5ZXIuQ2hhcmFjdGVyCgkJCQlsb2NhbCBodW0gPSBjaHIgYW5kIGNocjpGaW5k",
        "Rmlyc3RDaGlsZFdoaWNoSXNBKCJIdW1hbm9pZCIpCgkJCQl3aGlsZSB0cHdhbGtpbmcgYW5kIGhiOldh",
        "aXQoKSBhbmQgY2hyIGFuZCBodW0gYW5kIGh1bS5QYXJlbnQgZG8KCQkJCQlpZiBodW0uTW92ZURpcmVj",
        "dGlvbi5NYWduaXR1ZGUgPiAwIHRoZW4KCQkJCQkJY2hyOlRyYW5zbGF0ZUJ5KGh1bS5Nb3ZlRGlyZWN0",
        "aW9uKQoJCQkJCWVuZAoJCQkJZW5kCgoJCQllbmQpCgkJZW5kCgllbmQKZW5kKQptaW5lLk1vdXNlQnV0",
        "dG9uMURvd246Y29ubmVjdChmdW5jdGlvbigpCglpZiBzcGVlZHMgPT0gMSB0aGVuCgkJc3BlZWQuVGV4",
        "dCA9ICdjYW5ub3QgYmUgbGVzcyB0aGFuIDEnCgkJd2FpdCgxKQoJCXNwZWVkLlRleHQgPSBzcGVlZHMK",
        "CWVsc2UKCQlzcGVlZHMgPSBzcGVlZHMgLSAxCgkJc3BlZWQuVGV4dCA9IHNwZWVkcwoJCWlmIG5vd2Ug",
        "PT0gdHJ1ZSB0aGVuCgkJCXRwd2Fsa2luZyA9IGZhbHNlCgkJCWZvciBpID0gMSwgc3BlZWRzIGRvCgkJ",
        "CQlzcGF3bihmdW5jdGlvbigpCgoJCQkJCWxvY2FsIGhiID0gZ2FtZTpHZXRTZXJ2aWNlKCJSdW5TZXJ2",
        "aWNlIikuSGVhcnRiZWF0CQoKCgkJCQkJdHB3YWxraW5nID0gdHJ1ZQoJCQkJCWxvY2FsIGNociA9IGdh",
        "bWUuUGxheWVycy5Mb2NhbFBsYXllci5DaGFyYWN0ZXIKCQkJCQlsb2NhbCBodW0gPSBjaHIgYW5kIGNo",
        "cjpGaW5kRmlyc3RDaGlsZFdoaWNoSXNBKCJIdW1hbm9pZCIpCgkJCQkJd2hpbGUgdHB3YWxraW5nIGFu",
        "ZCBoYjpXYWl0KCkgYW5kIGNociBhbmQgaHVtIGFuZCBodW0uUGFyZW50IGRvCgkJCQkJCWlmIGh1bS5N",
        "b3ZlRGlyZWN0aW9uLk1hZ25pdHVkZSA+IDAgdGhlbgoJCQkJCQkJY2hyOlRyYW5zbGF0ZUJ5KGh1bS5N",
        "b3ZlRGlyZWN0aW9uKQoJCQkJCQllbmQKCQkJCQllbmQKCgkJCQllbmQpCgkJCWVuZAoJCWVuZAoJZW5k",
        "CmVuZCkKCmNsb3NlYnV0dG9uLk1vdXNlQnV0dG9uMUNsaWNrOkNvbm5lY3QoZnVuY3Rpb24oKQoJbWFp",
        "bjpEZXN0cm95KCkKZW5kKQoKbWluaS5Nb3VzZUJ1dHRvbjFDbGljazpDb25uZWN0KGZ1bmN0aW9uKCkK",
        "CXVwLlZpc2libGUgPSBmYWxzZQoJZG93bi5WaXNpYmxlID0gZmFsc2UKCW9ub2YuVmlzaWJsZSA9IGZh",
        "bHNlCglwbHVzLlZpc2libGUgPSBmYWxzZQoJc3BlZWQuVmlzaWJsZSA9IGZhbHNlCgltaW5lLlZpc2li",
        "bGUgPSBmYWxzZQoJbWluaS5WaXNpYmxlID0gZmFsc2UKCW1pbmkyLlZpc2libGUgPSB0cnVlCgltYWlu",
        "LkZyYW1lLkJhY2tncm91bmRUcmFuc3BhcmVuY3kgPSAxCgljbG9zZWJ1dHRvbi5Qb3NpdGlvbiA9ICBV",
        "RGltMi5uZXcoMCwgMCwgLTEsIDU3KQplbmQpCgptaW5pMi5Nb3VzZUJ1dHRvbjFDbGljazpDb25uZWN0",
        "KGZ1bmN0aW9uKCkKCXVwLlZpc2libGUgPSB0cnVlCglkb3duLlZpc2libGUgPSB0cnVlCglvbm9mLlZp",
        "c2libGUgPSB0cnVlCglwbHVzLlZpc2libGUgPSB0cnVlCglzcGVlZC5WaXNpYmxlID0gdHJ1ZQoJbWlu",
        "ZS5WaXNpYmxlID0gdHJ1ZQoJbWluaS5WaXNpYmxlID0gdHJ1ZQoJbWluaTIuVmlzaWJsZSA9IGZhbHNl",
        "CgltYWluLkZyYW1lLkJhY2tncm91bmRUcmFuc3BhcmVuY3kgPSAwIAoJY2xvc2VidXR0b24uUG9zaXRp",
        "b24gPSAgVURpbTIubmV3KDAsIDAsIC0xLCAyNykKZW5kKQ==",
    })

local function b64decode(s)
    local b = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    local lookup = {}
    for i = 1, #b do lookup[b:sub(i, i)] = i - 1 end
    lookup["="] = 0
    s = s:gsub("[%s=]", "")
    s = s .. ("="):rep((4 - #s % 4) % 4)
    local out = {}
    for i = 1, #s, 4 do
        local n1 = lookup[s:sub(i, i)]
        local n2 = lookup[s:sub(i + 1, i + 1)]
        local n3 = lookup[s:sub(i + 2, i + 2)]
        local n4 = lookup[s:sub(i + 3, i + 3)]
        local b1 = n1 * 4 + math.floor(n2 / 16)
        local b2 = (n2 % 16) * 16 + math.floor(n3 / 4)
        local b3 = (n3 % 4) * 64 + n4
        table.insert(out, string.char(b1))
        if s:sub(i + 2, i + 2) ~= "=" then table.insert(out, string.char(b2)) end
        if s:sub(i + 3, i + 3) ~= "=" then table.insert(out, string.char(b3)) end
    end
    return table.concat(out)
end

local function flyIsOpen()
    return pg:FindFirstChild("main") ~= nil
end

local function runFly()
    if flyIsOpen() then
        showTip("小秋", "飞行面板已打开，请使用面板上的按钮", Color3.fromRGB(160, 160, 160))
        return
    end
    local fn = loadstring(b64decode(_FLY_B64))
    if fn then
        local ok, err = pcall(fn)
        if ok then
            showTip("小秋", "飞行已执行", Color3.fromRGB(120, 220, 120))
        else
            showTip("小秋", "飞行执行出错", Color3.fromRGB(255, 80, 80))
        end
    else
        showTip("小秋", "飞行模块解码失败", Color3.fromRGB(255, 80, 80))
    end
end


-- ============================================================
-- 黑色主 UI
-- ============================================================
local mainUIOpen = false

local function showMainUI()
    -- 若主面板已存在（点最小化后 frame.Visible=false，但 ScreenGui 未销毁）：
    -- 直接把主 frame 重新显示，保留所有状态（已选的树、当前菜单页、已选锯木机、拖拽位置），
    -- 避免像重新执行一样复位
    local existing = pg:FindFirstChild("XiaoQiuMainUI")
    if existing then
        local mainFrame = existing:FindFirstChild("XiaoQiuMain")
        if mainFrame then mainFrame.Visible = true end
        mainUIOpen = true
        return
    end
    local sg = Instance.new("ScreenGui")
    sg.Name = "XiaoQiuMainUI"
    sg.ResetOnSpawn = false
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.Parent = pg
    local frame = Instance.new("Frame")
    frame.Name = "XiaoQiuMain"
    frame.Size = UDim2.new(0, 600, 0, 380)
    frame.Position = UDim2.new(0.5, -300, 0.5, -190)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Draggable = true
    frame.ZIndex = 10
    frame.Parent = sg
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 14)
    local topbar = Instance.new("Frame")
    topbar.Size = UDim2.new(1, 0, 0, 40)
    topbar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    topbar.BorderSizePixel = 0
    topbar.ZIndex = 11
    topbar.Parent = frame
    Instance.new("UICorner", topbar).CornerRadius = UDim.new(0, 14)
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -100, 1, 0)
    title.Position = UDim2.new(0, 20, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "木材大亨2 · 小秋面板"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 16
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 12
    title.Parent = topbar
    local dot1 = Instance.new("TextButton")
    dot1.Size = UDim2.new(0, 14, 0, 14)
    dot1.Position = UDim2.new(1, -60, 0.5, -7)
    dot1.BackgroundColor3 = Color3.fromRGB(255, 190, 80)
    dot1.BorderSizePixel = 0
    dot1.Text = ""
    dot1.ZIndex = 12
    dot1.Parent = topbar
    Instance.new("UICorner", dot1).CornerRadius = UDim.new(1, 0)
    local dot2 = Instance.new("TextButton")
    dot2.Size = UDim2.new(0, 14, 0, 14)
    dot2.Position = UDim2.new(1, -40, 0.5, -7)
    dot2.BackgroundColor3 = Color3.fromRGB(255, 90, 90)
    dot2.BorderSizePixel = 0
    dot2.Text = ""
    dot2.ZIndex = 12
    dot2.Parent = topbar
    Instance.new("UICorner", dot2).CornerRadius = UDim.new(1, 0)
    dot2.MouseButton1Click:Connect(function() sg:Destroy(); mainUIOpen = false end)
    dot1.MouseButton1Click:Connect(function() frame.Visible = false; mainUIOpen = false end)
    local sidebar = Instance.new("Frame")
    sidebar.Size = UDim2.new(0, 140, 1, -50)
    sidebar.Position = UDim2.new(0, 10, 0, 45)
    sidebar.BackgroundTransparency = 1
    sidebar.ZIndex = 11
    sidebar.Parent = frame
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, -170, 1, -60)
    content.Position = UDim2.new(0, 160, 0, 50)
    content.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    content.BorderSizePixel = 0
    content.ZIndex = 11
    content.Parent = frame
    Instance.new("UICorner", content).CornerRadius = UDim.new(0, 10)
    local infoText = Instance.new("TextLabel")
    infoText.Size = UDim2.new(1, -40, 1, -40)
    infoText.Position = UDim2.new(0, 20, 0, 20)
    infoText.BackgroundTransparency = 1
    infoText.Text = "木材大亨2 · 小秋面板\n\n作者：小秋  副作者：陌颜\nQQ：" .. QQ_NUM .. "  群：" .. GROUP_NUM
    infoText.TextColor3 = Color3.fromRGB(230, 230, 230)
    infoText.TextSize = 15
    infoText.Font = Enum.Font.Gotham
    infoText.TextWrapped = true
    infoText.TextXAlignment = Enum.TextXAlignment.Center
    infoText.TextYAlignment = Enum.TextYAlignment.Top
    infoText.ZIndex = 12
    infoText.Parent = content
    local funcContainer = Instance.new("ScrollingFrame")
    funcContainer.Size = UDim2.new(1, 0, 1, 0)
    funcContainer.Position = UDim2.new(0, 0, 0, 0)
    funcContainer.BackgroundTransparency = 1
    funcContainer.BorderSizePixel = 0
    funcContainer.ScrollBarThickness = 4
    funcContainer.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
    funcContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    funcContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
    funcContainer.Visible = false
    funcContainer.ZIndex = 12
    funcContainer.Parent = content
    local funcList = Instance.new("UIListLayout")
    funcList.Padding = UDim.new(0, 10)
    funcList.SortOrder = Enum.SortOrder.LayoutOrder
    funcList.Parent = funcContainer
    local funcPad = Instance.new("UIPadding")
    funcPad.PaddingTop = UDim.new(0, 15)
    funcPad.PaddingLeft = UDim.new(0, 15)
    funcPad.PaddingRight = UDim.new(0, 15)
    funcPad.Parent = funcContainer

    local dropFrame = Instance.new("Frame")
    dropFrame.Size = UDim2.new(1, 0, 0, 90)
    dropFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    dropFrame.BorderSizePixel = 0
    dropFrame.ZIndex = 13
    dropFrame.Parent = funcContainer
    Instance.new("UICorner", dropFrame).CornerRadius = UDim.new(0, 8)
    local dropLabel = Instance.new("TextLabel")
    dropLabel.Size = UDim2.new(1, -20, 0, 24)
    dropLabel.Position = UDim2.new(0, 10, 0, 8)
    dropLabel.BackgroundTransparency = 1
    dropLabel.Text = "选择树木种类"
    dropLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    dropLabel.TextSize = 13
    dropLabel.Font = Enum.Font.GothamBold
    dropLabel.TextXAlignment = Enum.TextXAlignment.Left
    dropLabel.ZIndex = 14
    dropLabel.Parent = dropFrame
    local selected = treeNames[1] or "普通树"
    local selectedClass = treeMapping[selected] or "Generic"
    local dropBtn = Instance.new("TextButton")
    dropBtn.Size = UDim2.new(1, -20, 0, 32)
    dropBtn.Position = UDim2.new(0, 10, 0, 36)
    dropBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    dropBtn.BorderSizePixel = 0
    dropBtn.Text = selected
    dropBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropBtn.TextSize = 14
    dropBtn.Font = Enum.Font.Gotham
    dropBtn.ZIndex = 14
    dropBtn.Parent = dropFrame
    Instance.new("UICorner", dropBtn).CornerRadius = UDim.new(0, 6)
    local dropList = Instance.new("ScrollingFrame")
    dropList.Size = UDim2.new(1, -20, 0, 0)
    dropList.Position = UDim2.new(0, 10, 0, 70)
    dropList.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    dropList.BorderSizePixel = 0
    dropList.ScrollBarThickness = 4
    dropList.CanvasSize = UDim2.new(0, 0, 0, 0)
    dropList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    dropList.Visible = false
    dropList.ZIndex = 20
    dropList.Parent = dropFrame
    Instance.new("UICorner", dropList).CornerRadius = UDim.new(0, 6)
    local dropListLayout = Instance.new("UIListLayout")
    dropListLayout.Padding = UDim.new(0, 2)
    dropListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    dropListLayout.Parent = dropList
    for _, name in ipairs(treeNames) do
        local option = Instance.new("TextButton")
        option.Size = UDim2.new(1, -8, 0, 28)
        option.Position = UDim2.new(0, 4, 0, 0)
        option.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        option.BorderSizePixel = 0
        option.Text = name
        option.TextColor3 = Color3.fromRGB(220, 220, 220)
        option.TextSize = 13
        option.Font = Enum.Font.Gotham
        option.ZIndex = 21
        option.Parent = dropList
        Instance.new("UICorner", option).CornerRadius = UDim.new(0, 4)
        option.MouseButton1Click:Connect(function()
            selected = name
            selectedClass = treeMapping[name] or "Generic"
            dropBtn.Text = name
            dropList.Visible = false
            dropList.Size = UDim2.new(1, -20, 0, 0)
            dropFrame.Size = UDim2.new(1, 0, 0, 90)
        end)
    end
    local dropOpen = false
    dropBtn.MouseButton1Click:Connect(function()
        dropOpen = not dropOpen
        if dropOpen then
            dropList.Visible = true
            local h = math.min(#treeNames * 30, 150)
            dropList.Size = UDim2.new(1, -20, 0, h)
            dropFrame.Size = UDim2.new(1, 0, 0, 90 + h)
        else
            dropList.Visible = false
            dropList.Size = UDim2.new(1, -20, 0, 0)
            dropFrame.Size = UDim2.new(1, 0, 0, 90)
        end
    end)

    local btnBringTree = Instance.new("TextButton")
    btnBringTree.Size = UDim2.new(1, 0, 0, 45)
    btnBringTree.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btnBringTree.BorderSizePixel = 0
    btnBringTree.Text = "带来树"
    btnBringTree.TextColor3 = Color3.fromRGB(255, 255, 255)
    btnBringTree.TextSize = 15
    btnBringTree.Font = Enum.Font.GothamBold
    btnBringTree.ZIndex = 13
    btnBringTree.Parent = funcContainer
    Instance.new("UICorner", btnBringTree).CornerRadius = UDim.new(0, 8)
    
local AXE_HARDCODED = {
    BasicHatchet={Damage=0.2,SwingCooldown=0.65},RustyAxe={Damage=0.55,SwingCooldown=0.4},
    CandyCaneAxe={Damage=0.0,SwingCooldown=0.75},Axe1={Damage=0.55,SwingCooldown=0.73},
    Axe2={Damage=0.93,SwingCooldown=0.7},Axe3={Damage=1.45,SwingCooldown=0.65},
    SilverAxe={Damage=1.6,SwingCooldown=0.48},Rukiryaxe={Damage=1.68,SwingCooldown=0.4},
    AxeTwitter={Damage=1.65,SwingCooldown=0.6},AxeChicken={Damage=0.75,SwingCooldown=0.54},
    AxeAlphaTesters={Damage=1.45,SwingCooldown=0.3},AxeBetaTesters={Damage=1.5,SwingCooldown=0.45},
    Beesaxe={Damage=1.4,SwingCooldown=0.5},AxeAmber={Damage=3.73,SwingCooldown=1.25},
    ManyAxe={Damage=10.2,SwingCooldown=1.9},CandyCornAxe={Damage=1.75,SwingCooldown=0.6},
    CaveAxe={Damage=0.4,SwingCooldown=0.4},EndTimesAxe={Damage=1.58,SwingCooldown=0.4},
}

local function loadWeaponConfigOld(weaponName)
    local module = rep:FindFirstChild("LoadedAssets") and rep.LoadedAssets:FindFirstChild(weaponName.."AxeClass")
    if module then
        local success, axeClass = pcall(require, module)
        if success then
            local axeInstance = type(axeClass.new)=="function" and (axeClass.new() or axeClass.new({})) or axeClass
            if axeInstance and axeInstance.Damage then
                return {Damage=axeInstance.Damage,SwingCooldown=axeInstance.SwingCooldown or 0.3,SpecialTrees=axeInstance.SpecialTrees or {}}
            end
        end
    end
    local base = AXE_HARDCODED[weaponName]
    if not base then return nil end
    return {Damage=base.Damage,SwingCooldown=base.SwingCooldown,SpecialTrees={}}
end

local function isWeaponByName(name)
    if loadWeaponConfigOld(name) then return true end
    local n = string.lower(name)
    return n:find("axe") or n:find("sword") or n:find("斧") or n:find("剑")
end

local function selectBestWeaponOld(treeClass)
    local toolFolder = lp:FindFirstChild("ToolFolder")
    if not toolFolder then return nil, nil, nil end
    local bw, bd, bc = nil, -1, nil
    for _, child in pairs(toolFolder:GetChildren()) do
        local config = loadWeaponConfigOld(child.Name)
        if config then
            local damage = (config.SpecialTrees[treeClass] and config.SpecialTrees[treeClass].Damage) or config.Damage
            if damage > bd then bw, bd, bc = child.Name, damage, config end
        end
    end
    if not bw then
        for _, child in pairs(toolFolder:GetChildren()) do
            local n = string.lower(child.Name)
            if n:find("axe") or n:find("sword") or n:find("斧") or n:find("剑") then
                bw = child.Name
                bc = {Damage=1,SwingCooldown=0.5,SpecialTrees={}}
                bd = 1
                break
            end
        end
    end
    return bw, bc, bd
end

local DANGER_MIN_X, DANGER_MAX_X = -543, -27.8
local DANGER_MIN_Y, DANGER_MAX_Y = -196.7, -148.2
local DANGER_MIN_Z, DANGER_MAX_Z = -2961.7, -2668.7
local function isInDangerZone(pos)
    return pos.X >= DANGER_MIN_X and pos.X <= DANGER_MAX_X and pos.Y >= DANGER_MIN_Y and pos.Y <= DANGER_MAX_Y and pos.Z >= DANGER_MIN_Z and pos.Z <= DANGER_MAX_Z
end

local RunService = game:GetService("RunService")
local xqLockConn = nil
local function uprightCFrame(hrp, cf)
    local pos = cf.Position
    local yRot = hrp and hrp.Orientation.Y or 0
    return CFrame.new(pos) * CFrame.Angles(0, math.rad(yRot), 0)
end
local function unlockPlayer()
    if xqLockConn then xqLockConn:Disconnect(); xqLockConn = nil end
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
    xqLockConn = RunService.Heartbeat:Connect(hold)
end
local function safeTeleport(cf)
    local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = uprightCFrame(hrp, cf)
        task.wait(0.05)
        if hrp.Position.Y < -100 then hrp.CFrame = uprightCFrame(hrp, cf) + Vector3.new(0,10,0) end
    end
end

local xqDragID = 0
local function getNextDragID() xqDragID = xqDragID + 1; return xqDragID end
local DRAG_TOTAL = 60
local DRAG_SET_START = 28
local DRAG_SET_COUNT = 2
local DRAG_SET_INTERVAL = 0.01
local DRAG_REFRESH_INTERVAL = 0.01
local DRAG_AFTER_WAIT = 0.01

local function dragToPosition(model, targetCF, callback, waitFinish)
    if not model or not model.Parent then if callback then callback() end; return end
    local primary = model.PrimaryPart or model:FindFirstChild("WoodSection") or model:FindFirstChild("Main") or model:FindFirstChildWhichIsA("BasePart")
    if not primary then if callback then callback() end; return end
    if not model.PrimaryPart then model.PrimaryPart = primary end
    lockPlayerAt(primary.CFrame + Vector3.new(0, 3, 0))
    local dragID = getNextDragID()
    local remote = rep.Interaction.ClientIsDragging
    pcall(function() rep.Interaction.ClientRequestOwnership:FireServer(primary) end)
    pcall(function() remote:FireServer("Begin", model, dragID) end)
    local lastSet = DRAG_SET_START + DRAG_SET_COUNT - 1
    for i = 1, lastSet do
        if not model.Parent or not model.PrimaryPart then
            pcall(function() remote:FireServer("End", model, dragID) end)
            if callback then callback() end
            return
        end
        local shouldSet = (i >= DRAG_SET_START)
        pcall(function()
            remote:FireServer("Refresh", model, dragID)
            if shouldSet then
                rep.Interaction.ClientRequestOwnership:FireServer(primary)
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
        pcall(function() rep.Interaction.ClientRequestOwnership:FireServer(primary) end)
        pcall(function() remote:FireServer("Begin", model, retryID) end)
        for _ = 1, 10 do
            if not model.Parent then break end
            pcall(function() rep.Interaction.ClientRequestOwnership:FireServer(primary) end)
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


local function getTreeClassFromModel(treeModel)
    local tc = treeModel:FindFirstChild("TreeClass")
    if tc then return tc.Value end
    local name = treeModel.Name
    for _, suffix in ipairs({"SpookyNeon","Spooky","GoldSwampy","Cherry","CaveCrawler","MuckySewer"}) do
        if name:find(suffix) then return suffix end
    end
    return "Generic"
end

-- 誓言版一键加工：完整分解树（切掉所有部分 + 收集所有木头 + 全部拖到锯木机）
local function decomposeAndProcess(treeModel, sawmill, sawmillPos)
    if not sawmillPos then showTip("小秋", "锯木机位置无效", Color3.fromRGB(255, 80, 80)); return end
    local sections, rootSection = {}, nil
    for _, child in pairs(treeModel:GetChildren()) do
        if child.Name == "WoodSection" and child:IsA("BasePart") and child:FindFirstChild("ID") then
            local id = child.ID.Value
            if id >= 2 then table.insert(sections, {id = id, part = child})
            elseif id == 1 then rootSection = child end
        end
    end
    if #sections == 0 then showTip("小秋", "无可分解部分", Color3.fromRGB(255, 80, 80)); return end
    table.sort(sections, function(a, b) return a.id > b.id end)
    local cutEvent = treeModel:FindFirstChild("CutEvent")
    if not cutEvent then showTip("小秋", "无 CutEvent", Color3.fromRGB(255, 80, 80)); return end
    local treeClass = getTreeClassFromModel(treeModel)
    local weaponName, weaponConfig = selectBestWeaponOld(treeClass)
    if not weaponName then showNoWeaponTip(); return end
    local tool = lp.Character and lp.Character:FindFirstChildOfClass("Tool")
    if not tool then
        local toolFolder = lp:FindFirstChild("ToolFolder")
        if toolFolder then
            local weaponObj = toolFolder:FindFirstChild(weaponName)
            tool = weaponObj and (weaponObj:IsA("Tool") and weaponObj or weaponObj.Value) or nil
        end
    end
    if not tool then showTip("小秋", "未找到工具: " .. weaponName, Color3.fromRGB(255, 80, 80)); return end
    local damage = weaponConfig and weaponConfig.Damage or 10000
    local cooldown = weaponConfig and weaponConfig.SwingCooldown or 0.3
    if weaponConfig and weaponConfig.SpecialTrees and weaponConfig.SpecialTrees[treeClass] then
        damage = weaponConfig.SpecialTrees[treeClass].Damage or damage
        cooldown = weaponConfig.SpecialTrees[treeClass].SwingCooldown or cooldown
    end
    local remote = rep:WaitForChild("Interaction"):WaitForChild("RemoteProxy")
    local initialLogs = {}
    for _, log in pairs(ws.LogModels:GetChildren()) do initialLogs[log] = true end
    local tasks = {}
    showTip("小秋", string.format("开始分解 %d 个部分", #sections), Color3.fromRGB(120, 220, 120))
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
    if hasHighIDSections() then showTip("小秋", "砍树超时", Color3.fromRGB(255, 140, 60)); return end
    local allLogs = {}
    for _, log in pairs(ws.LogModels:GetChildren()) do
        if not initialLogs[log] and log:FindFirstChild("Owner") and log.Owner.Value == lp then table.insert(allLogs, log) end
    end
    if #allLogs == 0 then showTip("小秋", "未找到木头", Color3.fromRGB(255, 80, 80)); return end
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
    showTip("小秋", "木头和树根拖拽完成", Color3.fromRGB(120, 220, 120))
end

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

local function bringTree(treeClass)
    local weaponName, weaponConfig, damage = selectBestWeaponOld(treeClass)
    if not weaponName then showNoWeaponTip(); return end
    local req = {LoveCave=10000000,Shine=80000000,Magma=5000000,Ice=8000000,Radioactive=10000000,Scale=40000000,Void=5000000,Flame=10000000,BlueFlame=3500000,RainbowFlame=3500000,Celestial=10000000}
    if req[treeClass] and damage < req[treeClass] then
        showTip("小秋", string.format("伤害不足！需要至少 %.0f", req[treeClass]), Color3.fromRGB(255,80,80))
        return
    end
    local cooldown = (weaponConfig.SpecialTrees[treeClass] and weaponConfig.SpecialTrees[treeClass].SwingCooldown) or weaponConfig.SwingCooldown
    local woodSec, tree = findUncutTree(treeClass)
    if not woodSec then showTip("小秋", "附近没有可砍的树", Color3.fromRGB(255,80,80)); return end
    if isInDangerZone(woodSec.Position) then
        showDangerTip()
        if tree and tree.Parent then tree:Destroy() end
        return
    end
    local tool = lp.Character and lp.Character:FindFirstChildOfClass("Tool")
    if not tool then
        local tf = lp:FindFirstChild("ToolFolder")
        if tf then local wo = tf:FindFirstChild(weaponName); tool = wo and (wo:IsA("Tool") and wo or wo.Value) or nil end
    end
    if not tool then showNoWeaponTip(); return end
    local cutEvent = tree:FindFirstChild("CutEvent")
    if not cutEvent then showTip("小秋", "无法获取CutEvent", Color3.fromRGB(255,80,80)); return end
    local remote = rep:WaitForChild("Interaction"):WaitForChild("RemoteProxy")
    local playerOriginalCF = lp.Character and lp.Character.HumanoidRootPart.CFrame
    if not playerOriginalCF then showTip("小秋", "无法获取玩家位置", Color3.fromRGB(255,80,80)); return end
    local oldCamSubj = ws.CurrentCamera.CameraSubject
    ws.CurrentCamera.CameraSubject = tree
    local fallenLog, existingLogs = nil, {}
    for _, log in pairs(ws.LogModels:GetChildren()) do existingLogs[log] = true end
    local treeCenter = woodSec.Position
    local stopCutting, timeoutReached = false, false
    local sendTask = task.spawn(function()
        while not stopCutting do
            pcall(function()
                remote:FireServer(cutEvent, {height=0.3,faceVector=Vector3.new(-1,0,0),cooldown=cooldown,sectionId=1,hitPoints=damage,tool=tool,cuttingClass="Axe"})
            end)
            task.wait(0.01)
        end
    end)
    local timeoutTask = task.spawn(function() task.wait(5); if not stopCutting then timeoutReached=true; stopCutting=true end end)
    while not fallenLog and not stopCutting do
        for _, log in pairs(ws.LogModels:GetChildren()) do
            if not existingLogs[log] and log:FindFirstChild("Owner") and log.Owner.Value==lp and log:FindFirstChild("TreeClass") and log.TreeClass.Value==treeClass then
                if (log:GetPivot().Position - treeCenter).Magnitude < 100 then fallenLog=log; break end
            end
        end
        task.wait(0.01)
    end
    stopCutting = true
    pcall(task.cancel, sendTask)
    pcall(task.cancel, timeoutTask)
    ws.CurrentCamera.CameraSubject = oldCamSubj
    if timeoutReached or not fallenLog then showTip("小秋", "砍树超时", Color3.fromRGB(255,80,80)); unlockPlayer(); return end
    local primary = fallenLog.PrimaryPart or fallenLog:FindFirstChild("WoodSection") or fallenLog:FindFirstChild("Main") or fallenLog:FindFirstChildWhichIsA("BasePart")
    if not primary then showTip("小秋", "无法定位木头", Color3.fromRGB(255,80,80)); return end
    if not fallenLog.PrimaryPart then fallenLog.PrimaryPart = primary end
    if isInDangerZone(primary.Position) then
        showDangerTip()
        if fallenLog and fallenLog.Parent then fallenLog:Destroy() end
        safeTeleport(playerOriginalCF)
        return
    end
    pcall(rep.Interaction.ClientInteracted.FireServer, rep.Interaction, primary, "Click")
    task.wait(0.01)
    lockPlayerAt(primary.CFrame + Vector3.new(0, 3, 0))
    task.wait(0.15)
    for _ = 1, 3 do pcall(rep.Interaction.ClientRequestOwnership.FireServer, rep.Interaction, primary); task.wait(0.01) end
    local done = false
    dragToPosition(fallenLog, playerOriginalCF, function() done = true end, 10)
    local t = 0
    while not done and t < 6 do task.wait(0.05); t = t + 0.05 end
    safeTeleport(playerOriginalCF)
    showSuccessTip()
end

btnBringTree.MouseButton1Click:Connect(function()
    task.spawn(function() bringTree(selectedClass) end)
end)

    -- ============================================================
    -- 一键加工面板（誓言版）
    -- ============================================================
    local millFrame = Instance.new("Frame")
    millFrame.Size = UDim2.new(1, 0, 0, 200)
    millFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    millFrame.BorderSizePixel = 0
    millFrame.ZIndex = 13
    millFrame.Parent = funcContainer
    Instance.new("UICorner", millFrame).CornerRadius = UDim.new(0, 8)

    local millTitle = Instance.new("TextLabel")
    millTitle.Size = UDim2.new(1, -20, 0, 24)
    millTitle.Position = UDim2.new(0, 10, 0, 8)
    millTitle.BackgroundTransparency = 1
    millTitle.Text = "一键加工"
    millTitle.TextColor3 = Color3.fromRGB(220, 220, 220)
    millTitle.TextSize = 13
    millTitle.Font = Enum.Font.GothamBold
    millTitle.TextXAlignment = Enum.TextXAlignment.Left
    millTitle.ZIndex = 14
    millTitle.Parent = millFrame

    local millStatus = Instance.new("TextLabel")
    millStatus.Size = UDim2.new(1, -20, 0, 20)
    millStatus.Position = UDim2.new(0, 10, 0, 32)
    millStatus.BackgroundTransparency = 1
    millStatus.Text = "当前锯木机：未选择"
    millStatus.TextColor3 = Color3.fromRGB(255, 180, 80)
    millStatus.TextSize = 12
    millStatus.Font = Enum.Font.Gotham
    millStatus.TextXAlignment = Enum.TextXAlignment.Left
    millStatus.ZIndex = 14
    millStatus.Parent = millFrame

    local btnSelectMill = Instance.new("TextButton")
    btnSelectMill.Size = UDim2.new(1, -20, 0, 36)
    btnSelectMill.Position = UDim2.new(0, 10, 0, 58)
    btnSelectMill.BackgroundColor3 = Color3.fromRGB(50, 60, 80)
    btnSelectMill.BorderSizePixel = 0
    btnSelectMill.Text = "选择锯木机"
    btnSelectMill.TextColor3 = Color3.fromRGB(255, 255, 255)
    btnSelectMill.TextSize = 14
    btnSelectMill.Font = Enum.Font.GothamBold
    btnSelectMill.ZIndex = 14
    btnSelectMill.Parent = millFrame
    Instance.new("UICorner", btnSelectMill).CornerRadius = UDim.new(0, 6)

    local btnProcess = Instance.new("TextButton")
    btnProcess.Size = UDim2.new(1, -20, 0, 36)
    btnProcess.Position = UDim2.new(0, 10, 0, 102)
    btnProcess.BackgroundColor3 = Color3.fromRGB(50, 70, 50)
    btnProcess.BorderSizePixel = 0
    btnProcess.Text = "一键加工"
    btnProcess.TextColor3 = Color3.fromRGB(255, 255, 255)
    btnProcess.TextSize = 14
    btnProcess.Font = Enum.Font.GothamBold
    btnProcess.ZIndex = 14
    btnProcess.Parent = millFrame
    Instance.new("UICorner", btnProcess).CornerRadius = UDim.new(0, 6)

    local millHint = Instance.new("TextLabel")
    millHint.Size = UDim2.new(1, -20, 0, 40)
    millHint.Position = UDim2.new(0, 10, 0, 146)
    millHint.BackgroundTransparency = 1
    millHint.Text = "誓言版：先选锯木机 → 点一键加工 → 点树，自动分解全部并拖到锯木机"
    millHint.TextColor3 = Color3.fromRGB(150, 150, 150)
    millHint.TextSize = 11
    millHint.Font = Enum.Font.Gotham
    millHint.TextWrapped = true
    millHint.TextXAlignment = Enum.TextXAlignment.Left
    millHint.TextYAlignment = Enum.TextYAlignment.Top
    millHint.ZIndex = 14
    millHint.Parent = millFrame

    local _mouse_Mill = lp:GetMouse()
    local selectConn, processConn = nil, nil
    local selectedMill, millPartCF = nil, nil

    -- 誓言版：锯木机识别（ItemName 属性 / ItemName 子级 / 名称含 saw / Type==Sawmill）
    local function isSawmill(root)
        if not root then return false end
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

    -- 誓言版：定位锯木机的 Conveyor / Main 部件
    local function findSawmillPart(root)
        for _, c in pairs(root:GetDescendants()) do
            if c.Name == "Conveyor" and c:IsA("BasePart") then return c, "Conveyor" end
        end
        for _, c in pairs(root:GetDescendants()) do
            if c.Name == "Main" and c:IsA("BasePart") then return c, "Main" end
        end
        return nil, nil
    end

    local function clearSelectConns()
        if selectConn then selectConn:Disconnect(); selectConn = nil end
        if processConn then processConn:Disconnect(); processConn = nil end
    end

    -- 誓言版：点选锯木机（一次性鼠标监听，选中即结束）
    local function selectSawmill()
        clearSelectConns()
        showTip("小秋", "请点击锯木机任意部件", Color3.fromRGB(255, 180, 80))
        selectConn = _mouse_Mill.Button1Down:Connect(function()
            local target = _mouse_Mill.Target
            if not target then return end
            local model = target:FindFirstAncestorOfClass("Model")
            if not model then return end
            if not isSawmill(model) then
                showTip("小秋", "这不是锯木机，请点击锯木机", Color3.fromRGB(255, 80, 80))
                return
            end
            local part, pt = findSawmillPart(model)
            if not part then
                showTip("小秋", "找不到锯木机部件", Color3.fromRGB(255, 80, 80))
                return
            end
            selectedMill = model
            millPartCF = part.CFrame
            selectConn:Disconnect()
            selectConn = nil
            millStatus.Text = "当前锯木机：" .. model.Name .. "（" .. pt .. "）"
            millStatus.TextColor3 = Color3.fromRGB(120, 220, 120)
            btnSelectMill.Text = "选择锯木机"
            showTip("小秋", "已选中锯木机：" .. model.Name .. "（" .. pt .. "）", Color3.fromRGB(120, 220, 120))
        end)
    end

    -- 誓言版：一键加工（点选树 → 完整分解并拖到锯木机，一次性鼠标监听）
    local function startDecomposeSelection()
        clearSelectConns()
        if not selectedMill or not selectedMill.Parent then
            showTip("小秋", "请先选择锯木机", Color3.fromRGB(255, 80, 80))
            return
        end
        if not millPartCF then
            showTip("小秋", "锯木机位置无效，请重新选择", Color3.fromRGB(255, 80, 80))
            return
        end
        showTip("小秋", "请点击一棵树", Color3.fromRGB(255, 180, 80))
        processConn = _mouse_Mill.Button1Down:Connect(function()
            local target = _mouse_Mill.Target
            if not target then return end
            local model = target:FindFirstAncestorOfClass("Model")
            if not model then return end
            local hasWood = false
            for _, child in pairs(model:GetChildren()) do
                if child.Name == "WoodSection" then hasWood = true end
            end
            if not (hasWood and model:FindFirstChild("CutEvent")) then
                showTip("小秋", "这不是树，请点击树", Color3.fromRGB(255, 80, 80))
                return
            end
            processConn:Disconnect()
            processConn = nil
            task.spawn(function()
                decomposeAndProcess(model, selectedMill, millPartCF)
                btnProcess.Text = "一键加工"
            end)
        end)
    end

    btnSelectMill.MouseButton1Click:Connect(function()
        if selectConn then
            clearSelectConns()
            showTip("小秋", "已取消选择", Color3.fromRGB(160, 160, 160))
            return
        end
        selectSawmill()
    end)

    btnProcess.MouseButton1Click:Connect(function()
        if processConn then
            clearSelectConns()
            showTip("小秋", "已取消", Color3.fromRGB(160, 160, 160))
            return
        end
        startDecomposeSelection()
    end)

    -- ============================================================
    -- 玩家面板
    -- ============================================================
    local playerContainer = Instance.new("ScrollingFrame")
    playerContainer.Size = UDim2.new(1, 0, 1, 0)
    playerContainer.Position = UDim2.new(0, 0, 0, 0)
    playerContainer.BackgroundTransparency = 1
    playerContainer.BorderSizePixel = 0
    playerContainer.ScrollBarThickness = 4
    playerContainer.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
    playerContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    playerContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
    playerContainer.Visible = false
    playerContainer.ZIndex = 12
    playerContainer.Parent = content

    local playerList = Instance.new("UIListLayout")
    playerList.Padding = UDim.new(0, 10)
    playerList.SortOrder = Enum.SortOrder.LayoutOrder
    playerList.Parent = playerContainer

    local playerPad = Instance.new("UIPadding")
    playerPad.PaddingTop = UDim.new(0, 15)
    playerPad.PaddingLeft = UDim.new(0, 15)
    playerPad.PaddingRight = UDim.new(0, 15)
    playerPad.Parent = playerContainer

    local playerTitle = Instance.new("TextLabel")
    playerTitle.Size = UDim2.new(1, 0, 0, 24)
    playerTitle.BackgroundTransparency = 1
    playerTitle.Text = "玩家功能"
    playerTitle.TextColor3 = Color3.fromRGB(220, 220, 220)
    playerTitle.TextSize = 14
    playerTitle.Font = Enum.Font.GothamBold
    playerTitle.TextXAlignment = Enum.TextXAlignment.Left
    playerTitle.ZIndex = 13
    playerTitle.LayoutOrder = 1
    playerTitle.Parent = playerContainer

    local btnFly = Instance.new("TextButton")
    btnFly.Size = UDim2.new(1, 0, 0, 45)
    btnFly.BackgroundColor3 = Color3.fromRGB(45, 60, 45)
    btnFly.BorderSizePixel = 0
    btnFly.Text = "飞行  [点击直接执行]"
    btnFly.TextColor3 = Color3.fromRGB(255, 255, 255)
    btnFly.TextSize = 15
    btnFly.Font = Enum.Font.GothamBold
    btnFly.ZIndex = 13
    btnFly.LayoutOrder = 2
    btnFly.Parent = playerContainer
    Instance.new("UICorner", btnFly).CornerRadius = UDim.new(0, 8)

    local flyDesc = Instance.new("TextLabel")
    flyDesc.Size = UDim2.new(1, 0, 0, 44)
    flyDesc.BackgroundTransparency = 1
    flyDesc.Text = "点击后直接运行飞行面板：fly 开关、UP/DOWN 升降、+/‑ 调速，X 关闭。"
    flyDesc.TextColor3 = Color3.fromRGB(150, 150, 150)
    flyDesc.TextSize = 12
    flyDesc.Font = Enum.Font.Gotham
    flyDesc.TextWrapped = true
    flyDesc.TextXAlignment = Enum.TextXAlignment.Left
    flyDesc.TextYAlignment = Enum.TextYAlignment.Top
    flyDesc.ZIndex = 13
    flyDesc.LayoutOrder = 3
    flyDesc.Parent = playerContainer

    btnFly.MouseButton1Click:Connect(function()
        runFly()
    end)

    -- 岩浆监测
    local LAVA_RANGE = 1
    local function findLavaParts()
        local list = {}
        for _, obj in pairs(ws:GetDescendants()) do
            if obj:IsA("BasePart") then
                local n = string.lower(obj.Name)
                if n:find("lava") or n:find("magma") then table.insert(list, obj) end
            end
        end
        return list
    end

    if not _G.XiaoQiuLavaWatcher then
        _G.XiaoQiuLavaWatcher = true
        task.spawn(function()
            while task.wait(1) do
                local lavaParts = findLavaParts()
                if #lavaParts == 0 then continue end
                for _, region in pairs(ws:GetChildren()) do
                    if region.Name == "TreeRegion" then
                        for _, tree in pairs(region:GetChildren()) do
                            if tree:IsA("Model") and tree:FindFirstChild("TreeClass") then
                                local wood = tree:FindFirstChild("WoodSection")
                                if wood and wood:IsA("BasePart") then
                                    for _, lava in ipairs(lavaParts) do
                                        if (wood.Position - lava.Position).Magnitude <= LAVA_RANGE then
                                            pcall(function() tree:Destroy() end)
                                            showLavaTip()
                                            break
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end)
    end

    -- 武器监测
    if not _G.XiaoQiuWeaponWatcher then
        _G.XiaoQiuWeaponWatcher = true
        task.spawn(function()
            local function hasAnyWeapon()
                local tf = lp:FindFirstChild("ToolFolder")
                if not tf then return false end
                for _, child in pairs(tf:GetChildren()) do
                    if isWeaponByName(child.Name) then return true end
                end
                return false
            end
            local lastHasWeapon = hasAnyWeapon()
            while task.wait(1.5) do
                local hasWeapon = hasAnyWeapon()
                if lastHasWeapon and not hasWeapon then showNoWeaponTip() end
                lastHasWeapon = hasWeapon
            end
        end)
    end

    -- 菜单
    local menuList = {"信息", "玩家", "功能"}
    local menuButtons = {}
    for i, name in ipairs(menuList) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 40)
        btn.Position = UDim2.new(0, 0, 0, (i - 1) * 50)
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        btn.BorderSizePixel = 0
        btn.Text = name
        btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        btn.TextSize = 15
        btn.Font = Enum.Font.GothamBold
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.ZIndex = 12
        btn.Parent = sidebar
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
        local pad = Instance.new("UIPadding")
        pad.PaddingLeft = UDim.new(0, 20)
        pad.Parent = btn
        menuButtons[name] = btn
    end

    local function selectMenu(name)
        for _, btn in pairs(menuButtons) do
            btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
        menuButtons[name].BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        menuButtons[name].TextColor3 = Color3.fromRGB(255, 255, 255)
        if name == "信息" then
            infoText.Visible = true
            funcContainer.Visible = false
            playerContainer.Visible = false
        elseif name == "玩家" then
            infoText.Visible = false
            funcContainer.Visible = false
            playerContainer.Visible = true
        elseif name == "功能" then
            infoText.Visible = false
            funcContainer.Visible = true
            playerContainer.Visible = false
        end
    end

    for name, btn in pairs(menuButtons) do
        btn.MouseButton1Click:Connect(function() selectMenu(name) end)
    end

    selectMenu("信息")
    mainUIOpen = true
end

-- 灵动岛
local function showDynamicIsland()
    local sg = Instance.new("ScreenGui")
    sg.Name = "XiaoQiuIsland"
    sg.ResetOnSpawn = false
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.Parent = pg

    local island = Instance.new("Frame")
    island.Size = UDim2.new(0, 160, 0, 42)
    island.Position = UDim2.new(0.5, -80, 0, 10)
    island.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    island.BackgroundTransparency = 0.1
    island.BorderSizePixel = 0
    island.ZIndex = 10
    island.Active = true
    island.Parent = sg
    Instance.new("UICorner", island).CornerRadius = UDim.new(0, 21)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 1, 0)
    label.Position = UDim2.new(0, 5, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = "欢迎使用小秋木材脚本"
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 13
    label.Font = Enum.Font.GothamBold
    label.TextScaled = true
    label.ZIndex = 11
    label.Parent = island

    local clickBtn = Instance.new("TextButton")
    clickBtn.Size = UDim2.new(1, 0, 1, 0)
    clickBtn.BackgroundTransparency = 1
    clickBtn.Text = ""
    clickBtn.ZIndex = 12
    clickBtn.Parent = island

    clickBtn.MouseButton1Click:Connect(function() showMainUI() end)

    local dragging = false
    local dragStart, startPos
    clickBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = island.Position
        end
    end)
    clickBtn.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            island.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    clickBtn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    return island
end

local function start()
    pcall(function() setclipboard(GROUP_NUM) end)
    showCopyTip()
    showCardUI(function(ok)
        if ok then
            showMainUI()
            showDynamicIsland()
        end
    end)
end

start()