local requestfunc = syn and syn.request or http and http.request or http_request or fluxus and fluxus.request or getgenv().request or request
local checkpublicreponum = 0
local checkpublicrepo
checkpublicrepo = function(id)
	local suc, req = pcall(function() return requestfunc({
		Url = "https://raw.githubusercontent.com/XylaWare/XyloWare/edit/main/CustomModules/"..id..".lua",
		Method = "GET"
	}) end)
	if not suc then
		checkpublicreponum = checkpublicreponum + 1
		spawn(function()
			local textlabel = Instance.new("TextLabel")
			textlabel.Size = UDim2.new(1, 0, 0, 36)
			textlabel.Text = "Loading CustomModule Failed!, Attempts : "..checkpublicreponum
			textlabel.BackgroundTransparency = 1
			textlabel.TextStrokeTransparency = 0
			textlabel.TextSize = 30
			textlabel.Font = Enum.Font.SourceSans
			textlabel.TextColor3 = Color3.new(1, 1, 1)
			textlabel.Position = UDim2.new(0, 0, 0, -36)
			textlabel.Parent = GuiLibrary["MainGui"]
			task.wait(2)
			textlabel:Remove()
		end)
		task.wait(2)
		return checkpublicrepo(id)
	end
	if req.StatusCode == 200 then
		return req.Body
	end
	return nil
end

shared.CustomSaveVape = 6872274481
if pcall(function() readfile("vape/CustomModules/6872265039.lua") end) then
	loadstring(readfile("vape/CustomModules/6872265039.lua"))()
else
	local publicrepo = checkpublicrepo("6872265039")
	if publicrepo then
		loadstring(publicrepo)()
	end
end

shared.CustomSaveVape = 6872274481
if pcall(function() readfile("vape/CustomModules/6872274481.lua") end) then
	loadstring(readfile("vape/CustomModules/6872274481.lua"))()
else
	local publicrepo = checkpublicrepo("6872274481")
	if publicrepo then
		loadstring(publicrepo)()
	end
end
