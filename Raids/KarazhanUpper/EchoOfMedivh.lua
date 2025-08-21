local module, L = BigWigs:ModuleDeclaration("Echo of Medivh", "Karazhan")

-- module variables
module.revision = 30002
module.enabletrigger = module.translatedName
module.toggleoptions = { "corruption", "corruptionmark", "corruptionyell", "corruptiontarget", -1, "doom", "potionstrat", "cancelrestopot", -1, "arcanefocus", "echoflamestrike", -1, "irestacks", "castfrostnova", "castshadowbolt", "castpyroblast", "castflamestrike", -1, "printecho", "bosskill" }
module.zonename = {
	AceLibrary("AceLocale-2.2"):new("BigWigs")["Tower of Karazhan"],
	AceLibrary("Babble-Zone-2.2")["Tower of Karazhan"],
}

-- module defaults
module.defaultDB = {
	corruption = true,
	corruptionmark = true,
	corruptionyell = true,
	corruptiontarget = false,
	doom = true,
	potionstrat = false,
	cancelrestopot = true,
	arcanefocus = false,
	echoflamestrike = true,
	irestacks = false,
	castfrostnova = false,
	castshadowbolt = false,
	castpyroblast = false,
	castflamestrike = false,
	printecho = false,
}

-- localization
L:RegisterTranslations("enUS", function()
	return {
		cmd = "EchoMedivh",

		corruption_cmd = "corruption",
		corruption_name = "Corruption of Medivh Alert",
		corruption_desc = "Warns when players are afflicted by Corruption of Medivh",

		corruptionmark_cmd = "corruptionmark",
		corruptionmark_name = "Corruption Raid Mark",
		corruptionmark_desc = "Marks players with Corruption of Medivh and restores previous mark when it fades",

		corruptionyell_cmd = "corruptionyell",
		corruptionyell_name = "Corruption Announce",
		corruptionyell_desc = "Makes corrupted players /say a warning",

		corruptiontarget_cmd = "corruptiontarget",
		corruptiontarget_name = "Corruption Target",
		corruptiontarget_desc = "Auto-targets the Corruption victim",

		doom_cmd = "doom",
		doom_name = "Doom of Medivh Alert",
		doom_desc = "Shows timer for Doom of Medivh stacks",

		potionstrat_cmd = "potionstrat",
		potionstrat_name = "Resto Pot Strategy",
		potionstrat_desc = "Show timers for raid-wide Restorative Potion usage at Doom 4. 3s to use potion, 5s for ghost spawn, 2s to yell for dispel if still Doomed.",

		cancelrestopot_cmd = "cancelrestopot",
		cancelrestopot_name = "Auto-Cancel Resto Potion",
		cancelrestopot_desc = "Automatically cancels your Restorative Potion when Doom of Medivh fades",

		arcanefocus_cmd = "arcanefocus",
		arcanefocus_name = "Arcane Focus Alert",
		arcanefocus_desc = "Warns when the tank gains Arcane Focus (+40% magic damage taken; for dispellers)",

		echoflamestrike_cmd = "echoflamestrike",
		echoflamestrike_name = "Flamestrike Alert",
		echoflamestrike_desc = "Warns when you stand in fire",

		irestacks_cmd = "irestacks",
		irestacks_name = "Guardian's Ire",
		irestacks_desc = "Keep track of Guardian's Ire to know when to safely interrupt",

		castfrostnova_cmd = "castfrostnova",
		castfrostnova_name = "Frost Nova cast",
		castfrostnova_desc = "Warn when Echo starts casting Frost Nova (for interrupters)",

		castshadowbolt_cmd = "castshadowbolt",
		castshadowbolt_name = "Shadow Bolt cast",
		castshadowbolt_desc = "Warn when Echo starts casting Shadow Bolt (for interrupters)",

		castpyroblast_cmd = "castpyroblast",
		castpyroblast_name = "Pyroblast cast",
		castpyroblast_desc = "Warn when Echo starts casting Pyroblast (for interrupters)",

		castflamestrike_cmd = "castflamestrike",
		castflamestrike_name = "Flamestrike cast",
		castflamestrike_desc = "Warn when Echo starts casting Flamestrike (for interrupters)",

		printecho_cmd = "printecho",
		printecho_name = "Troubleshoot Info",
		printecho_desc = "Print information to your main chat window: Corruption gains, successful Shadow Bolt casts",



		trigger_corruptionYou = "You are afflicted by Corruption of Medivh",
		trigger_corruptionOther = "(.+) is afflicted by Corruption of Medivh",
		trigger_corruptionFade = "Corruption of Medivh fades from you",
		trigger_corruptionFadeOther = "Corruption of Medivh fades from (.+)",
		msg_corruptionYou = "YOU have Corruption! Get away from others!",
		msg_corruptionOther = "%s has Corruption! Get away from them!",
		msg_corruptionSpread = "Corruption is spreading!",
		warning_corruptedGetAway = "CORRUPTED, GET AWAY",
		yell_corruption = "I am corrupted! STAY AWAY!",
		bar_corruption = "Corruption of Medivh",

		trigger_doomYou1 = "You are afflicted by Doom of Medivh%.",
		trigger_doomYou = "You are afflicted by Doom of Medivh %((%d+)%)",
		trigger_doomFade = "Doom of Medivh fades from",
		bar_doom = "Doom of Medivh (%d)",
		warn_doom = "DOOM 4",
		
		bar_potion = "Use potion",
		msg_potion = "Use Restorative Potion now!",
		bar_ghosts = "Ghosts spawn",
		msg_ghosts = "Dispel your own Doom, nuke ghosts!",
		yell_emergency = "I still have Doom! Dispel me!",

		resto_pot_cancelling = "Cancelling Resto Pot since Doom was removed",
		
		trigger_arcanefocus = "(.+) is afflicted by Arcane Focus",
		msg_arcanefocus = "Arcane Focus on %s - dispel them!",
		warn_arcanefocus = "DISPEL %s",
		
		trigger_flamestrike = "You are afflicted by Flamestrike",
		msg_flamestrike = "Move out of Flamestrike!",
		warn_flamestrike = "MOVE",
		
		trigger_fury1 = "Echo of Medivh gains Medivh's Fury%.",
		trigger_fury = "Echo of Medivh gains Medivh's Fury %((.+)%)%.",
		trigger_furyFade = "Medivh's Fury fades from Echo of Medivh",
		msg_fury = "FURY! +%d%% cast speed",
		
		trigger_ire1 = "Echo of Medivh gains Guardian's Ire%.",
		trigger_ire = "Echo of Medivh gains Guardian's Ire %((.+)%).",
		trigger_ireFade = "Guardian's Ire fades from Echo of Medivh",
		msg_ire = "Interrupt %d of 3",
		bar_ire = "Interrupt Stacks Reset",
		
		trigger_cast = "Echo of Medivh begins to cast (.+)%.",
		spell_FrostNova = "Frost Nova",
		spell_ShadowBolt = "Shadow Bolt",
		spell_Pyroblast = "Pyroblast",
		spell_Flamestrike = "Flamestrike",
		msg_cast = "%s incoming!",
		warn_cast = "INTERRUPT!",
		
		trigger_shadowBoltHit = "Echo of Medivh's Shadow Bolt",
	}
end)

-- timer and icon variables
local timer = {
	corruption = 12, -- duration of corruption debuff
	doomMin = 14, -- minimum time between Doom stacks
	doomMax = 24, -- maximum time between Doom stacks
	potionDelay = 3, -- use potion after Doom 4
	ghostsDelay = 5, -- ghosts spawn after potion
	emergencyDelay = 2, -- stragglers yell after ghosts
	ireReset = 15, -- stragglers yell after ghosts
}

local icon = {
	corruption = "INV_Misc_ShadowEgg", -- icon for corruption
	doom = "Spell_Nature_Drowsy", -- icon for doom
	frostnova = "Spell_Frost_FrostNova",
	shadowbolt = "Spell_Shadow_ShadowBolt",
	pyroblast = "Spell_Fire_Fireball02",
	flamestrike = "Spell_Fire_SelfDestruct",
	restopot = "INV_Potion_118",
	ghosts = "Spell_Shadow_Haunting",
	focus = "Spell_Holy_FlashHeal",
	ire = "Spell_Shadow_Possession",
}

local syncName = {
	corruption = "EchoMedivhCorruption" .. module.revision,
	arcanefocus = "EchoMedivhArcaneFocus" .. module.revision,
}

local maxCorruptedPlayers = 10
local doomStackCount = 0
local playerMarks = {}
local firstDoomFour = 1
local lastCorruption = 0

function module:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "AfflictionEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "AfflictionEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "SpellHitEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE", "SpellHitEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE", "SpellHitEvent")
end

function module:OnSetup()
	self.started = nil
	playerMarks = {}
end

function module:OnEngage()
	doomStackCount = 0
	firstDoomFour = 1
	lastCorruption = 0
end

function module:OnDisengage()
end

function module:AfflictionEvent(msg)
	-- Corruption of Medivh
	if string.find(msg, L["trigger_corruptionYou"]) then
		local player = UnitName("player")
		self:CorruptionOfMedivh(player) -- let's not miss a sync
		self:Sync(syncName.corruption .. " " .. player)
		if self.db.profile.printecho then
			print(msg)
		end
	else
		local _, _, player = string.find(msg, L["trigger_corruptionOther"])
		if player then
			self:Sync(syncName.corruption .. " " .. player)
			if self.db.profile.printecho then
				print(msg)
			end
		end
	end

	-- Doom of Medivh
	if string.find(msg, L["trigger_doomYou1"]) then
		self:DoomOfMedivh(1)
	end
	local _, _, count = string.find(msg, L["trigger_doomYou"])
	if count then
		self:DoomOfMedivh(tonumber(count))
	end
	
	-- Arcane Focus
	local _, _, player = string.find(msg, L["trigger_arcanefocus"])	
	if player then
		self:Sync(syncName.arcanefocus .. " " .. player)
	end
	
	-- Flamestrike
	if self.db.profile.echoflamestrike and string.find(msg, L["trigger_flamestrike"]) then
		self:WarningSign(icon.flamestrike, 2, false, L["warn_flamestrike"])
		self:Message(L["msg_flamestrike"], "Important", true, "Info")
	end
end

function module:CHAT_MSG_SPELL_AURA_GONE_SELF(msg)
	if string.find(msg, L["trigger_corruptionFade"]) then
		self:RemoveBar(L["bar_corruption"])
	end

	if string.find(msg, L["trigger_doomFade"]) then
		self:RemoveBar(string.format(L["bar_doom"], doomStackCount))
		doomStackCount = 0
		if self:IsEventScheduled("StillDoomed") then
			self:CancelScheduledEvent("StillDoomed")
		end

		-- Auto-cancel restoration potion if enabled
		if self.db.profile.cancelrestopot then
			self:CancelRestoPot()
		end
	end
end

function module:CHAT_MSG_SPELL_AURA_GONE_OTHER(msg)
	local _, _, player = string.find(msg, L["trigger_corruptionFadeOther"])
	if player then
		self:CorruptionFade(player)
	end
	if self.db.profile.irestacks and string.find(msg, L["trigger_ireFade"]) then
		self:Message(string.format(L["msg_ire"], 0), "Positive")
		self:RemoveBar(L["bar_ire"])
	end
end

function module:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	local _,_,spell = string.find(msg, L["trigger_cast"])
	if spell then
		if self.db.profile.castfrostnova and spell == L["spell_FrostNova"] then
			self:Message(string.format(L["msg_cast"], spell), "Important", true, "Info")
			self:WarningSign(icon.frostnova, 1, false, L["warn_cast"])
		elseif self.db.profile.castshadowbolt and spell == L["spell_ShadowBolt"] then
			self:Message(string.format(L["msg_cast"], spell), "Urgent", true, "Alarm")
			self:WarningSign(icon.shadowbolt, 1, true, L["warn_cast"])
		elseif self.db.profile.castpyroblast and spell == L["spell_Pyroblast"] then
			self:Message(string.format(L["msg_cast"], spell), "Important", true, "Info")
			self:WarningSign(icon.pyroblast, 1, false, L["warn_cast"])
		elseif self.db.profile.castflamestrike and spell == L["spell_Flamestrike"] then
			self:Message(string.format(L["msg_cast"], spell), "Important", true, "Info")
			self:WarningSign(icon.flamestrike, 1, false, L["warn_cast"])
		end
	end
end

function module:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(msg)
	-- Medivh's Fury
	local fury = nil
	if string.find(msg, L["trigger_fury1"]) then
		fury = 1
	elseif string.find(msg, L["trigger_fury"]) then
		local _,_,str = string.find(msg, L["trigger_fury"])
		fury = tonumber(str)
	end
	if fury then
		self:Message(string.format(L["msg_fury"], fury * 50), "Urgent")
	end
	-- Guardian's Ire
	local ire = nil
	if self.db.profile.irestacks then
		if string.find(msg, L["trigger_ire1"]) then
			ire = 1
		elseif string.find(msg, L["trigger_ire"]) then
			local _,_,str = string.find(msg, L["trigger_ire"])
			ire = tonumber(str)
		end
		if ire then
			self:Message(string.format(L["msg_ire"], ire), "Attention")
			self:Bar(L["bar_ire"], timer.ireReset, icon.ire)
		end
	end
end

function module:OnFriendlyDeath(msg)
	-- Remove raid marker when a player dies
	local _, _, player = string.find(msg, "(.+) dies")
	if player then
		self:CorruptionFade(player)
	end
end

function module:SpellHitEvent(msg)
	if self.db.profile.printecho and string.find(msg, L["trigger_shadowBoltHit"]) then
		print(msg)
	end
end

function module:BigWigs_RecvSync(sync, rest, nick)
	if sync == syncName.corruption and rest and rest ~= UnitName("player") then
		self:CorruptionOfMedivh(rest)
	elseif sync == syncName.arcanefocus and rest then
		self:ArcaneFocus(rest)
	end
end

function module:CorruptionOfMedivh(player)
	if GetTime() < lastCorruption + timer.corruption + 1 then -- spread
		if self.db.profile.corruption then
			self:Message(L["msg_corruptionSpread"], "Urgent", true, "Beware")
		end
	else -- no spread, new Corruption
		lastCorruption = GetTime()
	end
	
	if self.db.profile.corruption then
		if player == UnitName("player") then
			self:Message(L["msg_corruptionYou"], "Important", true, "RunAway")
			self:WarningSign(icon.corruption, 5, true, L["warning_corruptedGetAway"])
			self:Bar(L["bar_corruption"], timer.corruption, icon.corruption)
		else
			self:Message(string.format(L["msg_corruptionOther"], player), "Important")
		end
	end
	
	-- Yell in chat if enabled
	if self.db.profile.corruptionyell and player == UnitName("player") then
		SendChatMessage(L["yell_corruption"], "SAY")
	end

	-- Set raid mark if enabled
	if self.db.profile.corruptionmark then
		self:SetCorruptionMark(player)
	end
	
	-- Auto-targeting if enabled
	if self.db.profile.corruptiontarget then
		TargetByName(player,true)
	end
end

function module:CorruptionFade(player)
	-- Restore previous raid mark if enabled
	if self.db.profile.corruptionmark then
		self:RestoreMark(player)
	end
end

function module:SetCorruptionMark(player)
	local markToUse = self:GetAvailableRaidMark()
	if markToUse then
		self:SetRaidTargetForPlayer(player, markToUse)
	end
end

function module:RestoreMark(player)
	self:RestorePreviousRaidTargetForPlayer(player)
end

function module:ArcaneFocus(player)
	if self.db.profile.arcanefocus then
		self:Message(string.format(L["msg_arcanefocus"], player), "Important")
		self:WarningSign(icon.focus, 2, false, string.format(L["warn_arcanefocus"], player))
	end
end

function module:DoomOfMedivh(count)
	doomStackCount = count

	-- Adjust based on stack count
	local barColor = "white" -- Default color
	if count >= 4 then
		barColor = "red"
		self:WarningSign(icon.doom, 2, false, L["warn_doom"])
		if self.db.profile.potionstrat and firstDoomFour == 1 then
			firstDoomFour = 0 --only once per fight
			-- Potion
			self:Bar(L["bar_potion"], timer.potionDelay, icon.restopot)
			self:DelayedMessage(timer.potionDelay, L["msg_potion"], "Urgent", true, "Alarm")
			self:DelayedWarningSign(timer.potionDelay, icon.restopot, 1)
			-- Ghosts
			self:DelayedBar(timer.potionDelay, L["bar_ghosts"], timer.ghostsDelay, icon.ghosts, true, "blue")
			self:DelayedMessage(timer.potionDelay + timer.ghostsDelay, L["msg_ghosts"], "Urgent", true, "Beware")
			self:DelayedWarningSign(timer.potionDelay + timer.ghostsDelay, icon.ghosts, 1)
			-- Emergency Yell
			self:ScheduleEvent("StillDoomed", self.StillDoomed, timer.potionDelay + timer.ghostsDelay + timer.emergencyDelay, self)
		end
	elseif count >= 3 then
		barColor = "yellow"
	end
	
	if self.db.profile.doom then
		-- Remove existing bar
		self:RemoveBar(string.format(L["bar_doom"], count - 1))
		--Create new bar with appropriate color
		self:IntervalBar(string.format(L["bar_doom"], count), timer.doomMin, timer.doomMax, icon.doom, true, barColor)
	end
end

function module:StillDoomed()
	SendChatMessage(L["yell_emergency"], "YELL")
end

function module:CancelRestoPot()
	if GetPlayerBuffID then
		-- use spell id if superwow available to avoid potentially canceling the wrong buff
		if BigWigs:CancelAuraId(11359) then
			self:Message(L["resto_pot_cancelling"], "Positive")
		end
	else
		if BigWigs:CancelAuraTexture("Spell_Holy_DispelMagic") then
			self:Message(L["resto_pot_cancelling"], "Positive")
		end
	end
end

function module:Test()
	-- Initialize module state
	self:OnSetup()
	self:Engage()

	local events = {
		-- Corruption events
		{ time = 1, func = function()
			local member = UnitName("player")
			print("Test: " .. member .. " is afflicted by Corruption of Medivh")
			module:AfflictionEvent("You are afflicted by Corruption of Medivh")
		end },

		{ time = 3, func = function()
			local member = UnitName("raid1") or "Player1"
			print("Test: " .. member .. " is afflicted by Corruption of Medivh")
			module:AfflictionEvent(member .. " is afflicted by Corruption of Medivh")
		end },

		{ time = 5, func = function()
			local member = UnitName("raid2") or "Player2"
			print("Test: " .. member .. " is afflicted by Corruption of Medivh")
			module:AfflictionEvent(member .. " is afflicted by Corruption of Medivh")
		end },

		-- Frost Nova
		{ time = 8, func = function()
			print("Test: Echo of Medivh begins to cast Frost Nova")
			module:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE("Echo of Medivh begins to cast Frost Nova.")
		end },

		-- Doom events for self
		{ time = 10, func = function()
			print("Test: You are afflicted by Doom of Medivh. Also gains Guardian's Ire.")
			module:AfflictionEvent("You are afflicted by Doom of Medivh.")
			module:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS("Echo of Medivh gains Guardian's Ire.")
		end },

		-- Shadow Bolt
		{ time = 12, func = function()
			print("Test: Echo of Medivh begins to cast Shadow Bolt")
			module:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE("Echo of Medivh begins to cast Shadow Bolt.")
		end },
		{ time = 14, func = function()
			print("Test: Echo of Medivh's Shadow Bolt hits")
			module:SpellHitEvent("Echo of Medivh's Shadow Bolt hits Alice for 15750 Shadow damage. (5250 resisted)")
		end },

		{ time = 15, func = function()
			print("Test: You are afflicted by Doom of Medivh (2)")
			module:AfflictionEvent("You are afflicted by Doom of Medivh (2).")
		end },

		-- Corruptions start to fade
		{ time = 17, func = function()
			local member = UnitName("raid1") or "Player1"
			print("Test: Corruption of Medivh fades from " .. member)
			module:CHAT_MSG_SPELL_AURA_GONE_OTHER("Corruption of Medivh fades from " .. member)
		end },

		{ time = 18, func = function()
			local member = UnitName("raid2") or "Player2"
			print("Test: Corruption of Medivh fades from " .. member)
			module:CHAT_MSG_SPELL_AURA_GONE_OTHER("Corruption of Medivh fades from " .. member)
		end },

		{ time = 20, func = function()
			print("Test: You are afflicted by Doom of Medivh (3)")
			module:AfflictionEvent("You are afflicted by Doom of Medivh (3).")
		end },

		-- New corruption wave
		{ time = 21, func = function()
			local member = UnitName("raid3") or "Player3"
			print("Test: " .. member .. " is afflicted by Corruption of Medivh")
			module:AfflictionEvent(member .. " is afflicted by Corruption of Medivh")
		end },
		
		{ time = 23, func = function()
			print("Test: Echo of Medivh's Shadow Bolt is resisted")
			module:SpellHitEvent("Echo of Medivh's Shadow Bolt was resisted by Bob.")
		end },

		{ time = 25, func = function()
			print("Test: You are afflicted by Doom of Medivh (4). Also Ire fades.")
			module:AfflictionEvent("You are afflicted by Doom of Medivh (4).")
			module:CHAT_MSG_SPELL_AURA_GONE_OTHER("Guardian's Ire fades from Echo of Medivh")
		end },

		-- Pyroblast
		{ time = 26, func = function()
			print("Test: Echo of Medivh begins to cast Pyroblast")
			module:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE("Echo of Medivh begins to cast Pyroblast.")
		end },

		-- Player corruption fades
		{ time = 28, func = function()
			print("Test: Corruption fades from you. Also Ire 1.")
			module:CHAT_MSG_SPELL_AURA_GONE_SELF("Corruption of Medivh fades from you.")
			module:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS("Echo of Medivh gains Guardian's Ire.")
		end },

		-- Last corruption fades
		{ time = 33, func = function()
			local member = UnitName("raid3") or "Player3"
			print("Test: Corruption of Medivh fades from " .. member .. ". Also Ire 2")
			module:CHAT_MSG_SPELL_AURA_GONE_OTHER("Corruption of Medivh fades from " .. member)
			module:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS("Echo of Medivh gains Guardian's Ire (2).")
		end },

		-- Doom fades
		{ time = 34, func = function()
			print("Test: Doom fades from you. Also Ire 3.")
			module:CHAT_MSG_SPELL_AURA_GONE_SELF("Doom of Medivh fades from you.")
			module:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS("Echo of Medivh gains Guardian's Ire (3).")
		end },

		-- Flamestrike
		{ time = 35, func = function()
			print("Test: Echo of Medivh begins to cast Flamestrike")
			module:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE("Echo of Medivh begins to cast Flamestrike.")
		end },

		-- Test player death with corruption
		{ time = 36, func = function()
			local member = UnitName("raid4") or "Player4"
			print("Test: " .. member .. " is afflicted by Corruption of Medivh")
			module:AfflictionEvent(member .. " is afflicted by Corruption of Medivh")

			print("Test: " .. member .. " dies. Also Fury triggers.")
			module:CHAT_MSG_COMBAT_FRIENDLY_DEATH(member .. " dies")
			
			module:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS("Echo of Medivh gains Medivh's Fury.")
			module:CHAT_MSG_SPELL_AURA_GONE_OTHER("Guardian's Ire fades from Echo of Medivh")
		end },
		
		-- Arcane Focus on tank
		{ time = 37, func = function()
			local member = UnitName("raid5") or "Player5"
			print("Test: " ..member.." is afflicted by Arcane Focus")
			module:AfflictionEvent(member .. " is afflicted by Arcane Focus")
		end },
		
		{ time = 40, func = function()
			print("Test: Echo of Medivh gains Medivh's Fury (2).")
			module:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS("Echo of Medivh gains Medivh's Fury (2).")
		end },
		
		{ time = 41, func = function()
			print("Test: You are afflicted by Flamestrike.")
			module:AfflictionEvent("You are afflicted by Flamestrike.")
		end },

		-- Disengage
		{ time = 44, func = function()
			print("Test: Disengage")
			module:Disengage()
		end },
	}

	-- Schedule each event at its absolute time
	for i, event in ipairs(events) do
		self:ScheduleEvent("EchoMedivhTest" .. i, event.func, event.time)
	end

	self:Message("Echo of Medivh test started", "Positive")
	return true
end

-- Test command:
-- /run local m=BigWigs:GetModule("Echo of Medivh"); BigWigs:SetupModule("Echo of Medivh");m:Test();
