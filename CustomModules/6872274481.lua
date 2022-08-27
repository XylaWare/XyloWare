--[[ 
	Credits
	Infinite Yield - Blink
	DevForum - lots of rotation math because I hate it
	Please notify me if you need credits
]]
local GuiLibrary = shared.GuiLibrary
local players = game:GetService("Players")
local textservice = game:GetService("TextService")
local repstorage = game:GetService("ReplicatedStorage")
local lplr = players.LocalPlayer
local lighting = game:GetService("Lighting")
local cam = workspace.CurrentCamera
workspace:GetPropertyChangedSignal("CurrentCamera"):connect(function()
	cam = (workspace.CurrentCamera or workspace:FindFirstChild("Camera") or Instance.new("Camera"))
end)
local targetinfo = shared.VapeTargetInfo
local collectionservice = game:GetService("CollectionService")
local uis = game:GetService("UserInputService")
local mouse = lplr:GetMouse()
local bedwars = {}
local bedwarsblocks = {}
local blockraycast = RaycastParams.new()
blockraycast.FilterType = Enum.RaycastFilterType.Whitelist
local getfunctions
local oldchar
local oldcloneroot
local matchState = 0
local kit = ""
local antivoidypos = 0
local kills = 0
local beds = 0
local lagbacks = 0
local otherlagbacks = 0
local matchstatetick = 0
local lagbackevent = Instance.new("BindableEvent")
local reported = 0
local allowspeed = true
local antivoiding = false
local bettergetfocus = function()
	if KRNL_LOADED then 
		return ((game:GetService("Players").LocalPlayer.PlayerGui.Chat.Frame.ChatBarParentFrame.Frame.BoxFrame.Frame.ChatBar:IsFocused() or searchbar:IsFocused()) and true or nil) 
	else
		return game:GetService("UserInputService"):GetFocusedTextBox()
	end
end
local betterisfile = function(file)
	local suc, res = pcall(function() return readfile(file) end)
	return suc and res ~= nil
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
			Body = "bad executor",
			Headers = {},
			StatusCode = 404
		}
	end
end 
local queueteleport = syn and syn.queue_on_teleport or queue_on_teleport or fluxus and fluxus.queue_on_teleport or function() end
local teleportfunc
local getasset = getsynasset or getcustomasset or function(location) return "rbxasset://"..location end
local storedshahashes = {}
local oldshoot
local chatconnection
local blocktable
local inventories = {}
local currentinventory = {
	["inventory"] = {
		["items"] = {},
		["armor"] = {},
		["hand"] = nil
	}
}
local Hitboxes = {["Enabled"] = false}
local Reach = {["Enabled"] = false}
local Killaura = {["Enabled"] = false}
local flyspeed = {["Value"] = 40}
local nobob = {["Enabled"] = false}
local AnticheatBypass = {["Enabled"] = false}
local AnticheatBypassCombatCheck = {["Enabled"] = false}
local combatcheck = false
local combatchecktick = tick()
local disabletpcheck = false
local queueType = "bedwars_test"
local FastConsume = {["Enabled"] = false}
local chatconnection2
local oldchanneltab
local oldchannelfunc
local oldchanneltabs = {}
local connectionstodisconnect = {}
local anticheatfunny = false
local anticheatfunnyyes = false
local tpstring
local networkownertick = tick()
local networkownerfunc = isnetworkowner or function(part)
	if gethiddenproperty(part, "NetworkOwnershipRule") == Enum.NetworkOwnership.Manual then 
		sethiddenproperty(part, "NetworkOwnershipRule", Enum.NetworkOwnership.Automatic)
		networkownertick = tick() + 8
	end
	return networkownertick <= tick()
end
local uninjectflag = false
local vec3 = Vector3.new
local cfnew = CFrame.new
local clients = {
	ChatStrings1 = {
		["KVOP25KYFPPP4"] = "vape",
		["IO12GP56P4LGR"] = "future",
		["RQYBPTYNURYZC"] = "rektsky"
	},
	ChatStrings2 = {
		["vape"] = "KVOP25KYFPPP4",
		["future"] = "IO12GP56P4LGR",
		["rektsky"] = "RQYBPTYNURYZC"
	},
	ClientUsers = {}
}
local function GetURL(scripturl)
	if shared.VapeDeveloper then
		return readfile("XyloWare/"..scripturl)
	else
		return game:HttpGet("https://raw.githubusercontent.com/XylaWare/XyloWare/main/"..scripturl, true)
	end
end
local shalib = loadstring(GetURL("Libraries/sha.lua"))()
local entity = shared.vapeentity
local whitelisted = {
	players = {},
	owners = {},
	chattags = {}
}
local whitelistsuc = nil
task.spawn(function()
	whitelistsuc = pcall(function()
		whitelisted = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://raw.githubusercontent.com/XylaWare/whitelists/main/whitelist2.json", true))
	end)
end)
local AnticheatBypassNumbers = {
	TPSpeed = 0.1,
	TPCombat = 0.3,
	TPLerp = 0.39,
	TPCheck = 15
}

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

--skidded off the devforum because I hate projectile math
-- Compute 2D launch angle
-- v: launch velocity
-- g: gravity (positive) e.g. 196.2
-- d: horizontal distance
-- h: vertical distance
-- higherArc: if true, use the higher arc. If false, use the lower arc.
local function LaunchAngle(v: number, g: number, d: number, h: number, higherArc: boolean)
	local v2 = v * v
	local v4 = v2 * v2
	local root = math.sqrt(v4 - g*(g*d*d + 2*h*v2))
	if not higherArc then root = -root end
	return math.atan((v2 + root) / (g * d))
end

-- Compute 3D launch direction from
-- start: start position
-- target: target position
-- v: launch velocity
-- g: gravity (positive) e.g. 196.2
-- higherArc: if true, use the higher arc. If false, use the lower arc.
local function LaunchDirection(start, target, v, g, higherArc: boolean)
	-- get the direction flattened:
	local horizontal = vec3(target.X - start.X, 0, target.Z - start.Z)
	
	local h = target.Y - start.Y
	local d = horizontal.Magnitude
	local a = LaunchAngle(v, g, d, h, higherArc)
	
	-- NaN ~= NaN, computation couldn't be done (e.g. because it's too far to launch)
	if a ~= a then return nil end
	
	-- speed if we were just launching at a flat angle:
	local vec = horizontal.Unit * v
	
	-- rotate around the axis perpendicular to that direction...
	local rotAxis = vec3(-horizontal.Z, 0, horizontal.X)
	
	-- ...by the angle amount
	return CFrame.fromAxisAngle(rotAxis, a) * vec
end

local function FindLeadShot(targetPosition: Vector3, targetVelocity: Vector3, projectileSpeed: Number, shooterPosition: Vector3, shooterVelocity: Vector3, gravity: Number)
	local distance = (targetPosition - shooterPosition).Magnitude

	local p = targetPosition - shooterPosition
	local v = targetVelocity - shooterVelocity
	local a = Vector3.zero

	local timeTaken = (distance / projectileSpeed)
	
	if gravity > 0 then
		local timeTaken = projectileSpeed/gravity+math.sqrt(2*distance/gravity+projectileSpeed^2/gravity^2)
	end

	local goalX = targetPosition.X + v.X*timeTaken + 0.5 * a.X * timeTaken^2
	local goalY = targetPosition.Y + v.Y*timeTaken + 0.5 * a.Y * timeTaken^2
	local goalZ = targetPosition.Z + v.Z*timeTaken + 0.5 * a.Z * timeTaken^2
	
	return vec3(goalX, goalY, goalZ)
end

local function addvectortocframe(cframe, vec)
	local x, y, z, R00, R01, R02, R10, R11, R12, R20, R21, R22 = cframe:GetComponents()
	return cfnew(x + vec.X, y + vec.Y, z + vec.Z, R00, R01, R02, R10, R11, R12, R20, R21, R22)
end

local function addvectortocframe2(cframe, newylevel)
	local x, y, z, R00, R01, R02, R10, R11, R12, R20, R21, R22 = cframe:GetComponents()
	return cfnew(x, newylevel, z, R00, R01, R02, R10, R11, R12, R20, R21, R22)
end

local function runcode(func)
	func()
end

runcode(function()
	local textlabel = Instance.new("TextLabel")
	textlabel.Size = UDim2.new(1, 0, 0, 36)
	textlabel.Text = "This should not be noticable by others, however always be careful about banwaves.."
	textlabel.BackgroundTransparency = 1
	textlabel.ZIndex = 10
	textlabel.TextStrokeTransparency = 0
	textlabel.TextScaled = true
	textlabel.Font = Enum.Font.SourceSans
	textlabel.TextColor3 = Color3.new(1, 1, 1)
	textlabel.Position = UDim2.new(0, 0, 0, -36)
	textlabel.Parent = GuiLibrary["MainGui"].ScaledGui.ClickGui
	task.spawn(function()
		repeat task.wait() until matchState ~= 0
		textlabel:Remove()
	end)
end)

local cachedassets = {}
local function getcustomassetfunc(path)
	if not betterisfile(path) then
		task.spawn(function()
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
			repeat task.wait() until betterisfile(path)
			textlabel:Remove()
		end)
		local req = requestfunc({
			Url = "https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/"..path:gsub("vape/assets", "assets"),
			Method = "GET"
		})
		writefile(path, req.Body)
	end
	if cachedassets[path] == nil then
		cachedassets[path] = getasset(path) 
	end
	return cachedassets[path]
end

local function CreateAutoHotbarGUI(children2, argstable)
	local buttonapi = {}
	buttonapi["Hotbars"] = {}
	buttonapi["CurrentlySelected"] = 1
	local currentanim
	local amount = #children2:GetChildren()
	local sortableitems = {
		{itemType = "swords", itemDisplayType = "diamond_sword"},
		{itemType = "pickaxes", itemDisplayType = "diamond_pickaxe"},
		{itemType = "axes", itemDisplayType = "diamond_axe"},
		{itemType = "shears", itemDisplayType = "shears"},
		{itemType = "wool", itemDisplayType = "wool_white"},
		{itemType = "iron", itemDisplayType = "iron"},
		{itemType = "diamond", itemDisplayType = "diamond"},
		{itemType = "emerald", itemDisplayType = "emerald"},
		{itemType = "bows", itemDisplayType = "wood_bow"},
	}
	local items = bedwars["ItemTable"]
	if items then
		for i2,v2 in pairs(items) do
			if (i2:find("axe") == nil or i2:find("void")) and i2:find("bow") == nil and i2:find("shears") == nil and i2:find("wool") == nil and v2.sword == nil and v2.armor == nil and v2["dontGiveItem"] == nil and bedwars["ItemTable"][i2] and bedwars["ItemTable"][i2].image then
				table.insert(sortableitems, {itemType = i2, itemDisplayType = i2})
			end
		end
	end
	local buttontext = Instance.new("TextButton")
	buttontext.AutoButtonColor = false
	buttontext.BackgroundTransparency = 1
	buttontext.Name = "ButtonText"
	buttontext.Text = ""
	buttontext.Name = argstable["Name"]
	buttontext.LayoutOrder = 1
	buttontext.Size = UDim2.new(1, 0, 0, 40)
	buttontext.Active = false
	buttontext.TextColor3 = Color3.fromRGB(162, 162, 162)
	buttontext.TextSize = 17
	buttontext.Font = Enum.Font.SourceSans
	buttontext.Position = UDim2.new(0, 0, 0, 0)
	buttontext.Parent = children2
	local toggleframe2 = Instance.new("Frame")
	toggleframe2.Size = UDim2.new(0, 200, 0, 31)
	toggleframe2.Position = UDim2.new(0, 10, 0, 4)
	toggleframe2.BackgroundColor3 = Color3.fromRGB(38, 37, 38)
	toggleframe2.Name = "ToggleFrame2"
	toggleframe2.Parent = buttontext
	local toggleframe1 = Instance.new("Frame")
	toggleframe1.Size = UDim2.new(0, 198, 0, 29)
	toggleframe1.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
	toggleframe1.BorderSizePixel = 0
	toggleframe1.Name = "ToggleFrame1"
	toggleframe1.Position = UDim2.new(0, 1, 0, 1)
	toggleframe1.Parent = toggleframe2
	local addbutton = Instance.new("ImageLabel")
	addbutton.BackgroundTransparency = 1
	addbutton.Name = "AddButton"
	addbutton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	addbutton.Position = UDim2.new(0, 93, 0, 9)
	addbutton.Size = UDim2.new(0, 12, 0, 12)
	addbutton.ImageColor3 = Color3.fromRGB(5, 133, 104)
	addbutton.Image = getcustomassetfunc("vape/assets/AddItem.png")
	addbutton.Parent = toggleframe1
	local children3 = Instance.new("Frame")
	children3.Name = argstable["Name"].."Children"
	children3.BackgroundTransparency = 1
	children3.LayoutOrder = amount
	children3.Size = UDim2.new(0, 220, 0, 0)
	children3.Parent = children2
	local uilistlayout = Instance.new("UIListLayout")
	uilistlayout.Parent = children3
	uilistlayout:GetPropertyChangedSignal("AbsoluteContentSize"):connect(function()
		children3.Size = UDim2.new(1, 0, 0, uilistlayout.AbsoluteContentSize.Y)
	end)
	local uicorner = Instance.new("UICorner")
	uicorner.CornerRadius = UDim.new(0, 5)
	uicorner.Parent = toggleframe1
	local uicorner2 = Instance.new("UICorner")
	uicorner2.CornerRadius = UDim.new(0, 5)
	uicorner2.Parent = toggleframe2
	buttontext.MouseEnter:connect(function()
		game:GetService("TweenService"):Create(toggleframe2, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(79, 78, 79)}):Play()
	end)
	buttontext.MouseLeave:connect(function()
		game:GetService("TweenService"):Create(toggleframe2, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(38, 37, 38)}):Play()
	end)
	local ItemListBigFrame = Instance.new("Frame")
	ItemListBigFrame.Size = UDim2.new(1, 0, 1, 0)
	ItemListBigFrame.Name = "ItemList"
	ItemListBigFrame.BackgroundTransparency = 1
	ItemListBigFrame.Visible = false
	ItemListBigFrame.Parent = GuiLibrary["MainGui"]
	local ItemListFrame = Instance.new("Frame")
	ItemListFrame.Size = UDim2.new(0, 660, 0, 445)
	ItemListFrame.Position = UDim2.new(0.5, -330, 0.5, -223)
	ItemListFrame.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
	ItemListFrame.Parent = ItemListBigFrame
	local ItemListExitButton = Instance.new("ImageButton")
	ItemListExitButton.Name = "ItemListExitButton"
	ItemListExitButton.ImageColor3 = Color3.fromRGB(121, 121, 121)
	ItemListExitButton.Size = UDim2.new(0, 24, 0, 24)
	ItemListExitButton.AutoButtonColor = false
	ItemListExitButton.Image = getcustomassetfunc("vape/assets/ExitIcon1.png")
	ItemListExitButton.Visible = true
	ItemListExitButton.Position = UDim2.new(1, -31, 0, 8)
	ItemListExitButton.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
	ItemListExitButton.Parent = ItemListFrame
	local ItemListExitButtonround = Instance.new("UICorner")
	ItemListExitButtonround.CornerRadius = UDim.new(0, 16)
	ItemListExitButtonround.Parent = ItemListExitButton
	ItemListExitButton.MouseEnter:connect(function()
		game:GetService("TweenService"):Create(ItemListExitButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(60, 60, 60), ImageColor3 = Color3.fromRGB(255, 255, 255)}):Play()
	end)
	ItemListExitButton.MouseLeave:connect(function()
		game:GetService("TweenService"):Create(ItemListExitButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(26, 25, 26), ImageColor3 = Color3.fromRGB(121, 121, 121)}):Play()
	end)
	ItemListExitButton.MouseButton1Click:connect(function()
		ItemListBigFrame.Visible = false
		GuiLibrary["MainGui"].ScaledGui.ClickGui.Visible = true
	end)
	local ItemListFrameShadow = Instance.new("ImageLabel")
	ItemListFrameShadow.AnchorPoint = Vector2.new(0.5, 0.5)
	ItemListFrameShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
	ItemListFrameShadow.Image = getcustomassetfunc("vape/assets/WindowBlur.png")
	ItemListFrameShadow.BackgroundTransparency = 1
	ItemListFrameShadow.ZIndex = -1
	ItemListFrameShadow.Size = UDim2.new(1, 6, 1, 6)
	ItemListFrameShadow.ImageColor3 = Color3.new(0, 0, 0)
	ItemListFrameShadow.ScaleType = Enum.ScaleType.Slice
	ItemListFrameShadow.SliceCenter = Rect.new(10, 10, 118, 118)
	ItemListFrameShadow.Parent = ItemListFrame
	local ItemListFrameText = Instance.new("TextLabel")
	ItemListFrameText.Size = UDim2.new(1, 0, 0, 41)
	ItemListFrameText.BackgroundTransparency = 1
	ItemListFrameText.Name = "WindowTitle"
	ItemListFrameText.Position = UDim2.new(0, 0, 0, 0)
	ItemListFrameText.TextXAlignment = Enum.TextXAlignment.Left
	ItemListFrameText.Font = Enum.Font.SourceSans
	ItemListFrameText.TextSize = 17
	ItemListFrameText.Text = "    New AutoHotbar"
	ItemListFrameText.TextColor3 = Color3.fromRGB(201, 201, 201)
	ItemListFrameText.Parent = ItemListFrame
	local ItemListBorder1 = Instance.new("Frame")
	ItemListBorder1.BackgroundColor3 = Color3.fromRGB(40, 39, 40)
	ItemListBorder1.BorderSizePixel = 0
	ItemListBorder1.Size = UDim2.new(1, 0, 0, 1)
	ItemListBorder1.Position = UDim2.new(0, 0, 0, 41)
	ItemListBorder1.Parent = ItemListFrame
	local ItemListFrameCorner = Instance.new("UICorner")
	ItemListFrameCorner.CornerRadius = UDim.new(0, 4)
	ItemListFrameCorner.Parent = ItemListFrame
	local ItemListFrame1 = Instance.new("Frame")
	ItemListFrame1.Size = UDim2.new(0, 112, 0, 113)
	ItemListFrame1.Position = UDim2.new(0, 10, 0, 71)
	ItemListFrame1.BackgroundColor3 = Color3.fromRGB(38, 37, 38)
	ItemListFrame1.Name = "ItemListFrame1"
	ItemListFrame1.Parent = ItemListFrame
	local ItemListFrame2 = Instance.new("Frame")
	ItemListFrame2.Size = UDim2.new(0, 110, 0, 111)
	ItemListFrame2.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	ItemListFrame2.BorderSizePixel = 0
	ItemListFrame2.Name = "ItemListFrame2"
	ItemListFrame2.Position = UDim2.new(0, 1, 0, 1)
	ItemListFrame2.Parent = ItemListFrame1
	local ItemListFramePicker = Instance.new("ScrollingFrame")
	ItemListFramePicker.Size = UDim2.new(0, 495, 0, 220)
	ItemListFramePicker.Position = UDim2.new(0, 144, 0, 122)
	ItemListFramePicker.BorderSizePixel = 0
	ItemListFramePicker.ScrollBarThickness = 3
	ItemListFramePicker.ScrollBarImageTransparency = 0.8
	ItemListFramePicker.VerticalScrollBarInset = Enum.ScrollBarInset.None
	ItemListFramePicker.BackgroundTransparency = 1
	ItemListFramePicker.Parent = ItemListFrame
	local ItemListFramePickerGrid = Instance.new("UIGridLayout")
	ItemListFramePickerGrid.CellPadding = UDim2.new(0, 4, 0, 3)
	ItemListFramePickerGrid.CellSize = UDim2.new(0, 51, 0, 52)
	ItemListFramePickerGrid.Parent = ItemListFramePicker
	ItemListFramePickerGrid:GetPropertyChangedSignal("AbsoluteContentSize"):connect(function()
		ItemListFramePicker.CanvasSize = UDim2.new(0, 0, 0, ItemListFramePickerGrid.AbsoluteContentSize.Y * (1 / GuiLibrary["MainRescale"].Scale))
	end)
	local ItemListcorner = Instance.new("UICorner")
	ItemListcorner.CornerRadius = UDim.new(0, 5)
	ItemListcorner.Parent = ItemListFrame1
	local ItemListcorner2 = Instance.new("UICorner")
	ItemListcorner2.CornerRadius = UDim.new(0, 5)
	ItemListcorner2.Parent = ItemListFrame2
	local selectedslot = 1
	local hoveredslot = 0
	
	local refreshslots
	local refreshList
	refreshslots = function()
		local startnum = 144
		local oldhovered = hoveredslot
		for i2,v2 in pairs(ItemListFrame:GetChildren()) do
			if v2.Name:find("ItemSlot") then
				v2:Remove()
			end
		end
		for i3,v3 in pairs(ItemListFramePicker:GetChildren()) do
			if v3:IsA("TextButton") then
				v3:Remove()
			end
		end
		for i4,v4 in pairs(sortableitems) do
			local ItemFrame = Instance.new("TextButton")
			ItemFrame.Text = ""
			ItemFrame.BackgroundColor3 = Color3.fromRGB(31, 30, 31)
			ItemFrame.Parent = ItemListFramePicker
			ItemFrame.AutoButtonColor = false
			local ItemFrameIcon = Instance.new("ImageLabel")
			ItemFrameIcon.Size = UDim2.new(0, 32, 0, 32)
			ItemFrameIcon.Image = bedwars["getIcon"]({itemType = v4.itemDisplayType}, true) 
			ItemFrameIcon.ResampleMode = (bedwars["getIcon"]({itemType = v4.itemDisplayType}, true):find("rbxasset://") and Enum.ResamplerMode.Pixelated or Enum.ResamplerMode.Default)
			ItemFrameIcon.Position = UDim2.new(0, 10, 0, 10)
			ItemFrameIcon.BackgroundTransparency = 1
			ItemFrameIcon.Parent = ItemFrame
			local ItemFramecorner = Instance.new("UICorner")
			ItemFramecorner.CornerRadius = UDim.new(0, 5)
			ItemFramecorner.Parent = ItemFrame
			ItemFrame.MouseButton1Click:connect(function()
				for i5,v5 in pairs(buttonapi["Hotbars"][buttonapi["CurrentlySelected"]]["Items"]) do
					if v5.itemType == v4.itemType then
						buttonapi["Hotbars"][buttonapi["CurrentlySelected"]]["Items"][tostring(i5)] = nil
					end
				end
				buttonapi["Hotbars"][buttonapi["CurrentlySelected"]]["Items"][tostring(selectedslot)] = v4
				refreshslots()
				refreshList()
			end)
		end
		for i = 1, 9 do
			local item = buttonapi["Hotbars"][buttonapi["CurrentlySelected"]]["Items"][tostring(i)]
			local ItemListFrame3 = Instance.new("Frame")
			ItemListFrame3.Size = UDim2.new(0, 55, 0, 56)
			ItemListFrame3.Position = UDim2.new(0, startnum - 2, 0, 380)
			ItemListFrame3.BackgroundTransparency = (selectedslot == i and 0 or 1)
			ItemListFrame3.BackgroundColor3 = Color3.fromRGB(35, 34, 35)
			ItemListFrame3.Name = "ItemSlot"
			ItemListFrame3.Parent = ItemListFrame
			local ItemListFrame4 = Instance.new("TextButton")
			ItemListFrame4.Size = UDim2.new(0, 51, 0, 52)
			ItemListFrame4.BackgroundColor3 = (oldhovered == i and Color3.fromRGB(31, 30, 31) or Color3.fromRGB(20, 20, 20))
			ItemListFrame4.BorderSizePixel = 0
			ItemListFrame4.AutoButtonColor = false
			ItemListFrame4.Text = ""
			ItemListFrame4.Name = "ItemListFrame4"
			ItemListFrame4.Position = UDim2.new(0, 2, 0, 2)
			ItemListFrame4.Parent = ItemListFrame3
			local ItemListImage = Instance.new("ImageLabel")
			ItemListImage.Size = UDim2.new(0, 32, 0, 32)
			ItemListImage.BackgroundTransparency = 1
			local img = (item and bedwars["getIcon"]({itemType = item.itemDisplayType}, true) or "")
			ItemListImage.Image = img
			ItemListImage.ResampleMode = (img:find("rbxasset://") and Enum.ResamplerMode.Pixelated or Enum.ResamplerMode.Default)
			ItemListImage.Position = UDim2.new(0, 10, 0, 10)
			ItemListImage.Parent = ItemListFrame4
			local ItemListcorner3 = Instance.new("UICorner")
			ItemListcorner3.CornerRadius = UDim.new(0, 5)
			ItemListcorner3.Parent = ItemListFrame3
			local ItemListcorner4 = Instance.new("UICorner")
			ItemListcorner4.CornerRadius = UDim.new(0, 5)
			ItemListcorner4.Parent = ItemListFrame4
			ItemListFrame4.MouseEnter:connect(function()
				ItemListFrame4.BackgroundColor3 = Color3.fromRGB(31, 30, 31)
				hoveredslot = i
			end)
			ItemListFrame4.MouseLeave:connect(function()
				ItemListFrame4.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
				hoveredslot = 0
			end)
			ItemListFrame4.MouseButton1Click:connect(function()
				selectedslot = i
				refreshslots()
			end)
			ItemListFrame4.MouseButton2Click:connect(function()
				buttonapi["Hotbars"][buttonapi["CurrentlySelected"]]["Items"][tostring(i)] = nil
				refreshslots()
				refreshList()
			end)
			startnum = startnum + 55
		end
	end	

	local function createHotbarButton(num, items)
		num = tonumber(num) or #buttonapi["Hotbars"] + 1
		local hotbarbutton = Instance.new("TextButton")
		hotbarbutton.Size = UDim2.new(1, 0, 0, 30)
		hotbarbutton.BackgroundTransparency = 1
		hotbarbutton.LayoutOrder = num
		hotbarbutton.AutoButtonColor = false
		hotbarbutton.Text = ""
		hotbarbutton.Parent = children3
		buttonapi["Hotbars"][num] = {["Items"] = items or {}, ["Object"] = hotbarbutton, ["Number"] = num}
		local hotbarframe = Instance.new("Frame")
		hotbarframe.BackgroundColor3 = (num == buttonapi["CurrentlySelected"] and Color3.fromRGB(54, 53, 54) or Color3.fromRGB(31, 30, 31))
		hotbarframe.Size = UDim2.new(0, 200, 0, 27)
		hotbarframe.Position = UDim2.new(0, 10, 0, 1)
		hotbarframe.Parent = hotbarbutton
		local uicorner3 = Instance.new("UICorner")
		uicorner3.CornerRadius = UDim.new(0, 5)
		uicorner3.Parent = hotbarframe
		local startpos = 11
		for i = 1, 9 do
			local item = buttonapi["Hotbars"][num]["Items"][tostring(i)]
			local hotbarbox = Instance.new("ImageLabel")
			hotbarbox.Name = i
			hotbarbox.Size = UDim2.new(0, 17, 0, 18)
			hotbarbox.Position = UDim2.new(0, startpos, 0, 5)
			hotbarbox.BorderSizePixel = 0
			hotbarbox.Image = (item and bedwars["getIcon"]({itemType = item.itemDisplayType}, true) or "")
			hotbarbox.ResampleMode = ((item and bedwars["getIcon"]({itemType = item.itemDisplayType}, true) or ""):find("rbxasset://") and Enum.ResamplerMode.Pixelated or Enum.ResamplerMode.Default)
			hotbarbox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			hotbarbox.Parent = hotbarframe
			startpos = startpos + 18
		end
		hotbarbutton.MouseButton1Click:connect(function()
			if buttonapi["CurrentlySelected"] == num then
				ItemListBigFrame.Visible = true
				GuiLibrary["MainGui"].ScaledGui.ClickGui.Visible = false
				refreshslots()
			end
			buttonapi["CurrentlySelected"] = num
			refreshList()
		end)
		hotbarbutton.MouseButton2Click:connect(function()
			if buttonapi["CurrentlySelected"] == num then
				buttonapi["CurrentlySelected"] = (num == 2 and 0 or 1)
			end
			table.remove(buttonapi["Hotbars"], num)
			refreshList()
		end)
	end

	refreshList = function()
		local newnum = 0
		local newtab = {}
		for i3,v3 in pairs(buttonapi["Hotbars"]) do
			newnum = newnum + 1
			newtab[newnum] = v3
		end
		buttonapi["Hotbars"] = newtab
		for i,v in pairs(children3:GetChildren()) do
			if v:IsA("TextButton") then
				v:Remove()
			end
		end
		for i2,v2 in pairs(buttonapi["Hotbars"]) do
			createHotbarButton(i2, v2["Items"])
		end
		GuiLibrary["Settings"][children2.Name..argstable["Name"].."ItemList"] = {["Type"] = "ItemList", ["Items"] = buttonapi["Hotbars"], ["CurrentlySelected"] = buttonapi["CurrentlySelected"]}
	end
	buttonapi["RefreshList"] = refreshList

	buttontext.MouseButton1Click:connect(function()
		createHotbarButton()
	end)

	GuiLibrary["Settings"][children2.Name..argstable["Name"].."ItemList"] = {["Type"] = "ItemList", ["Items"] = buttonapi["Hotbars"], ["CurrentlySelected"] = buttonapi["CurrentlySelected"]}
	GuiLibrary["ObjectsThatCanBeSaved"][children2.Name..argstable["Name"].."ItemList"] = {["Type"] = "ItemList", ["Items"] = buttonapi["Hotbars"], ["Api"] = buttonapi, ["Object"] = buttontext}

	return buttonapi
end

GuiLibrary["LoadSettingsEvent"].Event:connect(function(res)
	for i,v in pairs(res) do
		local obj = GuiLibrary["ObjectsThatCanBeSaved"][i]
		if obj and v["Type"] == "ItemList" and obj.Api then
			obj["Api"]["Hotbars"] = v["Items"]
			obj["Api"]["CurrentlySelected"] = v["CurrentlySelected"]
			obj["Api"]["RefreshList"]()
		end
	end
end)

local function createwarning(title, text, delay)
	local suc, res = pcall(function()
		local frame = GuiLibrary["CreateNotification"](title, text, delay, "assets/WarningNotification.png")
		frame.Frame.Frame.ImageColor3 = Color3.fromRGB(236, 129, 44)
		return frame
	end)
	return (suc and res)
end

local function getItemNear(itemName, inv)
	for i5, v5 in pairs(inv or currentinventory.inventory.items) do
		if v5.itemType:find(itemName) then
			return v5, i5
		end
	end
	return nil
end

local function getItem(itemName, inv)
	for i5, v5 in pairs(inv or currentinventory.inventory.items) do
		if v5.itemType == itemName then
			return v5, i5
		end
	end
	return nil
end

local function getHotbarSlot(itemName)
	for i5, v5 in pairs(currentinventory.hotbar) do
		if v5["item"] and v5["item"].itemType == itemName then
			return i5 - 1
		end
	end
	return nil
end

local function getSword()
	local bestsword, bestswordslot, bestswordnum = nil, nil, 0
	for i5, v5 in pairs(currentinventory.inventory.items) do
		if bedwars["ItemTable"][v5.itemType]["sword"] then
			local swordrank = bedwars["ItemTable"][v5.itemType]["sword"]["damage"] or 0
			if swordrank > bestswordnum then
				bestswordnum = swordrank
				bestswordslot = i5
				bestsword = v5
			end
		end
	end
	return bestsword, bestswordslot
end

local function getBlock()
	for i5, v5 in pairs(currentinventory.inventory.items) do
		if bedwars["ItemTable"][v5.itemType]["block"] then
			return v5.itemType, v5.amount
		end
	end
	return
end

local function getSlotFromItem(item)
	for i,v in pairs(currentinventory.inventory.items) do
		if v.itemType == item.itemType then
			return i
		end
	end
	return nil
end

local function getShield(char)
	local shield = 0
	for i,v in pairs(char:GetAttributes()) do 
		if i:find("Shield") and type(v) == "number" then 
			shield = shield + v
		end
	end
	return shield
end

local function getAxe()
	local bestsword, bestswordslot, bestswordnum = nil, nil, 0
	for i5, v5 in pairs(currentinventory.inventory.items) do
		if v5.itemType:find("axe") and v5.itemType:find("pickaxe") == nil and v5.itemType:find("void") == nil then
			bestswordnum = swordrank
			bestswordslot = i5
			bestsword = v5
		end
	end
	return bestsword, bestswordslot
end

local function getPickaxe()
	return getItemNear("pick")
end

local function getBaguette()
	return getItemNear("baguette")
end

local function getwool()
	local wool = getItemNear("wool")
	return wool and wool.itemType, wool and wool.amount
end

local function isAliveOld(plr, alivecheck)
	if plr then
		return plr and plr.Character and plr.Character.Parent ~= nil and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Head") and plr.Character:FindFirstChild("Humanoid")
	end
	return entity.isAlive
end

local function isAlive(plr, alivecheck)
	if plr then
		local ind, tab = entity.getEntityFromPlayer(plr)
		return ((not alivecheck) or tab and tab.Humanoid:GetState() ~= Enum.HumanoidStateType.Dead) and tab
	end
	return entity.isAlive
end

local function hashvec(vec)
	return {
		["value"] = vec
	}
end

local function getremote(tab)
	for i,v in pairs(tab) do
		if v == "Client" then
			return tab[i + 1]
		end
	end
	return ""
end

local function betterfind(tab, obj)
	for i,v in pairs(tab) do
		if v == obj or type(v) == "table" and v.hash == obj then
			return v
		end
	end
	return nil
end

local GetNearestHumanoidToMouse = function() end

local function randomString()
	local randomlength = math.random(10,100)
	local array = {}

	for i = 1, randomlength do
		array[i] = string.char(math.random(32, 126))
	end

	return table.concat(array)
end

local function getWhitelistedBed(bed)
	for i,v in pairs(players:GetChildren()) do
		if v:GetAttribute("Team") and bed and bed:GetAttribute("Team"..v:GetAttribute("Team").."NoBreak") and bedwars["CheckWhitelisted"](v) then
			return true
		end
	end
	return false
end

local OldClientGet 
local oldbreakremote
local oldbob
runcode(function()
    getfunctions = function()
		local Flamework = require(repstorage["rbxts_include"]["node_modules"]["@flamework"].core.out).Flamework
		repeat task.wait() until Flamework.isInitialized
        local KnitClient = debug.getupvalue(require(lplr.PlayerScripts.TS.knit).setup, 6)
        local Client = require(repstorage.TS.remotes).default.Client
        local InventoryUtil = require(repstorage.TS.inventory["inventory-util"]).InventoryUtil
        OldClientGet = getmetatable(Client).Get
        getmetatable(Client).Get = function(Self, remotename)
			local res = OldClientGet(Self, remotename)
			if uninjectflag then return res end
			if remotename == "DamageBlock" then
				return {
					["CallServerAsync"] = function(Self, tab)
						local block = bedwars["BlockController"]:getStore():getBlockAt(tab.blockRef.blockPosition)
						if block and block.Name == "bed" then
							if getWhitelistedBed(block) then
								return {andThen = function(self, func) 
									func("failed")
								end}
							end
						end
						return res:CallServerAsync(tab)
					end,
					["CallServer"] = function(Self, tab)
						local block = bedwars["BlockController"]:getStore():getBlockAt(tab.blockRef.blockPosition)
						if block and block.Name == "bed" then
							if getWhitelistedBed(block) then
								return {andThen = function(self, func) 
									func("failed")
								end}
							end
						end
						return res:CallServer(tab)
					end
				}
			elseif remotename == bedwars["AttackRemote"] then
				return {
					["instance"] = res["instance"],
					["SendToServer"] = function(Self, tab)
						local suc, plr = pcall(function() return players:GetPlayerFromCharacter(tab.entityInstance) end)
						if suc and plr then
							local playertype, playerattackable = bedwars["CheckPlayerType"](plr)
							if not playerattackable then 
								return nil
							end
						end
						if Reach["Enabled"] then
							local mag = (tab.validate.selfPosition.value - tab.validate.targetPosition.value).magnitude
							local newres = hashvec(tab.validate.selfPosition.value + (mag > 14.4 and (CFrame.lookAt(tab.validate.selfPosition.value, tab.validate.targetPosition.value).lookVector * 4) or Vector3.zero))
							tab.validate.selfPosition = newres
						end
						return res:SendToServer(tab)
					end
				}
			end
            return res
        end
		bedwars = {
			["AnimationUtil"] = require(repstorage["rbxts_include"]["node_modules"]["@easy-games"]["game-core"].out["shared"].util["animation-util"]).AnimationUtil,
			["AngelUtil"] = require(repstorage.TS.games.bedwars.kit.kits.angel["angel-kit"]),
			["AppController"] = require(repstorage["rbxts_include"]["node_modules"]["@easy-games"]["game-core"].out.client.controllers["app-controller"]).AppController,
			["AttackRemote"] = getremote(debug.getconstants(getmetatable(KnitClient.Controllers.SwordController)["attackEntity"])),
			["BatteryRemote"] = getremote(debug.getconstants(debug.getproto(debug.getproto(KnitClient.Controllers.BatteryController.KnitStart, 1), 1))),
			["BatteryEffectController"] = KnitClient.Controllers.BatteryEffectsController,
            ["BalloonController"] = KnitClient.Controllers.BalloonController,
            ["BlockController"] = require(repstorage["rbxts_include"]["node_modules"]["@easy-games"]["block-engine"].out).BlockEngine,
            ["BlockController2"] = require(repstorage["rbxts_include"]["node_modules"]["@easy-games"]["block-engine"].out.client.placement["block-placer"]).BlockPlacer,
            ["BlockEngine"] = require(lplr.PlayerScripts.TS.lib["block-engine"]["client-block-engine"]).ClientBlockEngine,
            ["BlockEngineClientEvents"] = require(repstorage["rbxts_include"]["node_modules"]["@easy-games"]["block-engine"].out.client["block-engine-client-events"]).BlockEngineClientEvents,
			["BlockPlacementController"] = KnitClient.Controllers.BlockPlacementController,
            ["BedwarsKits"] = require(repstorage.TS.games.bedwars.kit["bedwars-kit-shop"]).BedwarsKitShop,
			["BedTable"] = {},
            ["BlockBreaker"] = KnitClient.Controllers.BlockBreakController.blockBreaker,
            ["BowTable"] = KnitClient.Controllers.ProjectileController,
			["BowConstantsTable"] = debug.getupvalue(KnitClient.Controllers.ProjectileController.enableBeam, 5),
			["ChestController"] = KnitClient.Controllers.ChestController,
			["CheckWhitelisted"] = function(plr, ownercheck)
				local plrstr = bedwars["HashFunction"](plr.Name..plr.UserId)
				local localstr = bedwars["HashFunction"](lplr.Name..lplr.UserId)
				return ((ownercheck == nil and (betterfind(whitelisted.players, plrstr) or betterfind(whitelisted.owners, plrstr)) or ownercheck and betterfind(whitelisted.owners, plrstr))) and betterfind(whitelisted.owners, localstr) == nil and true or false
			end,
			["CheckPlayerType"] = function(plr)
				local plrstr = bedwars["HashFunction"](plr.Name..plr.UserId)
				local playertype, playerattackable = "DEFAULT", true
				local private = betterfind(whitelisted.players, plrstr)
				local owner = betterfind(whitelisted.owners, plrstr)
				if private then
					playertype = "VAPE PRIVATE"
					playerattackable = not (type(private) == "table" and private.invulnerable or true)
				end
				if owner then
					playertype = "VAPE OWNER"
					playerattackable = not (type(owner) == "table" and owner.invulnerable or true)
				end
				return playertype, playerattackable
			end,
			["ClickHold"] = require(repstorage["rbxts_include"]["node_modules"]["@easy-games"]["game-core"].out.client.ui.lib.util["click-hold"]).ClickHold,
            ["ClientHandler"] = Client,
			["SharedConstants"] = require(repstorage.TS["shared-constants"]),
            ["ClientHandlerDamageBlock"] = require(repstorage["rbxts_include"]["node_modules"]["@easy-games"]["block-engine"].out.remotes).BlockEngineRemotes.Client,
            ["ClientStoreHandler"] = require(lplr.PlayerScripts.TS.ui.store).ClientStore,
			["ClientHandlerSyncEvents"] = require(lplr.PlayerScripts.TS["client-sync-events"]).ClientSyncEvents,
            ["CombatConstant"] = require(repstorage.TS.combat["combat-constant"]).CombatConstant,
			["CombatController"] = KnitClient.Controllers.CombatController,
			["ConsumeSoulRemote"] = getremote(debug.getconstants(KnitClient.Controllers.GrimReaperController.consumeSoul)),
			["ConstantManager"] = require(repstorage["rbxts_include"]["node_modules"]["@easy-games"]["game-core"].out["shared"].constant["constant-manager"]).ConstantManager,
			["CooldownController"] = KnitClient.Controllers.CooldownController,
            ["damageTable"] = KnitClient.Controllers.DamageController,
			["DinoRemote"] = getremote(debug.getconstants(debug.getproto(KnitClient.Controllers.DinoTamerController.KnitStart, 3))),
			["DaoRemote"] = getremote(debug.getconstants(debug.getprotos(KnitClient.Controllers.DaoController.onEnable)[4])),
			["DamageController"] = KnitClient.Controllers.DamageController,
			["DamageIndicator"] = KnitClient.Controllers.DamageIndicatorController.spawnDamageIndicator,
			["DamageIndicatorController"] = KnitClient.Controllers.DamageIndicatorController,
			["DetonateRavenRemote"] = getremote(debug.getconstants(getmetatable(KnitClient.Controllers.RavenController).detonateRaven)),
            ["DropItem"] = getmetatable(KnitClient.Controllers.ItemDropController).dropItemInHand,
            ["DropItemRemote"] = getremote(debug.getconstants(getmetatable(KnitClient.Controllers.ItemDropController).dropItemInHand)),
            ["EatRemote"] = getremote(debug.getconstants(debug.getproto(getmetatable(KnitClient.Controllers.ConsumeController).onEnable, 1))),
            ["EquipItemRemote"] = getremote(debug.getconstants(debug.getprotos(shared.oldequipitem or require(repstorage.TS.entity.entities["inventory-entity"]).InventoryEntity.equipItem)[3])),
			["FishermanTable"] = KnitClient.Controllers.FishermanController,
			["FovController"] = KnitClient.Controllers.FovController,
			["GameAnimationUtil"] = require(repstorage.TS.animation["animation-util"]).GameAnimationUtil,
			["GamePlayerUtil"] = require(repstorage.TS.player["player-util"]).GamePlayerUtil,
            ["getEntityTable"] = require(repstorage.TS.entity["entity-util"]).EntityUtil,
            ["getIcon"] = function(item, showinv)
                local itemmeta = bedwars["ItemTable"][item.itemType]
                if itemmeta and showinv then
                    return itemmeta.image
                end
                return ""
            end,
			["getInventory2"] = function(plr)
                local suc, result = pcall(function() 
					return InventoryUtil.getInventory(plr) 
				end)
                return (suc and result or {
                    ["items"] = {},
                    ["armor"] = {},
                    ["hand"] = nil
                })
            end,
            ["getItemMetadata"] = require(repstorage.TS.item["item-meta"]).getItemMeta,
			["GrimReaperController"] = KnitClient.Controllers.GrimReaperController,
			["GuitarHealRemote"] = getremote(debug.getconstants(KnitClient.Controllers.GuitarController.performHeal)),
			["HashFunction"] = function(str)
				if storedshahashes[tostring(str)] == nil then
					storedshahashes[tostring(str)] = shalib.sha512(tostring(str).."SelfReport")
				end
				return storedshahashes[tostring(str)]
			end,
			["HangGliderController"] = KnitClient.Controllers.HangGliderController,
			["HighlightController"] = KnitClient.Controllers.EntityHighlightController,
            ["ItemTable"] = debug.getupvalue(require(repstorage.TS.item["item-meta"]).getItemMeta, 1),
			["IsVapePrivateIngame"] = function()
				for i,v in pairs(players:GetChildren()) do 
					local plrstr = bedwars["HashFunction"](v.Name..v.UserId)
					if bedwars["CheckPlayerType"](v) ~= "DEFAULT" or whitelisted.chattags[plrstr] then 
						return true
					end
				end
				return false
			end,
			["JuggernautRemote"] = getremote(debug.getconstants(debug.getprotos(debug.getprotos(KnitClient.Controllers.JuggernautController.KnitStart)[1])[4])),
			["KatanaController"] = KnitClient.Controllers.DaoController,
			["KatanaRemote"] = getremote(debug.getconstants(debug.getproto(KnitClient.Controllers.DaoController.onEnable, 4))),
            ["KnockbackTable"] = debug.getupvalue(require(repstorage.TS.damage["knockback-util"]).KnockbackUtil.calculateKnockbackVelocity, 1),
			["LobbyClientEvents"] = require(repstorage["rbxts_include"]["node_modules"]["@easy-games"].lobby.out.client.events).LobbyClientEvents,
			["MapMeta"] = require(repstorage.TS.game.map["map-meta"]),
			["MissileController"] = KnitClient.Controllers.GuidedProjectileController,
			["MinerRemote"] = getremote(debug.getconstants(debug.getprotos(debug.getproto(getmetatable(KnitClient.Controllers.MinerController).onKitEnabled, 1))[2])),
			["MinerController"] = KnitClient.Controllers.MinerController,
			["ProdAnimations"] = require(repstorage.TS.animation.definitions["prod-animations"]).ProdAnimations,
            ["PickupRemote"] = getremote(debug.getconstants(getmetatable(KnitClient.Controllers.ItemDropController).checkForPickup)),
            ["PlayerUtil"] = require(repstorage.TS.player["player-util"]).GamePlayerUtil,
			["ProjectileMeta"] = require(repstorage.TS.projectile["projectile-meta"]).ProjectileMeta,
			["QueueMeta"] = require(repstorage.TS.game["queue-meta"]).QueueMeta,
			["QueueCard"] = require(lplr.PlayerScripts.TS.controllers.global.queue.ui["queue-card"]).QueueCard,
			["QueryUtil"] = require(repstorage["rbxts_include"]["node_modules"]["@easy-games"]["game-core"].out).GameQueryUtil,
			["PaintRemote"] = getremote(debug.getconstants(KnitClient.Controllers.PaintShotgunController.fire)),
            ["prepareHashing"] = require(repstorage.TS["remote-hash"]["remote-hash-util"]).RemoteHashUtil.prepareHashVector3,
			["ProjectileRemote"] = getremote(debug.getconstants(debug.getupvalues(getmetatable(KnitClient.Controllers.ProjectileController)["launchProjectileWithValues"])[2])),
			["ProjectileHitRemote"] = getremote(debug.getconstants(debug.getproto(KnitClient.Controllers.ProjectileController.createLocalProjectile, 1))),
            ["RavenTable"] = KnitClient.Controllers.RavenController,
			["RespawnController"] = KnitClient.Controllers.BedwarsRespawnController,
			["RespawnTimer"] = require(lplr.PlayerScripts.TS.controllers.games.bedwars.respawn.ui["respawn-timer"]).RespawnTimerWrapper,
			["ResetRemote"] = getremote(debug.getconstants(debug.getproto(KnitClient.Controllers.ResetController.createBindable, 1))),
			["Roact"] = require(repstorage["rbxts_include"]["node_modules"]["roact"].src),
			["RuntimeLib"] = require(repstorage["rbxts_include"].RuntimeLib),
            ["Shop"] = require(repstorage.TS.games.bedwars.shop["bedwars-shop"]).BedwarsShop,
			["ShopItems"] = debug.getupvalue(require(repstorage.TS.games.bedwars.shop["bedwars-shop"]).BedwarsShop.getShopItem, 2),
            ["ShopRight"] = require(lplr.PlayerScripts.TS.controllers.games.bedwars.shop.ui["item-shop"]["shop-left"]["shop-left"]).BedwarsItemShopLeft,
			["SpawnRavenRemote"] = getremote(debug.getconstants(getmetatable(KnitClient.Controllers.RavenController).spawnRaven)),
            ["SoundManager"] = require(repstorage["rbxts_include"]["node_modules"]["@easy-games"]["game-core"].out).SoundManager,
			["SoundList"] = require(repstorage.TS.sound["game-sound"]).GameSound,
            ["sprintTable"] = KnitClient.Controllers.SprintController,
			["StopwatchController"] = KnitClient.Controllers.StopwatchController,
            ["SwingSword"] = getmetatable(KnitClient.Controllers.SwordController).swingSwordAtMouse,
            ["SwingSwordRegion"] = getmetatable(KnitClient.Controllers.SwordController).swingSwordInRegion,
            ["SwordController"] = KnitClient.Controllers.SwordController,
            ["TreeRemote"] = getremote(debug.getconstants(debug.getprotos(debug.getprotos(KnitClient.Controllers.BigmanController.KnitStart)[2])[1])),
			["TrinityRemote"] = getremote(debug.getconstants(debug.getproto(getmetatable(KnitClient.Controllers.AngelController).onKitEnabled, 1))),
            ["VictoryScreen"] = require(lplr.PlayerScripts.TS.controllers["game"].match.ui["victory-section"]).VictorySection,
            ["ViewmodelController"] = KnitClient.Controllers.ViewmodelController,
			["VehicleController"] = KnitClient.Controllers.VehicleController,
			["WeldTable"] = require(repstorage.TS.util["weld-util"]).WeldUtil,
        }
		oldbob = bedwars["ViewmodelController"]["playAnimation"]
        bedwars["ViewmodelController"]["playAnimation"] = function(Self, id, ...)
            if id == 19 and nobob["Enabled"] and entity.isAlive then
                id = 11
            end
            return oldbob(Self, id, ...)
        end
		blocktable = bedwars["BlockController2"].new(bedwars["BlockEngine"], getwool())
		bedwars["placeBlock"] = function(newpos, customblock)
			if getItem(customblock) then
				blocktable.blockType = customblock
				return blocktable:placeBlock(vec3(newpos.X / 3, newpos.Y / 3, newpos.Z / 3))
			end
		end
        task.spawn(function()
            repeat task.wait() until matchState ~= 0
			if (not uninjectflag) then
				bedwarsblocks = collectionservice:GetTagged("block")
				connectionstodisconnect[#connectionstodisconnect + 1] = collectionservice:GetInstanceAddedSignal("block"):connect(function(v) table.insert(bedwarsblocks, v) blockraycast.FilterDescendantsInstances = bedwarsblocks end)
				connectionstodisconnect[#connectionstodisconnect + 1] = collectionservice:GetInstanceRemovedSignal("block"):connect(function(v) local found = table.find(bedwarsblocks, v) if found then table.remove(bedwarsblocks, found) end blockraycast.FilterDescendantsInstances = bedwarsblocks end)
				blockraycast.FilterDescendantsInstances = bedwarsblocks
				local lowestypos = 99999
				for i,v in pairs(bedwarsblocks) do 
					if v.Name == "bed" then 
						table.insert(bedwars["BedTable"], v)
					end
				end
				for i,v in pairs(bedwarsblocks) do 
					local newray = workspace:Raycast(v.Position + vec3(0, 800, 0), vec3(0, -1000, 0), blockraycast)
					if i % 200 == 0 then 
						task.wait(0.06)
					end
					if newray and newray.Position.Y <= lowestypos then
						lowestypos = newray.Position.Y
					end
				end
				antivoidypos = lowestypos - 8
			end
        end)
		connectionstodisconnect[#connectionstodisconnect + 1] = bedwars["ClientStoreHandler"].changed:connect(function(p3, p4)
			if p3.Game ~= p4.Game then 
				matchState = p3.Game.matchState
				queueType = p3.Game.queueType or "bedwars_test"
			end
			if p3.Kit ~= p4.Kit then 	
				bedwars["BountyHunterTarget"] = p3.Kit.bountyHunterTarget
			end
			if p3.Bedwars ~= p4.Bedwars then 
				kit = p3.Bedwars.kit
			end
			if p3.Inventory ~= p4.Inventory then 
				currentinventory = p3.Inventory.observedInventory
			end
        end)
		local clientstorestate = bedwars["ClientStoreHandler"]:getState()
        matchState = clientstorestate.Game.matchState or 0
        kit = clientstorestate.Bedwars.kit or ""
		queueType = clientstorestate.Game.queueType or "bedwars_test"
		currentinventory = clientstorestate.Inventory.observedInventory
		if not shared.vapebypassed then
			local fakeremote = Instance.new("RemoteEvent")
			fakeremote.Name = "GameAnalyticsError"
			local realremote = repstorage:WaitForChild("GameAnalyticsError")
			realremote.Parent = nil
			fakeremote.Parent = repstorage
			game:GetService("ScriptContext").Error:Connect(function(p1, p2, p3)
				if not p3 then
					return;
				end;
				local u2 = nil;
				local v4, v5 = pcall(function()
					u2 = p3:GetFullName();
				end);
				if not v4 then
					return;
				end;
				if p3.Parent == nil then
					return;
				end
				realremote:FireServer(p1, p2, u2);
			end)
			shared.vapebypassed = true
		end

		task.spawn(function()
			local chatsuc, chatres = pcall(function() return game:GetService("HttpService"):JSONDecode(readfile("vape/Profiles/bedwarssettings.json")) end)
			if chatsuc then
				if chatres.crashed and (not chatres.said) then
					pcall(function()
						local notification1 = createwarning("Vape", "either ur poor or its a exploit moment", 10)
						notification1:GetChildren()[5].TextSize = 15
						local notification2 = createwarning("Vape", "getconnections crashed, chat hook not loaded.", 10)
						notification2:GetChildren()[5].TextSize = 13
					end)
					local jsondata = game:GetService("HttpService"):JSONEncode({
						crashed = true,
						said = true,
					})
					writefile("vape/Profiles/bedwarssettings.json", jsondata)
				end
				if chatres.crashed then
					return nil
				else
					local jsondata = game:GetService("HttpService"):JSONEncode({
						crashed = true,
						said = false,
					})
					writefile("vape/Profiles/bedwarssettings.json", jsondata)
				end
			else
				local jsondata = game:GetService("HttpService"):JSONEncode({
					crashed = true,
					said = false,
				})
				writefile("vape/Profiles/bedwarssettings.json", jsondata)
			end
			repeat task.wait() until whitelistsuc
			for i3,v3 in pairs(whitelisted.chattags) do
				if v3.NameColor then
					v3.NameColor = Color3.fromRGB(v3.NameColor.r, v3.NameColor.g, v3.NameColor.b)
				end
				if v3.ChatColor then
					v3.ChatColor = Color3.fromRGB(v3.ChatColor.r, v3.ChatColor.g, v3.ChatColor.b)
				end
				if v3.Tags then
					for i4,v4 in pairs(v3.Tags) do
						if v4.TagColor then
							v4.TagColor = Color3.fromRGB(v4.TagColor.r, v4.TagColor.g, v4.TagColor.b)
						end
					end
				end
			end
			if getconnections then 
				for i,v in pairs(getconnections(repstorage.DefaultChatSystemChatEvents.OnNewMessage.OnClientEvent)) do
					if v.Function and #debug.getupvalues(v.Function) > 0 and type(debug.getupvalues(v.Function)[1]) == "table" and getmetatable(debug.getupvalues(v.Function)[1]) and getmetatable(debug.getupvalues(v.Function)[1]).GetChannel then
						oldchanneltab = getmetatable(debug.getupvalues(v.Function)[1])
						oldchannelfunc = getmetatable(debug.getupvalues(v.Function)[1]).GetChannel
						getmetatable(debug.getupvalues(v.Function)[1]).GetChannel = function(Self, Name)
							local tab = oldchannelfunc(Self, Name)
							if tab and tab.AddMessageToChannel then
								local addmessage = tab.AddMessageToChannel
								if oldchanneltabs[tab] == nil then
									oldchanneltabs[tab] = tab.AddMessageToChannel
								end
								tab.AddMessageToChannel = function(Self2, MessageData)
									if MessageData.FromSpeaker and players[MessageData.FromSpeaker] then
										local plrtype = bedwars["CheckPlayerType"](players[MessageData.FromSpeaker])
										local hash = bedwars["HashFunction"](players[MessageData.FromSpeaker].Name..players[MessageData.FromSpeaker].UserId)
										if plrtype == "VAPE PRIVATE" then
											MessageData.ExtraData = {
												NameColor = players[MessageData.FromSpeaker].Team == nil and Color3.new(0, 1, 1) or players[MessageData.FromSpeaker].TeamColor.Color,
												Tags = {
													table.unpack(MessageData.ExtraData.Tags),
													{
														TagColor = Color3.new(0.7, 0, 1),
														TagText = "VAPE PRIVATE"
													}
												}
											}
										end
										if plrtype == "VAPE OWNER" then
											MessageData.ExtraData = {
												NameColor = players[MessageData.FromSpeaker].Team == nil and Color3.new(1, 0, 0) or players[MessageData.FromSpeaker].TeamColor.Color,
												Tags = {
													table.unpack(MessageData.ExtraData.Tags),
													{
														TagColor = Color3.new(1, 0.3, 0.3),
														TagText = "VAPE OWNER"
													}
												}
											}
										end
										if clients.ClientUsers[tostring(players[MessageData.FromSpeaker])] then
											MessageData.ExtraData = {
												NameColor = players[MessageData.FromSpeaker].Team == nil and Color3.new(1, 0, 0) or players[MessageData.FromSpeaker].TeamColor.Color,
												Tags = {
													table.unpack(MessageData.ExtraData.Tags),
													{
														TagColor = Color3.new(1, 1, 0),
														TagText = clients.ClientUsers[tostring(players[MessageData.FromSpeaker])]
													}
												}
											}
										end
										if whitelisted.chattags[hash] then
											local newdata = {
												NameColor = players[MessageData.FromSpeaker].Team == nil and whitelisted.chattags[hash].NameColor or players[MessageData.FromSpeaker].TeamColor.Color,
												Tags = whitelisted.chattags[hash].Tags
											}
											MessageData.ExtraData = newdata
										end
									end
									return addmessage(Self2, MessageData)
								end
							end
							return tab
						end
					end
				end
			end
			local jsondata = game:GetService("HttpService"):JSONEncode({
				crashed = false,
				said = false,
			})
			writefile("vape/Profiles/bedwarssettings.json", jsondata)
		end)
    end
end)

local fakeuiconnection
GuiLibrary["SelfDestructEvent"].Event:connect(function()
	if OldClientGet then
		getmetatable(bedwars["ClientHandler"]).Get = OldClientGet
	end
	uninjectflag = true
	if blocktable then blocktable:disable() end
	if teleportfunc then teleportfunc:Disconnect() end
	if chatconnection then chatconnection:Disconnect() end
	if chatconnection2 then chatconnection2:Disconnect() end
	if fakeuiconnection then fakeuiconnection:Disconnect() end
	if oldchannelfunc and oldchanneltab then oldchanneltab.GetChannel = oldchannelfunc end
	for i2,v2 in pairs(oldchanneltabs) do i2.AddMessageToChannel = v2 end
	for i3,v3 in pairs(connectionstodisconnect) do
		if v3.Disconnect then pcall(function() v3:Disconnect() end) end
	end
end)

chatconnection2 = lplr.PlayerGui:WaitForChild("Chat").Frame.ChatChannelParentFrame["Frame_MessageLogDisplay"].Scroller.ChildAdded:connect(function(text)
	local textlabel2 = text:WaitForChild("TextLabel")
	if bedwars["IsVapePrivateIngame"] and bedwars["IsVapePrivateIngame"]() then
		local args = textlabel2.Text:split(" ")
		local client = clients.ChatStrings1[#args > 0 and args[#args] or tab.Message]
		if textlabel2.Text:find("You are now chatting") or textlabel2.Text:find("You are now privately chatting") then
			text.Size = UDim2.new(0, 0, 0, 0)
			text:GetPropertyChangedSignal("Size"):connect(function()
				text.Size = UDim2.new(0, 0, 0, 0)
			end)
		end
		if client then
			if textlabel2.Text:find(clients.ChatStrings2[client]) then
				text.Size = UDim2.new(0, 0, 0, 0)
				text:GetPropertyChangedSignal("Size"):connect(function()
					text.Size = UDim2.new(0, 0, 0, 0)
				end)
			end
		end
		textlabel2:GetPropertyChangedSignal("Text"):connect(function()
			local args = textlabel2.Text:split(" ")
			local client = clients.ChatStrings1[#args > 0 and args[#args] or tab.Message]
			if textlabel2.Text:find("You are now chatting") or textlabel2.Text:find("You are now privately chatting") then
				text.Size = UDim2.new(0, 0, 0, 0)
				text:GetPropertyChangedSignal("Size"):connect(function()
					text.Size = UDim2.new(0, 0, 0, 0)
				end)
			end
			if client then
				if textlabel2.Text:find(clients.ChatStrings2[client]) then
					text.Size = UDim2.new(0, 0, 0, 0)
					text:GetPropertyChangedSignal("Size"):connect(function()
						text.Size = UDim2.new(0, 0, 0, 0)
					end)
				end
			end
		end)
	end
end)

teleportfunc = lplr.OnTeleport:Connect(function(State)
    if State == Enum.TeleportState.Started then
		local clientstorestate = bedwars["ClientStoreHandler"]:getState()
		local queuedstring = ''
		if clientstorestate.Party and clientstorestate.Party.members and #clientstorestate.Party.members > 0 then
        	queuedstring = queuedstring..'shared.vapeteammembers = '..#clientstorestate.Party.members..'\n'
		end
		if tpstring then
			queuedstring = queuedstring..'shared.vapeoverlay = "'..tpstring..'"\n'
		end
		queueteleport(queuedstring)
    end
end)

local function getblock(pos)
	local blockpos = bedwars["BlockController"]:getBlockPosition(pos)
	return bedwars["BlockController"]:getStore():getBlockAt(blockpos), blockpos
end

getfunctions()

local function getNametagString(plr)
	local nametag = ""
	local hash = bedwars["HashFunction"](plr.Name..plr.UserId)
	if bedwars["CheckPlayerType"](plr) == "KAWAII" then
		nametag = '<font color="rgb(127, 0, 255)">[Kawaii] '..(plr.Name)..'</font>'
	end
	if clients.ClientUsers[tostring(plr)] then
		nametag = '<font color="rgb(255, 255, 0)">['..clients.ClientUsers[tostring(plr)]..'] '..(plr.DisplayName or plr.Name)..'</font>'
	end
	if whitelisted.chattags[hash] then
		local data = whitelisted.chattags[hash]
		local newnametag = ""
		if data.Tags then
			for i2,v2 in pairs(data.Tags) do
				newnametag = newnametag..'<font color="rgb('..math.floor(v2.TagColor.r * 255)..', '..math.floor(v2.TagColor.g * 255)..', '..math.floor(v2.TagColor.b * 255)..')">['..v2.TagText..']</font> '
			end
		end
		nametag = newnametag..(newnametag.NameColor and '<font color="rgb('..math.floor(newnametag.NameColor.r * 255)..', '..math.floor(newnametag.NameColor.g * 255)..', '..math.floor(newnametag.NameColor.b * 255)..')">' or '')..(plr.DisplayName or plr.Name)..(newnametag.NameColor and '</font>' or '')
	end
	return nametag
end

local function Wings(char, texture)
	for i,v in pairs(char:GetDescendants()) do
		if v.Name == "Wings" then
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
	p.Name = "Wings"
	p.Anchored = false
	p.CanCollide = false
	p.TopSurface = 0
	p.BottomSurface = 0
	p.FormFactor = "Custom"
	p.Size = vec3(0.2,0.2,0.2)
	p.Transparency = 1
	local decal = Instance.new("Decal", p)
	decal.Texture = texture
	decal.Face = "Back"
	local msh = Instance.new("BlockMesh", p)
	msh.Scale = vec3(29,20.5,0.6)
	local motor = Instance.new("Motor", p)
	motor.Part0 = p
	motor.Part1 = torso
	motor.MaxVelocity = 0.01
	motor.C0 = cfnew(0,2,0) * CFrame.Angles(0,math.rad(90),0)
	motor.C1 = cfnew(0,1,0.45) * CFrame.Angles(0,math.rad(90),0)
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
	p.Size = vec3(0.2,0.2,0.2)
	p.Transparency = 1
	local decal = Instance.new("Decal", p)
	decal.Texture = texture
	decal.Face = "Back"
	local msh = Instance.new("BlockMesh", p)
	msh.Scale = vec3(9,17.5,0.5)
	local motor = Instance.new("Motor", p)
	motor.Part0 = p
	motor.Part1 = torso
	motor.MaxVelocity = 0.01
	motor.C0 = cfnew(0,2,0) * CFrame.Angles(0,math.rad(90),0)
	motor.C1 = cfnew(0,1,0.45) * CFrame.Angles(0,math.rad(90),0)
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

local function getSpeedMultiplier(reduce)
	local speed = 1
	if lplr.Character then 
		local speedboost = lplr.Character:GetAttribute("SpeedBoost")
		if speedboost and speedboost > 1 then 
			speed = speed + (speedboost - 1)
		end
		if lplr.Character:GetAttribute("GrimReaperChannel") then 
			speed = speed + 0.6
		end
		if lplr.Character:GetAttribute("SpeedPieBuff") then 
			speed = speed + (queueType == "SURVIVAL" and 0.15 or 0.3)
		end
		local armor = currentinventory.inventory.armor[3]
		if type(armor) ~= "table" then armor = {itemType = ""} end
		if armor.itemType == "speed_boots" then 
			speed = speed + 1
		end
	end
	return reduce and speed ~= 1 and speed * (0.9 - (0.15 * math.floor(speed))) or speed
end

local function renderNametag(plr)
	if (bedwars["CheckPlayerType"](plr) ~= "DEFAULT" or whitelisted.chattags[bedwars["HashFunction"](plr.Name..plr.UserId)]) then
		local playerlist = game:GetService("CoreGui"):FindFirstChild("PlayerList")
		if playerlist then
			pcall(function()
				local playerlistplayers = playerlist.PlayerListMaster.OffsetFrame.PlayerScrollList.SizeOffsetFrame.ScrollingFrameContainer.ScrollingFrameClippingFrame.ScollingFrame.OffsetUndoFrame
				local targetedplr = playerlistplayers:FindFirstChild("p_"..plr.UserId)
				if targetedplr then 
					targetedplr.ChildrenFrame.NameFrame.BGFrame.OverlayFrame.PlayerIcon.Image = getcustomassetfunc("vape/assets/VapeIcon.png")
				end
			end)
		end
		if lplr ~= plr and bedwars["CheckPlayerType"](lplr) == "DEFAULT" then
			task.spawn(function()
				repeat task.wait() until plr:GetAttribute("PlayerConnected")
				task.wait(4)
				repstorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer("/w "..plr.Name.." "..clients.ChatStrings2.vape, "All")
				task.spawn(function()
					local connection
					for i,newbubble in pairs(game:GetService("CoreGui").BubbleChat:GetDescendants()) do
						if newbubble:IsA("TextLabel") and newbubble.Text:find(clients.ChatStrings2.vape) then
							newbubble.Parent.Parent.Visible = false
							repeat task.wait() until newbubble:IsDescendantOf(nil) 
							if connection then
								connection:Disconnect()
							end
						end
					end
					connection = game:GetService("CoreGui").BubbleChat.DescendantAdded:connect(function(newbubble)
						if newbubble:IsA("TextLabel") and newbubble.Text:find(clients.ChatStrings2.vape) then
							newbubble.Parent.Parent.Visible = false
							repeat task.wait() until newbubble:IsDescendantOf(nil)
							if connection then
								connection:Disconnect()
							end
						end
					end)
				end)
				repstorage.DefaultChatSystemChatEvents.OnMessageDoneFiltering.OnClientEvent:Wait()
				task.wait(0.2)
				if getconnections then
					for i,v in pairs(getconnections(repstorage.DefaultChatSystemChatEvents.OnNewMessage.OnClientEvent)) do
						if v.Function and #debug.getupvalues(v.Function) > 0 and type(debug.getupvalues(v.Function)[1]) == "table" and getmetatable(debug.getupvalues(v.Function)[1]) and getmetatable(debug.getupvalues(v.Function)[1]).GetChannel then
							debug.getupvalues(v.Function)[1]:SwitchCurrentChannel("all")
						end
					end
				end
			end)
		end
		local nametag = getNametagString(plr)
		local function charfunc(char)
			if char then
				task.spawn(function()
					pcall(function() 
						bedwars["getEntityTable"]:getEntity(plr):setNametag(nametag)
						Cape(char, getcustomassetfunc("vape/assets/VapeCape.png"))
					end)
				end)
			end
		end

		--[[plr:GetPropertyChangedSignal("Team"):connect(function()
			task.delay(3, function()
				pcall(function()
					bedwars["getEntityTable"]:getEntity(plr):setNametag(nametag)
				end)
			end)
		end)]]

		charfunc(plr.Character)
		connectionstodisconnect[#connectionstodisconnect + 1] = plr.CharacterAdded:connect(charfunc)
	end
end

task.spawn(function()
	repeat task.wait() until whitelistsuc
	for i,v in pairs(players:GetChildren()) do renderNametag(v) end
	connectionstodisconnect[#connectionstodisconnect + 1] = players.PlayerAdded:connect(renderNametag)
end)

local function friendCheck(plr, recolor)
	if GuiLibrary["ObjectsThatCanBeSaved"]["Use FriendsToggle"]["Api"]["Enabled"] then
		local friend = (table.find(GuiLibrary["ObjectsThatCanBeSaved"]["FriendsListTextCircleList"]["Api"]["ObjectList"], plr.Name) and GuiLibrary["ObjectsThatCanBeSaved"]["FriendsListTextCircleList"]["Api"]["ObjectListEnabled"][table.find(GuiLibrary["ObjectsThatCanBeSaved"]["FriendsListTextCircleList"]["Api"]["ObjectList"], plr.Name)] and true or nil)
		if recolor then
			return (friend and GuiLibrary["ObjectsThatCanBeSaved"]["Recolor visualsToggle"]["Api"]["Enabled"] and true or nil)
		else
			return friend
		end
	end
	return nil
end

local function getPlayerColor(plr)
	return (friendCheck(plr, true) and Color3.fromHSV(GuiLibrary["ObjectsThatCanBeSaved"]["Friends ColorSliderColor"]["Api"]["Hue"], GuiLibrary["ObjectsThatCanBeSaved"]["Friends ColorSliderColor"]["Api"]["Sat"], GuiLibrary["ObjectsThatCanBeSaved"]["Friends ColorSliderColor"]["Api"]["Value"]) or tostring(plr.TeamColor) ~= "White" and plr.TeamColor.Color)
end

local function targetCheck(plr)
	return plr and plr.Humanoid and plr.Humanoid.Health > 0 and plr.Character:FindFirstChild("ForceField") == nil
end

do
	entity.selfDestruct()
	entity.isPlayerTargetable = function(plr)
		return lplr:GetAttribute("Team") ~= plr:GetAttribute("Team") and friendCheck(plr) == nil
	end
	entity.characterAdded = function(plr, char, localcheck)
        if char then
            task.spawn(function()
				local id = game:GetService("HttpService"):GenerateGUID(true)
                entity.entityIds[plr.Name] = id
                local humrootpart = char:WaitForChild("HumanoidRootPart", 10)
                local head = char:WaitForChild("Head", 10)
                local hum = char:WaitForChild("Humanoid", 10)
				if entity.entityIds[plr.Name] ~= id then return end
                if humrootpart and hum and head then
					local childremoved
                    local newent
                    if localcheck then
                        entity.isAlive = true
                        entity.character.Head = head
                        entity.character.Humanoid = hum
                        entity.character.HumanoidRootPart = humrootpart
                    else
						newent = {
                            Player = plr,
                            Character = char,
                            HumanoidRootPart = humrootpart,
                            RootPart = humrootpart,
                            Head = head,
                            Humanoid = hum,
                            Targetable = entity.isPlayerTargetable(plr),
                            Team = plr.Team,
                            Connections = {}
                        }
						local inv = char:WaitForChild("InventoryFolder", 5)
						if inv then 
							local armorobj1 = char:WaitForChild("ArmorInvItem_0", 5)
							local armorobj2 = char:WaitForChild("ArmorInvItem_1", 5)
							local armorobj3 = char:WaitForChild("ArmorInvItem_2", 5)
							local handobj = char:WaitForChild("HandInvItem", 5)
							if entity.entityIds[plr.Name] ~= id then return end
							if armorobj1 then
								table.insert(newent.Connections, armorobj1.Changed:connect(function() 
									task.delay(0.3, function() 
										inventories[plr] = bedwars["getInventory2"](plr) 
										entity.entityUpdatedEvent:Fire(newent)
									end)
								end))
							end
							if armorobj2 then
								table.insert(newent.Connections, armorobj2.Changed:connect(function() 
									task.delay(0.3, function() 
										inventories[plr] = bedwars["getInventory2"](plr) 
										entity.entityUpdatedEvent:Fire(newent)
									end)
								end))
							end
							if armorobj3 then
								table.insert(newent.Connections, armorobj3.Changed:connect(function() 
									task.delay(0.3, function() 
										inventories[plr] = bedwars["getInventory2"](plr) 
										entity.entityUpdatedEvent:Fire(newent)
									end)
								end))
							end
							if handobj then
								table.insert(newent.Connections, handobj.Changed:connect(function() 
									task.delay(0.3, function() 
										inventories[plr] = bedwars["getInventory2"](plr)
										entity.entityUpdatedEvent:Fire(newent)
									end)
								end))
							end
						end
						task.delay(0.3, function() 
							inventories[plr] = bedwars["getInventory2"](plr) 
							entity.entityUpdatedEvent:Fire(newent)
						end)
						table.insert(newent.Connections, hum:GetPropertyChangedSignal("Health"):connect(function() entity.entityUpdatedEvent:Fire(newent) end))
						table.insert(newent.Connections, hum:GetPropertyChangedSignal("MaxHealth"):connect(function() entity.entityUpdatedEvent:Fire(newent) end))
						table.insert(newent.Connections, char.AttributeChanged:connect(function(attr) if attr:find("Shield") then entity.entityUpdatedEvent:Fire(newent) end end))
                        table.insert(entity.entityList, newent)
						entity.entityAddedEvent:Fire(newent)
                    end
					childremoved = char.ChildRemoved:connect(function(part)
                        if part.Name == "HumanoidRootPart" or part.Name == "Head" or part.Name == "Humanoid" then
                            childremoved:Disconnect()
                            if localcheck then
                                if char == lplr.Character then
									if part.Name == "HumanoidRootPart" then
										entity.isAlive = false
										local root = char:FindFirstChild("HumanoidRootPart")
										if not root then 
											for i = 1, 30 do 
												task.wait(0.1)
												root = char:FindFirstChild("HumanoidRootPart")
												if root then break end
											end
										end
										if root then 
											entity.character.HumanoidRootPart = root
											entity.isAlive = true
										end
									else
										entity.isAlive = false
									end
								end
                            else
                                entity.removeEntity(plr)
                            end
                        end
                    end)
                    if newent then 
                        table.insert(newent.Connections, childremoved)
                    end
                    table.insert(entity.entityConnections, childremoved)
                end
            end)
        end
    end
	entity.entityAdded = function(plr, localcheck, custom)
       	table.insert(entity.entityConnections, plr.CharacterAdded:connect(function(char)
            entity.refreshEntity(plr, localcheck)
        end))
        table.insert(entity.entityConnections, plr.CharacterRemoving:connect(function(char)
            if localcheck then
                entity.isAlive = false
            else
                entity.removeEntity(plr)
            end
        end))
        table.insert(entity.entityConnections, plr:GetAttributeChangedSignal("Team"):connect(function()
            if localcheck then
                entity.fullEntityRefresh()
            else
				entity.refreshEntity(plr, localcheck)
				local entnum, newent = entity.getEntityFromPlayer(plr)
				if newent then entity.entityUpdatedEvent:Fire(newent) end
				if plr:GetAttribute("Team") == lplr:GetAttribute("Team") then 
					task.delay(3, function()
						entity.refreshEntity(plr, localcheck)
						entnum, newent = entity.getEntityFromPlayer(plr)
						if newent then entity.entityUpdatedEvent:Fire(newent) end
					end)
				end
            end
        end))
		task.spawn(function()
            if not plr.Character then
                for i = 1, 10 do 
                    task.wait(0.1)
                    if plr.Character then break end
                end
            end
            if plr.Character then
                entity.refreshEntity(plr, localcheck)
            end
        end)
    end
	entity.fullEntityRefresh()
end

local function switchItem(tool, legit)
	if legit then
		local hotbarslot = getHotbarSlot(tool.Name)
		if hotbarslot then 
			bedwars["ClientStoreHandler"]:dispatch({
				type = "InventorySelectHotbarSlot", 
				slot = hotbarslot
			})
		end
	end
	pcall(function()
		lplr.Character.HandInvItem.Value = tool
	end)
	bedwars["ClientHandler"]:Get(bedwars["EquipItemRemote"]):CallServerAsync({
		hand = tool
	})
end

local updateitem = Instance.new("BindableEvent")
runcode(function()
	local inputobj = nil
	local tempconnection
	tempconnection = uis.InputBegan:connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			inputobj = input
			tempconnection:Disconnect()
		end
	end)
	connectionstodisconnect[#connectionstodisconnect + 1] = updateitem.Event:connect(function(inputObj)
		if uis:IsMouseButtonPressed(0) then
			game:GetService("ContextActionService"):CallFunction("block-break", Enum.UserInputState.Begin, inputobj)
		end
	end)
end)

local function getBestTool(block)
    local tool = nil
	local blockmeta = bedwars["ItemTable"][block]
	local blockType = blockmeta["block"] and blockmeta["block"]["breakType"]
	if blockType then
		for i,v in pairs(currentinventory.inventory.items) do
			local meta = bedwars["ItemTable"][v.itemType]
			if meta["breakBlock"] and meta["breakBlock"][blockType] then
				tool = v
				break
			end
		end
	end
    return tool
end

local function switchToAndUseTool(block, legit)
	local tool = getBestTool(block.Name)
	if tool and (entity.isAlive and lplr.Character:FindFirstChild("HandInvItem") and lplr.Character.HandInvItem.Value ~= tool["tool"]) then
		if legit then
			if getHotbarSlot(tool.itemType) then
				bedwars["ClientStoreHandler"]:dispatch({
					type = "InventorySelectHotbarSlot", 
					slot = getHotbarSlot(tool.itemType)
				})
				task.wait(0.1)
				updateitem:Fire(inputobj)
				return true
			else
				return false
			end
		end
		switchItem(tool["tool"])
		task.wait(0.1)
	end
end

local normalsides = {}
for i,v in pairs(Enum.NormalId:GetEnumItems()) do if v.Name ~= "Bottom" then table.insert(normalsides, v) end end

local function isBlockCovered(pos)
	local coveredsides = 0
	for i, v in pairs(normalsides) do
		local blockpos = (pos + (Vector3.FromNormalId(v) * 3))
		local block = getblock(blockpos)
		if block then
			coveredsides = coveredsides + 1
		end
	end
	return coveredsides == #normalsides
end

local blacklistedblocks = {
	bed = true,
	ceramic = true
}
local function getallblocks(pos, normal)
	local blocks = {}
	local lastfound = nil
	for i = 1, 20 do
		local blockpos = (pos + (Vector3.FromNormalId(normal) * (i * 3)))
		local extrablock = getblock(blockpos)
		local covered = isBlockCovered(blockpos)
		if extrablock then
			if bedwars["BlockController"]:isBlockBreakable({blockPosition = blockpos}, lplr) and (not blacklistedblocks[extrablock.Name]) then
				table.insert(blocks, extrablock.Name)
			end
			lastfound = extrablock
			if not covered then
				break
			end
		else
			break
		end
	end
	return blocks
end

local function getlastblock(pos, normal)
	local lastfound, lastpos = nil, nil
	for i = 1, 20 do
		local blockpos = (pos + (Vector3.FromNormalId(normal) * (i * 3)))
		local extrablock, extrablockpos = getblock(blockpos)
		local covered = isBlockCovered(blockpos)
		if extrablock then
			lastfound, lastpos = extrablock, extrablockpos
			if not covered then
				break
			end
		else
			break
		end
	end
	return lastfound, lastpos
end

local healthbarblocktable = {
	["blockHealth"] = -1,
	["breakingBlockPosition"] = Vector3.zero
}
bedwars["breakBlock"] = function(pos, effects, normal, bypass)
    if lplr:GetAttribute("DenyBlockBreak") == true then
		return nil
	end
	local block, blockpos = nil, nil
	if not bypass then block, blockpos = getlastblock(pos, normal) end
	if not block then block, blockpos = getblock(pos) end
    if blockpos and block then
        if bedwars["BlockEngineClientEvents"].DamageBlock:fire(block.Name, blockpos, block):isCancelled() then
            return nil
        end
        local blockhealthbarpos = {blockPosition = Vector3.zero}
        local blockdmg = 0
        if block and block.Parent ~= nil then
            switchToAndUseTool(block)
            blockhealthbarpos = {
                blockPosition = blockpos
            }
            if healthbarblocktable.blockHealth == -1 or blockhealthbarpos.blockPosition ~= healthbarblocktable.breakingBlockPosition then
				local blockdata = bedwars["BlockController"]:getStore():getBlockData(blockhealthbarpos.blockPosition)
				if not blockdata then
					return nil
				end
				local blockhealth = blockdata:GetAttribute(lplr.Name .. "_Health")
				if blockhealth == nil then
					blockhealth = block:GetAttribute("Health")
				end
				healthbarblocktable.blockHealth = blockhealth
				healthbarblocktable.breakingBlockPosition = blockhealthbarpos.blockPosition
			end
            blockdmg = bedwars["BlockController"]:calculateBlockDamage(lplr, blockhealthbarpos)
            bedwars["ClientHandlerDamageBlock"]:Get("DamageBlock"):CallServerAsync({
                blockRef = blockhealthbarpos, 
                hitPosition = blockpos * 3, 
                hitNormal = Vector3.FromNormalId(normal)
            }):andThen(function(result)
				if result ~= "failed" then
					healthbarblocktable.blockHealth = math.max(healthbarblocktable.blockHealth - blockdmg, 0)
					if effects then
						bedwars["BlockBreaker"]:updateHealthbar(blockhealthbarpos, healthbarblocktable.blockHealth, block:GetAttribute("MaxHealth"), blockdmg)
						if healthbarblocktable.blockHealth <= 0 then
							bedwars["BlockBreaker"].breakEffect:playBreak(block.Name, blockhealthbarpos.blockPosition, lplr)
							bedwars["BlockBreaker"].healthbarMaid:DoCleaning()
							healthbarblocktable.breakingBlockPosition = Vector3.zero
						else
							bedwars["BlockBreaker"].breakEffect:playHit(block.Name, blockhealthbarpos.blockPosition, lplr)
						end
					end
				end
			end)
        end
    end
end	

local function getEquipped()
	local typetext = ""
	local obj = currentinventory.inventory.hand
	if obj then
		local metatab = bedwars["ItemTable"][obj.itemType]
		typetext = metatab.sword and "sword" or metatab.block and "block" or obj.itemType:find("bow") and "bow"
	end
    return {["Object"] = obj and obj.tool, ["Type"] = typetext}
end

local function GetAllNearestHumanoidToPosition(player, distance, amount, targetcheck, overridepos, sortfunc)
	local returnedplayer = {}
	local currentamount = 0
    if entity.isAlive then -- alive check
        for i, v in pairs(entity.entityList) do -- loop through players
            if (v.Targetable or targetcheck) and targetCheck(v) then -- checks
                local mag = (entity.character.HumanoidRootPart.Position - v.RootPart.Position).magnitude
				if overridepos and mag > distance then 
					mag = (overridepos - v.RootPart.Position).magnitude
				end
                if mag <= distance then -- mag check
                    table.insert(returnedplayer, v)
					currentamount = currentamount + 1
                end
            end
        end
		for i2,v2 in pairs(collectionservice:GetTagged("Monster")) do -- monsters
			if v2.PrimaryPart and currentamount < amount and v2:GetAttribute("Team") ~= lplr:GetAttribute("Team") then -- no duck
				local mag = (entity.character.HumanoidRootPart.Position - v2.PrimaryPart.Position).magnitude
				if overridepos and mag > distance then 
					mag = (overridepos - v2.PrimaryPart.Position).magnitude
				end
                if mag <= distance then -- magcheck
                    table.insert(returnedplayer, {Player = {Name = (v2 and v2.Name or "Monster"), UserId = (v2 and v2.Name == "Duck" and 2020831224 or 1443379645)}, Character = v2, RootPart = v2.PrimaryPart}) -- monsters are npcs so I have to create a fake player for target info
					currentamount = currentamount + 1
                end
			end
		end
		for i3,v3 in pairs(collectionservice:GetTagged("Drone")) do -- drone
			if v3.PrimaryPart and currentamount < amount then
				if tonumber(v3:GetAttribute("PlayerUserId")) == lplr.UserId then continue end
				local droneplr = players:GetPlayerByUserId(v3:GetAttribute("PlayerUserId"))
				if droneplr and droneplr.Team == lplr.Team then continue end
				local mag = (entity.character.HumanoidRootPart.Position - v3.PrimaryPart.Position).magnitude
				if overridepos and mag > distance then 
					mag = (overridepos - v3.PrimaryPart.Position).magnitude
				end
                if mag <= distance then -- magcheck
                    table.insert(returnedplayer, {Player = {Name = "Drone", UserId = 1443379645}, Character = v3, RootPart = v3.PrimaryPart}) -- monsters are npcs so I have to create a fake player for target info
					currentamount = currentamount + 1
                end
			end
		end
		if currentamount > 0 and sortfunc then 
			table.sort(returnedplayer, sortfunc)
			returnedplayer = {returnedplayer[1]}
		end
	end
	return returnedplayer -- table of attackable entities
end

GetNearestHumanoidToMouse = function(player, distance, checkvis)
	local closest, returnedplayer = distance, nil
	if entity.isAlive then
		for i, v in pairs(entity.entityList) do
			if v.Targetable then
				local vec, vis = cam:WorldToScreenPoint(v.RootPart.Position)
				if vis and targetCheck(v) then
					local mag = (uis:GetMouseLocation() - Vector2.new(vec.X, vec.Y)).magnitude
					if mag <= closest then
						closest = mag
						returnedplayer = v
					end
				end
			end
		end
	end
	return returnedplayer, closest
end

local function GetNearestHumanoidToPosition(player, distance, overridepos)
	local closest, returnedplayer = distance, nil
    if entity.isAlive then
        for i, v in pairs(entity.entityList) do
			if v.Targetable and targetCheck(v) then
				local mag = (entity.character.HumanoidRootPart.Position - v.RootPart.Position).magnitude
				if overridepos and mag > distance then 
					mag = (overridepos - v.RootPart.Position).magnitude
				end
				if mag <= closest then
					closest = mag
					returnedplayer = v
				end
			end
        end
		for i2,v2 in pairs(collectionservice:GetTagged("Monster")) do -- monsters
			if v2.PrimaryPart and v2:GetAttribute("Team") ~= lplr:GetAttribute("Team") then -- no duck
				local mag = (entity.character.HumanoidRootPart.Position - v2.PrimaryPart.Position).magnitude
				if overridepos and mag > distance then 
					mag = (overridepos - v2.PrimaryPart.Position).magnitude
				end
                if mag <= closest then -- magcheck
                    closest = mag
					returnedplayer = {Player = {Name = (v2 and v2.Name or "Monster"), UserId = (v2 and v2.Name == "Duck" and 2020831224 or 1443379645)}, Character = v2, RootPart = v2.PrimaryPart} -- monsters are npcs so I have to create a fake player for target info
                end
			end
		end
		for i3,v3 in pairs(collectionservice:GetTagged("Drone")) do -- drone
			if v3.PrimaryPart then
				if tonumber(v3:GetAttribute("PlayerUserId")) == lplr.UserId then continue end
				local droneplr = players:GetPlayerByUserId(v3:GetAttribute("PlayerUserId"))
				if droneplr and droneplr.Team == lplr.Team then continue end
				local mag = (entity.character.HumanoidRootPart.Position - v3.PrimaryPart.Position).magnitude
				if overridepos and mag > distance then 
					mag = (overridepos - v3.PrimaryPart.Position).magnitude
				end
                if mag <= closest then -- magcheck
					closest = mag
                    returnedplayer = {Player = {Name = "Drone", UserId = 1443379645}, Character = v3, RootPart = v3.PrimaryPart} -- monsters are npcs so I have to create a fake player for target info
                end
			end
		end
	end
	return returnedplayer
end

runcode(function()
	local handsquare = Instance.new("ImageLabel")
	handsquare.Size = UDim2.new(0, 26, 0, 27)
	handsquare.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
	handsquare.Position = UDim2.new(0, 72, 0, 39)
	handsquare.Parent = targetinfo["Object"].GetCustomChildren().Frame.MainInfo
	local handround = Instance.new("UICorner")
	handround.CornerRadius = UDim.new(0, 4)
	handround.Parent = handsquare
	local helmetsquare = handsquare:Clone()
	helmetsquare.Position = UDim2.new(0, 100, 0, 39)
	helmetsquare.Parent = targetinfo["Object"].GetCustomChildren().Frame.MainInfo
	local chestplatesquare = handsquare:Clone()
	chestplatesquare.Position = UDim2.new(0, 127, 0, 39)
	chestplatesquare.Parent = targetinfo["Object"].GetCustomChildren().Frame.MainInfo
	local bootssquare = handsquare:Clone()
	bootssquare.Position = UDim2.new(0, 155, 0, 39)
	bootssquare.Parent = targetinfo["Object"].GetCustomChildren().Frame.MainInfo
	local uselesssquare = handsquare:Clone()
	uselesssquare.Position = UDim2.new(0, 182, 0, 39)
	uselesssquare.Parent = targetinfo["Object"].GetCustomChildren().Frame.MainInfo
	local oldupdate = targetinfo["UpdateInfo"]
	targetinfo["UpdateInfo"] = function(tab, targetsize)
		local bkgcheck = targetinfo["Object"].GetCustomChildren().Frame.MainInfo.BackgroundTransparency == 1
		handsquare.BackgroundTransparency = bkgcheck and 1 or 0
		helmetsquare.BackgroundTransparency = bkgcheck and 1 or 0
		chestplatesquare.BackgroundTransparency = bkgcheck and 1 or 0
		bootssquare.BackgroundTransparency = bkgcheck and 1 or 0
		uselesssquare.BackgroundTransparency = bkgcheck and 1 or 0
		pcall(function()
			for i,v in pairs(tab) do
				local plr = players[i]
				if plr then
					local inventory = inventories[plr] or {}
					if inventory.hand then
						handsquare.Image = bedwars["getIcon"](inventory.hand, true)
					else
						handsquare.Image = ""
					end
					if inventory.armor[4] then
						helmetsquare.Image = bedwars["getIcon"](inventory.armor[4], true)
					else
						helmetsquare.Image = ""
					end
					if inventory.armor[5] then
						chestplatesquare.Image = bedwars["getIcon"](inventory.armor[5], true)
					else
						chestplatesquare.Image = ""
					end
					if inventory.armor[6] then
						bootssquare.Image = bedwars["getIcon"](inventory.armor[6], true)
					else
						bootssquare.Image = ""
					end
				end
			end
		end)
		return oldupdate(tab, targetsize)
	end
end)

local function getBow()
	local bestsword, bestswordslot, bestswordnum = nil, nil, 0
	for i5, v5 in pairs(currentinventory.inventory.items) do
		if v5.itemType:find("bow") then 
			local tab = bedwars["ItemTable"][v5.itemType].projectileSource
			local tab2 = tab.projectileType(tab.ammoItemTypes[#tab.ammoItemTypes])	
			local dmg = bedwars["ProjectileMeta"][tab2].combat.damage
			if dmg > bestswordnum then
				bestswordnum = dmg
				bestswordslot = i5
				bestsword = v5
			end
		end
	end
	return bestsword, bestswordslot
end

local function getCustomItem(v2)
	local realitem = v2.itemType
	if realitem == "swords" then
		realitem = getSword() and getSword().itemType or "wood_sword"
	elseif realitem == "pickaxes" then
		realitem = getPickaxe() and getPickaxe().itemType or "wood_pickaxe"
	elseif realitem == "axes" then
		realitem = getAxe() and getAxe().itemType or "wood_axe"
	elseif realitem == "bows" then
		realitem = getBow() and getBow().itemType or "wood_bow"
	elseif realitem == "wool" then
		realitem = getwool() or "wool_white"
	end
	return realitem
end

local function findItemInTable(tab, item)
	for i,v in pairs(tab) do
		if v.itemType then
			local gottenitem, gottenitemnum = getItem(getCustomItem(v))
			if gottenitem and gottenitem.itemType == item.itemType then
				return i
			end
		end
	end
	return nil
end

runcode(function()
	local AutoHotbarList = {["Hotbars"] = {}, ["CurrentlySelected"] = 1}
	local AutoHotbarMode = {["Value"] = "Toggle"}
	local AutoHotbar = {["Enabled"] = false}
	local AutoHotbarConnection

	local function findinhotbar(item)
		for i,v in pairs(currentinventory.hotbar) do
			if v.item and v.item.itemType == getCustomItem(item) then
				return i, v.item
			end
		end
	end

	local function findininventory(item)
		for i,v in pairs(currentinventory.inventory.items) do
			if v.itemType == item.itemType then
				return v
			end
		end
	end

	local function AutoHotbarSort()
		task.spawn(function()
			task.wait(0.2)
			local items = (AutoHotbarList["Hotbars"][AutoHotbarList["CurrentlySelected"]] and AutoHotbarList["Hotbars"][AutoHotbarList["CurrentlySelected"]]["Items"] or {})
			for i,v in pairs(currentinventory.inventory.items) do 
				local hotbarslot = findItemInTable(items, v)
				if hotbarslot then
					local oldhotbaritem = currentinventory.hotbar[tonumber(hotbarslot)]
					local newhotbaritemslot, newhotbaritem = findinhotbar(v)
					if oldhotbaritem.item and oldhotbaritem.item.itemType == v.itemType then continue end
					if oldhotbaritem.item then 
						bedwars["ClientStoreHandler"]:dispatch({
							type = "InventoryRemoveFromHotbar", 
							slot = tonumber(hotbarslot) - 1
						})
					end
					if newhotbaritemslot then 
						bedwars["ClientStoreHandler"]:dispatch({
							type = "InventoryRemoveFromHotbar", 
							slot = newhotbaritemslot - 1
						})
					end
					if oldhotbaritem.item then 
						local nextitem1, nextitem1num = findininventory(oldhotbaritem.item)
						bedwars["ClientStoreHandler"]:dispatch({
							type = "InventoryAddToHotbar", 
							item = nextitem1, 
							slot = newhotbaritemslot - 1
						})
					end
					local nextitem2, nextitem2num = findininventory(v)
					bedwars["ClientStoreHandler"]:dispatch({
						type = "InventoryAddToHotbar", 
						item = nextitem2, 
						slot = tonumber(hotbarslot) - 1
					})
				end
			end
		end)
	end

	AutoHotbar = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
		["Name"] = "AutoHotbar",
		["Function"] = function(callback) 
			if callback then
				AutoHotbarSort()
				if AutoHotbarMode["Value"] == "On Key" then
					if AutoHotbar["Enabled"] then 
						AutoHotbar["ToggleButton"](false)
					end
				else
					AutoHotbarConnection = repstorage.Inventories.DescendantAdded:connect(function(p3)
						if p3.Parent.Name == lplr.Name then
							local items = (AutoHotbarList["Hotbars"][AutoHotbarList["CurrentlySelected"]] and AutoHotbarList["Hotbars"][AutoHotbarList["CurrentlySelected"]]["Items"] or {})
							local hotbarslot = findItemInTable(items, {itemType = p3.Name})
							if hotbarslot then
								AutoHotbarSort(hotbarslot, p3.Name)
							end
						end
					end)
				end
			else
				if AutoHotbarConnection then
					AutoHotbarConnection:Disconnect()
				end
			end
		end,
		["HoverText"] = "Automatically arranges hotbar to your liking."
	})
	AutoHotbarMode = AutoHotbar.CreateDropdown({
		["Name"] = "Activation",
		["List"] = {"On Key", "Toggle"},
		["Function"] = function(val)
			if AutoHotbar["Enabled"] then
				AutoHotbar["ToggleButton"](false)
				AutoHotbar["ToggleButton"](false)
			end
		end
	})
	AutoHotbarList = CreateAutoHotbarGUI(AutoHotbar["Children"], {
		["Name"] = "lol"
	})
end)

runcode(function()
	local Sprint = {["Enabled"] = false}
	Sprint = GuiLibrary["ObjectsThatCanBeSaved"]["CombatWindow"]["Api"].CreateOptionsButton({
		["Name"] = "Sprint",
		["Function"] = function(callback)
			if callback then
				task.spawn(function()
					repeat
						task.wait()
						if (not Sprint["Enabled"]) then break end
						if (not bedwars["sprintTable"].sprinting) then
							bedwars["sprintTable"]:startSprinting()
						end
					until (not Sprint["Enabled"])
				end)
			else
				bedwars["sprintTable"]:stopSprinting()
			end
		end,
		["HoverText"] = "Sets your sprinting to true."
	})
	
	local FieldOfViewValue = {["Value"] = 70}
	local oldfov
	local oldfov2
	local FieldOfView = {["Enabled"] = false}
	local FieldOfViewZoom = {["Enabled"] = false}
	FieldOfView = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
		["Name"] = "FOVChanger",
		["Function"] = function(callback)
			if callback then
				if FieldOfViewZoom["Enabled"] then
					task.spawn(function()
						repeat
							task.wait()
						until uis:IsKeyDown(Enum.KeyCode[FieldOfView["Keybind"] ~= "" and FieldOfView["Keybind"] or "C"]) == false
						if FieldOfView["Enabled"] then
							FieldOfView["ToggleButton"](false)
						end
					end)
				end
				oldfov = bedwars["FovController"]["setFOV"]
				oldfov2 = bedwars["FovController"]["getFOV"]
				bedwars["FovController"]["setFOV"] = function(self, fov)
					return oldfov(self, FieldOfViewValue["Value"])
				end
				bedwars["FovController"]["getFOV"] = function(self, fov)
					return oldfov2(self, FieldOfViewValue["Value"])
				end
			else
				bedwars["FovController"]["setFOV"] = oldfov
				bedwars["FovController"]["getFOV"] = oldfov2
			end
			bedwars["FovController"]:setFOV(bedwars["ClientStoreHandler"]:getState().Settings.fov)
		end
	})
	FieldOfViewValue = FieldOfView.CreateSlider({
		["Name"] = "FOV",
		["Min"] = 30,
		["Max"] = 120,
		["Function"] = function(val)
			if FieldOfView["Enabled"] then
				cam.FieldOfView = val * (bedwars["sprintTable"].sprinting and 1.1 or 1)
			end
		end
	})
	FieldOfViewZoom = FieldOfView.CreateToggle({
		["Name"] = "Zoom",
		["Function"] = function() end,
		["HoverText"] = "optifine zoom lol"
	})
end)

local lagbackedaftertouch = false
runcode(function()
	local antivoidpart
	local antivoidconnection
	local antitransparent = {["Value"] = 50}
	local anticolor = {["Hue"] = 1, ["Sat"] = 1, ["Value"] = 0.55}
	local AntiVoid = {["Enabled"] = false}
	local lastvalidpos

	local function closestpos(block)
		local startpos = block.Position - (block.Size / 2) + vec3(1.5, 1.5, 1.5)
		local endpos = block.Position + (block.Size / 2) - vec3(1.5, 1.5, 1.5)
		local newpos = block.Position + (entity.character.HumanoidRootPart.Position - block.Position)
		return vec3(math.clamp(newpos.X, startpos.X, endpos.X), endpos.Y + 3, math.clamp(newpos.Z, startpos.Z, endpos.Z))
	end

	local function getclosesttop(newmag)
		local closest, closestmag = nil, newmag * 3
		if entity.isAlive then 
			local tops = {}
			for i,v in pairs(bedwarsblocks) do 
				local close = getScaffold(closestpos(v), false)
				if getblock(close) then continue end
				if (close - entity.character.HumanoidRootPart.Position).magnitude <= newmag * 3 then 
					table.insert(tops, close)
				end
			end
			for i,v in pairs(tops) do 
				local mag = (v - entity.character.HumanoidRootPart.Position).magnitude
				if mag <= closestmag then 
					closest = v
					closestmag = mag
				end
			end
		end
		return closest
	end

	local function isPointInMapOccupied(p)
		local region = Region3.new(p - vec3(1, 1, 1), p + vec3(1, 1, 1))
		local possible = workspace:FindPartsInRegion3WithWhiteList(region, bedwarsblocks)
		return (#possible == 0)
	end

runcode(function()
	local oldenable2
	local olddisable2
	local oldhitblock
	local blockplacetable2 = {}
	local blockplaceenabled2 = false

	local AutoTool = GuiLibrary["ObjectsThatCanBeSaved"]["WorldWindow"]["Api"].CreateOptionsButton({
		["Name"] = "AutoTool",
		["Function"] = function(callback)
			if callback then
				oldenable2 = bedwars["BlockBreaker"]["enable"]
				olddisable2 = bedwars["BlockBreaker"]["disable"]
				oldhitblock = bedwars["BlockBreaker"]["hitBlock"]
				bedwars["BlockBreaker"]["enable"] = function(Self, tab)
					blockplaceenabled2 = true
					blockplacetable2 = Self
					return oldenable2(Self, tab)
				end
				bedwars["BlockBreaker"]["disable"] = function(Self)
					blockplaceenabled2 = false
					return olddisable2(Self)
				end
				bedwars["BlockBreaker"]["hitBlock"] = function(...)
					if entity.isAlive and (GuiLibrary["ObjectsThatCanBeSaved"]["Lobby CheckToggle"]["Api"]["Enabled"] == false or matchState ~= 0) and blockplaceenabled2 then
						local mouseinfo = blockplacetable2.clientManager:getBlockSelector():getMouseInfo(0)
						if mouseinfo and mouseinfo.target then
							if switchToAndUseTool(mouseinfo.target.blockInstance, true) then
								return
							end
						end
					end
					return oldhitblock(...)
				end
			else
				RunLoops:UnbindFromRenderStep("AutoTool")
				bedwars["BlockBreaker"]["enable"] = oldenable2
				bedwars["BlockBreaker"]["disable"] = olddisable2
				bedwars["BlockBreaker"]["hitBlock"] = oldhitblock
				oldenable2 = nil
				olddisable2 = nil
				oldhitblock = nil
			end
		end,
		["HoverText"] = "Automatically swaps your hand to the appropriate tool."
	})
end)

local function getbestside(pos)
	local softest, softestside = 9e9, Enum.NormalId.Top
	for i,v in pairs(normalsides) do
		local sidehardness = 0
		for i2,v2 in pairs(getallblocks(pos, v)) do	
			local blockmeta = bedwars["ItemTable"][v2]["block"]
			sidehardness = sidehardness + (blockmeta and blockmeta.health or 10)
            if blockmeta then
                local tool = getBestTool(v2)
                if tool then
                    sidehardness = sidehardness - bedwars["ItemTable"][tool.itemType]["breakBlock"][blockmeta.breakType]
                end
            end
		end
		if sidehardness <= softest then
			softest = sidehardness
			softestside = v
		end
	end
	return softestside, softest
end

runcode(function()
	local OpenEnderchest = {["Enabled"] = false}
	OpenEnderchest = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
		["Name"] = "OpenEnderchest",
		["Function"] = function(callback)
			if callback then
				local echest = repstorage.Inventories:FindFirstChild(lplr.Name.."_personal")
				if echest then
					bedwars["AppController"]:openApp("ChestApp", {})
					bedwars["ChestController"]:openChest(echest)
				else
					createwarning("OpenEnderchest", "Enderchest not found", 5)
				end
				OpenEnderchest["ToggleButton"](false)
			end
		end,
		["HoverText"] = "Opens the enderchest"
	})
end)

runcode(function()
	local ChestESPList = {["ObjectList"] = {}, ["RefreshList"] = function() end}
	local function nearchestitem(item)
		for i,v in pairs(ChestESPList["ObjectList"]) do 
			if item:find(v) then return v end
		end
	end
	local function refreshAdornee(v)
		local chest = v.Adornee.ChestFolderValue.Value
        local chestitems = chest and chest:GetChildren() or {}
		for i2,v2 in pairs(v.Frame:GetChildren()) do
			if v2:IsA("ImageLabel") then
				v2:Remove()
			end
		end
		v.Enabled = false
		local alreadygot = {}
		for i3,v3 in pairs(chestitems) do
			if table.find(ChestESPList["ObjectList"], v3.Name) or nearchestitem(v3.Name) and alreadygot[v3.Name] == nil then 
				alreadygot[v3.Name] = true
				v.Enabled = true
                local blockimage = Instance.new("ImageLabel")
                blockimage.Size = UDim2.new(0, 32, 0, 32)
                blockimage.BackgroundTransparency = 1
                blockimage.Image = bedwars["getIcon"]({itemType = v3.Name}, true)
                blockimage.Parent = v.Frame
            end
		end
	end

	local ChestESPFolder = Instance.new("Folder")
	ChestESPFolder.Name = "ChestESPFolder"
	ChestESPFolder.Parent = GuiLibrary["MainGui"]
	local ChestESP = {["Enabled"] = false}
    local chestconnections = {}
	ChestESP = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
		["Name"] = "ChestESP",
		["Function"] = function(callback)
			if callback then
				task.spawn(function()

					local function chestfunc(v)
						task.spawn(function()
							local billboard = Instance.new("BillboardGui")
							billboard.Parent = ChestESPFolder
							billboard.Name = "chest"
							billboard.StudsOffsetWorldSpace = vec3(0, 3, 1.5)
							billboard.Size = UDim2.new(0, 42, 0, 42)
							billboard.AlwaysOnTop = true
							billboard.Adornee = v
							local frame = Instance.new("Frame")
							frame.Size = UDim2.new(1, 0, 1, 0)
							frame.BackgroundColor3 = Color3.new(0, 0, 0)
							frame.BackgroundTransparency = 0.5
							frame.Parent = billboard
							local uilistlayout = Instance.new("UIListLayout")
							uilistlayout.FillDirection = Enum.FillDirection.Horizontal
							uilistlayout.Padding = UDim.new(0, 4)
							uilistlayout.VerticalAlignment = Enum.VerticalAlignment.Center
							uilistlayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
							uilistlayout:GetPropertyChangedSignal("AbsoluteContentSize"):connect(function()
								billboard.Size = UDim2.new(0, math.max(uilistlayout.AbsoluteContentSize.X + 12, 42), 0, 42)
							end)
							uilistlayout.Parent = frame
							local uicorner = Instance.new("UICorner")
							uicorner.CornerRadius = UDim.new(0, 4)
							uicorner.Parent = frame
							local chest = v:WaitForChild("ChestFolderValue").Value
							if chest then 
								chestconnections[#chestconnections + 1] = chest.ChildAdded:connect(function(item)
									if table.find(ChestESPList["ObjectList"], item.Name) or nearchestitem(item.Name) then 
										refreshAdornee(billboard)
									end
								end)
								chestconnections[#chestconnections + 1] = chest.ChildRemoved:connect(function(item)
									if table.find(ChestESPList["ObjectList"], item.Name) or nearchestitem(item.Name) then 
										refreshAdornee(billboard)
									end
								end)
								refreshAdornee(billboard)
							end
						end)
					end

					chestconnections[#chestconnections + 1] = collectionservice:GetInstanceAddedSignal("chest"):connect(chestfunc)
					for i,v in pairs(collectionservice:GetTagged("chest")) do chestfunc(v) end
				end)
			else
				ChestESPFolder:ClearAllChildren()
                for i,v in pairs(chestconnections) do 
                    v:Disconnect()
                end
			end
		end
	})
	ChestESPList = ChestESP.CreateTextList({
		["Name"] = "ItemList",
		["TempText"] = "item or part of item",
		["AddFunction"] = function()
			if ChestESP["Enabled"] then 
				ChestESP["ToggleButton"](false)
				ChestESP["ToggleButton"](false)
			end
		end,
		["RemoveFunction"] = function()
			if ChestESP["Enabled"] then 
				ChestESP["ToggleButton"](false)
				ChestESP["ToggleButton"](false)
			end
		end
	})
end)

local autobankapple = false
local autobankballoon = false
local autobankballoonevent = Instance.new("BindableEvent")
runcode(function()
	local AutoBuy = {["Enabled"] = false}
	local AutoBuyArmor = {["Enabled"] = false}
	local AutoBuySword = {["Enabled"] = false}
	local AutoBuyUpgrades = {["Enabled"] = false}
	local AutoBuyGen = {["Enabled"] = false}
	local AutoBuyProt = {["Enabled"] = false}
	local AutoBuySharp = {["Enabled"] = false}
	local AutoBuyBreakSpeed = {["Enabled"] = false}
	local AutoBuyAlarm = {["Enabled"] = false}
    local AutoBuyArmory = {["Enabled"] = false}
    local AutoBuyBrewingStand = {["Enabled"] = false}
	local AutoBuyGui = {["Enabled"] = false}
	local AutoBuyTierSkip = {["Enabled"] = true}
	local AutoBuyRange = {["Value"] = 20}
	local AutoBuyCustom = {["ObjectList"] = {}, ["RefreshList"] = function() end}
	local buyingthing = false
	local shoothook
	local bedwarsshopnpcs = {}
	local shopnpcconnection
	task.spawn(function()
		repeat task.wait() until matchState ~= 0
		for i,v in pairs(collectionservice:GetTagged("BedwarsItemShop")) do
			table.insert(bedwarsshopnpcs, {["Position"] = v.Position, ["TeamUpgradeNPC"] = true})
		end
		for i,v in pairs(collectionservice:GetTagged("BedwarsTeamUpgrader")) do
			table.insert(bedwarsshopnpcs, {["Position"] = v.Position, ["TeamUpgradeNPC"] = false})
		end
	end)

	local function nearNPC(range)
		local npc, npccheck, enchant = nil, false, false
		if entity.isAlive then
			local enchanttab = {unpack(collectionservice:GetTagged("broken-enchant-table")), unpack(collectionservice:GetTagged("enchant-table")), unpack(collectionservice:GetTagged("VoidPortal"))}
			for i,v in pairs(enchanttab) do 
				if (entity.character.HumanoidRootPart.Position - v.Position).magnitude <= 6 and ((not v:GetAttribute("Team")) or v:GetAttribute("Team") == lplr:GetAttribute("Team")) then
					npc, npccheck, enchant = true, true, true
				end
			end
			for i, v in pairs(bedwarsshopnpcs) do
				if (entity.character.HumanoidRootPart.Position - v.Position).magnitude <= (range or 20) then
					npc, npccheck, enchant = true, (v.TeamUpgradeNPC or npccheck), false
				end
			end
		end
		return npc, not npccheck, enchant
	end

	local function getShopItem(itemType)
		for i,v in pairs(bedwars["ShopItems"]) do 
			if v.itemType == itemType then return v end
		end
		return nil
	end

	local function buyItem(itemtab, waitdelay)
		local res
		bedwars["ClientHandler"]:Get("BedwarsPurchaseItem"):CallServerAsync({
			shopItem = itemtab
		}):andThen(function(p11)
			if p11 then
				bedwars["SoundManager"]:playSound(bedwars["SoundList"].BEDWARS_PURCHASE_ITEM)
				bedwars["ClientStoreHandler"]:dispatch({
					type = "BedwarsAddItemPurchased", 
					itemType = itemtab.itemType
				})
			end
			res = p11
		end)
		if waitdelay then 
			repeat task.wait() until res ~= nil
		end
	end

	local function buyUpgrade(upgradetype, inv, upgrades)
		local teamupgrade = bedwars["Shop"].getUpgrade(bedwars["Shop"]["TeamUpgrades"], upgradetype)
		local teamtier = teamupgrade["tiers"][upgrades[upgradetype] and upgrades[upgradetype] + 2 or 1]
		if teamtier then 
			local teamcurrency = getItem(teamtier["currency"], inv.items)
			if teamcurrency and teamcurrency["amount"] >= teamtier.price then 
				bedwars["ClientHandler"]:Get("BedwarsPurchaseTeamUpgrade"):CallServerAsync({
					upgradeId = upgradetype, 
					tier = upgrades[upgradetype] and upgrades[upgradetype] + 1 or 0
				}):andThen(function(suc)
					if suc then
						bedwars["SoundManager"]:playSound(bedwars["SoundList"].BEDWARS_PURCHASE_ITEM)
					end
				end)
			end
		end
	end
	
	local armors = {
		[1] = "leather_chestplate",
		[2] = "iron_chestplate",
		[3] = "diamond_chestplate",
		[4] = "emerald_chestplate"
	}

	local swords = {
		[1] = "wood_sword",
		[2] = "stone_sword",
		[3] = "iron_sword",
		[4] = "diamond_sword",
		[5] = "emerald_sword"
	}

	local buyfunctions = {
		Armor = function(inv, upgrades, shoptype) 
			if AutoBuyArmor["Enabled"] == false or shoptype ~= "item" then return end
			local currentarmor = (inv.armor[2] ~= "empty" and inv.armor[2].itemType:find("chestplate") ~= nil) and inv.armor[2] or nil
			local armorindex = (currentarmor and table.find(armors, currentarmor.itemType) or 0) + 1
			if armors[armorindex] == nil then return end
			local highestbuyable = nil
			for i = armorindex, #armors, 1 do 
				local shopitem = getShopItem(armors[i])
				if shopitem and (AutoBuyTierSkip["Enabled"] or i == armorindex) then 
					local currency = getItem(shopitem.currency, inv.items)
					if currency and currency["amount"] >= shopitem.price then 
						highestbuyable = shopitem
						bedwars["ClientStoreHandler"]:dispatch({
							type = "BedwarsAddItemPurchased", 
							itemType = shopitem.itemType
						})
					end
				end
			end
			if highestbuyable and (highestbuyable.ignoredByKit == nil or table.find(highestbuyable.ignoredByKit, kit) == nil) then 
				buyItem(highestbuyable)
			end
		end,
		Sword = function(inv, upgrades, shoptype)
			if AutoBuySword["Enabled"] == false or shoptype ~= "item" then return end
			local currentsword = getItemNear("sword", inv.items)
			local swordindex = (currentsword and table.find(swords, currentsword.itemType) or 0) + 1
			if currentsword ~= nil and table.find(swords, currentsword.itemType) == nil then return end
			local highestbuyable = nil
			for i = swordindex, #swords, 1 do 
				local shopitem = getShopItem(swords[i])
				if shopitem then 
					local currency = getItem(shopitem.currency, inv.items)
					if currency and currency["amount"] >= shopitem.price and (shopitem.category ~= "Armory" or upgrades["armory"]) then 
						highestbuyable = shopitem
						bedwars["ClientStoreHandler"]:dispatch({
							type = "BedwarsAddItemPurchased", 
							itemType = shopitem.itemType
						})
					end
				end
			end
			if highestbuyable and (highestbuyable.ignoredByKit == nil or table.find(highestbuyable.ignoredByKit, kit) == nil) then 
				buyItem(highestbuyable)
			end
		end,
		Protection = function(inv, upgrades)
			if not AutoBuyProt["Enabled"] then return end
			buyUpgrade("armor", inv, upgrades)
		end,
		Sharpness = function(inv, upgrades)
			if not AutoBuySharp["Enabled"] then return end
			buyUpgrade("damage", inv, upgrades)
		end,
		Generator = function(inv, upgrades)
			if not AutoBuyGen["Enabled"] then return end
			buyUpgrade("generator", inv, upgrades)
		end,
		BreakSpeed = function(inv, upgrades)
			if not AutoBuyBreakSpeed["Enabled"] then return end
			buyUpgrade("break", inv, upgrades)
		end,
		Alarm = function(inv, upgrades)
			if not AutoBuyAlarm["Enabled"] then return end
			buyUpgrade("alarm", inv, upgrades)
		end,
		Armory = function(inv, upgrades)
			if not AutoBuyArmory["Enabled"] then return end
			buyUpgrade("armory", inv, upgrades)
		end
	}

	AutoBuy = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
		["Name"] = "AutoBuy", 
		["Function"] = function(callback)
			if callback then 
				buyingthing = false 
				task.spawn(function()
					repeat
						task.wait()
						local found, npctype, enchant = nearNPC(AutoBuyRange["Value"])
						if found then
							local inv = currentinventory.inventory
							local currentupgrades = bedwars["ClientStoreHandler"]:getState()["Bedwars"]["teamUpgrades"]
							if kit == "dasher" then 
								swords = {
									[1] = "wood_dao",
									[2] = "stone_dao",
									[3] = "iron_dao",
									[4] = "diamond_dao",
									[5] = "emerald_dao"
								}
							elseif kit == "ice_queen" then 
								swords[5] = "ice_sword"
							elseif kit == "ember" then 
								swords[5] = "infernal_saber"
							elseif kit == "lumen" then 
								swords[5] = "light_sword"
							end
							if (AutoBuyGui["Enabled"] == false or (bedwars["AppController"]:isAppOpen("BedwarsItemShopApp") or bedwars["AppController"]:isAppOpen("BedwarsTeamUpgradeApp"))) and (not enchant) then
								for i,v in pairs(AutoBuyCustom["ObjectList"]) do 
									local autobuyitem = v:split("/")
									if #autobuyitem >= 3 and autobuyitem[4] ~= "true" then 
										local shopitem = getShopItem(autobuyitem[1])
										if shopitem then 
											local currency = getItem(shopitem.currency, inv.items)
											local actualitem = getItem(shopitem.itemType == "wool_white" and getwool() or shopitem.itemType, inv.items)
											if currency and currency["amount"] >= shopitem.price and (actualitem == nil or actualitem["amount"] < tonumber(autobuyitem[2])) then 
												buyItem(shopitem, tonumber(autobuyitem[2]) > 1)
											end
										end
									end
								end
								for i,v in pairs(buyfunctions) do v(inv, currentupgrades, npctype and "upgrade" or "item") end
								for i,v in pairs(AutoBuyCustom["ObjectList"]) do 
									local autobuyitem = v:split("/")
									if #autobuyitem >= 3 and autobuyitem[4] == "true" then 
										local shopitem = getShopItem(autobuyitem[1])
										if shopitem then 
											local currency = getItem(shopitem.currency, inv.items)
											local actualitem = getItem(shopitem.itemType == "wool_white" and getwool() or shopitem.itemType, inv.items)
											if currency and currency["amount"] >= shopitem.price and (actualitem == nil or actualitem["amount"] < tonumber(autobuyitem[2])) then 
												buyItem(shopitem, tonumber(autobuyitem[2]) > 1)
											end
										end
									end
								end
							end
						end
					until (not AutoBuy["Enabled"])
				end)
			end
		end,
		["HoverText"] = "Automatically Buys Swords, Armor, and Team Upgrades\nwhen you walk near the NPC"
	})
	AutoBuyRange = AutoBuy.CreateSlider({
		["Name"] = "Range",
		["Function"] = function() end,
		["Min"] = 1,
		["Max"] = 20,
		["Default"] = 20
	})
	AutoBuyArmor = AutoBuy.CreateToggle({
		["Name"] = "Buy Armor",
		["Function"] = function() end, 
		["Default"] = true
	})
	AutoBuySword = AutoBuy.CreateToggle({
		["Name"] = "Buy Sword",
		["Function"] = function() end, 
		["Default"] = true
	})
	AutoBuyUpgrades = AutoBuy.CreateToggle({
		["Name"] = "Buy Team Upgrades",
		["Function"] = function(callback) 
			if AutoBuyUpgrades["Object"] then
				AutoBuyUpgrades["Object"].ToggleArrow.Visible = callback
			end
			if AutoBuyGen["Object"] then
				AutoBuyGen["Object"].Visible = callback
			end
			if AutoBuyProt["Object"] then
				AutoBuyProt["Object"].Visible = callback
			end
			if AutoBuySharp["Object"] then
				AutoBuySharp["Object"].Visible = callback
			end
			if AutoBuyBreakSpeed["Object"] then
				AutoBuyBreakSpeed["Object"].Visible = callback
			end
			if AutoBuyAlarm["Object"] then
				AutoBuyAlarm["Object"].Visible = callback
			end
            if AutoBuyArmory["Object"] then
				AutoBuyArmory["Object"].Visible = callback
			end
		end, 
		["Default"] = true
	})
	AutoBuyGen = AutoBuy.CreateToggle({
		["Name"] = "Buy Team Generator",
		["Function"] = function() end, 
	})
	AutoBuyProt = AutoBuy.CreateToggle({
		["Name"] = "Buy Protection",
		["Function"] = function() end, 
		["Default"] = true
	})
	AutoBuySharp = AutoBuy.CreateToggle({
		["Name"] = "Buy Sharpness",
		["Function"] = function() end, 
		["Default"] = true
	})
	AutoBuyBreakSpeed = AutoBuy.CreateToggle({
		["Name"] = "Buy Break Speed",
		["Function"] = function() end, 
	})
	AutoBuyAlarm = AutoBuy.CreateToggle({
		["Name"] = "Buy Alarm",
		["Function"] = function() end, 
	})
    AutoBuyArmory = AutoBuy.CreateToggle({
		["Name"] = "Buy Armory",
		["Function"] = function() end, 
	})
	AutoBuyGui = AutoBuy.CreateToggle({
		["Name"] = "Shop GUI Check",
		["Function"] = function() end, 	
	})
	AutoBuyTierSkip = AutoBuy.CreateToggle({
		["Name"] = "Tier Skip",
		["Function"] = function() end, 
		["Default"] = true
	})
	AutoBuyGen["Object"].BackgroundTransparency = 0
	AutoBuyGen["Object"].BorderSizePixel = 0
	AutoBuyGen["Object"].BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	AutoBuyGen["Object"].Visible = AutoBuyUpgrades["Enabled"]
	AutoBuyProt["Object"].BackgroundTransparency = 0
	AutoBuyProt["Object"].BorderSizePixel = 0
	AutoBuyProt["Object"].BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	AutoBuyProt["Object"].Visible = AutoBuyUpgrades["Enabled"]
	AutoBuySharp["Object"].BackgroundTransparency = 0
	AutoBuySharp["Object"].BorderSizePixel = 0
	AutoBuySharp["Object"].BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	AutoBuySharp["Object"].Visible = AutoBuyUpgrades["Enabled"]
	AutoBuyBreakSpeed["Object"].BackgroundTransparency = 0
	AutoBuyBreakSpeed["Object"].BorderSizePixel = 0
	AutoBuyBreakSpeed["Object"].BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	AutoBuyBreakSpeed["Object"].Visible = AutoBuyUpgrades["Enabled"]
	AutoBuyAlarm["Object"].BackgroundTransparency = 0
	AutoBuyAlarm["Object"].BorderSizePixel = 0
	AutoBuyAlarm["Object"].BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	AutoBuyAlarm["Object"].Visible = AutoBuyUpgrades["Enabled"]
    AutoBuyArmory["Object"].BackgroundTransparency = 0
	AutoBuyArmory["Object"].BorderSizePixel = 0
	AutoBuyArmory["Object"].BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	AutoBuyArmory["Object"].Visible = AutoBuyUpgrades["Enabled"]
	AutoBuyCustom = AutoBuy.CreateTextList({
		["Name"] = "BuyList",
		["TempText"] = "item/amount/priority/after",
		["SortFunction"] = function(a, b)
			local amount1 = a:split("/")
			local amount2 = b:split("/")
			amount1 = #amount1 and tonumber(amount1[3]) or 1
			amount2 = #amount2 and tonumber(amount2[3]) or 1
			return amount1 < amount2
		end
	})
	AutoBuyCustom["Object"].AddBoxBKG.AddBox.TextSize = 14

	local AutoBankConnection
	local AutoBank = {["Enabled"] = false}
	local AutoBankRange = {["Value"] = 20}
	local AutoBankTransmitted, AutoBankTransmittedType = false, false
	local autobankoldapple
	local autobankoldballoon
	local autobankui

	local function refreshbank()
		if autobankui then
			local echest = repstorage.Inventories:FindFirstChild(lplr.Name.."_personal")
			for i,v in pairs(autobankui:GetChildren()) do 
				if echest:FindFirstChild(v.Name) then 
					v.Amount.Text = echest[v.Name]:GetAttribute("Amount")
				else
					v.Amount.Text = ""
				end
			end
		end
	end

	AutoBank = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
		["Name"] = "AutoBank",
		["Function"] = function(callback)
			if callback then
				autobankui = Instance.new("Frame")
				autobankui.Size = UDim2.new(0, 240, 0, 40)
				autobankui.Position = UDim2.new(0, 0, 0, -200)
				task.spawn(function()
					repeat
						task.wait()
						if autobankui then 
							local hotbar = lplr.PlayerGui:FindFirstChild("hotbar")
							if hotbar then 
								local healthbar = hotbar["1"]:FindFirstChild("HotbarHealthbarContainer")
								if healthbar then 
									autobankui.Position = UDim2.new(0.5, -120, 0, healthbar.AbsolutePosition.Y - 50)
								end
							end
						else
							break
						end
					until (not AutoBank["Enabled"])
				end)
				autobankui.BackgroundTransparency = 1
				autobankui.Parent = GuiLibrary["MainGui"]
				local emerald = Instance.new("ImageLabel")
				emerald.Image = bedwars["getIcon"]({itemType = "emerald"}, true)
				emerald.Size = UDim2.new(0, 40, 0, 40)
				emerald.Name = "emerald"
				emerald.Position = UDim2.new(0, 80, 0, 0)
				emerald.BackgroundTransparency = 1
				emerald.Parent = autobankui
				local emeraldtext = Instance.new("TextLabel")
				emeraldtext.TextSize = 20
				emeraldtext.BackgroundTransparency = 1
				emeraldtext.Size = UDim2.new(1, 0, 1, 0)
				emeraldtext.Font = Enum.Font.SourceSans
				emeraldtext.TextStrokeTransparency = 0.3
				emeraldtext.Name = "Amount"
				emeraldtext.Text = ""
				emeraldtext.TextColor3 = Color3.new(1, 1, 1)
				emeraldtext.Parent = emerald
				local diamond = emerald:Clone()
				diamond.Image = bedwars["getIcon"]({itemType = "diamond"}, true)
				diamond.Position = UDim2.new(0, 40, 0, 0)
				diamond.Name = "diamond"
				diamond.Parent = autobankui
				local iron = emerald:Clone()
				iron.Image = bedwars["getIcon"]({itemType = "iron"}, true)
				iron.Position = UDim2.new(0, 0, 0, 0)
				iron.Name = "iron"
				iron.Parent = autobankui
				local crystal = emerald:Clone()
				crystal.Image = bedwars["getIcon"]({itemType = "void_crystal"}, true)
				crystal.Position = UDim2.new(0, 120, 0, 0)
				crystal.Name = "void_crystal"
				crystal.Parent = autobankui
				local apple = emerald:Clone()
				apple.Image = bedwars["getIcon"]({itemType = "apple"}, true)
				apple.Position = UDim2.new(0, 160, 0, 0)
				apple.Name = "apple"
				apple.Parent = autobankui
				local balloon = emerald:Clone()
				balloon.Image = bedwars["getIcon"]({itemType = "balloon"}, true)
				balloon.Position = UDim2.new(0, 200, 0, 0)
				balloon.Name = "balloon"
				balloon.Parent = autobankui
				local echest = repstorage.Inventories:FindFirstChild(lplr.Name.."_personal")
				if entity.isAlive and echest then
					local chestitems = currentinventory.inventory.items
					for i3,v3 in pairs(chestitems) do
						if (v3.itemType == "void_crystal" or v3.itemType == "emerald" or v3.itemType == "iron" or v3.itemType == "diamond" or v3.itemType == "apple" or v3.itemType == "balloon") then
							bedwars["ClientHandler"]:GetNamespace("Inventory"):Get("ChestGiveItem"):CallServer(echest, v3.tool)
							refreshbank()
						end
					end
				end
				refreshbank()
				AutoBankConnection = repstorage.Inventories.DescendantAdded:connect(function(p3)
					if p3.Parent.Name == lplr.Name then
						if echest == nil then 
							echest = repstorage.Inventories:FindFirstChild(lplr.Name.."_personal")
						end	
						if not echest then return end
						if p3.Name == "apple" then 
							if autobankapple then return end
						elseif p3.Name == "balloon" then 
							if autobankballoon then autobankballoonevent:Fire() return end
						elseif (p3.Name == "void_crystal" or p3.Name == "emerald" or p3.Name == "iron" or p3.Name == "diamond") then
							if not ((not AutoBankTransmitted) or (AutoBankTransmittedType and p3.Name ~= "diamond")) then return end
						else
							return
						end
						bedwars["ClientHandler"]:GetNamespace("Inventory"):Get("ChestGiveItem"):CallServer(echest, p3)
						refreshbank()
					end
				end)
				task.spawn(function()
					repeat
						task.wait()
						local found, npctype = nearNPC(AutoBankRange["Value"])
						if echest == nil then 
							echest = repstorage.Inventories:FindFirstChild(lplr.Name.."_personal")
						end
						if autobankballoon then 
							local chestitems = echest and echest:GetChildren() or {}
							if #chestitems > 0 then
								for i3,v3 in pairs(chestitems) do
									if v3:IsA("Accessory") and v3.Name == "balloon" then
										if (not getItem("balloon")) then
											task.spawn(function()
												bedwars["ClientHandler"]:GetNamespace("Inventory"):Get("ChestGetItem"):CallServer(echest, v3)
												refreshbank()
											end)
										end
									end
								end
							end
						end
						if autobankballoon ~= autobankoldballoon then 
							if entity.isAlive then
								if not autobankballoon then
									local chestitems = currentinventory.inventory.items
									if #chestitems > 0 then
										for i3,v3 in pairs(chestitems) do
											if v3 and v3.itemType == "balloon" then
												task.spawn(function()
													bedwars["ClientHandler"]:GetNamespace("Inventory"):Get("ChestGiveItem"):CallServer(echest, v3.tool)
													refreshbank()
												end)
											end
										end
									end
								end
							end
							autobankoldballoon = autobankballoon
						end
						if autobankapple then 
							local chestitems = echest and echest:GetChildren() or {}
							if #chestitems > 0 then
								for i3,v3 in pairs(chestitems) do
									if v3:IsA("Accessory") and v3.Name == "apple" then
										if (not getItem("apple")) then
											task.spawn(function()
												bedwars["ClientHandler"]:GetNamespace("Inventory"):Get("ChestGetItem"):CallServer(echest, v3)
												refreshbank()
											end)
										end
									end
								end
							end
						end
						if autobankapple ~= autobankoldapple then 
							if entity.isAlive then
								if not autobankapple then
									local chestitems = currentinventory.inventory.items
									if #chestitems > 0 then
										for i3,v3 in pairs(chestitems) do
											if v3 and v3.itemType == "apple" then
												task.spawn(function()
													bedwars["ClientHandler"]:GetNamespace("Inventory"):Get("ChestGiveItem"):CallServer(echest, v3.tool)
													refreshbank()
												end)
											end
										end
									end
								end
							end
							autobankoldapple = autobankapple
						end
						if found ~= AutoBankTransmitted or npctype ~= AutoBankTransmittedType then
							AutoBankTransmitted, AutoBankTransmittedType = found, npctype
							if entity.isAlive then
								local chestitems = currentinventory.inventory.items
								if #chestitems > 0 then
									for i3,v3 in pairs(chestitems) do
										if v3 and (v3.itemType == "void_crystal" or v3.itemType == "emerald" or v3.itemType == "iron" or v3.itemType == "diamond") then
											if (not AutoBankTransmitted) or (AutoBankTransmittedType and v3.Name ~= "diamond") then 
												task.spawn(function()
													bedwars["ClientHandler"]:GetNamespace("Inventory"):Get("ChestGiveItem"):CallServer(echest, v3.tool)
													refreshbank()
												end)
											end
										end
									end
								end
							end
						end
						if found then 
							local chestitems = echest and echest:GetChildren() or {}
							if #chestitems > 0 then
								for i3,v3 in pairs(chestitems) do
									if v3:IsA("Accessory") and ((npctype == false and (v3.Name == "void_crystal" or v3.Name == "emerald" or v3.Name == "iron")) or v3.Name == "diamond") then
										task.spawn(function()
											bedwars["ClientHandler"]:GetNamespace("Inventory"):Get("ChestGetItem"):CallServer(echest, v3)
											refreshbank()
										end)
									end
								end
							end
						end
					until (not AutoBank["Enabled"])
				end)
			else
				if autobankui then
					autobankui:Remove()
					autobankui = nil
				end
				if AutoBankConnection then 
					AutoBankConnection:Disconnect()
				end
				local echest = repstorage.Inventories:FindFirstChild(lplr.Name.."_personal")
				local chestitems = echest and echest:GetChildren() or {}
				if #chestitems > 0 then
					for i3,v3 in pairs(chestitems) do
						if v3:IsA("Accessory") and (v3.Name == "void_crystal" or v3.Name == "emerald" or v3.Name == "iron" or v3.Name == "diamond" or v3.Name == "apple" or v3.Name == "balloon") then
							task.spawn(function()
								bedwars["ClientHandler"]:GetNamespace("Inventory"):Get("ChestGetItem"):CallServer(echest, v3)
							end)
						end
					end
				end
			end
		end
	})
	AutoBankRange = AutoBank.CreateSlider({
		["Name"] = "Range",
		["Function"] = function() end,
		["Min"] = 1,
		["Max"] = 20,
		["Default"] = 20
	})
end)

	local FastDrop = {["Enabled"] = false}
	FastDrop = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
		["Name"] = "FastDrop",
		["Function"] = function(callback)
			if callback then
				task.spawn(function()
					repeat
						task.wait()
						if entity.isAlive and (not bedwars["ClientStoreHandler"]:getState().Inventory.opened) and (uis:IsKeyDown(Enum.KeyCode.Q) or uis:IsKeyDown(Enum.KeyCode.Backspace)) and bettergetfocus() == nil then
							task.spawn(bedwars["DropItem"])
						end
					until (not FastDrop)
				end)
			end
		end,
		["HoverText"] = "Drops items fast when you hold Q"
	})
end)

local AutoReport = {["Enabled"] = false}
runcode(function()
	local reporttable = {
		["gay"] = "Bullying",
		["gae"] = "Bullying",
		["gey"] = "Bullying",
		["hack"] = "Scamming",
		["exploit"] = "Scamming",
		["cheat"] = "Scamming",
		["hecker"] = "Scamming",
		["hacer"] = "Scamming",
		["report"] = "Bullying",
		["fat"] = "Bullying",
		["black"] = "Bullying",
		["getalife"] = "Bullying",
		["fatherless"] = "Bullying",
		["report"] = "Bullying",
		["fatherless"] = "Bullying",
		["disco"] = "Offsite Links",
		["yt"] = "Offsite Links",
		["dizcourde"] = "Offsite Links",
		["retard"] = "Swearing",
		["bad"] = "Bullying",
		["trash"] = "Bullying",
		["nolife"] = "Bullying",
		["nolife"] = "Bullying",
		["loser"] = "Bullying",
		["killyour"] = "Bullying",
		["kys"] = "Bullying",
		["hacktowin"] = "Bullying",
		["bozo"] = "Bullying",
		["kid"] = "Bullying",
		["adopted"] = "Bullying",
		["linlife"] = "Bullying",
		["commitnotalive"] = "Bullying",
		["vape"] = "Offsite Links",
		["futureclient"] = "Offsite Links",
		["download"] = "Offsite Links",
		["youtube"] = "Offsite Links",
		["die"] = "Bullying",
		["lobby"] = "Bullying",
		["ban"] = "Bullying",
		["wizard"] = "Bullying",
		["wisard"] = "Bullying",
		["witch"] = "Bullying",
		["magic"] = "Bullying",
	}

	local function removerepeat(str)
		local newstr = ""
		local lastlet = ""
		for i,v in pairs(str:split("")) do 
			if v ~= lastlet then
				newstr = newstr..v 
				lastlet = v
			end
		end
		return newstr
	end

	local reporttableexact = {
		["L"] = "Bullying",
	}

	local alreadyreported = {}
	local AutoReportList = {["ObjectList"] = {}}

	local function findreport(msg)
		local checkstr = removerepeat(msg:gsub("%W+", ""):lower())
		for i,v in pairs(reporttable) do 
			if checkstr:find(i) then 
				return v, i
			end
		end
		for i,v in pairs(reporttableexact) do 
			if checkstr == i then 
				return v, i
			end
		end
		for i,v in pairs(AutoReportList["ObjectList"]) do 
			if checkstr:find(v) then 
				return "Bullying", v
			end
		end
		return nil
	end

	local AutoReportNotify = {["Enabled"] = false}
	AutoReport = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
		["Name"] = "AutoReport",
		["Function"] = function() end
	})
	AutoReportNotify = AutoReport.CreateToggle({
		["Name"] = "Notify",
		["Function"] = function() end
	})
	AutoReportList = AutoReport.CreateTextList({
		["Name"] = "Report Words",
		["TempText"] = "phrase (to report)"
	})

	chatconnection = repstorage.DefaultChatSystemChatEvents.OnMessageDoneFiltering.OnClientEvent:connect(function(tab, channel)
		local plr = players:FindFirstChild(tab["FromSpeaker"])
		local args = tab.Message:split(" ")
		local client = clients.ChatStrings1[#args > 0 and args[#args] or tab.Message]
		if plr and bedwars["CheckPlayerType"](lplr) ~= "DEFAULT" and tab.MessageType == "Whisper" and client ~= nil and alreadysaidlist[plr.Name] == nil then
			alreadysaidlist[plr.Name] = true
			local playerlist = game:GetService("CoreGui"):FindFirstChild("PlayerList")
			if playerlist then
				pcall(function()
					local playerlistplayers = playerlist.PlayerListMaster.OffsetFrame.PlayerScrollList.SizeOffsetFrame.ScrollingFrameContainer.ScrollingFrameClippingFrame.ScollingFrame.OffsetUndoFrame
					local targetedplr = playerlistplayers:FindFirstChild("p_"..plr.UserId)
					if targetedplr then 
						targetedplr.ChildrenFrame.NameFrame.BGFrame.OverlayFrame.PlayerIcon.Image = getcustomassetfunc("vape/assets/VapeIcon.png")
					end
				end)
			end
			task.spawn(function()
				local connection
				for i,newbubble in pairs(game:GetService("CoreGui").BubbleChat:GetDescendants()) do
					if newbubble:IsA("TextLabel") and newbubble.Text:find(clients.ChatStrings2[client]) then
						newbubble.Parent.Parent.Visible = false
						repeat task.wait() until newbubble.Parent.Parent.Parent == nil or newbubble.Parent.Parent.Parent.Parent == nil
						if connection then
							connection:Disconnect()
						end
					end
				end
				connection = game:GetService("CoreGui").BubbleChat.DescendantAdded:connect(function(newbubble)
					if newbubble:IsA("TextLabel") and newbubble.Text:find(clients.ChatStrings2[client]) then
						newbubble.Parent.Parent.Visible = false
						repeat task.wait() until newbubble.Parent.Parent.Parent == nil or  newbubble.Parent.Parent.Parent.Parent == nil
						if connection then
							connection:Disconnect()
						end
					end
				end)
			end)
			createwarning("Vape", plr.Name.." is using "..client.."!", 60)
			clients.ClientUsers[plr.Name] = client:upper()..' USER'
			local ind, newent = entity.getEntityFromPlayer(plr)
			if newent then entity.entityUpdatedEvent:Fire(newent) end
		end
		if priolist[bedwars["CheckPlayerType"](lplr)] > 0 and plr == lplr then
			if tab.Message:len() >= 5 and tab.Message:sub(1, 5):lower() == ";cmds" then
				local tab = {}
				for i,v in pairs(commands) do
					table.insert(tab, i)
				end
				table.sort(tab)
				local str = ""
				for i,v in pairs(tab) do
					str = str..";"..v.."\n"
				end
				game.StarterGui:SetCore("ChatMakeSystemMessage",{
					Text = 	str,
				})
			end
		end
		if AutoReport["Enabled"] and plr and plr ~= lplr and bedwars["CheckPlayerType"](plr) == "DEFAULT" then
            local reportreason, reportedmatch = findreport(tab.Message)
            if reportreason then 
				if alreadyreported[plr] == nil then
					task.spawn(function()
						reported = reported + 1
						if syn == nil then
							players:ReportAbuse(plr, reportreason, "he said a bad word")
						end
					end)
					if AutoReportNotify["Enabled"] then 
						local warning = createwarning("AutoReport", "Reported "..plr.Name.." for\n"..reportreason..' ('..reportedmatch..')', 15)
						pcall(function()
							warning:GetChildren()[5].Position = UDim2.new(0, 46, 0, 38)
						end)
					end
					alreadyreported[plr] = true
				end
            end
        end
		if plr and priolist[bedwars["CheckPlayerType"](plr)] > 0 and plr ~= lplr and priolist[bedwars["CheckPlayerType"](plr)] > priolist[bedwars["CheckPlayerType"](lplr)] and #args > 1 then
			table.remove(args, 1)
			local chosenplayers = findplayers(args[1])
			if table.find(chosenplayers, lplr) then
				table.remove(args, 1)
				for i,v in pairs(commands) do
					if tab.Message:len() >= (i:len() + 1) and tab.Message:sub(1, i:len() + 1):lower() == ";"..i:lower() then
						v(args, plr)
						break
					end
				end
			end
		end
		if (AutoToxicTeam["Enabled"] == false and lplr:GetAttribute("Team") ~= plr:GetAttribute("Team") or AutoToxicTeam["Enabled"]) and (#AutoToxicPhrases5["ObjectList"] <= 0 and findreport(tab["Message"]) == "Bullying" or toxicfindstr(tab["Message"], AutoToxicPhrases5["ObjectList"])) and plr ~= lplr and table.find(ignoredplayers, plr.UserId) == nil and AutoToxic["Enabled"] and AutoToxicRespond["Enabled"] then
			local custommsg = #AutoToxicPhrases4["ObjectList"] > 0 and AutoToxicPhrases4["ObjectList"][math.random(1, #AutoToxicPhrases4["ObjectList"])]
			if custommsg == lastsaid2 then
				custommsg = #AutoToxicPhrases4["ObjectList"] > 0 and AutoToxicPhrases4["ObjectList"][math.random(1, #AutoToxicPhrases4["ObjectList"])]
			else
				lastsaid2 = custommsg
			end
			if custommsg then
				custommsg = custommsg:gsub("<name>", (plr.DisplayName or plr.Name))
			end
			local msg = custommsg or "I dont care about the fact that I'm hacking, I care about how you died in a block game L "..(plr.DisplayName or plr.Name).." | va pe on top"
			repstorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg, "All")
			table.insert(ignoredplayers, plr.UserId)
		end
	end)
end)

	local justsaid = ""
	local leavesaid = false
	bedwars["ClientHandler"]:WaitFor("EntityDeathEvent"):andThen(function(p6)
		connectionstodisconnect[#connectionstodisconnect + 1] = p6:Connect(function(p7)
			if p7.fromEntity == lplr.Character and p7.entityInstance ~= lplr.Character then 
				kills = kills + 1
				if AutoToxic["Enabled"] then 
					local plr = {["Name"] = ""}
					if p7.entityInstance then
						plr = players:GetPlayerFromCharacter(p7.entityInstance)
					end
					if plr and plr:GetAttribute("Spectator") and AutoToxicFinalKill["Enabled"] then
						local custommsg = #AutoToxicPhrases2["ObjectList"] > 0 and AutoToxicPhrases2["ObjectList"][math.random(1, #AutoToxicPhrases2["ObjectList"])] or "L <name> | va pe on top"
						if custommsg == lastsaid then
							custommsg = #AutoToxicPhrases2["ObjectList"] > 0 and AutoToxicPhrases2["ObjectList"][math.random(1, #AutoToxicPhrases2["ObjectList"])] or "L <name> | va pe on top"
						else
							lastsaid = custommsg
						end
						if custommsg then
							custommsg = custommsg:gsub("<name>", (plr.DisplayName or plr.Name))
						end
						repstorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(custommsg, "All")
					end
				end
			end
			if (not leavesaid) and lplr:GetAttribute("Spectator") and p7.entityInstance == lplr.Character then
				leavesaid = true
				local plr = {["Name"] = ""}
				if p7.fromEntity then
					plr = players:GetPlayerFromCharacter(p7.fromEntity)
				end
				if plr and AutoToxic["Enabled"] and AutoToxicDeath["Enabled"] then
					local custommsg = #AutoToxicPhrases3["ObjectList"] > 0 and AutoToxicPhrases3["ObjectList"][math.random(1, #AutoToxicPhrases3["ObjectList"])] or "My gaming chair expired midfight, thats why you won <name> | va pe on top"
					if custommsg then
						custommsg = custommsg:gsub("<name>", (plr.DisplayName or plr.Name))
					end
					repstorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(custommsg, "All")
				end
				if AutoLeave["Enabled"] and allowleave() and matchState ~= 2 then
					task.wait(1 + (AutoLeaveDelay["Value"] / 10))
					if bedwars["ClientStoreHandler"]:getState().Game.customMatch == nil and bedwars["ClientStoreHandler"]:getState().Party.leader.userId == lplr.UserId then
						if not AutoPlayAgain["Enabled"] then
							bedwars["ClientHandler"]:Get("TeleportToLobby"):SendToServer()
						else
							bedwars["LobbyClientEvents"].joinQueue:fire({
								queueType = queueType
							})
						end
					end
				end
			end
		end)
	end)	


local BedESP = {["Enabled"] = false}
local BedESPFolder = Instance.new("Folder")
BedESPFolder.Name = "BedESPFolder"
BedESPFolder.Parent = GuiLibrary["MainGui"]
local BedESPTable = {}
local BedESPColor = {["Value"] = 0.44}
local BedESPTransparency = {["Value"] = 1}
local BedESPOnTop = {["Enabled"] = true}
BedESP = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
	["Name"] = "BedESP",
	["Function"] = function(callback) 
		if callback then
			RunLoops:BindToRenderStep("BedESP", 500, function()
				if bedwars["BedTable"] then
					for i,plr in pairs(bedwars["BedTable"]) do
						local thing
						if plr ~= nil and BedESPTable[plr] then
							thing = BedESPTable[plr]
							for bedespnumber, bedesppart in pairs(thing:GetChildren()) do
								bedesppart.Visible = false
							end
						end
						
						if plr ~= nil and plr.Parent ~= nil and plr:FindFirstChild("Covers") and plr.Covers.BrickColor ~= lplr.Team.TeamColor then
							if BedESPFolder:FindFirstChild(plr.Name..tostring(plr.Covers.BrickColor)) == nil then
								local Bedfolder = Instance.new("Folder")
								Bedfolder.Name = plr.Name..tostring(plr.Covers.BrickColor)
								Bedfolder.Parent = BedESPFolder
								BedESPTable[plr] = Bedfolder
								thing = Bedfolder
								for bedespnumber, bedesppart in pairs(plr:GetChildren()) do
									local boxhandle = Instance.new("BoxHandleAdornment")
									boxhandle.Size = bedesppart.Size + vec3(.01, .01, .01)
									boxhandle.AlwaysOnTop = true
									boxhandle.ZIndex = (bedesppart.Name == "Covers" and 10 or 8)
									boxhandle.Visible = true
									boxhandle.Color3 = bedesppart.Color
									boxhandle.Name = bedespnumber
									boxhandle.Parent = Bedfolder
								end
							end
							for bedespnumber, bedesppart in pairs(thing:GetChildren()) do
								bedesppart.Visible = true
								if plr:GetChildren()[bedespnumber] then
									bedesppart.Adornee = plr:GetChildren()[bedespnumber]
								else
									bedesppart.Adornee = nil
								end
							end
						end
					end
				end
			end)
		else
			RunLoops:UnbindFromRenderStep("BedESP") 
			BedESPFolder:ClearAllChildren()
		end
	end,
	["HoverText"] = "Render Beds through walls" 
})

runcode(function()
	local old
	local old2
	local oldhitpart 
	local removetextures = {["Enabled"] = false}
	local FPSBoost = {["Enabled"] = false}
	local removetexturessmooth = {["Enabled"] = false}
	local fpsboostdamageindicator = {["Enabled"] = false}
	local fpsboostdamageeffect = {["Enabled"] = false}

	local function fpsboosttextures()
		task.spawn(function()
			repeat task.wait() until matchState ~= 0
			for i,v in pairs(bedwarsblocks) do
				if v:GetAttribute("PlacedByUserId") == 0 then
					v.Material = FPSBoost["Enabled"] and removetextures["Enabled"] and Enum.Material.SmoothPlastic or (v.Name:find("glass") and Enum.Material.SmoothPlastic or Enum.Material.Fabric)
					for i2,v2 in pairs(v:GetChildren()) do
						if v2:IsA("Texture") then
							v2.Transparency = FPSBoost["Enabled"] and removetextures["Enabled"] and 1 or 0
						end
					end
				end
			end
		end)
	end

	FPSBoost = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
		["Name"] = "FPSBoost",
		["Function"] = function(callback)
			local damagetab = debug.getupvalue(bedwars["DamageIndicator"], 2)
			if callback then
				fpsboosttextures()
				if fpsboostdamageindicator["Enabled"] then 
					damagetab.strokeThickness = 0
					damagetab.textSize = 0
					damagetab.blowUpDuration = 0
					damagetab.blowUpSize = 0
					debug.setupvalue(bedwars["DamageIndicator"], 10, {
						Create = function(self, obj, ...)
							task.spawn(function()
								obj.Parent.Visible = false
							end)
							return game:GetService("TweenService"):Create(obj, ...)
						end
					})
				end
				if fpsboostdamageeffect["Enabled"] then 
					oldhitpart = bedwars["DamageIndicatorController"].hitEffectPart
					bedwars["DamageIndicatorController"].hitEffectPart = nil
				end
				old = getmetatable(bedwars["HighlightController"])["highlight"]
				old2 = getmetatable(bedwars["StopwatchController"]).tweenOutGhost
				local highlighttable = {}
				getmetatable(bedwars["StopwatchController"]).tweenOutGhost = function(p17, p18)
					p18:Destroy()
				end
				getmetatable(bedwars["HighlightController"])["highlight"] = function() end
			else
				fpsboosttextures()
				if oldhitpart then 
					bedwars["DamageIndicatorController"].hitEffectPart = oldhitpart
				end
				damagetab.strokeThickness = 1.5
				damagetab.textSize = 28
				damagetab.blowUpDuration = 0.125
				damagetab.blowUpSize = 76
				debug.setupvalue(bedwars["DamageIndicator"], 10, game:GetService("TweenService"))
				if bedwars["DamageIndicatorController"].hitEffectPart then 
					bedwars["DamageIndicatorController"].hitEffectPart.Attachment.Cubes.Enabled = true
					bedwars["DamageIndicatorController"].hitEffectPart.Attachment.Shards.Enabled = true
				end
				getmetatable(bedwars["HighlightController"])["highlight"] = old
				getmetatable(bedwars["StopwatchController"]).tweenOutGhost = old2
				old = nil
				old2 = nil
			end
		end
	})
	removetextures = FPSBoost.CreateToggle({
		["Name"] = "Remove Textures",
		["Function"] = function(callback)
			fpsboosttextures()
		end
	})
	fpsboostdamageindicator = FPSBoost.CreateToggle({
		["Name"] = "Remove Damage Indicator",
		["Function"] = function(callback)
			local damagetab = debug.getupvalue(bedwars["DamageIndicator"], 2)
			if FPSBoost["Enabled"] then 
				if callback then 
					damagetab.strokeThickness = 0
					damagetab.textSize = 0
					damagetab.blowUpDuration = 0
					damagetab.blowUpSize = 0
					debug.setupvalue(bedwars["DamageIndicator"], 10, {
						Create = function(self, obj, ...)
							task.spawn(function()
								obj.Parent.Visible = false
							end)
							return game:GetService("TweenService"):Create(obj, ...)
						end
					})
				else
					damagetab.strokeThickness = 1.5
					damagetab.textSize = 28
					damagetab.blowUpDuration = 0.125
					damagetab.blowUpSize = 76
					debug.setupvalue(bedwars["DamageIndicator"], 10, game:GetService("TweenService"))
				end
			end	
		end
	})
	fpsboostdamageeffect = FPSBoost.CreateToggle({
		["Name"] = "Remove Damage Effect",
		["Function"] = function(callback)
			if FPSBoost["Enabled"] then 
				if callback then 
					oldhitpart = bedwars["DamageIndicatorController"].hitEffectPart
					bedwars["DamageIndicatorController"].hitEffectPart = nil
				else
					if oldhitpart then 
						bedwars["DamageIndicatorController"].hitEffectPart = oldhitpart
					end
					oldhitpart = nil
				end
			end
		end
	})
end)

GuiLibrary["RemoveObject"]("NameTagsOptionsButton")
runcode(function()
	local nametagconnection
	local nametagconnection2 
	local function removeTags(str)
        str = str:gsub("<br%s*/>", "\n")
        return (str:gsub("<[^<>]->", ""))
    end

	local function floorpos(pos)
		return Vector2.new(math.floor(pos.X), math.floor(pos.Y))
	end

	local kititems = {
		["jade"] = "jade_hammer",
		["archer"] = "tactical_crossbow",
		["angel"] = "",
		["cowgirl"] = "lasso",
		["dasher"] = "wood_dao",
		["axolotl"] = "axolotl",
		["yeti"] = "snowball",
		["smoke"] = "smoke_block",
		["trapper"] = "snap_trap",
		["pyro"] = "flamethrower",
		["daven"] = "cannon",
		["regent"] = "void_axe", 
		["baker"] = "apple",
		["builder"] = "builder_hammer",
		["farmer_cletus"] = "carrot_seeds",
		["melody"] = "guitar",
		["barbarian"] = "rageblade",
		["gingerbread_man"] = "gumdrop_bounce_pad",
		["spirit_catcher"] = "spirit",
		["fisherman"] = "fishing_rod",
		["oil_man"] = "oil_consumable",
		["santa"] = "tnt",
		["miner"] = "miner_pickaxe",
		["sheep_herder"] = "crook",
		["beast"] = "speed_potion",
		["metal_detector"] = "metal_detector",
		["cyber"] = "drone",
		["vesta"] = "damage_banner",
		["lumen"] = "light_sword",
		["ember"] = "infernal_saber"
	}

	local NameTagsFolder = Instance.new("Folder")
	NameTagsFolder.Name = "NameTagsFolder"
	NameTagsFolder.Parent = GuiLibrary["MainGui"]
	local nametagsfolderdrawing = {}
	local NameTagsColor = {["Value"] = 0.44}
	local NameTagsTeammates = {["Enabled"] = false}
	local NameTagsDisplayName = {["Enabled"] = false}
	local NameTagsHealth = {["Enabled"] = false}
	local NameTagsDistance = {["Enabled"] = false}
	local NameTagsBackground = {["Enabled"] = true}
	local NameTagsScale = {["Value"] = 10}
	local NameTagsFont = {["Value"] = "SourceSans"}
	local NameTagsShowInventory = {["Enabled"] = false}
	local NameTagsDrawing = {["Enabled"] = false}
	local NameTagsRangeLimit = {["Value"] = 0}
	local NameTagsAlive = {["Enabled"] = false}
	local fontitems = {"SourceSans"}
	local nametagscache = {}

	local nametagsfunc = {
		Drawing = function(plr)
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
				nametagsfolderdrawing[plr.Name].BG.Size = Vector2.new(0, 0)
				nametagsfolderdrawing[plr.Name].BG.ZIndex = 1
				thing = nametagsfolderdrawing[plr.Name]
			end

			local aliveplr = isAlive(plr, NameTagsAlive["Enabled"])
			if aliveplr and ((not NameTagsTeammates["Enabled"]) and plr:GetAttribute("Team") ~= lplr:GetAttribute("Team") or NameTagsTeammates["Enabled"]) and plr ~= lplr then
				local mag = entity.isAlive and (entity.character.HumanoidRootPart.Position - aliveplr.RootPart.Position).magnitude or 0
				local magcheck = NameTagsRangeLimit["Value"] == 0 or mag <= NameTagsRangeLimit["Value"] 
				if magcheck then 
					local headPos, headVis = cam:WorldToViewportPoint((aliveplr.RootPart:GetRenderCFrame() * cfnew(0, aliveplr.Head.Size.Y + aliveplr.RootPart.Size.Y, 0)).Position)
					
					if headVis then
						thing.Text.Visible = headVis
						thing.Text.Position = floorpos(Vector2.new(headPos.X - thing.Text.TextBounds.X / 2, (headPos.Y - thing.Text.TextBounds.Y)))
						thing.BG.Visible = headVis and NameTagsBackground["Enabled"]
						thing.BG.Position = floorpos(Vector2.new((headPos.X - 2) - thing.Text.TextBounds.X / 2, (headPos.Y - thing.Text.TextBounds.Y) + 1.5))
					end
				end
			end
		end,
		Normal = function(plr)
			local thing = NameTagsFolder:FindFirstChild(plr.Name)
			if thing then
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
				local nametagSize = textservice:GetTextSize(plr.Name, thing.TextSize, thing.Font, Vector2.new(9e9, 9e9))
				thing.Size = UDim2.new(0, nametagSize.X + 4, 0, nametagSize.Y)
				thing.Text = plr.Name
				thing.TextColor3 = getPlayerColor(plr) or Color3.fromHSV(NameTagsColor["Hue"], NameTagsColor["Sat"], NameTagsColor["Value"])
				thing.Parent = NameTagsFolder
				local hand = Instance.new("ImageLabel")
				hand.Size = UDim2.new(0, 30, 0, 30)
				hand.Name = "Hand"
				hand.BackgroundTransparency = 1
				hand.Position = UDim2.new(0, -30, 0, -30)
				hand.Image = ""
				hand.Parent = thing
				local helmet = hand:Clone()
				helmet.Name = "Helmet"
				helmet.Position = UDim2.new(0, 5, 0, -30)
				helmet.Parent = thing
				local chest = hand:Clone()
				chest.Name = "Chestplate"
				chest.Position = UDim2.new(0, 35, 0, -30)
				chest.Parent = thing
				local boots = hand:Clone()
				boots.Name = "Boots"
				boots.Position = UDim2.new(0, 65, 0, -30)
				boots.Parent = thing
				local kit = hand:Clone()
				kit.Name = "Kit"
				task.spawn(function()
					repeat task.wait() until plr:GetAttribute("PlayingAsKit") ~= ""
					if kit then
						kit.Image = kititems[plr:GetAttribute("PlayingAsKit")] and bedwars["getIcon"]({itemType = kititems[plr:GetAttribute("PlayingAsKit")]}, NameTagsShowInventory["Enabled"]) or ""
					end
				end)
				kit.Position = UDim2.new(0, -30, 0, -65)
				kit.Parent = thing
			end

			local aliveplr = isAlive(plr, NameTagsAlive["Enabled"])
			if aliveplr and ((not NameTagsTeammates["Enabled"]) and plr:GetAttribute("Team") ~= lplr:GetAttribute("Team") or NameTagsTeammates["Enabled"]) and plr ~= lplr then
				local mag = entity.isAlive and (entity.character.HumanoidRootPart.Position - aliveplr.RootPart.Position).magnitude or 0
				local magcheck = NameTagsRangeLimit["Value"] == 0 or mag <= NameTagsRangeLimit["Value"] 
				if magcheck then 
					local headPos, headVis = cam:WorldToViewportPoint((aliveplr.RootPart:GetRenderCFrame() * cfnew(0, aliveplr.Head.Size.Y + aliveplr.RootPart.Size.Y, 0)).Position)
					
					if headVis then
						thing.Visible = headVis
						thing.Position = UDim2.new(0, headPos.X - thing.Size.X.Offset / 2, 0, (headPos.Y - thing.Size.Y.Offset) - 36)
					end
				end
			end
		end
	}
	local nametagsfunc2 = {
		Normal = function(plr)
			plr = plr.Player
			local thing = NameTagsFolder:FindFirstChild(plr.Name)
			if thing then
				local aliveplr = isAlive(plr)
				if aliveplr then
					if NameTagsShowInventory["Enabled"] then 
						local inventory = inventories[plr] or {armor = {}}
						if inventory.hand then
							thing.Hand.Image = bedwars["getIcon"](inventory.hand, NameTagsShowInventory["Enabled"])
							if thing.Hand.Image:find("rbxasset://") then
								thing.Hand.ResampleMode = Enum.ResamplerMode.Pixelated
							end
						else
							thing.Hand.Image = ""
						end
						if inventory.armor[4] then
							thing.Helmet.Image = bedwars["getIcon"](inventory.armor[4], NameTagsShowInventory["Enabled"])
							if thing.Helmet.Image:find("rbxasset://") then
								thing.Helmet.ResampleMode = Enum.ResamplerMode.Pixelated
							end
						else
							thing.Helmet.Image = ""
						end
						if inventory.armor[5] then
							thing.Chestplate.Image = bedwars["getIcon"](inventory.armor[5], NameTagsShowInventory["Enabled"])
							if thing.Chestplate.Image:find("rbxasset://") then
								thing.Chestplate.ResampleMode = Enum.ResamplerMode.Pixelated
							end
						else
							thing.Chestplate.Image = ""
						end
						if inventory.armor[6] then
							thing.Boots.Image = bedwars["getIcon"](inventory.armor[6], NameTagsShowInventory["Enabled"])
							if thing.Boots.Image:find("rbxasset://") then
								thing.Boots.ResampleMode = Enum.ResamplerMode.Pixelated
							end
						else
							thing.Boots.Image = ""
						end
					end
					local istarget = false
					if bedwars["BountyHunterTarget"] == plr then
						istarget = true
					end
					local displaynamestr = (NameTagsDisplayName["Enabled"] and plr.DisplayName ~= nil and plr.DisplayName or plr.Name)
					local displaynamestr2 = displaynamestr
					if bedwars["CheckPlayerType"](plr) ~= "DEFAULT" or whitelisted.chattags[bedwars["HashFunction"](plr.Name..plr.UserId)] or clients.ClientUsers[plr.Name] then
						displaynamestr2 = getNametagString(plr)
						displaynamestr = removeTags(displaynamestr2)
					end
					local blocksaway = math.floor(((entity.isAlive and entity.character.HumanoidRootPart.Position or vec3(0, 0, 0)) - aliveplr.RootPart.Position).Magnitude / 3)
					local rawText = (istarget and "[TARGET] " or "")..(NameTagsDistance["Enabled"] and entity.isAlive and "["..blocksaway.."] " or "")..displaynamestr..(NameTagsHealth["Enabled"] and " "..math.floor((aliveplr.Humanoid.Health + getShield(aliveplr.Character))) or "")
					local color = HealthbarColorTransferFunction((aliveplr.Humanoid.Health + getShield(aliveplr.Character)) / aliveplr.Humanoid.MaxHealth)
					local modifiedText = (istarget and '<font color="rgb(255, 0, 0)">[TARGET]</font> ' or '')..(NameTagsDistance["Enabled"] and entity.isAlive and '<font color="rgb(85, 255, 85)">[</font><font color="rgb(255, 255, 255)">'..blocksaway..'</font><font color="rgb(85, 255, 85)">]</font> ' or '')..displaynamestr2..(NameTagsHealth["Enabled"] and ' <font color="rgb('..tostring(math.floor(color.R * 255))..','..tostring(math.floor(color.G * 255))..','..tostring(math.floor(color.B * 255))..')">'..math.floor((aliveplr.Humanoid.Health + getShield(aliveplr.Character))).."</font>" or '')
					local nametagSize = textservice:GetTextSize(rawText, thing.TextSize, thing.Font, Vector2.new(9e9, 9e9))
					thing.Size = UDim2.new(0, nametagSize.X + 4, 0, nametagSize.Y)
					thing.Font = Enum.Font[NameTagsFont["Value"]]
					thing.TextSize = 14 * (NameTagsScale["Value"] / 10)
					thing.BackgroundTransparency = NameTagsBackground["Enabled"] and 0.5 or 1
					thing.Text = modifiedText
					thing.TextColor3 = getPlayerColor(plr) or Color3.fromHSV(NameTagsColor["Hue"], NameTagsColor["Sat"], NameTagsColor["Value"])
				end
			end
		end,
		Drawing = function(plr)
			plr = plr.Player
			local thing = nametagsfolderdrawing[plr.Name]
			if thing then
				local aliveplr = isAlive(plr)
				if aliveplr then
					local istarget = false
					if bedwars["BountyHunterTarget"] == plr then
						istarget = true
					end
					local displaynamestr = (NameTagsDisplayName["Enabled"] and plr.DisplayName ~= nil and plr.DisplayName or plr.Name)
					local displaynamestr2 = displaynamestr
					if bedwars["CheckPlayerType"](plr) ~= "DEFAULT" or whitelisted.chattags[bedwars["HashFunction"](plr.Name..plr.UserId)] or clients.ClientUsers[plr.Name] then
						displaynamestr2 = getNametagString(plr)
						displaynamestr = removeTags(displaynamestr2)
					end
					local blocksaway = math.floor(((entity.isAlive and entity.character.HumanoidRootPart.Position or vec3(0, 0, 0)) - aliveplr.RootPart.Position).Magnitude / 3)
					local rawText = (istarget and "[TARGET] " or "")..(NameTagsDistance["Enabled"] and entity.isAlive and "["..blocksaway.."] " or "")..displaynamestr..(NameTagsHealth["Enabled"] and " "..math.floor((aliveplr.Humanoid.Health + getShield(aliveplr.Character))) or "")
					local color = HealthbarColorTransferFunction((aliveplr.Humanoid.Health + getShield(aliveplr.Character)) / aliveplr.Humanoid.MaxHealth)
					local modifiedText = (istarget and '[TARGET] ' or '')..(NameTagsDistance["Enabled"] and entity.isAlive and '['..blocksaway..'] ' or '')..displaynamestr2..(NameTagsHealth["Enabled"] and ' '..math.floor((aliveplr.Humanoid.Health + getShield(aliveplr.Character))).."" or '')
					thing.Text.Text = removeTags(modifiedText)
					thing.Text.Size = 17 * (NameTagsScale["Value"] / 10)
					thing.Text.Color = getPlayerColor(plr) or Color3.fromHSV(NameTagsColor["Hue"], NameTagsColor["Sat"], NameTagsColor["Value"])
					thing.Text.Font = (math.clamp((table.find(fontitems, NameTagsFont["Value"]) or 1) - 1, 0, 3))
					thing.BG.Size = floorpos(Vector2.new(thing.Text.TextBounds.X + 4, thing.Text.TextBounds.Y))
				end
			end
		end
	}

	local NameTags = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
		["Name"] = "NameTags",
		["Function"] = function(callback) 
			if callback then
				nametagconnection = players.PlayerRemoving:connect(function(plr)
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
				nametagconnection2 = entity.entityUpdatedEvent:connect(function(plr)
					nametagsfunc2[NameTagsDrawing["Enabled"] and "Drawing" or "Normal"](plr)
				end)
				RunLoops:BindToRenderStep("NameTags", 500, function()
					local starttime = tick()
					for i,plr in pairs(players:GetChildren()) do
						nametagsfunc[NameTagsDrawing["Enabled"] and "Drawing" or "Normal"](plr)
					end
				end)
			else
				if nametagconnection then nametagconnection:Disconnect() end
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
	NameTagsRangeLimit = NameTags.CreateSlider({
		["Name"] = "Range",
		["Function"] = function() end,
		["Min"] = 0,
		["Max"] = 1000,
		["Default"] = 0
	})
	NameTagsBackground = NameTags.CreateToggle({
		["Name"] = "Background", 
		["Function"] = function() end,
		["Default"] = true
	})
	NameTagsTeammates = NameTags.CreateToggle({
		["Name"] = "Show Teammates",
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
		["Function"] = function() end,
		["Default"] = true
	})
	NameTagsDistance = NameTags.CreateToggle({
		["Name"] = "Distance",
		["Function"] = function(callback) 
			if callback then 
				task.spawn(function()
					repeat
						task.wait()
						for i,v in pairs(entity.entityList) do 
							entity.entityUpdatedEvent:Fire(v)
						end
					until (not NameTagsDistance["Enabled"])
				end)
			end
		end,
	})
	NameTagsShowInventory = NameTags.CreateToggle({
		["Name"] = "Equipment",
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

runcode(function()
	local function getallblocks2(pos, normal)
		local blocks = {}
		local lastfound = nil
		for i = 1, 20 do
			local blockpos = (pos + (Vector3.FromNormalId(normal) * (i * 3)))
			local extrablock = getblock(blockpos)
			local covered = true
			if extrablock and extrablock.Parent ~= nil then
				if bedwars["BlockController"]:isBlockBreakable({["blockPosition"] = blockpos}, lplr) then
					table.insert(blocks, extrablock.Name)
				else
					table.insert(blocks, "unbreakable")
					break
				end
				lastfound = extrablock
				if covered == false then
					break
				end
			else
				break
			end
		end
		return blocks
	end

	local function getallbedblocks(pos)
		local blocks = {}
		for i,v in pairs(normalsides) do
			for i2,v2 in pairs(getallblocks2(pos, v)) do	
				if table.find(blocks, v2) == nil and v2 ~= "bed" then
					table.insert(blocks, v2)
				end
			end
			for i2,v2 in pairs(getallblocks2(pos + vec3(0, 0, 3), v)) do	
				if table.find(blocks, v2) == nil and v2 ~= "bed" then
					table.insert(blocks, v2)
				end
			end
		end
		return blocks
	end

	local function refreshAdornee(v)
		local bedblocks = getallbedblocks(v.Adornee.Position)
		for i2,v2 in pairs(v.Frame:GetChildren()) do
			if v2:IsA("ImageLabel") then
				v2:Remove()
			end
		end
		for i3,v3 in pairs(bedblocks) do
			local blockimage = Instance.new("ImageLabel")
			blockimage.Size = UDim2.new(0, 32, 0, 32)
			blockimage.BackgroundTransparency = 1
			blockimage.Image = bedwars["getIcon"]({itemType = v3}, true)
			blockimage.Parent = v.Frame
		end
	end

	local BedPlatesFolder = Instance.new("Folder")
	BedPlatesFolder.Name = "BedPlatesFolder"
	BedPlatesFolder.Parent = GuiLibrary["MainGui"]
	local BedPlates = {["Enabled"] = false}
	bedwars["ClientHandlerDamageBlock"]:WaitFor("PlaceBlockEvent"):andThen(function(p4)
		connectionstodisconnect[#connectionstodisconnect + 1] = p4:Connect(function(p5)
			if not BedPlates["Enabled"] then return end
			for i,v in pairs(BedPlatesFolder:GetChildren()) do 
				if v.Adornee then
					if ((p5.blockRef.blockPosition * 3) - v.Adornee.Position).magnitude <= 20 then
						refreshAdornee(v)
					end
				end
			end
		end)
	end)
	bedwars["ClientHandlerDamageBlock"]:WaitFor("BreakBlockEvent"):andThen(function(p4)
		connectionstodisconnect[#connectionstodisconnect + 1] = p4:Connect(function(p5)
			if not BedPlates["Enabled"] then return end
			for i,v in pairs(BedPlatesFolder:GetChildren()) do 
				if v.Adornee then
					if ((p5.blockRef.blockPosition * 3) - v.Adornee.Position).magnitude <= 20 then
						refreshAdornee(v)
					end
				end
			end
		end)
	end)
	BedPlates = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
		["Name"] = "BedPlates",
		["Function"] = function(callback)
			if callback then
				task.spawn(function()
					repeat task.wait() until #bedwars["BedTable"] > 0
					if BedPlates["Enabled"] then
						for i,v in pairs(bedwars["BedTable"]) do
							local billboard = Instance.new("BillboardGui")
							billboard.Parent = BedPlatesFolder
							billboard.Name = "bed"
							billboard.StudsOffsetWorldSpace = vec3(0, 3, 1.5)
							billboard.Size = UDim2.new(0, 42, 0, 42)
							billboard.AlwaysOnTop = true
							billboard.Adornee = v
							local frame = Instance.new("Frame")
							frame.Size = UDim2.new(1, 0, 1, 0)
							frame.BackgroundColor3 = Color3.new(0, 0, 0)
							frame.BackgroundTransparency = 0.5
							frame.Parent = billboard
							local uilistlayout = Instance.new("UIListLayout")
							uilistlayout.FillDirection = Enum.FillDirection.Horizontal
							uilistlayout.Padding = UDim.new(0, 4)
							uilistlayout.VerticalAlignment = Enum.VerticalAlignment.Center
							uilistlayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
							uilistlayout:GetPropertyChangedSignal("AbsoluteContentSize"):connect(function()
								billboard.Size = UDim2.new(0, math.max(uilistlayout.AbsoluteContentSize.X + 12, 42), 0, 42)
							end)
							uilistlayout.Parent = frame
							local uicorner = Instance.new("UICorner")
							uicorner.CornerRadius = UDim.new(0, 4)
							uicorner.Parent = frame
							refreshAdornee(billboard)
						end
					end
				end)
			else
				BedPlatesFolder:ClearAllChildren()
			end
		end
	})
end)

local oldfish
GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
	["Name"] = "FishermanExploit",
	["Function"] = function(callback) 
		if callback then
			oldfish = bedwars["FishermanTable"].startMinigame
			bedwars["FishermanTable"].startMinigame = function(Self, dropdata, func) func({win = true}) end
		else
			bedwars["FishermanTable"].startMinigame = oldfish
			oldfish = nil
		end
	end,
	["HoverText"] = "Succeeds at fishing everytime"
})

runcode(function()
	local tiered = {}
	local nexttier = {}
	for i,v in pairs(bedwars["ShopItems"]) do
		if v["tiered"] then
			tiered[v.itemType] = v["tiered"]
		end
		if v["nextTier"] then
			nexttier[v.itemType] = v["nextTier"]
		end
	end
	local TierBypass = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
		["Name"] = "ShopTierBypass",
		["Function"] = function(callback) 
			if callback then
				for i,v in pairs(bedwars["ShopItems"]) do
					v["tiered"] = nil
					v["nextTier"] = nil
				end
			else
				for i,v in pairs(bedwars["ShopItems"]) do
					if tiered[v.itemType] then
						v["tiered"] = tiered[v.itemType]
					end
					if nexttier[v.itemType] then
						v["nextTier"] = nexttier[v.itemType]
					end
				end
			end
		end,
		["HoverText"] = "Allows you to access tiered items early."
	})
end)

runcode(function()
	local transformed = false
	local TexturePack = {["Enabled"] = false}
	TexturePack = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
		["Name"] = "TexturePack",
		["Function"] = function(callback) 
			if callback then 
				if not transformed then
					transformed = true
					task.spawn(function()
						local oldbedwarstabofblocks = '{"wool_blue":"http://www.roblox.com/asset/?id=10407182270","wool_pink":"http://www.roblox.com/asset/?id=10408611603","clay_pink":"http://www.roblox.com/asset/?id=10415485631","grass":["http://www.roblox.com/asset/?id=10412687803","http://www.roblox.com/asset/?id=10412875374","http://www.roblox.com/asset/?id=10445249494","http://www.roblox.com/asset/?id=10445249494","http://www.roblox.com/asset/?id=10445249494","http://www.roblox.com/asset/?id=10445249494"],"snow":"rbxassetid://6874651192","wool_cyan":"http://www.roblox.com/asset/?id=10407217881","red_sandstone":"http://www.roblox.com/asset/?id=10413333994","wool_green":"http://www.roblox.com/asset/?id=10407320895","clay_black":"http://www.roblox.com/asset/?id=10415487289","sand":"http://www.roblox.com/asset/?id=10415582359","wool_orange":"http://www.roblox.com/asset/?id=10407359255","wood_plank_birch":"http://www.roblox.com/asset/?id=10408744489","clay_gray":"http://www.roblox.com/asset/?id=10420295577","wood_plank_spruce":"http://www.roblox.com/asset/?id=10408847483","brick":"http://www.roblox.com/asset/?id=10420358273","clay_dark_brown":"http://www.roblox.com/asset/?id=10415706059","stone_brick":"http://www.roblox.com/asset/?id=10416484245","ceramic":"http://www.roblox.com/asset/?id=10415782126","clay_blue":"http://www.roblox.com/asset/?id=10415826972","wood_plank_maple":"http://www.roblox.com/asset/?id=10413457419","diamond_block":"http://www.roblox.com/asset/?id=10409280198","wood_plank_oak":"http://www.roblox.com/asset/?id=10408589947","ice":"http://www.roblox.com/asset/?id=10413754804","marble":"http://www.roblox.com/asset/?id=10413829927","spruce_log":["http://www.roblox.com/asset/?id=10455324890","http://www.roblox.com/asset/?id=10455324890", "http://www.roblox.com/asset/?id=10416758986", "http://www.roblox.com/asset/?id=10416758986", "http://www.roblox.com/asset/?id=10416758986","http://www.roblox.com/asset/?id=10416758986"],"hickory_log":["http://www.roblox.com/asset/?id=10455485367","http://www.roblox.com/asset/?id=10455485367","http://www.roblox.com/asset/?id=10420600774","http://www.roblox.com/asset/?id=10420600774","http://www.roblox.com/asset/?id=10420600774","http://www.roblox.com/asset/?id=10420600774"],"clay_light_brown":"http://www.roblox.com/asset/?id=10415861458","clay_dark_green":"http://www.roblox.com/asset/?id=10415920574","marble_pillar":["http://www.roblox.com/asset/?id=10414948240","http://www.roblox.com/asset/?id=10414948240","http://www.roblox.com/asset/?id=10414946680","http://www.roblox.com/asset/?id=10414946680","http://www.roblox.com/asset/?id=10414946680","http://www.roblox.com/asset/?id=10414946680"],"slate_brick":"http://www.roblox.com/asset/?id=10415953149","obsidian":"http://www.roblox.com/asset/?id=10415957481","iron_block":"http://www.roblox.com/asset/?id=10409414163","wool_red":"http://www.roblox.com/asset/?id=10407265765","clay_purple":"http://www.roblox.com/asset/?id=10407332996","clay_orange":"http://www.roblox.com/asset/?id=10416016383","clay_red":"http://www.roblox.com/asset/?id=10416049782","wool_yellow":"http://www.roblox.com/asset/?id=10407238791","tnt":["http://www.roblox.com/asset/?id=10416267458","http://www.roblox.com/asset/?id=10416271245","http://www.roblox.com/asset/?id=10416265082","http://www.roblox.com/asset/?id=10416265082","http://www.roblox.com/asset/?id=10416265082","http://www.roblox.com/asset/?id=10416265082"],"clay_yellow":"http://www.roblox.com/asset/?id=10420804323","clay_white":"http://www.roblox.com/asset/?id=10416451714","wool_purple":"http://www.roblox.com/asset/?id=10407332996","sandstone":"http://www.roblox.com/asset/?id=10413249048","wool_white":"http://www.roblox.com/asset/?id=10407458145","clay_light_green":"http://www.roblox.com/asset/?id=10420886255","emerald_block":"http://www.roblox.com/asset/?id=10409305031","clay":"rbxassetid://6856190168","stone":"http://www.roblox.com/asset/?id=10412461488","cobblestone":"http://www.roblox.com/asset/?id=10446021150","lucky_block":"http://www.roblox.com/asset/?id=10445724366","fisherman_coral":"http://www.roblox.com/asset/?id=10448256187","slime_block":"http://www.roblox.com/asset/?id=10412207075","dirt":"http://www.roblox.com/asset/?id=10449514590","concrete_green":["http://www.roblox.com/asset/?id=10450107448","http://www.roblox.com/asset/?id=10450107448","http://www.roblox.com/asset/?id=10449916439","http://www.roblox.com/asset/?id=10449916439","http://www.roblox.com/asset/?id=10449916439","http://www.roblox.com/asset/?id=10449916439"],"oak_log":["http://www.roblox.com/asset/?id=10455297992","http://www.roblox.com/asset/?id=10455297992","http://www.roblox.com/asset/?id=10416703653","http://www.roblox.com/asset/?id=10416703653","http://www.roblox.com/asset/?id=10416703653","http://www.roblox.com/asset/?id=10416703653"],"birch_log":["http://www.roblox.com/asset/?id=10455535165","http://www.roblox.com/asset/?id=10455535165","http://www.roblox.com/asset/?id=10416796681","http://www.roblox.com/asset/?id=10416796681","http://www.roblox.com/asset/?id=10416796681","http://www.roblox.com/asset/?id=10416796681"]}'
						local oldbedwarsblocktab = game:GetService("HttpService"):JSONDecode(oldbedwarstabofblocks)
						local oldbedwarstabofimages = '{"clay_orange":"rbxassetid://7017703219","iron":"http://www.roblox.com/asset/?id=10417446703","glass":"rbxassetid://6909521321","log_spruce":"rbxassetid://6874161124","ice":"rbxassetid://6874651262","marble":"rbxassetid://6594536339","zipline_base":"rbxassetid://7051148904","iron_helmet":"rbxassetid://6874272559","marble_pillar":"rbxassetid://6909323822","clay_dark_green":"rbxassetid://6763635916","wood_plank_birch":"rbxassetid://6768647328","watering_can":"rbxassetid://6915423754","emerald_helmet":"rbxassetid://6931675766","pie":"rbxassetid://6985761399","wood_plank_spruce":"rbxassetid://6768615964","diamond_chestplate":"rbxassetid://6874272898","wool_pink":"rbxassetid://6910479863","wool_blue":"rbxassetid://6910480234","wood_plank_oak":"rbxassetid://6910418127","diamond_boots":"rbxassetid://6874272964","clay_yellow":"rbxassetid://4991097283","tnt":"rbxassetid://6856168996","lasso":"rbxassetid://7192710930","clay_purple":"rbxassetid://6856099740","melon_seeds":"rbxassetid://6956387796","apple":"rbxassetid://6985765179","carrot_seeds":"rbxassetid://6956387835","log_oak":"rbxassetid://6763678414","emerald_chestplate":"rbxassetid://6931675868","wool_yellow":"rbxassetid://6910479606","emerald_boots":"rbxassetid://6931675942","clay_light_brown":"rbxassetid://6874651634","balloon":"rbxassetid://7122143895","cannon":"rbxassetid://7121221753","leather_boots":"rbxassetid://6855466456","melon":"rbxassetid://6915428682","wool_white":"rbxassetid://6910387332","log_birch":"rbxassetid://6763678414","clay_pink":"rbxassetid://6856283410","grass":"rbxassetid://6773447725","obsidian":"rbxassetid://6910443317","shield":"rbxassetid://7051149149","red_sandstone":"rbxassetid://6708703895","diamond_helmet":"rbxassetid://6874272793","wool_orange":"rbxassetid://6910479956","log_hickory":"rbxassetid://7017706899","guitar":"rbxassetid://7085044606","wool_purple":"rbxassetid://6910479777","diamond":"http://www.roblox.com/asset/?id=10449458929","iron_chestplate":"rbxassetid://6874272631","slime_block":"rbxassetid://6869284566","stone_brick":"rbxassetid://6910394475","hammer":"rbxassetid://6955848801","ceramic":"rbxassetid://6910426690","wood_plank_maple":"rbxassetid://6768632085","leather_helmet":"rbxassetid://6855466216","stone":"rbxassetid://6763635916","slate_brick":"rbxassetid://6708836267","sandstone":"rbxassetid://6708657090","snow":"rbxassetid://6874651192","wool_red":"rbxassetid://6910479695","leather_chestplate":"rbxassetid://6876833204","clay_red":"rbxassetid://6856283323","wool_green":"rbxassetid://6910480050","clay_white":"rbxassetid://7017705325","wool_cyan":"rbxassetid://6910480152","clay_black":"rbxassetid://5890435474","sand":"rbxassetid://6187018940","clay_light_green":"rbxassetid://6856099550","clay_dark_brown":"rbxassetid://6874651325","carrot":"rbxassetid://3677675280","clay":"rbxassetid://6856190168","iron_boots":"rbxassetid://6874272718","emerald":"http://www.roblox.com/asset/?id=10449460616","zipline":"rbxassetid://7051148904"}'
						local oldbedwarsicontab = game:GetService("HttpService"):JSONDecode(oldbedwarstabofimages)
						local oldbedwarssoundtable = {
							["QUEUE_JOIN"] = "rbxassetid://6691735519",
							["QUEUE_MATCH_FOUND"] = "rbxassetid://6768247187",
							["UI_CLICK"] = "rbxassetid://6732690176",
							["UI_OPEN"] = "rbxassetid://6732607930",
							["BEDWARS_UPGRADE_SUCCESS"] = "rbxassetid://6760677364",
							["BEDWARS_PURCHASE_ITEM"] = "rbxassetid://6760677364",
							["SWORD_SWING_1"] = "rbxassetid://1306070008",
							["SWORD_SWING_2"] = "rbxassetid://608537390",
							["DAMAGE_1"] = "rbxassetid://3362346832",
							["DAMAGE_2"] = "rbxassetid://3362346832",
							["DAMAGE_3"] = "rbxassetid://3362346832",
							["CROP_HARVEST"] = "rbxassetid://4864122196",
							["CROP_PLANT_1"] = "rbxassetid://5483943277",
							["CROP_PLANT_2"] = "rbxassetid://5483943479",
							["CROP_PLANT_3"] = "rbxassetid://5483943723",
							["ARMOR_EQUIP"] = "rbxassetid://2706199011",
							["ARMOR_UNEQUIP"] = "rbxassetid://6760625788",
							["PICKUP_ITEM_DROP"] = "rbxassetid://6768578304",
							["PARTY_INCOMING_INVITE"] = "rbxassetid://6732495464",
							["ERROR_NOTIFICATION"] = "rbxassetid://6732495464",
							["INFO_NOTIFICATION"] = "rbxassetid://6732495464",
							["END_GAME"] = "rbxassetid://5857559198",
							["GENERIC_BLOCK_PLACE"] = "rbxassetid://6328287211",
							["GENERIC_BLOCK_BREAK"] = "rbxassetid://4819966893",
							["GRASS_BREAK"] = "rbxassetid://507864112",
							["WOOD_BREAK"] = "rbxassetid://4819966893",
							["STONE_BREAK"] = "rbxassetid://6328287211",
							["WOOL_BREAK"] = "rbxassetid://4819966893",
							["TNT_EXPLODE_1"] = "rbxassetid://3154829820",
							["TNT_HISS_1"] = "rbxassetid://4633141679",
							["FIREBALL_EXPLODE"] = "rbxassetid://7192313632",
							["SLIME_BLOCK_BOUNCE"] = "rbxassetid://6857999096",
							["SLIME_BLOCK_BREAK"] = "rbxassetid://6857999170",
							["SLIME_BLOCK_HIT"] = "rbxassetid://6857999148",
							["SLIME_BLOCK_PLACE"] = "rbxassetid://6857999119",
							["BOW_DRAW"] = "rbxassetid://9125407493",
							["BOW_FIRE"] = "rbxassetid://3442683707",
							["ARROW_HIT"] = "rbxassetid://1053296915",
							["ARROW_IMPACT"] = "rbxassetid://2640195272",
							["TELEPEARL_THROW"] = "rbxassetid://6866223756",
							["TELEPEARL_LAND"] = "rbxassetid://289556450",
							["CROSSBOW_RELOAD"] = "rbxassetid://609345084",
							["VOICE_1"] = "rbxassetid://2699327050",
							["VOICE_2"] = "rbxassetid://5283867710",
							["VOICE_HONK"] = "rbxassetid://5283872555",
							["FORTIFY_BLOCK"] = "rbxassetid://9113131247",
							["EAT_FOOD_1"] = "rbxassetid://5546592140",
							["KILL"] = "rbxassetid://7013482008",
							["ZIPLINE_TRAVEL"] = "rbxassetid://7047882304",
							["ZIPLINE_LATCH"] = "rbxassetid://7047882233",
							["ZIPLINE_UNLATCH"] = "rbxassetid://7047882265",
							["SHIELD_BLOCKED"] = "rbxassetid://6955762535",
							["GUITAR_LOOP"] = "rbxassetid://7084168540",
							["GUITAR_HEAL_1"] = "rbxassetid://7084168458",
							["CANNON_MOVE"] = "rbxassetid://7118668472",
							["CANNON_FIRE"] = "rbxassetid://7121064180",
							["BALLOON_INFLATE"] = "rbxassetid://7118657911",
							["BALLOON_POP"] = "rbxassetid://7118657873",
							["FIREBALL_THROW"] = "rbxassetid://7192289445",
							["LASSO_HIT"] = "rbxassetid://7192289603",
							["LASSO_SWING"] = "rbxassetid://7192289504",
							["LASSO_THROW"] = "rbxassetid://7192289548",
							["GRIM_REAPER_CONSUME"] = "rbxassetid://7225389554",
							["GRIM_REAPER_CHANNEL"] = "rbxassetid://7225389512",
							["TV_STATIC"] = "rbxassetid://7256209920",
							["TURRET_ON"] = "rbxassetid://7290176291",
							["TURRET_OFF"] = "rbxassetid://7290176380",
							["TURRET_ROTATE"] = "rbxassetid://7290176421",
							["TURRET_SHOOT"] = "rbxassetid://7290187805",
							["WIZARD_LIGHTNING_CAST"] = "rbxassetid://7262989886",
							["WIZARD_LIGHTNING_LAND"] = "rbxassetid://7263165647",
							["WIZARD_LIGHTNING_STRIKE"] = "rbxassetid://7263165347",
							["WIZARD_ORB_CAST"] = "rbxassetid://7263165448",
							["WIZARD_ORB_TRAVEL_LOOP"] = "rbxassetid://7263165579",
							["WIZARD_ORB_CONTACT_LOOP"] = "rbxassetid://7263165647",
							["BATTLE_PASS_PROGRESS_LEVEL_UP"] = "rbxassetid://7331597283",
							["BATTLE_PASS_PROGRESS_EXP_GAIN"] = "rbxassetid://7331597220",
							["FLAMETHROWER_UPGRADE"] = "rbxassetid://7310273053",
							["FLAMETHROWER_USE"] = "rbxassetid://7310273125",
							["BRITTLE_HIT"] = "rbxassetid://7310273179",
							["EXTINGUISH"] = "rbxassetid://7310273015",
							["RAVEN_SPACE_AMBIENT"] = "rbxassetid://7341443286",
							["RAVEN_WING_FLAP"] = "rbxassetid://7341443378",
							["RAVEN_CAW"] = "rbxassetid://7341443447",
							["JADE_HAMMER_THUD"] = "rbxassetid://7342299402",
							["STATUE"] = "rbxassetid://7344166851",
							["CONFETTI"] = "rbxassetid://7344278405",
							["HEART"] = "rbxassetid://7345120916",
							["SPRAY"] = "rbxassetid://7361499529",
							["BEEHIVE_PRODUCE"] = "rbxassetid://7378100183",
							["DEPOSIT_BEE"] = "rbxassetid://7378100250",
							["CATCH_BEE"] = "rbxassetid://7378100305",
							["BEE_NET_SWING"] = "rbxassetid://7378100350",
							["ASCEND"] = "rbxassetid://7378387334",
							["BED_ALARM"] = "rbxassetid://5476307813",
							["BOUNTY_CLAIMED"] = "rbxassetid://7396751941",
							["BOUNTY_ASSIGNED"] = "rbxassetid://7396752155",
							["BAGUETTE_HIT"] = "rbxassetid://7396760547",
							["BAGUETTE_SWING"] = "rbxassetid://7396760496",
							["TESLA_ZAP"] = "rbxassetid://5509750509",
							["SPIRIT_TRIGGERED"] = "rbxassetid://7498107251",
							["SPIRIT_EXPLODE"] = "rbxassetid://7498107327",
							["ANGEL_LIGHT_ORB_CREATE"] = "rbxassetid://7552134231",
							["ANGEL_LIGHT_ORB_HEAL"] = "rbxassetid://7552134868",
							["ANGEL_VOID_ORB_CREATE"] = "rbxassetid://7552135942",
							["ANGEL_VOID_ORB_HEAL"] = "rbxassetid://7552136927",
							["DODO_BIRD_JUMP"] = "rbxassetid://7618085391",
							["DODO_BIRD_DOUBLE_JUMP"] = "rbxassetid://7618085771",
							["DODO_BIRD_MOUNT"] = "rbxassetid://7618085486",
							["DODO_BIRD_DISMOUNT"] = "rbxassetid://7618085571",
							["DODO_BIRD_SQUAWK_1"] = "rbxassetid://7618085870",
							["DODO_BIRD_SQUAWK_2"] = "rbxassetid://7618085657",
							["SHIELD_CHARGE_START"] = "rbxassetid://7730842884",
							["SHIELD_CHARGE_LOOP"] = "rbxassetid://7730843006",
							["SHIELD_CHARGE_BASH"] = "rbxassetid://7730843142",
							["ROCKET_LAUNCHER_FIRE"] = "rbxassetid://7681584765",
							["ROCKET_LAUNCHER_FLYING_LOOP"] = "rbxassetid://7681584906",
							["SMOKE_GRENADE_POP"] = "rbxassetid://7681276062",
							["SMOKE_GRENADE_EMIT_LOOP"] = "rbxassetid://7681276135",
							["GOO_SPIT"] = "rbxassetid://7807271610",
							["GOO_SPLAT"] = "rbxassetid://7807272724",
							["GOO_EAT"] = "rbxassetid://7813484049",
							["LUCKY_BLOCK_BREAK"] = "rbxassetid://7682005357",
							["AXOLOTL_SWITCH_TARGETS"] = "rbxassetid://7344278405",
							["HALLOWEEN_MUSIC"] = "rbxassetid://7775602786",
							["SNAP_TRAP_SETUP"] = "rbxassetid://7796078515",
							["SNAP_TRAP_CLOSE"] = "rbxassetid://7796078695",
							["SNAP_TRAP_CONSUME_MARK"] = "rbxassetid://7796078825",
							["GHOST_VACUUM_SUCKING_LOOP"] = "rbxassetid://7814995865",
							["GHOST_VACUUM_SHOOT"] = "rbxassetid://7806060367",
							["GHOST_VACUUM_CATCH"] = "rbxassetid://7815151688",
							["FISHERMAN_GAME_START"] = "rbxassetid://7806060544",
							["FISHERMAN_GAME_PULLING_LOOP"] = "rbxassetid://7806060638",
							["FISHERMAN_GAME_PROGRESS_INCREASE"] = "rbxassetid://7806060745",
							["FISHERMAN_GAME_FISH_MOVE"] = "rbxassetid://7806060863",
							["FISHERMAN_GAME_LOOP"] = "rbxassetid://7806061057",
							["FISHING_ROD_CAST"] = "rbxassetid://7806060976",
							["FISHING_ROD_SPLASH"] = "rbxassetid://7806061193",
							["SPEAR_HIT"] = "rbxassetid://7807270398",
							["SPEAR_THROW"] = "rbxassetid://7813485044",
						}

						task.spawn(function()
							for i,v in pairs(collectionservice:GetTagged("block")) do
								if oldbedwarsblocktab[v.Name] then
									if type(oldbedwarsblocktab[v.Name]) == "table" then
										for i2,v2 in pairs(v:GetDescendants()) do
											if v2:IsA("Texture") then
												if v2.Name == "Top" then
													v2.Texture = oldbedwarsblocktab[v.Name][1]
													v2.Color3 = v.Name == "grass" and Color3.fromRGB(68, 148, 14) or Color3.fromRGB(255, 255, 255)
												elseif v2.Name == "Bottom" then
													v2.Texture = oldbedwarsblocktab[v.Name][2]
												else
													v2.Texture = oldbedwarsblocktab[v.Name][3]
												end
											end
										end
									else
										for i2,v2 in pairs(v:GetDescendants()) do
											if v2:IsA("Texture") then
												v2.Texture = oldbedwarsblocktab[v.Name]
											end
										end
									end
								end
							end
						end)
						game:GetService("CollectionService"):GetInstanceAddedSignal("block"):connect(function(v)
							if oldbedwarsblocktab[v.Name] then
								if type(oldbedwarsblocktab[v.Name]) == "table" then
									for i2,v2 in pairs(v:GetDescendants()) do
										if v2:IsA("Texture") then
											if v2.Name == "Top" then
												v2.Texture = oldbedwarsblocktab[v.Name][1]
												v2.Color3 = v.Name == "grass" and Color3.fromRGB(68, 148, 14) or Color3.fromRGB(255, 255, 255)
											elseif v2.Name == "Bottom" then
												v2.Texture = oldbedwarsblocktab[v.Name][2]
											else
												v2.Texture = oldbedwarsblocktab[v.Name][3]
											end
										end
									end
									v.DescendantAdded:connect(function(v3)
										if v3:IsA("Texture") then
											if v3.Name == "Top" then
												v3.Texture = oldbedwarsblocktab[v.Name][1]
												v3.Color3 = v.Name == "grass" and Color3.fromRGB(68, 148, 14) or Color3.fromRGB(255, 255, 255)
											elseif v3.Name == "Bottom" then
												v3.Texture = oldbedwarsblocktab[v.Name][2]
											else
												v3.Texture = oldbedwarsblocktab[v.Name][3]
											end
										end
									end)
								else
									for i2,v2 in pairs(v:GetDescendants()) do
										if v2:IsA("Texture") then
											v2.Texture = oldbedwarsblocktab[v.Name]
										end
									end
									v.DescendantAdded:connect(function(v3)
										if v3:IsA("Texture") then
											v3.Texture = oldbedwarsblocktab[v.Name]
										end
									end)
								end
							end
						end)
						game:GetService("CollectionService"):GetInstanceAddedSignal("tnt"):connect(function(v)
							if oldbedwarsblocktab[v.Name] then
								if type(oldbedwarsblocktab[v.Name]) == "table" then
									for i2,v2 in pairs(v:GetDescendants()) do
										if v2:IsA("Texture") then
											if v2.Name == "Top" then
												v2.Texture = oldbedwarsblocktab[v.Name][1]
												v2.Color3 = v.Name == "grass" and Color3.fromRGB(115, 255, 28) or Color3.fromRGB(255, 255, 255)
											elseif v2.Name == "Bottom" then
												v2.Texture = oldbedwarsblocktab[v.Name][2]
											else
												v2.Texture = oldbedwarsblocktab[v.Name][3]
											end
										end
									end
									v.DescendantAdded:connect(function(v3)
										if v3:IsA("Texture") then
											if v3.Name == "Top" then
												v3.Texture = oldbedwarsblocktab[v.Name][1]
												v3.Color3 = v.Name == "grass" and Color3.fromRGB(115, 255, 28) or Color3.fromRGB(255, 255, 255)
											elseif v3.Name == "Bottom" then
												v3.Texture = oldbedwarsblocktab[v.Name][2]
											else
												v3.Texture = oldbedwarsblocktab[v.Name][3]
											end
										end
									end)
								else
									for i2,v2 in pairs(v:GetDescendants()) do
										if v2:IsA("Texture") then
											v2.Texture = oldbedwarsblocktab[v.Name]
										end
									end
									v.DescendantAdded:connect(function(v3)
										if v3:IsA("Texture") then
											v3.Texture = oldbedwarsblocktab[v.Name]
										end
									end)
								end
							end
						end)
						for i,v in pairs(bedwars["ItemTable"]) do 
							if oldbedwarsicontab[i] then 
								v.image = oldbedwarsicontab[i]
							end
						end			
						for i,v in pairs(oldbedwarssoundtable) do 
							local item = bedwars["SoundList"][i]
							if item then
								bedwars["SoundList"][i] = v
							end
						end	
						local oldweld = bedwars["WeldTable"].weldCharacterAccessories
						local alreadydone = {}
						bedwars["WeldTable"].weldCharacterAccessories = function(model, ...)
							for i,v in pairs(model:GetChildren()) do
								local died = v.Name == "HumanoidRootPart" and v:FindFirstChild("Died")
								if died then 
									died.Volume = 0
								end
								if oldbedwarsblocktab[v.Name] then
									task.spawn(function()
										local hand = v:WaitForChild("Handle", 10)
										if hand then
											hand.CastShadow = false
										end
										for i2,v2 in pairs(v:GetDescendants()) do
											if v2:IsA("Texture") then
												if v2.Name == "Top" then
													v2.Texture = (type(oldbedwarsblocktab[v.Name]) == "table" and oldbedwarsblocktab[v.Name][1] or oldbedwarsblocktab[v.Name])
													v2.Color3 = v.Name == "grass" and Color3.fromRGB(115, 255, 28) or Color3.fromRGB(255, 255, 255)
												elseif v2.Name == "Bottom" then
													v2.Texture = (type(oldbedwarsblocktab[v.Name]) == "table" and oldbedwarsblocktab[v.Name][2] or oldbedwarsblocktab[v.Name])
												else
													v2.Texture = (type(oldbedwarsblocktab[v.Name]) == "table" and oldbedwarsblocktab[v.Name][3] or oldbedwarsblocktab[v.Name])
												end
											end
										end
										v.DescendantAdded:connect(function(v3)
											if v3:IsA("Texture") then
												if v3.Name == "Top" then
													v3.Texture = (type(oldbedwarsblocktab[v.Name]) == "table" and oldbedwarsblocktab[v.Name][1] or oldbedwarsblocktab[v.Name])
													v3.Color3 = v.Name == "grass" and Color3.fromRGB(115, 255, 28) or Color3.fromRGB(255, 255, 255)
												elseif v3.Name == "Bottom" then
													v3.Texture = (type(oldbedwarsblocktab[v.Name]) == "table" and oldbedwarsblocktab[v.Name][2] or oldbedwarsblocktab[v.Name])
												else
													v3.Texture = (type(oldbedwarsblocktab[v.Name]) == "table" and oldbedwarsblocktab[v.Name][3] or oldbedwarsblocktab[v.Name])
												end
											end
										end)
									end)
								end
							end
							return oldweld(model, ...)
						end
						for i, v in pairs(game.Workspace.Map.Worlds:GetDescendants()) do
    							if v.ClassName == "Texture" then
        							if v.Parent.Name == "wool_pink" then
            								v.Texture = "http://www.roblox.com/asset/?id=10449237078"
            								v.Parent.Transparency = 0.7 -- what ever u want it to be lol
        							end
    							end
						end
						for i, v in pairs(game.Workspace.Map.Worlds:GetDescendants()) do
    							if v.ClassName == "Texture" then
        							if v.Parent.Name == "clay_dark_green" then
            								v.Texture = "http://www.roblox.com/asset/?id=10464522235"
            								v.Parent.Transparency = 1 -- what ever u want it to be lol
        							end
    							end
						end
						local damagetab = debug.getupvalue(bedwars["DamageIndicator"], 2)
						damagetab.strokeThickness = false
						damagetab.textSize = 32
						damagetab.blowUpDuration = 0
						damagetab.baseColor = Color3.fromRGB(214, 0, 0)
						damagetab.blowUpSize = 32
						damagetab.blowUpCompleteDuration = 0
						damagetab.anchoredDuration = 0
						debug.setconstant(bedwars["ViewmodelController"].show, 37, "")
						debug.setconstant(bedwars["DamageIndicator"], 81, Enum.Font.LuckiestGuy)
						debug.setconstant(bedwars["DamageIndicator"], 100, "Enabled")
						debug.setconstant(bedwars["DamageIndicator"], 116, 0.3)
						debug.setconstant(bedwars["DamageIndicator"], 126, 0.5)
						debug.setupvalue(bedwars["DamageIndicator"], 10, {
							Create = function(self, obj, ...)
								task.spawn(function()
									obj.Parent.Parent.Parent.Parent.Velocity = vec3((math.random(-50, 50) / 100) * damagetab.velX, (math.random(50, 60) / 100) * damagetab.velY, (math.random(-50, 50) / 100) * damagetab.velZ)
									local textcompare = obj.Parent.TextColor3
									if textcompare ~= Color3.fromRGB(85, 255, 85) then
										local newtween = game:GetService("TweenService"):Create(obj.Parent, TweenInfo.new(0.5, Enum.EasingStyle.Linear), {
											TextColor3 = (textcompare == Color3.fromRGB(76, 175, 93) and Color3.new(0, 0, 0) or Color3.new(1, 1, 1))
										})
										task.wait(0.15)
										newtween:Play()
									end
								end)
								return game:GetService("TweenService"):Create(obj, ...)
							end
						})
						sethiddenproperty(lighting, "Technology", "ShadowMap")
						lighting.Ambient = Color3.new(0, 0, 0)
						lighting.Brightness = 0
						lighting.EnvironmentDiffuseScale = 0.1
						lighting.EnvironmentSpecularScale = 0.1
						lighting.OutdoorAmbient = Color3.fromRGB(100, 100, 100)
						lighting.Atmosphere.Density = 0.45
						lighting.Atmosphere.Offset = 0
						lighting.Atmosphere.Color = Color3.fromRGB(193, 193, 193)
						lighting.Atmosphere.Decay = Color3.fromRGB(104, 112, 124)
						lighting.Atmosphere.Glare = 0
						lighting.Atmosphere.Haze = 0
						lighting.ClockTime = 6.3
						lighting.GeographicLatitude = -7
						lighting.GlobalShadows = true
						lighting.TimeOfDay = "06:18:00"
						lighting.Sky.SkyboxBk = "http://www.roblox.com/asset/?id=9851144466"
						lighting.Sky.SkyboxDn = "http://www.roblox.com/asset/?id=9851144249"
						lighting.Sky.SkyboxFt = "http://www.roblox.com/asset/?id=9851144099"
						lighting.Sky.SkyboxLf = "http://www.roblox.com/asset/?id=9851143942"
						lighting.Sky.SkyboxRt = "http://www.roblox.com/asset/?id=9851143761"
						lighting.Sky.SkyboxUp = "http://www.roblox.com/asset/?id=9851143257"
					end)
				else
					TexturePack["ToggleButton"](false)
				end
			else
				createwarning("TexturePack", "Disabled Next Game", 10)
			end
		end
	})
end)

runcode(function()
	GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
		["Name"] = "VoidTheme",
		["Function"] = function(callback)
			if callback then
				task.spawn(function()
					for i,v in pairs(lighting:GetChildren()) do
						if v:IsA("Atmosphere") or v:IsA("Sky") or v:IsA("PostEffect") then
							v:Remove()
						end
					end
					local sky = Instance.new("Sky")
					sky.StarCount = 5000
					sky.SkyboxUp = "http://www.roblox.com/asset/?id=9851143257"
					sky.SkyboxLf = "http://www.roblox.com/asset/?id=9851143942"
					sky.SkyboxFt = "http://www.roblox.com/asset/?id=9851144099"
					sky.SkyboxBk = "http://www.roblox.com/asset/?id=9851144466"
					sky.SkyboxDn = "http://www.roblox.com/asset/?id=9851144249"
					sky.SkyboxRt = "http://www.roblox.com/asset/?id=9851143761"
					sky.MoonTextureId = "rbxassetid://8139665943"
					sky.MoonAngularSize = 30
					sky.Parent = lighting
					local bloom = Instance.new("BloomEffect")
					bloom.Threshold = 2
					bloom.Intensity = 1
					bloom.Size = 2
					bloom.Parent = lighting
					local atmosphere = Instance.new("Atmosphere")
					atmosphere.Density = 0.3
					atmosphere.Offset = 0.25
					atmosphere.Color = Color3.fromRGB(193, 193, 193)
					atmosphere.Decay = Color3.fromRGB(104, 112, 124)
					atmosphere.Glare = 0
					atmosphere.Haze = 0
					atmosphere.Parent = lighting
					TimeOfDay = "06:18:00"
					ClockTime = 6.3
					GeographicLatitude = -7
					globalshadows = true
				end)
			end
		end
	})
end)

runcode(function()
	local trollage
	local remote = bedwars["ClientHandler"]:Get(bedwars["PickupRemote"])
	local ServerCrasher = {["Enabled"] = false}
	ServerCrasher = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
		["Name"] = "LagbackAllLoop",
		["Function"] = function(callback)
			if callback then
				task.spawn(function()
					if not trollage then 
						trollage = {}
						local lasttbl
						for i = 1,150000 do
							trollage[#trollage+1] = (lasttbl or {})
							lasttbl = trollage[#trollage]
						end
					end
					repeat
						task.wait(0.3)
						task.spawn(function() 
							pcall(function() remote:CallServer(trollage) end)
						end)
					until (not ServerCrasher["Enabled"])
				end)
			end
		end
	})
	local ServerCrasher2 = {["Enabled"] = false}
	ServerCrasher2 = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
		["Name"] = "LagbackAll",
		["Function"] = function(callback)
			if callback then
				task.spawn(function()
					if not trollage then 
						trollage = {}
						local lasttbl
						for i = 1,150000 do
							trollage[#trollage+1] = (lasttbl or {})
							lasttbl = trollage[#trollage]
						end
					end
					for i = 1, 15 do 
						task.wait(0.3)
						task.spawn(function() 
							pcall(function() remote:CallServer(trollage) end)
						end)
					end
				end)
				ServerCrasher2["ToggleButton"](false)
			end
		end
	})
end)

runcode(function()
	local chatdisabler = {["Enabled"] = false}
	chatdisabler = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
		["Name"] = "ChatDisabler",
		["HoverText"] = "Disables chat 90% of the time",
		["Function"] = function(callback)
			 if callback then
                          chatdisabler["ToggleButton"](false)
                          createwarning("CatV5", "Chat delayed/disabled while running", 150)
                        	 local count = 60
                           	 repeat
                              	 wait(2.5)
                               	 count = count - 1
                              	game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(" ", "All")
                          	until count == 0
		 	end
          	  end
        })
end)

runcode(function()
	local ChinaHat = {["Enabled"] = false}
	local ChinaHatColor = {["Hue"] = 1,["Sat"]=1,["Value"]=0.33}
	local chinahattrail
	local chinahatattachment
	local chinahatattachment2
	ChinaHat = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
		["Name"] = "ChinaHat",
		["Function"] = function(callback)
			if callback then
				RunLoops:BindToHeartbeat("ChinaHat", 1, function()
					if entity.isAlive then
						if chinahattrail == nil or chinahattrail.Parent == nil then
							chinahattrail = Instance.new("Part")
							chinahattrail.CFrame = entity.character.Head.CFrame * cfnew(0, 1.1, 0)
							chinahattrail.Size = vec3(3, 0.7, 3)
							chinahattrail.Name = "ChinaHat"
							chinahattrail.Material = Enum.Material.Neon
							chinahattrail.Color = Color3.fromHSV(ChinaHatColor["Hue"], ChinaHatColor["Sat"], ChinaHatColor["Value"])
							chinahattrail.CanCollide = false
							chinahattrail.Transparency = 0.17
							local chinahatmesh = Instance.new("SpecialMesh")
							chinahatmesh.Parent = chinahattrail
							chinahatmesh.MeshId = "http://www.roblox.com/asset/?id=7830250750"
							chinahatmesh.TextureId = "http://www.roblox.com/asset/?id=7830250846"
							chinahatmesh.Scale = vec3(0.95, 0.9, 0.952)
							chinahattrail.Parent = workspace.Camera
						end
						chinahattrail.CFrame = entity.character.Head.CFrame * cfnew(0, 1.1, 0)
						chinahattrail.Velocity = Vector3.zero
						chinahattrail.LocalTransparencyModifier = ((cam.CFrame.Position - cam.Focus.Position).Magnitude <= 0.6 and 1 or 0)
					else
						if chinahattrail then 
							chinahattrail:Remove()
							chinahattrail = nil
						end
					end
				end)
			else
				RunLoops:UnbindFromHeartbeat("ChinaHat")
				if chinahattrail then
					chinahattrail:Remove()
					chinahattrail = nil
				end
			end
		end,
		["HoverText"] = "Puts a china hat on your character (ty daddydawn)"
	})
	ChinaHatColor = ChinaHat.CreateColorSlider({
		["Name"] = "Hat Color",
		["Function"] = function(h, s, v) 
			if chinahattrail then 
				chinahattrail.Color = Color3.fromHSV(h, s, v)
			end
		end
	})
end)

runcode(function()
	GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
		["Name"] = "WinterTheme",
		["Function"] = function(callback)
			if callback then
				task.spawn(function()
					for i,v in pairs(lighting:GetChildren()) do
						if v:IsA("Atmosphere") or v:IsA("Sky") or v:IsA("PostEffect") then
							v:Remove()
						end
					end
					local sky = Instance.new("Sky")
					sky.StarCount = 5000
					sky.SkyboxUp = "rbxassetid://8139676647"
					sky.SkyboxLf = "rbxassetid://8139676988"
					sky.SkyboxFt = "rbxassetid://8139677111"
					sky.SkyboxBk = "rbxassetid://8139677359"
					sky.SkyboxDn = "rbxassetid://8139677253"
					sky.SkyboxRt = "rbxassetid://8139676842"
					sky.SunTextureId = "rbxassetid://6196665106"
					sky.SunAngularSize = 11
					sky.MoonTextureId = "rbxassetid://8139665943"
					sky.MoonAngularSize = 30
					sky.Parent = lighting
					local sunray = Instance.new("SunRaysEffect")
					sunray.Intensity = 0.03
					sunray.Parent = lighting
					local bloom = Instance.new("BloomEffect")
					bloom.Threshold = 2
					bloom.Intensity = 1
					bloom.Size = 2
					bloom.Parent = lighting
					local atmosphere = Instance.new("Atmosphere")
					atmosphere.Density = 0.3
					atmosphere.Offset = 0.25
					atmosphere.Color = Color3.fromRGB(198, 198, 198)
					atmosphere.Decay = Color3.fromRGB(104, 112, 124)
					atmosphere.Glare = 0
					atmosphere.Haze = 0
					atmosphere.Parent = lighting
				end)
				task.spawn(function()
					local snowpart = Instance.new("Part")
					snowpart.Size = vec3(240, 0.5, 240)
					snowpart.Name = "SnowParticle"
					snowpart.Transparency = 1
					snowpart.CanCollide = false
					snowpart.Position = vec3(0, 120, 286)
					snowpart.Anchored = true
					snowpart.Parent = workspace
					local snow = Instance.new("ParticleEmitter")
					snow.RotSpeed = NumberRange.new(300)
					snow.VelocitySpread = 35
					snow.Rate = 28
					snow.Texture = "rbxassetid://8158344433"
					snow.Rotation = NumberRange.new(110)
					snow.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,0.16939899325371,0),NumberSequenceKeypoint.new(0.23365999758244,0.62841498851776,0.37158501148224),NumberSequenceKeypoint.new(0.56209099292755,0.38797798752785,0.2771390080452),NumberSequenceKeypoint.new(0.90577298402786,0.51912599802017,0),NumberSequenceKeypoint.new(1,1,0)})
					snow.Lifetime = NumberRange.new(8,14)
					snow.Speed = NumberRange.new(8,18)
					snow.EmissionDirection = Enum.NormalId.Bottom
					snow.SpreadAngle = Vector2.new(35,35)
					snow.Size = NumberSequence.new({NumberSequenceKeypoint.new(0,0,0),NumberSequenceKeypoint.new(0.039760299026966,1.3114800453186,0.32786899805069),NumberSequenceKeypoint.new(0.7554469704628,0.98360699415207,0.44038599729538),NumberSequenceKeypoint.new(1,0,0)})
					snow.Parent = snowpart
					local windsnow = Instance.new("ParticleEmitter")
					windsnow.Acceleration = vec3(0,0,1)
					windsnow.RotSpeed = NumberRange.new(100)
					windsnow.VelocitySpread = 35
					windsnow.Rate = 28
					windsnow.Texture = "rbxassetid://8158344433"
					windsnow.EmissionDirection = Enum.NormalId.Bottom
					windsnow.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,0.16939899325371,0),NumberSequenceKeypoint.new(0.23365999758244,0.62841498851776,0.37158501148224),NumberSequenceKeypoint.new(0.56209099292755,0.38797798752785,0.2771390080452),NumberSequenceKeypoint.new(0.90577298402786,0.51912599802017,0),NumberSequenceKeypoint.new(1,1,0)})
					windsnow.Lifetime = NumberRange.new(8,14)
					windsnow.Speed = NumberRange.new(8,18)
					windsnow.Rotation = NumberRange.new(110)
					windsnow.SpreadAngle = Vector2.new(35,35)
					windsnow.Size = NumberSequence.new({NumberSequenceKeypoint.new(0,0,0),NumberSequenceKeypoint.new(0.039760299026966,1.3114800453186,0.32786899805069),NumberSequenceKeypoint.new(0.7554469704628,0.98360699415207,0.44038599729538),NumberSequenceKeypoint.new(1,0,0)})
					windsnow.Parent = snowpart
					for i = 1, 30 do
						for i2 = 1, 30 do
							local clone = snowpart:Clone()
							clone.Position = vec3(240 * (i - 1), 120, 240 * (i2 - 1))
							clone.Parent = workspace
						end
					end
				end)
			else
				for i,v in pairs(lighting:GetChildren()) do
					if v:IsA("Atmosphere") or v:IsA("Sky") or v:IsA("PostEffect") then
						v:Remove()
					end
				end
				for i,v in pairs(game:GetService("Workspace"):GetChildren()) do
					if v.Name == "SnowParticle" then
						v:Remove()
					end
				end
			end
		end
	})
end)

runcode(function()
	local autoheal = {["Enabled"] = false}
	local autohealval = {["Value"] = 100}
	local autohealspeed = {["Enabled"] = true}
	local autohealdelay = tick()
	local function autohealfunc()
		if entity.isAlive then
			local speedpotion = getItem("speed_potion")
			if lplr.Character:GetAttribute("Health") <= (lplr.Character:GetAttribute("MaxHealth") - (100 - autohealval["Value"])) then
				autobankapple = true
				local item = getItem("apple")
				local pot = getItem("heal_splash_potion")
				if (item or pot) and autohealdelay <= tick() then
					if item then
						bedwars["ClientHandler"]:Get(bedwars["EatRemote"]):CallServerAsync({
							["item"] = item["tool"]
						})
						autohealdelay = tick() + 0.6
					else
						local newray = workspace:Raycast((oldcloneroot or entity.character.HumanoidRootPart).Position, vec3(0, -76, 0), blockraycast)
						if newray ~= nil then
							bedwars["ClientHandler"]:Get(bedwars["ProjectileRemote"]):CallServerAsync(pot["tool"], "heal_splash_potion", "heal_splash_potion", (oldcloneroot or entity.character.HumanoidRootPart).Position, (oldcloneroot or entity.character.HumanoidRootPart).Position, vec3(0, -70, 0), game:GetService("HttpService"):GenerateGUID(), {drawDurationSeconds = 1})
						end
					end
				end
			else
				autobankapple = false
			end
			if speedpotion and (not lplr.Character:GetAttribute("StatusEffect_speed")) and autohealspeed["Enabled"] then 
				bedwars["ClientHandler"]:Get(bedwars["EatRemote"]):CallServerAsync({
					["item"] = speedpotion["tool"]
				})
			end
			if lplr.Character:GetAttribute("Shield_POTION") and ((not lplr.Character:GetAttribute("Shield_POTION")) or lplr.Character:GetAttribute("Shield_POTION") == 0) then
				local shield = getItem("big_shield") or getItem("mini_shield")
				if shield then
					bedwars["ClientHandler"]:Get(bedwars["EatRemote"]):CallServerAsync({
						["item"] = shield["tool"]
					})
				end
			end
		end
	end
	autoheal = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
		["Name"] = "AutoConsume",
		["Function"] = function(callback)
			if callback then
				task.spawn(function()
					repeat
						task.wait(0.1)
						autohealfunc()
					until (not autoheal["Enabled"])
				end)
			end
		end,
		["HoverText"] = "Automatically heals for you when health or shield is under threshold."
	})
	autohealval = autoheal.CreateSlider({
		["Name"] = "Health",
		["Min"] = 1,
		["Max"] = 99,
		["Default"] = 70,
		["Function"] = function() end
	})
	autohealspeed = autoheal.CreateToggle({
		["Name"] = "Speed Potions",
		["Function"] = function() end,
		["Default"] = true
	})
end)

GuiLibrary["RemoveObject"]("CapeOptionsButton")
runcode(function()
	local vapecapeconnection
	GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
		["Name"] = "Cape",
		["Function"] = function(callback)
			if callback then
				vapecapeconnection = lplr.CharacterAdded:connect(function(char)
					task.spawn(function()
						pcall(function() 
							Cape(char, getcustomassetfunc("XyloWare/assets/VapeCape.png"))
						end)
					end)
				end)
				if lplr.Character then
					task.spawn(function()
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
	tpstring = shared.vapeoverlay or nil
	local origtpstring = tpstring
	local Overlay = GuiLibrary.CreateCustomWindow({
		["Name"] = "Overlay", 
		["Icon"] = "vape/assets/TargetIcon1.png",
		["IconSize"] = 16
	})
	local overlayframe = Instance.new("Frame")
	overlayframe.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	overlayframe.Size = UDim2.new(0, 200, 0, 120)
	overlayframe.Position = UDim2.new(0, 0, 0, 5)
	overlayframe.Parent = Overlay.GetCustomChildren()
	local overlayframe2 = Instance.new("Frame")
	overlayframe2.Size = UDim2.new(1, 0, 0, 10)
	overlayframe2.Position = UDim2.new(0, 0, 0, -5)
	overlayframe2.Parent = overlayframe
	local overlayframe3 = Instance.new("Frame")
	overlayframe3.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	overlayframe3.Size = UDim2.new(1, 0, 0, 6)
	overlayframe3.Position = UDim2.new(0, 0, 0, 6)
	overlayframe3.BorderSizePixel = 0
	overlayframe3.Parent = overlayframe2
	local oldguiupdate = GuiLibrary["UpdateUI"]
	GuiLibrary["UpdateUI"] = function(...)
		overlayframe2.BackgroundColor3 = Color3.fromHSV(GuiLibrary["Settings"]["GUIObject"]["Color"], 0.7, 0.9)
		return oldguiupdate(...)
	end
	local framecorner1 = Instance.new("UICorner")
	framecorner1.CornerRadius = UDim.new(0, 5)
	framecorner1.Parent = overlayframe
	local framecorner2 = Instance.new("UICorner")
	framecorner2.CornerRadius = UDim.new(0, 5)
	framecorner2.Parent = overlayframe2
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -7, 1, -5)
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextYAlignment = Enum.TextYAlignment.Top
	label.Font = Enum.Font.GothamBold
	label.LineHeight = 1.2
	label.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	label.TextSize = 16
	label.Text = ""
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(200, 200, 200)
	label.Position = UDim2.new(0, 7, 0, 5)
	label.Parent = overlayframe
	Overlay["Bypass"] = true
	local oldnetworkowner
	local teleported = {}
	local teleported2 = {}
	local teleportconnections = {}
	local pinglist = {}
	local fpslist = {}
	local matchstatechanged = 0
	local mapname = "to4_Blossom"

	task.spawn(function()
		mapname = workspace:WaitForChild("Map"):WaitForChild("Worlds"):GetChildren()[1].Name
		mapname = string.gsub(string.split(mapname, "_")[2] or mapname, "-", "") or "Blank"
	end)
	task.spawn(function()
		bedwars["ClientHandler"]:OnEvent("ProjectileImpact", function(p3)
			if uninjectflag then return end
			if p3.projectile == "telepearl" then 
				teleported[p3.shooterPlayer] = true
			elseif p3.projectile == "swap_ball" then
				teleported[p3.shooterPlayer] = true
				if p3.hitEntity then 
					local plr = players:GetPlayerFromCharacter(p3.hitEntity)
					if plr then teleported[plr] = true end
				end
			end
		end)

		local function didpingspike()
			local currentpingcheck = pinglist[1] or math.floor(tonumber(game:GetService("Stats"):FindFirstChild("PerformanceStats").Ping:GetValue()))
			for i,v in pairs(pinglist) do 
				if v ~= currentpingcheck and math.abs(v - currentpingcheck) >= 100 then 
					return currentpingcheck.." => "..v.." ping"
				else
					currentpingcheck = v
				end
			end
			return nil
		end

		local function notlasso()
			for i,v in pairs(collectionservice:GetTagged("LassoHooked")) do 
				if v == lplr.Character then 
					return false
				end
			end
			return true
		end
		repeat
			local ping = math.floor(tonumber(game:GetService("Stats"):FindFirstChild("PerformanceStats").Ping:GetValue()))
			if #pinglist >= 10 then 
				table.remove(pinglist, 1)
			end
			table.insert(pinglist, ping)
			wait(1)
			if matchState ~= matchstatechanged then 
				if matchState == 1 then 
					matchstatetick = tick() + 3
				end
				matchstatechanged = matchState
			end
			if not tpstring then
				tpstring = tick().."/"..kills.."/"..beds.."/"..(victorysaid and 1 or 0).."/"..(1).."/"..(0).."/"..(0).."/"..(0)
				origtpstring = tpstring
			end
			if entity.isAlive and (not oldcloneroot) and networkownerfunc then 
				local newnetworkowner = networkownerfunc(entity.character.HumanoidRootPart)
				if oldnetworkowner ~= nil and oldnetworkowner ~= newnetworkowner and newnetworkowner == false and notlasso() then 
					local falseflag = didpingspike()
					if falseflag then 
						createwarning("AnticheatBypass", "Lagspike Detected : "..falseflag, 10)
					else
						lagbacks = lagbacks + 1
					end
				end
				oldnetworkowner = newnetworkowner
			else
				oldnetworkowner = nil
			end
			for i,v in pairs(entity.entityList) do 
				if teleportconnections[v.Player.Name.."1"] then continue end
				teleportconnections[v.Player.Name.."1"] = v.Player:GetAttributeChangedSignal("LastTeleported"):connect(function()
					if uninjectflag then return end
					for i = 1, 15 do 
						task.wait(0.1)
						if teleported[v.Player] or teleported2[v.Player] or matchstatetick > tick() or math.abs(v.Player:GetAttribute("SpawnTime") - v.Player:GetAttribute("LastTeleported")) < 3 then break end
					end
					if v.Player ~= nil and teleported[v.Player] == nil and teleported2[v.Player] == nil and math.abs(v.Player:GetAttribute("SpawnTime") - v.Player:GetAttribute("LastTeleported")) > 3 and matchstatetick <= tick() then 
						otherlagbacks = otherlagbacks + 1
						lagbackevent:Fire(v.Player)
					end
					teleported[v.Player] = nil
				end)
				teleportconnections[v.Player.Name.."2"] = v.Player:GetAttributeChangedSignal("PlayerConnected"):connect(function()
					teleported2[v.Player] = true
					task.delay(5, function()
						teleported2[v.Player] = nil
					end)
				end)
			end
			local splitted = origtpstring:split("/")
			label.Text = "Session Info\nTime Played : "..os.date("!%X",math.floor(tick() - splitted[1])).."\nKills : "..(splitted[2] + kills).."\nBeds : "..(splitted[3] + beds).."\nWins : "..(splitted[4] + (victorysaid and 1 or 0)).."\nGames : "..splitted[5].."\nLagbacks : "..(splitted[6] + lagbacks).."\nUniversal Lagbacks : "..(splitted[7] + otherlagbacks).."\nReported : "..(splitted[8] + reported).."\nMap : "..mapname
			local textsize = textservice:GetTextSize(label.Text, label.TextSize, label.Font, Vector2.new(9e9, 9e9))
			overlayframe.Size = UDim2.new(0, math.max(textsize.X + 19, 200), 0, (textsize.Y * 1.2) + 10)
			tpstring = splitted[1].."/"..(splitted[2] + kills).."/"..(splitted[3] + beds).."/"..(splitted[4] + (victorysaid and 1 or 0)).."/"..(splitted[5] + 1).."/"..(splitted[6] + lagbacks).."/"..(splitted[7] + otherlagbacks).."/"..(splitted[8] + reported)
		until uninjectflag
	end)

	GuiLibrary["ObjectsThatCanBeSaved"]["GUIWindow"]["Api"].CreateCustomToggle({
		["Name"] = "Overlay", 
		["Icon"] = "XyloWare/assets/TargetIcon1.png", 
		["Function"] = function(callback)
			Overlay.SetVisible(callback) 
		end, 
		["Priority"] = 2
	})
end)

runcode(function()
	local vapecapeconnection
	GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
		["Name"] = "DragonWings",
		["Function"] = function(callback)
			if callback then
				vapecapeconnection = lplr.CharacterAdded:connect(function(char)
					task.spawn(function()
						pcall(function() 
							Wings(char, getcustomassetfunc("XyloWare/assets/DragonWing.png"))
						end)
					end)
				end)
				if lplr.Character then
					task.spawn(function()
						pcall(function() 
							Wings(lplr.Character, getcustomassetfunc("XyloWare/assets/DragonWing.png"))
						end)
					end)
				end
			else
				if vapecapeconnection then
					vapecapeconnection:Disconnect()
				end
				if lplr.Character then
					for i,v in pairs(lplr.Character:GetDescendants()) do
						if v.Name == "DragonWings" then
							v:Remove()
						end
					end
				end
			end
		end
	})
end)

runcode(function()
	local CameraFix = {["Enabled"] = false}
	CameraFix = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
		["Name"] = "GameFixer",
		["Function"] = function(callback)
			if callback then
				task.spawn(function()
					repeat task.wait() until matchState ~= 0
					if bedwars["ClientStoreHandler"]:getState().Game.customMatch == nil and CameraFix["Enabled"] then 
						debug.setconstant(bedwars["QueueCard"].render, 9, 0.1)
					end
				end)
				task.spawn(function()
					repeat
						task.wait()
						if (not CameraFix["Enabled"]) then break end
						UserSettings():GetService("UserGameSettings").RotationType = ((cam.CFrame.Position - cam.Focus.Position).Magnitude <= 0.5 and Enum.RotationType.CameraRelative or Enum.RotationType.MovementRelative)
					until (not CameraFix["Enabled"])
				end)
			else
				debug.setconstant(bedwars["QueueCard"].render, 9, 0.01)
			end
		end,
		["HoverText"] = "Fixes game bugs"
	})
end)

runcode(function()
	local transformed = false
	local OldBedwars = {["Enabled"] = false}
	OldBedwars = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
		["Name"] = "OldBedwars",
		["Function"] = function(callback) 
			if callback then 
				if not transformed then
					transformed = true
					task.spawn(function()
						local oldbedwarstabofblocks = '{"wool_blue":"rbxassetid://5089281898","wool_pink":"rbxassetid://6856183009","clay_pink":"rbxassetid://6856283410","grass":["rbxassetid://6812582110","rbxassetid://6812616868","rbxassetid://6812616868","rbxassetid://6812616868","rbxassetid://6812616868","rbxassetid://6812616868"],"snow":"rbxassetid://6874651192","wool_cyan":"rbxassetid://6177124865","red_sandstone":"rbxassetid://6708703895","wool_green":"rbxassetid://6177123316","clay_black":"rbxassetid://5890435474","sand":"rbxassetid://6187018940","wool_orange":"rbxassetid://6177122584","hickory_log":"rbxassetid://6879467811","wood_plank_birch":"rbxassetid://6768647328","clay_gray":"rbxassetid://7126965624","wood_plank_spruce":"rbxassetid://6768615964","brick":"rbxassetid://6782607284","clay_dark_brown":"rbxassetid://6874651325","stone_brick":"rbxassetid://6710700118","ceramic":"rbxassetid://6875522401","clay_blue":"rbxassetid://4991097126","wood_plank_maple":"rbxassetid://6768632085","diamond_block":"rbxassetid://6734061546","wood_plank_oak":"rbxassetid://6768575772","ice":"rbxassetid://6874651262","marble":"rbxassetid://6594536339","spruce_log":"rbxassetid://6874161124","oak_log":"rbxassetid://6879467811","clay_light_brown":"rbxassetid://6874651634","clay_dark_green":"rbxassetid://6812653448","marble_pillar":["rbxassetid://6909328433","rbxassetid://6909328433","rbxassetid://6909323822","rbxassetid://6909323822","rbxassetid://6909323822","rbxassetid://6909323822"],"slate_brick":"rbxassetid://6708836267","obsidian":"rbxassetid://6855476765","iron_block":"rbxassetid://6734050333","wool_red":"rbxassetid://5089281973","clay_purple":"rbxassetid://6856099740","clay_orange":"rbxassetid://7017703219","clay_red":"rbxassetid://6856283323","wool_yellow":"rbxassetid://6829151816","tnt":["rbxassetid://6889157997","rbxassetid://6889157997","rbxassetid://6855533421","rbxassetid://6855533421","rbxassetid://6855533421","rbxassetid://6855533421"],"clay_yellow":"rbxassetid://4991097283","clay_white":"rbxassetid://7017705325","wool_purple":"rbxassetid://6177125247","sandstone":"rbxassetid://6708657090","wool_white":"rbxassetid://5089287375","clay_light_green":"rbxassetid://6856099550","birch_log":"rbxassetid://6856088949","emerald_block":"rbxassetid://6856082835","clay":"rbxassetid://6856190168","stone":"rbxassetid://6812635290","slime_block":"rbxassetid://6869286145"}'
						local oldbedwarsblocktab = game:GetService("HttpService"):JSONDecode(oldbedwarstabofblocks)
						local oldbedwarstabofimages = '{"clay_orange":"rbxassetid://7017703219","iron":"rbxassetid://6850537969","glass":"rbxassetid://6909521321","log_spruce":"rbxassetid://6874161124","ice":"rbxassetid://6874651262","marble":"rbxassetid://6594536339","zipline_base":"rbxassetid://7051148904","iron_helmet":"rbxassetid://6874272559","marble_pillar":"rbxassetid://6909323822","clay_dark_green":"rbxassetid://6763635916","wood_plank_birch":"rbxassetid://6768647328","watering_can":"rbxassetid://6915423754","emerald_helmet":"rbxassetid://6931675766","pie":"rbxassetid://6985761399","wood_plank_spruce":"rbxassetid://6768615964","diamond_chestplate":"rbxassetid://6874272898","wool_pink":"rbxassetid://6910479863","wool_blue":"rbxassetid://6910480234","wood_plank_oak":"rbxassetid://6910418127","diamond_boots":"rbxassetid://6874272964","clay_yellow":"rbxassetid://4991097283","tnt":"rbxassetid://6856168996","lasso":"rbxassetid://7192710930","clay_purple":"rbxassetid://6856099740","melon_seeds":"rbxassetid://6956387796","apple":"rbxassetid://6985765179","carrot_seeds":"rbxassetid://6956387835","log_oak":"rbxassetid://6763678414","emerald_chestplate":"rbxassetid://6931675868","wool_yellow":"rbxassetid://6910479606","emerald_boots":"rbxassetid://6931675942","clay_light_brown":"rbxassetid://6874651634","balloon":"rbxassetid://7122143895","cannon":"rbxassetid://7121221753","leather_boots":"rbxassetid://6855466456","melon":"rbxassetid://6915428682","wool_white":"rbxassetid://6910387332","log_birch":"rbxassetid://6763678414","clay_pink":"rbxassetid://6856283410","grass":"rbxassetid://6773447725","obsidian":"rbxassetid://6910443317","shield":"rbxassetid://7051149149","red_sandstone":"rbxassetid://6708703895","diamond_helmet":"rbxassetid://6874272793","wool_orange":"rbxassetid://6910479956","log_hickory":"rbxassetid://7017706899","guitar":"rbxassetid://7085044606","wool_purple":"rbxassetid://6910479777","diamond":"rbxassetid://6850538161","iron_chestplate":"rbxassetid://6874272631","slime_block":"rbxassetid://6869284566","stone_brick":"rbxassetid://6910394475","hammer":"rbxassetid://6955848801","ceramic":"rbxassetid://6910426690","wood_plank_maple":"rbxassetid://6768632085","leather_helmet":"rbxassetid://6855466216","stone":"rbxassetid://6763635916","slate_brick":"rbxassetid://6708836267","sandstone":"rbxassetid://6708657090","snow":"rbxassetid://6874651192","wool_red":"rbxassetid://6910479695","leather_chestplate":"rbxassetid://6876833204","clay_red":"rbxassetid://6856283323","wool_green":"rbxassetid://6910480050","clay_white":"rbxassetid://7017705325","wool_cyan":"rbxassetid://6910480152","clay_black":"rbxassetid://5890435474","sand":"rbxassetid://6187018940","clay_light_green":"rbxassetid://6856099550","clay_dark_brown":"rbxassetid://6874651325","carrot":"rbxassetid://3677675280","clay":"rbxassetid://6856190168","iron_boots":"rbxassetid://6874272718","emerald":"rbxassetid://6850538075","zipline":"rbxassetid://7051148904"}'
						local oldbedwarsicontab = game:GetService("HttpService"):JSONDecode(oldbedwarstabofimages)
						local oldbedwarssoundtable = {
							["QUEUE_JOIN"] = "rbxassetid://6691735519",
							["QUEUE_MATCH_FOUND"] = "rbxassetid://6768247187",
							["UI_CLICK"] = "rbxassetid://6732690176",
							["UI_OPEN"] = "rbxassetid://6732607930",
							["BEDWARS_UPGRADE_SUCCESS"] = "rbxassetid://6760677364",
							["BEDWARS_PURCHASE_ITEM"] = "rbxassetid://6760677364",
							["SWORD_SWING_1"] = "rbxassetid://6760544639",
							["SWORD_SWING_2"] = "rbxassetid://6760544595",
							["DAMAGE_1"] = "rbxassetid://6765457325",
							["DAMAGE_2"] = "rbxassetid://6765470975",
							["DAMAGE_3"] = "rbxassetid://6765470941",
							["CROP_HARVEST"] = "rbxassetid://4864122196",
							["CROP_PLANT_1"] = "rbxassetid://5483943277",
							["CROP_PLANT_2"] = "rbxassetid://5483943479",
							["CROP_PLANT_3"] = "rbxassetid://5483943723",
							["ARMOR_EQUIP"] = "rbxassetid://6760627839",
							["ARMOR_UNEQUIP"] = "rbxassetid://6760625788",
							["PICKUP_ITEM_DROP"] = "rbxassetid://6768578304",
							["PARTY_INCOMING_INVITE"] = "rbxassetid://6732495464",
							["ERROR_NOTIFICATION"] = "rbxassetid://6732495464",
							["INFO_NOTIFICATION"] = "rbxassetid://6732495464",
							["END_GAME"] = "rbxassetid://6246476959",
							["GENERIC_BLOCK_PLACE"] = "rbxassetid://4842910664",
							["GENERIC_BLOCK_BREAK"] = "rbxassetid://4819966893",
							["GRASS_BREAK"] = "rbxassetid://5282847153",
							["WOOD_BREAK"] = "rbxassetid://4819966893",
							["STONE_BREAK"] = "rbxassetid://6328287211",
							["WOOL_BREAK"] = "rbxassetid://4842910664",
							["TNT_EXPLODE_1"] = "rbxassetid://7192313632",
							["TNT_HISS_1"] = "rbxassetid://7192313423",
							["FIREBALL_EXPLODE"] = "rbxassetid://6855723746",
							["SLIME_BLOCK_BOUNCE"] = "rbxassetid://6857999096",
							["SLIME_BLOCK_BREAK"] = "rbxassetid://6857999170",
							["SLIME_BLOCK_HIT"] = "rbxassetid://6857999148",
							["SLIME_BLOCK_PLACE"] = "rbxassetid://6857999119",
							["BOW_DRAW"] = "rbxassetid://6866062236",
							["BOW_FIRE"] = "rbxassetid://6866062104",
							["ARROW_HIT"] = "rbxassetid://6866062188",
							["ARROW_IMPACT"] = "rbxassetid://6866062148",
							["TELEPEARL_THROW"] = "rbxassetid://6866223756",
							["TELEPEARL_LAND"] = "rbxassetid://6866223798",
							["CROSSBOW_RELOAD"] = "rbxassetid://6869254094",
							["VOICE_1"] = "rbxassetid://5283866929",
							["VOICE_2"] = "rbxassetid://5283867710",
							["VOICE_HONK"] = "rbxassetid://5283872555",
							["FORTIFY_BLOCK"] = "rbxassetid://6955762535",
							["EAT_FOOD_1"] = "rbxassetid://4968170636",
							["KILL"] = "rbxassetid://7013482008",
							["ZIPLINE_TRAVEL"] = "rbxassetid://7047882304",
							["ZIPLINE_LATCH"] = "rbxassetid://7047882233",
							["ZIPLINE_UNLATCH"] = "rbxassetid://7047882265",
							["SHIELD_BLOCKED"] = "rbxassetid://6955762535",
							["GUITAR_LOOP"] = "rbxassetid://7084168540",
							["GUITAR_HEAL_1"] = "rbxassetid://7084168458",
							["CANNON_MOVE"] = "rbxassetid://7118668472",
							["CANNON_FIRE"] = "rbxassetid://7121064180",
							["BALLOON_INFLATE"] = "rbxassetid://7118657911",
							["BALLOON_POP"] = "rbxassetid://7118657873",
							["FIREBALL_THROW"] = "rbxassetid://7192289445",
							["LASSO_HIT"] = "rbxassetid://7192289603",
							["LASSO_SWING"] = "rbxassetid://7192289504",
							["LASSO_THROW"] = "rbxassetid://7192289548",
							["GRIM_REAPER_CONSUME"] = "rbxassetid://7225389554",
							["GRIM_REAPER_CHANNEL"] = "rbxassetid://7225389512",
							["TV_STATIC"] = "rbxassetid://7256209920",
							["TURRET_ON"] = "rbxassetid://7290176291",
							["TURRET_OFF"] = "rbxassetid://7290176380",
							["TURRET_ROTATE"] = "rbxassetid://7290176421",
							["TURRET_SHOOT"] = "rbxassetid://7290187805",
							["WIZARD_LIGHTNING_CAST"] = "rbxassetid://7262989886",
							["WIZARD_LIGHTNING_LAND"] = "rbxassetid://7263165647",
							["WIZARD_LIGHTNING_STRIKE"] = "rbxassetid://7263165347",
							["WIZARD_ORB_CAST"] = "rbxassetid://7263165448",
							["WIZARD_ORB_TRAVEL_LOOP"] = "rbxassetid://7263165579",
							["WIZARD_ORB_CONTACT_LOOP"] = "rbxassetid://7263165647",
							["BATTLE_PASS_PROGRESS_LEVEL_UP"] = "rbxassetid://7331597283",
							["BATTLE_PASS_PROGRESS_EXP_GAIN"] = "rbxassetid://7331597220",
							["FLAMETHROWER_UPGRADE"] = "rbxassetid://7310273053",
							["FLAMETHROWER_USE"] = "rbxassetid://7310273125",
							["BRITTLE_HIT"] = "rbxassetid://7310273179",
							["EXTINGUISH"] = "rbxassetid://7310273015",
							["RAVEN_SPACE_AMBIENT"] = "rbxassetid://7341443286",
							["RAVEN_WING_FLAP"] = "rbxassetid://7341443378",
							["RAVEN_CAW"] = "rbxassetid://7341443447",
							["JADE_HAMMER_THUD"] = "rbxassetid://7342299402",
							["STATUE"] = "rbxassetid://7344166851",
							["CONFETTI"] = "rbxassetid://7344278405",
							["HEART"] = "rbxassetid://7345120916",
							["SPRAY"] = "rbxassetid://7361499529",
							["BEEHIVE_PRODUCE"] = "rbxassetid://7378100183",
							["DEPOSIT_BEE"] = "rbxassetid://7378100250",
							["CATCH_BEE"] = "rbxassetid://7378100305",
							["BEE_NET_SWING"] = "rbxassetid://7378100350",
							["ASCEND"] = "rbxassetid://7378387334",
							["BED_ALARM"] = "rbxassetid://7396762708",
							["BOUNTY_CLAIMED"] = "rbxassetid://7396751941",
							["BOUNTY_ASSIGNED"] = "rbxassetid://7396752155",
							["BAGUETTE_HIT"] = "rbxassetid://7396760547",
							["BAGUETTE_SWING"] = "rbxassetid://7396760496",
							["TESLA_ZAP"] = "rbxassetid://7497477336",
							["SPIRIT_TRIGGERED"] = "rbxassetid://7498107251",
							["SPIRIT_EXPLODE"] = "rbxassetid://7498107327",
							["ANGEL_LIGHT_ORB_CREATE"] = "rbxassetid://7552134231",
							["ANGEL_LIGHT_ORB_HEAL"] = "rbxassetid://7552134868",
							["ANGEL_VOID_ORB_CREATE"] = "rbxassetid://7552135942",
							["ANGEL_VOID_ORB_HEAL"] = "rbxassetid://7552136927",
							["DODO_BIRD_JUMP"] = "rbxassetid://7618085391",
							["DODO_BIRD_DOUBLE_JUMP"] = "rbxassetid://7618085771",
							["DODO_BIRD_MOUNT"] = "rbxassetid://7618085486",
							["DODO_BIRD_DISMOUNT"] = "rbxassetid://7618085571",
							["DODO_BIRD_SQUAWK_1"] = "rbxassetid://7618085870",
							["DODO_BIRD_SQUAWK_2"] = "rbxassetid://7618085657",
							["SHIELD_CHARGE_START"] = "rbxassetid://7730842884",
							["SHIELD_CHARGE_LOOP"] = "rbxassetid://7730843006",
							["SHIELD_CHARGE_BASH"] = "rbxassetid://7730843142",
							["ROCKET_LAUNCHER_FIRE"] = "rbxassetid://7681584765",
							["ROCKET_LAUNCHER_FLYING_LOOP"] = "rbxassetid://7681584906",
							["SMOKE_GRENADE_POP"] = "rbxassetid://7681276062",
							["SMOKE_GRENADE_EMIT_LOOP"] = "rbxassetid://7681276135",
							["GOO_SPIT"] = "rbxassetid://7807271610",
							["GOO_SPLAT"] = "rbxassetid://7807272724",
							["GOO_EAT"] = "rbxassetid://7813484049",
							["LUCKY_BLOCK_BREAK"] = "rbxassetid://7682005357",
							["AXOLOTL_SWITCH_TARGETS"] = "rbxassetid://7344278405",
							["HALLOWEEN_MUSIC"] = "rbxassetid://7775602786",
							["SNAP_TRAP_SETUP"] = "rbxassetid://7796078515",
							["SNAP_TRAP_CLOSE"] = "rbxassetid://7796078695",
							["SNAP_TRAP_CONSUME_MARK"] = "rbxassetid://7796078825",
							["GHOST_VACUUM_SUCKING_LOOP"] = "rbxassetid://7814995865",
							["GHOST_VACUUM_SHOOT"] = "rbxassetid://7806060367",
							["GHOST_VACUUM_CATCH"] = "rbxassetid://7815151688",
							["FISHERMAN_GAME_START"] = "rbxassetid://7806060544",
							["FISHERMAN_GAME_PULLING_LOOP"] = "rbxassetid://7806060638",
							["FISHERMAN_GAME_PROGRESS_INCREASE"] = "rbxassetid://7806060745",
							["FISHERMAN_GAME_FISH_MOVE"] = "rbxassetid://7806060863",
							["FISHERMAN_GAME_LOOP"] = "rbxassetid://7806061057",
							["FISHING_ROD_CAST"] = "rbxassetid://7806060976",
							["FISHING_ROD_SPLASH"] = "rbxassetid://7806061193",
							["SPEAR_HIT"] = "rbxassetid://7807270398",
							["SPEAR_THROW"] = "rbxassetid://7813485044",
						}
						task.spawn(function()
							for i,v in pairs(collectionservice:GetTagged("block")) do
								if oldbedwarsblocktab[v.Name] then
									if type(oldbedwarsblocktab[v.Name]) == "table" then
										for i2,v2 in pairs(v:GetDescendants()) do
											if v2:IsA("Texture") then
												if v2.Name == "Top" then
													v2.Texture = oldbedwarsblocktab[v.Name][1]
													v2.Color3 = v.Name == "grass" and Color3.fromRGB(115, 255, 28) or Color3.fromRGB(255, 255, 255)
												elseif v2.Name == "Bottom" then
													v2.Texture = oldbedwarsblocktab[v.Name][2]
												else
													v2.Texture = oldbedwarsblocktab[v.Name][3]
												end
											end
										end
									else
										for i2,v2 in pairs(v:GetDescendants()) do
											if v2:IsA("Texture") then
												v2.Texture = oldbedwarsblocktab[v.Name]
											end
										end
									end
								end
							end
						end)
						game:GetService("CollectionService"):GetInstanceAddedSignal("block"):connect(function(v)
							if oldbedwarsblocktab[v.Name] then
								if type(oldbedwarsblocktab[v.Name]) == "table" then
									for i2,v2 in pairs(v:GetDescendants()) do
										if v2:IsA("Texture") then
											if v2.Name == "Top" then
												v2.Texture = oldbedwarsblocktab[v.Name][1]
												v2.Color3 = v.Name == "grass" and Color3.fromRGB(115, 255, 28) or Color3.fromRGB(255, 255, 255)
											elseif v2.Name == "Bottom" then
												v2.Texture = oldbedwarsblocktab[v.Name][2]
											else
												v2.Texture = oldbedwarsblocktab[v.Name][3]
											end
										end
									end
									v.DescendantAdded:connect(function(v3)
										if v3:IsA("Texture") then
											if v3.Name == "Top" then
												v3.Texture = oldbedwarsblocktab[v.Name][1]
												v3.Color3 = v.Name == "grass" and Color3.fromRGB(115, 255, 28) or Color3.fromRGB(255, 255, 255)
											elseif v3.Name == "Bottom" then
												v3.Texture = oldbedwarsblocktab[v.Name][2]
											else
												v3.Texture = oldbedwarsblocktab[v.Name][3]
											end
										end
									end)
								else
									for i2,v2 in pairs(v:GetDescendants()) do
										if v2:IsA("Texture") then
											v2.Texture = oldbedwarsblocktab[v.Name]
										end
									end
									v.DescendantAdded:connect(function(v3)
										if v3:IsA("Texture") then
											v3.Texture = oldbedwarsblocktab[v.Name]
										end
									end)
								end
							end
						end)
						game:GetService("CollectionService"):GetInstanceAddedSignal("tnt"):connect(function(v)
							if oldbedwarsblocktab[v.Name] then
								if type(oldbedwarsblocktab[v.Name]) == "table" then
									for i2,v2 in pairs(v:GetDescendants()) do
										if v2:IsA("Texture") then
											if v2.Name == "Top" then
												v2.Texture = oldbedwarsblocktab[v.Name][1]
												v2.Color3 = v.Name == "grass" and Color3.fromRGB(115, 255, 28) or Color3.fromRGB(255, 255, 255)
											elseif v2.Name == "Bottom" then
												v2.Texture = oldbedwarsblocktab[v.Name][2]
											else
												v2.Texture = oldbedwarsblocktab[v.Name][3]
											end
										end
									end
									v.DescendantAdded:connect(function(v3)
										if v3:IsA("Texture") then
											if v3.Name == "Top" then
												v3.Texture = oldbedwarsblocktab[v.Name][1]
												v3.Color3 = v.Name == "grass" and Color3.fromRGB(115, 255, 28) or Color3.fromRGB(255, 255, 255)
											elseif v3.Name == "Bottom" then
												v3.Texture = oldbedwarsblocktab[v.Name][2]
											else
												v3.Texture = oldbedwarsblocktab[v.Name][3]
											end
										end
									end)
								else
									for i2,v2 in pairs(v:GetDescendants()) do
										if v2:IsA("Texture") then
											v2.Texture = oldbedwarsblocktab[v.Name]
										end
									end
									v.DescendantAdded:connect(function(v3)
										if v3:IsA("Texture") then
											v3.Texture = oldbedwarsblocktab[v.Name]
										end
									end)
								end
							end
						end)
						for i,v in pairs(bedwars["ItemTable"]) do 
							if oldbedwarsicontab[i] then 
								v.image = oldbedwarsicontab[i]
							end
						end			
						for i,v in pairs(oldbedwarssoundtable) do 
							local item = bedwars["SoundList"][i]
							if item then
								bedwars["SoundList"][i] = v
							end
						end	
						local oldweld = bedwars["WeldTable"].weldCharacterAccessories
						local alreadydone = {}
						bedwars["WeldTable"].weldCharacterAccessories = function(model, ...)
							for i,v in pairs(model:GetChildren()) do
								local died = v.Name == "HumanoidRootPart" and v:FindFirstChild("Died")
								if died then 
									died.Volume = 0
								end
								if oldbedwarsblocktab[v.Name] then
									task.spawn(function()
										local hand = v:WaitForChild("Handle", 10)
										if hand then
											hand.CastShadow = false
										end
										for i2,v2 in pairs(v:GetDescendants()) do
											if v2:IsA("Texture") then
												if v2.Name == "Top" then
													v2.Texture = (type(oldbedwarsblocktab[v.Name]) == "table" and oldbedwarsblocktab[v.Name][1] or oldbedwarsblocktab[v.Name])
													v2.Color3 = v.Name == "grass" and Color3.fromRGB(115, 255, 28) or Color3.fromRGB(255, 255, 255)
												elseif v2.Name == "Bottom" then
													v2.Texture = (type(oldbedwarsblocktab[v.Name]) == "table" and oldbedwarsblocktab[v.Name][2] or oldbedwarsblocktab[v.Name])
												else
													v2.Texture = (type(oldbedwarsblocktab[v.Name]) == "table" and oldbedwarsblocktab[v.Name][3] or oldbedwarsblocktab[v.Name])
												end
											end
										end
										v.DescendantAdded:connect(function(v3)
											if v3:IsA("Texture") then
												if v3.Name == "Top" then
													v3.Texture = (type(oldbedwarsblocktab[v.Name]) == "table" and oldbedwarsblocktab[v.Name][1] or oldbedwarsblocktab[v.Name])
													v3.Color3 = v.Name == "grass" and Color3.fromRGB(115, 255, 28) or Color3.fromRGB(255, 255, 255)
												elseif v3.Name == "Bottom" then
													v3.Texture = (type(oldbedwarsblocktab[v.Name]) == "table" and oldbedwarsblocktab[v.Name][2] or oldbedwarsblocktab[v.Name])
												else
													v3.Texture = (type(oldbedwarsblocktab[v.Name]) == "table" and oldbedwarsblocktab[v.Name][3] or oldbedwarsblocktab[v.Name])
												end
											end
										end)
									end)
								end
							end
							return oldweld(model, ...)
						end
						local damagetab = debug.getupvalue(bedwars["DamageIndicator"], 2)
						damagetab.strokeThickness = false
						damagetab.textSize = 32
						damagetab.blowUpDuration = 0
						damagetab.baseColor = Color3.fromRGB(214, 0, 0)
						damagetab.blowUpSize = 32
						damagetab.blowUpCompleteDuration = 0
						damagetab.anchoredDuration = 0
						debug.setconstant(bedwars["ViewmodelController"].show, 37, "")
						debug.setconstant(bedwars["DamageIndicator"], 81, Enum.Font.LuckiestGuy)
						debug.setconstant(bedwars["DamageIndicator"], 100, "Enabled")
						debug.setconstant(bedwars["DamageIndicator"], 116, 0.3)
						debug.setconstant(bedwars["DamageIndicator"], 126, 0.5)
						debug.setupvalue(bedwars["DamageIndicator"], 10, {
							Create = function(self, obj, ...)
								task.spawn(function()
									obj.Parent.Parent.Parent.Parent.Velocity = vec3((math.random(-50, 50) / 100) * damagetab.velX, (math.random(50, 60) / 100) * damagetab.velY, (math.random(-50, 50) / 100) * damagetab.velZ)
									local textcompare = obj.Parent.TextColor3
									if textcompare ~= Color3.fromRGB(85, 255, 85) then
										local newtween = game:GetService("TweenService"):Create(obj.Parent, TweenInfo.new(0.5, Enum.EasingStyle.Linear), {
											TextColor3 = (textcompare == Color3.fromRGB(76, 175, 93) and Color3.new(0, 0, 0) or Color3.new(1, 1, 1))
										})
										task.wait(0.15)
										newtween:Play()
									end
								end)
								return game:GetService("TweenService"):Create(obj, ...)
							end
						})
						sethiddenproperty(lighting, "Technology", "ShadowMap")
						lighting.Ambient = Color3.fromRGB(69, 69, 69)
						lighting.Brightness = 3
						lighting.EnvironmentDiffuseScale = 1
						lighting.EnvironmentSpecularScale = 1
						lighting.OutdoorAmbient = Color3.fromRGB(69, 69, 69)
						lighting.Atmosphere.Density = 0.1
						lighting.Atmosphere.Offset = 0.25
						lighting.Atmosphere.Color = Color3.fromRGB(198, 198, 198)
						lighting.Atmosphere.Decay = Color3.fromRGB(104, 112, 124)
						lighting.Atmosphere.Glare = 0
						lighting.Atmosphere.Haze = 0
						lighting.ClockTime = 13
						lighting.GeographicLatitude = 0
						lighting.GlobalShadows = false
						lighting.TimeOfDay = "13:00:00"
						lighting.Sky.SkyboxBk = "rbxassetid://7018684000"
						lighting.Sky.SkyboxDn = "rbxassetid://6334928194"
						lighting.Sky.SkyboxFt = "rbxassetid://7018684000"
						lighting.Sky.SkyboxLf = "rbxassetid://7018684000"
						lighting.Sky.SkyboxRt = "rbxassetid://7018684000"
						lighting.Sky.SkyboxUp = "rbxassetid://7018689553"
					end)
				else
					OldBedwars["ToggleButton"](false)
				end
			else
				createwarning("OldBedwars", "Disabled Next Game", 10)
			end
		end
	})
end)

task.spawn(function()
	local url = "https://raw.githubusercontent.com/XylaWare/XyloWare/main/CustomModules/bedwarsdata"
	local function createannouncement(announcetab)
		local notifyframereal = Instance.new("TextButton")
		notifyframereal.AnchorPoint = Vector2.new(0.5, 0)
		notifyframereal.BackgroundColor3 = announcetab.Error and Color3.fromRGB(235, 87, 87) or Color3.fromRGB(100, 103, 167)
		notifyframereal.BorderSizePixel = 0
		notifyframereal.AutoButtonColor = false
		notifyframereal.Text = ""
		notifyframereal.Position = UDim2.new(0.5, 0, 0.01, -36)
		notifyframereal.Size = UDim2.new(0.4, 0, 0, 0)
		notifyframereal.Parent = GuiLibrary["MainGui"]
		local notifyframe = Instance.new("Frame")
		notifyframe.BackgroundTransparency = 1
		notifyframe.Size = UDim2.new(1, 0, 1, 0)
		notifyframe.Parent = notifyframereal
		local notifyframecorner = Instance.new("UICorner")
		notifyframecorner.CornerRadius = UDim.new(0, 5)
		notifyframecorner.Parent = notifyframereal
		local notifyframeaspect = Instance.new("UIAspectRatioConstraint")
		notifyframeaspect.AspectRatio = 10
		notifyframeaspect.DominantAxis = Enum.DominantAxis.Height
		notifyframeaspect.Parent = notifyframereal
		local notifyframelist = Instance.new("UIListLayout")
		notifyframelist.SortOrder = Enum.SortOrder.LayoutOrder
		notifyframelist.FillDirection = Enum.FillDirection.Horizontal
		notifyframelist.HorizontalAlignment = Enum.HorizontalAlignment.Left
		notifyframelist.VerticalAlignment = Enum.VerticalAlignment.Center
		notifyframelist.Parent = notifyframe
		local notifyframe2 = Instance.new("Frame")
		notifyframe2.BackgroundTransparency = 1
		notifyframe2.BorderSizePixel = 0
		notifyframe2.LayoutOrder = 1
		notifyframe2.Size = UDim2.new(0.3, 0, 0, 0)
		notifyframe2.SizeConstraint = Enum.SizeConstraint.RelativeYY
		notifyframe2.Parent = notifyframe
		local notifyframesat = Instance.new("ImageLabel")
		notifyframesat.BackgroundTransparency = 1
		notifyframesat.BorderSizePixel = 0
		notifyframesat.Size = UDim2.new(0.7, 0, 0.7, 0)
		notifyframesat.LayoutOrder = 2
		notifyframesat.SizeConstraint = Enum.SizeConstraint.RelativeYY
		notifyframesat.Image = announcetab.Error and "rbxassetid://6768383834" or "rbxassetid://6685538693"
		notifyframesat.Parent = notifyframe
		local notifyframe3 = Instance.new("Frame")
		notifyframe3.BackgroundTransparency = 1
		notifyframe3.BorderSizePixel = 0
		notifyframe3.LayoutOrder = 3
		notifyframe3.Size = UDim2.new(4.1, 0, 0.8, 0)
		notifyframe3.SizeConstraint = Enum.SizeConstraint.RelativeYY
		notifyframe3.Parent = notifyframe
		local notifyframenotifyframelist = Instance.new("UIPadding")
		notifyframenotifyframelist.PaddingBottom = UDim.new(0.08, 0)
		notifyframenotifyframelist.PaddingLeft = UDim.new(0.06, 0)
		notifyframenotifyframelist.PaddingTop = UDim.new(0.08, 0)
		notifyframenotifyframelist.Parent = notifyframe3
		local notifyframeaspectnotifyframeaspect = Instance.new("UIListLayout")
		notifyframeaspectnotifyframeaspect.Parent = notifyframe3
		notifyframeaspectnotifyframeaspect.VerticalAlignment = Enum.VerticalAlignment.Center
		local notifyframelistnotifyframeaspect = Instance.new("TextLabel")
		notifyframelistnotifyframeaspect.BackgroundTransparency = 1
		notifyframelistnotifyframeaspect.BorderSizePixel = 0
		notifyframelistnotifyframeaspect.Size = UDim2.new(1, 0, 0.6, 0)
		notifyframelistnotifyframeaspect.Font = Enum.Font.Roboto
		notifyframelistnotifyframeaspect.Text = "XyloWare Announcement"
		notifyframelistnotifyframeaspect.TextColor3 = Color3.fromRGB(255, 255, 255)
		notifyframelistnotifyframeaspect.TextScaled = true
		notifyframelistnotifyframeaspect.TextWrapped = true
		notifyframelistnotifyframeaspect.TextXAlignment = Enum.TextXAlignment.Left
		notifyframelistnotifyframeaspect.Parent = notifyframe3
		local notifyframe2notifyframeaspect = Instance.new("TextLabel")
		notifyframe2notifyframeaspect.BackgroundTransparency = 1
		notifyframe2notifyframeaspect.BorderSizePixel = 0
		notifyframe2notifyframeaspect.Size = UDim2.new(1, 0, 0.4, 0)
		notifyframe2notifyframeaspect.Font = Enum.Font.Roboto
		notifyframe2notifyframeaspect.Text = "<b>"..announcetab.Text.."</b>"
		notifyframe2notifyframeaspect.TextColor3 = Color3.fromRGB(255, 255, 255)
		notifyframe2notifyframeaspect.TextScaled = true
		notifyframe2notifyframeaspect.TextWrapped = true
		notifyframe2notifyframeaspect.RichText = true
		notifyframe2notifyframeaspect.TextXAlignment = Enum.TextXAlignment.Left
		notifyframe2notifyframeaspect.Parent = notifyframe3
		local notifyprogress = Instance.new("Frame")
		notifyprogress.Parent = notifyframereal
		notifyprogress.BorderSizePixel = 0
		notifyprogress.BackgroundColor3 = Color3.new(1, 1, 1)
		notifyprogress.Position = UDim2.new(0, 0, 1, -3)
		notifyprogress.Size = UDim2.new(1, 0, 0, 3)
		local notifyprogresscorner = Instance.new("UICorner")
		notifyprogresscorner.CornerRadius = UDim.new(0, 100)
		notifyprogresscorner.Parent = notifyprogress
		game:GetService("TweenService"):Create(notifyframereal, TweenInfo.new(0.12), {Size = UDim2.fromScale(0.4, 0.065)}):Play()
		game:GetService("TweenService"):Create(notifyprogress, TweenInfo.new(announcetab.Time or 20, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 0, 3)}):Play()
		local sound = Instance.new("Sound")
		sound.PlayOnRemove = true
		sound.SoundId = "rbxassetid://6732495464"
		sound.Parent = workspace
		sound:Remove()
		notifyframereal.MouseButton1Click:connect(function()
			local sound = Instance.new("Sound")
			sound.PlayOnRemove = true
			sound.SoundId = "rbxassetid://6732690176"
			sound.Parent = workspace
			sound:Remove()
			notifyframereal:Remove()
			notifyframereal = nil
		end)
		task.wait(announcetab.Time or 20)
		if notifyframereal then
			notifyframereal:Remove()
		end
	end

	local function rundata(datatab, olddatatab)
		if not olddatatab then
			if datatab.Disabled then 
				coroutine.resume(coroutine.create(function()
					repeat task.wait() until shared.VapeFullyLoaded
					task.wait(1)
					GuiLibrary.SelfDestruct()
				end))
				game:GetService("StarterGui"):SetCore("SendNotification", {
					Title = "XyloWare",
					Text = "XyloWare is currently disabled, ask Xylo for updates,
					Duration = 30,
				})
			end
			if datatab.KickUsers and datatab.KickUsers[tostring(lplr.UserId)] then
				lplr:Kick(datatab.KickUsers[tostring(lplr.UserId)])
			end
		else
			local newdatatab = {}
			for i,v in pairs(datatab) do 
				if not olddatatab or olddatatab[i] ~= v then 
					newdatatab[i] = v
				end
			end
			if newdatatab.Disabled then 
				coroutine.resume(coroutine.create(function()
					repeat task.wait() until shared.VapeFullyLoaded
					task.wait(1)
					GuiLibrary.SelfDestruct()
				end))
				game:GetService("StarterGui"):SetCore("SendNotification", {
					Title = "XyloWare",
					Text = "XyloWare is currently disabled, check the discord for updates",
					Duration = 30,
				})
			end
			if newdatatab.KickUsers and newdatatab.KickUsers[tostring(lplr.UserId)] then
				lplr:Kick(newdatatab.KickUsers[tostring(lplr.UserId)])
			end
			if newdatatab.Announcement and newdatatab.Announcement.ExpireTime >= os.time() then 
				task.spawn(function()
					createannouncement(newdatatab.Announcement)
				end)
			end
		end
	end

	pcall(function()
		if betterisfile("XyloWare/Profiles/bedwarsdata.txt") == false then 
			writefile("XyloWare/Profiles/bedwarsdata.txt", game:HttpGet(url, true))
		end
		local olddata = readfile("XyloWare/Profiles/bedwarsdata.txt")
		local newdata = game:HttpGet(url, true)
		if newdata ~= olddata then 
			rundata(game:GetService("HttpService"):JSONDecode(newdata), game:GetService("HttpService"):JSONDecode(olddata))
			olddata = newdata
			writefile("XyloWare/Profiles/bedwarsdata.txt", newdata)
		else
			rundata(game:GetService("HttpService"):JSONDecode(olddata))
		end
		repeat
			task.wait(60)
			newdata = game:HttpGet(url, true)
			if newdata ~= olddata then 
				rundata(game:GetService("HttpService"):JSONDecode(newdata), game:GetService("HttpService"):JSONDecode(olddata))
				olddata = newdata
				writefile("XyloWare/Profiles/bedwarsdata.txt", newdata)
			end
		until uninjectflag
	end)
end)
