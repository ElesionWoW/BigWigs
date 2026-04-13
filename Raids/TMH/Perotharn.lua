local module, L = BigWigs:ModuleDeclaration("Peroth'arn", "Timbermaw Hold")

-- module variables
module.revision = 30138
module.enabletrigger = module.translatedName
module.toggleoptions = { "flames", "flamesothers", "flamesmark", "flamesfear", "spiral", -1, "disarm", "dirk", "curse", "burst", "bosskill" }

local _, playerClass = UnitClass("player")

-- module defaults
module.defaultDB = {
	flames = true,
	flamesothers = false,
	flamesmark = true,
	flamesfear = false,
	spiral = true,
	--shield = true,
	disarm = true,
	dirk = true,
	curse = false,
	burst = true,
}

-- localization
L:RegisterTranslations("enUS", function()
	return {
		cmd = "Perotharn",

		flames_cmd = "flames",
		flames_name = "Flames of Purgation alert",
		flames_desc = "Personal alert about being afflicted by Flames of Purgation and a timer bar for incoming fear",

		flamesothers_cmd = "flamesothers",
		flamesothers_name = "Flames of Purgation warning",
		flamesothers_desc = "Warning messages about all 4 victims of Flames of Purgation",

		flamesmark_cmd = "flamesmark",
		flamesmark_name = "Flames of Purgation marks",
		flamesmark_desc = "Mark all 4 victims of Flames of Purgation with available raid targets",

		flamesfear_cmd = "flamesfear",
		flamesfear_name = "Fear warning",
		flamesfear_desc = "Warning message about feared players after Flames of Purgation expires",

		spiral_cmd = "spiral",
		spiral_name = "Spiral of Hellfire alert",
		spiral_desc = "Personal alert about being afflicted by Spiral of Hellfire (250 fire damage to you when anyone around you takes damage)",

		--shield_cmd = "shield",
		--shield_name = "Shield bar",
		--shield_desc = "A bar keeping track of Nightmarish Absorption (300k shield) - requires SuperWoW!",

		disarm_cmd = "disarm",
		disarm_name = "Disarm alert",
		disarm_desc = "Alert when Peroth'arn becomes vulnerable",

		dirk_cmd = "dirk",
		dirk_name = "Dirk alert",
		dirk_desc = "Personal alert when you stand in the mind-control zone/beam (Dirk of the Beast)",

		curse_cmd = "curse",
		curse_name = "Satyr Curse warning",
		curse_desc = "Warning message about mind-controlled players who stood in in the zone/beam",

		burst_cmd = "burst",
		burst_name = "Nightmare Burst cast bar",
		burst_desc = "Shows a cast bar for incoming knockback (Nightmare Burst)",

		trigger_flames = "(.+) ...? afflicted by Flames of Purgation",
		trigger_flamesEmote = "casts Flames of Purgation!",
		msg_flames = "%s has Flames of Purgation",
		msg_flamesYou = "YOU have Flames - don't be near people when it expires",
		msg_flamesFear = "%s is feared",
		bar_flames = "Fear from Flames",

		trigger_spiral = "You are afflicted by Spiral of Hellfire",
		msg_spiral = "Spiral - anyone around you taking damage will hurt you!",
		bar_spiral = "Spiral of Hellfire",
		
		trigger_dirk = "You are afflicted by Dirk of the Beast",
		trigger_dirkFade = "Dirk of the Beast fades from you.",
		warn_dirk = "MOVE",
		
		trigger_shield = "Wretched pests! You shall join the ranks of the enlightened!",
		bar_shield = "Shield",
		trigger_disarm = "becomes vulnerable!",
		warn_disarm = "DISARM",
		trigger_disarmed = "Insolent vermin! You will regret this!",
		
		trigger_curse = "(.+) ...? afflicted by Satyr Curse",
		trigger_curseHostile = "(.+) %(Peroth'arn%) is afflicted by Satyr Curse",
		msg_curse = "MC on %s",
		
		trigger_burst = "Peroth'arn begins to perform Nightmare Burst.",
		bar_burst = "incoming Knockback",
	}
end)

-- timer and icon variables
local timer = {
	flames = 8,
	spiral = 15,
	dirk = 3,
	burst = 3,
}

local icon = {
	flames = "Spell_Fire_Immolation",
	flamesFear = "Spell_Shadow_Possession",
	spiral = "Spell_Fire_Incinerate",
	shield = "Spell_Holy_PowerWordShield",
	dirk = "Spell_Holy_InnerFire",
	disarm = "Ability_Warrior_Disarm",
	burst = "Spell_Nature_ThunderClap",
}

local syncName = {
	flames = "THPerotharnFlames" .. module.revision,
	burst = "THPerotharnBurst" .. module.revision,
}

local guid = {
	perotharn = "0xF13000ED0E27A356",
}

local spellId = {
}

local fearWindow = {0, 0}
local shield = 0

function module:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "AfflictionEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "AfflictionEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "AfflictionEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE", "AfflictionEvent") -- for mind-control
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE", "AfflictionEvent") -- for pets

	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF", "FadesEvent")
	--self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_PARTY", "FadesEvent")
	--self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER", "FadesEvent")

	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "CastEvent")
	--self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF", "CastEvent")

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")

	self:ThrottleSync(3, syncName.burst)
end

function module:OnSetup()
end

function module:OnEngage()
	if self.core:IsModuleActive("Timbermaw Trash", "Timbermaw Hold") then
		self.core:DisableModule("Timbermaw Trash", "Timbermaw Hold")
	end
end

function module:OnDisengage()
end

function module:AfflictionEvent(msg)
	if self.db.profile.dirk and string.find(msg, L["trigger_dirk"]) then
		self:Sound("Beware")
		self:WarningSign(icon.dirk, timer.dirk, true, L["warn_dirk"])
		return
	end
	if self.db.profile.spiral and string.find(msg, L["trigger_spiral"]) then
		self:Message(L["msg_spiral"], "Important", true, "Info")
		self:Bar(L["bar_spiral"], timer.spiral, icon.spiral)
		return
	end

	local _, _, player = string.find(msg, L["trigger_flames"])
	if player then
		player = player == "You" and UnitName("player") or player
		self:Sync(syncName.flames .. player) -- bake player into sync name to throttle per player
		return
	end
	local _, _, player = string.find(msg, L["trigger_curse"])
	if self.db.profile.curse and player then
		player = player == "You" and UnitName("player") or player
		self:Message(string.format(L["msg_curse"],player), "Important")
		return
	end
	local _, _, player = string.find(msg, L["trigger_curseHostile"])
	if self.db.profile.curse and player then
		self:Message(string.format(L["msg_curse"],player), "Important")
		return
	end
end

function module:FadesEvent(msg)
	if self.db.profile.dirk and msg == L["trigger_dirkFade"] then
		self:RemoveWarningSign(icon.dirk)
		self:Sound("Long")
	end
end

function module:CastEvent(msg)
	if msg == L["trigger_burst"] then
		self:Sync(syncName.burst)
	end
end

function module:CHAT_MSG_MONSTER_YELL(msg)
	if self.db.profile.shield and msg == L["trigger_shield"] then
		shield = 300000
		self:CounterBar(L["bar_shield"], 300, icon.shield, guid.perotharn, nil, false, "%dk", true, "Blue")
	end
	if msg == L["trigger_disarmed"] then
		self:RemoveWarningSign(icon.disarm)
	end
end

function module:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if string.find(msg, L["trigger_flamesEmote"]) then
		fearWindow[1] = GetTime() + 1
		fearWindow[2] = GetTime() + 1 + timer.flames
		if self.db.profile.flames then
			self:Bar(L["bar_flames"], timer.flames, icon.flamesFear)
		end
		return
	elseif string.find(msg, L["trigger_disarm"]) then
		self:RemoveBar(L["bar_shield"])
		if self.db.profile.disarm then
			self:Sound("Alarm")
			self:WarningSign(icon.disarm, 300, false, L["warn_disarm"])
		end
		return
	end
end

function module:BigWigs_RecvSync(sync, rest, nick)
	local _, _, player = string.find(sync, syncName.flames .. "(.+)")
	if player then
		self:FlamesOfPurgation(player)
		return
	end
	if self.db.profile.burst and sync == syncName.burst then
		self:Bar(L["bar_burst"], timer.burst, icon.burst)
		return
	end
end

function module:FlamesOfPurgation(player)
	if GetTime() > fearWindow[1] and GetTime() < fearWindow[2] then -- we are between 1 and 9 seconds after the last Flames cast, so it must be a fear
		if self.db.profile.flamesfear then
			self:Message(string.format(L["msg_flamesFear"],player), "Attention", nil, "Alert")
		end
	else -- we are outside of the fear window, it must be a new debuff
		if player == UnitName("player") and self.db.profile.flames then
			self:WarningSign(icon.flames, 1)
			self:Message(string.format(L["msg_flamesYou"],player), "Urgent", true, "Beware")
		elseif self.db.profile.flamesothers then
			self:Message(string.format(L["msg_flames"],player), "Urgent")
		end
		if self.db.profile.flamesmark then
			local markToUse = self:GetAvailableRaidMark(nil, true)
			if markToUse then
				self:SetRaidTargetForPlayer(player, markToUse)
				self:ScheduleEvent("RemoveFlamesMark"..player, self.RestoreInitialRaidTargetForPlayer, timer.flames, self, player)
			end
		end
	end
end

function module:Test()
	self:Engage()

	-- test characters
	local player = UnitName("player")
	local raid1 = UnitName("raid1") or "Raid1"
	local raid2 = UnitName("raid2") or "Raid2"
	local raid3 = UnitName("raid3") or "Raid3"
	local raid4 = UnitName("raid4") or "Raid4"

	local events = {
		-- Flames 1
		{ time = 2, func = function()
			print("Test: Flames of Purgation cast and initial debuffs onto you, "..raid1..", "..raid2)
			self:TriggerEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", raid1.." is afflicted by Flames of Purgation.")
			self:TriggerEvent("CHAT_MSG_RAID_BOSS_EMOTE", "%s casts Flames of Purgation!", "Peroth'arn")
			self:TriggerEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "You are afflicted by Flames of Purgation.")
			self:TriggerEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", raid2.." is afflicted by Flames of Purgation.")
		end },

		-- Fear 1
		{ time = 10, func = function()
			local msg = raid3.." is afflicted by Flames of Purgation."
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", msg)
		end },
		{ time = 10, func = function()
			local msg = raid4.." is afflicted by Flames of Purgation."
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", msg)
		end },

		-- Flames 2
		{ time = 26, func = function()
			print("Test: Flames of Purgation cast and initial debuffs onto you, "..raid1..", "..raid2)
			self:TriggerEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", raid1.." is afflicted by Flames of Purgation.")
			self:TriggerEvent("CHAT_MSG_RAID_BOSS_EMOTE", "%s casts Flames of Purgation!", "Peroth'arn")
			self:TriggerEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "You are afflicted by Flames of Purgation.")
			self:TriggerEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", raid2.." is afflicted by Flames of Purgation.")
		end },

		-- Fear 2
		{ time = 34, func = function()
			local msg = raid3.." is afflicted by Flames of Purgation."
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", msg)
		end },
		{ time = 34, func = function()
			local msg = raid4.." is afflicted by Flames of Purgation."
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", msg)
		end },

		-- Spiral
		{ time = 13, func = function()
			local msg = "You are afflicted by Spiral of Hellfire."
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", msg)
		end },

		-- Shield
		{ time = 16, func = function()
			local msg = "Wretched pests! You shall join the ranks of the enlightened!"
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_MONSTER_YELL", msg, "Peroth'arn")
		end },

		-- Dirk 1
		{ time = 18, func = function()
			local msg = "You are afflicted by Dirk of the Beast."
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", msg)
		end },
		{ time = 20, func = function()
			local msg = "Dirk of the Beast fades from you."
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_SPELL_AURA_GONE_SELF", msg)
		end },
		{ time = 21, func = function()
			local msg = raid1.." is afflicted by Satyr Curse."
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", msg)
		end },

		-- Dirk 2
		{ time = 21, func = function()
			local msg = "You are afflicted by Dirk of the Beast."
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", msg)
		end },
		{ time = 24, func = function()
			local msg = "Dirk of the Beast fades from you."
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_SPELL_AURA_GONE_SELF", msg)
		end },
		{ time = 24, func = function()
			local msg = "You are afflicted by Satyr Curse."
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", msg)
		end },
		{ time = 24, func = function()
			local msg = raid2.." is afflicted by Satyr Curse."
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", msg)
		end },
		{ time = 24, func = function()
			local msg = raid3.." is afflicted by Satyr Curse."
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE", msg)
		end },
		{ time = 24, func = function()
			local msg = "Pet is afflicted by Satyr Curse."
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE", msg)
		end },

		-- Disarm
		{ time = 29, func = function()
			local msg = "%s becomes vulnerable!"
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_RAID_BOSS_EMOTE", msg, "Peroth'arn")
		end },
		{ time = 31, func = function()
			local msg = "Insolent vermin! You will regret this!"
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_MONSTER_YELL", msg, "Peroth'arn")
		end },

		-- Burst
		{ time = 36, func = function()
			local msg = "Peroth'arn begins to perform Nightmare Burst."
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", msg)
		end },

		-- End of Test
		{ time = 40, func = function()
			print("Test: Disengage")
			module:Disengage()
		end },
	}

	-- Schedule each event
	for i, event in ipairs(events) do
		self:ScheduleEvent("PerotharnTest" .. i, event.func, event.time)
	end

	self:Message(module.translatedName .. " test started", "Positive")
	return true
end

-- Test command: /run BigWigs:GetModule("Peroth'arn"):Test()
