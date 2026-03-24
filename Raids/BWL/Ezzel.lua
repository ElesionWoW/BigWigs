local module, L = BigWigs:ModuleDeclaration("Ezzel Darkbrewer", "Blackwing Lair")

-- module variables
module.revision = 30138
module.enabletrigger = module.translatedName
module.toggleoptions = { "charge", "chargemark", "acid", "transmute", "bosskill" }

-- module defaults
module.defaultDB = {
	charge = true,
	chargemark = true,
	acid = true,
	transmute = true,
}

-- localization
L:RegisterTranslations("enUS", function()
	return {
		cmd = "EzzelDarkbrewer",

		charge_cmd = "charge",
		charge_name = "Charge Alert",
		charge_desc = "Alerts about incoming Charges",

		chargemark_cmd = "chargemark",
		chargemark_name = "Charge Mark",
		chargemark_desc = "Mark Charge victims with Triangle",

		acid_cmd = "acid",
		acid_name = "Acid Alert",
		acid_desc = "Warns when you are standing in Acid",

		transmute_cmd = "transmute",
		transmute_name = "Transmute to Gold Alert",
		transmute_desc = "Warns when the boss begins to cast Transmute to Gold (wipe mechanic)",

		trigger_charge = "Raka begins charging (.+)!",
		bar_charge = "Charge on %s",
		say_charge = "Charge On Me!",
		warn_charge = "HIDE",

		trigger_acid = "You suffer (.+) damage from Ezzel Darkbrewer's Acid Bomb",
		warn_acid = "ACID - MOVE",

		trigger_transmute = "Ezzel Darkbrewer begins to cast Transmute to Gold",
		bar_transmute = "Kill Boss",
	}
end)

-- timer and icon variables
local timer = {
	charge = 8,
	transmute = 8,
}

local icon = {
	charge = "ABILITY_MOUNT_MOUNTAINRAM",
	acid = "ABILITY_CREATURE_POISON_06",
	transmute = "SPELL_HOLY_HARMUNDEADAURA",
}

local syncName = {
	charge = "EzzelCharge" .. module.revision,
	transmute = "EzzelTransmute" .. module.revision,
}

local guid = {
	ezzel = "0xF13000FE7C279933",
}

function module:OnEnable()
	--self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "AfflictionEvent")
	--self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "AfflictionEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "AfflictionEvent")

	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "CastEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF", "CastEvent")
	
	--self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")

	self:ThrottleSync(3, syncName.charge)
	self:ThrottleSync(3, syncName.transmute)
end

function module:OnSetup()
end

function module:OnEngage()	
	-- Start health monitoring
	--self:ScheduleRepeatingEvent("CheckBossHealth", self.CheckBossHealth, 0.5, self)
end

function module:OnDisengage()
end

function module:AfflictionEvent(msg)
	if self.db.profile.acid and string.find(msg, L["trigger_acid"]) then
		self:Sound("Info")
		self:WarningSign(icon.acid, 1, false, L["warn_acid"])
	end
end

function module:CastEvent(msg)
	if string.find(msg, L["trigger_transmute"]) then
		self:Sync(syncName.transmute)
	end
end

function module:CHAT_MSG_MONSTER_YELL(msg)
end

function module:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	local _, _, player = string.find(msg, L["trigger_charge"])
	if player then
		self:Sync(syncName.charge .. " " .. player)
	end
end

function module:BigWigs_RecvSync(sync, rest, nick)
	if sync == syncName.transmute then
		self:TransmuteToGold()
	elseif sync == syncName.charge and rest then
		self:Charge(rest)
	end
end

function module:TransmuteToGold()
	if not self.db.profile.transmute then return end

	self:Bar(L["bar_transmute"], timer.transmute * BigWigs:GetCastTimeCoefficient(guid.ezzel), icon.transmute)
	self:Sound("Beware")
end

function module:Charge(player)
	if self.db.profile.charge then
		self:Bar(string.format(L["bar_charge"],player), timer.charge, icon.charge)
		if player == UnitName("player") then
			self:WarningSign(icon.charge, 4, true, L["warn_charge"])
			self:Sound("RunAway")
			SendChatMessage(L["say_charge"], "SAY")
		else
			self:Sound("Alarm")
		end
	end

	if self.db.profile.chargemark then
		self:SetRaidTargetForPlayer(player, "Triangle")
		self:ScheduleEvent("RemoveChargeMark", self.RestoreInitialRaidTargetForPlayer, 8, self, player)
	end
end

function module:Test()
	self:Engage()
	
	-- test characters
	local player = UnitName("player")
	local raid1 = UnitName("raid1") or "Raid1"
	local raid2 = UnitName("raid2") or "Raid2"
	
	local events = {
		-- Acid
		{ time = 2, func = function()
			local msg = "You suffer 450 Nature damage from Ezzel Darkbrewer's Acid Bomb."
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", msg)
		end },
		{ time = 3, func = function()
			local msg = "You suffer 0 Nature damage from Ezzel Darkbrewer's Acid Bomb. (405 absorbed)"
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", msg)
		end },

		-- Charge
		{ time = 8, func = function()
			local msg = "Ton'Raka begins charging "..raid1.."!"
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_RAID_BOSS_EMOTE", msg)
		end },		
		{ time = 18, func = function()
			local msg = "Ton'Raka begins charging "..player.."!"
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_RAID_BOSS_EMOTE", msg)
		end },

		-- Transmute
		{ time = 28, func = function()
			local msg = "Ezzel Darkbrewer begins to cast Transmute to Gold."
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", msg)
		end },

		-- End of Test
		{ time = 38, func = function()
			print("Test: Disengage")
			module:Disengage()
		end },
	}
	
	-- Schedule each event
	for i, event in ipairs(events) do
		self:ScheduleEvent("EzzelTest" .. i, event.func, event.time)
	end

	self:Message(module.translatedName .. " test started", "Positive")
	return true
end

-- Test command: /run BigWigs:GetModule("Ezzel Darkbrewer"):Test()
