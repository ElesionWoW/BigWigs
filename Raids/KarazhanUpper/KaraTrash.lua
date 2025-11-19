local module, L = BigWigs:ModuleDeclaration("Kara Trash", "Karazhan")

module.revision = 30002
module.trashMod = true -- how does this affect things
module.enabletrigger = { "Shadowclaw Rager", "Shadowclaw Darkbringer", "Manascale Suppressor", "Manascale Drake", "Unstable Arcane Elemental", "Disrupted Arcane Elemental", "Arcane Anomaly", "Lingering Arcanist", "Lingering Astrologist", "Lingering Magus", "Karazhan Protector Golem", "Crumbling Protector", "Warbringer Overseer" }
module.toggleoptions = { "shadowclaw_enrage", "call_of_darkness", -1, "suppressor_crystal", "enrage_on_drake", "frigid_mana_breath", "draconic_thrash", -1, "mana_buildup", "unstable_mana", "overflowing_arcana", -1, "arcanist_blizzard", "astrologist_insight", "astrologist_rain", "magus_polymorph", "magus_flames", "golem_reflection", "protector_self_destruct", -1, "warbringer_shifted", -1, "printtrash" }
module.zonename = {
	AceLibrary("AceLocale-2.2"):new("BigWigs")["Tower of Karazhan"],
	AceLibrary("Babble-Zone-2.2")["Tower of Karazhan"],
	"Outland",
	"The Rock of Desolation"
}
local guid_patterns = {
	manascale_drake = "^0xF13000F1F427",
}

local _, playerClass = UnitClass("player")
local has_superwow = SUPERWOW_VERSION or SetAutoloot
local tracked_guids = {}

module.defaultDB = {
	shadowclaw_enrage = playerClass == "HUNTER",
	call_of_darkness = true,
	suppressor_crystal = false,
	enrage_on_drake = playerClass == "HUNTER",
	frigid_mana_breath = true,
	draconic_thrash = false,
	mana_buildup = true,
	unstable_mana = true,
	overflowing_arcana = true,
	arcanist_blizzard = true,
	astrologist_insight = true,
	astrologist_rain = true,
	magus_polymorph = playerClass == "PALADIN" or playerClass == "PRIEST",
	magus_flames = true,
	golem_reflection = true,
	protector_self_destruct = true,
	warbringer_shifted = true,
	printtrash = false,
	-- bosskill           = nil,
}

L:RegisterTranslations("enUS", function()
	return {
		cmd = "UpperKaraTrash",

		shadowclaw_enrage_cmd = "shadowclaw_enrage",
		shadowclaw_enrage_name = "Shadowclaw Enrage Alert",
		shadowclaw_enrage_desc = "Warns when a Shadowclaw Rager enrages (and needs Tranqilizing Shot)",

		call_of_darkness_cmd = "call_of_darkness",
		call_of_darkness_name = "Call of Darnkess Alert",
		call_of_darkness_desc = "Warns when a Shadowclaw Darkbringer begins to cast Call of Darkness",

		suppressor_crystal_cmd = "suppressor_crystal",
		suppressor_crystal_name = "Resonating Crystal Alert",
		suppressor_crystal_desc = "Warns when a Manascale Suppressor begins summoning a Resonating Crystal",

		enrage_on_drake_cmd = "enrage_on_drake",
		enrage_on_drake_name = "Enrage on Drake",
		enrage_on_drake_desc = "Warns when a Enrage Dragonkin is used on a Manascale Drake",

		frigid_mana_breath_cmd = "frigid_mana_breath",
		frigid_mana_breath_name = "Manascale Drake Breath",
		frigid_mana_breath_desc = "Warn when Manascale Drake is able to cast Frigid Mana Breath",

		draconic_thrash_cmd = "draconic_thrash",
		draconic_thrash_name = "Manascale Threat Drop",
		draconic_thrash_desc = "Warn when Manascale Drake is about to wing buffet",

		mana_buildup_cmd = "mana_buildup",
		mana_buildup_name = "Mana Buildup Alert",
		mana_buildup_desc = "Warn to get out of raid if you have Mana Buildup bomb",

		unstable_mana_cmd = "unstable_mana",
		unstable_mana_name = "Unstable Mana Alert",
		unstable_mana_desc = "Warn to get out of raid if you have Unstable Mana bomb",

		overflowing_arcana_cmd = "overflowing_arcana",
		overflowing_arcana_name = "Overflowing Arcana Alert",
		overflowing_arcana_desc = "Warn when Overflowing Arcana stacks are near the limit",

		arcanist_blizzard_cmd = "arcanist_blizzard",
		arcanist_blizzard_name = "Blizzard",
		arcanist_blizzard_desc = "Warn you're standing in a Blizzard cast by Lingering Arcanist",

		astrologist_insight_cmd = "astrologist_insight",
		astrologist_insight_name = "Astral Insight",
		astrologist_insight_desc = "Warn when you have to stop casting (Astral Insight from Lingering Astrologist)",

		astrologist_rain_cmd = "astrologist_rain",
		astrologist_rain_name = "Rain of Stars",
		astrologist_rain_desc = "Warn when Lingering Astrologist has cast Rain of Stars",

		magus_polymorph_cmd = "magus_polymorph",
		magus_polymorph_name = "Lingering Polymorph",
		magus_polymorph_desc = "Warn when someone has been polymorphed by Lingering Magus",

		magus_flames_cmd = "magus_flames",
		magus_flames_name = "Enveloped Flames",
		magus_flames_desc = "Warn when Lingering Magus forces someone to stop moving",

		golem_reflection_cmd = "golem_reflection",
		golem_reflection_name = "Reflection Protocol",
		golem_reflection_desc = "Warn when Karazhan Protector Golem gains spell reflect",

		protector_self_destruct_cmd = "protector_self_destruct",
		protector_self_destruct_name = "Self Destruction Protocol Alert",
		protector_self_destruct_desc = "Warn when Crumbling Protector is casting Self Destruction Protocol",

		warbringer_shifted_cmd = "warbringer_shifted",
		warbringer_shifted_name = "Phase Shifted Alert",
		warbringer_shifted_desc = "Warn when Warbringer Overseer applies Phase Shifted to a mob (-90% damage taken)",

		printtrash_cmd = "printtrash",
		printtrash_name = "Troubleshoot Info",
		printtrash_desc = "Print information to your main chat window: Players afflicted by Enveloped Flames",


		trigger_shadowclaw_enrage = "Shadowclaw Rager gains Shadowclaw Enrage",
		msg_shadowclaw_enrage = "Rager frenzies - use Tranq Shot!",

		trigger_call_of_darkness = "Shadowclaw Darkbringer begins to cast Call of Darkness",
		msg_call_of_darkness = "Call of Darkness - Interrupt Shadowclaw Darkbringer!",
		bar_call_of_darkness = "Call of Darkness",

		trigger_suppressor_crystal = "Manascale Suppressor begins to cast Summon Resonating Crystal",
		msg_suppressor_crystal = "Resonating Crystal incoming - interrupt Suppressor!",

		trigger_enrage_on_drake = "Manascale Drake gains Enrage Dragonkin",
		msg_enrage_on_drake = "Drake frenzies - use Tranq Shot!",
		bar_frigid_mana_breath = "Drake Breath soon",
		bar_draconic_thrash = "Wing Buffet soon",

		trigger_mana_buildup = "(.+) ...? afflicted by Mana Buildup",
		trigger_remove_mana_buildup = "Your Mana Buildup is removed",
		msg_mana_buildup_you = "Mana Buildup - get dispelled or get out of the raid!",
		msg_mana_buildup = "Dispel %s - Mana Buildup!",
		bar_mana_buildup = "Mana Buildup blowing up",
		msg_mana_buildup_remove = "Mana Buildup dispelled",

		trigger_unstable_mana = "(.+) ...? afflicted by Unstable Mana",
		msg_unstable_mana_you = "Unstable Mana - wait for it to expire (no dispels!)",
		msg_unstable_mana = "DON'T dispel %s - Unstable Mana!",
		bar_unstable_mana = "Unstable Mana expires",

		trigger_overflowing_arcana = "(.+) ...? afflicted by Overflowing Arcana(.+)",
		warn_overflowing_arcana = "Flee from Arcane Anomaly!",
		bar_overflowing_arcana = "Overflowing Arcana dot stacks",

		trigger_arcanist_blizzard = "You are afflicted by Blizzard",
		msg_arcanist_blizzard = "Move out of Blizzard!",
		warn_arcanist_blizzard = "MOVE",

		trigger_astrologist_insight = "You are afflicted by Astral Insight",
		msg_astrologist_insight = "Stop casting - Astral Insight!",
		warn_astrologist_insight = "NO CASTING",

		trigger_astrologist_rain = "afflicted by Rain of Stars",
		msg_astrologist_rain = "Shackle Astrologist - Rain of Stars!",
		warn_astrologist_rain = "SHACKLE ASTROLOGIST",

		trigger_magus_polymorph = "(.+) ...? afflicted by Lingering Polymorph",
		msg_magus_polymorph = "Dispel %s - Lingering Polymorph",

		trigger_magus_flames = "(.+) ...? afflicted by Enveloped Flames",
		msg_magus_flames_self = "Stop moving until dispelled - Enveloped Flames!",
		warn_magus_flames = "FREEZE",
		msg_magus_flames_others = "%s has to stop moving - Enveloped Flames",
		msg_magus_flames_dispel = "Dispel %s - Enveloped Flames",

		trigger_golem_reflection = "Karazhan Protector Golem begins to perform Reflection Protocol.",
		msg_golem_reflection = "Spell Reflect on Karazhan Protector Golem",
		warn_golem_reflection = "GOLEM REFLECT",
		bar_golem_reflection = "Golem Spell Reflect",

		trigger_self_destruct = "Crumbling Protector begins to cast Self Destruction Protocol",
		warn_self_destruct = "BOOM!",
		bar_self_destruct = "Self Destruction Protocol",

		trigger_warbringer_shifted = "(.+) gains Rift Shifted",
		msg_warbringer_shifted = "Purge %s - Rift Shifted (90% DR)!",

	}
end)

local timer = {
	call_of_darkness = 5,
	frigid_mana_breath = {14, 19},
	draconic_thrash = {12, 14},
	mana_buildup = 7,
	unstable_mana = 10,
	overflowing_arcana = 8, -- warning icon and application delay
	golem_reflection = 11, -- 1s cast time + 10s duration
	self_destruct = 4,
}

local icon = {
	call_of_darkness = "Spell_Shadow_ShadowBolt",
	frigid_mana_breath = "Spell_Frost_FrostShock",
	draconic_thrash = "INV_Misc_MonsterScales_05",
	mana_buildup = "Spell_Nature_Lightning",
	unstable_mana = "Spell_Shadow_Teleport",
	overflowing_arcana = "INV_Enchant_EssenceEternalLarge",
	arcanist_blizzard = "Spell_Frost_IceStorm",
	astrologist_insight = "Spell_Holy_Silence",
	astrologist_rain = "Spell_Arcane_StarFire",
	magus_flames = "Ability_Rogue_Trip",
	golem_reflection = "Spell_Shadow_Teleport",
	self_destruct = "Spell_Fire_SelfDestruct",
}

local syncName = {
	shadowclaw_enrage = "K40ShadowclawEnrage" .. module.revision,
	call_of_darkness = "K40CallOfDarkness" .. module.revision,
	suppressor_crystal = "K40SuppressorCrystal" .. module.revision,
	enrage_on_drake = "K40EnrageOnDrake" .. module.revision,
	drake_engage = "DrakeEngage" .. module.revision,
	mana_buildup = "K40ManaBuildup" .. module.revision,
	unstable_mana = "K40UnstableMana" .. module.revision,
	overflowing_arcana = "K40OverflowingArcana" .. module.revision,
	astrologist_rain = "K40AstrologistRain" .. module.revision,
	magus_polymorph = "K40MagusPolymorph" .. module.revision,
	magus_flames = "K40MagusFlames" .. module.revision,
	golem_reflection = "K40GolemReflection" .. module.revision,
	self_destruct = "K40SelfDestruct" .. module.revision,
	warbringer_shifted = "K40WarbringerShifted" .. module.revision,
}

function module:OnEnable()
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "AfflictionEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "AfflictionEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "AfflictionEvent")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")

	self:RegisterEvent("CHAT_MSG_SPELL_BREAK_AURA", "RemoveEvent")

	if has_superwow then
		self:RegisterEvent("UNIT_CASTEVENT")
		self:RegisterEvent("UNIT_FLAGS")
	else
		self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF", "EnemyCastEvent") -- not sure which of these it is
		self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "EnemyCastEvent")  -- not sure which of these it is
	end

	self:ThrottleSync(1, syncName.shadowclaw_enrage)
	self:ThrottleSync(1, syncName.call_of_darkness)
	self:ThrottleSync(1, syncName.suppressor_crystal)
	self:ThrottleSync(1, syncName.enrage_on_drake)
	self:ThrottleSync(10, syncName.drake_engage)
	self:ThrottleSync(1, syncName.mana_buildup)
	self:ThrottleSync(1, syncName.unstable_mana)
	self:ThrottleSync(1, syncName.overflowing_arcana)
	self:ThrottleSync(5, syncName.astrologist_rain)
	self:ThrottleSync(1, syncName.magus_polymorph)
	self:ThrottleSync(1, syncName.magus_flames)
	self:ThrottleSync(2, syncName.golem_reflection)
	self:ThrottleSync(1, syncName.self_destruct)
	self:ThrottleSync(1, syncName.warbringer_shifted)
end

-- function module:OnSetup()
-- end


function module:OnEngage()
	if not has_superwow and self.db.profile.frigid_mana_breath then
		-- start checking for drake changing targets
		self:ScheduleRepeatingEvent("bwdraketargetcheck", self.CheckDrakeTarget, 0.2, self)
		-- don't run forever if this isn't a drake pack
		self:ScheduleEvent("disable_bwdraketargetcheck", "CancelScheduledEvent", 5, "bwdraketargetcheck")
	end
end

function module:OnDisengage()
	tracked_guids = {}
end

-- todo: replace this with a proper top level flags detection feature for pull detection
function module:UNIT_FLAGS(unit)
	if not UnitAffectingCombat(unit) then return end
	if not tracked_guids[unit] and string.find(unit, guid_patterns.manascale_drake) then
		tracked_guids[unit] = true
		self:Sync(syncName.drake_engage)
	end
end

function module:CheckDrakeTarget()
	local drakeTarget = nil

	if UnitName("target") == "Manascale Drake" then
		drakeTarget = UnitName("targettarget")
	else
		-- loop through raid to find someone targeting the drake
		for i = 1, GetNumRaidMembers() do
			if UnitName("raid" .. i .. "target") == "Manascale Drake" then
				drakeTarget = UnitName("raid" .. i .. "targettarget")
				break
			end
		end
	end
	if drakeTarget then
		self:Sync(syncName.drake_engage)
	end
end

function module:UNIT_CASTEVENT(caster, target, action, spell_id, cast_time)
	if caster and spell_id == 57645 and action == "START" then
		self:Sync(syncName.call_of_darkness)
	end
	if caster and spell_id == 52385 and action == "START" then
		self:Sync(syncName.suppressor_crystal)
	end
	if caster and spell_id == 57654 and action == "START" then
		self:Sync(syncName.golem_reflection)
	end
	if caster and spell_id == 57652 and action == "START" then
		self:Sync(syncName.self_destruct)
	end
end

function module:EnemyCastEvent(msg)
	if string.find(msg, L["trigger_call_of_darkness"]) then
		self:Sync(syncName.call_of_darkness)
		return
	end
	if string.find(msg, L["trigger_suppressor_crystal"]) then
		self:Sync(syncName.suppressor_crystal)
		return
	end
	if string.find(msg, L["trigger_golem_reflection"]) then
		self:Sync(syncName.golem_reflection)
		return
	end
	if string.find(msg, L["trigger_self_destruct"]) then
		self:Sync(syncName.self_destruct)
		return
	end
end

function module:CHAT_MSG_COMBAT_HOSTILE_DEATH(msg)
	if msg == string.format(UNITDIESOTHER, "Arcane Anomaly") then
		self:TriggerEvent("BigWigs_StopCounterBar", self, L["bar_overflowing_arcana"])
	end
end

function module:AfflictionEvent(msg)
	local _, _, playerMB = string.find(msg, L["trigger_mana_buildup"])
	if playerMB then
		if playerMB == "You" then
			playerMB = UnitName("player")
		end
		self:Sync(syncName.mana_buildup .. " " .. playerMB)
		return
	end
	local _, _, playerUM = string.find(msg, L["trigger_unstable_mana"])
	if playerUM then
		if playerUM == "You" then
			playerUM = UnitName("player")
		end
		self:Sync(syncName.unstable_mana .. " " .. playerUM)
		return
	end
	local _, _, playerOA, rest = string.find(msg, L["trigger_overflowing_arcana"])
	if playerOA then
		if playerOA == "You" then
			playerOA = UnitName("player")
		end
		local _, _, n = string.find(rest, "(%d+)")
		n = tonumber(n)
		self:Sync(syncName.overflowing_arcana .. " " .. playerOA .. (n or 1))
		return
	end
	local _, _, playerLP = string.find(msg, L["trigger_magus_polymorph"])
	if playerLP then
		if playerLP == "You" then
			playerLP = UnitName("player")
		end
		self:Sync(syncName.magus_polymorph .. " " .. playerLP)
		return
	end
	local _, _, playerEF = string.find(msg, L["trigger_magus_flames"])
	if playerEF then
		if self.db.profile.printtrash then
			print(msg)
		end
		if playerEF == "You" then
			playerEF = UnitName("player")
			module:EnvelopedFlames(playerEF) -- let's not miss a sync
		end
		self:Sync(syncName.magus_flames .. " " .. playerEF)
		return
	end
	if string.find(msg, L["trigger_arcanist_blizzard"]) then
		self:Message(L["msg_arcanist_blizzard"], "Attention", nil, "Info")
		self:WarningSign(icon.arcanist_blizzard, 2, false, L["warn_arcanist_blizzard"])
	end
	if string.find(msg, L["trigger_astrologist_insight"]) then
		self:Message(L["msg_astrologist_insight"], "Important", nil, "Beware")
		self:WarningSign(icon.astrologist_insight, 7, true, L["warn_astrologist_insight"])
	end
	if string.find(msg, L["trigger_astrologist_rain"]) then
		self:Sync(syncName.astrologist_rain)
	end
end

function module:RemoveEvent(msg)
	-- Check for Mana Buildup removal
	if string.find(msg, L["trigger_remove_mana_buildup"]) then
		self:RemoveBar(L["bar_mana_buildup"])
		self:Message(L["msg_mana_buildup_remove"], "Green", nil)
	end
end

function module:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(msg)
	if string.find(msg, L["trigger_shadowclaw_enrage"]) then
		self:Sync(syncName.shadowclaw_enrage)
		return
	end
	if string.find(msg, L["trigger_enrage_on_drake"]) then
		self:Sync(syncName.enrage_on_drake)
		return
	end
	local _, _, shifted = string.find(msg, L["trigger_warbringer_shifted"])
	if shifted then
		self:Sync(syncName.warbringer_shifted .. " " .. shifted)
		return
	end
end

function module:BigWigs_RecvSync(sync, rest, nick)
	if sync == syncName.call_of_darkness then
		if self.db.profile.call_of_darkness then
			self:Message(L["msg_call_of_darkness"], "Important", nil, "Beware")
			self:Bar(L["bar_call_of_darkness"], timer.call_of_darkness, icon.call_of_darkness)
		end
	elseif sync == syncName.suppressor_crystal then
		if self.db.profile.suppressor_crystal then
			self:Message(L["msg_suppressor_crystal"], "Urgent", nil, "Beware")
		end
	elseif sync == syncName.drake_engage then
		if self.db.profile.frigid_mana_breath then
			self:IntervalBar(L["bar_frigid_mana_breath"], timer.frigid_mana_breath[1], timer.frigid_mana_breath[2], icon.frigid_mana_breath)
		end
		if self.db.profile.draconic_thrash then
			self:IntervalBar(L["bar_draconic_thrash"], timer.draconic_thrash[1], timer.draconic_thrash[2], icon.draconic_thrash)
		end
	elseif sync == syncName.mana_buildup then
		if self.db.profile.mana_buildup and rest == UnitName("player") then
			self:Bar(L["bar_mana_buildup"], timer.mana_buildup, icon.mana_buildup)
			self:Message(L["msg_mana_buildup_you"], "Urgent", nil, "Info")
		elseif self.db.profile.mana_buildup then
			self:Message(string.format(L["msg_mana_buildup"], rest), "Attention", nil, "Info")
		end
	elseif sync == syncName.unstable_mana then
		if self.db.profile.unstable_mana and rest == UnitName("player") then
			self:Message(L["msg_unstable_mana_you"], "Urgent", nil, "Info")
			self:Bar(L["bar_unstable_mana"], timer.unstable_mana, icon.unstable_mana)
		elseif self.db.profile.unstable_mana then
			self:Message(string.format(L["msg_unstable_mana"], rest), "Attention", nil, "Info")
		end
	elseif sync == syncName.overflowing_arcana then
		if self.db.profile.overflowing_arcana then
			local _, _, player, n = string.find(rest, "(.-)(%d+)")
			n = tonumber(n)
			if n and player and player == UnitName("player") then
				if n == 1 then
					-- no icon, it's buggy and could confuse people
					self:TriggerEvent("BigWigs_StartCounterBar", self, L["bar_overflowing_arcana"], 5, nil, true, "red", "green")
				end
				self:TriggerEvent("BigWigs_SetCounterBar", self, L["bar_overflowing_arcana"], 5 - n)
				if n == 4 then
					self:Sound("RunAway")
					self:WarningSign(icon.overflowing_arcana, 8, true, L["warn_overflowing_arcana"])
					self:Bar(L["warn_overflowing_arcana"], timer.overflowing_arcana, icon.overflowing_arcana)
				end
			end
		end
	elseif sync == syncName.astrologist_rain then
		if self.db.profile.astrologist_rain then
			self:Message(L["msg_astrologist_rain"], "Important")
			self:WarningSign(icon.astrologist_rain, 2, false, L["warn_astrologist_rain"])
			if playerClass == "PRIEST" then
				self:Sound("Beware")
			else
				self:Sound("Info")
			end
		end
	elseif sync == syncName.magus_polymorph and rest then
		if self.db.profile.magus_polymorph then
			self:Message(string.format(L["msg_magus_polymorph"], rest), "Urgent", nil, "Info")
		end
	elseif sync == syncName.magus_flames and rest and rest ~= UnitName("player") then
		self:EnvelopedFlames(rest)
	elseif sync == syncName.golem_reflection then
		if self.db.profile.golem_reflection then
			self:Message(L["msg_golem_reflection"], "Attention", nil, "Info")
			self:Bar(L["bar_golem_reflection"], timer.golem_reflection, icon.golem_reflection)
			self:WarningSign(icon.golem_reflection, 3, false, L["warn_golem_reflection"])
		end
	elseif sync == syncName.self_destruct then
		if self.db.profile.protector_self_destruct then
			self:Sound("Beware")
			self:Bar(L["bar_self_destruct"], timer.self_destruct, icon.self_destruct)
		end
	end
end

function module:EnvelopedFlames(player)
	if self.db.profile.magus_flames then
		if player == UnitName("player") then
			self:Message(L["msg_magus_flames_self"], "Important", nil, "Beware")
			self:RemoveWarningSign(icon.astrologist_insight, true) --cancel other forced sign since this is more important
			self:WarningSign(icon.magus_flames, 3, true, L["warn_magus_flames"])
		elseif playerClass == "PALADIN" or playerClass == "PRIEST" then
			self:Message(string.format(L["msg_magus_flames_dispel"], player), "Urgent", nil, "Alarm")
		else
			self:Message(string.format(L["msg_magus_flames_others"], player), "Attention", nil, "Info")
		end
	end
end

-------------------------------------------------------------------------------
--  Testing
-------------------------------------------------------------------------------

function module:Test()
	local print = function(s)
		DEFAULT_CHAT_FRAME:AddMessage(s)
	end
	BigWigs:EnableModule(self:ToString())

	local player = UnitName("player")
	local tests = {
		{ 3,
		  "Mana Buildup bar, you:",
		  "CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE",
		  "You are afflicted by Mana Buildup (1)." },
		{ 11,
		  "Mana Buildup bar, other:",
		  "CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE",
		  player .. " is afflicted by Mana Buildup (1)." },
		{ 14,
		  "Mana Buildup bar, dispell:",
		  "CHAT_MSG_SPELL_BREAK_AURA",
		  "Your Mana Buildup is removed." },
		{ 15,
		  "Unstable Mana",
		  "CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE",
		  UnitName("raid2") .. " is afflicted by Unstable Mana (1)." },
		{ 26,
		  "Overflowing Arcana",
		  "CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE",
		  "You are afflicted by Overflowing Arcana." },
		{ 28,
		  "Overflowing Arcana (1)",
		  "CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE",
		  "You are afflicted by Overflowing Arcana (1)." },
		{ 30,
		  "Overflowing Arcana (2)",
		  "CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE",
		  "You are afflicted by Overflowing Arcana (2)." },
		{ 30,
		  "Overflowing Arcana (2) sync",
		  "CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE",
		  player .. "is afflicted by Overflowing Arcana (2)." },
		{ 32,
		  "Overflowing Arcana (3)",
		  "CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE",
		  "You are afflicted by Overflowing Arcana (3)." },
		{ 34,
		  "Overflowing Arcana (4)",
		  "CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE",
		  "You are afflicted by Overflowing Arcana (4)." },
		{ 34,
		  "Overflowing Arcana (4) sync",
		  "CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE",
		  player .. "is afflicted by Overflowing Arcana (4)." },
		{ 36,
		  "Overflowing Arcana (5)",
		  "CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE",
		  "You are afflicted by Overflowing Arcana (5)." },
		{ 38,
		  "Anomaly Dies",
		  "CHAT_MSG_COMBAT_HOSTILE_DEATH",
		  "Arcane Anomaly dies." },
		{ 39,
		  "Golem Spell Reflect",
		  "CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF",
		  "Karazhan Protector Golem begins to perform Reflection Protocol." },
		{ 40,
		  "Blizzard",
		  "CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE",
		  "You are afflicted by Blizzard" },
		{ 43,
		  "Stop casting",
		  "CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE",
		  "You are afflicted by Astral Insight" },
		{ 51,
		  "Rain of Stars",
		  "CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE",
		  "You are afflicted by Rain of Stars" },
		{ 54,
		  "Flames on You",
		  "CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE",
		  "You are afflicted by Enveloped Flames" },
		{ 56,
		  "Flames on Other",
		  "CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE",
		  "Tester is afflicted by Enveloped Flames" },
		{ 58,
		  "Sheep on Other",
		  "CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE",
		  "Tester is afflicted by Lingering Polymorph" },
		{ 62,
			"Drake engaged (vanilla):",
			"BigWigs_SendSync",
			syncName.drake_engage},
		{ 82,
			"Drake engaged (superwow):", -- commentout the unitcombat check in unit_flags to test this
			"UNIT_FLAGS",
			"0xF13000F1F4276B71" },
	}

	for i, t in ipairs(tests) do
		if type(t[2]) == "string" then
			local t1, t2, t3, t4 = t[1], t[2], t[3], t[4]
			self:ScheduleEvent("K40TrashTest" .. i, function()
				print(t2)
				self:TriggerEvent(t3, t4)
			end, t1)
		else
			self:ScheduleEvent("K40TrashTest" .. i, t[2], t[1])
		end
	end

	self:Message(module.translatedName .. " test started", "Positive")
	return true
end
-- /run BigWigs:GetModule("Kara Trash"):Test()
