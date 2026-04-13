local module, L = BigWigs:ModuleDeclaration("Rotgrowl", "Timbermaw Hold")

-- module variables
module.revision = 30138
module.enabletrigger = module.translatedName
module.toggleoptions = { "volleyzone", -1, "arrow", "arrowsay", "arrowmark", -1, "fear", "frenzy", "killcommand", "killcommandmark", "revive", "bosskill" }

local _, playerClass = UnitClass("player")

-- module defaults
module.defaultDB = {
	volleyzone = true,
	arrow = true,
	arrowsay = true,
	arrowmark = true,
	fear = true,
	frenzy = playerClass == "HUNTER",
	killcommand = true,
	killcommandmark = true,
	revive = true,
}

-- localization
L:RegisterTranslations("enUS", function()
	return {
		cmd = "Rotgrowl",

		volleyzone_cmd = "volleyzone",
		volleyzone_name = "Volley of Arrows alert",
		volleyzone_desc = "Personal alert when you stand in an aoe zone (Volley of Arrows)",

		arrow_cmd = "arrow",
		arrow_name = "Fire-Soaked Arrow alert",
		arrow_desc = "Cast bar and personal alert if you are the target of Fire-Soaked Arrow",

		arrowsay_cmd = "arrowsay",
		arrowsay_name = "Fire-Soaked Arrow say",
		arrowsay_desc = "Announce a Fire-Soaked Arrow targeting you to /say",

		arrowmark_cmd = "arrowmark",
		arrowmark_name = "Fire-Soaked Arrow mark",
		arrowmark_desc = "Mark Fire-Soaked Arrow target with Triangle",

		fear_cmd = "fear",
		fear_name = "Fearful Roar bar",
		fear_desc = "Cast bar for Kodiak's aoe fear (Fearful Roar)",

		frenzy_cmd = "frenzy",
		frenzy_name = "Rage of the Ursa alert",
		frenzy_desc = "Alert when Kodiak frenzies (Rage of the Ursa)",

		killcommand_cmd = "killcommand",
		killcommand_name = "Kill Command alert",
		killcommand_desc = "Duration bar and personal alert for Kill Command victim",

		killcommandmark_cmd = "killcommandmark",
		killcommandmark_name = "Kill Command mark",
		killcommandmark_desc = "Mark the target of Kill Command with Square",

		revive_cmd = "revive",
		revive_name = "Revive bar",
		revive_desc = "Bar for the vulnerability phase until Kodiak returns",

		trigger_engage = "Destroy them Kodiak, show them no mercy!",

		bar_volleyCast = "New AoE Zone",
		trigger_volleyZone = "You are afflicted by Volley of Arrows",
		trigger_volleyZoneTick = "You suffer .+ Physical damage from Rotgrowl's Volley of Arrows.",
		warn_volleyZone = "MOVE",
		trigger_volleyZoneFade = "Volley of Arrows fades from you.",

		trigger_arrow = "aims a flaming bolt at (.+)!",
		bar_arrow = "Arrow on %s",
		msg_arrowSelf = "Stack with others!",
		msg_arrowOther = "Stack on %s to soak the Arrow!",
		say_arrow = "Arrow on Me!",

		trigger_fear = "bellows a deep roar",
		bar_fear = "Incoming Fear",

		trigger_frenzy = "Kodiak gains Rage of the Ursa",
		msg_frenzy = "Kodiak Rage - use Tranq Shot!",

		trigger_killcommand = "commands Kodiak to kill (.+)!",
		bar_killcommand = "Bear chasing %s",

		trigger_revive = "Live and fight once more, you shall not fall.",
		bar_revive = "Bear Revives",
	}
end)

-- timer and icon variables
local timer = {
	volleyDuration = 10,
	arrow = 5,
	fearCast = 4,
	killcommand = 10,
	revive = 25,
}

local icon = {
	volley = "Ability_Marksmanship",
	arrow = "Spell_Fire_Fireball02",
	fear = "Spell_Shadow_PsychicScream",
	killcommand = "Spell_Nature_Reincarnation",
	revive = "Spell_Holy_Resurrection",
}

local syncName = {
	frenzy = "THRotgrowlFrenzy" .. module.revision,
}

local guid = {
	rotgrowl = "0xF13000F5D8279798",
	kodiak = "0xF13000F5D927A7BF",
}

local spellId = {
}

module:RegisterYellEngage(L["trigger_engage"])

function module:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "AfflictionEvent")

	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF", "FadesEvent")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS", "EnemyBuffEvent")

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")

	self:ThrottleSync(3, syncName.frenzy)
end

function module:OnSetup()
end

function module:OnEngage()
end

function module:OnDisengage()
end

function module:AfflictionEvent(msg)
	if self.db.profile.volleyzone then
		if string.find(msg, L["trigger_volleyZone"]) then
			self:Sound("Info")
			self:WarningSign(icon.volley, timer.volleyDuration, false, L["warn_volleyZone"])
			return
		elseif self.db.profile.volleyzone and string.find(msg, L["trigger_volleyZoneTick"]) then
			self:Sound("Info")
			return
		end
	end
end

function module:FadesEvent(msg)
	if msg == L["trigger_volleyZoneFade"] then
		self:RemoveWarningSign(icon.volley)
		self:Sound("Long")
	end
end

function module:EnemyBuffEvent(msg)
	if string.find(msg, L["trigger_frenzy"]) then
		self:Sync(syncName.frenzy)
	end
end

function module:CHAT_MSG_MONSTER_YELL(msg)
	if self.db.profile.revive and string.find(msg, L["trigger_revive"]) then
		self:Bar(L["bar_revive"], timer.revive, icon.revive, true, "Cyan")
	end
end

function module:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	local _, _, player = string.find(msg, L["trigger_arrow"])
	if player then
		self:Arrow(player)
	end

	local _, _, player = string.find(msg, L["trigger_killcommand"])
	if player then
		self:KillCommand(player)
	end
end

function module:CHAT_MSG_MONSTER_EMOTE(msg)
	if self.db.profile.fear and string.find(msg, L["trigger_fear"]) then
		self:Bar(L["bar_fear"], timer.fearCast, icon.fear)
	end
end

function module:BigWigs_RecvSync(sync, rest, nick)
	if self.db.profile.frenzy and sync == syncName.frenzy then
		self:Message(L["msg_frenzy"], "Urgent")
	end
end

function module:Arrow(player)
	if self.db.profile.arrow then
		self:Bar(string.format(L["bar_arrow"], player), timer.arrow, icon.arrow)
		if player == UnitName("player") then
			self:Message(L["msg_arrowSelf"], "Important", true, "RunAway")
		else
			self:Message(string.format(L["msg_arrowOther"],player), "Attention", nil, "Alarm")
		end
	end

	if self.db.profile.arrowsay and player == UnitName("player") then
		SendChatMessage(L["say_arrow"], "SAY")
	end	

	if self.db.profile.arrowmark then
		self:SetRaidTargetForPlayer(player, "Triangle")
		self:ScheduleEvent("RemoveArrowMark"..player, self.RestoreInitialRaidTargetForPlayer, timer.arrow, self, player)
	end
end

function module:KillCommand(player)
	if self.db.profile.killcommand then
		self:Bar(string.format(L["bar_killcommand"], player), timer.killcommand, icon.killcommand, true, "Blue")
		if player == UnitName("player") then
			self:Sound("RunAway")
		else
			self:Sound("Alert")
		end
	end

	if self.db.profile.killcommandmark then
		self:SetRaidTargetForPlayer(player, "Square")
		self:ScheduleEvent("RemoveKillCommandMark"..player, self.RestoreInitialRaidTargetForPlayer, timer.killcommand, self, player)
	end
end

function module:Test()
	self:Engage()

	-- test characters
	local player = UnitName("player")
	local raid1 = UnitName("raid1") or "Raid1"
	local raid2 = UnitName("raid2") or "Raid2"

	local events = {
		-- Zone 1
		{ time = 2, func = function()
			local msg = "You are afflicted by Volley of Arrows."
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", msg)
		end },
		{ time = 3, func = function()
			local msg = "You suffer 460 Physical damage from Rotgrowl's Volley of Arrows."
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", msg)
		end },
		{ time = 4, func = function()
			local msg = "You suffer 500 Physcial damage from Rotgrowl's Volley of Arrows."
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", msg)
		end },
		{ time = 4.3, func = function()
			local msg = "Volley of Arrows fades from you."
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_SPELL_AURA_GONE_SELF", msg)
		end },

		-- Kill Command 1
		{ time = 8, func = function()
			local msg = "%s commands Kodiak to kill "..player.."!"
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_RAID_BOSS_EMOTE", msg, "Rotgrowl")
		end },

		-- Bear Death
		{ time = 12, func = function()
			local msg = "Live and fight once more, you shall not fall."
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_MONSTER_YELL", msg, "Rotgrowl")
		end },

		-- Arrow 1
		{ time = 18, func = function()
			local msg = "%s aims a flaming bolt at "..player.."!"
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_RAID_BOSS_EMOTE", msg, "Rotgrowl")
		end },

		-- Kill Command 1
		{ time = 22, func = function()
			local msg = "%s commands Kodiak to kill "..raid1.."!"
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_RAID_BOSS_EMOTE", msg, "Rotgrowl")
		end },

		-- Arrow 2
		{ time = 26, func = function()
			local msg = "%s aims a flaming bolt at "..raid1.."!"
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_RAID_BOSS_EMOTE", msg, "Rotgrowl")
		end },

		-- Fear
		{ time = 30, func = function()
			local msg = "%s bellows a deep roar…"
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_MONSTER_EMOTE", msg, "Kodiak")
		end },

		-- Fear
		{ time = 37, func = function()
			local msg = "Kodiak gains Rage of the Ursa."
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS", msg)
		end },

		-- End of Test
		{ time = 42, func = function()
			print("Test: Disengage")
			module:Disengage()
		end },
	}

	-- Schedule each event
	for i, event in ipairs(events) do
		self:ScheduleEvent("RotgrowlTest" .. i, event.func, event.time)
	end

	self:Message(module.translatedName .. " test started", "Positive")
	return true
end

-- Test command: /run BigWigs:GetModule("Rotgrowl"):Test()
