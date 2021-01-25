local sdotPos = {
	[1] = {-94, 99},
	[2] = {0, 69},
	[3] = {0, 142},
	[4] = {-55, 224},
	[5] = {51, 225},
	[6] = {-198, -83},
	[7] = {-59, -22},
	[8] = {-61, -8},
	[9] = {-59, 8},
	[10] = {-55, 23},
	[11] = {75, -99},
	[12] = {24, -63},
	[13] = {8, -67},
	[14] = {-8, -67},
	[15] = {-24, -63},
	[16] = {154, -40},
	[17] = {206, 0},
	[18] = {62, -16},
	[19] = {62, 0},
	[20] = {62, 16},
	[21] = {-152, 182},
	[22] = {-64, 172},
	[23] = {-172, 100},
	[24] = {-216, 21},
	[25] = {-120, 21},
	[26] = {147, 164},
	[27] = {79, 90},
	[28] = {59, 143},
	[29] = {112, 191},
	[30] = {181, 75},
	[31] = {-143, -120},
	[32] = {0, -129},
	[33] = {-80, -72},
	[34] = {-64, -180},
	[35] = {0, -182},
	[36] = {153, -113},
	[37] = {71, 233},
	[38] = {110, -11},
	[39] = {194, -85},
	[40] = {73, -182}
}

local classColors = {
	["warrior"] = {0.68, 0.51, 0.33},
	["rogue"] = {1.0, 0.96, 0.31},
	["mage"] = {0.21, 0.60, 0.74},
	["warlock"] = {0.48, 0.41, 0.69},
	["hunter"] = {0.47, 0.73, 0.25},
	["priest"] = {1.0, 1.00, 1.00},
	["paladin"] = {0.96, 0.55, 0.73},
	["druid"] = {1.0, 0.49, 0.04},
	["shaman"] = {0.0, 0.34, 0.77}
}

local Salad_PlayerName,_ = UnitName("player")
local backdrop = {
	bgFile = "Interface\\AddOns\\Salad_KelThuzad\\Images\\KT_Positioning.tga",
	edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
	tile = false,
	edgeSize = 32,
	insets = {
		left = 12,
		right = 12,
		top = 12,
		bottom = 12
	}
}

local ktFrame = CreateFrame("Frame", "KelThuzad_room", UIParent)
ktFrame:EnableMouse(true)
ktFrame:SetMovable(true)
ktFrame:SetHeight(534)
ktFrame:SetWidth(534)
ktFrame:SetPoint("CENTER", 0, 0)
ktFrame:SetBackdrop(backdrop)
ktFrame:SetAlpha(1.00)
ktFrame:SetUserPlaced(true)
ktFrame:SetFrameStrata("HIGH")
ktFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
ktFrame:SetScript("OnEvent", function()
	fillGrid()
end)
ktFrame:Hide()

local KT_Salad_Slider = CreateFrame("Slider", "KelThuzad_Salad_Slider", ktFrame, "OptionsSliderTemplate")
KT_Salad_Slider:SetPoint("BOTTOM", ktFrame, "BOTTOMRIGHT", -80, 20)
KT_Salad_Slider:SetMinMaxValues(0.05, 1.00)
KT_Salad_Slider:SetValue(1.00)
KT_Salad_Slider:SetValueStep(0.05)
getglobal(KT_Salad_Slider:GetName() .. 'Low'):SetText('5%')
getglobal(KT_Salad_Slider:GetName() .. 'High'):SetText('100%')
getglobal(KT_Salad_Slider:GetName() .. 'Text'):SetText('Opacity')
KT_Salad_Slider:SetScript("OnValueChanged", function(self)
	local value = KT_Salad_Slider:GetValue()
	ktFrame:SetAlpha(value)
end)

local KT_Salad_Header = CreateFrame("Frame", "KelThuzad_Salad_Header", ktFrame)
KT_Salad_Header:SetPoint("TOP", ktFrame, "TOP", 0, 12)
KT_Salad_Header:SetWidth(256)
KT_Salad_Header:SetHeight(64)
KT_Salad_Header:SetBackdrop({
	bgFile = "Interface\\DialogFrame\\UI-DialogBox-Header"
})

local sdrag = CreateFrame("Frame", nil, ktFrame)
sdrag:SetWidth(256)
sdrag:SetHeight(64)
sdrag:SetPoint("TOP", ktFrame, "TOP", 0, 12)
sdrag:EnableMouse(true)
sdrag:SetScript("OnMouseDown", function()
	ktFrame:StartMoving()
end)

sdrag:SetScript("OnMouseUp", function()
	ktFrame:StopMovingOrSizing()
end)

sdrag:SetScript("OnHide", function()
	ktFrame:StopMovingOrSizing()
end)

local Salad_Fontstring = KT_Salad_Header:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
Salad_Fontstring:SetPoint("CENTER", KT_Salad_Header, "CENTER", 0, 12)
Salad_Fontstring:SetText("Salad_KelThuzad")

local button = CreateFrame("Button", "KelThuzad_Close_button", ktFrame)
button:SetPoint("TOPRIGHT", ktFrame, "TOPRIGHT", -5, -5)
button:SetHeight(32)
button:SetWidth(32)
button:SetNormalTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Up")
button:SetHighlightTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight")
button:SetPushedTexture("Interface\\Buttons\\UI-Panel-oMinimizeButton-Down")
button:SetScript("OnLoad", 
	function()
		button:RegisterForClicks("AnyUp")
	end 
)
button:SetScript("OnClick", 
	function()
		ktFrame:Hide();
	end
)

--Create dot frames
for i=1,40 do
	dot = CreateFrame("Button", "KelThuzad_Dot_"..i, ktFrame)
	dot:SetPoint("CENTER", ktFrame, "CENTER", sdotPos[i][1], sdotPos[i][2])
	dot:EnableMouse(true)
	dot:SetFrameLevel(dot:GetFrameLevel()+3)
	tooltip = CreateFrame("GameTooltip", "KelThuzad_Tooltip_"..i, nil, "GameTooltipTemplate")
	local texdot = dot:CreateTexture("KelThuzad_Texture_"..i, "OVERLAY")
	dot.texture = texdot
	texdot:SetAllPoints(dot)
	texdot:SetTexture("Interface\\AddOns\\Salad_KelThuzad\\Images\\playerdot.tga")
	texdot:Hide()
	dot:SetScript("OnEnter", function()
		tooltip:SetOwner(dot, "ANCHOR_RIGHT")
		tooltip:SetText("Empty")
		tooltip:Show()
	end)
	dot:SetScript("OnLeave", function()
		tooltip:Hide()
	end)
end

function newDot(dot, tooltip, texture, name, class)
	if (Salad_PlayerName == name) then
		dot:SetWidth(36)
		dot:SetHeight(36)
	else
		dot:SetWidth(20)
		dot:SetHeight(20)
	end
	
	if name ~= "Empty" then
		texture:SetVertexColor(classColors[class][1], classColors[class][2], classColors[class][3], 1.0)
		texture:Show()
	else
		texture:Hide()
	end

	dot:SetScript("OnEnter", function()
		tooltip:SetOwner(dot, "ANCHOR_RIGHT")
		tooltip:SetText(name)
		tooltip:Show()
	end)

	dot:SetScript("OnLeave", function()
		tooltip:Hide()
	end)
end

local sdotRes = {{{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"}}, -- group 1
		  		{{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"}}, -- group 2
		  		{{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"}}, --    |
	  	  		{{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"}}, --    |
	  	  		{{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"}}, --    |
		  		{{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"}}, --    |
		  		{{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"}}, --    |
		  		{{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"}}} -- group 8

function getRaidInfo()
	local lastgroupIndex = 1
	local c = 1
	for i=1,40 do		
		local name,_,subgroup,_,class = GetRaidRosterInfo(i);

		if name == nil then
			return
		end

		if(lastgroupIndex ~= subgroup) then
			lastgroupIndex = subgroup
			c = 1
		end

		sdotRes[subgroup][c] = {name, class}
		c = c + 1
	end
end

function fillGrid()
	wipeReserves()
	getRaidInfo()
	for i=1,8 do
		for j=1,5 do
			local x = ((i-1)*5)+j
			newDot(_G["KelThuzad_Dot_"..x], _G["KelThuzad_Tooltip_"..x], _G["KelThuzad_Texture_"..x], sdotRes[i][j][1], strlower(sdotRes[i][j][2]))
		end
	end
end

function wipeReserves()
	for i=1,8 do
		for j=1,5 do
			for k=1,2 do
				sdotRes[i][j][k] = "Empty"
			end
		end
	end
end

SLASH_KT1 = "/kt";

local function HandleSlashCommands(str)
	if (str == "help") then
		print("|cffffff00Commands:");
		print("|cffffff00   /kt |cff00d2d6help |r|cffffff00-- show this help menu");
		print("|cffffff00   /kt -- open kelthuzad map");
	elseif (str == "fill" or str == "" or str == nil) then
		ktFrame:Show();
		fillGrid()
	else
		print("|cffffff00Command not found");
	end
end

SlashCmdList.KT = HandleSlashCommands;
