local module, L = BigWigs:ModuleDeclaration("Loktanag the Vile", "Timbermaw Hold")

-- module variables
module.revision = 30138
module.enabletrigger = module.translatedName
module.toggleoptions = { "secretionhit", "secretionsay", "secretionmark", "secretioncd", "secretionzone", "bosskill" }

-- module defaults
module.defaultDB = {
	secretionhit = true,
	secretionsay = true,
	secretionmark = true,
	secretioncd = true,
	secretionzone = true,
}

-- localization
L:RegisterTranslations("enUS", function()
	return {
		cmd = "Loktanag",

		secretionhit_cmd = "secretionhit",
		secretionhit_name = "Infected Secretion hit warning",
		secretionhit_desc = "Warning message about the target of Infected Secretion (spawns adds and a damage zone on the floor)",

		secretionsay_cmd = "secretionsay",
		secretionsay_name = "Infected Secretion hit say",
		secretionsay_desc = "Announce to /say if Infected Secretion targeted you (spawns adds and a damage zone on the floor on your location)",

		secretionmark_cmd = "secretionmark",
		secretionmark_name = "Infected Secretion hit mark",
		secretionmark_desc = "Mark the target of Infected Secretion with Square",

		secretioncd_cmd = "secretioncd",
		secretioncd_name = "Infected Secretion cd bar",
		secretioncd_desc = "Cooldown bar for Infected Secretion",

		secretionzone_cmd = "secretionzone",
		secretionzone_name = "Infected Secretion zone",
		secretionzone_desc = "Personal warning when you stand in Infected Secretion",

		trigger_secretionHit = "Loktanag the Vile's Infected Secretion hits (.+) for ",
		msg_secretionHit = "Adds and Zone on %s",
		say_secretionHit = "Adds and Zone on Me!",
		bar_secretionCd = "next Secretion",
		trigger_secretionZone = "You are afflicted by Infected Secretion",
		trigger_secretionZoneTick = "You suffer .+ Nature damage from Loktanag the Vile's Infected Secretion",
		warn_secretionZone = "MOVE",
		trigger_secretionZoneFade = "Infected Secretion fades from you.",
	}
end)

-- timer and icon variables
local timer = {
	secretion = 30,
	secretionCd = {12, 14},
	secretionMarkDuration = 4,
}

local icon = {
	secretion = "Spell_Nature_NullifyDisease",
}

local syncName = {
	secretionHit = "THLoktanagSecretionHit" .. module.revision,
}

local guid = {
	loktanag = "0xF13000085B279753",
}

local spellId = {
}

function module:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "AfflictionEvent")
	
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF", "FadesEvent")

	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE", "SpellEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE", "SpellEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "SpellEvent")

	self:ThrottleSync(3, syncName.secretionHit)
end

function module:OnSetup()
end

function module:OnEngage()
end

function module:OnDisengage()
end

function module:AfflictionEvent(msg)
	if self.db.profile.secretionzone then
		if string.find(msg, L["trigger_secretionZone"]) then
			self:Sound("Info")
			self:WarningSign(icon.secretion, timer.secretion, false, L["warn_secretionZone"])
			return
		elseif string.find(msg, L["trigger_secretionZoneTick"]) then
			self:Sound("Info")
			return
		end
	end
end

function module:FadesEvent(msg)
	if self.db.profile.secretionzone and msg == L["trigger_secretionZoneFade"] then
		self:RemoveWarningSign(icon.secretion)
		self:Sound("Long")
	end
end

function module:SpellEvent(msg)
	local _, _, player = string.find(msg, L["trigger_secretionHit"])
	if player then
		player = player == "you" and UnitName("player") or player
		self:Sync(syncName.secretionHit .. " " .. player) 
		return
	end
end

function module:BigWigs_RecvSync(sync, rest, nick)
	if sync == syncName.secretionHit and rest then
		self:InfectedSecretionHit(rest)
	end
end

function module:InfectedSecretionHit(player)
	self:RemoveBar(L["bar_secretionCd"])

	if self.db.profile.secretionhit then
		self:Message(string.format(L["msg_secretionHit"],player), "Urgent")
	end

	if self.db.profile.secretionsay and player == UnitName("player") then
		SendChatMessage(L["say_secretionHit"], "SAY")
	end

	if self.db.profile.secretionmark then
		self:SetRaidTargetForPlayer(player, "Square")
		self:ScheduleEvent("RemoveSecretionMark"..player, self.RestoreInitialRaidTargetForPlayer, timer.secretionMarkDuration, self, player)
	end

	if self.db.profile.secretioncd then
		self:IntervalBar(L["bar_secretionCd"], timer.secretionCd[1], timer.secretionCd[2], icon.secretion)
	end
end

function module:Test()
	self:Engage()

	-- test characters
	local player = UnitName("player")
	local raid1 = UnitName("raid1") or "Raid1"
	local raid2 = UnitName("raid2") or "Raid2"

	local events = {
		-- Hit 1
		{ time = 2, func = function()
			local msg = "Loktanag the Vile's Infected Secretion hits you for 1352 Nature damage."
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE", msg)
		end },
		{ time = 2, func = function()
			local msg = "You are afflicted by Infected Secretion."
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", msg)
		end },
		{ time = 3, func = function()
			local msg = "You suffer 450 Nature damage from Loktanag the Vile's Infected Secretion."
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", msg)
		end },
		{ time = 4, func = function()
			local msg = "You suffer 481 Nature damage from Loktanag the Vile's Infected Secretion."
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", msg)
		end },
		{ time = 4.8, func = function()
			local msg = "Infected Secretion fades from you."
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_SPELL_AURA_GONE_SELF", msg)
		end },

		-- Hit 2
		{ time = 15, func = function()
			local msg = "Loktanag the Vile's Infected Secretion hits "..raid2.." for 1139 Nature damage."
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE", msg)
		end },
		{ time = 15, func = function()
			local msg = "You are afflicted by Infected Secretion."
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", msg)
		end },
		{ time = 16, func = function()
			local msg = "You suffer 500 Nature damage from Loktanag the Vile's Infected Secretion."
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", msg)
		end },
		{ time = 16.2, func = function()
			local msg = "Infected Secretion fades from you."
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_SPELL_AURA_GONE_SELF", msg)
		end },

		-- Stepping back into the zone
		{ time = 19, func = function()
			local msg = "You are afflicted by Infected Secretion."
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", msg)
		end },
		{ time = 19.3, func = function()
			local msg = "You suffer 450 Nature damage from Loktanag the Vile's Infected Secretion."
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", msg)
		end },
		{ time = 20, func = function()
			local msg = "Infected Secretion fades from you."
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_SPELL_AURA_GONE_SELF", msg)
		end },

		-- End of Test
		{ time = 32, func = function()
			print("Test: Disengage")
			module:Disengage()
		end },
	}

	-- Schedule each event
	for i, event in ipairs(events) do
		self:ScheduleEvent("LoktanagTest" .. i, event.func, event.time)
	end

	self:Message(module.translatedName .. " test started", "Positive")
	return true
end

-- Test command: /run BigWigs:GetModule("Loktanag the Vile"):Test()
