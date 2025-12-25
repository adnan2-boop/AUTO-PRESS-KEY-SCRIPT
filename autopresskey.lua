-- SERVICES
local Players = game:GetService("Players")
local VIM = game:GetService("VirtualInputManager")
local player = Players.LocalPlayer

-- DATA
local keyList = {} -- { KeyCode = Enum.KeyCode.E, Interval = 1, Enabled = false }

-- UI ROOT
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "AutoKeyUI"
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 300, 0, 360)
main.Position = UDim2.new(0, 20, 0.5, -180)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.Active = true
main.Draggable = true
main.BorderSizePixel = 0
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

-- TITLE
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = "AUTO KEY PRESSER"
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = Color3.fromRGB(230,230,230)

-- CONTAINER
local list = Instance.new("UIListLayout")
list.Padding = UDim.new(0, 6)

local scroll = Instance.new("ScrollingFrame", main)
scroll.Position = UDim2.new(0,10,0,50)
scroll.Size = UDim2.new(1,-20,1,-60)
scroll.CanvasSize = UDim2.new(0,0,0,0)
scroll.ScrollBarImageTransparency = 0.5
scroll.BackgroundTransparency = 1
list.Parent = scroll

-- AUTO RESIZE
list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	scroll.CanvasSize = UDim2.new(0,0,0,list.AbsoluteContentSize.Y + 10)
end)

-- FUNCTION: CREATE KEY ROW
local function createKeyRow(keyCode)
	local data = {
		KeyCode = keyCode,
		Interval = 1,
		Enabled = false
	}
	table.insert(keyList, data)

	local row = Instance.new("Frame", scroll)
	row.Size = UDim2.new(1,0,0,45)
	row.BackgroundColor3 = Color3.fromRGB(35,35,35)
	row.BorderSizePixel = 0
	Instance.new("UICorner", row).CornerRadius = UDim.new(0,8)

	-- KEY NAME
	local keyLabel = Instance.new("TextLabel", row)
	keyLabel.Size = UDim2.new(0.25,0,1,0)
	keyLabel.BackgroundTransparency = 1
	keyLabel.Text = keyCode.Name
	keyLabel.Font = Enum.Font.GothamBold
	keyLabel.TextSize = 14
	keyLabel.TextColor3 = Color3.new(1,1,1)

	-- INTERVAL BOX
	local box = Instance.new("TextBox", row)
	box.Position = UDim2.new(0.28,0,0.15,0)
	box.Size = UDim2.new(0.35,0,0.7,0)
	box.Text = "1.0"
	box.Font = Enum.Font.Gotham
	box.TextSize = 13
	box.BackgroundColor3 = Color3.fromRGB(45,45,45)
	box.TextColor3 = Color3.new(1,1,1)
	box.ClearTextOnFocus = false
	Instance.new("UICorner", box).CornerRadius = UDim.new(0,6)

	box.FocusLost:Connect(function()
		local num = tonumber(box.Text)
		if num and num > 0 then
			data.Interval = num
		else
			box.Text = tostring(data.Interval)
		end
	end)

	-- TOGGLE
	local toggle = Instance.new("TextButton", row)
	toggle.Position = UDim2.new(0.67,0,0.15,0)
	toggle.Size = UDim2.new(0.28,0,0.7,0)
	toggle.Text = "OFF"
	toggle.Font = Enum.Font.GothamBold
	toggle.TextSize = 13
	toggle.BackgroundColor3 = Color3.fromRGB(160,60,60)
	toggle.TextColor3 = Color3.new(1,1,1)
	Instance.new("UICorner", toggle).CornerRadius = UDim.new(0,6)

	toggle.MouseButton1Click:Connect(function()
		data.Enabled = not data.Enabled
		if data.Enabled then
			toggle.Text = "ON"
			toggle.BackgroundColor3 = Color3.fromRGB(60,160,90)
		else
			toggle.Text = "OFF"
			toggle.BackgroundColor3 = Color3.fromRGB(160,60,60)
		end
	end)
end

-- DEFAULT KEYS (BISA DIHAPUS / TAMBAH)
createKeyRow(Enum.KeyCode.E)
createKeyRow(Enum.KeyCode.F)
createKeyRow(Enum.KeyCode.R)

-- PRESS LOOP
task.spawn(function()
	while true do
		for _,data in ipairs(keyList) do
			if data.Enabled then
				VIM:SendKeyEvent(true, data.KeyCode, false, game)
				task.wait(0.03)
				VIM:SendKeyEvent(false, data.KeyCode, false, game)
				task.wait(data.Interval)
			end
		end
		task.wait(0.05)
	end
end)
