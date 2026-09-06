
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local Portals = workspace:FindFirstChild("Portals")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local CurrentlyFarming
local Remote = game.ReplicatedStorage.GameRemotes.NotificationToFight
local TargetPlayer1
local TargetPlayer2
local AutoAcp = false
local AutoInv = false
local SmartFarm = false

local GUI = Instance.new("ScreenGui")
GUI.Name = "BattleMenu"
GUI.ResetOnSpawn = false
GUI.IgnoreGuiInset = true
GUI.Parent = PlayerGui

local Frame = Instance.new("Frame")
Frame.Parent = GUI
Frame.Size = UDim2.new(0.36, 0, 0.78, 0)
Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
Frame.AnchorPoint = Vector2.new(0.5, 0.5)
Frame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

local FrameStroke = Instance.new("UIStroke")
FrameStroke.Parent = Frame
FrameStroke.Color = Color3.fromRGB(255, 255, 255)
FrameStroke.Thickness = 4

local function Border(Object, Thickness)
	local Border = Instance.new("Frame")
	Border.Name = "Border"
	Border.Parent = Object.Parent
	Border.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Border.BorderSizePixel = 0
	Border.Position = UDim2.new(
		Object.Position.X.Scale,
		Object.Position.X.Offset - Thickness,
		Object.Position.Y.Scale,
		Object.Position.Y.Offset - Thickness
	)
	Border.Size = UDim2.new(
		Object.Size.X.Scale,
		Object.Size.X.Offset + Thickness * 2,
		Object.Size.Y.Scale,
		Object.Size.Y.Offset + Thickness * 2
	)
	Border.ZIndex = Object.ZIndex - 1

	return Border
end

local function Container(Object, Thickness)
	local UiStroke = Instance.new("UIStroke", Object)
	UiStroke.Color = Color3.fromRGB(255, 255, 255)
	UiStroke.Thickness = Thickness
end


local Title = Instance.new("TextLabel")
Title.Parent = Frame
Title.Size = UDim2.new(0.9, 0, 0.085, 0)
Title.Position = UDim2.new(0.05, 0, 0.025, 0)
Title.BackgroundTransparency = 1
Title.Text = "BATTLE CONTROL"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Font = Enum.Font.Arcade

local Subtitle = Instance.new("TextLabel")
Subtitle.Parent = Frame
Subtitle.Size = UDim2.new(0.9, 0, 0.035, 0)
Subtitle.Position = UDim2.new(0.05, 0, 0.105, 0)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "PLAYER SETTINGS"
Subtitle.TextColor3 = Color3.fromRGB(150, 150, 150)
Subtitle.TextScaled = true
Subtitle.Font = Enum.Font.Arcade

local function CreateSetting(Y, Placeholder)
	local Container = Instance.new("Frame")
	Container.Parent = Frame
	Container.Size = UDim2.new(0.9, 0, 0.1, 0)
	Container.Position = UDim2.new(0.05, 0, Y, 0)
	Container.BackgroundTransparency = 1

	local Textbox = Instance.new("TextBox")
	Textbox.Parent = Container
	Textbox.Size = UDim2.new(0.68, 0, 1, 0)
	Textbox.Position = UDim2.new(0, 0, 0, 0)
	Textbox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	Textbox.BorderSizePixel = 0
	Textbox.PlaceholderText = Placeholder
	Textbox.PlaceholderColor3 = Color3.fromRGB(130, 130, 130)
	Textbox.Text = ""
	Textbox.TextColor3 = Color3.fromRGB(255, 255, 255)
	Textbox.TextScaled = true
	Textbox.Font = Enum.Font.Arcade
	Textbox.ClearTextOnFocus = false

	Textbox.FocusLost:Connect(function()
		if Placeholder == "Auto Accpet Invites From Player" then
			TargetPlayer1 = Textbox.Text
		elseif Placeholder == "Auto Invite Player to Battle" then
			TargetPlayer2 = Textbox.Text
		end
	end)

	Border(Textbox, 3)

	local Button = Instance.new("TextButton")
	Button.Parent = Container
	Button.Size = UDim2.new(0.25, 0, 1, 0)
	Button.Position = UDim2.new(0.75, 0, 0, 0)
	Button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	Button.BorderSizePixel = 0
	Button.Text = "OFF"
	Button.TextColor3 = Color3.fromRGB(255, 255, 255)
	Button.TextScaled = true
	Button.Font = Enum.Font.Arcade
	Button.AutoButtonColor = false

	Border(Button, 3)

	local Enabled = false

	Button.MouseEnter:Connect(function()
		TweenService:Create(
			Button,
			TweenInfo.new(0.12),
			{BackgroundColor3 = Color3.fromRGB(45, 45, 45)}
		):Play()
	end)

	Button.MouseLeave:Connect(function()
		TweenService:Create(
			Button,
			TweenInfo.new(0.12),
			{BackgroundColor3 = Color3.fromRGB(0, 0, 0)}
		):Play()
	end)

	Button.MouseButton1Click:Connect(function()
		if Placeholder == "Auto Accpet Invites From Player" then
			Enabled = not Enabled
			Button.Text = Enabled and "ON" or "OFF"
			AutoAcp = Enabled
		elseif Placeholder == "Auto Invite Player to Battle" then
			Enabled = not Enabled
			Button.Text = Enabled and "ON" or "OFF"
			AutoInv = Enabled
		end
	end)

	return Textbox, Button
end

local TextboxPlayer, AutoACPInviteButton =
	CreateSetting(0.155, "Auto Accpet Invites From Player")

local TextboxPlayer2, AutoInviteButton =
	CreateSetting(0.275, "Auto Invite Player to Battle")



local BattleHeader = Instance.new("TextLabel")
BattleHeader.Parent = Frame
BattleHeader.Size = UDim2.new(0.9, 0, 0.065, 0)
BattleHeader.Position = UDim2.new(0.05, 0, 0.405, 0)
BattleHeader.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
BattleHeader.BorderSizePixel = 0
BattleHeader.Text = "AVAILABLE BATTLES"
BattleHeader.TextColor3 = Color3.fromRGB(255, 255, 255)
BattleHeader.TextScaled = true
BattleHeader.Font = Enum.Font.Arcade

Border(BattleHeader, 3)


local SearchBox = Instance.new("TextBox")
SearchBox.Parent = Frame
SearchBox.Size = UDim2.new(0.9, 0, 0.055, 0)
SearchBox.Position = UDim2.new(0.05, 0, 0.475, 0)
SearchBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
SearchBox.BorderSizePixel = 0
SearchBox.PlaceholderText = "SEARCH BATTLES..."
SearchBox.PlaceholderColor3 = Color3.fromRGB(130, 130, 130)
SearchBox.Text = ""
SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchBox.TextScaled = true
SearchBox.Font = Enum.Font.Arcade
SearchBox.ClearTextOnFocus = false

Border(SearchBox, 3)


local ScrollingBattle = Instance.new("ScrollingFrame")
ScrollingBattle.Parent = Frame
ScrollingBattle.Size = UDim2.new(0.9, 0, 0.255, 0)
ScrollingBattle.Position = UDim2.new(0.05, 0, 0.54, 0)
ScrollingBattle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ScrollingBattle.BorderSizePixel = 0
ScrollingBattle.ScrollBarThickness = 3
ScrollingBattle.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
ScrollingBattle.AutomaticCanvasSize = Enum.AutomaticSize.Y
ScrollingBattle.CanvasSize = UDim2.new(0, 0, 0, 0)

Border(ScrollingBattle, 3)

local Padding = Instance.new("UIPadding")
Padding.Parent = ScrollingBattle
Padding.PaddingTop = UDim.new(0, 7)
Padding.PaddingBottom = UDim.new(0, 7)
Padding.PaddingLeft = UDim.new(0, 7)
Padding.PaddingRight = UDim.new(0, 7)

local Layout = Instance.new("UIListLayout")
Layout.Parent = ScrollingBattle
Layout.Padding = UDim.new(0, 7)
Layout.SortOrder = Enum.SortOrder.LayoutOrder



local function CreateBattle(Name)
	local Portal = workspace.Portals:FindFirstChild(Name)

	if Portal then
		local TeleporterConfig = Portal:FindFirstChild("TeleporterConfig")

		if TeleporterConfig then
			local Settings = require(TeleporterConfig)
			
	local Battle = Instance.new("Frame")
	Battle.Parent = ScrollingBattle
	Battle.Size = UDim2.new(1, 0, 0, 52)
	Battle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	Battle.BorderSizePixel = 0

	Container(Battle, 2)

	local EnemyName = Instance.new("TextLabel")
	EnemyName.Parent = Battle
	EnemyName.Name = "EnemyName"
	EnemyName.BackgroundTransparency = 1
	EnemyName.Position = UDim2.new(0, 10, 0, 3)
	EnemyName.Size = UDim2.new(1, -100, 0, 22)
	EnemyName.Text = "▶  " .. Settings.Destination
	EnemyName.TextColor3 = Color3.fromRGB(255, 255, 255)
	EnemyName.TextScaled = true
	EnemyName.Font = Enum.Font.Arcade
	EnemyName.TextXAlignment = Enum.TextXAlignment.Left

	local Requirements = Instance.new("TextLabel")
	Requirements.Parent = Battle
	Requirements.BackgroundTransparency = 1
	Requirements.Position = UDim2.new(0, 10, 0, 27)
	Requirements.Size = UDim2.new(1, -100, 0, 18)
	Requirements.Text = "Loading requirements..."
	Requirements.TextColor3 = Color3.fromRGB(180, 180, 180)
	Requirements.TextScaled = true
	Requirements.Font = Enum.Font.Arcade
	Requirements.TextXAlignment = Enum.TextXAlignment.Left

	local ActiveButton = Instance.new("TextButton")
	ActiveButton.Parent = Battle
	ActiveButton.Name = "ActiveButton"
	ActiveButton.Size = UDim2.new(0, 75, 0, 34)
	ActiveButton.Position = UDim2.new(1, -83, 0.5, -17)
	ActiveButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	ActiveButton.BorderSizePixel = 0
	ActiveButton.Text = "SELECT"
	ActiveButton.TextColor3 = Color3.fromRGB(0, 0, 0)
	ActiveButton.TextScaled = true
	ActiveButton.Font = Enum.Font.Arcade
	ActiveButton.AutoButtonColor = false
	
	Border(ActiveButton, 2)
	Container(ActiveButton, 2)

   Battle:SetAttribute("EnemyName", Settings.Destination)

	

			local RequiredLevel = Settings.RequiredLevel or 0
			local RequiredTP = Settings.RequiredTP or 0
			local RequiredReset = Settings.RequiredReset or 0
			local RequiredTrueReset = Settings.RequiredTrueReset or 0

			Requirements.Text =
				"LVL " .. RequiredLevel ..
				"  |  TP " .. RequiredTP ..
				"  |  RESET " .. RequiredReset ..
				"  |  TRUE RESET " .. RequiredTrueReset

	Battle.MouseEnter:Connect(function()
		TweenService:Create(
			Battle,
			TweenInfo.new(0.1),
			{BackgroundColor3 = Color3.fromRGB(35, 35, 35)}
		):Play()
	end)

	Battle.MouseLeave:Connect(function()
		TweenService:Create(
			Battle,
			TweenInfo.new(0.1),
			{BackgroundColor3 = Color3.fromRGB(0, 0, 0)}
		):Play()
	end)

	ActiveButton.MouseEnter:Connect(function()
		TweenService:Create(
			ActiveButton,
			TweenInfo.new(0.1),
			{BackgroundColor3 = Color3.fromRGB(35, 35, 35)}
		):Play()
	end)

	ActiveButton.MouseLeave:Connect(function()
		TweenService:Create(
			ActiveButton,
			TweenInfo.new(0.1),
			{BackgroundColor3 = Color3.fromRGB(0, 0, 0)}
		):Play()
	end)

	ActiveButton.MouseButton1Click:Connect(function()
		for _, Other in ScrollingBattle:GetChildren() do
			if Other:IsA("Frame") then
				local OtherButton = Other:FindFirstChild("ActiveButton")

				if OtherButton then
					OtherButton.Text = "SELECT"
					OtherButton.TextColor3 = Color3.fromRGB(255, 255, 255)
				end
			end
		end

		ActiveButton.Text = "ACTIVE"
		ActiveButton.TextColor3 = Color3.fromRGB(55, 255, 0)

		CurrentlyFarming = Name
	end)

	return Battle
	end
	end
end

local function UpdateBattle()
	for _, Battle in ScrollingBattle:GetChildren() do
		if Battle:IsA("TextButton") then
			Battle:Destroy()
		end
	end

	local FindAllBattles = Portals:GetChildren()

	for i,v in pairs(FindAllBattles) do
		if v:IsA("Model") then
			CreateBattle(v.Name)
		end
	end

	local Search = SearchBox.Text:lower()

	for _, Battle in ScrollingBattle:GetChildren() do
		if Battle:IsA("Frame") then
			local BattleName = Battle:GetAttribute("EnemyName")

			if BattleName and Search ~= "" then
				Battle.Visible = BattleName:lower():find(Search, 1, true) ~= nil
			else
				Battle.Visible = true
			end
		end
	end
end

SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
	local Search = SearchBox.Text:lower()

	for _, Battle in ScrollingBattle:GetChildren() do
		if Battle:IsA("Frame") then
			local BattleName = Battle:GetAttribute("EnemyName")

			if BattleName then
				if Search == "" then
					Battle.Visible = true
				else
					Battle.Visible = BattleName:lower():find(Search, 1, true) ~= nil
				end
			end
		end
	end
end)

UpdateBattle()
Portals.ChildAdded:Connect(UpdateBattle)
Portals.ChildRemoved:Connect(UpdateBattle)

local FarmHeader = Instance.new("TextLabel")
FarmHeader.Parent = Frame
FarmHeader.Size = UDim2.new(0.9, 0, 0.05, 0)
FarmHeader.Position = UDim2.new(0.05, 0, 0.815, 0)
FarmHeader.BackgroundTransparency = 1
FarmHeader.Text = "AUTOMATION"
FarmHeader.TextColor3 = Color3.fromRGB(150, 150, 150)
FarmHeader.TextScaled = true
FarmHeader.Font = Enum.Font.Arcade


local AutoFarmButton = Instance.new("TextButton")
AutoFarmButton.Parent = Frame
AutoFarmButton.Size = UDim2.new(0.5, 0, 0.08, 0)
AutoFarmButton.Position = UDim2.new(0, 0, 0.87, 0)
AutoFarmButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
AutoFarmButton.BorderSizePixel = 0
AutoFarmButton.Text = "AUTO FARM  :  OFF"
AutoFarmButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoFarmButton.TextScaled = true
AutoFarmButton.Font = Enum.Font.Arcade
AutoFarmButton.AutoButtonColor = false


local AutoSmartButon = Instance.new("TextButton", Frame)
AutoSmartButon.Size = UDim2.new(0.5, 0, 0.08, 0)
AutoSmartButon.Position = UDim2.new(0.5, 0, 0.87, 0)
AutoSmartButon.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
AutoSmartButon.BorderSizePixel = 0
AutoSmartButon.Text = "AUTO SMART FARM  :  OFF"
AutoSmartButon.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoSmartButon.TextScaled = true
AutoSmartButon.Font = Enum.Font.Arcade
AutoSmartButon.AutoButtonColor = false

Border(AutoFarmButton, 3)
Border(AutoSmartButon, 3)

local Farming = false

AutoFarmButton.MouseEnter:Connect(function()
	TweenService:Create(
		AutoFarmButton,
		TweenInfo.new(0.12),
		{BackgroundColor3 = Color3.fromRGB(45, 45, 45)}
	):Play()
end)

AutoFarmButton.MouseLeave:Connect(function()
	TweenService:Create(
		AutoFarmButton,
		TweenInfo.new(0.12),
		{BackgroundColor3 = Color3.fromRGB(0, 0, 0)}
	):Play()
end)

AutoSmartButon.MouseEnter:Connect(function()
	TweenService:Create(
		AutoSmartButon,
		TweenInfo.new(0.12),
		{BackgroundColor3 = Color3.fromRGB(45, 45, 45)}
	):Play()
end)

AutoSmartButon.MouseLeave:Connect(function()
	TweenService:Create(
		AutoSmartButon,
		TweenInfo.new(0.12),
		{BackgroundColor3 = Color3.fromRGB(0, 0, 0)}
	):Play()
end)

AutoFarmButton.MouseButton1Click:Connect(function()
	Farming = not Farming

	if Farming then
		AutoFarmButton.Text = "AUTO FARM  :  ON"
	else
		AutoFarmButton.Text = "AUTO FARM  :  OFF"
	end
end)

AutoSmartButon.MouseButton1Click:Connect(function()
	SmartFarm = not SmartFarm
	
	if SmartFarm then
		AutoSmartButon.Text = "AUTO SMART FARM  :  ON"
	else
		AutoSmartButon.Text = "AUTO SMART FARM  :  OFF"
	end
end)

local db = false
local db2 = false

game.RunService.RenderStepped:Connect(function()
	local Requirements = game.Players.LocalPlayer.PlayerGui.PlayerMain.Dark.InvitePlayer.Requirements
	local Teleporter = Requirements.Teleporter.Value
	local Boss = Requirements.Boss.Value

	local OnCombat = game.Players.LocalPlayer.Character:FindFirstChild("OnCombat")

	if Farming and CurrentlyFarming ~= "" and OnCombat.Value == false then
		if db2 then return end
		db2 = true
		task.delay(5, function()
			db2 = false
		end)
		local FindPortal = Portals:FindFirstChild(CurrentlyFarming)
		if FindPortal then
			local FindTeleport = FindPortal:FindFirstChild("Head")
			if FindTeleport then
				local Character = game.Players.LocalPlayer.Character
				local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
				if HumanoidRootPart then
					HumanoidRootPart.CFrame = FindTeleport.CFrame
				end
			end
		end
	end

	if Teleporter == "" and Boss == "" and AutoInv == true then return end
	if db then return end
	db = true
	task.delay(5, function()
		db = false
	end)
	game.ReplicatedStorage.GameRemotes.InvitedPlayers:FireServer(
		TargetPlayer2,
		Teleporter,
		Boss
	)




end)

local OnCombat = game.Players.LocalPlayer.Character:FindFirstChild("OnCombat")
game.RunService.RenderStepped:Connect(function()
		if SmartFarm == true and OnCombat.Value == false then

			local Player = game.Players.LocalPlayer
			local leaderstats = Player:FindFirstChild("leaderstats")
			print("Checking player stats...")
			if leaderstats then
				print("Leaderstats Found")
		     	local Level = leaderstats:FindFirstChild("LV")
			    local TP = leaderstats:FindFirstChild("TP")
				local Reset = leaderstats:FindFirstChild("Reset")
		     	local TrueReset = leaderstats:FindFirstChild("TrueReset")

				if Level and TP and Reset and TrueReset then
					print("Checking Levels Resets Tp TRUES TReEtss")
					local PlayerLevel = Level.Value
					local PlayerTP = TP.Value
					local PlayerReset = Reset.Value
					local PlayerTrueReset = TrueReset.Value

					local BestBattle = nil
					local BestSettings = nil

					local BestReset = -math.huge
					local BestTrueReset = -math.huge
					local BestLevel = -math.huge

					for _, v in pairs(game.Workspace.Portals:GetChildren()) do

						if v:IsA("Model") then

							local TelepoterConfig = v:FindFirstChild("TeleporterConfig")

							if TelepoterConfig then
								print("FOUND TELEPORTERCONFIG")
								local Settings = require(TelepoterConfig)

								local RequiredLevel = Settings.RequiredLevel or 0
								local RequiredTP = Settings.RequiredTP or 0
								local RequiredReset = Settings.RequiredReset or 0
								local RequiredTrueReset = Settings.RequiredTrueReset or 0

								local MeetsRequirements =
									RequiredLevel <= PlayerLevel
									and RequiredTP <= PlayerTP
									and RequiredReset <= PlayerReset
									and RequiredTrueReset <= PlayerTrueReset

								local Within300Levels =
									PlayerLevel <= RequiredLevel + 300

								if MeetsRequirements and Within300Levels then

									local IsBetter = false

									if RequiredReset > BestReset then
										IsBetter = true

									elseif RequiredReset == BestReset then

										if RequiredTrueReset > BestTrueReset then
											IsBetter = true

										elseif RequiredTrueReset == BestTrueReset
											and RequiredLevel > BestLevel then
											IsBetter = true
										end
									end

									if IsBetter then
										BestBattle = v
										BestSettings = Settings

										BestReset = RequiredReset
										BestTrueReset = RequiredTrueReset
										BestLevel = RequiredLevel
									end
								end
							end
						end
					end

					if BestBattle then
						print("Best Battle:", BestBattle.Name)
						print("Required Level:", BestSettings.RequiredLevel)
						print("Required TP:", BestSettings.RequiredTP)
						print("Required Reset:", BestSettings.RequiredReset)
						print("Required True Reset:", BestSettings.RequiredTrueReset)

						local FindTeleport = BestBattle:FindFirstChild("Head")
						if FindTeleport then
							local Character = game.Players.LocalPlayer.Character
							local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
							if HumanoidRootPart then
								HumanoidRootPart.CFrame = FindTeleport.CFrame
							end
						end
					end
				end
			end
	end
end)

Remote.OnClientEvent:Connect(function(InviterName, BattleName, p3, p4)
	if InviterName ~= TargetPlayer1 then return end
	if AutoAcp == false then return end

	Remote:FireServer(p3, p4)
end)

local Closebtn = Instance.new("TextButton", GUI)
Closebtn.Size = UDim2.new(0.135, 0,0.115, 0)
Closebtn.Position = UDim2.new(0.848, 0,0.303, 0)
Closebtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Closebtn.Text = "unwavering-Soul"
Closebtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Closebtn.TextScaled = true
Closebtn.Font = Enum.Font.Arcade

Border(Closebtn, 3)

Closebtn.Activated:Connect(function()
	Frame.Visible = not Frame.Visible
end)


