local W=loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local P,R,U,WS,LT,TP,MS=game:GetService("Players"),game:GetService("RunService"),game:GetService("UserInputService"),workspace,game:GetService("Lighting"),game:GetService("TeleportService"),game:GetService("MarketplaceService")
local L,C=P.LocalPlayer,WS.CurrentCamera
local M=U.TouchEnabled and not U.KeyboardEnabled
local S={WSv=16,FS=50,VFS=80,AF=150,Smooth=3,Prediction=0.15,AimReal=true,AimNPC=false,SFv=120,DFm=70,DFM=130,curFX="无",spin=false,spinSpeed=360,ShowFPS=false,Marquee=false}
local function ch()return L.Character end
local function hm()local c=ch()return c and c:FindFirstChildOfClass("Humanoid")end
local function rt()local c=ch()return c and c:FindFirstChild("HumanoidRootPart")end
local function nt(t,c)W:Notify({Title=t,Content=c,Icon="check",Duration=3})end
local function NM()local n={}for _,p in ipairs(P:GetPlayers())do if p~=L then n[#n+1]=p.Name end end return n end
local function lp(k,f,w)task.spawn(function()while S[k]do pcall(f)task.wait(w or .5)end end)end

local F={}
F.sta=function()local c=ch()if c then for _,v in ipairs(c:GetDescendants())do if v:IsA("Script")and v.Name:lower():find("stamina")then v.Disabled=true end end end end
F.hun=function()local g=L:FindFirstChild("PlayerGui")if g then for _,v in ipairs(g:GetDescendants())do if v:IsA("Script")and v.Name:lower():find("hunger")then v.Disabled=true end end end end
F.fall=function()local c=ch()if c then local x=c:FindFirstChild("Freefall")if x then x.Disabled=true end local h=hm()if h then h:SetStateEnabled(Enum.HumanoidStateType.FallingDown,false)end end end
F.rag=function()local c=ch()if c then local h=hm()if h then h:SetStateEnabled(Enum.HumanoidStateType.Physics,false)h:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,false)end for _,v in ipairs(c:GetDescendants())do if v:IsA("Script")and v.Name:lower():find("ragdoll")then v.Disabled=true end end end end
F.clip=function()local c=ch()if c then for _,v in ipairs(c:GetDescendants())do if v:IsA("BasePart")then v.CanCollide=false end end end end
F.inv=function()local c=ch()if c then for _,v in ipairs(c:GetDescendants())do if v:IsA("BasePart")then v.LocalTransparencyModifier=1 end if v:IsA("Decal")then v.Transparency=1 end end end end
F.spd=function()local h=hm()if h then h.WalkSpeed=S.WSv end end

local FXFolder,FXConn
local function clearFX()
    if FXConn then FXConn:Disconnect() FXConn=nil end
    if FXFolder then FXFolder:Destroy() FXFolder=nil end
end
local function newFXPart(shape,size,color,transp)
    local p=Instance.new("Part")
    p.Shape=shape or Enum.PartType.Block
    p.Size=size
    p.Color=color
    p.Transparency=transp or 0
    p.Material=Enum.Material.Neon
    p.Anchored=true
    p.CanCollide=false
    p.CastShadow=false
    p.Massless=true
    p.Parent=FXFolder
    return p
end
local function applyFX(name)
    clearFX()
    S.curFX=name
    if name=="无" then return end
    local c=ch() if not c then return end
    local r=rt() if not r then return end
    FXFolder=Instance.new("Folder",c)
    FXFolder.Name="AceFX"
    if name=="头顶光环" then
        local ring=newFXPart(Enum.PartType.Cylinder,Vector3.new(0.12,2.6,2.6),Color3.fromRGB(255,215,0))
        FXConn=R.Heartbeat:Connect(function()
            local hd=c:FindFirstChild("Head")
            if hd and ring.Parent then
                ring.CFrame=hd.CFrame*CFrame.new(0,1.3,0)*CFrame.Angles(0,0,math.rad(90))*CFrame.Angles(0,tick()*1.5,0)
            end
        end)
    elseif name=="环绕光球" then
        local parts={}
        for i=1,4 do
            parts[i]=newFXPart(Enum.PartType.Ball,Vector3.new(0.55,0.55,0.55),Color3.fromHSV((i-1)/4,1,1))
        end
        FXConn=R.Heartbeat:Connect(function()
            local rr=rt() if not rr or not rr.Parent then return end
            local t=tick()*2
            for i,p in ipairs(parts) do
                if not p.Parent then return end
                local a=t+(i-1)*math.pi/2
                p.CFrame=rr.CFrame*CFrame.new(math.cos(a)*3.2,0.5,math.sin(a)*3.2)
            end
        end)
    elseif name=="能量翅膀" then
        local wings={}
        for i,side in ipairs({-1,1}) do
            local w=newFXPart(Enum.PartType.Block,Vector3.new(0.15,3.2,2),Color3.fromRGB(120,200,255),0.25)
            wings[i]=w
        end
        FXConn=R.Heartbeat:Connect(function()
            local rr=rt() if not rr then return end
            local flap=math.sin(tick()*3)*0.15
            local base=rr.CFrame*CFrame.new(0,0.5,1.2)*CFrame.Angles(0,math.rad(180),0)
            wings[1].CFrame=base*CFrame.new(-1.6,0,0)*CFrame.Angles(math.rad(20+flap*30),0,math.rad(-15))
            wings[2].CFrame=base*CFrame.new(1.6,0,0)*CFrame.Angles(math.rad(20+flap*30),0,math.rad(15))
        end)
    elseif name=="脚踏法阵" then
        local ring=newFXPart(Enum.PartType.Cylinder,Vector3.new(0.1,5,5),Color3.fromRGB(120,80,255),0.3)
        local inner=newFXPart(Enum.PartType.Cylinder,Vector3.new(0.1,3,3),Color3.fromRGB(200,150,255),0.5)
        FXConn=R.Heartbeat:Connect(function()
            local rr=rt() if not rr then return end
            ring.CFrame=rr.CFrame*CFrame.new(0,-3,0)*CFrame.Angles(0,0,math.rad(90))*CFrame.Angles(0,tick()*1.5,0)
            inner.CFrame=rr.CFrame*CFrame.new(0,-3,0)*CFrame.Angles(0,0,math.rad(90))*CFrame.Angles(0,-tick()*2.5,0)
        end)
    elseif name=="全身霓虹" then
        local origColors={}
        for _,p in ipairs(c:GetDescendants()) do
            if p:IsA("BasePart") and p.Name~="HumanoidRootPart" then
                origColors[p]=p.Color
                p.Material=Enum.Material.Neon
            end
        end
        FXConn=R.Heartbeat:Connect(function()
            local hue=(tick()*0.4)%1
            for p,_ in pairs(origColors) do
                if p.Parent then p.Color=Color3.fromHSV(hue,0.8,1) end
            end
        end)
    elseif name=="残影幻影" then
        local lastPos=nil
        FXConn=R.Heartbeat:Connect(function()
            local rr=rt() if not rr then return end
            if lastPos and (rr.Position-lastPos).Magnitude>4 then
                lastPos=rr.Position
                local g=Instance.new("Part")
                g.Size=Vector3.new(2,4,1)
                g.CFrame=rr.CFrame
                g.Color=Color3.fromRGB(120,200,255)
                g.Material=Enum.Material.ForceField
                g.Transparency=0.5
                g.CanCollide=false
                g.Anchored=true
                g.CastShadow=false
                g.Parent=FXFolder
                task.delay(1.5,function()
                    for i=1,10 do
                        if g.Parent then g.Transparency=0.5+i*0.05 end
                        task.wait(0.05)
                    end
                    g:Destroy()
                end)
            else
                lastPos=rr.Position
            end
        end)
    end
end

-- ==================== 武器预设 ====================
local WeaponPresets = {
    ["暗黑魔剑"]  = {primary=Color3.fromRGB(15,15,22), accent=Color3.fromRGB(220,20,60),  glow=Color3.fromRGB(255,40,80)},
    ["血刃"]      = {primary=Color3.fromRGB(25,0,0),   accent=Color3.fromRGB(255,20,20),  glow=Color3.fromRGB(255,50,50)},
    ["冰霜之刃"]  = {primary=Color3.fromRGB(180,220,255),accent=Color3.fromRGB(100,200,255),glow=Color3.fromRGB(150,220,255)},
    ["黄金圣剑"]  = {primary=Color3.fromRGB(200,160,20),accent=Color3.fromRGB(255,220,80), glow=Color3.fromRGB(255,240,120)},
    ["虚空之刃"]  = {primary=Color3.fromRGB(50,20,80),  accent=Color3.fromRGB(180,80,255), glow=Color3.fromRGB(200,120,255)},
    ["雷电之剑"]  = {primary=Color3.fromRGB(40,40,60),  accent=Color3.fromRGB(120,220,255),glow=Color3.fromRGB(180,240,255)},
    ["翡翠长剑"]  = {primary=Color3.fromRGB(20,50,30),  accent=Color3.fromRGB(80,255,150), glow=Color3.fromRGB(120,255,180)},
}

local RingPresets = {
    ["无"]       = nil,
    ["金色光环"]  = {color=Color3.fromRGB(255,215,0),  size=5,  thickness=0.15, count=1, tilt=0},
    ["符文之环"]  = {color=Color3.fromRGB(180,80,255), size=5.5, thickness=0.08, count=1, tilt=0, runes=true},
    ["双层能量环"]= {color=Color3.fromRGB(80,200,255), size=5.5, thickness=0.1,  count=2, tilt=15},
    ["暗黑魔王环"]= {color=Color3.fromRGB(220,20,60),  size=6,  thickness=0.12, count=3, tilt=25, runes=true},
}

local SwordFolder, SwordConn, RingFolder, RingConn
local SwordParts = {}
local RingParts = {}
local SfxCfg = {Enabled=false, RingEnabled=false, WeaponType="暗黑魔剑", RingType="双层能量环", Count=3, Radius=4.5, Height=1.5, Speed=2}

local function clearSwords()
    if SwordConn then SwordConn:Disconnect() SwordConn=nil end
    if SwordFolder then SwordFolder:Destroy() SwordFolder=nil end
    SwordParts = {}
end
local function clearRings()
    if RingConn then RingConn:Disconnect() RingConn=nil end
    if RingFolder then RingFolder:Destroy() RingFolder=nil end
    RingParts = {}
end

local function createAdvancedSword(preset)
    local model = Instance.new("Model")
    model.Name = "AceSword"
    model.Parent = SwordFolder
    local parts = {}

    local function addPart(size, color, material, offset, rot, shape)
        local p = Instance.new(shape == "Wedge" and "WedgePart" or "Part")
        p.Size = size
        p.Color = color
        p.Material = material or Enum.Material.Metal
        p.Anchored = true
        p.CanCollide = false
        p.CastShadow = false
        p.Massless = true
        if shape and shape ~= "Wedge" then p.Shape = Enum.PartType[shape] end
        p.Parent = model
        table.insert(parts, {part=p, offset=offset, rot=rot or CFrame.new()})
        return p
    end

    local c1 = preset.primary
    local c2 = preset.accent
    local c3 = preset.glow

    addPart(Vector3.new(0.55, 0.18, 1.2), c1, Enum.Material.Metal, Vector3.new(0,0,-3.6))
    addPart(Vector3.new(0.75, 0.22, 1.4), c1, Enum.Material.Metal, Vector3.new(0,0,-2.3))
    addPart(Vector3.new(0.95, 0.26, 1.4), c1, Enum.Material.Metal, Vector3.new(0,0,-0.9))
    addPart(Vector3.new(1.05, 0.30, 1.4), c1, Enum.Material.Metal, Vector3.new(0,0,0.5))
    addPart(Vector3.new(0.90, 0.30, 1.3), c1, Enum.Material.Metal, Vector3.new(0,0,1.8))
    addPart(Vector3.new(0.5, 0.18, 0.9), c1, Enum.Material.Metal, Vector3.new(0,0,-4.7), CFrame.Angles(math.rad(-90),0,0), "Wedge")

    local edgeZ = {-3.6, -2.3, -0.9, 0.5, 1.8}
    for i, z in ipairs(edgeZ) do
        local t = 0.32 + i * 0.05
        addPart(Vector3.new(0.06, 0.28, 1.35), c2, Enum.Material.Neon, Vector3.new( t, 0, z))
        addPart(Vector3.new(0.06, 0.28, 1.35), c2, Enum.Material.Neon, Vector3.new(-t, 0, z))
    end

    addPart(Vector3.new(0.08, 0.32, 5.5), c3, Enum.Material.Neon, Vector3.new(0,0,-0.9))

    for i, z in ipairs({-3.4, -2.1, -0.7, 0.7, 2.0}) do
        local sz = 0.45 + (i-1) * 0.08
        addPart(Vector3.new(0.06, sz, 0.4), c1, Enum.Material.Metal, Vector3.new(0.45, 0, z), CFrame.Angles(0,0,math.rad(-35)))
        addPart(Vector3.new(0.06, sz, 0.4), c1, Enum.Material.Metal, Vector3.new(-0.45, 0, z), CFrame.Angles(0,0,math.rad(35)))
    end

    addPart(Vector3.new(3.4, 0.40, 0.55), c1, Enum.Material.Metal, Vector3.new(0,0,2.85))
    addPart(Vector3.new(2.4, 0.30, 0.45), c1, Enum.Material.Metal, Vector3.new(0,0,3.15))
    addPart(Vector3.new(3.5, 0.08, 0.08), c2, Enum.Material.Neon, Vector3.new(0, 0.24, 2.85))
    addPart(Vector3.new(3.5, 0.08, 0.08), c2, Enum.Material.Neon, Vector3.new(0,-0.24, 2.85))
    addPart(Vector3.new(0.4, 0.4, 0.4), c3, Enum.Material.Neon, Vector3.new( 1.85, 0, 2.85), nil, "Ball")
    addPart(Vector3.new(0.4, 0.4, 0.4), c3, Enum.Material.Neon, Vector3.new(-1.85, 0, 2.85), nil, "Ball")

    addPart(Vector3.new(0.32, 0.32, 1.6), Color3.fromRGB(25,25,30), Enum.Material.Metal, Vector3.new(0,0,4.2))
    for i=1,5 do
        addPart(Vector3.new(0.36, 0.36, 0.12), Color3.fromRGB(70,35,35), Enum.Material.Fabric, Vector3.new(0,0,3.5 + i*0.28))
    end
    addPart(Vector3.new(0.55, 0.55, 0.55), c3, Enum.Material.Neon, Vector3.new(0,0,5.3), nil, "Ball")
    addPart(Vector3.new(0.3, 0.3, 0.3), c2, Enum.Material.Neon, Vector3.new(0,0,5.7), nil, "Ball")

    return {model=model, parts=parts}
end

local function updateSword(sw, baseCF)
    for _, item in ipairs(sw.parts) do
        item.part.CFrame = baseCF * CFrame.new(item.offset) * item.rot
    end
end

local function startSwords()
    clearSwords()
    local c = ch() if not c then return end
    local r = c:FindFirstChild("HumanoidRootPart")
    if not r then return end
    SwordFolder = Instance.new("Folder", WS)
    SwordFolder.Name = "AceSwords"

    local preset = WeaponPresets[SfxCfg.WeaponType] or WeaponPresets["暗黑魔剑"]

    for i = 1, SfxCfg.Count do
        local sw = createAdvancedSword(preset)
        table.insert(SwordParts, sw)
    end

    SwordConn = R.Heartbeat:Connect(function()
        if not SfxCfg.Enabled then return end
        local cc = ch() if not cc then return end
        local rr = cc:FindFirstChild("HumanoidRootPart")
        if not rr then return end
        local t = tick() * SfxCfg.Speed
        for i, sw in ipairs(SwordParts) do
            if not sw.parts[1].part.Parent then return end
            local angle = t + (i-1) * (2*math.pi / #SwordParts)
            local ox = math.cos(angle) * SfxCfg.Radius
            local oz = math.sin(angle) * SfxCfg.Radius
            local oy = math.sin(t*2 + i) * 0.4 + SfxCfg.Height
            local radial = Vector3.new(math.cos(angle), 0, math.sin(angle))
            local newCF = CFrame.new(rr.Position + Vector3.new(ox, oy, oz))
            newCF = CFrame.lookAt(newCF.Position, newCF.Position + radial)
            newCF = newCF * CFrame.Angles(math.rad(75), 0, math.rad(15))
            updateSword(sw, newCF)
        end
    end)
end

local function stopSwords()
    SfxCfg.Enabled = false
    clearSwords()
end

-- ==================== 背环 ====================
local function createRing(preset, layer)
    local model = Instance.new("Model")
    model.Name = "AceRing"
    model.Parent = RingFolder
    local parts = {}

    local function addPart(size, color, material, offset, rot, shape, transp)
        local p = Instance.new("Part")
        p.Size = size
        p.Color = color
        p.Material = material or Enum.Material.Neon
        p.Transparency = transp or 0
        p.Anchored = true
        p.CanCollide = false
        p.CastShadow = false
        p.Massless = true
        if shape then p.Shape = Enum.PartType[shape] end
        p.Parent = model
        table.insert(parts, {part=p, offset=offset, rot=rot or CFrame.new()})
        return p
    end

    local size = preset.size - layer * 0.6
    local thickness = preset.thickness
    local color = preset.color

    local segCount = 24
    for i = 1, segCount do
        local angle = (i-1) * (2*math.pi / segCount)
        local x = math.cos(angle) * size / 2
        local z = math.sin(angle) * size / 2
        addPart(Vector3.new(0.5, thickness, thickness), color, Enum.Material.Neon,
            Vector3.new(x, 0, z), CFrame.Angles(0, -angle, 0))
    end

    if preset.runes then
        for i = 1, 6 do
            local angle = (i-1) * (math.pi/3) + layer * 0.3
            local x = math.cos(angle) * size / 2
            local z = math.sin(angle) * size / 2
            addPart(Vector3.new(0.15, 0.6, 0.15), Color3.fromRGB(255,255,255), Enum.Material.Neon,
                Vector3.new(x, 0, z), CFrame.Angles(0, -angle, 0))
        end
    end

    return {model=model, parts=parts, size=size}
end

local function updateRing(ring, baseCF)
    for _, item in ipairs(ring.parts) do
        item.part.CFrame = baseCF * CFrame.new(item.offset) * item.rot
    end
end

local function startRings()
    clearRings()
    local c = ch() if not c then return end
    local r = c:FindFirstChild("HumanoidRootPart")
    if not r then return end
    local preset = RingPresets[SfxCfg.RingType]
    if not preset then return end

    RingFolder = Instance.new("Folder", WS)
    RingFolder.Name = "AceRings"

    for layer = 0, preset.count - 1 do
        local ring = createRing(preset, layer)
        ring.layer = layer
        table.insert(RingParts, ring)
    end

    RingConn = R.Heartbeat:Connect(function()
        if not SfxCfg.RingEnabled then return end
        local cc = ch() if not cc then return end
        local rr = cc:FindFirstChild("HumanoidRootPart")
        if not rr then return end
        local totalRings = #RingParts
        if totalRings == 0 then return end
        local t = tick() * 1.5
        for i, ring in ipairs(RingParts) do
            if not ring.parts[1].part.Parent then return end
            local angle = t + (i-1) * (2*math.pi / totalRings)
            local orbitRadius = 2.5 + (i-1) * 0.6
            local height = 2.5
            local ox = math.cos(angle) * orbitRadius
            local oz = math.sin(angle) * orbitRadius
            local pos = rr.Position + Vector3.new(ox, height, oz)
            local baseCF = CFrame.new(pos) * CFrame.Angles(0, tick() * 3, 0)
            updateRing(ring, baseCF)
        end
    end)
end

local function stopRings()
    SfxCfg.RingEnabled = false
    clearRings()
end
-- ==================== 武器/背环结束 ====================

local spinBV
local function stopSpin()if spinBV then spinBV:Destroy()spinBV=nil end end
local function startSpin()
    stopSpin()
    local r=rt()if not r then return end
    spinBV=Instance.new("BodyAngularVelocity",r)
    spinBV.MaxTorque=Vector3.new(0,1e5,0)
    spinBV.AngularVelocity=Vector3.new(0,math.rad(S.spinSpeed),0)
end

-- ==================== 彩虹走马灯（含过渡特效） ====================
local MarqueeGui, MarqueeConn
local MarqueeGradients = {}

local function rainbowColorSeq()
    return ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 140, 0)),
        ColorSequenceKeypoint.new(0.33, Color3.fromRGB(255, 255, 0)),
        ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 0)),
        ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 150, 255)),
        ColorSequenceKeypoint.new(0.83, Color3.fromRGB(160, 0, 255)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 0)),
    })
end

local function startMarquee()
    stopMarquee()
    MarqueeGui = Instance.new("ScreenGui")
    MarqueeGui.Name = "AceMarquee"
    MarqueeGui.ResetOnSpawn = false
    MarqueeGui.IgnoreGuiInset = true
    MarqueeGui.DisplayOrder = 99999
    MarqueeGui.Parent = L:WaitForChild("PlayerGui")

    MarqueeGradients = {}
    local thick = 10
    local TS = game:GetService("TweenService")
    local transitionTime = 0.7
    local easeStyle = Enum.EasingStyle.Quart
    local easeDir = Enum.EasingDirection.Out

    local top = Instance.new("Frame", MarqueeGui)
    top.Size = UDim2.new(0, 0, 0, thick)
    top.Position = UDim2.new(0.5, 0, 0.5, 0)
    top.AnchorPoint = Vector2.new(0.5, 0.5)
    top.BackgroundColor3 = Color3.new(1,1,1)
    top.BorderSizePixel = 0
    local topG = Instance.new("UIGradient")
    topG.Color = rainbowColorSeq()
    topG.Parent = top
    table.insert(MarqueeGradients, {g=topG, axis="X"})

    local bottom = Instance.new("Frame", MarqueeGui)
    bottom.Size = UDim2.new(0, 0, 0, thick)
    bottom.Position = UDim2.new(0.5, 0, 0.5, 0)
    bottom.AnchorPoint = Vector2.new(0.5, 0.5)
    bottom.BackgroundColor3 = Color3.new(1,1,1)
    bottom.BorderSizePixel = 0
    local botG = Instance.new("UIGradient")
    botG.Color = rainbowColorSeq()
    botG.Parent = bottom
    table.insert(MarqueeGradients, {g=botG, axis="-X"})

    local left = Instance.new("Frame", MarqueeGui)
    left.Size = UDim2.new(0, thick, 0, 0)
    left.Position = UDim2.new(0.5, 0, 0.5, 0)
    left.AnchorPoint = Vector2.new(0.5, 0.5)
    left.BackgroundColor3 = Color3.new(1,1,1)
    left.BorderSizePixel = 0
    local lftG = Instance.new("UIGradient")
    lftG.Color = rainbowColorSeq()
    lftG.Rotation = 90
    lftG.Parent = left
    table.insert(MarqueeGradients, {g=lftG, axis="Y"})

    local right = Instance.new("Frame", MarqueeGui)
    right.Size = UDim2.new(0, thick, 0, 0)
    right.Position = UDim2.new(0.5, 0, 0.5, 0)
    right.AnchorPoint = Vector2.new(0.5, 0.5)
    right.BackgroundColor3 = Color3.new(1,1,1)
    right.BorderSizePixel = 0
    local rgtG = Instance.new("UIGradient")
    rgtG.Color = rainbowColorSeq()
    rgtG.Rotation = -90
    rgtG.Parent = right
    table.insert(MarqueeGradients, {g=rgtG, axis="-Y"})

    local corners = {}
    local cornerTargets = {
        UDim2.new(0, 0, 0, 0),
        UDim2.new(1, 0, 0, 0),
        UDim2.new(0, 0, 1, 0),
        UDim2.new(1, 0, 1, 0),
    }
    for i = 1, 4 do
        local dot = Instance.new("Frame", MarqueeGui)
        dot.Size = UDim2.fromOffset(0, 0)
        dot.AnchorPoint = Vector2.new(0.5, 0.5)
        dot.Position = UDim2.new(0.5, 0, 0.5, 0)
        dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        dot.BorderSizePixel = 0
        Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
        local dg = Instance.new("UIGradient")
        dg.Color = rainbowColorSeq()
        dg.Parent = dot
        table.insert(MarqueeGradients, {g=dg, axis="R" .. i})
        table.insert(corners, {frame=dot, targetPos=cornerTargets[i]})
    end

    TS:Create(top, TweenInfo.new(transitionTime, easeStyle, easeDir), {
        Size = UDim2.new(1, 0, 0, thick),
        Position = UDim2.new(0.5, 0, 0, thick/2),
    }):Play()
    TS:Create(bottom, TweenInfo.new(transitionTime, easeStyle, easeDir), {
        Size = UDim2.new(1, 0, 0, thick),
        Position = UDim2.new(0.5, 0, 1, -thick/2),
    }):Play()
    TS:Create(left, TweenInfo.new(transitionTime, easeStyle, easeDir), {
        Size = UDim2.new(0, thick, 1, 0),
        Position = UDim2.new(0, thick/2, 0.5, 0),
    }):Play()
    TS:Create(right, TweenInfo.new(transitionTime, easeStyle, easeDir), {
        Size = UDim2.new(0, thick, 1, 0),
        Position = UDim2.new(1, -thick/2, 0.5, 0),
    }):Play()

    for _, item in ipairs(corners) do
        TS:Create(item.frame, TweenInfo.new(transitionTime, easeStyle, easeDir), {
            Size = UDim2.fromOffset(20, 20),
            Position = item.targetPos,
        }):Play()
    end

    local t0 = tick()
    MarqueeConn = R.Heartbeat:Connect(function()
        if not S.Marquee or not MarqueeGui then return end
        local speed = 0.5
        local off = ((tick() - t0) * speed) % 1
        for _, item in ipairs(MarqueeGradients) do
            local ax = item.axis
            if ax == "X" then
                item.g.Offset = Vector2.new(off, 0)
            elseif ax == "-X" then
                item.g.Offset = Vector2.new(-off, 0)
            elseif ax == "Y" then
                item.g.Offset = Vector2.new(0, off)
            elseif ax == "-Y" then
                item.g.Offset = Vector2.new(0, -off)
            else
                item.g.Rotation = (tick() * 60) % 360
                item.g.Offset = Vector2.new(off, 0)
            end
        end
    end)
end

function stopMarquee()
    if MarqueeConn then MarqueeConn:Disconnect() MarqueeConn = nil end
    if MarqueeGui then MarqueeGui:Destroy() MarqueeGui = nil end
    MarqueeGradients = {}
end
-- ==================== 走马灯结束 ====================

local JV=Vector2.new()local VV=0 local MG
local function mkMG()
 if MG then return end
 MG=Instance.new("ScreenGui")MG.ResetOnSpawn=false MG.IgnoreGuiInset=true MG.Parent=L:WaitForChild("PlayerGui")
 local jb=Instance.new("Frame",MG)jb.Size=UDim2.fromOffset(150,150)jb.Position=UDim2.new(0,30,1,-180)jb.BackgroundColor3=Color3.fromRGB(30,30,30)jb.BackgroundTransparency=.5 jb.BorderSizePixel=0 jb.Active=true Instance.new("UICorner",jb).CornerRadius=UDim.new(1,0)
 local jt=Instance.new("Frame",jb)jt.Size=UDim2.fromOffset(60,60)jt.Position=UDim2.fromOffset(45,45)jt.BackgroundColor3=Color3.fromRGB(255,100,100)jt.BorderSizePixel=0 Instance.new("UICorner",jt).CornerRadius=UDim.new(1,0)
 local function btn(pos,txt,col)local b=Instance.new("TextButton",MG)b.Size=UDim2.fromOffset(70,70)b.Position=pos b.Text=txt b.TextSize=26 b.TextColor3=Color3.new(1,1,1)b.BackgroundColor3=col b.BorderSizePixel=0 Instance.new("UICorner",b).CornerRadius=UDim.new(1,0)return b end
 local ub=btn(UDim2.new(1,-100,1,-230),"▲",Color3.fromRGB(60,180,60))
 local db=btn(UDim2.new(1,-100,1,-150),"▼",Color3.fromRGB(180,60,60))
 local at=nil
 jb.InputBegan:Connect(function(i)if i.UserInputType==Enum.UserInputType.Touch then at=i end end)
 U.InputChanged:Connect(function(i)if at and i==at and i.UserInputType==Enum.UserInputType.Touch then local cn=jb.AbsolutePosition+jb.AbsoluteSize/2 local d=Vector2.new(i.Position.X,i.Position.Y)-cn local r=jb.AbsoluteSize.X/2-30 if d.Magnitude>r then d=d.Unit*r end jt.Position=UDim2.fromOffset(45+d.X,45+d.Y)JV=d/r end end)
 U.InputEnded:Connect(function(i)if at and i==at then at=nil jt.Position=UDim2.fromOffset(45,45)JV=Vector2.new()end end)
 for _,x in ipairs({{ub,1},{db,-1}})do local b,v=x[1],x[2] b.InputBegan:Connect(function(i)if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then VV=v end end)b.InputEnded:Connect(function(i)if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then VV=0 end end)end
end
local function setMG(b)if b then mkMG()if MG then MG.Enabled=true end else if MG then MG.Enabled=false end JV=Vector2.new()VV=0 end end

local function dir()
 local d=Vector3.zero
 if M then
  if JV.Magnitude>.05 then d=d+C.CFrame.LookVector*(-JV.Y)+C.CFrame.RightVector*JV.X end
  if VV~=0 then d=d+Vector3.new(0,VV,0)end
 else
  local K=Enum.KeyCode
  if U:IsKeyDown(K.W)then d=d+C.CFrame.LookVector end
  if U:IsKeyDown(K.S)then d=d-C.CFrame.LookVector end
  if U:IsKeyDown(K.A)then d=d-C.CFrame.RightVector end
  if U:IsKeyDown(K.D)then d=d+C.CFrame.RightVector end
  if U:IsKeyDown(K.Space)then d=d+Vector3.new(0,1,0)end
  if U:IsKeyDown(K.LeftControl)then d=d-Vector3.new(0,1,0)end
 end
 return d
end

local BV,BG,CF,VBV,VBG,VCF
local function stopFly()if BV then BV:Destroy()BV=nil end if BG then BG:Destroy()BG=nil end if CF then CF:Disconnect()CF=nil end setMG(false)end
local function startFly()
 stopFly() local r=rt()if not r then nt("飞行","角色未加载")return end
 BV=Instance.new("BodyVelocity",r)BV.MaxForce=Vector3.new(1e5,1e5,1e5)BV.Velocity=Vector3.zero
 BG=Instance.new("BodyGyro",r)BG.MaxTorque=Vector3.new(1e5,1e5,1e5)BG.CFrame=r.CFrame
 if M then setMG(true)end
 CF=R.Heartbeat:Connect(function()
  if not S.Fly then return end
  local rr=rt()if not rr or not BV then return end
  local d=dir()local m=d.Magnitude
  if m>0 then BV.Velocity=d*S.FS else BV.Velocity=Vector3.zero end
  BG.CFrame=CFrame.new(rr.Position,rr.Position+C.CFrame.LookVector)
 end)
end
local function stopVF()if VBV then VBV:Destroy()VBV=nil end if VBG then VBG:Destroy()VBG=nil end if VCF then VCF:Disconnect()VCF=nil end setMG(false)end
local function startVF()
 stopVF()
 local c=ch()local h=c and c:FindFirstChildOfClass("Humanoid")local sp=h and h.SeatPart
 local v=sp and sp:FindFirstAncestorOfClass("Model")
 if not v then nt("车辆飞行","请先坐进车辆")return false end
 if not v.PrimaryPart then for _,p in ipairs(v:GetDescendants())do if p:IsA("BasePart")then v.PrimaryPart=p break end end end
 local r=v.PrimaryPart
 VBV=Instance.new("BodyVelocity",r)VBV.MaxForce=Vector3.new(1e6,1e6,1e6)VBV.Velocity=Vector3.zero
 VBG=Instance.new("BodyGyro",r)VBG.MaxTorque=Vector3.new(1e6,1e6,1e6)VBG.CFrame=r.CFrame
 if M then setMG(true)end
 VCF=R.Heartbeat:Connect(function()
  if not S.VF then return end
  if not r.Parent then stopVF()S.VF=false return end
  local d=dir()local m=d.Magnitude
  if m>0 then VBV.Velocity=d*S.VFS else VBV.Velocity=Vector3.zero end
  VBG.CFrame=CFrame.new(r.Position,r.Position+C.CFrame.LookVector)
 end)
 return true
end

local ED={}
local function mkE(p)if p==L or ED[p]then return end local b=Drawing.new("Square")b.Thickness=2 b.Color=Color3.fromRGB(0,255,0)b.Visible=false local n=Drawing.new("Text")n.Size=14 n.Color=Color3.new(1,1,1)n.Center=true n.Outline=true local d=Drawing.new("Text")d.Size=12 d.Color=Color3.fromRGB(255,255,0)d.Center=true d.Outline=true local h=Drawing.new("Text")h.Size=12 h.Color=Color3.fromRGB(0,255,0)h.Center=true h.Outline=true local t=Drawing.new("Line")t.Thickness=1 t.Color=Color3.new(1,1,1)t.Visible=false ED[p]={b=b,n=n,d=d,h=h,t=t}end
local function hE(e)e.b.Visible=false e.n.Visible=false e.d.Visible=false e.h.Visible=false e.t.Visible=false end
R.RenderStepped:Connect(function()
 for p,e in pairs(ED)do
  local c=p.Character local r=c and c:FindFirstChild("HumanoidRootPart")local h=c and c:FindFirstChildOfClass("Humanoid")
  if not(c and r and h and h.Health>0 and S.ESP)then hE(e)else
   local pos,on=C:WorldToViewportPoint(r.Position)
   if not on then hE(e)else
    local hp=C:WorldToViewportPoint(r.Position+Vector3.new(0,3,0))local lpp=C:WorldToViewportPoint(r.Position-Vector3.new(0,4,0))
    local hh=math.abs(hp.Y-lpp.Y)local ww=hh*.5
    e.b.Size=Vector2.new(ww,hh)e.b.Position=Vector2.new(pos.X-ww/2,pos.Y-hh/2)e.b.Visible=S.EN
    e.n.Text=p.Name e.n.Position=Vector2.new(pos.X,pos.Y-hh/2-18)e.n.Visible=S.ENa
    local dd=(r.Position-C.CFrame.Position).Magnitude
    e.d.Text=math.floor(dd).."m"e.d.Position=Vector2.new(pos.X,pos.Y+hh/2+2)e.d.Visible=S.EDis
    e.h.Text=math.floor(h.Health).."HP"e.h.Position=Vector2.new(pos.X,pos.Y+hh/2+16)e.h.Visible=S.EH
    if S.ET then e.t.From=Vector2.new(C.ViewportSize.X/2,C.ViewportSize.Y)e.t.To=Vector2.new(pos.X,pos.Y)e.t.Visible=true else e.t.Visible=false end
   end
  end
 end
end)
for _,p in ipairs(P:GetPlayers())do mkE(p)end
P.PlayerAdded:Connect(function(p)p.CharacterAdded:Connect(function()task.wait(1)mkE(p)end)end)

local function getTargets()
    local targets={}
    if S.AimReal then
        for _,p in ipairs(P:GetPlayers())do
            if p~=L and p.Character then
                local h=p.Character:FindFirstChildOfClass("Humanoid")
                local r=p.Character:FindFirstChild("HumanoidRootPart")
                if h and r and h.Health>0 then table.insert(targets,p.Character) end
            end
        end
    end
    if S.AimNPC then
        for _,m in ipairs(WS:GetChildren())do
            if m:IsA("Model") and m~=ch() then
                local h=m:FindFirstChildOfClass("Humanoid")
                local r=m:FindFirstChild("HumanoidRootPart")
                if h and r and h.Health>0 and not P:GetPlayerFromCharacter(m) then table.insert(targets,m) end
            end
        end
    end
    return targets
end

R.RenderStepped:Connect(function()
    if not S.Aim then return end
    local mr=rt() if not mr then return end
    local best,bestDist=nil,S.AF
    for _,char in ipairs(getTargets())do
        if char and char.Parent then
            local r=char:FindFirstChild("HumanoidRootPart")
            local h=char:FindFirstChildOfClass("Humanoid")
            if r and h and h.Health>0 then
                local d=(r.Position-mr.Position).Magnitude
                if d<bestDist then bestDist=d best=char end
            end
        end
    end
    if best then
        local aimPart=best:FindFirstChild("Head")
        local aimPos
        if S.AT=="Head" and aimPart then aimPos=aimPart.Position
        else
            local rp=best:FindFirstChild("HumanoidRootPart")
            if rp then aimPos=rp.Position end
        end
        if aimPos then
            if S.Prediction>0 and aimPart and aimPart.AssemblyLinearVelocity then
                aimPos=aimPos+aimPart.AssemblyLinearVelocity*S.Prediction
            end
            local dir=(aimPos-mr.Position)
            if dir.Magnitude>0.01 then
                local newCF=CFrame.new(mr.Position,mr.Position+dir.Unit)
                local alpha=math.clamp(1-S.Smooth/11,0.05,0.95)
                C.CFrame=C.CFrame:Lerp(newCF,alpha)
            end
        end
    end
end)

local FC=Drawing.new("Circle")FC.Thickness=2 FC.Color=Color3.fromRGB(255,80,80)FC.NumSides=64 FC.Visible=false
R.RenderStepped:Connect(function()if S.ShowFOV then FC.Position=Vector2.new(C.ViewportSize.X/2,C.ViewportSize.Y/2)FC.Radius=S.AF FC.Visible=true else FC.Visible=false end end)
R.RenderStepped:Connect(function()
 if S.DF then local h=hm()if h and h.RootPart then local sp=h.RootPart.Velocity.Magnitude C.FieldOfView=S.DFm+(S.DFM-S.DFm)*math.clamp(sp/100,0,1)end
 elseif S.SF and C.FieldOfView~=S.SFv then C.FieldOfView=S.SFv end
end)

-- ==================== 帧率显示 ====================
local FpsGui, FpsLabel, FpsConn
local FpsFrameCount = 0
local FpsLastTime = tick()

local function toggleFpsDisplay(on)
    if on then
        if not FpsGui then
            FpsGui = Instance.new("ScreenGui")
            FpsGui.Name = "AceFpsDisplay"
            FpsGui.ResetOnSpawn = false
            FpsGui.IgnoreGuiInset = true
            FpsGui.DisplayOrder = 9999
            FpsGui.Parent = L:WaitForChild("PlayerGui")
            FpsLabel = Instance.new("TextLabel", FpsGui)
            FpsLabel.Size = UDim2.fromOffset(110, 32)
            FpsLabel.Position = UDim2.new(0, 10, 0, 10)
            FpsLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
            FpsLabel.BackgroundTransparency = 0.35
            FpsLabel.TextColor3 = Color3.fromRGB(80, 255, 120)
            FpsLabel.TextSize = 16
            FpsLabel.Font = Enum.Font.GothamBold
            FpsLabel.Text = "FPS: --"
            FpsLabel.BorderSizePixel = 0
            Instance.new("UICorner", FpsLabel).CornerRadius = UDim.new(0, 6)
        end
        FpsGui.Enabled = true
        if FpsConn then FpsConn:Disconnect() end
        FpsFrameCount = 0
        FpsLastTime = tick()
        FpsConn = R.RenderStepped:Connect(function()
            if not FpsLabel then return end
            FpsFrameCount = FpsFrameCount + 1
            local now = tick()
            if now - FpsLastTime >= 0.5 then
                local fps = math.floor(FpsFrameCount / (now - FpsLastTime))
                FpsLabel.Text = "FPS: " .. tostring(fps)
                if fps >= 50 then FpsLabel.TextColor3 = Color3.fromRGB(80, 255, 120)
                elseif fps >= 25 then FpsLabel.TextColor3 = Color3.fromRGB(255, 200, 80)
                else FpsLabel.TextColor3 = Color3.fromRGB(255, 80, 80) end
                FpsFrameCount = 0
                FpsLastTime = now
            end
        end)
    else
        if FpsGui then FpsGui.Enabled = false end
        if FpsConn then FpsConn:Disconnect() FpsConn = nil end
    end
end

-- ==================== 画质/帧率控制 ====================
local OriginalQualityLevel = nil
local OriginalShadows = nil
local OriginalPostEffects = {}

pcall(function() OriginalQualityLevel = settings().Rendering.QualityLevel end)
pcall(function()
    OriginalShadows = LT.GlobalShadows
    for _, v in ipairs(LT:GetChildren()) do
        if v:IsA("PostEffect") then OriginalPostEffects[v] = v.Enabled end
    end
end)

local function setQualityLevel(level)
    level = math.clamp(level, 1, 10)
    pcall(function()
        local ql = Enum.QualityLevel["Level" .. tostring(level)]
        if ql then settings().Rendering.QualityLevel = ql end
    end)
    pcall(function()
        local ugs = UserSettings():GetService("UserGameSettings")
        ugs.SavedQualityLevel = level
    end)
    pcall(function()
        LT.GlobalShadows = level >= 3
        LT.FogEnd = level >= 5 and 100000 or 200
    end)
end

local function setFpsCap(cap)
    cap = math.clamp(cap, 15, 360)
    pcall(function() if setfpscap then setfpscap(cap) end end)
    pcall(function() settings().Rendering.FramerateCap = cap end)
    pcall(function() if fpscap then fpscap(cap) end end)
end

-- ==================== 窗口 ====================
local Wn=W:CreateWindow({Title="ACE作弊精简版",Icon="door-open",Author="ACE作弊精简版",Folder="AceHub",Size=UDim2.fromOffset(580,460),Transparent=true,Theme="Dark",SideBarWidth=200,HasOutline=true,User={Enabled=true,Anonymous=false}})
Wn:EditOpenButton({Title="ACE 简洁版",Icon="monitor",CornerRadius=UDim.new(0,16),StrokeThickness=2,Color=ColorSequence.new(Color3.fromHex("FF0F7B"),Color3.fromHex("F89B29")),Draggable=true})
task.defer(function()task.wait(.2)pcall(function()Wn:Close()end)end)

local function toggleOpenButton(show)
    pcall(function()
        local pg=L:FindFirstChild("PlayerGui")
        if not pg then return end
        for _,g in ipairs(pg:GetChildren())do
            if g:IsA("ScreenGui") then
                for _,d in ipairs(g:GetDescendants())do
                    if d:IsA("TextButton") and d.Text and d.Text:find("ACE 简洁版") then
                        d.Visible=show
                        if d.Parent and d.Parent:IsA("GuiObject") then d.Parent.Visible=show end
                    end
                end
            end
        end
    end)
end
task.spawn(function() task.wait(0.3) toggleOpenButton(false) end)

local function showWelcomePopup()
    local gui=Instance.new("ScreenGui")
    gui.Name="AceWelcome"
    gui.ResetOnSpawn=false
    gui.IgnoreGuiInset=true
    gui.DisplayOrder=99999
    gui.Parent=L:WaitForChild("PlayerGui")
    local dim=Instance.new("Frame",gui)
    dim.Size=UDim2.fromScale(1,1)
    dim.BackgroundColor3=Color3.new(0,0,0)
    dim.BackgroundTransparency=0.5
    dim.BorderSizePixel=0
    local box=Instance.new("Frame",dim)
    box.Size=UDim2.fromOffset(440,340)
    box.Position=UDim2.fromScale(0.5,0.5)
    box.AnchorPoint=Vector2.new(0.5,0.5)
    box.BackgroundColor3=Color3.fromRGB(25,25,35)
    box.BorderSizePixel=0
    Instance.new("UICorner",box).CornerRadius=UDim.new(0,14)
    local stroke=Instance.new("UIStroke",box)
    stroke.Color=Color3.fromRGB(124,58,237)
    stroke.Thickness=2
    local title=Instance.new("TextLabel",box)
    title.Size=UDim2.new(1,-40,0,32)
    title.Position=UDim2.new(0,20,0,18)
    title.BackgroundTransparency=1
    title.Text="欢迎！"
    title.TextColor3=Color3.fromRGB(200,180,255)
    title.TextSize=22
    title.Font=Enum.Font.GothamBold
    title.TextXAlignment=Enum.TextXAlignment.Left
    local content=Instance.new("TextLabel",box)
    content.Size=UDim2.new(1,-40,0,230)
    content.Position=UDim2.new(0,20,0,58)
    content.BackgroundTransparency=1
    content.RichText=true
    content.Text="欢迎使用 ACE作弊精简版，祝你游戏愉快！\n\n官方 QQ 群：<font color=\"rgb(255,40,40)\">1128017697</font>\n加入官方群可以获取最新版本、使用教程和问题反馈，遇到任何问题都可以在群里提问。\n\n如果觉得脚本好用，欢迎推荐给朋友，也欢迎在能力范围内支持一下作者。"
    content.TextColor3=Color3.fromRGB(230,230,240)
    content.TextSize=14
    content.Font=Enum.Font.Gotham
    content.TextXAlignment=Enum.TextXAlignment.Left
    content.TextYAlignment=Enum.TextYAlignment.Top
    content.TextWrapped=true
    local btn=Instance.new("TextButton",box)
    btn.Size=UDim2.fromOffset(180,46)
    btn.Position=UDim2.new(0.5,-90,1,-64)
    btn.BackgroundColor3=Color3.fromRGB(60,60,80)
    btn.BorderSizePixel=0
    btn.Text="继续 (10S)"
    btn.TextColor3=Color3.fromRGB(160,160,175)
    btn.TextSize=15
    btn.Font=Enum.Font.GothamBold
    btn.AutoButtonColor=false
    Instance.new("UICorner",btn).CornerRadius=UDim.new(0,8)
    local ready=false
    task.spawn(function()
        for i=10,1,-1 do
            btn.Text="继续 ("..i.."S)"
            task.wait(1)
        end
        ready=true
        btn.Text="继续"
        btn.BackgroundColor3=Color3.fromRGB(124,58,237)
        btn.TextColor3=Color3.new(1,1,1)
        btn.AutoButtonColor=true
    end)
    btn.MouseButton1Click:Connect(function()
        if ready then
            gui:Destroy()
            task.wait(0.2)
            toggleOpenButton(true)
        end
    end)
end
showWelcomePopup()

local RegisteredControls = {}
local ConfigValues = {}

local function T(t,n,k,cb)
    local toggle = t:Toggle({Title=n,Value=false,Callback=function(v)
        if k and k~="" then S[k]=v end
        if cb then cb(v) end
    end})
    if k and k~="" and toggle then RegisteredControls[k]=toggle end
    return toggle
end
local function Sl(t,n,a,b,d,cb)t:Slider({Title=n,Value={Min=a,Max=b,Default=d},Callback=cb})end
local function Dp(t,n,l,d,cb)t:Dropdown({Title=n,Values=l,Value=d or l[1],Multi=false,AllowNone=false,Callback=cb})end
local function Pa(t,n,d,i)t:Paragraph({Title=n,Desc=d,Image=i or "info",ImageSize=26})end
local function Bt(t,n,i,x)t:Button({Title=n,Icon=i,Callback=function()setclipboard(x)nt("已复制",x)end})end
local function Sec(t,n)t:Section({Title=n})end

-- ==================== 配置保存/读取 ====================
local SaveFileName = "AceHub_Config.txt"

local function serializeConfig()
    local lines = {}
    for k, v in pairs(S) do
        local ty = type(v)
        if ty == "boolean" then table.insert(lines, k .. "=" .. (v and "true" or "false"))
        elseif ty == "number" then table.insert(lines, k .. "=" .. tostring(v))
        elseif ty == "string" then table.insert(lines, k .. "=" .. v) end
    end
    table.insert(lines, "SfxWeaponType=" .. tostring(SfxCfg.WeaponType))
    table.insert(lines, "SfxRingType=" .. tostring(SfxCfg.RingType))
    table.insert(lines, "SfxCount=" .. tostring(SfxCfg.Count))
    table.insert(lines, "SfxRadius=" .. tostring(SfxCfg.Radius))
    table.insert(lines, "SfxHeight=" .. tostring(SfxCfg.Height))
    table.insert(lines, "SfxSpeed=" .. tostring(SfxCfg.Speed))
    table.insert(lines, "SfxEnabled=" .. (SfxCfg.Enabled and "true" or "false"))
    table.insert(lines, "SfxRingEnabled=" .. (SfxCfg.RingEnabled and "true" or "false"))
    for k, v in pairs(ConfigValues) do
        if type(v) == "boolean" then table.insert(lines, k .. "=" .. (v and "true" or "false"))
        elseif type(v) == "number" or type(v) == "string" then table.insert(lines, k .. "=" .. tostring(v)) end
    end
    return table.concat(lines, "\n")
end

local function deserializeConfig(text)
    local cfg = {}
    for line in text:gmatch("[^\r\n]+") do
        local k, v = line:match("^([^=]+)=(.*)$")
        if k and v then
            if v == "true" then cfg[k] = true
            elseif v == "false" then cfg[k] = false
            else
                local n = tonumber(v)
                if n then cfg[k] = n else cfg[k] = v end
            end
        end
    end
    return cfg
end

local function saveConfig()
    if not writefile then nt("保存失败", "执行器不支持 writefile") return end
    local text = serializeConfig()
    local ok = pcall(function() writefile(SaveFileName, text) end)
    if ok then nt("保存成功", "配置已保存") else nt("保存失败", "写入文件出错") end
end

local function loadConfig()
    if not (readfile and isfile) then nt("加载失败", "执行器不支持读取文件") return end
    local exists = false
    pcall(function() exists = isfile(SaveFileName) end)
    if not exists then nt("加载失败", "未找到配置文件，请先保存") return end
    local text
    pcall(function() text = readfile(SaveFileName) end)
    if not text then nt("加载失败", "读取文件失败") return end
    local cfg = deserializeConfig(text)

    for k, v in pairs(cfg) do
        if k:sub(1,3) ~= "Sfx" and S[k] ~= nil then S[k] = v end
    end

    if cfg.SfxWeaponType then SfxCfg.WeaponType = cfg.SfxWeaponType end
    if cfg.SfxRingType then SfxCfg.RingType = cfg.SfxRingType end
    if cfg.SfxCount then SfxCfg.Count = cfg.SfxCount end
    if cfg.SfxRadius then SfxCfg.Radius = cfg.SfxRadius end
    if cfg.SfxHeight then SfxCfg.Height = cfg.SfxHeight end
    if cfg.SfxSpeed then SfxCfg.Speed = cfg.SfxSpeed end

    for k, v in pairs(cfg) do
        if k:sub(1,6) ~= "Sfx" then ConfigValues[k] = v end
    end

    if S.InfStamina then lp("InfStamina", F.sta, .5) end
    if S.InfHunger then lp("InfHunger", F.hun, .5) end
    if S.NoFall then lp("NoFall", F.fall, .2) end
    if S.AntiRagdoll then lp("AntiRagdoll", F.rag, .5) end
    if S.Inv then lp("Inv", F.inv, .5) end
    if S.Noclip then lp("Noclip", F.clip, .1) end
    if S.Speed then lp("Speed", F.spd, .5) end
    if S.Fly then startFly() end
    if S.VF then startVF() end
    if S.spin then startSpin() end
    if cfg.SfxEnabled then SfxCfg.Enabled = true startSwords() end
    if cfg.SfxRingEnabled then SfxCfg.RingEnabled = true startRings() end
    if ConfigValues.QualityLevel then setQualityLevel(ConfigValues.QualityLevel) end
    if ConfigValues.FpsCap then setFpsCap(ConfigValues.FpsCap) end
    if ConfigValues.ShowFPS then S.ShowFPS = true toggleFpsDisplay(true) end
    if ConfigValues.Marquee then S.Marquee = true startMarquee() end

    for k, v in pairs(cfg) do
        local ctrl = RegisteredControls[k]
        if ctrl then
            pcall(function() if ctrl.SetValue then ctrl:SetValue(v) end end)
        end
    end
    nt("加载成功", "配置已应用")
end

-- ==================== 标签页 ====================
local Hm=Wn:Tab({Title="主页",Icon="house"})
local Ct=Wn:Tab({Title="联系方式",Icon="phone"})
local Tu=Wn:Tab({Title="使用教程",Icon="book-open"})
Wn:Divider()
local No=Wn:Tab({Title="公告",Icon="megaphone"})
local Lg=Wn:Tab({Title="更新日志",Icon="history"})
Wn:Divider()
local Bs=Wn:Tab({Title="基础",Icon="settings-2"})
local Am=Wn:Tab({Title="自瞄",Icon="crosshair"})
local Pl=Wn:Tab({Title="玩家",Icon="user"})
local Es=Wn:Tab({Title="ESP",Icon="eye"})
local Gr=Wn:Tab({Title="画质",Icon="image"})
local Vw=Wn:Tab({Title="视角",Icon="camera"})
local Sp=Wn:Tab({Title="观战",Icon="video"})
local En=Wn:Tab({Title="娱乐",Icon="sparkles"})
local Sv=Wn:Tab({Title="服务器",Icon="server"})
local Ui=Wn:Tab({Title="UI 设置",Icon="palette"})
Wn:SelectTab(1)

-- 主页
Pa(Hm,"官方 QQ 群",
    '<font color="rgb(255,40,40)">1128017697</font>\n'..
    '<font color="rgb(255,120,120)">点击下方按钮一键复制群号，打开 QQ 粘贴搜索即可加入我们</font>',
    "users")
Hm:Button({Title="一键复制官方 QQ 群号",Desc="点击复制后打开 QQ 粘贴搜索即可找到我们",Icon="message-circle",Callback=function()
    setclipboard("1128017697")
    nt("已复制","群号 1128017697 已复制，打开 QQ 粘贴搜索即可")
end})
Hm:Divider()

Pa(Hm,"欢迎使用 ACE作弊精简版","本脚本使用 WindUI 构建\n执行后菜单默认不打开，点击灵动岛按钮打开。","hand")
Sec(Hm,"版本信息")
Pa(Hm,"当前版本","v3.5.0")
Pa(Hm,"执行者",L.DisplayName.." ("..L.Name..")")
Bt(Hm,"复制加载链接","clipboard",'loadstring(game:HttpGet("https://raw.githubusercontent.com/jumanazarovziyomuhammad-eng/Ace-cheated/main/main.lua"))()')

Sec(Hm,"配置管理")
Pa(Hm,"配置管理","保存当前所有开关状态 / 加载上次保存的配置","save")
Hm:Button({Title="保存配置",Desc="将当前所有开启的功能保存到本地",Icon="save",Callback=function()saveConfig()end})
Hm:Button({Title="读取配置",Desc="加载上次保存的配置，自动恢复所有开关",Icon="folder-open",Callback=function()loadConfig()end})

-- 联系方式
Pa(Ct,"联系方式","加入官方 QQ 群或直接联系作者","phone")
Sec(Ct,"官方 QQ 群")
Ct:Button({Title="复制官方 QQ 群号",Desc="点击复制群号后，打开 QQ 粘贴搜索即可找到我们",Icon="message-circle",Callback=function()setclipboard("1128017697")nt("已复制","群号 1128017697 已复制")end})
Sec(Ct,"作者 QQ")
Ct:Button({Title="复制作者 QQ",Desc="点击复制 QQ 号后，打开 QQ 粘贴搜索即可添加作者",Icon="user",Callback=function()setclipboard("2145493327")nt("已复制","QQ 2145493327 已复制")end})

-- 教程
Pa(Tu,"1. 如何执行脚本","打开执行器粘贴并执行，执行后菜单默认不打开。","play")
Pa(Tu,"2. 如何打开菜单","点击「ACE 简洁版」灵动岛按钮，默认快捷键 RightShift。","keyboard")
Pa(Tu,"3. 功能一览","基础 / 自瞄 / 玩家 / ESP / 画质 / 视角 / 观战 / 娱乐 / 服务器 / UI 设置","list")
Pa(Tu,"4. 移动端飞行","左下角摇杆控制前后左右（推得越深速度越快），右下角按钮控制升降。","gamepad-2")
Pa(Tu,"5. 配置管理","主页的「保存配置 / 读取配置」按钮，一键保存或恢复所有开关状态。","save")
Pa(Tu,"6. 官方交流群","QQ 群：1128017697\n遇到任何问题都可以在群里提问。","users")

-- 公告
Pa(No,"【置顶】重要公告",
    "此脚本为缝合脚本，纯公益、完全免费使用，禁止用于任何商业用途。\n\n"..
    "· 本脚本由多个公开开源项目整合缝合而成，仅供学习交流\n"..
    "· 完全免费，不收任何费用，不设任何付费通道\n"..
    "· 严禁倒卖、加价转售或用于任何商业盈利行为\n"..
    "· 本脚本防封技术较低，请自行安排使用，制作方不承担责任\n"..
    "· 如果觉得好用，欢迎在能力范围内支持一下作者\n\n"..
    "官方 QQ 群：1128017697\n"..
    "感谢每一位使用者的理解与支持",
    "pin")

No:Divider()

Pa(No,"【正式发布】ACE作弊精简版 v3.5.0",
    "经过长时间的开发、测试和打磨，ACE作弊精简版正式与大家见面了！\n\n"..
    "从最初的简单框架，到如今集基础、自瞄、玩家、ESP、画质、视角、观战、娱乐、服务器于一体的完整脚本，\n"..
    "每一步更新都离不开各位用户的支持与反馈。\n\n"..
    "本次正式版亮点：\n"..
    "· 完整功能模块，覆盖日常使用场景\n"..
    "· 支持移动端飞行（虚拟摇杆）\n"..
    "· 娱乐分类：7 种宝剑 + 4 种背环 + 6 种特效\n"..
    "· 真实画质等级与帧率上限调整\n"..
    "· 彩虹走马灯（带扩散过渡特效）\n"..
    "· 配置一键保存 / 读取\n\n"..
    "感谢每一位陪伴脚本成长的用户，也感谢所有提出建议的朋友。\n"..
    "未来我们还会继续优化，让它变得更好用、更稳定、更帅气！\n\n"..
    "—— ACE 开发团队",
    "party-popper")

No:Divider()

Pa(No,"普通公告","感谢大家一直以来的支持！\n我们会持续优化并修复问题，请勿用于任何商业用途。","megaphone")
Pa(No,"使用须知","1. 仅供学习交流使用\n2. 请勿传播至非法渠道\n3. 使用后果自负","triangle-alert")

Sec(Lg,"最新通知")Pa(Lg,"2026-10-06","v3.5.0 正式发布！公告分类新增【正式发布】说明。","bell-ring")
Sec(Lg,"更新日志")
Pa(Lg,"v3.5.0  —  2026-10-06","· 正式版发布\n· 公告分类新增正式发布说明","sparkles")
Pa(Lg,"v3.4.2  —  2026-10-06","· 走马灯新增开启过渡特效","wrench")
Pa(Lg,"v3.4.1  —  2026-10-06","· 删除默认背环\n· UI 设置新增彩虹走马灯","wrench")

-- 基础
Sec(Bs,"生存相关")
local Life={"无限体力","无限饥饿","防摔伤","防布娃娃"}local LF={F.sta,F.hun,F.fall,F.rag}
for i,n in ipairs(Life)do local k="lf"..i T(Bs,n,k,function(v)if v then lp(k,LF[i],.5)end end)end
Sec(Bs,"隐身")
T(Bs,"隐身（仅自身可见）","Inv",function(v)if v then lp("Inv",F.inv,.5)end end)
T(Bs,"战斗拦截","CombatBlock")

-- 自瞄
Sec(Am,"自瞄开关")T(Am,"开启自瞄","Aim")
Sec(Am,"瞄准目标")T(Am,"瞄准真人","AimReal")T(Am,"瞄准人机 / NPC","AimNPC")
Sec(Am,"查看 FOV")T(Am,"查看 FOV","ShowFOV")
Sec(Am,"自瞄参数")
Sl(Am,"FOV 大小",10,800,150,function(v)S.AF=v end)
Sl(Am,"平滑度（越小越准）",0,10,3,function(v)S.Smooth=v end)
Sl(Am,"预判强度（打移动目标用）",0,0.5,0.15,function(v)S.Prediction=v end)
Dp(Am,"瞄准部位",{"头部","躯干"},"头部",function(v)S.AT=v end)

-- 玩家
Sec(Pl,"穿墙")T(Pl,"穿墙","Noclip",function(v)if v then lp("Noclip",F.clip,.1)end end)
Sec(Pl,"跳跃")T(Pl,"开启跳跃")
Sl(Pl,"跳跃高度",1,500,50,function(v)local h=hm()if h then h.JumpPower=v end end)
Sl(Pl,"跳跃倍数",1,20,1)
T(Pl,"无限跳跃","InfJump")
if not S._ij then S._ij=U.JumpRequest:Connect(function()if S.InfJump then local h=hm()if h then h:ChangeState(Enum.HumanoidStateType.Jumping)end end end)end
Sec(Pl,"移动")
T(Pl,"走路速度修改","Speed",function(v)if v then lp("Speed",F.spd,.5)end end)
Sl(Pl,"走路速度",16,500,16,function(v)S.WSv=v end)
T(Pl,"突破速度限制","SpeedLimit")
Sec(Pl,"人物飞行")
Pa(Pl,"人物飞行","电脑 WASD+Space/Ctrl\n移动端 摇杆 + 上下按钮（推得越深速度越快）","plane")
T(Pl,"开启人物飞行","Fly",function(v)if v then startFly()else stopFly()end end)
Sl(Pl,"人物飞行速度",1,500,50,function(v)S.FS=v end)
Sec(Pl,"车辆飞行")
Pa(Pl,"车辆飞行","需先坐车再开启","car")
T(Pl,"开启车辆飞行","VF",function(v)if v then if not startVF()then S.VF=false end else stopVF()end end)
Sl(Pl,"车辆飞行速度",1,500,80,function(v)S.VFS=v end)

-- ESP
Sec(Es,"透视开关")T(Es,"玩家透视总开关","ESP")
Sec(Es,"显示项（需手动开启）")
T(Es,"显示名字","ENa")T(Es,"显示距离","EDis")T(Es,"显示血量","EH")T(Es,"显示高亮","EN")T(Es,"显示追踪线","ET")
Dp(Es,"追踪线起点",{"屏幕顶部","屏幕底部","屏幕中心"},"屏幕底部")

-- 画质
Sec(Gr,"画质等级")
Pa(Gr,"真实画质调整","拖动滑块实时调整游戏画质等级\n1 = 最低画质（最流畅）\n10 = 最高画质（最精细）","info")
Gr:Slider({Title="画质等级（1~10）",Value={Min=1, Max=10, Default=10},Callback=function(v)
    ConfigValues.QualityLevel = v
    setQualityLevel(v)
end})
Sec(Gr,"帧率设置")
Pa(Gr,"帧率上限调整","调整游戏最大帧率","gauge")
Gr:Slider({Title="帧率上限（30~360）",Value={Min=30, Max=360, Default=60},Callback=function(v)
    ConfigValues.FpsCap = v
    setFpsCap(v)
end})
Sec(Gr,"帧率显示")
local fpsToggle = Gr:Toggle({Title="显示实时帧率",Value=false,Callback=function(v)
    S.ShowFPS = v
    ConfigValues.ShowFPS = v
    toggleFpsDisplay(v)
end})
RegisteredControls["ShowFPS"] = fpsToggle
Sec(Gr,"画质快捷调整")
Gr:Toggle({Title="关闭阴影",Value=false,Callback=function(v)pcall(function() LT.GlobalShadows = not v end)end})
Gr:Toggle({Title="关闭后处理效果",Value=false,Callback=function(v)
    for _, e in ipairs(LT:GetChildren()) do
        if e:IsA("PostEffect") then e.Enabled = not v end
    end
end})
Gr:Button({Title="恢复默认画质",Icon="rotate-ccw",Callback=function()
    pcall(function() if OriginalQualityLevel then settings().Rendering.QualityLevel = OriginalQualityLevel end end)
    pcall(function()
        LT.GlobalShadows = OriginalShadows
        for effect, enabled in pairs(OriginalPostEffects) do
            if effect.Parent then effect.Enabled = enabled end
        end
    end)
    pcall(function() setFpsCap(60) end)
    nt("画质已恢复","已还原到默认状态")
end})

-- 视角
Sec(Vw,"广角设置")Pa(Vw,"广角说明","静态：固定 FOV；动态：随速度变化 FOV。","info")
Vw:Toggle({Title="静态广角（默认开启）",Value=true,Callback=function(v)S.SF=v if not v and not S.DF then C.FieldOfView=70 end end})
Sl(Vw,"静态广角大小",70,150,120,function(v)S.SFv=v end)
Sec(Vw,"动态广角")
T(Vw,"动态广角","DF")
Sl(Vw,"动态广角最小值",70,150,70,function(v)S.DFm=v end)
Sl(Vw,"动态广角最大值",70,150,130,function(v)S.DFM=v end)
Vw:Button({Title="重置视角（恢复默认 70）",Icon="rotate-ccw",Callback=function()S.SF=false S.DF=false C.FieldOfView=70 end})

-- 观战
Pa(Sp,"温馨提示","需先刷新列表，再选择玩家进行观战或传送。","triangle-alert")
Sec(Sp,"观战设置")
local sD=Sp:Dropdown({Title="选择观战玩家",Values=NM(),Value=nil,Multi=false,AllowNone=true,Callback=function(n)if n then S._SpT=P:FindFirstChild(n)if S.Spectate and S._SpT then local h=S._SpT.Character and S._SpT.Character:FindFirstChildOfClass("Humanoid")if h then C.CameraSubject=h end end else S._SpT=nil end end})
T(Sp,"开启观战","Spectate",function(v)
 if v and S._SpT then local h=S._SpT.Character and S._SpT.Character:FindFirstChildOfClass("Humanoid")if h then C.CameraSubject=h nt("观战","正在观战 "..S._SpT.Name)end
 elseif not v then local h=hm()if h then C.CameraSubject=h end nt("观战","已停止")end
end)
Sp:Button({Title="刷新玩家列表",Icon="refresh-cw",Callback=function()sD:Refresh(NM())nt("观战","已刷新")end})
Sec(Sp,"传送到玩家身边")
local tD=Sp:Dropdown({Title="选择传送目标",Values=NM(),Value=nil,Multi=false,AllowNone=true,Callback=function(n)S.Tgt=n end})
Sp:Button({Title="传送到目标身边",Icon="map-pin",Callback=function()
 if not S.Tgt then nt("传送","请先选择目标")return end
 local t=P:FindFirstChild(S.Tgt)local tr=t and t.Character and t.Character:FindFirstChild("HumanoidRootPart")
 local mr=rt()if tr and mr then mr.CFrame=tr.CFrame*CFrame.new(0,0,3)nt("传送","已传送到 "..t.Name)end
end})
Sp:Button({Title="刷新目标列表",Icon="refresh-cw",Callback=function()tD:Refresh(NM())end})

-- 娱乐
Sec(En,"人物特效")
Pa(En,"人物特效","选择后角色身上会持续显示对应特效","sparkles")
En:Dropdown({Title="选择人物特效",Values={"无","头顶光环","环绕光球","能量翅膀","脚踏法阵","全身霓虹","残影幻影"},Value="无",Multi=false,AllowNone=false,Callback=function(v)applyFX(v)nt("人物特效",v)end})

Sec(En,"宝剑环绕")
Pa(En,"宝剑环绕","选择宝剑种类后开启，角色周围会环绕旋转的宝剑","sword")
En:Dropdown({
    Title="宝剑种类",
    Values={"暗黑魔剑","血刃","冰霜之刃","黄金圣剑","虚空之刃","雷电之剑","翡翠长剑"},
    Value="暗黑魔剑",Multi=false,AllowNone=false,
    Callback=function(v)
        SfxCfg.WeaponType=v
        if SfxCfg.Enabled then startSwords() end
        nt("宝剑已切换",v)
    end
})
T(En,"开启宝剑环绕","",function(v)
    SfxCfg.Enabled=v
    if v then startSwords() else stopSwords() end
end)
Sl(En,"宝剑数量",1,8,3,function(v)
    SfxCfg.Count=v
    if SfxCfg.Enabled then startSwords() end
end)
Sl(En,"旋转半径",2,12,4.5,function(v)SfxCfg.Radius=v end)
Sl(En,"旋转速度",0.5,8,2,function(v)SfxCfg.Speed=v end)
Sl(En,"离地高度",0,6,1.5,function(v)SfxCfg.Height=v end)

Sec(En,"背环")
Pa(En,"背环","在角色头顶水平环绕的华丽光环","circle-dot")
En:Dropdown({
    Title="背环类型",
    Values={"无","金色光环","符文之环","双层能量环","暗黑魔王环"},
    Value="双层能量环",Multi=false,AllowNone=false,
    Callback=function(v)
        SfxCfg.RingType=v
        if SfxCfg.RingEnabled then startRings() end
        nt("背环已切换",v)
    end
})
local ringToggle = En:Toggle({
    Title="开启背环",
    Value=false,
    Callback=function(v)
        SfxCfg.RingEnabled=v
        if v then startRings() else stopRings() end
    end
})
RegisteredControls["SfxRingEnabled"] = ringToggle

Sec(En,"旋转功能")
Pa(En,"旋转功能","开启后角色会持续自转","rotate-cw")
T(En,"开启人物旋转","spin",function(v)if v then startSpin()else stopSpin()end end)
Sl(En,"旋转速度（度/秒）",30,1080,360,function(v)S.spinSpeed=v if S.spin and spinBV then spinBV.AngularVelocity=Vector3.new(0,math.rad(v),0)end end)

Sec(En,"操作")
En:Button({Title="停止全部娱乐效果",Icon="square",Callback=function()
    clearFX()S.curFX="无"
    stopSpin()S.spin=false
    stopSwords()
    stopRings()
    nt("已停止","娱乐效果已还原")
end})

-- 服务器
Sec(Sv,"服务器操作")Pa(Sv,"服务器","重进 / 换服 / 查看简介","server")
Sv:Button({Title="重新进入本服务器",Icon="rotate-ccw",Callback=function()nt("服务器","正在重进...")task.wait(.5)pcall(function()TP:Teleport(game.PlaceId,L)end)end})
Sv:Button({Title="换一个服务器进入",Icon="shuffle",Callback=function()nt("服务器","正在切换...")task.wait(.5)pcall(function()TP:Teleport(game.PlaceId,L)end)end})
Sv:Button({Title="查看本服务器简介",Icon="info",Callback=function()
 local ok,info=pcall(function()return MS:GetProductInfo(game.PlaceId)end)
 if ok and info then local d=info.Description or"无"if #d>300 then d=d:sub(1,300).."..."end W:Notify({Title="【"..(info.Name or"?").."】",Content="作者："..(info.Creator and info.Creator.Name or"?").."\n最大玩家："..tostring(info.MaxPlayers or"?").."\n简介："..d,Icon="info",Duration=12})else nt("服务器","获取失败")end
end})
Sec(Sv,"服务器信息")Bt(Sv,"复制当前 JobId","clipboard",game.JobId)

-- UI 设置
Sec(Ui,"界面外观")
T(Ui,"自定义光标")Dp(Ui,"通知位置",{"右上","右下","左上","左下","居中"},"右上")
Sl(Ui,"DPI 缩放",50,200,100)

Sec(Ui,"彩虹走马灯")
Pa(Ui,"彩虹走马灯","开启后屏幕四边会出现流光溢彩的彩虹走马灯\n开启时会有从中央扩散到四边的过渡特效","rainbow")
local marqueeToggle = Ui:Toggle({
    Title="开启彩虹走马灯",
    Value=false,
    Callback=function(v)
        S.Marquee = v
        ConfigValues.Marquee = v
        if v then startMarquee() else stopMarquee() end
    end
})
RegisteredControls["Marquee"] = marqueeToggle

Sec(Ui,"快捷键")
Ui:Keybind({Title="菜单按键",Desc="打开/关闭菜单",Value="RightShift",Callback=function(v)Wn:SetToggleKey(Enum.KeyCode[v])nt("UI","新键："..v)end})
Sec(Ui,"操作")
Ui:Button({Title="关闭 UI",Icon="x",Callback=function()Wn:Close()end})

L.CharacterAdded:Connect(function()
    task.wait(1)
    if S.SF and not S.DF then C.FieldOfView=S.SFv end
    if S.Fly then task.wait(.3)startFly()end
    if S.curFX~="无"then task.wait(.3)applyFX(S.curFX)end
    if S.spin then task.wait(.3)startSpin()end
    if SfxCfg.Enabled then task.wait(.3)startSwords()end
    if SfxCfg.RingEnabled then task.wait(.3)startRings()end
    if S.Marquee then task.wait(.3)startMarquee()end
end)

nt("ACE作弊精简版","加载完成，点击灵动岛按钮打开菜单！官方 QQ 群：1128017697")
