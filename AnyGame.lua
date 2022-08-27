--[[ 
	Made by Xyla
]]
local GuiLibrary = shared.GuiLibrary
local players = game:GetService("Players")
local textservice = game:GetService("TextService")
local lplr = players.LocalPlayer
local workspace = game:GetService("Workspace")
local lighting = game:GetService("Lighting")
local cam = workspace.CurrentCamera
workspace:GetPropertyChangedSignal("CurrentCamera"):connect(function()
	cam = (workspace.CurrentCamera or workspace:FindFirstChild("Camera") or Instance.new("Camera"))
end)
local targetinfo = shared.VapeTargetInfo
local uis = game:GetService("UserInputService")
local localmouse = lplr:GetMouse()
local v3check = syn and syn.toast_notification and "V3" or ""
local betterisfile = function(file)
	local suc, res = pcall(function() return readfile(file) end)
	return suc and res ~= nil
end
local function GetURL(scripturl)
	if shared.VapeDeveloper then
		if not betterisfile("XyloWare/"..scripturl) then
			error("File not found : XyloWare/"..scripturl)
		end
		return readfile("vape/"..scripturl)
	else
		local res = game:HttpGet("https://raw.githubusercontent.com/XylaWare/XyloWare/main/"..scripturl, true)
		assert(res ~= "404: Not Found", "File not found")
		return res
	end
end
local requestfunc = syn and syn.request or http and http.request or http_request or fluxus and fluxus.request or request or function(tab)
	if tab.Method == "GET" then
		return {
			Body = game:HttpGet(tab.Url, true),
			Headers = {},
			StatusCode = 200
		}
	else
		return {
			Body = "bad exploit",
			Headers = {},
			StatusCode = 404
		}
	end
end 
local queueteleport = syn and syn.queue_on_teleport or queue_on_teleport or fluxus and fluxus.queue_on_teleport or function() end
local getasset = getsynasset or getcustomasset or function(location) return "rbxasset://"..location end
local entity = loadstring(GetURL("Libraries/entityHandler.lua"))()
shared.vapeentity = entity

local RunLoops = {RenderStepTable = {}, StepTable = {}, HeartTable = {}}
do
	function RunLoops:BindToRenderStep(name, num, func)
		if RunLoops.RenderStepTable[name] == nil then
			RunLoops.RenderStepTable[name] = game:GetService("RunService").RenderStepped:connect(func)
		end
	end

	function RunLoops:UnbindFromRenderStep(name)
		if RunLoops.RenderStepTable[name] then
			RunLoops.RenderStepTable[name]:Disconnect()
			RunLoops.RenderStepTable[name] = nil
		end
	end

	function RunLoops:BindToStepped(name, num, func)
		if RunLoops.StepTable[name] == nil then
			RunLoops.StepTable[name] = game:GetService("RunService").Stepped:connect(func)
		end
	end

	function RunLoops:UnbindFromStepped(name)
		if RunLoops.StepTable[name] then
			RunLoops.StepTable[name]:Disconnect()
			RunLoops.StepTable[name] = nil
		end
	end

	function RunLoops:BindToHeartbeat(name, num, func)
		if RunLoops.HeartTable[name] == nil then
			RunLoops.HeartTable[name] = game:GetService("RunService").Heartbeat:connect(func)
		end
	end

	function RunLoops:UnbindFromHeartbeat(name)
		if RunLoops.HeartTable[name] then
			RunLoops.HeartTable[name]:Disconnect()
			RunLoops.HeartTable[name] = nil
		end
	end
end

local function createwarning(title, text, delay)
	pcall(function()
		local frame = GuiLibrary["CreateNotification"](title, text, delay, "assets/WarningNotification.png")
		frame.Frame.BackgroundColor3 = Color3.fromRGB(236, 129, 44)
		frame.Frame.Frame.BackgroundColor3 = Color3.fromRGB(236, 129, 44)
	end)
end

local function friendCheck(plr, recolor)
	if GuiLibrary["ObjectsThatCanBeSaved"]["Use FriendsToggle"]["Api"]["Enabled"] then
		local friend = table.find(GuiLibrary["ObjectsThatCanBeSaved"]["FriendsListTextCircleList"]["Api"]["ObjectList"], plr.Name)
		friend = friend and GuiLibrary["ObjectsThatCanBeSaved"]["FriendsListTextCircleList"]["Api"]["ObjectListEnabled"][friend] and true or nil
		if recolor then
			friend = friend and GuiLibrary["ObjectsThatCanBeSaved"]["Recolor visualsToggle"]["Api"]["Enabled"] or nil
		end
		return friend
	end
	return nil
end

local function getPlayerColor(plr)
	return (friendCheck(plr, true) and Color3.fromHSV(GuiLibrary["ObjectsThatCanBeSaved"]["Friends ColorSliderColor"]["Api"]["Hue"], GuiLibrary["ObjectsThatCanBeSaved"]["Friends ColorSliderColor"]["Api"]["Sat"], GuiLibrary["ObjectsThatCanBeSaved"]["Friends ColorSliderColor"]["Api"]["Value"]) or tostring(plr.TeamColor) ~= "White" and plr.TeamColor.Color)
end

local function getcustomassetfunc(path)
	if not isfile(path) then
		spawn(function()
			local textlabel = Instance.new("TextLabel")
			textlabel.Size = UDim2.new(1, 0, 0, 36)
			textlabel.Text = "Downloading "..path
			textlabel.BackgroundTransparency = 1
			textlabel.TextStrokeTransparency = 0
			textlabel.TextSize = 30
			textlabel.Font = Enum.Font.SourceSans
			textlabel.TextColor3 = Color3.new(1, 1, 1)
			textlabel.Position = UDim2.new(0, 0, 0, -36)
			textlabel.Parent = GuiLibrary["MainGui"]
			repeat wait() until isfile(path)
			textlabel:Remove()
		end)
		local req = requestfunc({
			Url = "https://raw.githubusercontent.com/XylaWare/XyloWare/main/"..path:gsub("XyloWare/assets", "assets"),
			Method = "GET"
		})
		writefile(path, req.Body)
	end
	return getasset(path) 
end

local function targetCheck(plr)
	local ForceField = not plr.Character.FindFirstChildWhichIsA(plr.Character, "ForceField")
	local state = plr.Humanoid.GetState(plr.Humanoid)
	return state ~= Enum.HumanoidStateType.Dead and state ~= Enum.HumanoidStateType.Physics and ForceField
end

do
	GuiLibrary["ObjectsThatCanBeSaved"]["FriendsListTextCircleList"]["Api"].FriendRefresh.Event:connect(function()
		entity.fullEntityRefresh()
	end)
	GuiLibrary["ObjectsThatCanBeSaved"]["Teams by colorToggle"]["Api"].Refresh.Event:connect(function()
		entity.fullEntityRefresh()
	end)
	entity.isPlayerTargetable = function(plr)
		if (not GuiLibrary["ObjectsThatCanBeSaved"]["Teams by colorToggle"]["Api"]["Enabled"]) then return true end
		if friendCheck(plr) then return nil end
		if (not lplr.Team) then return true end
		if plr.Team ~= lplr.Team then return true end
        return plr.Team and #plr.Team:GetPlayers() == #players:GetPlayers()
	end
	entity.fullEntityRefresh()
end

local function isAlive(plr, alivecheck)
	if plr then
		local ind, tab = entity.getEntityFromPlayer(plr)
		return ((not alivecheck) or tab and tab.Humanoid:GetState() ~= Enum.HumanoidStateType.Dead) and tab
	end
	return entity.isAlive
end

local function vischeck(char, checktable)
	local rayparams = checktable.IgnoreObject or RaycastParams.new()
	if not checktable.IgnoreObject then 
		rayparams.FilterDescendantsInstances = {lplr.Character, char, cam, table.unpack(checktable.IgnoreTable or {})}
	end
	local ray = workspace.Raycast(workspace, checktable.Origin, CFrame.lookAt(checktable.Origin, char[checktable.AimPart].Position).lookVector * (checktable.Origin - char[checktable.AimPart].Position).Magnitude, rayparams)
	return not ray
end

local function runcode(func)
	func()
end

local function GetAllNearestHumanoidToPosition(player, distance, amount, checktab)
	local returnedplayer = {}
	local currentamount = 0
	checktab = checktab or {}
    if entity.isAlive then
		for i, v in pairs(entity.entityList) do -- loop through players
			if not v.Targetable then continue end
            if targetCheck(v) and currentamount < amount then -- checks
				local mag = (entity.character.HumanoidRootPart.Position - v.RootPart.Position).magnitude
                if mag <= distance then -- mag check
					if checktab.WallCheck then
						if not vischeck(v.Character, checktab) then continue end
					end
                    table.insert(returnedplayer, v)
					currentamount = currentamount + 1
                end
            end
        end
	end
	return returnedplayer
end

local function GetNearestHumanoidToPosition(player, distance, checktab)
	local closest, returnedplayer, targetpart = distance, nil, nil
	checktab = checktab or {}
	if entity.isAlive then
		for i, v in pairs(entity.entityList) do -- loop through players
			if not v.Targetable then continue end
            if targetCheck(v) then -- checks
				local mag = (entity.character.HumanoidRootPart.Position - v.RootPart.Position).magnitude
                if mag <= closest then -- mag check
					if checktab.WallCheck then
						if not vischeck(v.Character, checktab) then continue end
					end
                    closest = mag
					returnedplayer = v
                end
            end
        end
	end
	return returnedplayer
end

local function GetNearestHumanoidToMouse(player, distance, checktab)
    local closest, returnedplayer = distance, nil
	checktab = checktab or {}
    if entity.isAlive then
		local mousepos = uis.GetMouseLocation(uis)
		for i, v in pairs(entity.entityList) do -- loop through players
			if not v.Targetable then continue end
            if targetCheck(v) then -- checks
				local vec, vis = cam.WorldToScreenPoint(cam, v.Character[checktab.AimPart].Position)
				local mag = (mousepos - Vector2.new(vec.X, vec.Y)).magnitude
                if vis and mag <= closest then -- mag check
					if checktab.WallCheck then
						if not vischeck(v.Character, checktab) then continue end
					end
                    closest = mag
					returnedplayer = v
                end
            end
        end
    end
    return returnedplayer
end

local function CalculateObjectPosition(pos)
	local newpos = cam:WorldToViewportPoint(cam.CFrame:pointToWorldSpace(cam.CFrame:pointToObjectSpace(pos)))
	return Vector2.new(newpos.X, newpos.Y)
end

local function CalculateLine(startVector, endVector, obj)
	local Distance = (startVector - endVector).Magnitude
	obj.Size = UDim2.new(0, Distance, 0, 2)
	obj.Position = UDim2.new(0, (startVector.X + endVector.X) / 2, 0, ((startVector.Y + endVector.Y) / 2) - 36)
	obj.Rotation = math.atan2(endVector.Y - startVector.Y, endVector.X - startVector.X) * (180 / math.pi)
end

local function findTouchInterest(tool)
	return tool and tool:FindFirstChildWhichIsA("TouchTransmitter", true)
end

GuiLibrary["SelfDestructEvent"].Event:connect(function()
	entity.selfDestruct()
end)

local radarcam = Instance.new("Camera")
radarcam.FieldOfView = 45
local Radar = GuiLibrary.CreateCustomWindow({
	["Name"] = "Radar", 
	["Icon"] = "XyloWare/assets/RadarIcon1.png",
	["IconSize"] = 16
})
local RadarColor = Radar.CreateColorSlider({
	["Name"] = "Player Color", 
	["Function"] = function(val) end
})
local RadarFrame = Instance.new("Frame")
RadarFrame.BackgroundColor3 = Color3.new(0, 0, 0)
RadarFrame.BorderSizePixel = 0
RadarFrame.BackgroundTransparency = 0.5
RadarFrame.Size = UDim2.new(0, 250, 0, 250)
RadarFrame.Parent = Radar.GetCustomChildren()
local RadarBorder1 = RadarFrame:Clone()
RadarBorder1.Size = UDim2.new(0, 6, 0, 250)
RadarBorder1.Parent = RadarFrame
local RadarBorder2 = RadarBorder1:Clone()
RadarBorder2.Position = UDim2.new(0, 6, 0, 0)
RadarBorder2.Size = UDim2.new(0, 238, 0, 6)
RadarBorder2.Parent = RadarFrame
local RadarBorder3 = RadarBorder1:Clone()
RadarBorder3.Position = UDim2.new(1, -6, 0, 0)
RadarBorder3.Size = UDim2.new(0, 6, 0, 250)
RadarBorder3.Parent = RadarFrame
local RadarBorder4 = RadarBorder1:Clone()
RadarBorder4.Position = UDim2.new(0, 6, 1, -6)
RadarBorder4.Size = UDim2.new(0, 238, 0, 6)
RadarBorder4.Parent = RadarFrame
local RadarBorder5 = RadarBorder1:Clone()
RadarBorder5.Position = UDim2.new(0, 0, 0.5, -1)
RadarBorder5.BackgroundColor3 = Color3.new(1, 1, 1)
RadarBorder5.Size = UDim2.new(0, 250, 0, 2)
RadarBorder5.Parent = RadarFrame
local RadarBorder6 = RadarBorder1:Clone()
RadarBorder6.Position = UDim2.new(0.5, -1, 0, 0)
RadarBorder6.BackgroundColor3 = Color3.new(1, 1, 1)
RadarBorder6.Size = UDim2.new(0, 2, 0, 124)
RadarBorder6.Parent = RadarFrame
local RadarBorder7 = RadarBorder1:Clone()
RadarBorder7.Position = UDim2.new(0.5, -1, 0, 126)
RadarBorder7.BackgroundColor3 = Color3.new(1, 1, 1)
RadarBorder7.Size = UDim2.new(0, 2, 0, 124)
RadarBorder7.Parent = RadarFrame
local RadarMainFrame = Instance.new("Frame")
RadarMainFrame.BackgroundTransparency = 1
RadarMainFrame.Size = UDim2.new(0, 250, 0, 250)
RadarMainFrame.Parent = RadarFrame
Radar.GetCustomChildren().Parent:GetPropertyChangedSignal("Size"):connect(function()
	RadarFrame.Position = UDim2.new(0, 0, 0, (Radar.GetCustomChildren().Parent.Size.Y.Offset == 0 and 45 or 0))
end)
players.PlayerRemoving:connect(function(plr)
	if RadarMainFrame:FindFirstChild(plr.Name) then
		RadarMainFrame[plr.Name]:Remove()
	end
end)
GuiLibrary["ObjectsThatCanBeSaved"]["GUIWindow"]["Api"].CreateCustomToggle({
	["Name"] = "Radar", 
	["Icon"] = "XyloWare/assets/RadarIcon2.png", 
	["Function"] = function(callback)
		Radar.SetVisible(callback) 
		if callback then
			RunLoops:BindToRenderStep("Radar", 1, function() 
				local v278 = (CFrame.new(0, 0, 0):inverse() * cam.CFrame).p * 0.2 * Vector3.new(1, 1, 1);
				local v279, v280, v281 = cam.CFrame:ToOrientation();
				local u90 = v280 * 180 / math.pi;
				local v277 = 0 - u90;
				local v276 = v278 + Vector3.new();
				radarcam.CFrame = CFrame.new(v276 + Vector3.new(0, 50, 0)) * CFrame.Angles(0, -v277 * (math.pi / 180), 0) * CFrame.Angles(-90 * (math.pi / 180), 0, 0)
				for i,plr in pairs(players:GetChildren()) do
					local thing
					if RadarMainFrame:FindFirstChild(plr.Name) then
						thing = RadarMainFrame[plr.Name]
						if thing.Visible then
							thing.Visible = false
						end
					else
						thing = Instance.new("Frame")
						thing.BackgroundTransparency = 0
						thing.Size = UDim2.new(0, 4, 0, 4)
						thing.BorderSizePixel = 1
						thing.BorderColor3 = Color3.new(0, 0, 0)
						thing.BackgroundColor3 = Color3.new(0, 0, 0)
						thing.Visible = false
						thing.Name = plr.Name
						thing.Parent = RadarMainFrame
					end
					
					local aliveplr = isAlive(plr)
					if aliveplr then
						local v238, v239 = radarcam:WorldToViewportPoint((CFrame.new(0, 0, 0):inverse() * aliveplr.RootPart.CFrame).p * 0.2)
						thing.Visible = true
						thing.BackgroundColor3 = getPlayerColor(plr) or Color3.fromHSV(RadarColor["Hue"], RadarColor["Sat"], RadarColor["Value"])
						thing.Position = UDim2.new(math.clamp(v238.X, 0.03, 0.97), -2, math.clamp(v238.Y, 0.03, 0.97), -2)
					end
				end
			end)
		else
			RunLoops:UnbindFromRenderStep("Radar")
			RadarMainFrame:ClearAllChildren()
		end
	end, 
	["Priority"] = 1
})


local function Cape(char, texture)
	for i,v in pairs(char:GetDescendants()) do
		if v.Name == "Cape" then
			v:Remove()
		end
	end
	local hum = char:WaitForChild("Humanoid")
	local torso = nil
	if hum.RigType == Enum.HumanoidRigType.R15 then
	torso = char:WaitForChild("UpperTorso")
	else
	torso = char:WaitForChild("Torso")
	end
	local p = Instance.new("Part", torso.Parent)
	p.Name = "Cape"
	p.Anchored = false
	p.CanCollide = false
	p.TopSurface = 0
	p.BottomSurface = 0
	p.FormFactor = "Custom"
	p.Size = Vector3.new(0.2,0.2,0.2)
	p.Transparency = 1
	local decal = Instance.new("Decal", p)
	decal.Texture = texture
	decal.Face = "Back"
	local msh = Instance.new("BlockMesh", p)
	msh.Scale = Vector3.new(9,17.5,0.5)
	local motor = Instance.new("Motor", p)
	motor.Part0 = p
	motor.Part1 = torso
	motor.MaxVelocity = 0.01
	motor.C0 = CFrame.new(0,2,0) * CFrame.Angles(0,math.rad(90),0)
	motor.C1 = CFrame.new(0,1,0.45) * CFrame.Angles(0,math.rad(90),0)
	local wave = false
	repeat wait(1/44)
		decal.Transparency = torso.Transparency
		local ang = 0.1
		local oldmag = torso.Velocity.magnitude
		local mv = 0.002
		if wave then
			ang = ang + ((torso.Velocity.magnitude/10) * 0.05) + 0.05
			wave = false
		else
			wave = true
		end
		ang = ang + math.min(torso.Velocity.magnitude/11, 0.5)
		motor.MaxVelocity = math.min((torso.Velocity.magnitude/111), 0.04) --+ mv
		motor.DesiredAngle = -ang
		if motor.CurrentAngle < -0.2 and motor.DesiredAngle > -0.2 then
			motor.MaxVelocity = 0.04
		end
		repeat wait() until motor.CurrentAngle == motor.DesiredAngle or math.abs(torso.Velocity.magnitude - oldmag) >= (torso.Velocity.magnitude/10) + 1
		if torso.Velocity.magnitude < 0.1 then
			wait(0.1)
		end
	until not p or p.Parent ~= torso.Parent
end

local mousefunctions = mouse1release and mouse1press and (isrbxactive or iswindowactive) and true or false
runcode(function()
	local aimfov = {["Value"] = 1}
	local aimfovshow = {["Enabled"] = false}
	local aimvischeck = {["Enabled"] = false}
	local aimwallbang = {["Enabled"] = false}
	local aimautofire = {["Enabled"] = false}
	local aimsmartignore = {["Enabled"] = false}
	local aimsmartab = {}
	local aimfovframecolor = {["Value"] = 0.44}
	local aimheadshotchance = {["Value"] = 1}
	local aimassisttarget
	local aimhitchance = {["Value"] = 1}
	local aimmethod = {["Value"] = "FindPartOnRayWithIgnoreList"}
	local aimmode = {["Value"] = "Legit"}
	local aimmethodmode = {["Value"] = "Whitelist"}
	local aimignoredscripts = {["ObjectList"] = {}}
	local aimbound
	local shoottime = tick()
	local recentlyshotplr
	local recentlyshottick = tick()
	local aimfovframe
	local pressed = false
	local filterobj
	local tar = nil
	local AimAssist = {["Enabled"] = false}

	local function isNotHoveringOverGui()
		local mousepos = uis:GetMouseLocation() - Vector2.new(0, 36)
		for i,v in pairs(lplr.PlayerGui:GetGuiObjectsAtPosition(mousepos.X, mousepos.Y)) do 
			if v.Active and v.Visible and v:FindFirstAncestorOfClass("ScreenGui").Enabled then
				return false
			end
		end
		for i,v in pairs(game:GetService("CoreGui"):GetGuiObjectsAtPosition(mousepos.X, mousepos.Y)) do 
			if v.Active and v.Visible and v:FindFirstAncestorOfClass("ScreenGui").Enabled then
				return false
			end
		end
		return true
	end

local autoclickercps = {["GetRandomValue"] = function() return 1 end}
local autoclicker = {["Enabled"] = false}
local autoclickermode = {["Value"] = "Sword"}
local autoclickertick = tick()
autoclicker = GuiLibrary["ObjectsThatCanBeSaved"]["CombatWindow"]["Api"].CreateOptionsButton({
	["Name"] = "AutoClicker", 
	["Function"] = function(callback)
		if callback then
			RunLoops:BindToRenderStep("AutoClicker", 1, function() 
				if entity.isAlive and autoclickertick <= tick() then
					if autoclickermode["Value"] == "Tool" then
						local tool = lplr and lplr.Character and lplr.Character:FindFirstChildWhichIsA("Tool")
						if tool and uis:IsMouseButtonPressed(0) then
							tool:Activate()
							autoclickertick = tick() + (1 / autoclickercps["GetRandomValue"]()) * Random.new().NextNumber(Random.new(), 0.75, 1)
						end
					else
						if mousefunctions then
							if (isrbxactive or iswindowactive)() and GuiLibrary["MainGui"].ScaledGui.ClickGui.Visible == false then
								local clickfunc = (autoclickermode["Value"] == "Click" and mouse1click or mouse2click)
								clickfunc()
								autoclickertick = tick() + (1 / autoclickercps["GetRandomValue"]()) * Random.new().NextNumber(Random.new(), 0.75, 1)
							end
						else
							createwarning("AutoClicker", "Mouse functions missing", 5)
							if autoclicker["Enabled"] then
								autoclicker["ToggleButton"](false)
							end
						end
					end
				end
			end)
		else
			RunLoops:UnbindFromRenderStep("AutoClicker")
		end
	end
})
autoclickermode = autoclicker.CreateDropdown({
	["Name"] = "Mode",
	["List"] = {"Tool", "Click", "RightClick"},
	["Function"] = function() end
})
autoclickercps = autoclicker.CreateTwoSlider({
	["Name"] = "CPS",
	["Min"] = 1,
	["Max"] = 20, 
	["Default"] = 8,
	["Default2"] = 12
})

local healthColorToPosition = {
	[0.01] = Color3.fromRGB(255, 28, 0);
	[0.5] = Color3.fromRGB(250, 235, 0);
	[0.99] = Color3.fromRGB(27, 252, 107);
}

local function HealthbarColorTransferFunction(healthPercent)
	healthPercent = math.clamp(healthPercent, 0.01, 0.99)
	local lastcolor = Color3.new(1, 1, 1)
	for samplePoint, colorSampleValue in pairs(healthColorToPosition) do
		local distance = (healthPercent / samplePoint)
		if distance == 1 then
			return colorSampleValue
		elseif distance < 1 then 
			return lastcolor:lerp(colorSampleValue, distance)
		else
			lastcolor = colorSampleValue
		end
	end
	return lastcolor
end

local ArrowsFolder = Instance.new("Folder")
ArrowsFolder.Name = "ArrowsFolder"
ArrowsFolder.Parent = GuiLibrary["MainGui"]
players.PlayerRemoving:connect(function(plr)
	if ArrowsFolder:FindFirstChild(plr.Name) then
		ArrowsFolder[plr.Name]:Remove()
	end
end)
local ArrowsColor = {["Value"] = 0.44}
local ArrowsTeammate = {["Enabled"] = true}
local Arrows = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
	["Name"] = "Arrows", 
	["Function"] = function(callback) 
		if callback then
			RunLoops:BindToRenderStep("Arrows", 500, function()
				for i,plr in pairs(players:GetChildren()) do
					local thing
					if ArrowsFolder:FindFirstChild(plr.Name) then
						thing = ArrowsFolder[plr.Name]
						thing.Visible = false
						thing.ImageColor3 = getPlayerColor(plr) or Color3.fromHSV(ArrowsColor["Hue"], ArrowsColor["Sat"], ArrowsColor["Value"])
					else
						thing = Instance.new("ImageLabel")
						thing.BackgroundTransparency = 1
						thing.BorderSizePixel = 0
						thing.Size = UDim2.new(0, 256, 0, 256)
						thing.AnchorPoint = Vector2.new(0.5, 0.5)
						thing.Position = UDim2.new(0.5, 0, 0.5, 0)
						thing.Visible = false
						thing.Image = getcustomassetfunc("vape/assets/ArrowIndicator.png")
						thing.Name = plr.Name
						thing.Parent = ArrowsFolder
					end
					
					local aliveplr = isAlive(plr)
					if aliveplr and plr ~= lplr and (ArrowsTeammate["Enabled"] or aliveplr.Targetable) then
						local rootPos, rootVis = cam:WorldToViewportPoint(aliveplr.RootPart.Position)
						local camcframeflat = CFrame.new(cam.CFrame.p, cam.CFrame.p + cam.CFrame.lookVector * Vector3.new(1, 0, 1))
						local pointRelativeToCamera = camcframeflat:pointToObjectSpace(aliveplr.RootPart.Position)
						local unitRelativeVector = (pointRelativeToCamera * Vector3.new(1, 0, 1)).unit
						local rotation = math.atan2(unitRelativeVector.Z, unitRelativeVector.X)
						thing.Visible = not rootVis
						thing.Rotation = math.deg(rotation)
					end
				end
			end)
		else
			RunLoops:UnbindFromRenderStep("Arrows") 
			ArrowsFolder:ClearAllChildren()
		end
	end, 
	["HoverText"] = "Draws arrows on screen when entities\nare out of your field of view."
})
ArrowsColor = Arrows.CreateColorSlider({
	["Name"] = "Player Color", 
	["Function"] = function(val) end,
})
ArrowsTeammate = Arrows.CreateToggle({
	["Name"] = "Teammate",
	["Function"] = function() end,
	["Default"] = true
})


runcode(function()
	local Disguise = {["Enabled"] = false}
	local DisguiseId = {["Value"] = ""}
	local desc
	
	local function disguisechar(char)
		task.spawn(function()
			if not char then return end
			local hum = char:WaitForChild("Humanoid")
			char:WaitForChild("Head")
			local desc
			if desc == nil then
				local suc = false
				repeat
					suc = pcall(function()
						desc = players:GetHumanoidDescriptionFromUserId(DisguiseId["Value"] == "" and 239702688 or tonumber(DisguiseId["Value"]))
					end)
					task.wait(1)
				until suc
			end
			desc.HeightScale = hum:WaitForChild("HumanoidDescription").HeightScale
			char.Archivable = true
			local disguiseclone = char:Clone()
			disguiseclone.Name = "disguisechar"
			disguiseclone.Parent = workspace
			for i,v in pairs(disguiseclone:GetChildren()) do 
				if v:IsA("Accessory") or v:IsA("ShirtGraphic") or v:IsA("Shirt") or v:IsA("Pants") then  
					v:Destroy()
				end
			end
			disguiseclone.Humanoid:ApplyDescriptionClientServer(desc)
			for i,v in pairs(char:GetChildren()) do 
				if (v:IsA("Accessory") and v:GetAttribute("InvItem") == nil and v:GetAttribute("ArmorSlot") == nil) or v:IsA("ShirtGraphic") or v:IsA("Shirt") or v:IsA("Pants") or v:IsA("BodyColors") then 
					v.Parent = game
				end
			end
			char.ChildAdded:connect(function(v)
				if ((v:IsA("Accessory") and v:GetAttribute("InvItem") == nil and v:GetAttribute("ArmorSlot") == nil) or v:IsA("ShirtGraphic") or v:IsA("Shirt") or v:IsA("Pants") or v:IsA("BodyColors")) and v:GetAttribute("Disguise") == nil then 
					repeat task.wait() v.Parent = game until v.Parent == game
				end
			end)
			for i,v in pairs(disguiseclone:WaitForChild("Animate"):GetChildren()) do 
				v:SetAttribute("Disguise", true)
				local real = char.Animate:FindFirstChild(v.Name)
				if v:IsA("StringValue") and real then 
					real.Parent = game
					v.Parent = char.Animate
				end
			end
			for i,v in pairs(disguiseclone:GetChildren()) do 
				v:SetAttribute("Disguise", true)
				if v:IsA("Accessory") then  
					for i2,v2 in pairs(v:GetDescendants()) do 
						if v2:IsA("Weld") and v2.Part1 then 
							v2.Part1 = char[v2.Part1.Name]
						end
					end
					v.Parent = char
				elseif v:IsA("ShirtGraphic") or v:IsA("Shirt") or v:IsA("Pants") or v:IsA("BodyColors") then  
					v.Parent = char
				elseif v.Name == "Head" then 
					char.Head.MeshId = v.MeshId
				end
			end
			local localface = char:FindFirstChild("face", true)
			local cloneface = disguiseclone:FindFirstChild("face", true)
			if localface and cloneface then localface.Parent = game cloneface.Parent = char.Head end
			char.Humanoid.HumanoidDescription:SetEmotes(desc:GetEmotes())
			char.Humanoid.HumanoidDescription:SetEquippedEmotes(desc:GetEquippedEmotes())
			disguiseclone:Destroy()
		end)
	end

	local disguiseconnection
	Disguise = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
		["Name"] = "Disguise",
		["Function"] = function(callback)
			if callback then 
				disguiseconnection = lplr.CharacterAdded:connect(disguisechar)
				disguisechar(lplr.Character)
			else
				if disguiseconnection then 
					disguiseconnection:Disconnect()
				end
			end
		end
	})
	DisguiseId = Disguise.CreateTextBox({
		["Name"] = "Disguise",
		["TempText"] = "Disguise User Id",
		["FocusLost"] = function(enter) 
			task.spawn(function() desc = players:GetHumanoidDescriptionFromUserId(DisguiseId["Value"] == "" and 239702688 or tonumber(DisguiseId["Value"])) end)
		end
	})
end)

runcode(function()
	local espfolderdrawing = {}
	local methodused
	local espfolder = Instance.new("Folder")
	espfolder.Parent = GuiLibrary["MainGui"]

	local function floorpos(pos)
		return Vector2.new(math.floor(pos.X), math.floor(pos.Y))
	end

	local ESPColor = {["Value"] = 0.44}
	local ESPHealthBar = {["Enabled"] = false}
	local ESPBoundingBox = {["Enabled"] = true}
	local ESPName = {["Enabled"] = true}
	local ESPMethod = {["Value"] = "2D"}
	local ESPTeammates = {["Enabled"] = true}
	local espconnections = {}
	local addedconnection
	local removedconnection
	local updatedconnection

	local espfuncs1 = {
		Drawing2D = function(plr)
			if ESPTeammates["Enabled"] and (not plr.Targetable) then return end
			local thing = {}
			thing.Quad1 = Drawing.new("Square")
			thing.Quad1.Transparency = ESPBoundingBox["Enabled"] and 1 or 0
			thing.Quad1.ZIndex = 2
			thing.Quad1.Thickness = 1
			thing.Quad1.Color = getPlayerColor(plr.Player) or Color3.fromHSV(ESPColor["Hue"], ESPColor["Sat"], ESPColor["Value"])
			thing.QuadLine2 = Drawing.new("Square")
			thing.QuadLine2.Transparency = ESPBoundingBox["Enabled"] and 0.5 or 0
			thing.QuadLine2.ZIndex = 1
			thing.QuadLine2.Thickness = 1
			thing.QuadLine2.Color = Color3.new(0, 0, 0)
			thing.QuadLine3 = Drawing.new("Square")
			thing.QuadLine3.Transparency = ESPBoundingBox["Enabled"] and 0.5 or 0
			thing.QuadLine3.ZIndex = 1
			thing.QuadLine3.Thickness = 1
			thing.QuadLine3.Color = Color3.new(0, 0, 0)
			if ESPHealthBar["Enabled"] then 
				thing.Quad3 = Drawing.new("Line")
				thing.Quad3.Thickness = 1
				thing.Quad3.ZIndex = 2
				thing.Quad3.Color = Color3.new(0, 1, 0)
				thing.Quad4 = Drawing.new("Line")
				thing.Quad4.Thickness = 3
				thing.Quad4.Transparency = 0.5
				thing.Quad4.ZIndex = 1
				thing.Quad4.Color = Color3.new(0, 0, 0)
			end
			if ESPName["Enabled"] then 
				thing.Text = Drawing.new("Text")
				thing.Text.Text = plr.Player.DisplayName or plr.Player.Name
				thing.Text.ZIndex = 2
				thing.Text.Color = thing.Quad1.Color
				thing.Text.Center = true
				thing.Text.Size = 20
				thing.Drop = Drawing.new("Text")
				thing.Drop.Color = Color3.new()
				thing.Drop.Text = plr.Player.DisplayName or plr.Player.Name
				thing.Drop.ZIndex = 1
				thing.Drop.Center = true
				thing.Drop.Size = 20
			end
			espfolderdrawing[plr.Player] = {entity = plr, Main = thing}
		end,
		Drawing2DV3 = function(plr)
			if ESPTeammates["Enabled"] and (not plr.Targetable) then return end
			local toppoint = PointInstance.new(plr.RootPart, CFrame.new(2, 3, 0))
			local bottompoint = PointInstance.new(plr.RootPart, CFrame.new(-2, -3.5, 0))
			local newobj = RectDynamic.new(toppoint)
			newobj.BottomRight = bottompoint
			newobj.Outlined = ESPBoundingBox["Enabled"]
			newobj.Opacity = ESPBoundingBox["Enabled"] and 1 or 0
			newobj.OutlineOpacity = 0.5
			newobj.Color = getPlayerColor(plr.Player) or Color3.fromHSV(ESPColor["Hue"], ESPColor["Sat"], ESPColor["Value"])
			local newobj2 = {}
			local newobj3 = {}
			if ESPHealthBar["Enabled"] then 
				local topoffset = PointOffset.new(PointInstance.new(plr.RootPart, CFrame.new(-2, 3, 0)), Vector2.new(-5, -1))
				local bottomoffset = PointOffset.new(PointInstance.new(plr.RootPart, CFrame.new(-2, -3.5, 0)), Vector2.new(-3, 1))
				local healthoffset = PointOffset.new(bottomoffset, Vector2.new(-1, -1))
				local healthoffset2 = PointOffset.new(bottomoffset, Vector2.new(-1, -((bottomoffset.ScreenPos.Y - topoffset.ScreenPos.Y) - 1)))
				newobj2.Bkg = RectDynamic.new(topoffset)
				newobj2.Bkg.Filled = true
				newobj2.Bkg.Opacity = 0.5
				newobj2.Bkg.BottomRight = bottomoffset
				newobj2.Line = RectDynamic.new(healthoffset)
				newobj2.Line.Filled = true
				newobj2.Line.YAlignment = YAlignment.Bottom
				newobj2.Line.BottomRight = healthoffset2
				newobj2.Line.Color = HealthbarColorTransferFunction(plr.Humanoid.Health / plr.Humanoid.MaxHealth)
				newobj2.Offset = healthoffset2
				newobj2.TopOffset = topoffset
				newobj2.BottomOffset = bottomoffset
			end
			if ESPName["Enabled"] then 
				local nameoffset1 = PointOffset.new(PointInstance.new(plr.RootPart, CFrame.new(0, 3, 0)), Vector2.new(0, -15))
				local nameoffset2 = PointOffset.new(nameoffset1, Vector2.new(1, 1))
				newobj3.Text = TextDynamic.new(nameoffset1)
				newobj3.Text.Text = plr.Player.DisplayName or plr.Player.Name
				newobj3.Text.Color = newobj.Color
				newobj3.Text.ZIndex = 2
				newobj3.Text.Size = 20
				newobj3.Drop = TextDynamic.new(nameoffset2)
				newobj3.Drop.Text = plr.Player.DisplayName or plr.Player.Name
				newobj3.Drop.Color = Color3.new()
				newobj3.Drop.ZIndex = 1
				newobj3.Drop.Size = 20
			end
			espfolderdrawing[plr.Player] = {entity = plr, Main = newobj, HealthBar = newobj2, Name = newobj3}
		end,
		DrawingSkeleton = function(plr)
			if ESPTeammates["Enabled"] and (not plr.Targetable) then return end
			local thing = {}
			thing.Head = Drawing.new("Line")
			thing.Head2 = Drawing.new("Line")
			thing.Torso = Drawing.new("Line")
			thing.Torso2 = Drawing.new("Line")
			thing.Torso3 = Drawing.new("Line")
			thing.LeftArm = Drawing.new("Line")
			thing.RightArm = Drawing.new("Line")
			thing.LeftLeg = Drawing.new("Line")
			thing.RightLeg = Drawing.new("Line")
			local color = getPlayerColor(plr.Player) or Color3.fromHSV(ESPColor["Hue"], ESPColor["Sat"], ESPColor["Value"])
			for i,v in pairs(thing) do v.Thickness = 2 v.Color = color end
			espfolderdrawing[plr.Player] = {entity = plr, Main = thing}
		end,
		DrawingSkeletonV3 = function(plr)
			if ESPTeammates["Enabled"] and plr.Targetable then return end
			thing = {Main = {}, entity = plr}
			local rigcheck = plr.Humanoid.RigType == Enum.HumanoidRigType.R6
			local head = PointInstance.new(plr.Head)
			head.RotationType = CFrameRotationType.TargetRelative
			local headfront = PointInstance.new(plr.Head, CFrame.new(0, 0, -0.5))
			headfront.RotationType = CFrameRotationType.TargetRelative
			local toplefttorso = PointInstance.new(plr.Character[(rigcheck and "Torso" or "UpperTorso")], CFrame.new(-1.5, 0.8, 0))
			toplefttorso.RotationType = CFrameRotationType.TargetRelative
			local toprighttorso = PointInstance.new(plr.Character[(rigcheck and "Torso" or "UpperTorso")], CFrame.new(1.5, 0.8, 0))
			toprighttorso.RotationType = CFrameRotationType.TargetRelative
			local toptorso = PointInstance.new(plr.Character[(rigcheck and "Torso" or "UpperTorso")], CFrame.new(0, 0.8, 0))
			toptorso.RotationType = CFrameRotationType.TargetRelative
			local bottomtorso = PointInstance.new(plr.Character[(rigcheck and "Torso" or "UpperTorso")], CFrame.new(0, -0.8, 0))
			bottomtorso.RotationType = CFrameRotationType.TargetRelative
			local bottomlefttorso = PointInstance.new(plr.Character[(rigcheck and "Torso" or "UpperTorso")], CFrame.new(-0.5, -0.8, 0))
			bottomlefttorso.RotationType = CFrameRotationType.TargetRelative
			local bottomrighttorso = PointInstance.new(plr.Character[(rigcheck and "Torso" or "UpperTorso")], CFrame.new(0.5, -0.8, 0))
			bottomrighttorso.RotationType = CFrameRotationType.TargetRelative
			local leftarm = PointInstance.new(plr.Character[(rigcheck and "Left Arm" or "LeftHand")], CFrame.new(0, -0.8, 0))
			leftarm.RotationType = CFrameRotationType.TargetRelative
			local rightarm = PointInstance.new(plr.Character[(rigcheck and "Right Arm" or "RightHand")], CFrame.new(0, -0.8, 0))
			rightarm.RotationType = CFrameRotationType.TargetRelative
			local leftleg = PointInstance.new(plr.Character[(rigcheck and "Left Leg" or "LeftFoot")], CFrame.new(0, -0.8, 0))
			leftleg.RotationType = CFrameRotationType.TargetRelative
			local rightleg = PointInstance.new(plr.Character[(rigcheck and "Right Leg" or "RightFoot")], CFrame.new(0, -0.8, 0))
			rightleg.RotationType = CFrameRotationType.TargetRelative
			thing.Main.Head = LineDynamic.new(toptorso, head)
			thing.Main.Head2 = LineDynamic.new(head, headfront)
			thing.Main.Torso = LineDynamic.new(toplefttorso, toprighttorso)
			thing.Main.Torso2 = LineDynamic.new(toptorso, bottomtorso)
			thing.Main.Torso3 = LineDynamic.new(bottomlefttorso, bottomrighttorso)
			thing.Main.LeftArm = LineDynamic.new(toplefttorso, leftarm)
			thing.Main.RightArm = LineDynamic.new(toprighttorso, rightarm)
			thing.Main.LeftLeg = LineDynamic.new(bottomlefttorso, leftleg)
			thing.Main.RightLeg = LineDynamic.new(bottomrighttorso, rightleg)
			local color = getPlayerColor(plr.Player) or Color3.fromHSV(ESPColor["Hue"], ESPColor["Sat"], ESPColor["Value"])
			for i,v in pairs(thing) do v.Thickness = 2 v.Color = color end
			espfolderdrawing[plr.Player] = thing
		end,
		Drawing3D = function(plr)
			if ESPTeammates["Enabled"] and (not plr.Targetable) then return end
			local thing = {}
			thing.Line1 = Drawing.new("Line")
			thing.Line2 = Drawing.new("Line")
			thing.Line3 = Drawing.new("Line")
			thing.Line4 = Drawing.new("Line")
			thing.Line5 = Drawing.new("Line")
			thing.Line6 = Drawing.new("Line")
			thing.Line7 = Drawing.new("Line")
			thing.Line8 = Drawing.new("Line")
			thing.Line9 = Drawing.new("Line")
			thing.Line10 = Drawing.new("Line")
			thing.Line11 = Drawing.new("Line")
			thing.Line12 = Drawing.new("Line")
			local color = getPlayerColor(plr.Player) or Color3.fromHSV(ESPColor["Hue"], ESPColor["Sat"], ESPColor["Value"])
			for i,v in pairs(thing) do v.Thickness = 1 v.Color = color end
			espfolderdrawing[plr.Player] = {entity = plr, Main = thing}
		end,
		Drawing3DV3 = function(plr)
			if ESPTeammates["Enabled"] and (not plr.Targetable) then return end
			thing = {}
			local point1 = PointInstance.new(plr.RootPart, CFrame.new(1.5, 3, 1.5))
			point1.RotationType = CFrameRotationType.Ignore
			local point2 = PointInstance.new(plr.RootPart, CFrame.new(1.5, -3, 1.5))
			point2.RotationType = CFrameRotationType.Ignore
			local point3 = PointInstance.new(plr.RootPart, CFrame.new(-1.5, 3, 1.5))
			point3.RotationType = CFrameRotationType.Ignore
			local point4 = PointInstance.new(plr.RootPart, CFrame.new(-1.5, -3, 1.5))
			point4.RotationType = CFrameRotationType.Ignore
			local point5 = PointInstance.new(plr.RootPart, CFrame.new(1.5, 3, -1.5))
			point5.RotationType = CFrameRotationType.Ignore
			local point6 = PointInstance.new(plr.RootPart, CFrame.new(1.5, -3, -1.5))
			point6.RotationType = CFrameRotationType.Ignore
			local point7 = PointInstance.new(plr.RootPart, CFrame.new(-1.5, 3, -1.5))
			point7.RotationType = CFrameRotationType.Ignore
			local point8 = PointInstance.new(plr.RootPart, CFrame.new(-1.5, -3, -1.5))
			point8.RotationType = CFrameRotationType.Ignore
			thing.Line1 = LineDynamic.new(point1, point2)
			thing.Line2 = LineDynamic.new(point3, point4)
			thing.Line3 = LineDynamic.new(point5, point6)
			thing.Line4 = LineDynamic.new(point7, point8)
			thing.Line5 = LineDynamic.new(point1, point3)
			thing.Line6 = LineDynamic.new(point1, point5)
			thing.Line7 = LineDynamic.new(point5, point7)
			thing.Line8 = LineDynamic.new(point7, point3)
			thing.Line9 = LineDynamic.new(point2, point4)
			thing.Line10 = LineDynamic.new(point2, point6)
			thing.Line11 = LineDynamic.new(point6, point8)
			thing.Line12 = LineDynamic.new(point8, point4)
			local color = getPlayerColor(plr.Player) or Color3.fromHSV(ESPColor["Hue"], ESPColor["Sat"], ESPColor["Value"])
			for i,v in pairs(thing) do v.Thickness = 1 v.Color = color end
			espfolderdrawing[plr.Player] = {entity = plr, Main = thing}
		end
	}
	local espfuncs2 = {
		Drawing2D = function(ent)
			local v = espfolderdrawing[ent]
			espfolderdrawing[ent] = nil
			if v then 
				for i2,v2 in pairs(v.Main) do
					pcall(function() v2.Visible = false v2:Remove() end)
				end
			end
		end,
		Drawing2DV3 = function(ent)
			local v = espfolderdrawing[ent]
			espfolderdrawing[ent] = nil
			if v then
				v.Main.Visible = false
				for i2,v2 in pairs(v.HealthBar) do
					if typeof(v2):find("Point") == nil then 
						v2.Visible = false
					end
				end
				for i2,v2 in pairs(v.Name) do
					if typeof(v2):find("Point") == nil then 
						v2.Visible = false
					end
				end
			end
		end,
		Drawing3D = function(ent)
			local v = espfolderdrawing[ent]
			espfolderdrawing[ent] = nil
			if v then 
				for i2,v2 in pairs(v.Main) do
					pcall(function() v2.Visible = false v2:Remove() end)
				end
			end
		end,
		Drawing3DV3 = function(ent)
			local v = espfolderdrawing[ent]
			espfolderdrawing[ent] = nil
			if v then
				for i2,v2 in pairs(v.Main) do
					if typeof(v2):find("Dynamic") then 
						v2.Visible = false
					end
				end
			end
		end,
		DrawingSkeleton = function(ent)
			local v = espfolderdrawing[ent]
			espfolderdrawing[ent] = nil
			if v then 
				for i2,v2 in pairs(v.Main) do
					pcall(function() v2.Visible = false v2:Remove() end)
				end
			end
		end,
		DrawingSkeletonV3 = function(ent)
			local v = espfolderdrawing[ent]
			espfolderdrawing[ent] = nil
			if v then 
				for i2,v2 in pairs(v.Main) do
					if typeof(v2):find("Dynamic") then 
						v2.Visible = false
					end
				end
			end
		end
	}
	local espupdatefuncs = {
		Drawing2D = function(ent)
			local v = espfolderdrawing[ent.Player]
			if v and v.Main.Quad3 then 
				local color = HealthbarColorTransferFunction(ent.Humanoid.Health / ent.Humanoid.MaxHealth)
				v.Main.Quad3.Color = color
			end
		end,
		Drawing2DV3 = function(ent)
			local v = espfolderdrawing[ent.Player]
			if v and v.HealthBar.Line then 
				local health = ent.Humanoid.Health / ent.Humanoid.MaxHealth
				local color = HealthbarColorTransferFunction(health)
				v.HealthBar.Line.Color = color
			end
		end
	}
	local espcolorfuncs = {
		Drawing2D = function(hue, sat, value)
			local color = Color3.fromHSV(hue, sat, value)
			for i,v in pairs(espfolderdrawing) do 
				v.Main.Quad1.Color = getPlayerColor(v.entity.Player) or color
				if v.Main.Text then 
					v.Main.Text.Color = v.Main.Quad1.Color
				end
			end
		end,
		Drawing2DV3 = function(hue, sat, value)
			local color = Color3.fromHSV(hue, sat, value)
			for i,v in pairs(espfolderdrawing) do 
				v.Main.Color = getPlayerColor(v.entity.Player) or color
				if v.Name.Text then 
					v.Name.Text.Color = v.Main.Color
				end
			end
		end,
		Drawing3D = function(hue, sat, value)
			local color = Color3.fromHSV(hue, sat, value)
			for i,v in pairs(espfolderdrawing) do 
				for i2,v2 in pairs(v.Main) do
					v2.Color = getPlayerColor(v.entity.Player) or color
				end
			end
		end,
		Drawing3DV3 = function(hue, sat, value)
			local color = Color3.fromHSV(hue, sat, value)
			for i,v in pairs(espfolderdrawing) do 
				for i2,v2 in pairs(v.Main) do
					if typeof(v2):find("Dynamic") then 
						v2.Color = getPlayerColor(v.entity.Player) or color
					end
				end
			end
		end,
		DrawingSkeleton = function(hue, sat, value)
			local color = Color3.fromHSV(hue, sat, value)
			for i,v in pairs(espfolderdrawing) do 
				for i2,v2 in pairs(v.Main) do
					v2.Color = getPlayerColor(v.entity.Player) or color
				end
			end
		end,
		DrawingSkeletonV3 = function(hue, sat, value)
			local color = Color3.fromHSV(hue, sat, value)
			for i,v in pairs(espfolderdrawing) do 
				for i2,v2 in pairs(v.Main) do
					if typeof(v2):find("Dynamic") then 
						v2.Color = getPlayerColor(v.entity.Player) or color
					end
				end
			end
		end,
	}
	local esploop = {
		Drawing2D = function()
			for i,v in pairs(espfolderdrawing) do 
				local rootPos, rootVis = cam:WorldToViewportPoint(v.entity.RootPart.Position)
				if not rootVis then 
					v.Main.Quad1.Visible = false
					v.Main.QuadLine2.Visible = false
					v.Main.QuadLine3.Visible = false
					if v.Main.Quad3 then 
						v.Main.Quad3.Visible = false
						v.Main.Quad4.Visible = false
					end
					if v.Main.Text then 
						v.Main.Text.Visible = false
						v.Main.Drop.Visible = false
					end
					continue 
				end
				local topPos, topVis = cam:WorldToViewportPoint((CFrame.new(v.entity.RootPart.Position, v.entity.RootPart.Position + cam.CFrame.lookVector) * CFrame.new(2, 3, 0)).p)
				local bottomPos, bottomVis = cam:WorldToViewportPoint((CFrame.new(v.entity.RootPart.Position, v.entity.RootPart.Position + cam.CFrame.lookVector) * CFrame.new(-2, -3.5, 0)).p)
				local sizex, sizey = topPos.X - bottomPos.X, topPos.Y - bottomPos.Y
				local posx, posy = (rootPos.X - sizex / 2),  ((rootPos.Y - sizey / 2))
				v.Main.Quad1.Position = floorpos(Vector2.new(posx, posy))
				v.Main.Quad1.Size = floorpos(Vector2.new(sizex, sizey))
				v.Main.Quad1.Visible = true
				v.Main.QuadLine2.Position = floorpos(Vector2.new(posx - 1, posy + 1))
				v.Main.QuadLine2.Size = floorpos(Vector2.new(sizex + 2, sizey - 2))
				v.Main.QuadLine2.Visible = true
				v.Main.QuadLine3.Position = floorpos(Vector2.new(posx + 1, posy - 1))
				v.Main.QuadLine3.Size = floorpos(Vector2.new(sizex - 2, sizey + 2))
				v.Main.QuadLine3.Visible = true
				if v.Main.Quad3 then 
					local healthposy = sizey * math.clamp(v.entity.Humanoid.Health / v.entity.Humanoid.MaxHealth, 0, 1)
					v.Main.Quad3.Visible = v.entity.Humanoid.Health > 0
					v.Main.Quad3.From = floorpos(Vector2.new(posx - 4, posy + (sizey - (sizey - healthposy))))
					v.Main.Quad3.To = floorpos(Vector2.new(posx - 4, posy))
					v.Main.Quad4.Visible = true
					v.Main.Quad4.From = floorpos(Vector2.new(posx - 4, posy))
					v.Main.Quad4.To = floorpos(Vector2.new(posx - 4, (posy + sizey)))
				end
				if v.Main.Text then 
					v.Main.Text.Visible = true
					v.Main.Drop.Visible = true
					v.Main.Text.Position = floorpos(Vector2.new(posx + (sizex / 2), posy + (sizey - 25)))
					v.Main.Drop.Position = v.Main.Text.Position + Vector2.new(1, 1)
				end
			end
		end,
		Drawing2DV3 = function()
			for i,v in pairs(espfolderdrawing) do 
				if v.HealthBar.Offset then 
					v.HealthBar.Offset.Offset = Vector2.new(-1, -(((v.HealthBar.BottomOffset.ScreenPos.Y - v.HealthBar.TopOffset.ScreenPos.Y) - 1) * (v.entity.Humanoid.Health / v.entity.Humanoid.MaxHealth)))
					v.HealthBar.Line.Visible = v.entity.Humanoid.Health > 0
				end
			end
		end,
		Drawing3D = function()
			for i,v in pairs(espfolderdrawing) do 
				local rootPos, rootVis = cam:WorldToViewportPoint(v.entity.RootPart.Position)
				if not rootVis then 
					for i,v in pairs(v.Main) do 
						v.Visible = false
					end
					continue 
				end
				for i,v in pairs(v.Main) do 
					v.Visible = true
				end
				local point1 = CalculateObjectPosition(v.entity.RootPart.Position + Vector3.new(1.5, 3, 1.5))
				local point2 = CalculateObjectPosition(v.entity.RootPart.Position + Vector3.new(1.5, -3, 1.5))
				local point3 = CalculateObjectPosition(v.entity.RootPart.Position + Vector3.new(-1.5, 3, 1.5))
				local point4 = CalculateObjectPosition(v.entity.RootPart.Position + Vector3.new(-1.5, -3, 1.5))
				local point5 = CalculateObjectPosition(v.entity.RootPart.Position + Vector3.new(1.5, 3, -1.5))
				local point6 = CalculateObjectPosition(v.entity.RootPart.Position + Vector3.new(1.5, -3, -1.5))
				local point7 = CalculateObjectPosition(v.entity.RootPart.Position + Vector3.new(-1.5, 3, -1.5))
				local point8 = CalculateObjectPosition(v.entity.RootPart.Position + Vector3.new(-1.5, -3, -1.5))
				v.Main.Line1.From = point1
				v.Main.Line1.To = point2
				v.Main.Line2.From = point3
				v.Main.Line2.To = point4
				v.Main.Line3.From = point5
				v.Main.Line3.To = point6
				v.Main.Line4.From = point7
				v.Main.Line4.To = point8
				v.Main.Line5.From = point1
				v.Main.Line5.To = point3
				v.Main.Line6.From = point1
				v.Main.Line6.To = point5
				v.Main.Line7.From = point5
				v.Main.Line7.To = point7
				v.Main.Line8.From = point7
				v.Main.Line8.To = point3
				v.Main.Line9.From = point2
				v.Main.Line9.To = point4
				v.Main.Line10.From = point2
				v.Main.Line10.To = point6
				v.Main.Line11.From = point6
				v.Main.Line11.To = point8
				v.Main.Line12.From = point8
				v.Main.Line12.To = point4
			end
		end,
		DrawingSkeleton = function()
			for i,v in pairs(espfolderdrawing) do 
				local rootPos, rootVis = cam:WorldToViewportPoint(v.entity.RootPart.Position)
				if not rootVis then 
					for i,v in pairs(v.Main) do 
						v.Visible = false
					end
					continue 
				end
				for i,v in pairs(v.Main) do 
					v.Visible = true
				end
				local rigcheck = v.entity.Humanoid.RigType == Enum.HumanoidRigType.R6
				local head = CalculateObjectPosition((v.entity.Head.CFrame).p)
				local headfront = CalculateObjectPosition((v.entity.Head.CFrame * CFrame.new(0, 0, -0.5)).p)
				local toplefttorso = CalculateObjectPosition((v.entity.Character[(rigcheck and "Torso" or "UpperTorso")].CFrame * CFrame.new(-1.5, 0.8, 0)).p)
				local toprighttorso = CalculateObjectPosition((v.entity.Character[(rigcheck and "Torso" or "UpperTorso")].CFrame * CFrame.new(1.5, 0.8, 0)).p)
				local toptorso = CalculateObjectPosition((v.entity.Character[(rigcheck and "Torso" or "UpperTorso")].CFrame * CFrame.new(0, 0.8, 0)).p)
				local bottomtorso = CalculateObjectPosition((v.entity.Character[(rigcheck and "Torso" or "UpperTorso")].CFrame * CFrame.new(0, -0.8, 0)).p)
				local bottomlefttorso = CalculateObjectPosition((v.entity.Character[(rigcheck and "Torso" or "UpperTorso")].CFrame * CFrame.new(-0.5, -0.8, 0)).p)
				local bottomrighttorso = CalculateObjectPosition((v.entity.Character[(rigcheck and "Torso" or "UpperTorso")].CFrame * CFrame.new(0.5, -0.8, 0)).p)
				local leftarm = CalculateObjectPosition((v.entity.Character[(rigcheck and "Left Arm" or "LeftHand")].CFrame * CFrame.new(0, -0.8, 0)).p)
				local rightarm = CalculateObjectPosition((v.entity.Character[(rigcheck and "Right Arm" or "RightHand")].CFrame * CFrame.new(0, -0.8, 0)).p)
				local leftleg = CalculateObjectPosition((v.entity.Character[(rigcheck and "Left Leg" or "LeftFoot")].CFrame * CFrame.new(0, -0.8, 0)).p)
				local rightleg = CalculateObjectPosition((v.entity.Character[(rigcheck and "Right Leg" or "RightFoot")].CFrame * CFrame.new(0, -0.8, 0)).p)
				v.Main.Torso.From = toplefttorso
				v.Main.Torso.To = toprighttorso
				v.Main.Torso2.From = toptorso
				v.Main.Torso2.To = bottomtorso
				v.Main.Torso3.From = bottomlefttorso
				v.Main.Torso3.To = bottomrighttorso
				v.Main.LeftArm.From = toplefttorso
				v.Main.LeftArm.To = leftarm
				v.Main.RightArm.From = toprighttorso
				v.Main.RightArm.To = rightarm
				v.Main.LeftLeg.From = bottomlefttorso
				v.Main.LeftLeg.To = leftleg
				v.Main.RightLeg.From = bottomrighttorso
				v.Main.RightLeg.To = rightleg
				v.Main.Head.From = toptorso
				v.Main.Head.To = head
				v.Main.Head2.From = head
				v.Main.Head2.To = headfront
			end
		end
	}

	local ESP = {Enabled = false}
	ESP = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
		["Name"] = "ESP", 
		["Function"] = function(callback) 
			if callback then
				methodused = "Drawing"..ESPMethod["Value"]..v3check
				if espfuncs2[methodused] then
					removedconnection = entity.entityRemovedEvent:connect(espfuncs2[methodused])
				end
				if espfuncs1[methodused] then
					local addfunc = espfuncs1[methodused]
					for i,v in pairs(entity.entityList) do 
						if espfolderdrawing[v.Player] then espfuncs2[methodused](v.Player) end
						addfunc(v)
					end
					addedconnection = entity.entityAddedEvent:connect(function(ent)
						if espfolderdrawing[ent.Player] then espfuncs2[methodused](ent.Player) end
						addfunc(ent)
					end)
				end
				if espupdatefuncs[methodused] then
					updatedconnection = entity.entityUpdatedEvent:connect(espupdatefuncs[methodused])
					for i,v in pairs(entity.entityList) do 
						espupdatefuncs[methodused](v)
					end
				end
				if esploop[methodused] then 
					RunLoops:BindToRenderStep("ESP", 1, esploop[methodused])
				end
			else
				RunLoops:UnbindFromRenderStep("ESP")
				if addedconnection then 
					addedconnection:Disconnect()
				end
				if updatedconnection then 
					updatedconnection:Disconnect()
				end
				if removedconnection then 
					removedconnection:Disconnect()
				end
				if espfuncs2[methodused] then
					for i,v in pairs(entity.entityList) do 
						if espfolderdrawing[v.Player] then
							espfuncs2[methodused](v.Player)
						end
					end
				end
			end
		end,
		["HoverText"] = "Extra Sensory Perception\nRenders an ESP on players."
	})
	ESPColor = ESP.CreateColorSlider({
		["Name"] = "Player Color", 
		["Function"] = function(hue, sat, val) 
			if ESP["Enabled"] and espcolorfuncs[methodused] then 
				espcolorfuncs[methodused](hue, sat, val)
			end
		end
	})
	ESPMethod = ESP.CreateDropdown({
		["Name"] = "Mode",
		["List"] = {"2D", "3D", "Skeleton"},
		["Function"] = function(val)
			if ESP["Enabled"] then ESP["ToggleButton"](true) ESP["ToggleButton"](true) end
			ESPBoundingBox["Object"].Visible = (val == "2D")
			ESPHealthBar["Object"].Visible = (val == "2D")
			ESPName["Object"].Visible = (val == "2D")
		end,
	})
	ESPBoundingBox = ESP.CreateToggle({
		["Name"] = "Bounding Box",
		["Function"] = function() if ESP["Enabled"] then ESP["ToggleButton"](true) ESP["ToggleButton"](true) end end,
		["Default"] = true
	})
	ESPTeammates = ESP.CreateToggle({
		["Name"] = "Priority Only",
		["Function"] = function() if ESP["Enabled"] then ESP["ToggleButton"](true) ESP["ToggleButton"](true) end end,
		["Default"] = true
	})
	ESPHealthBar = ESP.CreateToggle({
		["Name"] = "Health Bar", 
		["Function"] = function(callback) if ESP["Enabled"] then ESP["ToggleButton"](true) ESP["ToggleButton"](true) end end
	})
	ESPName = ESP.CreateToggle({
		["Name"] = "Name", 
		["Function"] = function(callback) if ESP["Enabled"] then ESP["ToggleButton"](true) ESP["ToggleButton"](true) end end
	})
end)

runcode(function()
	local ChamsFolder = Instance.new("Folder")
	ChamsFolder.Name = "ChamsFolder"
	ChamsFolder.Parent = GuiLibrary["MainGui"]
	players.PlayerRemoving:connect(function(plr)
		if ChamsFolder:FindFirstChild(plr.Name) then
			ChamsFolder[plr.Name]:Remove()
		end
	end)
	local ChamsColor = {["Value"] = 0.44}
	local ChamsOutlineColor = {["Value"] = 0.44}
	local ChamsBetter = {["Enabled"] = false}
	local ChamsTransparency = {["Value"] = 1}
	local ChamsOutlineTransparency = {["Value"] = 1}
	local ChamsOnTop = {["Enabled"] = true}
	local chamobjects = {["Head"] = true, ["Torso"] = true, ["UpperTorso"] = true, ["LowerTorso"] = true, ["Left Arm"] = true, ["Left Leg"] = true, ["Right Arm"] = true, ["Right Leg"] = true, ["LeftLowerLeg"] = true, ["RightLowerLeg"] = true, ["LeftUpperLeg"] = true, ["RightUpperLeg"] = true, ["LeftFoot"] = true, ["RightFoot"] = true, ["LeftLowerArm"] = true, ["RightLowerArm"] = true, ["LeftUpperArm"] = true, ["RightUpperArm"] = true, ["LeftHand"] = true, ["RightHand"] = true}
	local ChamsTeammates = {["Enabled"] = true}
	local ChamsAlive = {["Enabled"] = false}
	local Chams = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
		["Name"] = "Chams", 
		["Function"] = function(callback) 
			if callback then
				RunLoops:BindToRenderStep("Chams", 500, function()
					for i,plr in pairs(players:GetChildren()) do
						local thing
						if ChamsFolder:FindFirstChild(plr.Name) then
							thing = ChamsFolder[plr.Name]
							thing.Enabled = false
							thing.FillColor = getPlayerColor(plr) or Color3.fromHSV(ChamsColor["Hue"], ChamsColor["Sat"], ChamsColor["Value"])
							thing.OutlineColor = getPlayerColor(plr) or Color3.fromHSV(ChamsOutlineColor["Hue"], ChamsOutlineColor["Sat"], ChamsOutlineColor["Value"])
						end

						local aliveplr = isAlive(plr, ChamsAlive["Enabled"])
						if aliveplr and plr ~= lplr and (ChamsTeammates["Enabled"] or aliveplr.Targetable) then
							if ChamsFolder:FindFirstChild(plr.Name) == nil then
								local chamfolder = Instance.new("Highlight")
								chamfolder.Name = plr.Name
								chamfolder.Parent = ChamsFolder
								thing = chamfolder
							end
							thing.Enabled = true
							thing.Adornee = aliveplr.Character
							thing.OutlineTransparency = ChamsOutlineTransparency["Value"] / 100
							thing.DepthMode = Enum.HighlightDepthMode[(ChamsOnTop["Enabled"] and "AlwaysOnTop" or "Occluded")]
							thing.FillTransparency = ChamsTransparency["Value"] / 100
						end
					end
				end)
			else
				RunLoops:UnbindFromRenderStep("Chams")
				ChamsFolder:ClearAllChildren()
			end
		end,
		["HoverText"] = "Render players through walls"
	})
	ChamsColor = Chams.CreateColorSlider({
		["Name"] = "Player Color", 
		["Function"] = function(val) end
	})
	ChamsOutlineColor = Chams.CreateColorSlider({
		["Name"] = "Outline Player Color", 
		["Function"] = function(val) end
	})
	ChamsTransparency = Chams.CreateSlider({
		["Name"] = "Transparency", 
		["Min"] = 1,
		["Max"] = 100, 
		["Function"] = function(val) end,
		["Default"] = 50
	})
	ChamsOutlineTransparency = Chams.CreateSlider({
		["Name"] = "Outline Transparency", 
		["Min"] = 1,
		["Max"] = 100, 
		["Function"] = function(val) end,
		["Default"] = 1
	})
	ChamsTeammates = Chams.CreateToggle({
		["Name"] = "Teammates",
		["Function"] = function() end,
		["Default"] = true
	})
	ChamsOnTop = Chams.CreateToggle({
		["Name"] = "Bypass Walls", 
		["Function"] = function() end
	})
	ChamsAlive = Chams.CreateToggle({
		["Name"] = "Alive Check",
		["Function"] = function() end
	})
end)

local lightingsettings = {}
local lightingconnection
local lightingchanged = false
GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
	["Name"] = "Fullbright",
	["Function"] = function(callback)
		if callback then 
			lightingsettings["Brightness"] = lighting.Brightness
			lightingsettings["ClockTime"] = lighting.ClockTime
			lightingsettings["FogEnd"] = lighting.FogEnd
			lightingsettings["GlobalShadows"] = lighting.GlobalShadows
			lightingsettings["OutdoorAmbient"] = lighting.OutdoorAmbient
			lightingchanged = false
			lighting.Brightness = 2
			lighting.ClockTime = 14
			lighting.FogEnd = 100000
			lighting.GlobalShadows = false
			lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
			lightingchanged = true
			lightingconnection = lighting.Changed:connect(function()
				if not lightingchanged then
					lightingsettings["Brightness"] = lighting.Brightness
					lightingsettings["ClockTime"] = lighting.ClockTime
					lightingsettings["FogEnd"] = lighting.FogEnd
					lightingsettings["GlobalShadows"] = lighting.GlobalShadows
					lightingsettings["OutdoorAmbient"] = lighting.OutdoorAmbient
					lightingchanged = true
					lighting.Brightness = 2
					lighting.ClockTime = 14
					lighting.FogEnd = 100000
					lighting.GlobalShadows = false
					lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
					lightingchanged = false
				end
			end)
		else
			for name,thing in pairs(lightingsettings) do 
				lighting[name] = thing 
			end
			lightingconnection:Disconnect()  
		end
	end
})

local HealthText = Instance.new("TextLabel")
HealthText.Font = Enum.Font.SourceSans
HealthText.TextSize = 20
HealthText.Text = "100❤"
HealthText.Position = UDim2.new(0.5, 0, 0.5, 70)
HealthText.BackgroundTransparency = 1
HealthText.TextColor3 = Color3.fromRGB(255, 0, 0)
HealthText.Size = UDim2.new(0, 0, 0, 0)
HealthText.Visible = false
HealthText.Parent = GuiLibrary["MainGui"]
local Health = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
	["Name"] = "Health", 
	["Function"] = function(callback) 
		if callback then
			HealthText.Visible = true
			RunLoops:BindToRenderStep("Health", 1, function()
				if entity.isAlive then
					HealthText.Text = tostring(math.round(entity.character.Humanoid.Health)).."❤"
				end
			end)
		else
			HealthText.Visible = false
			RunLoops:UnbindFromRenderStep("Health")
		end
	end,
	["HoverText"] = "Displays your health in the center of your screen."
})


runcode(function()
	local function removeTags(str)
        str = str:gsub("<br%s*/>", "\n")
        return (str:gsub("<[^<>]->", ""))
    end

	local function floorpos(pos)
		return Vector2.new(math.floor(pos.X), math.floor(pos.Y))
	end

	local NameTagsFolder = Instance.new("Folder")
	NameTagsFolder.Name = "NameTagsFolder"
	NameTagsFolder.Parent = GuiLibrary["MainGui"]
	local nametagsfolderdrawing = {}
	players.PlayerRemoving:connect(function(plr)
		if NameTagsFolder:FindFirstChild(plr.Name) then
			NameTagsFolder[plr.Name]:Remove()
		end
		if nametagsfolderdrawing[plr.Name] then 
			pcall(function()
				nametagsfolderdrawing[plr.Name].Text:Remove()
				nametagsfolderdrawing[plr.Name].BG:Remove()
				nametagsfolderdrawing[plr.Name] = nil
			end)
		end
	end)
	local NameTagsColor = {["Value"] = 0.44}
	local NameTagsDisplayName = {["Enabled"] = false}
	local NameTagsHealth = {["Enabled"] = false}
	local NameTagsDistance = {["Enabled"] = false}
	local NameTagsBackground = {["Enabled"] = true}
	local NameTagsScale = {["Value"] = 10}
	local NameTagsFont = {["Value"] = "SourceSans"}
	local NameTagsTeammates = {["Enabled"] = true}
	local NameTagsAlive = {["Enabled"] = false}
	local fontitems = {"SourceSans"}
	local NameTags = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
		["Name"] = "NameTags", 
		["Function"] = function(callback) 
			if callback then
				RunLoops:BindToRenderStep("NameTags", 500, function()
					for i,plr in pairs(players:GetChildren()) do
						local thing
						if NameTagsDrawing["Enabled"] then
							if nametagsfolderdrawing[plr.Name] then
								thing = nametagsfolderdrawing[plr.Name]
								thing.Text.Visible = false
								thing.BG.Visible = false
							else
								nametagsfolderdrawing[plr.Name] = {}
								nametagsfolderdrawing[plr.Name].Text = Drawing.new("Text")
								nametagsfolderdrawing[plr.Name].Text.Size = 17	
								nametagsfolderdrawing[plr.Name].Text.Font = 0
								nametagsfolderdrawing[plr.Name].Text.Text = ""
								nametagsfolderdrawing[plr.Name].Text.ZIndex = 2
								nametagsfolderdrawing[plr.Name].BG = Drawing.new("Square")
								nametagsfolderdrawing[plr.Name].BG.Filled = true
								nametagsfolderdrawing[plr.Name].BG.Transparency = 0.5
								nametagsfolderdrawing[plr.Name].BG.Color = Color3.new(0, 0, 0)
								nametagsfolderdrawing[plr.Name].BG.ZIndex = 1
								thing = nametagsfolderdrawing[plr.Name]
							end

							local aliveplr = isAlive(plr, NameTagsAlive["Enabled"])
							if aliveplr and plr ~= lplr and (NameTagsTeammates["Enabled"] or aliveplr.Targetable) then
								local headPos, headVis = cam:WorldToViewportPoint((aliveplr.RootPart:GetRenderCFrame() * CFrame.new(0, aliveplr.Head.Size.Y + aliveplr.RootPart.Size.Y, 0)).Position)
								
								if headVis then
									local displaynamestr = (NameTagsDisplayName["Enabled"] and plr.DisplayName ~= nil and plr.DisplayName or plr.Name)
									local blocksaway = math.floor(((entity.isAlive and entity.character.HumanoidRootPart.Position or Vector3.new(0,0,0)) - aliveplr.RootPart.Position).magnitude / 3)
									local color = HealthbarColorTransferFunction(aliveplr.Humanoid.Health / aliveplr.Humanoid.MaxHealth)
									thing.Text.Text = (NameTagsDistance["Enabled"] and entity.isAlive and '['..blocksaway..'] ' or '')..displaynamestr..(NameTagsHealth["Enabled"] and ' '..math.floor(aliveplr.Humanoid.Health).."" or '')
									thing.Text.Size = 17 * (NameTagsScale["Value"] / 10)
									thing.Text.Color = getPlayerColor(plr) or Color3.fromHSV(NameTagsColor["Hue"], NameTagsColor["Sat"], NameTagsColor["Value"])
									thing.Text.Visible = headVis
									thing.Text.Font = (math.clamp((table.find(fontitems, NameTagsFont["Value"]) or 1) - 1, 0, 3))
									thing.Text.Position = floorpos(Vector2.new(headPos.X - thing.Text.TextBounds.X / 2, (headPos.Y - thing.Text.TextBounds.Y)))
									thing.BG.Visible = headVis and NameTagsBackground["Enabled"]
									thing.BG.Size = floorpos(Vector2.new(thing.Text.TextBounds.X + 4, thing.Text.TextBounds.Y))
									thing.BG.Position = floorpos(Vector2.new((headPos.X - 2) - thing.Text.TextBounds.X / 2, (headPos.Y - thing.Text.TextBounds.Y) + 1.5))
								end
							end
						else
							if NameTagsFolder:FindFirstChild(plr.Name) then
								thing = NameTagsFolder[plr.Name]
								thing.Visible = false
							else
								thing = Instance.new("TextLabel")
								thing.BackgroundTransparency = 0.5
								thing.BackgroundColor3 = Color3.new(0, 0, 0)
								thing.BorderSizePixel = 0
								thing.Visible = false
								thing.RichText = true
								thing.Name = plr.Name
								thing.Font = Enum.Font.SourceSans
								thing.TextSize = 14
								if plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character:FindFirstChild("HumanoidRootPart") then
									local rawText = (NameTagsDisplayName["Enabled"] and plr.DisplayName ~= nil and plr.DisplayName or plr.Name)
									if NameTagsHealth["Enabled"] then
										rawText = (NameTagsDisplayName["Enabled"] and plr.DisplayName ~= nil and plr.DisplayName or plr.Name).." "..math.floor(plr.Character.Humanoid.Health)
									end
									local color = HealthbarColorTransferFunction(plr.Character.Humanoid.Health / plr.Character.Humanoid.MaxHealth)
									local modifiedText = (NameTagsDistance["Enabled"] and entity.isAlive and '<font color="rgb(85, 255, 85)">[</font>'..math.floor((entity.character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).magnitude)..'<font color="rgb(85, 255, 85)">]</font> ' or '')..(NameTagsDisplayName["Enabled"] and plr.DisplayName ~= nil and plr.DisplayName or plr.Name)..(NameTagsHealth["Enabled"] and ' <font color="rgb('..tostring(math.floor(color.R * 255))..','..tostring(math.floor(color.G * 255))..','..tostring(math.floor(color.B * 255))..')">'..math.floor(plr.Character.Humanoid.Health).."</font>" or '')
									local nametagSize = textservice:GetTextSize(rawText, thing.TextSize, thing.Font, Vector2.new(100000, 100000))
									thing.Size = UDim2.new(0, nametagSize.X + 4, 0, nametagSize.Y)
									thing.Text = modifiedText
								else
									local nametagSize = textservice:GetTextSize(plr.Name, thing.TextSize, thing.Font, Vector2.new(100000, 100000))
									thing.Size = UDim2.new(0, nametagSize.X + 4, 0, nametagSize.Y)
									thing.Text = plr.Name
								end
								thing.TextColor3 = getPlayerColor(plr) or Color3.fromHSV(NameTagsColor["Hue"], NameTagsColor["Sat"], NameTagsColor["Value"])
								thing.Parent = NameTagsFolder
							end
								
							local aliveplr = isAlive(plr, NameTagsAlive["Enabled"])
							if aliveplr and plr ~= lplr and (NameTagsTeammates["Enabled"] or aliveplr.Targetable) then
								local headPos, headVis = cam:WorldToViewportPoint((aliveplr.RootPart:GetRenderCFrame() * CFrame.new(0, aliveplr.Head.Size.Y + aliveplr.RootPart.Size.Y, 0)).Position)
								headPos = headPos
								
								if headVis then
									local rawText = (NameTagsDistance["Enabled"] and entity.isAlive and "["..math.floor((entity.character.HumanoidRootPart.Position - aliveplr.RootPart.Position).magnitude).."] " or "")..(NameTagsDisplayName["Enabled"] and plr.DisplayName ~= nil and plr.DisplayName or plr.Name)..(NameTagsHealth["Enabled"] and " "..math.floor(aliveplr.Humanoid.Health) or "")
									local color = HealthbarColorTransferFunction(aliveplr.Humanoid.Health / aliveplr.Humanoid.MaxHealth)
									local modifiedText = (NameTagsDistance["Enabled"] and entity.isAlive and '<font color="rgb(85, 255, 85)">[</font><font color="rgb(255, 255, 255)">'..math.floor((entity.character.HumanoidRootPart.Position - aliveplr.RootPart.Position).magnitude)..'</font><font color="rgb(85, 255, 85)">]</font> ' or '')..(NameTagsDisplayName["Enabled"] and plr.DisplayName ~= nil and plr.DisplayName or plr.Name)..(NameTagsHealth["Enabled"] and ' <font color="rgb('..tostring(math.floor(color.R * 255))..','..tostring(math.floor(color.G * 255))..','..tostring(math.floor(color.B * 255))..')">'..math.floor(aliveplr.Humanoid.Health).."</font>" or '')
									local nametagSize = textservice:GetTextSize(rawText, thing.TextSize, thing.Font, Vector2.new(100000, 100000))
									thing.Size = UDim2.new(0, nametagSize.X + 4, 0, nametagSize.Y)
									thing.Text = modifiedText
									thing.Font = Enum.Font[NameTagsFont["Value"]]
									thing.TextSize = 14 * (NameTagsScale["Value"] / 10)
									thing.BackgroundTransparency = NameTagsBackground["Enabled"] and 0.5 or 1
									thing.TextColor3 = getPlayerColor(plr) or Color3.fromHSV(NameTagsColor["Hue"], NameTagsColor["Sat"], NameTagsColor["Value"])
									thing.Visible = headVis
									thing.Position = UDim2.new(0, headPos.X - thing.Size.X.Offset / 2, 0, (headPos.Y - thing.Size.Y.Offset) - 36)
								end
							end
						end
					end
				end)
			else
				RunLoops:UnbindFromRenderStep("NameTags")
				NameTagsFolder:ClearAllChildren()
				for i,v in pairs(nametagsfolderdrawing) do 
					pcall(function()
						nametagsfolderdrawing[i].Text:Remove()
						nametagsfolderdrawing[i].BG:Remove()
						nametagsfolderdrawing[i] = nil
					end)
				end
			end
		end,
		["HoverText"] = "Renders nametags on entities through walls."
	})
	for i,v in pairs(Enum.Font:GetEnumItems()) do 
		if v.Name ~= "SourceSans" then 
			table.insert(fontitems, v.Name)
		end
	end
	NameTagsFont = NameTags.CreateDropdown({
		["Name"] = "Font",
		["List"] = fontitems,
		["Function"] = function() end,
	})
	NameTagsColor = NameTags.CreateColorSlider({
		["Name"] = "Player Color", 
		["Function"] = function(val) end
	})
	NameTagsScale = NameTags.CreateSlider({
		["Name"] = "Scale",
		["Function"] = function(val) end,
		["Default"] = 10,
		["Min"] = 1,
		["Max"] = 50
	})
	NameTagsBackground = NameTags.CreateToggle({
		["Name"] = "Background", 
		["Function"] = function() end,
		["Default"] = true
	})
	NameTagsDisplayName = NameTags.CreateToggle({
		["Name"] = "Use Display Name", 
		["Function"] = function() end,
		["Default"] = true
	})
	NameTagsHealth = NameTags.CreateToggle({
		["Name"] = "Health", 
		["Function"] = function() end
	})
	NameTagsDistance = NameTags.CreateToggle({
		["Name"] = "Distance", 
		["Function"] = function() end
	})
	NameTagsTeammates = NameTags.CreateToggle({
		["Name"] = "Teammates", 
		["Function"] = function() end,
		["Default"] = true
	})
	NameTagsDrawing = NameTags.CreateToggle({
		["Name"] = "Drawing",
		["Function"] = function() 
			NameTagsFolder:ClearAllChildren()
			for i,v in pairs(nametagsfolderdrawing) do 
				pcall(function()
					nametagsfolderdrawing[i].Text:Remove()
					nametagsfolderdrawing[i].BG:Remove()
					nametagsfolderdrawing[i] = nil
				end)
			end
		end,
	})
	NameTagsAlive = NameTags.CreateToggle({
		["Name"] = "Alive Check",
		["Function"] = function() end
	})
end)

local SearchTextList = {["RefreshValues"] = function() end, ["ObjectList"] = {}}
local searchColor = {["Value"] = 0.44}
local searchModule = {["Enabled"] = false}
local searchNewHighlight = {["Enabled"] = false}
local searchFolder = Instance.new("Folder")
searchFolder.Name = "SearchFolder"
searchFolder.Parent = GuiLibrary["MainGui"]
local function searchFindBoxHandle(part)
	for i,v in pairs(searchFolder:GetChildren()) do
		if v.Adornee == part then
			return v
		end
	end
	return nil
end
local searchAdd
local searchRemove
local searchRefresh = function()
	searchFolder:ClearAllChildren()
	if searchModule["Enabled"] then
		for i,v in pairs(workspace:GetDescendants()) do
			if (v:IsA("BasePart") or v:IsA("Model")) and table.find(SearchTextList["ObjectList"], v.Name) and searchFindBoxHandle(v) == nil then
				local highlight = Instance.new("Highlight")
				highlight.Name = v.Name
				highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
				highlight.FillColor = Color3.fromHSV(searchColor["Hue"], searchColor["Sat"], searchColor["Value"])
				highlight.Adornee = v
				highlight.Parent = searchFolder
			end
		end
	end
end
searchModule = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
	["Name"] = "Search", 
	["Function"] = function(callback) 
		if callback then
			searchRefresh()
			searchAdd = workspace.DescendantAdded:connect(function(v)
				if (v:IsA("BasePart") or v:IsA("Model")) and table.find(SearchTextList["ObjectList"], v.Name) and searchFindBoxHandle(v) == nil then
					local highlight = Instance.new("Highlight")
					highlight.Name = v.Name
					highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
					highlight.FillColor = Color3.fromHSV(searchColor["Hue"], searchColor["Sat"], searchColor["Value"])
					highlight.Adornee = v
					highlight.Parent = searchFolder
				end
			end)
			searchRemove = workspace.DescendantRemoving:connect(function(v)
				if v:IsA("BasePart") or v:IsA("Model") then
					local boxhandle = searchFindBoxHandle(v)
					if boxhandle then
						boxhandle:Remove()
					end
				end
			end)
		else
			pcall(function()
				searchFolder:ClearAllChildren()
				searchAdd:Disconnect()
				searchRemove:Disconnect()
			end)
		end
	end,
	["HoverText"] = "Draws a box around selected parts\nAdd parts in Search frame"
})
searchColor = searchModule.CreateColorSlider({
	["Name"] = "new part color", 
	["Function"] = function(hue, sat, val)
		for i,v in pairs(searchFolder:GetChildren()) do
			v.FillColor = Color3.fromHSV(hue, sat, val)
		end
	end
})
SearchTextList = searchModule.CreateTextList({
	["Name"] = "SearchList",
	["TempText"] = "part name", 
	["AddFunction"] = function(user)
		searchRefresh()
	end, 
	["RemoveFunction"] = function(num) 
		searchRefresh()
	end
})


local XrayAdd
local Xray = GuiLibrary["ObjectsThatCanBeSaved"]["WorldWindow"]["Api"].CreateOptionsButton({
	["Name"] = "Xray", 
	["Function"] = function(callback) 
		if callback then
			XrayAdd = workspace.DescendantAdded:connect(function(v)
				if v:IsA("BasePart") and not v.Parent:FindFirstChild("Humanoid") and not v.Parent.Parent:FindFirstChild("Humanoid") then
					v.LocalTransparencyModifier = 0.5
				end
			end)
			for i, v in pairs(workspace:GetDescendants()) do
				if v:IsA("BasePart") and not v.Parent:FindFirstChild("Humanoid") and not v.Parent.Parent:FindFirstChild("Humanoid") then
					v.LocalTransparencyModifier = 0.5
				end
			end
		else
			for i, v in pairs(workspace:GetDescendants()) do
				if v:IsA("BasePart") and not v.Parent:FindFirstChild("Humanoid") and not v.Parent.Parent:FindFirstChild("Humanoid") then
					v.LocalTransparencyModifier = 0
				end
			end
			XrayAdd:Disconnect()
		end
	end
})

runcode(function()
	local tracersfolderdrawing = {}
	local methodused

	local function floorpos(pos)
		return Vector2.new(math.floor(pos.X), math.floor(pos.Y))
	end

	local TracersColor = {["Value"] = 0.44}
	local TracersTransparency = {["Value"] = 1}
	local TracersStartPosition = {["Value"] = "Middle"}
	local TracersEndPosition = {["Value"] = "Head"}
	local TracersTeammates = {["Enabled"] = true}
	local tracersconnections = {}
	local addedconnection
	local removedconnection
	local updatedconnection

	local tracersfuncs1 = {
		Drawing = function(plr)
			if TracersTeammates["Enabled"] and (not plr.Targetable) then return end
			local newobj = Drawing.new("Line")
			newobj.Thickness = 1
			newobj.Transparency = 1 - (TracersTransparency["Value"] / 100)
			tracersfolderdrawing[plr.Player] = {entity = plr, Main = newobj}
		end,
		DrawingV3 = function(plr)
			if TracersTeammates["Enabled"] and (not plr.Targetable) then return end
			local toppoint = PointInstance.new(plr[TracersEndPosition["Value"] == "Torso" and "RootPart" or "Head"])
			local bottompoint = Point2D.new(UDim2.new(0.5, 0, TracersStartPosition["Value"] == "Middle" and 0.5 or 1, 0))
			local newobj = LineDynamic.new(toppoint, bottompoint)
			newobj.Opacity = 1 - (TracersTransparency["Value"] / 100)
			newobj.Color = getPlayerColor(plr.Player) or Color3.fromHSV(TracersColor["Hue"], TracersColor["Sat"], TracersColor["Value"])
			tracersfolderdrawing[plr.Player] = {entity = plr, Main = newobj}
		end,
	}
	local tracersfuncs2 = {
		Drawing = function(ent)
			local v = tracersfolderdrawing[ent]
			tracersfolderdrawing[ent] = nil
			if v then 
				pcall(function() v.Main.Visible = false v.Main:Remove() end)
			end
		end,
	}
	local tracerscolorfuncs = {
		Drawing = function(hue, sat, value)
			local color = Color3.fromHSV(hue, sat, value)
			for i,v in pairs(tracersfolderdrawing) do 
				v.Main.Color = getPlayerColor(v.entity.Player) or color
			end
		end
	}
	tracerscolorfuncs.DrawingV3 = tracerscolorfuncs.Drawing
	tracersfuncs2.DrawingV3 = tracersfuncs2.Drawing
	local tracersloop = {
		Drawing = function()
			for i,v in pairs(tracersfolderdrawing) do 
				local rootPart = v.entity[TracersEndPosition["Value"] == "Torso" and "RootPart" or "Head"].Position
				local rootPos, rootVis = cam:WorldToViewportPoint(rootPart)
				if rootPos.Z < 0 and TracersStartPosition["Value"] ~= "Bottom" then
					local tempPos = cam.CFrame:pointToObjectSpace(rootPart)
					tempPos = CFrame.Angles(0, 0, (math.atan2(tempPos.Y, tempPos.X) + math.pi)):vectorToWorldSpace((CFrame.Angles(0, math.rad(89.9), 0):vectorToWorldSpace(Vector3.new(0, 0, -1))))
					rootPos, rootVis = cam:WorldToViewportPoint(cam.CFrame:pointToWorldSpace(tempPos))
				end
				local screensize = cam.ViewportSize
				local startVector = Vector2.new(screensize.X / 2, (TracersStartPosition["Value"] == "Middle" and screensize.Y / 2 or screensize.Y))
				local endVector = Vector2.new(rootPos.X, rootPos.Y)
				v.Main.Visible = true
				v.Main.From = startVector
				v.Main.To = endVector
			end
		end,
	}

	local Tracers = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
		["Name"] = "Tracers", 
		["Function"] = function(callback) 
			if callback then
				methodused = "Drawing"..v3check
				if tracersfuncs2[methodused] then
					removedconnection = entity.entityRemovedEvent:connect(tracersfuncs2[methodused])
				end
				if tracersfuncs1[methodused] then
					local addfunc = tracersfuncs1[methodused]
					for i,v in pairs(entity.entityList) do 
						addfunc(v)
					end
					addedconnection = entity.entityAddedEvent:connect(function(ent)
						if tracersfolderdrawing[ent] then 
							tracersfuncs2[methodused](ent)
						end
						addfunc(ent)
					end)
				end
				if tracersloop[methodused] then 
					RunLoops:BindToRenderStep("Tracers", 1, tracersloop[methodused])
				end
			else
				RunLoops:UnbindFromRenderStep("Tracers")
				if addedconnection then 
					addedconnection:Disconnect()
				end
				if updatedconnection then 
					updatedconnection:Disconnect()
				end
				if removedconnection then 
					removedconnection:Disconnect()
				end
				for i,v in pairs(entity.entityList) do 
					if tracersfuncs2[methodused] and tracersfolderdrawing[v.Player] then
						tracersfuncs2[methodused](v.Player)
					end
				end
			end
		end,
		["HoverText"] = "Extra Sensory Perception\nRenders an Tracers on players."
	})
	TracersStartPosition = Tracers.CreateDropdown({
		["Name"] = "Start Position",
		["List"] = {"Middle", "Bottom"},
		["Function"] = function() if Tracers["Enabled"] then Tracers["ToggleButton"](true) Tracers["ToggleButton"](true) end end
	})
	TracersEndPosition = Tracers.CreateDropdown({
		["Name"] = "End Position",
		["List"] = {"Head", "Torso"},
		["Function"] = function() if Tracers["Enabled"] then Tracers["ToggleButton"](true) Tracers["ToggleButton"](true) end end
	})
	TracersColor = Tracers.CreateColorSlider({
		["Name"] = "Player Color", 
		["Function"] = function(hue, sat, val) 
			if Tracers["Enabled"] and tracerscolorfuncs[methodused] then 
				tracerscolorfuncs[methodused](hue, sat, val)
			end
		end
	})
	TracersTransparency = Tracers.CreateSlider({
		["Name"] = "Transparency", 
		["Min"] = 1,
		["Max"] = 100, 
		["Function"] = function(val) 
			for i,v in pairs(tracersfolderdrawing) do 
				if v.Main then 
					v.Main[methodused == "DrawingV3" and "Opacity" or "Transparency"] = 1 - (val / 100)
				end
			end
		end,
		["Default"] = 0
	})
	TracersTeammates = Tracers.CreateToggle({
		["Name"] = "Priority Only",
		["Function"] = function() if Tracers["Enabled"] then Tracers["ToggleButton"](true) Tracers["ToggleButton"](true) end end,
		["Default"] = true
	})
end)

--[[runcode(function()
	local TracersFolder = Instance.new("Folder")
	TracersFolder.Name = "TracersFolder"
	TracersFolder.Parent = GuiLibrary["MainGui"]
	local TracersDrawing
	local tracersdrawingtab = {}
	players.PlayerRemoving:connect(function(plr)
		if TracersFolder:FindFirstChild(plr.Name) then
			TracersFolder[plr.Name]:Remove()
		end
		if tracersdrawingtab[plr.Name] then 
			pcall(function()
				tracersdrawingtab[plr.Name]:Remove()
				tracersdrawingtab[plr.Name] = nil
			end)
		end
	end)
	local TracersColor = {["Value"] = 0.44}
	local TracersTransparency = {["Value"] = 1}
	local TracersStartPosition = {["Value"] = "Middle"}
	local TracersEndPosition = {["Value"] = "Head"}
	local TracersTeammates = {["Enabled"] = true}
	local TracersAlive = {["Enabled"] = false}
	local Tracers = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
		["Name"] = "Tracers", 
		["Function"] = function(callback) 
			if callback then
				RunLoops:BindToRenderStep("Tracers", 500, function()
					for i,plr in pairs(players:GetChildren()) do
							local thing
							if TracersDrawing["Enabled"] then
								if tracersdrawingtab[plr.Name] then 
									thing = tracersdrawingtab[plr.Name]
									thing.Visible = false
								else
									thing = Drawing.new("Line")
									thing.Thickness = 1
									thing.Visible = false
									tracersdrawingtab[plr.Name] = thing
								end

								local aliveplr = isAlive(plr, TracersAlive["Enabled"])
								if aliveplr and plr ~= lplr and (TracersTeammates["Enabled"] or aliveplr.Targetable) then
									local rootScrPos = cam:WorldToViewportPoint((TracersEndPosition["Value"] == "Head" and aliveplr.Head or aliveplr.RootPart).Position)
									local tempPos = cam.CFrame:pointToObjectSpace((TracersEndPosition["Value"] == "Head" and aliveplr.Head or aliveplr.RootPart).Position)
									if rootScrPos.Z < 0 then
										tempPos = CFrame.Angles(0, 0, (math.atan2(tempPos.Y, tempPos.X) + math.pi)):vectorToWorldSpace((CFrame.Angles(0, math.rad(89.9), 0):vectorToWorldSpace(Vector3.new(0, 0, -1))));
									end
									local tracerPos = cam:WorldToViewportPoint(cam.CFrame:pointToWorldSpace(tempPos))
									local screensize = cam.ViewportSize
									local startVector = Vector2.new(screensize.X / 2, (TracersStartPosition["Value"] == "Middle" and screensize.Y / 2 or screensize.Y))
									local endVector = Vector2.new(tracerPos.X, tracerPos.Y)
									local Distance = (startVector - endVector).Magnitude
									startVector = startVector
									endVector = endVector
									thing.Visible = true
									thing.Transparency = 1 - TracersTransparency["Value"] / 100
									thing.Color = getPlayerColor(plr) or Color3.fromHSV(TracersColor["Hue"], TracersColor["Sat"], TracersColor["Value"])
									thing.From = startVector
									thing.To = endVector
								end
							else
								if TracersFolder:FindFirstChild(plr.Name) then
									thing = TracersFolder[plr.Name]
									if thing.Visible then
										thing.Visible = false
									end
								else
									thing = Instance.new("Frame")
									thing.BackgroundTransparency = 0
									thing.AnchorPoint = Vector2.new(0.5, 0.5)
									thing.BackgroundColor3 = Color3.new(0, 0, 0)
									thing.BorderSizePixel = 0
									thing.Visible = false
									thing.Name = plr.Name
									thing.Parent = TracersFolder
								end
								
								local aliveplr = isAlive(plr)
								if aliveplr and plr ~= lplr and (TracersTeammates["Enabled"] or aliveplr.Targetable) then
									local rootScrPos = cam:WorldToViewportPoint((TracersEndPosition["Value"] == "Head" and aliveplr.Head or aliveplr.RootPart).Position)
									local tempPos = cam.CFrame:pointToObjectSpace((TracersEndPosition["Value"] == "Head" and aliveplr.Head or aliveplr.RootPart).Position)
									if rootScrPos.Z < 0 then
										tempPos = CFrame.Angles(0, 0, (math.atan2(tempPos.Y, tempPos.X) + math.pi)):vectorToWorldSpace((CFrame.Angles(0, math.rad(89.9), 0):vectorToWorldSpace(Vector3.new(0, 0, -1))));
									end
									local tracerPos = cam:WorldToViewportPoint(cam.CFrame:pointToWorldSpace(tempPos))
									local screensize = cam.ViewportSize
									local startVector = Vector2.new(screensize.X / 2, (TracersStartPosition["Value"] == "Middle" and screensize.Y / 2 or screensize.Y))
									local endVector = Vector2.new(tracerPos.X, tracerPos.Y)
									local Distance = (startVector - endVector).Magnitude
									startVector = startVector
									endVector = endVector
									thing.Visible = true
									thing.BackgroundTransparency = TracersTransparency["Value"] / 100
									thing.BackgroundColor3 = getPlayerColor(plr) or Color3.fromHSV(TracersColor["Hue"], TracersColor["Sat"], TracersColor["Value"])
									thing.Size = UDim2.new(0, Distance, 0, 2)
									thing.Position = UDim2.new(0, (startVector.X + endVector.X) / 2, 0, ((startVector.Y + endVector.Y) / 2) - 36)
									thing.Rotation = math.atan2(endVector.Y - startVector.Y, endVector.X - startVector.X) * (180 / math.pi)
								end
							end
						end
				end)
			else
				RunLoops:UnbindFromRenderStep("Tracers") 
				TracersFolder:ClearAllChildren()
				for i,v in pairs(tracersdrawingtab) do 
					pcall(function()
						v:Remove()
						tracersdrawingtab[i] = nil
					end)
				end
			end
		end
	})
	TracersStartPosition = Tracers.CreateDropdown({
		["Name"] = "Start Position",
		["List"] = {"Middle", "Bottom"},
		["Function"] = function() end
	})
	TracersEndPosition = Tracers.CreateDropdown({
		["Name"] = "End Position",
		["List"] = {"Head", "Torso"},
		["Function"] = function() end
	})
	TracersColor = Tracers.CreateColorSlider({
		["Name"] = "Player Color", 
		["Function"] = function(val) end
	})
	TracersTransparency = Tracers.CreateSlider({
		["Name"] = "Transparency", 
		["Min"] = 1,
		["Max"] = 100, 
		["Function"] = function(val) end,
		["Default"] = 0
	})
	TracersTeammates = Tracers.CreateToggle({
		["Name"] = "Teammates",
		["Function"] = function() end,
		["Default"] = true
	})
	TracersDrawing = Tracers.CreateToggle({
		["Name"] = "Drawing",
		["Function"] = function() 
			TracersFolder:ClearAllChildren()
			for i,v in pairs(tracersdrawingtab) do 
				pcall(function()
					v:Remove()
					tracersdrawingtab[i] = nil
				end)
			end
		end
	})
	TracersAlive = Tracers.CreateToggle({
		["Name"] = "Alive Check",
		["Function"] = function() end
	})
end)]]

Spring = {} do
	Spring.__index = Spring

	function Spring.new(freq, pos)
		local self = setmetatable({}, Spring)
		self.f = freq
		self.p = pos
		self.v = pos*0
		return self
	end

	function Spring:Update(dt, goal)
		local f = self.f*2*math.pi
		local p0 = self.p
		local v0 = self.v

		local offset = goal - p0
		local decay = math.exp(-f*dt)

		local p1 = goal + (v0*dt - offset*(f*dt + 1))*decay
		local v1 = (f*dt*(offset*f - v0) + v0)*decay

		self.p = p1
		self.v = v1

		return p1
	end

	function Spring:Reset(pos)
		self.p = pos
		self.v = pos*0
	end
end

local cameraPos = Vector3.new()
local cameraRot = Vector2.new()
local velSpring = Spring.new(5, Vector3.new())
local panSpring = Spring.new(5, Vector2.new())

Input = {} do

	keyboard = {
		W = 0,
		A = 0,
		S = 0,
		D = 0,
		E = 0,
		Q = 0,
		Up = 0,
		Down = 0,
		LeftShift = 0,
	}

	mouse = {
		Delta = Vector2.new(),
	}

	NAV_KEYBOARD_SPEED = Vector3.new(1, 1, 1)
	PAN_MOUSE_SPEED = Vector2.new(3, 3)*(math.pi/64)
	NAV_ADJ_SPEED = 0.75
	NAV_SHIFT_MUL = 0.25

	navSpeed = 1

	function Input.Vel(dt)
		navSpeed = math.clamp(navSpeed + dt*(keyboard.Up - keyboard.Down)*NAV_ADJ_SPEED, 0.01, 4)

		local kKeyboard = Vector3.new(
			keyboard.D - keyboard.A,
			keyboard.E - keyboard.Q,
			keyboard.S - keyboard.W
		)*NAV_KEYBOARD_SPEED

		local shift = uis:IsKeyDown(Enum.KeyCode.LeftShift)

		return (kKeyboard)*(navSpeed*(shift and NAV_SHIFT_MUL or 1))
	end

	function Input.Pan(dt)
		local kMouse = mouse.Delta*PAN_MOUSE_SPEED
		mouse.Delta = Vector2.new()
		return kMouse
	end

	do
		function Keypress(action, state, input)
			keyboard[input.KeyCode.Name] = state == Enum.UserInputState.Begin and 1 or 0
			return Enum.ContextActionResult.Sink
		end

		function MousePan(action, state, input)
			local delta = input.Delta
			mouse.Delta = Vector2.new(-delta.y, -delta.x)
			return Enum.ContextActionResult.Sink
		end

		function Zero(t)
			for k, v in pairs(t) do
				t[k] = v*0
			end
		end

		function Input.StartCapture()
			game:GetService("ContextActionService"):BindActionAtPriority("FreecamKeyboard",Keypress,false,Enum.ContextActionPriority.High.Value,
			Enum.KeyCode.W,
			Enum.KeyCode.A,
			Enum.KeyCode.S,
			Enum.KeyCode.D,
			Enum.KeyCode.E,
			Enum.KeyCode.Q,
			Enum.KeyCode.Up,
			Enum.KeyCode.Down
			)
			game:GetService("ContextActionService"):BindActionAtPriority("FreecamMousePan",MousePan,false,Enum.ContextActionPriority.High.Value,Enum.UserInputType.MouseMovement)
		end

		function Input.StopCapture()
			navSpeed = 1
			Zero(keyboard)
			Zero(mouse)
			game:GetService("ContextActionService"):UnbindAction("FreecamKeyboard")
			game:GetService("ContextActionService"):UnbindAction("FreecamMousePan")
		end
	end
end

local function GetFocusDistance(cameraFrame)
	local znear = 0.1
	local viewport = cam.ViewportSize
	local projy = 2*math.tan(cameraFov/2)
	local projx = viewport.x/viewport.y*projy
	local fx = cameraFrame.rightVector
	local fy = cameraFrame.upVector
	local fz = cameraFrame.lookVector

	local minVect = Vector3.new()
	local minDist = 512

	for x = 0, 1, 0.5 do
		for y = 0, 1, 0.5 do
			local cx = (x - 0.5)*projx
			local cy = (y - 0.5)*projy
			local offset = fx*cx - fy*cy + fz
			local origin = cameraFrame.p + offset*znear
			local _, hit = workspace:FindPartOnRay(Ray.new(origin, offset.unit*minDist))
			local dist = (hit - origin).magnitude
			if minDist > dist then
				minDist = dist
				minVect = offset.unit
			end
		end
	end

	return fz:Dot(minVect)*minDist
end

local PlayerState = {} do
	mouseBehavior = ""
	mouseIconEnabled = ""
	cameraType = ""
	cameraFocus = ""
	cameraCFrame = ""
	cameraFieldOfView = ""

	function PlayerState.Push()
		cameraFieldOfView = cam.FieldOfView
		cam.FieldOfView = 70

		cameraType = cam.CameraType
		cam.CameraType = Enum.CameraType.Custom

		cameraCFrame = cam.CFrame
		cameraFocus = cam.Focus

		mouseBehavior = uis.MouseBehavior
		uis.MouseBehavior = Enum.MouseBehavior.Default

		mouseIconEnabled = uis.MouseIconEnabled
		uis.MouseIconEnabled = true
	end

	function PlayerState.Pop()
		cam.FieldOfView = cameraFieldOfView
        cameraFieldOfView = nil

		cam.CameraType = cameraType
		cameraType = nil

		cam.CFrame = cameraCFrame
		cameraCFrame = nil

		cam.Focus = cameraFocus
		cameraFocus = nil

		uis.MouseIconEnabled = mouseIconEnabled
		mouseIconEnabled = nil

		uis.MouseBehavior = mouseBehavior
		mouseBehavior = nil
	end
end

local Freecam = GuiLibrary["ObjectsThatCanBeSaved"]["WorldWindow"]["Api"].CreateOptionsButton({
	["Name"] = "Freecam", 
	["Function"] = function(callback)
		if callback then
			local cameraCFrame = cam.CFrame
			local pitch, yaw, roll = cameraCFrame:ToEulerAnglesYXZ()
			cameraRot = Vector2.new(pitch, yaw)
			cameraPos = cameraCFrame.p
			cameraFov = cam.FieldOfView

			velSpring:Reset(Vector3.new())
			panSpring:Reset(Vector2.new())

			PlayerState.Push()
			RunLoops:BindToRenderStep("Freecam", Enum.RenderPriority.Camera.Value, function(dt)
				local vel = velSpring:Update(dt, Input.Vel(dt))
				local pan = panSpring:Update(dt, Input.Pan(dt))

				local zoomFactor = math.sqrt(math.tan(math.rad(70/2))/math.tan(math.rad(cameraFov/2)))

				cameraRot = cameraRot + pan*Vector2.new(0.75, 1)*8*(dt/zoomFactor)
				cameraRot = Vector2.new(math.clamp(cameraRot.x, -math.rad(90), math.rad(90)), cameraRot.y%(2*math.pi))

				local cameraCFrame = CFrame.new(cameraPos)*CFrame.fromOrientation(cameraRot.x, cameraRot.y, 0)*CFrame.new(vel*Vector3.new(1, 1, 1)*64*dt)
				cameraPos = cameraCFrame.p

				cam.CFrame = cameraCFrame
				cam.Focus = cameraCFrame*CFrame.new(0, 0, -GetFocusDistance(cameraCFrame))
				cam.FieldOfView = cameraFov
			end)
			Input.StartCapture()
		else
			Input.StopCapture()
			RunLoops:UnbindFromRenderStep("Freecam")
			PlayerState.Pop()
		end
	end,
	["HoverText"] = "Lets you fly and clip through walls freely\nwithout moving your player server-sided."
})
freecamspeed = Freecam.CreateSlider({
	["Name"] = "Speed",
	["Min"] = 1,
	["Max"] = 150,
	["Function"] = function(val) NAV_KEYBOARD_SPEED = Vector3.new(val / 75,  val / 75, val / 75) end,
	["Default"] = 75
})

local Panic = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
	["Name"] = "Panic", 
	["Function"] = function(callback)
		if callback then
			for i,v in pairs(GuiLibrary["ObjectsThatCanBeSaved"]) do
				if v["Type"] == "Button" or v["Type"] == "OptionsButton" then
					if v["Api"]["Enabled"] then
						v["Api"]["ToggleButton"]()
					end
				end
			end
		end
	end
}) 
		
runcode(function()
	local vapecapeconnection
	GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
		["Name"] = "Cape",
		["Function"] = function(callback)
			if callback then
				vapecapeconnection = lplr.CharacterAdded:connect(function(char)
					spawn(function()
						pcall(function() 
							Cape(char, getcustomassetfunc("XyloWare/assets/VapeCape.png"))
						end)
					end)
				end)
				if lplr.Character then
					spawn(function()
						pcall(function() 
							Cape(lplr.Character, getcustomassetfunc("XyloWare/assets/VapeCape.png"))
						end)
					end)
				end
			else
				if vapecapeconnection then
					vapecapeconnection:Disconnect()
				end
				if lplr.Character then
					for i,v in pairs(lplr.Character:GetDescendants()) do
						if v.Name == "Cape" then
							v:Remove()
						end
					end
				end
			end
		end
	})
end)

runcode(function()
	local Breadcrumbs = {["Enabled"] = false}
	local BreadcrumbsLifetime = {["Value"] = 20}
	local BreadcrumbsThickness = {["Value"] = 7}
	local BreadcrumbsFadeIn = {["Value"] = 0.44}
	local BreadcrumbsFadeOut = {["Value"] = 0.44}
	local breadcrumbtrail
	local breadcrumbattachment
	local breadcrumbattachment2
	Breadcrumbs = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
		["Name"] = "Breadcrumbs",
		["Function"] = function(callback)
			if callback then
				spawn(function()
					repeat
						task.wait(0.3)
						if (not Breadcrumbs["Enabled"]) then return end
						if entity.isAlive then
							if breadcrumbtrail == nil then
								breadcrumbattachment = Instance.new("Attachment")
								breadcrumbattachment.Position = Vector3.new(0, 0.07 - 2.7, 0)
								breadcrumbattachment2 = Instance.new("Attachment")
								breadcrumbattachment2.Position = Vector3.new(0, -0.07 - 2.7, 0)
								breadcrumbtrail = Instance.new("Trail")
								breadcrumbtrail.Attachment0 = breadcrumbattachment 
								breadcrumbtrail.Attachment1 = breadcrumbattachment2
								breadcrumbtrail.Color = ColorSequence.new(Color3.fromHSV(BreadcrumbsFadeIn["Hue"], BreadcrumbsFadeIn["Sat"], BreadcrumbsFadeIn["Value"]), Color3.fromHSV(BreadcrumbsFadeOut["Hue"], BreadcrumbsFadeOut["Sat"], BreadcrumbsFadeOut["Value"]))
								breadcrumbtrail.FaceCamera = true
								breadcrumbtrail.Lifetime = BreadcrumbsLifetime["Value"] / 10
								breadcrumbtrail.Enabled = true
							else
								pcall(function()
									breadcrumbattachment.Parent = entity.character.HumanoidRootPart
									breadcrumbattachment2.Parent = entity.character.HumanoidRootPart
									breadcrumbtrail.Parent = cam
								end)
							end
						end
					until (not Breadcrumbs["Enabled"])
				end)
			else
				if breadcrumbtrail then
					breadcrumbtrail:Remove()
					breadcrumbtrail = nil
				end
			end
		end,
		["HoverText"] = "Shows a trail behind your character"
	})
	BreadcrumbsFadeIn = Breadcrumbs.CreateColorSlider({
		["Name"] = "Fade In",
		["Function"] = function(hue, sat, val)
			if breadcrumbtrail then 
				breadcrumbtrail.Color = ColorSequence.new(Color3.fromHSV(hue, sat, val), Color3.fromHSV(BreadcrumbsFadeOut["Hue"], BreadcrumbsFadeOut["Sat"], BreadcrumbsFadeOut["Value"]))
			end
		end
	})
	BreadcrumbsFadeOut = Breadcrumbs.CreateColorSlider({
		["Name"] = "Fade Out",
		["Function"] = function(hue, sat, val)
			if breadcrumbtrail then 
				breadcrumbtrail.Color = ColorSequence.new(Color3.fromHSV(BreadcrumbsFadeIn["Hue"], BreadcrumbsFadeIn["Sat"], BreadcrumbsFadeIn["Value"]), Color3.fromHSV(hue, sat, val))
			end
		end
	})
	BreadcrumbsLifetime = Breadcrumbs.CreateSlider({
		["Name"] = "Lifetime",
		["Min"] = 1,
		["Max"] = 100,
		["Function"] = function(val) 
			if breadcrumbtrail then 
				breadcrumbtrail.Lifetime = val / 10
			end
		end,
		["Default"] = 20,
		["Double"] = 10
	})
	BreadcrumbsThickness = Breadcrumbs.CreateSlider({
		["Name"] = "Thickness",
		["Min"] = 1,
		["Max"] = 30,
		["Function"] = function(val) 
			if breadcrumbattachment then 
				breadcrumbattachment.Position = Vector3.new(0, (val / 100) - 2.7, 0)
			end
			if breadcrumbattachment2 then 
				breadcrumbattachment2.Position = Vector3.new(0, -(val / 100) - 2.7, 0)
			end
		end,
		["Default"] = 7,
		["Double"] = 10
	})
end)
