local lp = game:GetService("Players").LocalPlayer
local pg = lp:WaitForChild("PlayerGui")

local hidden = false
local conns = {}

local sg = Instance.new("ScreenGui")
sg.Name = "XiaoQiuInvis"
sg.ResetOnSpawn = false
sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
sg.Parent = pg

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0, 110, 0, 44)
btn.Position = UDim2.new(0, 20, 0, 260)
btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
btn.BorderSizePixel = 0
btn.Text = "隐身 [关]"
btn.TextColor3 = Color3.fromRGB(20, 20, 20)
btn.TextSize = 15
btn.Font = Enum.Font.GothamBold
btn.Active = true
btn.Parent = sg
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
local st = Instance.new("UIStroke", btn)
st.Color = Color3.fromRGB(200, 200, 200)
st.Thickness = 1

local dragging = false
local dragStart, startPos

btn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = btn.Position
    end
end)

btn.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        btn.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

btn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

local function setInvisible(state)
    for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
    conns = {}
    local char = lp.Character
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") or part:IsA("Decal") then
            if state then
                part.LocalTransparencyModifier = 1
                pcall(function() part.Transparency = 1 end)
            else
                part.LocalTransparencyModifier = 0
            end
        end
    end
    if state then
        local c1 = char.DescendantAdded:Connect(function(d)
            if d:IsA("BasePart") or d:IsA("Decal") then
                d.LocalTransparencyModifier = 1
                pcall(function() d.Transparency = 1 end)
            end
        end)
        table.insert(conns, c1)
        local c2 = game:GetService("RunService").RenderStepped:Connect(function()
            local c = lp.Character
            if not c then return end
            for _, p in ipairs(c:GetDescendants()) do
                if p:IsA("BasePart") or p:IsA("Decal") then
                    p.LocalTransparencyModifier = 1
                end
            end
        end)
        table.insert(conns, c2)
    end
end

lp.CharacterAdded:Connect(function()
    task.wait(0.5)
    if hidden then setInvisible(true) end
end)

btn.MouseButton1Click:Connect(function()
    if dragging then return end
    hidden = not hidden
    setInvisible(hidden)
    if hidden then
        btn.Text = "隐身 [开]"
        btn.BackgroundColor3 = Color3.fromRGB(40, 180, 60)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    else
        btn.Text = "隐身 [关]"
        btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextColor3 = Color3.fromRGB(20, 20, 20)
    end
end)
