local module, L = BigWigs:ModuleDeclaration("Timbermaw Trash", "Timbermaw Hold")

-- module variables
module.revision = 30138
module.trashMod = true
module.enabletrigger = { "Withermaw Pathfinder", "Withermaw Shaman", "Withermaw Defiler", "Withermaw Ursa", "Corruption of Loktanag", "Tainted Mass",  "Son of Ursol", "Foulheart Trickster" }
module.toggleoptions = { "pathfinder_illumination", "shaman_blessing", "defiler_defiling", "defiler_defilingother", "defiler_defilingmark", "defiler_cloud", "ursa_command", "ursa_roar", -1, "corruption_boils", "corruption_euyonalia", "son_rage", -1, "trickster_siphon" }

local _, playerClass = UnitClass("player")

-- module defaults
module.defaultDB = {
	pathfinder_illumination = false,
	shaman_blessing = true,
	defiler_defiling = true,
	defiler_defilingother = true,
	defiler_defilingmark = true,
	defiler_cloud = true,
	ursa_command = playerClass == "HUNTER",
	ursa_roar = true,
	corruption_boils = playerClass == "SHAMAN" or playerClass == "PRIEST" or playerClass == "PALADIN",
	corruption_euyonalia = true,
	son_rage = playerClass == "HUNTER",
	trickster_siphon = playerClass == "PALADIN" or playerClass == "PRIEST",
}

-- localization
L:RegisterTranslations("enUS", function()
	return {
		cmd = "TimbermawTrash",

		pathfinder_illumination_cmd = "pathfinder_illumination",
		pathfinder_illumination_name = "Cauterizing Illumination Alert",
		pathfinder_illumination_desc = "Warns when Withermaw Pathfinders gain their 8yd fire aura",

		shaman_blessing_cmd = "shaman_blessing",
		shaman_blessing_name = "Withermaw Blessing Alert",
		shaman_blessing_desc = "Warns when Withermaw Shamans apply their Blessing to others (physical damage immunity)",

		defiler_defiling_cmd = "defiler_defiling",
		defiler_defiling_name = "Withered Defiling Alert",
		defiler_defiling_desc = "Get a personal warning when a Withermaw Defiler puts Withered Defiling on you, and announce it to /say",

		defiler_defilingother_cmd = "defiler_defilingother",
		defiler_defilingother_name = "Withered Defiling Warning",
		defiler_defilingother_desc = "Get warnings about other players suffering from Withered Defiling",

		defiler_defilingmark_cmd = "defiler_defilingmark",
		defiler_defilingmark_name = "Withered Defiling Mark",
		defiler_defilingmark_desc = "Mark players suffering from Withered Defiling",

		defiler_cloud_cmd = "defiler_cloud",
		defiler_cloud_name = "Poison Cloud Alert",
		defiler_cloud_desc = "Warn when you are standing in a Poison Cloud cast by a Withermaw Defiler or Tainted Mass",

		ursa_command_cmd = "ursa_command",
		ursa_command_name = "Ursol's Command Alert",
		ursa_command_desc = "Warn when a Withermaw Ursa applies their buff aura (Frenzy dispel)",

		ursa_roar_cmd = "ursa_roar",
		ursa_roar_name = "Roar of the Ursa Alert",
		ursa_roar_desc = "Warns when a Withermaw Ursa begins to cast their aoe fear",

		corruption_boils_cmd = "corruption_boils",
		corruption_boils_name = "Black Boils Warning",
		corruption_boils_desc = "Warn when Corruption of Loktanag applies Black Boils so they can be cleansed",

		corruption_euyonalia_cmd = "corruption_euyonalia",
		corruption_euyonalia_name = "Euyonalia Alert",
		corruption_euyonalia_desc = "Cast bar and personal alert when you are afflicted by Euyonalia so you can distance before getting dispelled",

		son_rage_cmd = "son_rage",
		son_rage_name = "Ancient Rage Alert",
		son_rage_desc = "Warn when Son of Ursol frenzies",

		trickster_siphon_cmd = "trickster_siphon",
		trickster_siphon_name = "Foulheart Siphon Warning",
		trickster_siphon_desc = "Warn about victims of Foulheart Siphon (drain) by Foulheart Tricksters",


		trigger_pathfinder_illumination = "Withermaw Pathfinder .+ Cauterizing Illumination",
		msg_pathfinder_illumination = "Fire Aura around Pathfinder!",

		trigger_shaman_blessing = "(.+) gains Withermaw Blessing",
		msg_shaman_blessing = "%s immune to physical - Purge!",

		trigger_defiler_defiling = "(.+) ...? afflicted by Withered Defiling",
		msg_defiler_defiling = "Get out of the raid! - Withered Defiling",
		msg_defiler_defilingOther = "Withered Defiling on %s",
		bar_defiler_defiling = "Withered Defiling",
		say_defiler_defiling = "Don't be near me - Withered Defiling!",
		trigger_defiler_cloud = "You are afflicted by Poison Cloud",
		trigger_defiler_cloudTick = "You suffer (.+) Nature damage from Withermaw Defiler's Poison Cloud",
		warn_defiler_cloud = "MOVE",

		trigger_ursa_command = "Withermaw Ursa gains Ursol's Command",
		msg_ursa_command = "Ursa Buff Aura active - Tranq Shot!",
		trigger_ursa_roar = "Withermaw Ursa begins to perform Roar of the Ursa.",
		bar_ursa_roar = "Ursa Fear",

		trigger_corruption_boils = "(.+) ...? afflicted by Black Boils",
		msg_corruption_boils = "Black Boils on %s - cleanse them!",
		trigger_corruption_euyonaliaCast = "Corruption of Loktanag begins to cast Euyonalia.",
		bar_corruption_euyonaliaCast = "AoE Disease",
		trigger_corruption_euyonalia = "You are afflicted by Euyonalia",
		msg_corruption_euyonalia = "You have Euyonalia - spreads on cleanse!",

		trigger_son_rage = "Son of Ursol gains Ancient Rage",
		msg_son_rage = "Bear Enrage - Tranq Shot!",

		trigger_trickster_siphon = "(.+) ...? afflicted by Foulheart Siphon.",
		msg_trickster_siphon = "Drain on %s - dispel them!",
	}
end)

-- timer and icon variables
local timer = {
	defiler_defiling = 12,
	ursa_command = 3,
	ursa_roar = 3,
	corruption_euyonaliaCast = 2,
}

local icon = {
	defiler_defiling = "Spell_Shadow_CreepingPlague",
	poisonCloud = "ABILITY_CREATURE_POISON_06",
	euyonalia = "Spell_Shadow_CallofBone",
	ursa_roar = "Ability_Druid_DemoralizingRoar",
}

local syncName = {
	defiler_defiling = "THDefilerDefiling" .. module.revision,
	corruption_boils = "THCorruptionBoils" .. module.revision,
	trickster_siphon = "THTricksterSiphon" .. module.revision,
	pathfinder_illumination = "THPathfinderIllumination" .. module.revision,
	ursa_command = "THUrsaCommand" .. module.revision,
	son_rage = "THSonRage" .. module.revision,
	shaman_blessing = "THShamanBlessing" .. module.revision,
	corruption_euyonaliaCast = "THCorruptionEuyonaliaCast" .. module.revision,
	ursa_roar = "THUrsaRoar" .. module.revision,
}

local guid = {
	boss = "0xF13000FE7C279933",
}

local spellId = {
	one = 30196,
}

function module:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "AfflictionEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "AfflictionEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "AfflictionEvent")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS", "EnemyBuffEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE", "EnemyBuffEvent")

	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "CastEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF", "CastEvent")

	self:ThrottleSync(1, syncName.pathfinder_illumination)
	self:ThrottleSync(1, syncName.ursa_command)
	self:ThrottleSync(1, syncName.son_rage)
	self:ThrottleSync(1, syncName.shaman_blessing)
	self:ThrottleSync(1, syncName.corruption_euyonaliaCast)
	self:ThrottleSync(1, syncName.ursa_roar)
end

function module:OnSetup()
end

function module:OnEngage()
end

function module:OnDisengage()
end

function module:AfflictionEvent(msg)
	if string.find(msg, L["trigger_defiler_cloud"]) then
		self:PoisonCloud()
		return
	elseif string.find(msg, L["trigger_defiler_cloudTick"]) then
		self:PoisonCloud()
		return
	elseif self.db.profile.corruption_euyonalia and string.find(msg, L["trigger_corruption_euyonalia"]) then
		self:Message(L["msg_corruption_euyonalia"], "Attention", true, "Alert")
		return
	end

	local _, _, player = string.find(msg, L["trigger_defiler_defiling"])
	if player then
		player = player == "You" and UnitName("player") or player
		self:Sync(syncName.defiler_defiling .. player) -- bake player into sync name to throttle per player
		return
	end

	local _, _, player = string.find(msg, L["trigger_corruption_boils"])
	if player then
		player = player == "You" and UnitName("player") or player
		self:Sync(syncName.corruption_boils .. player) -- bake player into sync name to throttle per player
		return
	end

	local _, _, player = string.find(msg, L["trigger_trickster_siphon"])
	if player then
		player = player == "You" and UnitName("player") or player
		self:Sync(syncName.trickster_siphon .. player) -- bake player into sync name to throttle per player
		return
	end
end

function module:EnemyBuffEvent(msg)
	if string.find(msg, L["trigger_pathfinder_illumination"]) then
		self:Sync(syncName.pathfinder_illumination)
		return
	elseif string.find(msg, L["trigger_ursa_command"]) then
		self:Sync(syncName.ursa_command)
		return
	elseif string.find(msg, L["trigger_son_rage"]) then
		self:Sync(syncName.son_rage)
		return
	end
	local _, _, mob = string.find(msg, L["trigger_shaman_blessing"])
	if mob then
		self:Sync(syncName.shaman_blessing .. " " .. mob)
		return
	end
	local _, _, pet = string.find(msg, L["trigger_defiler_defiling"])
	if pet then
		self:Sync(syncName.defiler_defiling .. pet) -- bake pet into sync name to throttle per pet
		return
	end
end

function module:CastEvent(msg)
	if string.find(msg, L["trigger_corruption_euyonaliaCast"]) then
		self:Sync(syncName.corruption_euyonaliaCast)
		return
	elseif string.find(msg, L["trigger_ursa_roar"]) then
		self:Sync(syncName.ursa_roar)
		return
	end
end

function module:BigWigs_RecvSync(sync, rest, nick)
	local _, _, player = string.find(sync, syncName.defiler_defiling .. "(.+)")
	if player then
		self:WitheredDefiling(player)
		return
	end
	local _, _, player = string.find(sync, syncName.corruption_boils .. "(.+)")
	if player and self.db.profile.corruption_boils then
		self:Message(string.format(L["msg_corruption_boils"],player), "Attention")
		return
	end
	local _, _, player = string.find(sync, syncName.trickster_siphon .. "(.+)")
	if player and self.db.profile.trickster_siphon then
		self:Message(string.format(L["msg_trickster_siphon"],player), "Attention")
		return
	end

	if self.db.profile.pathfinder_illumination and sync == syncName.pathfinder_illumination then
		self:Message(L["msg_pathfinder_illumination"], "Urgent")
		return
	elseif self.db.profile.ursa_command and sync == syncName.ursa_command then
		self:Message(L["msg_ursa_command"], "Attention")
		return
	elseif self.db.profile.son_rage and sync == syncName.son_rage then
		self:Message(L["msg_son_rage"], "Urgent")
		return
	elseif self.db.profile.shaman_blessing and sync == syncName.shaman_blessing and rest then
		self:Message(string.format(L["msg_shaman_blessing"],rest), "Attention", nil, "Alert")
		return
	elseif self.db.profile.corruption_euyonalia and sync == syncName.corruption_euyonaliaCast then
		self:Bar(L["bar_corruption_euyonaliaCast"], timer.corruption_euyonaliaCast, icon.euyonalia, true, "Yellow")
		self:Sound("Beware")
		return
	elseif self.db.profile.ursa_roar and sync == syncName.ursa_roar then
		self:Bar(L["bar_ursa_roar"], timer.ursa_roar, icon.ursa_roar, true, "Cyan")
		self:Sound("Alarm")
		return
	end
end

function module:PoisonCloud()
	if not self.db.profile.defiler_cloud then return end

	self:WarningSign(icon.poisonCloud, 1, false, L["warn_defiler_cloud"])
	self:Sound("Info")
end

function module:WitheredDefiling(player)
	if player == UnitName("player") and self.db.profile.defiler_defiling then
		self:Message(L["msg_defiler_defiling"], "Important", true, "RunAway")
		self:Bar(L["bar_defiler_defiling"], timer.defiler_defiling, icon.defiler_defiling, true, "Red")
		SendChatMessage(L["say_defiler_defiling"], "SAY")
	elseif self.db.profile.defiler_defilingother then
		self:Message(string.format(L["msg_defiler_defilingOther"],player), "Urgent")
	end
	if self.db.profile.defiler_defilingmark then
		local markToUse = self:GetAvailableRaidMark()
		if markToUse then
			self:SetRaidTargetForPlayer(player, markToUse)
			self:ScheduleEvent("RemoveDefilingMark"..player, self.RestoreInitialRaidTargetForPlayer, timer.defiler_defiling, self, player)
		end
	end
end

function module:Test()
	self:Engage()

	-- test characters
	local player = UnitName("player")
	local raid1 = UnitName("raid1") or "Raid1"
	local raid2 = UnitName("raid2") or "Raid2"

	local events = {
		-- Pathfinders
		{ time = 2, func = function()
			local msg = "Withermaw Pathfinder is afflicted by Cauterizing Illumination."
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE", msg)
		end },

		-- Shamans
		{ time = 5, func = function()
			local msg = "Withermaw Shaman gains Withermaw Blessing."
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS", msg)
		end },

		-- Defilers
		{ time = 8, func = function()
			local msg = "You are afflicted by Withered Defiling."
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", msg)
		end },
		{ time = 14, func = function()
			local msg = raid1.." is afflicted by Withered Defiling."
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", msg)
		end },
		{ time = 14, func = function()
			local msg = "Pet is afflicted by Withered Defiling."
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE", msg)
		end },
		{ time = 14, func = function()
			local msg = raid2.." is afflicted by Withered Defiling."
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", msg)
		end },

		{ time = 18, func = function()
			local msg = "You are afflicted by Poison Cloud."
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", msg)
		end },
		{ time = 19, func = function()
			local msg = "You suffer 432 Nature damage from Withermaw Defiler's Poison Cloud."
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", msg)
		end },

		-- Ursas
		{ time = 22, func = function()
			local msg = "Withermaw Ursa gains Ursol's Command."
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS", msg)
		end },
		{ time = 25, func = function()
			local msg = "Withermaw Ursa begins to perform Roar of the Ursa."
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", msg)
		end },

		-- Ursas
		{ time = 28, func = function()
			local msg = raid2.." is afflicted by Black Boils."
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", msg)
		end },
		{ time = 30, func = function()
			local msg = "You are afflicted by Black Boils."
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", msg)
		end },
		{ time = 32, func = function()
			local msg = "Corruption of Loktanag begins to cast Euyonalia."
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", msg)
		end },
		{ time = 34, func = function()
			local msg = "You are afflicted by Euyonalia."
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", msg)
		end },

		-- Sons
		{ time = 37, func = function()
			local msg = "Son of Ursol gains Ancient Rage."
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS", msg)
		end },

		-- Tricksters
		{ time = 37, func = function()
			local msg = raid1.." is afflicted by Foulheart Siphon."
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", msg)
		end },

		-- End of Test
		{ time = 40, func = function()
			print("Test: Disengage")
			module:Disengage()
		end },
	}

	-- Schedule each event
	for i, event in ipairs(events) do
		self:ScheduleEvent("TimbermawTrashTest" .. i, event.func, event.time)
	end

	self:Message(module.translatedName .. " test started", "Positive")
	return true
end

-- Test command: /run BigWigs:GetModule("Timbermaw Trash"):Test()
