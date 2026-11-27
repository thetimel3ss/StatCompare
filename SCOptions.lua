
local realmName;
local playerName;

STATCOMPARE_DEFAULT_MINIMAP_POSITION = 45;

StatCompare_OPTIONS = {
	["ShowSTR"] = {
		["default"] = 1 },
	["ShowAGI"] = {
		["default"] = 1 },
	["ShowSTA"] = {
		["default"] = 1 },
	["ShowINT"] = {
		["default"] = 1 },
	["ShowSPI"] = {
		["default"] = 1 },
	["ShowArmor"] = {
		["default"] = 1 },
	["ShowEnArmor"] = {
		["default"] = 1 },
	["ShowDR"] = {
		["default"] = 1 },
	["ShowArcaneRes"] = {
		["default"] = 1 },
	["ShowFireRes"] = {
		["default"] = 1 },
	["ShowNatureRes"] = {
		["default"] = 1 },
	["ShowFrostRes"] = {
		["default"] = 1 },
	["ShowShadowRes"] = {
		["default"] = 1 },
	["ShowDetarRes"] = {
		["default"] = 1 },
	["ShowFishing"] = {
		["default"] = 1 },
	["ShowMining"] = {
		["default"] = 1 },
	["ShowHerbalism"] = {
		["default"] = 1 },
	["ShowSkinning"] = {
		["default"] = 1 },
	["ShowDefense"] = {
		["default"] = 1 },
	["ShowBlock"] = {
		["default"] = 1 },
	["ShowToBlock"] = {
		["default"] = 1 },
	["ShowDodge"] = {
		["default"] = 1 },
	["ShowParry"] = {
		["default"] = 1 },
	["ShowAP"] = {
		["default"] = 1 },
	["ShowCrit"] = {
		["default"] = 1 },
	["ShowRAP"] = {
		["default"] = 1 },
	["ShowRCrit"] = {
		["default"] = 1 },
	["ShowToHit"] = {
		["default"] = 1 },
	["ShowHealthRegen"] = {
		["default"] = 1 },
	["ShowHealth"] = {
		["default"] = 1 },
	["ShowManaRegen"] = {
		["default"] = 1 },
	["ShowManaRegenSPI"] = {
		["default"] = 1 },
	["ShowMana"] = {
		["default"] = 1 },
	["MinimapButtonPosition"] = {
		["default"] = STATCOMPARE_DEFAULT_MINIMAP_POSITION },
	["ShowMinimapIcon"] = {
		["default"] = 1 },
	["ShowSelfFrame"] = {
		["default"] = 1	},
	["ShowBuffBonus"] = {
		["default"] = 1	},
	["ShowPlayerEquippedItems"] = {
		["default"] = 1	},
	["ShowPlayerEquippedEnchants"] = {
		["default"] = 1	},
	["ShowPlayerActiveBuffs"] = {
		["default"] = 1	},
	["ShowPlayerBasicStats"] = {
		["default"] = 1	},
	["ShowPlayerTalentSpec"] = {
		["default"] = 1	},
	["ShowPlayerSpellPowerStats"] = {
		["default"] = 0	},
	["ShowPlayerEquippedItems"] = {
		["default"] = 1	},
	["ShowTargetEquippedEnchants"] = {
		["default"] = 1	},
	["ShowTargetActiveBuffs"] = {
		["default"] = 1	},
	["ShowTargetBasicStats"] = {
		["default"] = 1	},
	["ShowTargetTalentSpec"] = {
		["default"] = 1	},
	["ShowTargetSpellPowerStats"] = {
		["default"] = 0	},
}

function StatCompare_Toggle()
	if(not StatCompareOptFrame) then
		return
	end
	if(StatCompareOptFrame:IsVisible()) then
		StatCompareOptFrame:Hide();
	else
		StatCompareOptFrame:Show();
		for i=1,2 do
			getglobal("StatCompareOptTab"..i):UnlockHighlight();
			getglobal("StatCompareOptSubFrame"..i):Hide();
		end
		getglobal("StatCompareOptTab"..1):LockHighlight();
		getglobal("StatCompareOptSubFrame"..1):Show();
		if(StatCompare_Player and StatCompare_Player["Settings"]) then
			for k,v in pairs(StatCompare_Player["Settings"]) do
				if(getglobal(k)) then
					if(v == 1) then
						getglobal(k):SetChecked(1);
					else
						getglobal(k):SetChecked(0);
					end
				end
			end
		end
		local value=StatCompare_GetSetting("ShowMinimapIcon");
		if(value == 0) then
			getglobal("StatCompareShowMinimapOpt"):SetChecked(0);
		else
			getglobal("StatCompareShowMinimapOpt"):SetChecked(1);
		end
		local value=StatCompare_GetSetting("ShowSelfFrame");
		if(value == 0) then
			getglobal("StatCompareShowSelfFrameOpt"):SetChecked(0);
		else
			getglobal("StatCompareShowSelfFrameOpt"):SetChecked(1);
		end
		local value=StatCompare_GetSetting("ShowBuffBonus");
		if(value == 0) then
			getglobal("StatCompareShowBuffBonusOpt"):SetChecked(0);
		else
			getglobal("StatCompareShowBuffBonusOpt"):SetChecked(1);
		end
	end
end

local minimapMenu;

local function StatCompareMinimapMenu_Initialize()
	local enabled = StatCompare_enable == 1;
	UIDropDownMenu_AddButton({
		text = enabled and STATCOMPARE_MINIMAP_DISABLE or STATCOMPARE_MINIMAP_ENABLE,
		notCheckable = 1,
		func = function()
			STATCOMPARE_SlashCmdHandler(enabled and "off" or "on");
		end,
	}, 1);
	UIDropDownMenu_AddButton({
		text = STATCOMPARE_MINIMAP_CONFIG,
		notCheckable = 1,
		func = function()
			if StatCompareOptFrame and not StatCompareOptFrame:IsVisible() then
				StatCompare_Toggle();
			end
		end,
	}, 1);
end

function StatCompareMinimapButton_ShowMenu()
	GameTooltip:Hide();
	if not minimapMenu then
		minimapMenu = CreateFrame("Frame", "StatCompareMinimapMenu", UIParent, "UIDropDownMenuTemplate");
		UIDropDownMenu_Initialize(minimapMenu, StatCompareMinimapMenu_Initialize, "MENU");
	end
	ToggleDropDownMenu(1, nil, minimapMenu, "StatCompareMinimapButton", 0, 0);
end

function StatCompareMinimapButton_UpdatePosition()
	local showIcon = StatCompare_GetSetting("ShowMinimapIcon");
	if(showIcon == 1) then
		local where = StatCompare_GetSetting("MinimapButtonPosition");
		StatCompareMinimapFrame:ClearAllPoints();
		StatCompareMinimapFrame:SetPoint("TOPLEFT", "Minimap", "TOPLEFT",
					 52 - (80 * cos(where)),
					 (80 * sin(where)) - 52);
	end
end

function StatCompareOptCheck_OnClick()
	local value = 0;

	if(this:GetChecked()) then
		value = 1;
	end
	StatCompare_SetSetting(this:GetName(), value);
end

function StatCompareOptTab_OnClick()
	local id,i = this:GetID()
	PlaySound("GAMEGENERICBUTTONPRESS")

	if id and id>0 then
		for i=1,2 do
			getglobal("StatCompareOptTab"..i):UnlockHighlight();
			getglobal("StatCompareOptSubFrame"..i):Hide();
		end
		getglobal("StatCompareOptTab"..id):LockHighlight();
		getglobal("StatCompareOptSubFrame"..id):Show();
		if(id == 1 and StatCompare_Player and StatCompare_Player["Settings"]) then
			for k,v in pairs(StatCompare_Player["Settings"]) do
				if(getglobal(k)) then
					if(v == 1) then
						getglobal(k):SetChecked(1);
					else
						getglobal(k):SetChecked(0);
					end
				end
			end
		end

	end
end

function StatCompareOptFrame_Hide()
	StatCompare_SaveConfigInfo();
	StatCompareOptFrame:Hide();
end

function StatCompare_CheckPlayerInfo()
	local tabs = { "Settings" };

	if ( not StatCompare_Player ) then
		StatCompare_Player = {};
		for _,tab in pairs(tabs) do
			StatCompare_Player[tab] = { };
		end

		if ( StatCompare_Info[realmName] and
			StatCompare_Info[realmName]["Settings"] and
			StatCompare_Info[realmName]["Settings"][playerName] ) then
			for _,tab in pairs(tabs) do
				if ( StatCompare_Info[realmName][tab] and
					StatCompare_Info[realmName][tab][playerName] ) then
					for k,v in pairs(StatCompare_Info[realmName][tab][playerName]) do
						StatCompare_Player[tab][k] = v;
					end
				end
			end
		end
	elseif ( StatCompare_Info[realmName] and StatCompare_Info[realmName]["Settings"] ) then
		-- the saved information is there, kill the old stuff
		for _,tab in pairs(tabs) do
			if ( StatCompare_Info[realmName][tab] ) then
				StatCompare_Info[realmName][tab][playerName] = nil;
				if ( next(StatCompare_Info[realmName][tab]) == nil ) then
					StatCompare_Info[realmName][tab] = nil;
				end
			end
		end
		if ( next(StatCompare_Info[realmName]) == nil ) then
			StatCompare_Info[realmName] = nil;
		end
	end
end

-- Fill in the player name and realm
function StatCompare_SetupNameInfo()
	playerName = UnitName("player");
	realmName = GetRealmName();
	return playerName, realmName;
end

function StatCompare_SetSetting(setting, value)
	if ( StatCompare_Player and setting ) then
		local val = StatCompare_GetDefault(setting);
		if ( val == value ) then
			StatCompare_Player["Settings"][setting] = nil;
		else
			StatCompare_Player["Settings"][setting] = value;
		end
	end
end

function StatCompare_GetSetting(setting)
	if ( not StatCompare_Player or not StatCompare_Player["Settings"] ) then
		return;
	end
	local val = StatCompare_Player["Settings"][setting];
	if ( val == nil ) then
		val = StatCompare_GetDefault(setting);
	end
	return val;
end

function StatCompare_GetDefault(setting)
	local opt = StatCompare_OPTIONS[setting];
	if ( opt ) then
		if ( opt.check and opt.checkfail ) then
			if ( not opt.check() ) then
				return opt.checkfail;
			end
		end
		return opt.default;
	end
end

function StatCompare_SaveConfigInfo()
	if ( StatCompare_Info[realmName] and
		StatCompare_Info[realmName]["Settings"] and
		StatCompare_Info[realmName]["Settings"][playerName] ) then
		local tabs = { "Settings" };
		for _,tab in pairs(tabs) do
			for k,v in pairs(StatCompare_Player[tab]) do
				StatCompare_Info[realmName][tab][playerName][k] = v;
			end
		end
	end
end

function StatCompare_InitConfig()
	playerName, realmName = StatCompare_SetupNameInfo();
	if( not StatCompare_Info ) then
		StatCompare_Info = { };
	end
	
	-- global stuff
	StatCompare_CheckRealm();
	StatCompare_CheckPlayerInfo();
	
	-- per user stuff
	if ( not StatCompare_Player["Settings"] ) then
		StatCompare_Player["Settings"] = { };
	end
	if(StatCompareMinimapFrame) then
		StatCompareMinimapButton_UpdatePosition();
	end
end

function StatCompare_CheckRealm()
	local legacySettings = StatCompare_Info["Settings"];
	if not legacySettings then return; end

	local old = legacySettings[playerName];
	if old then
		local realm = StatCompare_Info[realmName] or {};
		StatCompare_Info[realmName] = realm;
		realm["Settings"] = realm["Settings"] or {};

		local settings = realm["Settings"][playerName] or {};
		realm["Settings"][playerName] = settings;
		for key, value in pairs(old) do
			if settings[key] == nil then
				settings[key] = value;
			end
		end
		if StatCompare_Player then
			StatCompare_Player["Settings"] = StatCompare_Player["Settings"] or {};
			for key in pairs(old) do
				if StatCompare_Player["Settings"][key] == nil then
					StatCompare_Player["Settings"][key] = settings[key];
				end
			end
		end
		legacySettings[playerName] = nil;
	end

	if UNKNOWNOBJECT then legacySettings[UNKNOWNOBJECT] = nil; end
	if UNKNOWNBEING then legacySettings[UNKNOWNBEING] = nil; end
	if next(legacySettings) == nil then
		StatCompare_Info["Settings"] = nil;
	end
end

function StatCompareShowMinimapOpt_OnClick()
	local value = 0;

	if(this:GetChecked()) then
		value = 1;
	end
	StatCompare_SetSetting("ShowMinimapIcon", value);
	if(value == 0 and StatCompareMinimapFrame:IsVisible()) then
		StatCompareMinimapFrame:Hide();
	elseif(value == 1 and not StatCompareMinimapFrame:IsVisible()) then
		StatCompareMinimapFrame:Show();
		StatCompareMinimapButton_UpdatePosition()
	end
end

function StatCompareShowSelfFrameOpt_OnClick()
	local value = 0;

	if(this:GetChecked()) then
		value = 1;
	end
	StatCompare_SetSetting("ShowSelfFrame", value);	
end

function StatCompareShowBuffBonusOpt_OnClick()
	local value = 0;

	if(this:GetChecked()) then
		value = 1;
	end
	StatCompare_SetSetting("ShowBuffBonus", value);	
end
