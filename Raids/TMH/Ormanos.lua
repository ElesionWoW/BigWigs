local module, L = BigWigs:ModuleDeclaration("Ormanos the Cracked", "Timbermaw Hold")

-- module variables
module.revision = 30138
module.enabletrigger = module.translatedName
module.toggleoptions = { "crushcast", "crushzone", -1, "charge", "chargesay", "chargemark", -1, "attunement", "bosskill" }

-- module defaults
module.defaultDB = {
	crushcast = true,
	crushzone = true,
	charge = true,
	chargesay = true,
	chargemark = true,
	attunement = true,
}

-- localization
L:RegisterTranslations("enUS", function()
	return {
		cmd = "Ormanos",

		crushcast_cmd = "crushcast",
		crushcast_name = "Crush Earth cast",
		crushcast_desc = "Timer bar for a new floor zone appearing (Crush Earth)",

		crushzone_cmd = "crushzone",
		crushzone_name = "Crush Earth zone",
		crushzone_desc = "Personal alert when you stand in a floor zone (Crush Earth)",

		charge_cmd = "charge",
		charge_name = "Charge alert",
		charge_desc = "Cast bar and personal alert if you are the target of Rampaging Earth (charge)",

		chargesay_cmd = "chargesay",
		chargesay_name = "Charge say",
		chargesay_desc = "Announce a charge targeting you to /say",

		chargemark_cmd = "chargemark",
		chargemark_name = "Charge mark",
		chargemark_desc = "Mark Charge target with Triangle",

		attunement_cmd = "attunement",
		attunement_name = "Attunement indicator",
		attunement_desc = "Show the current vulnerability and immunity on screen",

		trigger_engage = "Rock and Stone...",

		trigger_crushCast = "Ormanos the Cracked begins to cast Crush Earth.",
		bar_crushCast = "New AoE Zone",
		trigger_crushZone = "You are afflicted by Crush Earth",
		trigger_crushZoneTick = "You suffer .+ Nature damage from Ormanos the Cracked's Crush Earth.",
		warn_crushZone = "MOVE",
		trigger_crushZoneFade = "Crush Earth fades from you.",

		trigger_charge = "Ormanos is preparing to charge (.+)!",
		bar_charge = "Charge on %s",
		msg_chargeSelf = "Run away and stack with others!",
		msg_chargeOther = "Stack on %s far away from the boss!",
		say_charge = "Charge on Me!",

		trigger_attunement = "Ormanos attunes to .+, becoming immune to (.+) and vulnerable to (.+)!",
		bar_attunement = "%s, no %s",
	}
end)

-- timer and icon variables
local timer = {
	crushCast = 2.5,
	crushDuration = 30,
	charge = 6,
	attunementCast = 2,
}

local icon = {
	crush = "Spell_Nature_Earthquake",
	charge = "Ability_Warrior_Charge",
	attunement = "Spell_Nature_AstralRecalGroup",
}

local syncName = {
}

local guid = {
	ormanos = "0xF13000F5D72794D4",
}

local spellId = {
}

module:RegisterYellEngage(L["trigger_engage"])

function module:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "AfflictionEvent")
	
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF", "FadesEvent")

	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "SpellEvent")
	
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
end

function module:OnSetup()
end

function module:OnEngage()
end

function module:OnDisengage()
end

function module:AfflictionEvent(msg)
	if self.db.profile.crushzone then
		if string.find(msg, L["trigger_crushZone"]) then
			self:Sound("Info")
			self:WarningSign(icon.crush, timer.crushDuration, false, L["warn_crushZone"])
			return
		elseif self.db.profile.crushzone and string.find(msg, L["trigger_crushZoneTick"]) then
			self:Sound("Info")
			return
		end
	end
end

function module:FadesEvent(msg)
	if msg == L["trigger_crushZoneFade"] then
		self:RemoveWarningSign(icon.crush)
		self:Sound("Long")
	end
end

function module:SpellEvent(msg)
	if self.db.profile.crushcast and msg == L["trigger_crushCast"] then
		self:Bar(L["bar_crushCast"], timer.crushCast * BigWigs:GetCastTimeCoefficient(guid.ormanos), icon.crush, true, "Yellow")
	end
end

function module:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	local _, _, player = string.find(msg, L["trigger_charge"])
	if player then
		self:Charge(player)
	end

	local _, _, imm, vuln = string.find(msg, L["trigger_attunement"])
	if imm and vuln then
		self:ScheduleEvent("NewAttunement", self.Attunement, timer.attunementCast * BigWigs:GetCastTimeCoefficient(guid.ormanos), self, vuln, imm)
	end
end

function module:Charge(player)
	local adjustedTimer = timer.charge * BigWigs:GetCastTimeCoefficient(guid.ormanos)

	if self.db.profile.charge then
		self:Bar(string.format(L["bar_charge"], player), adjustedTimer, icon.charge)
		if player == UnitName("player") then
			self:Message(L["msg_chargeSelf"], "Important", true, "RunAway")
		else
			self:Message(string.format(L["msg_chargeOther"],player), "Attention", nil, "Alarm")
		end
	end

	if self.db.profile.chargesay and player == UnitName("player") then
		SendChatMessage(L["say_charge"], "SAY")
	end	

	if self.db.profile.chargemark then
		self:SetRaidTargetForPlayer(player, "Triangle")
		self:ScheduleEvent("RemoveChargeMark"..player, self.RestoreInitialRaidTargetForPlayer, adjustedTimer, self, player)
	end
end

function module:Attunement(vulnerability, immunity)
	print("fired with vuln "..vulnerability.." and imm "..immunity)
	if self.db.profile.attunement then
		if not self:BarStatus("Attunement") then
			self:CounterBar("Attunement", 200, icon.attunement, nil, nil, false, "%d%%", true, "White")
		end
		self:UpdateBar("Attunement", nil, string.format(L["bar_attunement"], vulnerability, immunity))
	else
		self:RemoveBar("Attunement")
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
			local msg = "Ormanos the Cracked begins to cast Crush Earth."
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", msg)
		end },
		{ time = 4.5, func = function()
			local msg = "You are afflicted by Crush Earth."
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", msg)
		end },
		{ time = 5.5, func = function()
			local msg = "You suffer 460 Nature damage from Ormanos the Cracked's Crush Earth."
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", msg)
		end },
		{ time = 6.5, func = function()
			local msg = "You suffer 500 Nature damage from Ormanos the Cracked's Crush Earth."
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", msg)
		end },
		{ time = 6.8, func = function()
			local msg = "Crush Earth fades from you."
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_SPELL_AURA_GONE_SELF", msg)
		end },

		-- Attune 1
		{ time = 9, func = function()
			local msg = "Ormanos attunes to basalt, becoming immune to Shadow and vulnerable to Fire!"
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_RAID_BOSS_EMOTE", msg)
		end },

		-- Zone 2
		{ time = 12, func = function()
			local msg = "Ormanos the Cracked begins to cast Crush Earth."
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", msg)
		end },

		-- Attune 2
		{ time = 14, func = function()
			local msg = "Ormanos attunes to quartz, becoming immune to Nature and vulnerable to Shadow!"
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_RAID_BOSS_EMOTE", msg)
		end },

		-- Charge 1
		{ time = 18, func = function()
			local msg = "Ormanos is preparing to charge "..player.."!"
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_RAID_BOSS_EMOTE", msg)
		end },

		-- Attune 3
		{ time = 22, func = function()
			local msg = "Ormanos attunes to slate, becoming immune to Fire and vulnerable to Arcane!"
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_RAID_BOSS_EMOTE", msg)
		end },

		-- Charge 2
		{ time = 26, func = function()
			local msg = "Ormanos is preparing to charge "..raid1.."!"
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_RAID_BOSS_EMOTE", msg)
		end },

		-- End of Test
		{ time = 34, func = function()
			print("Test: Disengage")
			module:Disengage()
		end },
	}

	-- Schedule each event
	for i, event in ipairs(events) do
		self:ScheduleEvent("OrmanosTest" .. i, event.func, event.time)
	end

	self:Message(module.translatedName .. " test started", "Positive")
	return true
end

-- Test command: /run BigWigs:GetModule("Ormanos the Cracked"):Test()
